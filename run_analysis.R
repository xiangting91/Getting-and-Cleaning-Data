## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Download the file and put the file in the Working Directory
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(Url,destfile="./Dataset.zip")
unzip(zipfile="./Dataset.zip")
path_rf <- file.path("./" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)

##Read activity, subject and features files
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

## 1. Merges the training and the test sets to create one data set.

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

## set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")

features <- read.table("./UCI HAR Dataset/features.txt")[,2]
names(dataFeatures)<- features

##Combine columns of Activity, Subject and Data
dataSA <- cbind(dataSubject, dataActivity)
dataFSA <- cbind(dataFeatures, dataSA)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features.rows <- grep("mean\\(\\)|std\\(\\)", features)
data <- dataFSA[,c(features.rows,562,563)]

## 3. Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
data$activity <- factor(data$activity, label = activity_labels)

## 4. Appropriately labels the data set with descriptive activity names.
        ##t is replaced by time
        ##Acc is replaced by Accelerometer
        ##Gyro is replaced by Gyroscope
        ##f is replaced by frequency
        ##Mag is replaced by Magnitude
        ##BodyBody is replaced by Body

names(data)<-gsub("^t", "Time", names(data))
names(data)<-gsub("^f", "Frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
data2<-aggregate(. ~subject + activity, data, mean)
data2<-data2[order(data2$subject,data2$activity),]
write.table(data2, file = "tidydata.txt",row.name=FALSE)

