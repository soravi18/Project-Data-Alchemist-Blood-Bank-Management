




--------------------------------------------------------->
--------------------------------------------------------->
--Team: Blood Bank Database Management System
--Course: IST 659
--Professor: Vincent Michael Plaza
--Members:

--		Himanshu Hedge
--		Soundarya Ravi
--		Subhiksha Murugesan
--		Rishi Manohar
--		Nagul Pandian


 ------Contents:
 ------    1) Delete Foreign Keys
 ------    2) Drop Tables
 ------    3) Create Tables
 ------    4) Add CONSTRAINTS
 ------    5) Add Triggers
 ------    6) Insert Operations
 ------    5) Stored Procedures
 ------    6) Views



--------------------------------------------------------->
--------------------------------------------------------->


-- Create Database
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'BloodBankDatabase')
BEGIN
CREATE DATABASE BloodBankDatabase
END
GO


-- Use DB
use BloodBankDatabase
go


-- DOWN SCRIPT
----------------------------------------------------------------------------------------------> Foreign Key Deletion
--- Views

-- Batch script for dropping views
IF OBJECT_ID('vw_blood_donation_drive_details', 'V') IS NOT NULL
    DROP VIEW vw_blood_donation_drive_details;
GO
    
IF OBJECT_ID('vw_blood_requests_from_hospitals', 'V') IS NOT NULL
    DROP VIEW vw_blood_requests_from_hospitals;
GO

-- Stored Procedure to delete foreign keys
drop procedure if exists delete_foreign_keys
go

create procedure delete_foreign_keys (@fkey_name nvarchar(30),@table_name nvarchar(30))
as
begin
if exists(select * from sys.foreign_keys where name = @fkey_name)
    begin
    DECLARE @sql NVARCHAR(MAX);
    SELECT @sql = 'ALTER TABLE ' + @table_name + ' DROP CONSTRAINT ' + @fkey_name;
    print @sql;
    -- Execute the dynamic SQL statement
    EXEC sp_executesql @sql;
    end
else 
    begin 
    print 'No Foreign Key to Delete'
    end
end
go

--select * from sys.foreign_keys
--select * from sys.foreign_keys where name = 'fk_blood_donation_drive_donor_id'
--select * from sys.tables

-- Drop Foreign Keys
-- exec delete_foreign_keys @table_name = 'dim_blood_collection', @fkey_name = 'fk_dim_blood_collection_donor_id'
-- go
--exec delete_foreign_keys @table_name = 'dim_blood_donation_drive', @fkey_name = 'fk_blood_donation_drive_donor_id'
--go


if exists(select * from sys.foreign_keys where name = 'fk_dim_blood_collection_donor_id')
BEGIN
alter table dim_blood_collection drop constraint fk_dim_blood_collection_donor_id
alter table dim_blood_collection drop constraint fk_dim_blood_collection_camp_id
END
ELSE
BEGIN
print 'Nothing'
END
go

if exists(select * from sys.foreign_keys where name = 'fk_blood_donation_drive_donor_id')
BEGIN
alter table dim_blood_donation_drive drop constraint fk_blood_donation_drive_donor_id
END
ELSE
BEGIN
print 'Nothing'
END
go

if exists(select * from sys.foreign_keys where name = 'fk_fact_blood_donation_drive_camp_id')
BEGIN
alter table fact_blood_donation_drive drop constraint fk_fact_blood_donation_drive_camp_id;
alter table fact_blood_donation_drive drop constraint fk_fact_blood_donation_drive_donor_id;
alter table fact_blood_donation_drive drop constraint fk_fact_blood_donation_drive_staff_id;
alter table fact_blood_donation_drive drop constraint fk_fact_blood_donation_drive_inventory_id;
alter table fact_blood_donation_drive drop constraint fk_fact_blood_donation_drive_bag_id;
END
ELSE
BEGIN
print 'Nothing'
END
go

if exists(select * from sys.foreign_keys where name = 'fk_blood_pre_process_storage_inventory_id')
BEGIN
alter table fact_blood_pre_process_storage drop constraint fk_blood_pre_process_storage_inventory_id;
alter table fact_blood_pre_process_storage drop constraint fk_blood_pre_process_storage_donor_id;
alter table fact_blood_pre_process_storage drop constraint fk_blood_pre_process_storage_bag_id;
END
ELSE
BEGIN
print 'Nothing'
END
go
if exists(select * from sys.foreign_keys where name = 'fk_processing_disease_test_inventory_id')
BEGIN
alter table fact_processing_disease_test drop constraint fk_processing_disease_test_inventory_id;
alter table fact_processing_disease_test drop constraint fk_processing_disease_test_donor_id;
alter table fact_processing_disease_test drop constraint fk_processing_disease_test_blood_id;
END
ELSE
BEGIN
print 'Nothing'
END
go
if exists(select * from sys.foreign_keys where name = 'fk_processing_centrifuge_inventory_id')
BEGIN
alter table fact_processing_centrifuge drop constraint fk_processing_centrifuge_inventory_id;
alter table fact_processing_centrifuge drop constraint fk_processing_centrifuge_donor_id;
alter table fact_processing_centrifuge drop constraint fk_processing_centrifuge_bag_id;
alter table fact_processing_centrifuge drop constraint fk_processing_centrifuge_component_id;
END
ELSE
BEGIN
print 'Nothing'
END
go


if exists(select * from sys.foreign_keys where name = 'fk_storage_inventory_inventory_id')
BEGIN
alter table fact_storage_inventory drop constraint fk_storage_inventory_inventory_id;
alter table fact_storage_inventory drop constraint fk_storage_inventory_bag_id;
alter table fact_storage_inventory drop constraint fk_storage_inventory_component_id;
END
ELSE
BEGIN
print 'Nothing'
END
go
if exists(select * from sys.foreign_keys where name = 'fk_blood_requests_hospital_id')
BEGIN
	begin try	
		alter table fact_blood_requests drop constraint fk_blood_requests_hospital_id;
		alter table fact_blood_requests drop constraint fk_blood_requests_hospital_staff_id;
	end try
	begin catch
		print 'Drop DB and Re Run Code from Scratch - fact_blood_requests'
		SELECT ERROR_MESSAGE() AS ErrorMessage;
	end catch
END
ELSE
BEGIN
print 'Nothing'
END
go

if exists(select * from sys.foreign_keys where name = 'fk_hospital_requests_hospital_id')
BEGIN
	begin try
		alter table fact_hospital_requests drop constraint fk_hospital_requests_hospital_id;
		alter table fact_hospital_requests drop constraint fk_hospital_requests_patient_id;
		alter table fact_hospital_requests drop constraint fk_hospital_requests_hospital_staff_id;
	end try
	begin catch
		print 'Drop DB and Re Run Code from Scratch - fact_hospital_requests';
		SELECT ERROR_MESSAGE() AS ErrorMessage;
	end catch
END
ELSE
BEGIN
print 'Nothing'
END
go
if exists(select * from sys.foreign_keys where name = 'fk_patient_to_hospital_hospital_id')
BEGIN
alter table fact_patient_to_hospital drop constraint fk_patient_to_hospital_hospital_id;
alter table fact_patient_to_hospital drop constraint fk_patient_to_hospital_patient_id;

END
ELSE
BEGIN
print 'Nothing'
END
go

---------------------------------------------------------------------------------------> Drop Tables
drop table if exists dim_donor
go

drop table if exists dim_hospital 
go 

drop table if exists dim_blood_collection
go

drop table if exists dim_blood_donation_drive
go

drop table if exists dim_recipient
go

drop table if exists dim_camp
go

drop table if exists dim_staff
go

drop table if exists dim_blood_disease
go

drop table if exists dim_inventory
go

drop table if exists dim_component
go

drop table if exists dim_hospital_staff_details
go

drop table if exists fact_blood_donation_drive
go

drop table if exists fact_blood_pre_process_storage
go
drop table if exists fact_processing_disease_test
go
drop table if exists fact_processing_centrifuge
GO
drop table if exists fact_storage_inventory
GO
drop table if exists fact_blood_requests
GO
drop table if exists fact_hospital_requests
GO
drop table if exists fact_patient_to_hospital
GO


------------------------------------------------------------------------------------------------> Create Table
CREATE TABLE dim_donor (
    donor_id INT not null,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender CHAR(1),
    blood_type VARCHAR(5),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(255),
    last_donation_date DATE,
    constraint pk_donor_donor_id PRIMARY KEY(donor_id)
)
go



--select OBJECT_ID('dim_blood_donation_drive') as 'obj'

CREATE TABLE dim_hospital (
    hospital_id INT not null,
    hospital_name VARCHAR(100),
    hospital_location VARCHAR(255),
    hospital_location_state VARCHAR(255),
    contact_number VARCHAR(15),
    constraint pk_hospital_hospital_id PRIMARY KEY(hospital_id)
)
go

CREATE TABLE dim_camp (
    camp_id INT ,
    camp_location VARCHAR(255),
    camp_location_state VARCHAR(255),
    camp_name VARCHAR(255),
    camp_date DATE
    constraint pk_camp_camp_id primary key (camp_id)
)
go

CREATE TABLE dim_blood_collection (
    bag_id INT not null,
    donor_id INT,
    donor_name VARCHAR(100),
    blood_type VARCHAR(5),
    expiration_date DATE,
    blood_status VARCHAR(20),
    unit_collected_date DATE,
    camp_id INT,
    staff_id INT,
    constraint pk_dim_blood_collection_bag_id PRIMARY KEY(bag_id),
    constraint fk_dim_blood_collection_donor_id FOREIGN KEY(donor_id) REFERENCES dim_donor(donor_id),
    constraint fk_dim_blood_collection_camp_id FOREIGN KEY(camp_id) REFERENCES dim_camp(camp_id)

)
go

CREATE TABLE dim_blood_donation_drive (
    donation_id INT not null,
    donor_id INT,
    donation_date DATE,
    donation_location VARCHAR(255),
    constraint pk_blood_donation_drive_donation_id PRIMARY KEY(donation_id),
    constraint fk_blood_donation_drive_donor_id FOREIGN KEY (donor_id) REFERENCES dim_donor(donor_id)
)
go

CREATE TABLE dim_recipient (
    recipient_id INT not null,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(10),
    blood_type VARCHAR(5),
    medical_history TEXT,
    CONSTRAINT pk_recipient_recipient_id primary key(recipient_id)
)
go 

CREATE TABLE dim_staff (
    staff_id INT not null,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    date_of_birth DATE,
    gender CHAR(1),
    contact_number NVARCHAR(15),
    email NVARCHAR(100),
    location NVARCHAR(100),
    role NVARCHAR(50),
    CONSTRAINT pk_staff_staff_id primary key(staff_id)
);
go

CREATE TABLE dim_blood_disease (
    bag_id INT not null,
    disease NVARCHAR(50),
    disease_status NVARCHAR(3) CHECK (disease_status IN ('Yes', 'No')),
    constraint pk_blood_disease_bag_id primary key(bag_id)
)
go

CREATE TABLE dim_inventory (
    inventory_id INT not null,
    storage_unit_name NVARCHAR(50),
    storage_location NVARCHAR(100),
    point_of_contact NVARCHAR(50)
    constraint pk_inventory_inventory_id primary key(inventory_id)
)
go

CREATE TABLE dim_component (
    component_id INT not null,
    component_name NVARCHAR(50),
    expiration_limit_in_days INT,
    constraint pk_component_component_id primary key(component_id)
)
go



CREATE TABLE dim_hospital_staff_details (
    hospital_staff_id INT PRIMARY KEY CHECK (hospital_staff_id BETWEEN 201 AND 250),
    hospital_id INT,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    location NVARCHAR(100),
    contact_number NVARCHAR(15)
);


CREATE TABLE fact_blood_donation_drive (
    camp_id INT,
    donor_id INT,
    bag_id INT,
    staff_id INT,
    inventory_id INT,
    collection_date DATE,
    blood_units_collected INT,
    blood_type VARCHAR(5),
    CONSTRAINT pk_fact_blood_donation_drive PRIMARY KEY (camp_id,inventory_id, donor_id, bag_id),
    CONSTRAINT fk_fact_blood_donation_drive_camp_id FOREIGN KEY(camp_id) REFERENCES dim_camp(camp_id),
    CONSTRAINT fk_fact_blood_donation_drive_donor_id FOREIGN KEY(donor_id) REFERENCES dim_donor(donor_id),
    CONSTRAINT fk_fact_blood_donation_drive_staff_id FOREIGN KEY(staff_id) REFERENCES dim_staff(staff_id),
    CONSTRAINT fk_fact_blood_donation_drive_inventory_id FOREIGN KEY(inventory_id) REFERENCES dim_inventory(inventory_id),
    CONSTRAINT fk_fact_blood_donation_drive_bag_id FOREIGN KEY(bag_id) REFERENCES dim_blood_collection(bag_id)
)
go





CREATE TABLE fact_blood_pre_process_storage (
    inventory_id INT,
    donor_id INT,
    bag_id INT,
    storage_date DATE,
    blood_units_stored INT,
    blood_type VARCHAR(5),
    CONSTRAINT pk_blood_pre_process_storage PRIMARY KEY (inventory_id, donor_id, bag_id),
    CONSTRAINT fk_blood_pre_process_storage_inventory_id FOREIGN KEY (inventory_id) REFERENCES dim_inventory(inventory_id),
    CONSTRAINT fk_blood_pre_process_storage_donor_id FOREIGN KEY (donor_id) REFERENCES dim_donor(donor_id),
    CONSTRAINT fk_blood_pre_process_storage_bag_id FOREIGN KEY (bag_id) REFERENCES dim_blood_collection(bag_id)
)
go





CREATE TABLE fact_processing_disease_test (
    inventory_id INT,
    donor_id INT,
    bag_id INT,
    disease_flag CHAR(1),
    disease_type VARCHAR(50),
    blood_bag_approval CHAR(1),
    storage_date DATE,
    blood_units_stored INT,
    blood_type VARCHAR(5),
    CONSTRAINT pk_processing_disease_test PRIMARY KEY (inventory_id, donor_id, bag_id),
    CONSTRAINT fk_processing_disease_test_inventory_id FOREIGN KEY (inventory_id) REFERENCES dim_inventory(inventory_id),
    CONSTRAINT fk_processing_disease_test_donor_id FOREIGN KEY (donor_id) REFERENCES dim_donor(donor_id),
    CONSTRAINT fk_processing_disease_test_blood_id FOREIGN KEY (bag_id) REFERENCES dim_blood_collection(bag_id)
)
go





CREATE TABLE fact_processing_centrifuge (
    inventory_id INT,
    donor_id INT,
    bag_id INT,
    component_id INT,
    processing_date DATE,
    blood_units_stored INT,
    blood_type VARCHAR(5),
    CONSTRAINT pk_processing_centrifuge PRIMARY KEY (inventory_id, donor_id, bag_id, component_id),
    CONSTRAINT fk_processing_centrifuge_inventory_id FOREIGN KEY (inventory_id) REFERENCES dim_inventory(inventory_id),
    CONSTRAINT fk_processing_centrifuge_donor_id FOREIGN KEY (donor_id) REFERENCES dim_donor(donor_id),
    CONSTRAINT fk_processing_centrifuge_bag_id FOREIGN KEY (bag_id) REFERENCES dim_blood_collection(bag_id),
    CONSTRAINT fk_processing_centrifuge_component_id FOREIGN KEY (component_id) REFERENCES dim_component(component_id))
go





CREATE TABLE fact_storage_inventory (
    inventory_id INT,
    bag_id INT,
    component_id INT,
    storage_date DATE,
    blood_units_stored INT,
    blood_type VARCHAR(5),
    CONSTRAINT pk_storage_inventory PRIMARY KEY (inventory_id, bag_id, component_id),
    CONSTRAINT fk_storage_inventory_inventory_id FOREIGN KEY (inventory_id) REFERENCES dim_inventory(inventory_id),
    CONSTRAINT fk_storage_inventory_bag_id FOREIGN KEY (bag_id) REFERENCES dim_blood_collection(bag_id),
    CONSTRAINT fk_storage_inventory_component_id FOREIGN KEY (component_id) REFERENCES dim_component(component_id)
)
go




CREATE TABLE fact_blood_requests (
    request_id INT,
    hospital_id INT,
    blood_type_requested VARCHAR(5),
    blood_component_requested VARCHAR(20),
    blood_type VARCHAR(5),
    units_requested INT,
    request_date DATE,
    hospital_staff_id INT,
    CONSTRAINT pk_blood_requests PRIMARY KEY (request_id, hospital_id),
    CONSTRAINT fk_blood_requests_hospital_id FOREIGN KEY (hospital_id) REFERENCES dim_hospital(hospital_id),
    CONSTRAINT fk_blood_requests_hospital_staff_id FOREIGN KEY (hospital_staff_id) REFERENCES dim_hospital_staff_details(hospital_staff_id)
)
go





CREATE TABLE fact_hospital_requests (
    request_id INT,
    hospital_id INT,
    patient_id INT,
    incident_type VARCHAR(50),
    priority VARCHAR(20),
    blood_type_requested VARCHAR(5),
    blood_component_requested VARCHAR(20),
    blood_type VARCHAR(5),
    units_requested INT,
    cost_per_unit DECIMAL(10, 2),
    request_date DATE,
    hospital_staff_id INT,
    CONSTRAINT pk_hospital_requests PRIMARY KEY (request_id, hospital_id),
    CONSTRAINT fk_hospital_requests_hospital_id FOREIGN KEY (hospital_id) REFERENCES dim_hospital(hospital_id),
    CONSTRAINT fk_hospital_requests_patient_id FOREIGN KEY (patient_id) REFERENCES dim_recipient(recipient_id),
    CONSTRAINT fk_hospital_requests_hospital_staff_id FOREIGN KEY (hospital_staff_id) REFERENCES dim_hospital_staff_details(hospital_staff_id)
)
go



CREATE TABLE fact_patient_to_hospital (
    incident_request_id INT,
    hospital_id INT,
    patient_id INT,
    incident_type VARCHAR(50),
    priority VARCHAR(20),
    blood_type_requested VARCHAR(5),
    blood_component_requested VARCHAR(20),
    blood_type VARCHAR(5),
    units_requested INT,
    cost_per_unit DECIMAL(10, 2),
    request_date DATE,
    CONSTRAINT pk_patient_to_hospital PRIMARY KEY (incident_request_id, hospital_id,patient_id),
    CONSTRAINT fk_patient_to_hospital_hospital_id FOREIGN KEY (hospital_id) REFERENCES dim_hospital(hospital_id),
    CONSTRAINT fk_patient_to_hospital_patient_id FOREIGN KEY (patient_id) REFERENCES dim_recipient(recipient_id)
)
go



-----------------------------------------------------------------------------------> Unique and Check constraints
ALTER TABLE dim_blood_collection
ADD CONSTRAINT ck_blood_type
CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'));
GO
 
-- ALTER TABLE dim_blood_collection
-- ADD CONSTRAINT ck_expiration_date
-- CHECK (expiration_date > unit_collected_date);
-- GO
 
ALTER TABLE dim_blood_disease
ADD CONSTRAINT ck_disease_status
CHECK ((disease = 'No Disease' AND disease_status = 'No') OR (disease != 'No Disease' AND disease_status = 'Yes'));
GO
 
ALTER TABLE dim_component
ADD CONSTRAINT ck_component_id_and_name
CHECK (
    (component_id BETWEEN 1 AND 5)
    AND
    (
        (component_id = 1 AND component_name = 'Plasma') OR
        (component_id = 2 AND component_name = 'RBC') OR
        (component_id = 3 AND component_name = 'WBC') OR
        (component_id = 4 AND component_name = 'Platelets') OR
        (component_id = 5 AND component_name = 'Whole Blood')
    )
);
GO
 
-- ALTER TABLE dim_donor
-- ADD CONSTRAINT ck_donor_age
-- CHECK (DATEDIFF(CURRENT_DATE, date_of_birth) >= 16 * 365.25);
-- GO
 
-- ALTER TABLE dim_inventory
-- ADD CONSTRAINT ck_inventory_id_and_location
-- CHECK (
--     (storage_unit_name BETWEEN 'A' AND 'T')
--     AND
--     (storage_location BETWEEN 'G' AND 'Z')
-- );
-- GO
 
ALTER TABLE dim_recipient
ADD CONSTRAINT ck_recipient_blood_type_and_gender
CHECK (
    blood_type IN ('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-')
    AND
    gender IN ('Male', 'Female')
);
GO


--3 --------------------------------------------------------------------------------------------->Triggers -  Ensure Integrity :

DROP TRIGGER IF EXISTS trg_update_dim_blood_donation_camp_date
GO

-- Ensures camp date is consistent across the dim blood collection table, and expiration date is 45 days after camp date 
CREATE TRIGGER trg_update_dim_blood_donation_camp_date
ON dim_blood_collection
AFTER UPDATE,INSERT
AS
BEGIN

    BEGIN
    PRINT 'UPDATING DATES -> dim_blood_donation_camp'
        UPDATE dim_blood_collection
        SET
            dim_blood_collection.unit_collected_date = dim_camp.camp_date
        FROM
            dim_blood_collection,dim_camp
        WHERE
            dim_blood_collection.camp_id = dim_camp.camp_id;
    END

    BEGIN
        UPDATE dim_blood_collection
        SET expiration_date = DATEADD(day, 45, unit_collected_date)
    END
END
GO

-- Ensures camp date is consistent across the fact blood collection table
DROP TRIGGER IF EXISTS trg_update_fact_blood_donation_drive_date
GO


CREATE TRIGGER trg_update_fact_blood_donation_drive_camp_date
ON fact_blood_donation_drive
AFTER UPDATE,INSERT
AS
BEGIN

    BEGIN
    PRINT 'UPDATING DATES -> fact_blood_donation_drive'
    UPDATE fact_blood_donation_drive
    SET
        fact_blood_donation_drive.collection_date = dim_camp.camp_date
    FROM
        fact_blood_donation_drive,dim_camp
    WHERE
        fact_blood_donation_drive.camp_id = dim_camp.camp_id;
    END
END
GO

-- Ensures bag pre process  storage date is after collection date
DROP TRIGGER IF EXISTS trg_update_fact_blood_pre_process_storage_date
GO


CREATE TRIGGER trg_update_fact_blood_pre_process_storage_date
ON fact_blood_pre_process_storage
AFTER UPDATE,INSERT
AS
BEGIN

    BEGIN
    PRINT 'UPDATING DATES -> fact_blood_pre_process_storage'
        UPDATE fact_blood_pre_process_storage
        SET
            fact_blood_pre_process_storage.storage_date = DATEADD(day,3,dim_blood_collection.unit_collected_date)
        FROM
            fact_blood_pre_process_storage,dim_blood_collection
        WHERE
            fact_blood_pre_process_storage.bag_id = dim_blood_collection.bag_id;
    END

END
GO


-- Remove Blood Bags with Disease in fact_processing_centrifuge table
DROP TRIGGER IF EXISTS trg_delete_rows_where_blood_bag_has_disease_in_centrifuge
GO

CREATE TRIGGER trg_delete_rows_where_blood_bag_has_disease_in_centrifuge
ON fact_processing_centrifuge
AFTER UPDATE,INSERT
AS

BEGIN
        PRINT 'DELETING BLOOD BAGS WITH DISEASE -> fact_processing_centrifuge'
        DELETE FROM fact_processing_centrifuge WHERE bag_id in (SELECT bag_id FROM fact_processing_disease_test WHERE disease_type IS NOT NULL)
END
GO

-- Remove Blood Bags with Disease in fact_storage_inventory table
DROP TRIGGER IF EXISTS trg_delete_rows_where_blood_bag_has_disease_in_inventory
GO

CREATE TRIGGER trg_delete_rows_where_blood_bag_has_disease_in_inventory
ON fact_storage_inventory
AFTER UPDATE,INSERT
AS

BEGIN

        PRINT 'DELETING BLOOD BAGS WITH DISEASE -> fact_storage_inventory'
        DELETE FROM fact_storage_inventory WHERE bag_id in (SELECT bag_id FROM fact_processing_disease_test WHERE disease_type IS NOT NULL)

END
GO

-- Ensures bag fact_processing_centrifuge date is after storage date in process
DROP TRIGGER IF EXISTS trg_update_fact_processing_centrifuge_process_date
GO


CREATE TRIGGER trg_update_fact_processing_centrifuge_process_date
ON fact_processing_centrifuge
AFTER UPDATE,INSERT
AS
BEGIN

    BEGIN
    PRINT 'UPDATING DATES -> fact_processing_centrifuge'
        UPDATE fact_processing_centrifuge
        SET
            fact_processing_centrifuge.processing_date = DATEADD(day,3,fact_blood_pre_process_storage.storage_date)
        FROM
            fact_processing_centrifuge,fact_blood_pre_process_storage
        WHERE
            fact_processing_centrifuge.bag_id = fact_blood_pre_process_storage.bag_id;
    END

END
GO


-- Ensures bag fact_storage_inventory date is after process date in fact_processing_centrifuge
DROP TRIGGER IF EXISTS trg_update_fact_storage_inventory_storage_date
GO


CREATE TRIGGER trg_update_fact_storage_inventory_storage_date
ON fact_storage_inventory
AFTER UPDATE,INSERT
AS
BEGIN

    BEGIN
    PRINT 'UPDATING DATES -> fact_storage_inventory'
        UPDATE fact_storage_inventory
        SET
            fact_storage_inventory.storage_date = DATEADD(day,3,fact_processing_centrifuge.processing_date)
        FROM
            fact_storage_inventory,fact_processing_centrifuge
        WHERE
            fact_storage_inventory.bag_id = fact_processing_centrifuge.bag_id;
    END

END
GO

-- UP SCRIPT
----------------------------------------------------------------------------------------> INSERT Operations

INSERT INTO dim_donor (donor_id, first_name, last_name, date_of_birth, gender, blood_type, contact_number, email, address, last_donation_date)
VALUES
(1, 'John', 'Doe', '1990-01-01', 'M', 'O+', '1234567890', 'john.doe@example.com', '123 Main St', '2023-01-15'),
(2, 'Jane', 'Smith', '1985-05-15', 'F', 'A-', '9876543210', 'jane.smith@example.com', '456 Oak St', '2022-11-20'),
(3, 'Michael', 'Johnson', '1988-08-20', 'M', 'B+', '5551112222', 'michael.johnson@example.com', '789 Maple St', '2023-02-28'),
(4, 'Emily', 'Anderson', '1995-04-12', 'F', 'AB-', '4443332222', 'emily.anderson@example.com', '567 Birch St', '2022-10-10'),
(5, 'Daniel', 'Williams', '1982-11-05', 'M', 'A+', '3339998888', 'daniel.williams@example.com', '890 Cedar St', '2023-03-05'),
(6, 'Olivia', 'Jones', '1997-09-25', 'F', 'B-', '1112223333', 'olivia.jones@example.com', '678 Pine St', '2022-12-12'),
(7, 'William', 'Brown', '1984-03-08', 'M', 'O-', '9998887777', 'william.brown@example.com', '234 Oak St', '2022-09-15'),
(8, 'Ava', 'Davis', '1998-06-30', 'F', 'AB+', '7776665555', 'ava.davis@example.com', '345 Maple St', '2023-01-31'),
(9, 'James', 'Miller', '1980-12-17', 'M', 'A-', '5554443333', 'james.miller@example.com', '456 Elm St', '2022-11-05'),
(10, 'Sophia', 'Taylor', '1993-07-18', 'F', 'B+', '2223334444', 'sophia.taylor@example.com', '567 Pine St', '2023-02-28'),
(11, 'Benjamin', 'Anderson', '1987-02-14', 'M', 'O+', '8889990000', 'benjamin.anderson@example.com', '789 Oak St', '2022-10-15'),
(12, 'Emma', 'White', '1996-08-03', 'F', 'A-', '6665554444', 'emma.white@example.com', '890 Maple St', '2022-09-20'),
(13, 'Logan', 'Harris', '1983-04-22', 'M', 'B+', '3332221111', 'logan.harris@example.com', '123 Birch St', '2023-03-10'),
(14, 'Mia', 'Clark', '1994-10-05', 'F', 'AB-', '2221110000', 'mia.clark@example.com', '234 Cedar St', '2022-12-20'),
(15, 'Elijah', 'Lewis', '1981-01-28', 'M', 'A+', '9990001111', 'elijah.lewis@example.com', '345 Elm St', '2022-11-25'),
(16, 'Avery', 'Jones', '1999-05-12', 'F', 'B-', '7778889999', 'avery.jones@example.com', '456 Pine St', '2023-01-15'),
(17, 'Jackson', 'Miller', '1986-11-15', 'M', 'O-', '5556667777', 'jackson.miller@example.com', '567 Oak St', '2022-10-01'),
(18, 'Scarlett', 'Wilson', '1990-07-08', 'F', 'AB+', '4445556666', 'scarlett.wilson@example.com', '678 Maple St', '2023-02-05'),
(19, 'Liam', 'Moore', '1989-02-18', 'M', 'A-', '1112223333', 'liam.moore@example.com', '789 Elm St', '2022-12-10'),
(20, 'Chloe', 'Hall', '1997-06-22', 'F', 'B+', '8887776666', 'chloe.hall@example.com', '890 Pine St', '2023-01-20'),
(21, 'Noah', 'Baker', '1982-12-10', 'M', 'O+', '6665554444', 'noah.baker@example.com', '123 Cedar St', '2022-11-15'),
(22, 'Amelia', 'Green', '1995-08-27', 'F', 'A-', '3332221111', 'amelia.green@example.com', '234 Elm St', '2023-02-10'),
(23, 'Ethan', 'Young', '1988-03-05', 'M', 'B+', '1110009999', 'ethan.young@example.com', '345 Birch St', '2022-10-25'),
(24, 'Lily', 'Cooper', '1994-09-18', 'F', 'AB-', '8889990000', 'lily.cooper@example.com', '456 Cedar St', '2022-12-05'),
(25, 'Mason', 'Evans', '1983-05-02', 'M', 'A+', '5556667777', 'mason.evans@example.com', '567 Elm St', '2023-01-25'),
(26, 'Harper', 'Adams', '1998-01-15', 'F', 'B-', '2223334444', 'harper.adams@example.com', '678 Birch St', '2022-11-30'),
(27, 'Elijah', 'Perez', '1981-07-30', 'M', 'O-', '9998887777', 'elijah.perez@example.com', '789 Cedar St', '2023-02-15'),
(28, 'Aria', 'Turner', '1996-03-12', 'F', 'AB+', '6665554444', 'aria.turner@example.com', '890 Elm St', '2022-10-30'),
(29, 'Grayson', 'Ward', '1984-09-24', 'M', 'A-', '3332221111', 'grayson.ward@example.com', '123 Pine St', '2022-12-15'),
(30, 'Scarlett', 'Sullivan', '1997-04-07', 'F', 'B+', '1112223333', 'scarlett.sullivan@example.com', '234 Birch St', '2023-01-30'),
(31, 'Lucas', 'Coleman', '1980-10-20', 'M', 'O+', '8889990000', 'lucas.coleman@example.com', '345 Cedar St', '2022-11-20'),
(32, 'Penelope', 'Morgan', '1999-06-13', 'F', 'A-', '5556667777', 'penelope.morgan@example.com', '456 Elm St', '2023-02-05'),
(33, 'Carter', 'Fisher', '1987-02-28', 'M', 'B+', '2223334444', 'carter.fisher@example.com', '567 Pine St', '2022-10-10'),
(34, 'Madison', 'Watson', '1993-08-11', 'F', 'AB-', '9998887777', 'madison.watson@example.com', '678 Oak St', '2023-01-15'),
(35, 'Henry', 'Harrison', '1985-04-25', 'M', 'A+', '6665554444', 'henry.harrison@example.com', '789 Maple St', '2022-11-25'),
(36, 'Luna', 'Barnes', '1992-10-08', 'F', 'B-', '3332221111', 'luna.barnes@example.com', '890 Cedar St', '2023-03-01'),
(37, 'Jackson', 'Hill', '1989-05-31', 'M', 'O-', '1112223333', 'jackson.hill@example.com', '123 Elm St', '2022-09-15'),
(38, 'Ella', 'Gonzalez', '1994-11-14', 'F', 'AB+', '7776665555', 'ella.gonzalez@example.com', '234 Birch St', '2022-12-20'),
(39, 'Aiden', 'Chapman', '1986-06-27', 'M', 'A-', '4445556666', 'aiden.chapman@example.com', '345 Pine St', '2023-02-25'),
(40, 'Stella', 'Fleming', '1991-01-20', 'F', 'B+', '2221110000', 'stella.fleming@example.com', '456 Oak St', '2022-10-01'),
(41, 'Caleb', 'Wells', '1996-07-03', 'M', 'O+', '9990001111', 'caleb.wells@example.com', '567 Maple St', '2022-09-20'),
(42, 'Nova', 'Ward', '1983-12-16', 'F', 'A-', '5556667777', 'nova.ward@example.com', '678 Elm St', '2023-03-10'),
(43, 'Isaac', 'Fuller', '1998-03-29', 'M', 'B+', '3334445555', 'isaac.fuller@example.com', '789 Birch St', '2022-11-05'),
(44, 'Aurora', 'Murray', '1981-09-11', 'F', 'AB-', '1112223333', 'aurora.murray@example.com', '890 Cedar St', '2022-10-15'),
(45, 'Eli', 'Hanson', '1995-05-24', 'M', 'A+', '8889990000', 'eli.hanson@example.com', '123 Pine St', '2023-01-01'),
(46, 'Grace', 'Nelson', '1988-10-07', 'F', 'B-', '4445556666', 'grace.nelson@example.com', '234 Elm St', '2022-09-25'),
(47, 'Levi', 'Reyes', '1992-04-30', 'M', 'O-', '7776665555', 'levi.reyes@example.com', '345 Birch St', '2023-02-10'),
(48, 'Zoe', 'Knight', '1987-11-13', 'F', 'AB+', '5554443333', 'zoe.knight@example.com', '456 Cedar St', '2022-10-05'),
(49, 'Miles', 'Porter', '1994-06-26', 'M', 'A-', '2221110000', 'miles.porter@example.com', '567 Elm St', '2022-12-30'),
(50, 'Hazel', 'Simpson', '1999-02-09', 'F', 'B+', '9998887777', 'hazel.simpson@example.com', '678 Pine St', '2023-01-20')
go



INSERT INTO dim_hospital (hospital_id, hospital_name, hospital_location,hospital_location_state, contact_number)
VALUES
(1, 'City General dim_hospital', '123 Main Street','New York', '555-1234'),
(2, 'Central Medical Center', '456 Oak Avenue','New York', '555-5678'),
(3, 'Community Health Center', '789 Elm Boulevard','New York', '555-9012'),
(4, 'Metro Regional dim_hospital', '234 Pine Lane','California', '555-3456'),
(5, 'County Memorial dim_hospital', '567 Maple Drive','California', '555-7890'),
(6, 'University Medical Center', '890 Cedar Road','California', '555-2345'),
(7, 'Southside Health Clinic', '123 Birch Street','Texas', '555-6789'),
(8, 'Northwest General dim_hospital', '456 Cedar Lane','Texas', '555-0123'),
(9, 'Eastwood Medical Center', '789 Elm Avenue','Florida', '555-4567'),
(10, 'Westside Community dim_hospital', '234 Pine Boulevard','Florida', '555-8901')
go

INSERT INTO dim_camp (camp_id, camp_location, camp_location_state, camp_name, camp_date)
VALUES
(1, 'City Park', 'New York', 'City Health Fair', '2023-01-15'),
(2, 'Community Center', 'California', 'Community Blood Drive', '2023-02-20'),
(3, 'Regional dim_hospital', 'Texas', 'Regional Blood Donation Event', '2023-03-28'),
(4, 'Red Cross Mobile Unit', 'Florida', 'Mobile Blood Collection', '2023-04-10'),
(5, 'University Campus', 'New York', 'University Blood Drive', '2023-05-05'),
(6, 'Local Community Center', 'California', 'Community Health Fair', '2023-06-12'),
(7, 'County Fairgrounds', 'Texas', 'County Blood Drive', '2023-07-15'),
(8, 'Downtown Square', 'Florida', 'Citywide Blood Donation', '2023-08-31'),
(9, 'City Park', 'New York', 'City Health Fair', '2023-09-05'),
(10, 'Community Center', 'California', 'Community Blood Drive', '2023-06-28'),
(11, 'Regional dim_hospital', 'Texas', 'Regional Blood Donation Event', '2023-01-15'),
(12, 'Red Cross Mobile Unit', 'Florida', 'Mobile Blood Collection', '2023-01-20'),
(13, 'University Campus', 'New York', 'University Blood Drive', '2023-01-28'),
(14, 'Local Community Center', 'California', 'Community Health Fair', '2023-02-10'),
(15, 'County Fairgrounds', 'Texas', 'County Blood Drive', '2023-03-05'),
(16, 'Downtown Square', 'Florida', 'Citywide Blood Donation', '2023-04-12'),
(17, 'City Park', 'New York', 'City Health Fair', '2023-05-15'),
(18, 'Community Center', 'California', 'Community Blood Drive', '2023-06-30'),
(19, 'Regional dim_hospital', 'Texas', 'Regional Blood Donation Event', '2023-07-05'),
(20, 'Red Cross Mobile Unit', 'Florida', 'Mobile Blood Collection', '2023-08-28');
go

INSERT INTO dim_blood_collection (bag_id, donor_id, donor_name, blood_type, expiration_date, blood_status, unit_collected_date, camp_id, staff_id)
VALUES
(1, 1, 'John Doe', 'O+', '2023-01-30', 'Available', '2023-01-15', 1, 3),
(2, 2, 'Jane Smith', 'A-', '2023-02-25', 'Available', '2023-02-20', 2, 3),
(3, 3, 'Robert Johnson', 'B+', '2023-04-25', 'Available', '2023-03-28', 3, 3),
(4, 4, 'Emily Davis', 'AB-', '2023-04-11', 'Available', '2023-04-10', 4, 3),
(5, 5, 'Michael Brown', 'A+', '2023-06-18', 'Available', '2023-05-05', 5, 3),
(6, 6, 'Jessica Wilson', 'B-', '2023-07-01', 'Available', '2023-06-12', 6, 3),
(7, 7, 'Christopher Lee', 'O-', '2023-08-01', 'Available', '2023-07-15', 7, 3),
(8, 8, 'Sophia Kim', 'AB+', '2023-10-15', 'Available', '2023-08-31', 8, 3),
(9, 9, 'William Davis', 'A-', '2023-10-01', 'Available', '2023-09-05', 9, 3),
(10, 10, 'Olivia Johnson', 'B+', '2023-11-18', 'Available', '2023-10-28', 10, 3),
(11, 11, 'Ethan Martinez', 'O+', '2023-12-01', 'Available', '2023-11-15', 11, 3),
(12, 12, 'Ava Wilson', 'A-', '2023-12-01', 'Available', '2023-11-20', 12, 3),
(13, 13, 'Daniel Miller', 'B+', '2023-04-01', 'Available', '2023-01-28', 13, 3),
(14, 14, 'Emma Smith', 'AB-', '2023-04-01', 'Available', '2023-02-10', 14, 3),
(15, 15, 'Noah Anderson', 'A+', '2023-05-01', 'Available', '2023-03-05', 15, 3),
(16, 16, 'Isabella Garcia', 'B-', '2023-12-01', 'Available', '2023-04-12', 16, 3),
(17, 17, 'Alexander Brown', 'O-', '2023-12-01', 'Available', '2023-05-15', 17, 3),
(18, 18, 'Mia Davis', 'AB+', '2023-12-01', 'Available', '2023-06-30', 18, 3),
(19, 19, 'James Lee', 'A-', '2023-12-01', 'Available', '2023-07-05', 19, 3),
(20, 20, 'Sophia Wilson', 'B+', '2023-11-01', 'Available', '2023-08-28', 20, 3),
(21, 21, 'Elijah Martinez', 'O+', '2023-12-01', 'Available', '2023-11-15', 11, 3),
(22, 22, 'Charlotte Wilson', 'A-', '2023-12-01', 'Available', '2023-11-20', 12, 3),
(23, 23, 'Logan Miller', 'B+', '2023-04-01', 'Available', '2023-01-28', 13, 3),
(24, 24, 'Avery Smith', 'AB-', '2023-04-01', 'Available', '2023-02-10', 14, 3),
(25, 25, 'Jackson Anderson', 'A+', '2023-05-01', 'Available', '2023-03-05', 15, 3),
(26, 26, 'Grace Garcia', 'B-', '2023-05-01', 'Available', '2023-04-12', 16, 3),
(27, 27, 'Lucas Brown', 'O-', '2023-12-01', 'Available', '2023-05-15', 17, 3),
(28, 28, 'Lily Davis', 'AB+', '2023-12-01', 'Available', '2023-06-30', 18, 3),
(29, 29, 'Benjamin Lee', 'A-', '2023-12-01', 'Available', '2023-07-05', 19, 3),
(30, 30, 'Amelia Wilson', 'B+', '2023-12-01', 'Available', '2023-08-28', 20, 3),
(31, 31, 'Henry Martinez', 'O+', '2023-12-01', 'Available', '2023-11-15', 11, 3),
(32, 32, 'Ella Wilson', 'A-', '2023-12-01', 'Available', '2023-11-20', 12, 3),
(33, 33, 'Mason Miller', 'B+', '2023-04-01', 'Available', '2023-01-28', 13, 3),
(34, 34, 'Aria Smith', 'AB-', '2023-04-01', 'Available', '2023-02-10', 14, 3),
(35, 35, 'Sebastian Anderson', 'A+', '2023-05-01', 'Available', '2023-03-05', 15, 3),
(36, 36, 'Scarlett Garcia', 'B-', '2023-05-01', 'Available', '2023-04-12', 16, 3),
(37, 37, 'Gabriel Brown', 'O-', '2022-09-22', 'Available', '2022-09-07', 7, 3),
(38, 38, 'Chloe Davis', 'AB+', '2023-12-15', 'Available', '2023-08-31', 8, 3),
(39, 39, 'Carter Lee', 'A-', '2022-11-22', 'Available', '2022-10-17', 9, 3),
(40, 40, 'Madison Wilson', 'B+', '2023-12-10', 'Available', '2023-10-28', 10, 3),
(41, 41, 'Andrew Martinez', 'O+', '2023-12-25', 'Available', '2023-11-15', 11, 3),
(42, 42, 'Abigail Wilson', 'A-', '2023-12-01', 'Available', '2023-11-20', 12, 3),
(43, 43, 'Nathan Miller', 'B+', '2023-04-01', 'Available', '2023-01-28', 13, 3),
(44, 44, 'Evelyn Smith', 'AB-', '2023-04-01', 'Available', '2023-02-10', 14, 3),
(45, 45, 'Dylan Anderson', 'A+', '2023-05-01', 'Available', '2023-03-05', 15, 3),
(46, 46, 'Zoe Garcia', 'B-', '2023-05-01', 'Available', '2023-04-12', 16, 3),
(47, 47, 'Owen Brown', 'O-', '2022-09-16', 'Available', '2022-09-01', 7, 3),
(48, 48, 'Brooklyn Davis', 'AB+', '2023-10-15', 'Available', '2023-08-31', 8, 3),
(49, 49, 'Liam Lee', 'A-', '2022-11-22', 'Available', '2022-10-17', 9, 3),
(50, 50, 'Hannah Wilson', 'B+', '2023-11-10', 'Available', '2023-10-28', 10, 3);





INSERT INTO dim_blood_donation_drive (donation_id, donor_id, donation_date, donation_location)
VALUES
(1, 1, '2022-01-15', 'City Blood Center'),
(2, 2, '2022-02-20', 'Community dim_hospital'),
(3, 3, '2022-03-28', 'Regional Medical Center'),
(4, 4, '2022-04-10', 'Red Cross Mobile Unit'),
(5, 5, '2022-05-05', 'University Blood Drive'),
(6, 6, '2022-06-12', 'Local Community Center'),
(7, 7, '2022-07-15', 'County Blood Bank'),
(8, 8, '2022-08-31', 'Medical Outreach Van'),
(9, 9, '2022-09-05', 'City Blood Center'),
(10, 10, '2022-10-28', 'Community dim_hospital'),
(11, 1, '2022-11-15', 'Regional Medical Center'),
(12, 2, '2022-12-20', 'Red Cross Mobile Unit'),
(13, 3, '2023-01-28', 'University Blood Drive'),
(14, 4, '2023-02-10', 'Local Community Center'),
(15, 5, '2023-03-05', 'County Blood Bank'),
(16, 6, '2023-04-12', 'Medical Outreach Van'),
(17, 7, '2023-05-15', 'City Blood Center'),
(18, 8, '2023-06-30', 'Community dim_hospital'),
(19, 9, '2023-07-05', 'Regional Medical Center'),
(20, 10, '2023-08-28', 'Red Cross Mobile Unit'),
(21, 1, '2023-09-15', 'University Blood Drive'),
(22, 2, '2023-10-20', 'Local Community Center'),
(23, 3, '2023-11-28', 'County Blood Bank'),
(24, 4, '2023-12-10', 'Medical Outreach Van'),
(25, 5, '2023-01-05', 'City Blood Center'),
(26, 6, '2023-02-12', 'Community dim_hospital'),
(27, 7, '2023-03-15', 'Regional Medical Center'),
(28, 8, '2023-04-30', 'Red Cross Mobile Unit'),
(29, 9, '2023-05-05', 'University Blood Drive'),
(30, 10, '2023-06-28', 'Local Community Center'),
(31, 1, '2023-07-15', 'County Blood Bank'),
(32, 2, '2023-08-31', 'Medical Outreach Van'),
(33, 3, '2023-09-05', 'City Blood Center'),
(34, 4, '2023-10-28', 'Community dim_hospital'),
(35, 5, '2023-11-30', 'Regional Medical Center'),
(36, 6, '2023-12-12', 'Red Cross Mobile Unit'),
(37, 7, '2023-01-15', 'University Blood Drive'),
(38, 8, '2023-02-28', 'Local Community Center'),
(39, 9, '2023-03-05', 'County Blood Bank'),
(40, 10, '2023-04-28', 'Medical Outreach Van'),
(41, 1, '2023-05-15', 'City Blood Center'),
(42, 2, '2023-06-20', 'Community dim_hospital'),
(43, 3, '2023-07-28', 'Regional Medical Center'),
(44, 4, '2023-08-10', 'Red Cross Mobile Unit'),
(45, 5, '2023-09-05', 'University Blood Drive'),
(46, 6, '2023-10-12', 'Local Community Center'),
(47, 7, '2023-11-15', 'County Blood Bank'),
(48, 8, '2023-12-30', 'Medical Outreach Van'),
(49, 9, '2023-01-05', 'City Blood Center'),
(50, 10, '2023-02-28', 'Community dim_hospital')
go

INSERT INTO dim_recipient (recipient_id, first_name, last_name, date_of_birth, gender, blood_type, medical_history)
VALUES
(1, 'Emma', 'Johnson', '1990-05-15', 'Female', 'A+', 'No known medical conditions'),
(2, 'Aiden', 'Smith', '1985-08-20', 'Male', 'B-', 'Hypertension'),
(3, 'Olivia', 'Davis', '1978-03-28', 'Female', 'O+', 'Asthma'),
(4, 'Liam', 'Wilson', '1995-04-10', 'Male', 'AB+', 'Diabetes'),
(5, 'Sophia', 'Brown', '1982-05-05', 'Female', 'A-', 'None'),
(6, 'Noah', 'Miller', '1989-06-12', 'Male', 'B+', 'Allergies'),
(7, 'Ava', 'Anderson', '1975-07-15', 'Female', 'O-', 'High Cholesterol'),
(8, 'Mia', 'Garcia', '1998-08-31', 'Female', 'AB+', 'None'),
(9, 'Ethan', 'Lee', '1992-09-05', 'Male', 'A-', 'Asthma'),
(10, 'Isabella', 'Martinez', '1987-10-28', 'Female', 'B+', 'Hypertension'),
(11, 'Jackson', 'Taylor', '1993-11-15', 'Male', 'O+', 'None'),
(12, 'Aria', 'Moore', '1980-12-20', 'Female', 'A-', 'Diabetes'),
(13, 'Lucas', 'Johnson', '1996-01-28', 'Male', 'B+', 'None'),
(14, 'Harper', 'Wilson', '1972-02-10', 'Female', 'AB-', 'High Blood Pressure'),
(15, 'Liam', 'Smith', '1985-03-05', 'Male', 'A+', 'Asthma'),
(16, 'Amelia', 'Brown', '1990-04-12', 'Female', 'B-', 'None'),
(17, 'Elijah', 'Davis', '1978-07-15', 'Male', 'O-', 'Diabetes'),
(18, 'Grace', 'Wilson', '1983-06-30', 'Female', 'AB+', 'None'),
(19, 'Logan', 'Garcia', '1997-07-05', 'Male', 'A-', 'None'),
(20, 'Avery', 'Lee', '1982-08-28', 'Female', 'B+', 'Allergies'),
(21, 'Sophie', 'Martinez', '1989-09-15', 'Female', 'O+', 'None'),
(22, 'Henry', 'Taylor', '1975-10-31', 'Male', 'A-', 'High Cholesterol'),
(23, 'Madison', 'Moore', '1998-11-05', 'Female', 'B+', 'Asthma'),
(24, 'Ethan', 'Johnson', '1981-12-28', 'Male', 'AB-', 'None'),
(25, 'Aria', 'Smith', '1995-01-05', 'Female', 'A+', 'None'),
(26, 'Carter', 'Brown', '1989-02-12', 'Male', 'B-', 'None'),
(27, 'Ava', 'Davis', '1972-03-15', 'Female', 'O-', 'High Blood Pressure'),
(28, 'Noah', 'Wilson', '1996-04-30', 'Male', 'AB+', 'None'),
(29, 'Mia', 'Garcia', '1988-05-05', 'Female', 'A-', 'Allergies'),
(30, 'Elijah', 'Lee', '1993-06-28', 'Male', 'B+', 'None')
go



INSERT INTO dim_staff (staff_id, first_name, last_name, date_of_birth, gender, contact_number, email, location, role)
VALUES
(1, 'John', 'Doe', '1990-05-15', 'M', '123-456-7890', 'john.doe@email.com', 'New York', 'Nurse'),
(2, 'Jane', 'Smith', '1985-08-22', 'F', '987-654-3210', 'jane.smith@email.com', 'Los Angeles', 'Nurse'),
(3, 'David', 'Johnson', '1993-12-10', 'M', '555-123-4567', 'david.johnson@email.com', 'Chicago', 'Nurse'),
(4, 'Emily', 'Williams', '1988-03-27', 'F', '777-888-9999', 'emily.williams@email.com', 'Houston', 'Nurse'),
(5, 'Michael', 'Brown', '1995-06-18', 'M', '111-222-3333', 'michael.brown@email.com', 'Miami', 'Nurse'),
(6, 'Amanda', 'Jones', '1982-09-05', 'F', '444-555-6666', 'amanda.jones@email.com', 'Seattle', 'Nurse'),
(7, 'Brian', 'Taylor', '1991-04-12', 'M', '999-888-7777', 'brian.taylor@email.com', 'San Francisco', 'Nurse'),
(8, 'Catherine', 'Miller', '1987-11-30', 'F', '666-777-8888', 'catherine.miller@email.com', 'Dallas', 'Doctor'),
(9, 'Ethan', 'Davis', '1994-07-25', 'M', '333-444-5555', 'ethan.davis@email.com', 'Boston', 'Doctor'),
(10, 'Olivia', 'Wilson', '1983-02-14', 'F', '555-666-7777', 'olivia.wilson@email.com', 'Phoenix', 'Nurse'),
(11, 'Christopher', 'Anderson', '1992-09-08', 'M', '111-222-3333', 'chris.anderson@email.com', 'Denver', 'Nurse'),
(12, 'Sophia', 'Moore', '1986-05-03', 'F', '777-888-9999', 'sophia.moore@email.com', 'Atlanta', 'Medical Assistant'),
(13, 'Daniel', 'Clark', '1996-12-20', 'M', '444-555-6666', 'daniel.clark@email.com', 'Detroit', 'Medical Assistant'),
(14, 'Isabella', 'Lewis', '1981-08-17', 'F', '999-888-7777', 'isabella.lewis@email.com', 'Minneapolis', 'Medical Assistant'),
(15, 'Matthew', 'Hall', '1990-03-02', 'M', '666-777-8888', 'matthew.hall@email.com', 'Philadelphia', 'Medical Assistant'),
(16, 'Chloe', 'Martin', '1989-10-15', 'F', '333-444-5555', 'chloe.martin@email.com', 'San Diego', 'Medical Assistant'),
(17, 'Andrew', 'Allen', '1993-06-28', 'M', '555-666-7777', 'andrew.allen@email.com', 'Portland', 'Medical Assistant'),
(18, 'Grace', 'White', '1984-01-11', 'F', '111-222-3333', 'grace.white@email.com', 'Charlotte', 'Medical Assistant'),
(19, 'James', 'Harris', '1997-04-24', 'M', '777-888-9999', 'james.harris@email.com', 'Houston', 'Medical Assistant'),
(20, 'Emma', 'Turner', '1988-11-07', 'F', '999-888-7777', 'emma.turner@email.com', 'Dallas', 'Doctor')
go

INSERT INTO dim_blood_disease (bag_id, disease, disease_status)
VALUES
(1, 'No Disease', 'No'),
(2, 'Hemophilia', 'Yes'),
(3, 'No Disease', 'No'),
(4, 'Anemia', 'Yes'),
(5, 'No Disease', 'No'),
(6, 'Sickle Cell Anemia', 'Yes'),
(7, 'No Disease', 'No'),
(8, 'Thalassemia', 'Yes'),
(9, 'No Disease', 'No'),
(10, 'Leukemia', 'Yes'),
(11, 'No Disease', 'No'),
(12, 'Iron Deficiency', 'Yes'),
(13, 'No Disease', 'No'),
(14, 'Polycythemia', 'Yes'),
(15, 'No Disease', 'No'),
(16, 'Hypertension', 'Yes'),
(17, 'No Disease', 'No'),
(18, 'Hemochromatosis', 'Yes'),
(19, 'No Disease', 'No'),
(20, 'Deep Vein Thrombosis', 'Yes'),
(21, 'No Disease', 'No'),
(22, 'Erythroblastosis Fetalis', 'Yes'),
(23, 'No Disease', 'No'),
(24, 'Myelodysplastic Syndromes', 'Yes'),
(25, 'No Disease', 'No'),
(26, 'Hemolytic Anemia', 'Yes'),
(27, 'No Disease', 'No'),
(28, 'Peripheral Artery Disease', 'Yes'),
(29, 'No Disease', 'No'),
(30, 'Hemorrhagic Disorders', 'Yes'),
(31, 'No Disease', 'No'),
(32, 'Pulmonary Embolism', 'Yes'),
(33, 'No Disease', 'No'),
(34, 'Von Willebrand Disease', 'Yes'),
(35, 'No Disease', 'No'),
(36, 'Multiple Myeloma', 'Yes'),
(37, 'No Disease', 'No'),
(38, 'Factor V Leiden Deficiency', 'Yes'),
(39, 'No Disease', 'No'),
(40, 'Hypothyroidism', 'Yes'),
(41, 'No Disease', 'No'),
(42, 'Idiopathic Thrombocytopenic Purpura', 'Yes'),
(43, 'No Disease', 'No'),
(44, 'Malaria', 'Yes'),
(45, 'No Disease', 'No'),
(46, 'Hemangioma', 'Yes'),
(47, 'No Disease', 'No'),
(48, 'Coagulation Disorders', 'Yes'),
(49, 'No Disease', 'No'),
(50, 'Fever/AIDS', 'Yes')
go 

INSERT INTO dim_inventory (inventory_id, storage_unit_name, storage_location, point_of_contact)
VALUES
(1, 'Unit A', 'New York', 'John Doe'),
(2, 'Unit B', 'California', 'Jane Smith'),
(3, 'Unit C', 'Texas', 'David Johnson'),
(4, 'Unit D', 'Florida', 'Emily Williams'),
(5, 'Unit E', 'New York', 'Michael Brown'),
(6, 'Unit F', 'California', 'Amanda Jones'),
(7, 'Unit G', 'Texas', 'Brian Taylor'),
(8, 'Unit H', 'Florida', 'Catherine Miller'),
(9, 'Unit I', 'New York', 'Ethan Davis'),
(10, 'Unit J', 'California', 'Olivia Wilson'),
(11, 'Unit K', 'Texas', 'Christopher Anderson'),
(12, 'Unit L', 'Florida', 'Sophia Moore'),
(13, 'Unit M', 'New York', 'Daniel Clark'),
(14, 'Unit N', 'California', 'Isabella Lewis'),
(15, 'Unit O', 'Texas', 'Matthew Hall'),
(16, 'Unit P', 'Florida', 'Chloe Martin'),
(17, 'Unit Q', 'New York', 'Andrew Allen'),
(18, 'Unit R', 'California', 'Grace White'),
(19, 'Unit S', 'Texas', 'James Harris'),
(20, 'Unit T', 'Florida', 'Emma Turner');
go



INSERT INTO dim_component (component_id, component_name, expiration_limit_in_days)
VALUES
(1, 'Plasma', 30),
(2, 'RBC', 42),
(3, 'WBC', 14),
(4, 'Platelets', 21),
(5, 'Whole Blood', 35)
go

INSERT INTO dim_hospital_staff_details (hospital_staff_id, hospital_id, first_name, last_name, location, contact_number)
VALUES
    (201, 3, 'Eleanor', 'Miller', 'Hospital Location 1', '123-456-7890'),
    (202, 3, 'Matthew', 'Carter', 'Hospital Location 2', '987-654-3210'),
    (203, 6, 'Olivia', 'Fisher', 'Hospital Location 3', '555-123-4567'),
    (204, 9, 'Nathan', 'White', 'Hospital Location 1', '789-012-3456'),
    (205, 1, 'Sophia', 'Moore', 'Hospital Location 2', '234-567-8901'),
    (206, 2, 'Elijah', 'Hill', 'Hospital Location 3', '111-222-3333'),
    (207, 4, 'Grace', 'Turner', 'Hospital Location 1', '444-555-6666'),
    (208, 1, 'Aiden', 'Cooper', 'Hospital Location 2', '777-888-9999'),
    (209, 7, 'Hannah', 'Fletcher', 'Hospital Location 3', '123-987-6543'),
    (210, 4, 'Isaac', 'Reid', 'Hospital Location 1', '111-222-3333'),
    (211, 7, 'Lily', 'Harrison', 'Hospital Location 2', '444-555-6666'),
    (212, 7, 'Logan', 'Bryant', 'Hospital Location 3', '777-888-9999'),
    (213, 3, 'Mia', 'Collins', 'Hospital Location 1', '123-987-6543'),
    (214, 1, 'Caleb', 'Mason', 'Hospital Location 2', '111-222-3333'),
    (215, 4, 'Oliver', 'Hunt', 'Hospital Location 3', '444-555-6666'),
    (216, 3, 'Aria', 'Perry', 'Hospital Location 1', '777-888-9999'),
    (217, 5, 'Wyatt', 'Floyd', 'Hospital Location 2', '123-987-6543'),
    (218, 1, 'Ava', 'Perkins', 'Hospital Location 3', '111-222-3333'),
    (219, 5, 'Ethan', 'Richards', 'Hospital Location 1', '444-555-6666'),
    (220, 7, 'Emma', 'Webster', 'Hospital Location 2', '777-888-9999'),
    (221, 7, 'Liam', 'Wells', 'Hospital Location 3', '123-987-6543'),
    (222, 6, 'Amelia', 'Sutton', 'Hospital Location 1', '111-222-3333'),
    (223, 4, 'Mason', 'Chapman', 'Hospital Location 2', '444-555-6666'),
    (224, 7, 'Harper', 'Ross', 'Hospital Location 3', '777-888-9999'),
    (225, 6, 'Lucas', 'Wood', 'Hospital Location 1', '123-987-6543'),
    (226, 7, 'Avery', 'McCarthy', 'Hospital Location 2', '111-222-3333'),
    (227, 7, 'Jackson', 'Norman', 'Hospital Location 3', '444-555-6666'),
    (228, 6, 'Ella', 'Ball', 'Hospital Location 1', '777-888-9999'),
    (229, 4, 'Elijah', 'Parsons', 'Hospital Location 2', '123-987-6543'),
    (230, 4, 'Scarlett', 'Beck', 'Hospital Location 3', '111-222-3333'),
    (231, 8, 'Liam', 'Barker', 'Hospital Location 1', '444-555-6666'),
    (232, 9, 'Grace', 'Murray', 'Hospital Location 2', '777-888-9999'),
    (233, 10, 'Lincoln', 'Morrison', 'Hospital Location 3', '123-987-6543'),
    (234, 9, 'Chloe', 'Hardy', 'Hospital Location 1', '111-222-3333'),
    (235, 6, 'Carter', 'Flynn', 'Hospital Location 2', '444-555-6666'),
    (236, 7, 'Aubrey', 'Holt', 'Hospital Location 3', '777-888-9999'),
    (237, 7, 'Grayson', 'Blackburn', 'Hospital Location 1', '123-987-6543'),
    (238, 6, 'Penelope', 'Lowe', 'Hospital Location 2', '111-222-3333'),
    (239, 4, 'Xavier', 'Neal', 'Hospital Location 3', '444-555-6666'),
    (240, 4, 'Zoe', 'Faulkner', 'Hospital Location 1', '777-888-9999'),
    (241, 8, 'Silas', 'Leach', 'Hospital Location 2', '123-987-6543'),
    (242, 9, 'Nova', 'Davies', 'Hospital Location 3', '111-222-3333'),
    (243, 6, 'Leo', 'Hancock', 'Hospital Location 1', '444-555-6666'),
    (244, 2, 'Luna', 'Wade', 'Hospital Location 2', '777-888-9999'),
    (245, 4, 'Mateo', 'Walters', 'Hospital Location 3', '123-987-6543'),
    (246, 4, 'Eva', 'Church', 'Hospital Location 1', '111-222-3333'),
    (247, 8, 'Theo', 'Harding', 'Hospital Location 2', '444-555-6666'),
    (248, 9, 'Isla', 'Yates', 'Hospital Location 3', '777-888-9999'),
    (249, 6, 'Jack', 'Barnes', 'Hospital Location 1', '123-987-6543'),
    (250, 2, 'Aurora', 'Reed', 'Hospital Location 2', '111-222-3333');
GO

INSERT INTO fact_blood_donation_drive (camp_id, donor_id, bag_id, staff_id, inventory_id, collection_date, blood_units_collected, blood_type)
VALUES
(3, 47,FLOOR(RAND() * 50) + 1, 11, 9, '2023-03-05', 2, 'A-'),
(14, 22,FLOOR(RAND() * 50) + 1, 18, 15, '2023-06-30', 3, 'B+'),
(7, 8,FLOOR(RAND() * 50) + 1, 4, 5, '2023-02-14', 1, 'O+'),
(12, 40,FLOOR(RAND() * 50) + 1, 7, 6, '2023-03-23', 3, 'AB-'),
(1, 19,FLOOR(RAND() * 50) + 1, 5, 12, '2023-01-12', 2, 'A+'),
(6, 14,FLOOR(RAND() * 50) + 1, 19, 11, '2023-06-10', 1, 'O+'),
(18, 33,FLOOR(RAND() * 50) + 1, 16, 17, '2023-09-15', 3, 'AB-'),
(9, 2,FLOOR(RAND() * 50) + 1, 1, 7, '2023-02-28', 2, 'A-'),
(20, 27,FLOOR(RAND() * 50) + 1, 9, 2, '2023-05-20', 1, 'O+'),
(11, 43,FLOOR(RAND() * 50) + 1, 14, 4, '2023-11-01', 3, 'A+'),
(2, 28,FLOOR(RAND() * 50) + 1, 8, 14, '2023-02-05', 2, 'O+'),
(13, 13,FLOOR(RAND() * 50) + 1, 12, 8, '2023-07-07', 1, 'A+'),
(8, 34,FLOOR(RAND() * 50) + 1, 15, 19, '2023-08-15', 3, 'AB-'),
(19, 5,FLOOR(RAND() * 50) + 1, 2, 18, '2023-10-28', 2, 'O+'),
(4, 46,FLOOR(RAND() * 50) + 1, 6, 1, '2023-04-18', 1, 'B+'),
(15, 39,FLOOR(RAND() * 50) + 1, 13, 10, '2023-05-25', 3, 'A+'),
(10, 24,FLOOR(RAND() * 50) + 1, 10, 16, '2023-03-15', 2, 'AB-'),
(17, 48,FLOOR(RAND() * 50) + 1, 20, 3, '2023-09-01', 1, 'O+'),
(5, 45,FLOOR(RAND() * 50) + 1, 17, 13, '2023-05-05', 3, 'A+'),
(16, 12,FLOOR(RAND() * 50) + 1, 3, 20, '2023-04-10', 2, 'A-'),
(1, 32,FLOOR(RAND() * 50) + 1, 14, 6, '2023-09-10', 1, 'B+'),
(14, 19,FLOOR(RAND() * 50) + 1, 10, 15, '2023-11-22', 3, 'A+'),
(7, 47,FLOOR(RAND() * 50) + 1, 1, 1, '2023-09-05', 2, 'AB-'),
(12, 15,FLOOR(RAND() * 50) + 1, 18, 11, '2023-12-01', 1, 'O+'),
(20, 42,FLOOR(RAND() * 50) + 1, 13, 2, '2023-12-10', 3, 'A-'),
(6, 8,FLOOR(RAND() * 50) + 1, 6, 7, '2023-12-15', 2, 'O+'),
(18, 3,FLOOR(RAND() * 50) + 1, 2, 15, '2023-11-18', 1, 'A+'),
(9, 41,FLOOR(RAND() * 50) + 1, 16, 9, '2023-11-30', 3, 'B+'),
(20, 16,FLOOR(RAND() * 50) + 1, 11, 4, '2023-10-10', 2, 'A+'),
(11, 36,FLOOR(RAND() * 50) + 1, 5, 19, '2023-10-22', 1, 'O+'),
(2, 9,FLOOR(RAND() * 50) + 1, 7, 8, '2023-08-20', 3, 'AB+'),
(13, 26,FLOOR(RAND() * 50) + 1, 14, 12, '2023-01-06', 2, 'B+'),
(8, 23,FLOOR(RAND() * 50) + 1, 9, 10, '2023-06-15', 1, 'A+'),
(19, 37,FLOOR(RAND() * 50) + 1, 17, 16, '2023-04-05', 3, 'AB-'),
(4, 4,FLOOR(RAND() * 50) + 1, 8, 13, '2023-03-01', 2, 'B-'),
(15, 31,FLOOR(RAND() * 50) + 1, 12, 18, '2023-08-01', 1, 'AB-'),
(10, 18,FLOOR(RAND() * 50) + 1, 3, 7, '2023-11-25', 3, 'O-'),
(17, 7,FLOOR(RAND() * 50) + 1, 19, 20, '2023-11-20', 2, 'B+'),
(5, 25,FLOOR(RAND() * 50) + 1, 16, 14, '2023-09-08', 1, 'A+'),
(16, 38,FLOOR(RAND() * 50) + 1, 10, 1, '2023-06-08', 3, 'AB-'),
(3, 11,FLOOR(RAND() * 50) + 1, 5, 6, '2023-02-10', 2, 'A+'),
(14, 35,FLOOR(RAND() * 50) + 1, 18, 15, '2023-08-12', 1, 'A-'),
(7, 50,FLOOR(RAND() * 50) + 1, 7, 6, '2023-10-03', 3, 'B+'),
(12, 17,FLOOR(RAND() * 50) + 1, 1, 12, '2023-11-18', 2, 'A+'),
(1, 44,FLOOR(RAND() * 50) + 1, 19, 11, '2023-03-28', 1, 'A+'),
(6, 29,FLOOR(RAND() * 50) + 1, 16, 17, '2023-09-02', 3, 'AB+'),
(18, 6,FLOOR(RAND() * 50) + 1, 1, 7, '2023-05-20', 2, 'B-'),
(9, 21,FLOOR(RAND() * 50) + 1, 9, 2, '2023-07-15', 1, 'O+'),
(20, 42,FLOOR(RAND() * 50) + 1, 14, 6, '2023-10-12', 2, 'O+'),
(11, 15,FLOOR(RAND() * 50) + 1, 8, 14, '2023-06-07', 3, 'B+')
go

-- Insert into fact_blood_pre_process_storage
INSERT INTO fact_blood_pre_process_storage (inventory_id, donor_id, bag_id, storage_date, blood_units_stored, blood_type)
VALUES
    (1, 10,FLOOR(RAND() * 50) + 1, '2023-01-15', 5, 'A+'),
    (2, 20,FLOOR(RAND() * 50) + 1, '2023-02-20', 3, 'B-'),
    (3, 30,FLOOR(RAND() * 50) + 1, '2023-03-10', 7, 'O+'),
    (4, 40,FLOOR(RAND() * 50) + 1, '2023-04-05', 4, 'AB-'),
    (5, 50,FLOOR(RAND() * 50) + 1, '2023-05-12', 6, 'A+'),
    (6, 1,FLOOR(RAND() * 50) + 1, '2023-06-18', 2, 'B+'),
    (7, 11,FLOOR(RAND() * 50) + 1, '2023-07-25', 8, 'A-'),
    (8, 21,FLOOR(RAND() * 50) + 1, '2023-08-02', 5, 'O-'),
    (9, 1,FLOOR(RAND() * 50) + 1, '2023-09-14', 3, 'AB+'),
    (10, 11,FLOOR(RAND() * 50) + 1, '2023-10-01', 6, 'A-'),
    (11, 2,FLOOR(RAND() * 50) + 1, '2023-11-09', 4, 'B+'),
    (12, 12,FLOOR(RAND() * 50) + 1, '2023-11-20', 7, 'O-'),
    (13, 2,FLOOR(RAND() * 50) + 1, '2023-01-08', 5, 'A+'),
    (14, 12,FLOOR(RAND() * 50) + 1, '2023-02-14', 2, 'AB+'),
    (15, 2,FLOOR(RAND() * 50) + 1, '2023-03-22', 8, 'O+'),
    (16, 3,FLOOR(RAND() * 50) + 1, '2023-04-30', 6, 'A-'),
    (17, 13,FLOOR(RAND() * 50) + 1, '2023-05-09', 4, 'B-'),
    (18, 23,FLOOR(RAND() * 50) + 1, '2023-06-15', 7, 'AB-'),
    (19, 3,FLOOR(RAND() * 50) + 1, '2023-07-12', 3, 'O+'),
    (20, 13,FLOOR(RAND() * 50) + 1, '2023-08-28', 5, 'A+'),
    (1, 4,FLOOR(RAND() * 50) + 1, '2023-09-05', 2, 'B+'),
    (2, 14,FLOOR(RAND() * 50) + 1, '2023-10-18', 6, 'A-'),
    (3, 24,FLOOR(RAND() * 50) + 1, '2023-11-24', 8, 'AB-'),
    (4, 34,FLOOR(RAND() * 50) + 1, '2023-12-30', 4, 'O-'),
    (5, 44,FLOOR(RAND() * 50) + 1, '2023-01-15', 7, 'B-'),
    (6, 5,FLOOR(RAND() * 50) + 1, '2023-02-20', 3, 'A+'),
    (7, 15,FLOOR(RAND() * 50) + 1, '2023-03-28', 5, 'O+'),
    (8, 25,FLOOR(RAND() * 50) + 1, '2023-04-05', 6, 'AB+'),
    (9, 35,FLOOR(RAND() * 50) + 1, '2023-05-12', 2, 'A-'),
    (10, 45,FLOOR(RAND() * 50) + 1, '2023-06-18', 4, 'B+'),
    (11, 6,FLOOR(RAND() * 50) + 1, '2023-07-25', 8, 'O-'),
    (12, 16,FLOOR(RAND() * 50) + 1, '2023-08-02', 6, 'AB-'),
    (13, 26,FLOOR(RAND() * 50) + 1, '2023-09-14', 3, 'A+'),
    (14, 36,FLOOR(RAND() * 50) + 1, '2023-10-01', 5, 'B+'),
    (15, 46,FLOOR(RAND() * 50) + 1, '2023-11-09', 7, 'O+'),
    (16, 7,FLOOR(RAND() * 50) + 1, '2023-11-20', 2, 'A-'),
    (17, 17,FLOOR(RAND() * 50) + 1, '2023-01-08', 4, 'AB+'),
    (18, 27,FLOOR(RAND() * 50) + 1, '2023-02-14', 6, 'O+'),
    (19, 37,FLOOR(RAND() * 50) + 1, '2023-03-22', 8, 'A+'),
    (20, 47,FLOOR(RAND() * 50) + 1, '2023-04-30', 5, 'B+'),
    (1, 8,FLOOR(RAND() * 50) + 1, '2023-05-09', 3, 'AB-'),
    (2, 18,FLOOR(RAND() * 50) + 1, '2023-06-15', 7, 'A+'),
    (3, 28,FLOOR(RAND() * 50) + 1, '2023-07-12', 4, 'O-'),
    (4, 38,FLOOR(RAND() * 50) + 1, '2023-08-28', 6, 'A-'),
    (5, 48,FLOOR(RAND() * 50) + 1, '2023-09-05', 2, 'B+'),
    (6, 9,FLOOR(RAND() * 50) + 1, '2023-10-18', 8, 'O+'),
    (7, 19,FLOOR(RAND() * 50) + 1, '2023-11-24', 7, 'AB-'),
    (8, 29,FLOOR(RAND() * 50) + 1, '2023-12-30', 5, 'A+'),
    (9, 39,FLOOR(RAND() * 50) + 1, '2023-01-15', 3, 'B+'),
    (10, 49,FLOOR(RAND() * 50) + 1, '2023-02-20', 6, 'O-'),
    (11, 10,FLOOR(RAND() * 50) + 1, '2023-03-10', 7, 'A+'),
    (12, 20,FLOOR(RAND() * 50) + 1, '2023-04-05', 4, 'AB+'),
    (13, 30,FLOOR(RAND() * 50) + 1, '2023-05-12', 6, 'O+'),
    (14, 40,FLOOR(RAND() * 50) + 1, '2023-06-18', 2, 'B+'),
    (15, 1,FLOOR(RAND() * 50) + 1, '2023-07-25', 8, 'A-'),
    (16, 11,FLOOR(RAND() * 50) + 1, '2023-08-02', 5, 'O-'),
    (17, 21,FLOOR(RAND() * 50) + 1, '2023-09-14', 3, 'AB+'),
    (18, 31,FLOOR(RAND() * 50) + 1, '2023-10-01', 6, 'A-'),
    (19, 41,FLOOR(RAND() * 50) + 1, '2023-11-09', 4, 'B+'),
    (20, 2,FLOOR(RAND() * 50) + 1, '2023-11-20', 7, 'O-'),
    (1, 12,FLOOR(RAND() * 50) + 1, '2023-01-08', 5, 'A+'),
    (2, 22,FLOOR(RAND() * 50) + 1, '2023-02-14', 2, 'AB+'),
    (3, 32,FLOOR(RAND() * 50) + 1, '2023-03-22', 8, 'O+'),
    (4, 42,FLOOR(RAND() * 50) + 1, '2023-04-30', 6, 'A-'),
    (5, 3,FLOOR(RAND() * 50) + 1, '2023-05-09', 4, 'B-'),
    (6, 13,FLOOR(RAND() * 50) + 1, '2023-06-15', 7, 'AB-'),
    (7, 23,FLOOR(RAND() * 50) + 1, '2023-07-12', 3, 'O+'),
    (8, 33,FLOOR(RAND() * 50) + 1, '2023-08-28', 5, 'A+'),
    (9, 43,FLOOR(RAND() * 50) + 1, '2023-09-05', 2, 'B+'),
    (10, 4,FLOOR(RAND() * 50) + 1, '2023-10-18', 6, 'A-'),
    (11, 14,FLOOR(RAND() * 50) + 1, '2023-11-24', 8, 'AB-'),
    (12, 24,FLOOR(RAND() * 50) + 1, '2023-12-30', 4, 'O-'),
    (13, 34,FLOOR(RAND() * 50) + 1, '2023-01-15', 7, 'B-'),
    (14, 44,FLOOR(RAND() * 50) + 1, '2023-02-20', 3, 'A+'),
    (15, 5,FLOOR(RAND() * 50) + 1, '2023-03-28', 5, 'O+'),
    (16, 15,FLOOR(RAND() * 50) + 1, '2023-04-05', 6, 'AB+'),
    (17, 25,FLOOR(RAND() * 50) + 1, '2023-05-12', 2, 'A-'),
    (18, 35,FLOOR(RAND() * 50) + 1, '2023-06-18', 4, 'B+'),
    (19, 45,FLOOR(RAND() * 50) + 1, '2023-07-25', 8, 'O-'),
    (20, 6,FLOOR(RAND() * 50) + 1, '2023-08-02', 6, 'AB-')
go



-- Insert into fact_processing_disease_test
INSERT INTO fact_processing_disease_test (inventory_id, donor_id, bag_id, disease_flag, disease_type, blood_bag_approval, storage_date, blood_units_stored, blood_type)
VALUES
    (1, 10,FLOOR(RAND() * 50) + 1, 'Y', 'HIV', 'Y', '2023-01-15', 5, 'A+'),
    (2, 20,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-02-20', 3, 'B-'),
    (3, 30,FLOOR(RAND() * 50) + 1, 'N', NULL, 'N', '2023-03-10', 7, 'O+'),
    (4, 40,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-04-05', 4, 'AB-'),
    (5, 50,FLOOR(RAND() * 50) + 1, 'N', NULL, 'N', '2023-05-12', 6, 'A+'),
    (6, 1,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-06-18', 2, 'B+'),
    (7, 11,FLOOR(RAND() * 50) + 1, 'Y', 'HIV', 'N', '2023-07-25', 8, 'A-'),
    (8, 21,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-08-02', 5, 'O-'),
    (9, 31,FLOOR(RAND() * 50) + 1, 'Y', 'HIV', 'N', '2023-09-14', 3, 'AB+'),
    (10, 41,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-10-01', 6, 'A-'),
    (11, 2,FLOOR(RAND() * 50) + 1, 'N', NULL, 'N', '2023-11-09', 4, 'B+'),
    (12, 12,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-11-20', 7, 'O-'),
    (13, 22,FLOOR(RAND() * 50) + 1, 'N', NULL, 'N', '2023-01-08', 5, 'A+'),
    (14, 32,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-02-14', 2, 'AB+'),
    (15, 42,FLOOR(RAND() * 50) + 1, 'Y', 'Malaria', 'N', '2023-03-22', 8, 'O+'),
    (16, 3,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-04-30', 6, 'A-'),
    (17, 13,FLOOR(RAND() * 50) + 1, 'Y', 'Fever', 'N', '2023-05-09', 4, 'B-'),
    (18, 23,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-06-15', 7, 'AB-'),
    (19, 33,FLOOR(RAND() * 50) + 1, 'N', NULL, 'N', '2023-07-12', 3, 'O+'),
    (20, 43,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-08-28', 5, 'A+'),
    (1, 4,FLOOR(RAND() * 50) + 1, 'Y', 'Malaria', 'N', '2023-09-05', 2, 'B+'),
    (2, 14,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-10-18', 6, 'A-'),
    (3, 24,FLOOR(RAND() * 50) + 1, 'Y', 'Hepatitis B', 'N', '2023-11-24', 8, 'AB-'),
    (4, 34,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-12-30', 4, 'O-'),
    (5, 44,FLOOR(RAND() * 50) + 1, 'N', NULL, 'N', '2023-01-15', 7, 'B-'),
    (6, 5,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-02-20', 3, 'A+'),
    (7, 15,FLOOR(RAND() * 50) + 1, 'Y', 'HIV', 'N', '2023-03-28', 5, 'O+'),
    (8, 25,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-04-05', 6, 'AB+'),
    (9, 35,FLOOR(RAND() * 50) + 1, 'Y', 'Malaria', 'N', '2023-05-12', 2, 'A-'),
    (10, 45,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-06-18', 4, 'B+'),
    (11, 6,FLOOR(RAND() * 50) + 1, 'N', NULL, 'N', '2023-07-25', 8, 'O-'),
    (12, 16,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-08-02', 6, 'AB-'),
    (13, 26,FLOOR(RAND() * 50) + 1, 'N', NULL, 'N', '2023-09-14', 3, 'A+'),
    (14, 36,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-10-01', 5, 'B+'),
    (15, 46,FLOOR(RAND() * 50) + 1, 'Y', 'Malaria', 'N', '2023-11-09', 7, 'O+'),
    (16, 7,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-11-20', 2, 'A-'),
    (17, 17,FLOOR(RAND() * 50) + 1, 'Y', 'HIV', 'N', '2023-01-08', 4, 'AB+'),
    (18, 27,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-02-14', 6, 'O+'),
    (19, 37,FLOOR(RAND() * 50) + 1, 'N', NULL, 'N', '2023-03-22', 8, 'A+'),
    (20, 47,FLOOR(RAND() * 50) + 1, 'N', NULL, 'Y', '2023-04-30', 5, 'B+')
go


--Insert into Fact Processing Centrifuge
INSERT INTO Fact_Processing_Centrifuge (inventory_id, donor_id, bag_id, component_id, processing_date, blood_units_stored, blood_type)
VALUES
    (FLOOR(RAND() * 20)+ 1, 10, FLOOR(RAND() * 50)+ 1, 1, '2023-01-15', 5, 'A+'),
    (FLOOR(RAND() * 20)+ 1, 20, FLOOR(RAND() * 50)+ 1, 2, '2023-02-20', 3, 'B-'),
    (FLOOR(RAND() * 20)+ 1, 30, FLOOR(RAND() * 50)+ 1, 3, '2023-03-10', 7, 'O+'),
    (FLOOR(RAND() * 20)+ 1, 40, FLOOR(RAND() * 50)+ 1, 1, '2023-04-05', 4, 'AB-'),
    (FLOOR(RAND() * 20)+ 1, 50, FLOOR(RAND() * 50)+ 1, 2, '2023-05-12', 6, 'A+'),
    (FLOOR(RAND() * 20)+ 1, 1, FLOOR(RAND() * 50)+ 1, 3, '2023-06-18', 2, 'B+'),
    (FLOOR(RAND() * 20)+ 1, 11, FLOOR(RAND() * 50)+ 1, 1, '2023-07-25', 8, 'A-'),
    (FLOOR(RAND() * 20)+ 1, 21, FLOOR(RAND() * 50)+ 1, 2, '2023-08-02', 5, 'O-'),
    (FLOOR(RAND() * 20)+ 1, 31, FLOOR(RAND() * 50)+ 1, 3, '2023-09-14', 3, 'AB+'),
    (FLOOR(RAND() * 20)+ 1, 41,FLOOR(RAND() * 50)+ 1, 1, '2023-10-01', 6, 'A-'),
    (FLOOR(RAND() * 20)+ 1, 2, FLOOR(RAND() * 50)+ 1, 2, '2023-11-09', 4, 'B+'),
    (FLOOR(RAND() * 20)+ 1, 12,FLOOR(RAND() * 50)+ 1, 3, '2023-11-20', 7, 'O-'),
    (FLOOR(RAND() * 20)+ 1, 22,FLOOR(RAND() * 50)+ 1, 1, '2023-01-08', 5, 'A+'),
    (FLOOR(RAND() * 20)+ 1, 32,FLOOR(RAND() * 50)+ 1, 2, '2023-02-14', 2, 'AB+'),
    (FLOOR(RAND() * 20)+ 1, 42,FLOOR(RAND() * 50)+ 1, 3, '2023-03-22', 8, 'O+'),
    (FLOOR(RAND() * 20)+ 1, 3, FLOOR(RAND() * 50)+ 1, 1, '2023-04-30', 6, 'A-'),
    (FLOOR(RAND() * 20)+ 1, 13,FLOOR(RAND() * 50)+ 1, 2, '2023-05-09', 4, 'B-'),
    (FLOOR(RAND() * 20)+ 1, 23,FLOOR(RAND() * 50)+ 1, 3, '2023-06-15', 7, 'AB-'),
    (FLOOR(RAND() * 20)+ 1, 33,FLOOR(RAND() * 50)+ 1, 1, '2023-07-12', 3, 'O+'),
    (FLOOR(RAND() * 20)+ 1, 43,FLOOR(RAND() * 50)+ 1, 2, '2023-08-28', 5, 'A+'),
    (FLOOR(RAND() * 20)+ 1, 4, FLOOR(RAND() * 50)+ 1, 3, '2023-09-05', 2, 'B+'),
    (FLOOR(RAND() * 20)+ 1, 14,FLOOR(RAND() * 50)+ 1, 1, '2023-10-18', 6, 'A-'),
    (FLOOR(RAND() * 20)+ 1, 24,FLOOR(RAND() * 50)+ 1, 2, '2023-11-24', 8, 'AB-'),
    (FLOOR(RAND() * 20)+ 1, 34,FLOOR(RAND() * 50)+ 1, 3, '2023-12-30', 4, 'O-'),
    (FLOOR(RAND() * 20)+ 1, 44,FLOOR(RAND() * 50)+ 1, 1, '2023-01-15', 7, 'B-'),
    (FLOOR(RAND() * 20)+ 1, 5, FLOOR(RAND() * 50)+ 1, 2, '2023-02-20', 3, 'A+'),
    (FLOOR(RAND() * 20)+ 1, 15,FLOOR(RAND() * 50)+ 1, 3, '2023-03-28', 5, 'O+'),
    (FLOOR(RAND() * 20)+ 1, 25,FLOOR(RAND() * 50)+ 1, 1, '2023-04-05', 6, 'AB+'),
    (FLOOR(RAND() * 20)+ 1, 35,FLOOR(RAND() * 50)+ 1, 2, '2023-05-12', 2, 'A-'),
    (FLOOR(RAND() * 20)+ 1, 45,FLOOR(RAND() * 50)+ 1, 3, '2023-06-18', 4, 'B+'),
    (FLOOR(RAND() * 20)+ 1, 6, FLOOR(RAND() * 50)+ 1, 1, '2023-07-25', 8, 'O-'),
    (FLOOR(RAND() * 20)+ 1, 16,FLOOR(RAND() * 50)+ 1, 2, '2023-08-02', 6, 'AB-'),
    (FLOOR(RAND() * 20)+ 1, 26,FLOOR(RAND() * 50)+ 1, 3, '2023-09-14', 3, 'A+'),
    (FLOOR(RAND() * 20)+ 1, 36,FLOOR(RAND() * 50)+ 1, 1, '2023-10-01', 5, 'B+'),
    (FLOOR(RAND() * 20)+ 1, 46,FLOOR(RAND() * 50)+ 1, 2, '2023-11-09', 7, 'O+'),
    (FLOOR(RAND() * 20)+ 1, 7, FLOOR(RAND() * 50)+ 1, 3, '2023-11-20', 2, 'A-'),
    (FLOOR(RAND() * 20)+ 1, 17,FLOOR(RAND() * 50)+ 1, 1, '2023-01-08', 4, 'AB+'),
    (FLOOR(RAND() * 20)+ 1, 27,FLOOR(RAND() * 50)+ 1, 2, '2023-02-14', 6, 'O+'),
    (FLOOR(RAND() * 20)+ 1, 37,FLOOR(RAND() * 50)+ 1, 3, '2023-03-22', 8, 'A+'),
    (FLOOR(RAND() * 20)+ 1, 47,FLOOR(RAND() * 50)+ 1, 1, '2023-04-30', 5, 'B+'),
    (FLOOR(RAND() * 20)+ 1, 8, FLOOR(RAND() * 50)+ 1, 2, '2023-05-09', 3, 'AB-'),
    (FLOOR(RAND() * 20)+ 1, 18,FLOOR(RAND() * 50)+ 1, 3, '2023-06-15', 7, 'A+'),
    (FLOOR(RAND() * 20)+ 1, 28,FLOOR(RAND() * 50)+ 1, 1, '2023-07-12', 4, 'O-'),
    (FLOOR(RAND() * 20)+ 1, 38,FLOOR(RAND() * 50)+ 1, 2, '2023-08-28', 6, 'A-'),
    (FLOOR(RAND() * 20)+ 1, 48,FLOOR(RAND() * 50)+ 1, 3, '2023-09-05', 2, 'B+'),
    (FLOOR(RAND() * 20)+ 1, 9, FLOOR(RAND() * 50)+ 1, 1, '2023-10-18', 8, 'O+'),
    (FLOOR(RAND() * 20)+ 1, 19,FLOOR(RAND() * 50)+ 1, 2, '2023-11-24', 7, 'AB-'),
    (FLOOR(RAND() * 20)+ 1, 29,FLOOR(RAND() * 50)+ 1, 3, '2023-12-30', 5, 'A+'),
    (FLOOR(RAND() * 20)+ 1, 39,FLOOR(RAND() * 50)+ 1, 1, '2023-01-15', 3, 'B+'),
    (FLOOR(RAND() * 20)+ 1, 49,FLOOR(RAND() * 50)+ 1, 2, '2023-02-20', 6, 'O-');
    Go




-- Insert into fact_storage_inventory
INSERT INTO fact_storage_inventory (inventory_id, bag_id, component_id, storage_date, blood_units_stored, blood_type)
VALUES
    (1, 10, 1, '2023-01-15', 5, 'A+'),
    (2, 20, 2, '2023-02-20', 3, 'B-'),
    (3, 30, 3, '2023-03-10', 7, 'O+'),
    (4, 40, 1, '2023-04-05', 4, 'AB-'),
    (5, 50, 2, '2023-05-12', 6, 'A+'),
    (6, 1, 3, '2023-06-18', 2, 'B+'),
    (7, 11, 1, '2023-07-25', 8, 'A-'),
    (8, 21, 2, '2023-08-02', 5, 'O-'),
    (9, 31, 3, '2023-09-14', 3, 'AB+'),
    (10, 41, 1, '2023-10-01', 6, 'A-'),
    (11, 2, 2, '2023-11-09', 4, 'B+'),
    (12, 12, 3, '2023-11-20', 7, 'O-'),
    (13, 22, 1, '2023-01-08', 5, 'A+'),
    (14, 32, 2, '2023-02-14', 2, 'AB+'),
    (15, 42, 3, '2023-03-22', 8, 'O+'),
    (16, 3, 1, '2023-04-30', 6, 'A-'),
    (17, 13, 2, '2023-05-09', 4, 'B-'),
    (18, 23, 3, '2023-06-15', 7, 'AB-'),
    (19, 33, 1, '2023-07-12', 3, 'O+'),
    (20, 43, 2, '2023-08-28', 5, 'A+'),
    (1, 4, 3, '2023-09-05', 2, 'B+'),
    (2, 14, 1, '2023-10-18', 6, 'A-'),
    (3, 24, 2, '2023-11-24', 8, 'AB-'),
    (4, 34, 3, '2023-12-30', 4, 'O-'),
    (5, 44, 1, '2023-01-15', 7, 'B-'),
    (6, 5, 2, '2023-02-20', 3, 'A+'),
    (7, 15, 3, '2023-03-28', 5, 'O+'),
    (8, 25, 1, '2023-04-05', 6, 'AB+'),
    (9, 35, 2, '2023-05-12', 2, 'A-'),
    (10, 45, 3, '2023-06-18', 4, 'B+'),
    (11, 6, 1, '2023-07-25', 8, 'O-'),
    (12, 16, 2, '2023-08-02', 6, 'AB-'),
    (13, 26, 3, '2023-09-14', 3, 'A+'),
    (14, 36, 1, '2023-10-01', 5, 'B+'),
    (15, 46, 2, '2023-11-09', 7, 'O+'),
    (16, 7, 3, '2023-11-20', 2, 'A-'),
    (17, 17, 1, '2023-01-08', 4, 'AB+'),
    (18, 27, 2, '2023-02-14', 6, 'O+'),
    (19, 37, 3, '2023-03-22', 8, 'A+'),
    (20, 47, 1, '2023-04-30', 5, 'B+'),
    (1, 8, 2, '2023-05-09', 3, 'AB-'),
    (2, 18, 3, '2023-06-15', 7, 'A+'),
    (3, 28, 1, '2023-07-12', 5, 'B-'),
    (4, 38, 2, '2023-08-28', 2, 'O-'),
    (5, 48, 3, '2023-09-05', 6, 'A+'),
    (6, 9, 1, '2023-10-18', 4, 'AB+'),
    (7, 19, 2, '2023-11-24', 8, 'O+'),
    (8, 29, 3, '2023-12-30', 6, 'A-'),
    (9, 39, 1, '2023-01-15', 3, 'B-'),
    (10, 49, 2, '2023-02-20', 5, 'O+')
go 



INSERT INTO fact_blood_requests (request_id, hospital_id, blood_type_requested, blood_component_requested, blood_type, units_requested, request_date, hospital_staff_id)
VALUES
    (1, FLOOR(RAND() * 10) + 1, 'A+', 'Whole Blood', 'A+', 5, '2023-01-15', 201),
    (2, FLOOR(RAND() * 10) + 1, 'B-', 'Platelets', 'B-', 3, '2023-02-20', 202),
    (3, FLOOR(RAND() * 10) + 1, 'O+', 'Plasma', 'O+', 7, '2023-03-10', 203),
    (4, FLOOR(RAND() * 10) + 1, 'AB-', 'Red Blood Cells', 'AB-', 4, '2023-04-05', 204),
    (5, FLOOR(RAND() * 10) + 1, 'A+', 'Whole Blood', 'A+', 6, '2023-05-12', 205),
    (6, FLOOR(RAND() * 10) + 1, 'B+', 'Platelets', 'B+', 2, '2023-06-18', 206),
    (7, FLOOR(RAND() * 10) + 1, 'A-', 'Plasma', 'A-', 8, '2023-07-25', 207),
    (8, FLOOR(RAND() * 10) + 1, 'O-', 'Red Blood Cells', 'O-', 5, '2023-08-02', 208),
    (9, FLOOR(RAND() * 10) + 1, 'AB+', 'Whole Blood', 'AB+', 3, '2023-09-14', 209),
    (10,FLOOR(RAND() * 10) + 1, 'A-', 'Platelets', 'A-', 6, '2023-10-01', 210),
    (11,FLOOR(RAND() * 10) + 1, 'B+', 'Plasma', 'B+', 4, '2023-11-09', 211),
    (12,FLOOR(RAND() * 10) + 1, 'O+', 'Red Blood Cells', 'O+', 7, '2023-11-20', 212),
    (13,FLOOR(RAND() * 10) + 1, 'AB+', 'Whole Blood', 'AB+', 5, '2023-01-08', 213),
    (14,FLOOR(RAND() * 10) + 1, 'A+', 'Platelets', 'A+', 2, '2023-02-14', 214),
    (15,FLOOR(RAND() * 10) + 1, 'B-', 'Plasma', 'B-', 8, '2023-03-22', 215),
    (16,FLOOR(RAND() * 10) + 1, 'O-', 'Red Blood Cells', 'O-', 6, '2023-04-30', 216),
    (17,FLOOR(RAND() * 10) + 1, 'AB+', 'Whole Blood', 'AB+', 4, '2023-05-09', 217),
    (18,FLOOR(RAND() * 10) + 1, 'A-', 'Platelets', 'A-', 7, '2023-06-15', 218),
    (19,FLOOR(RAND() * 10) + 1, 'B+', 'Plasma', 'B+', 3, '2023-07-12', 219),
    (20,FLOOR(RAND() * 10) + 1, 'O+', 'Red Blood Cells', 'O+', 5, '2023-08-28', 220),
    (21,FLOOR(RAND() * 10) + 1, 'AB-', 'Whole Blood', 'AB-', 6, '2023-09-05', 221),
    (22,FLOOR(RAND() * 10) + 1, 'A+', 'Platelets', 'A+', 8, '2023-10-18', 222),
    (23,FLOOR(RAND() * 10) + 1, 'B-', 'Plasma', 'B-', 2, '2023-11-24', 223),
    (24,FLOOR(RAND() * 10) + 1, 'O-', 'Red Blood Cells', 'O-', 7, '2023-12-30', 224),
    (25,FLOOR(RAND() * 10) + 1, 'AB-', 'Whole Blood', 'AB-', 5, '2023-01-15', 225),
    (26,FLOOR(RAND() * 10) + 1, 'A-', 'Platelets', 'A-', 3, '2023-02-20', 226),
    (27,FLOOR(RAND() * 10) + 1, 'B+', 'Plasma', 'B+', 5, '2023-03-28', 227),
    (28,FLOOR(RAND() * 10) + 1, 'O+', 'Red Blood Cells', 'O+', 6, '2023-04-05', 228),
    (29,FLOOR(RAND() * 10) + 1, 'AB-', 'Whole Blood', 'AB-', 2, '2023-05-12', 229),
    (30,FLOOR(RAND() * 10) + 1, 'A+', 'Platelets', 'A+', 4, '2023-06-18', 230),
    (31,FLOOR(RAND() * 10) + 1, 'B-', 'Plasma', 'B-', 6, '2023-07-25', 231),
    (32,FLOOR(RAND() * 10) + 1, 'O-', 'Red Blood Cells', 'O-', 3, '2023-08-02', 232),
    (33,FLOOR(RAND() * 10) + 1, 'AB+', 'Whole Blood', 'AB+', 7, '2023-09-14', 233),
    (34,FLOOR(RAND() * 10) + 1, 'A+', 'Platelets', 'A+', 4, '2023-10-01', 234),
    (35,FLOOR(RAND() * 10) + 1, 'B+', 'Plasma', 'B+', 8, '2023-11-09', 235),
    (36,FLOOR(RAND() * 10) + 1, 'O+', 'Red Blood Cells', 'O+', 5, '2023-11-20', 236),
    (37,FLOOR(RAND() * 10) + 1, 'AB+', 'Whole Blood', 'AB+', 3, '2023-01-08', 237),
    (38,FLOOR(RAND() * 10) + 1, 'A-', 'Platelets', 'A-', 6, '2023-02-14', 238),
    (39,FLOOR(RAND() * 10) + 1, 'B+', 'Plasma', 'B+', 2, '2023-03-22', 239),
    (40,FLOOR(RAND() * 10) + 1, 'O+', 'Red Blood Cells', 'O+', 7, '2023-04-30', 240),
    (41,FLOOR(RAND() * 10) + 1, 'AB+', 'Whole Blood', 'AB+', 5, '2023-05-09', 241),
    (42,FLOOR(RAND() * 10) + 1, 'A+', 'Platelets', 'A+', 8, '2023-06-15', 242),
    (43,FLOOR(RAND() * 10) + 1, 'B-', 'Plasma', 'B-', 3, '2023-07-12', 243),
    (44,FLOOR(RAND() * 10) + 1, 'O-', 'Red Blood Cells', 'O-', 6, '2023-08-28', 244),
    (45,FLOOR(RAND() * 10) + 1, 'AB+', 'Whole Blood', 'AB+', 4, '2023-09-05', 245),
    (46,FLOOR(RAND() * 10) + 1, 'A-', 'Platelets', 'A-', 7, '2023-10-18', 246),
    (47,FLOOR(RAND() * 10) + 1, 'B+', 'Plasma', 'B+', 5, '2023-11-24', 247),
    (48,FLOOR(RAND() * 10) + 1, 'O+', 'Red Blood Cells', 'O+', 2, '2023-12-30', 248),
    (49,FLOOR(RAND() * 10) + 1, 'AB-', 'Whole Blood', 'AB-', 6, '2023-01-15', 249),
    (50,FLOOR(RAND() * 10) + 1, 'A+', 'Platelets', 'A+', 3, '2023-02-20', 250)
go


INSERT INTO fact_hospital_requests (request_id, hospital_id, patient_id, incident_type, priority, blood_type_requested, blood_component_requested, blood_type, units_requested, cost_per_unit, request_date, hospital_staff_id)
VALUES
    (1, FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'A+', 'Whole Blood', 'A+', 5, 150.00, '2023-01-15', 201),
    (2, FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'B-', 'Platelets', 'B-', 3, 200.00, '2023-02-20', 202),
    (3, FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'O+', 'Plasma', 'O+', 7, 180.00, '2023-03-10', 203),
    (4, FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'AB-', 'Red Blood Cells', 'AB-', 4, 220.00, '2023-04-05', 204),
    (5, FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'A+', 'Whole Blood', 'A+', 6, 150.00, '2023-05-12', 205),
    (6, FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'B+', 'Platelets', 'B+', 2, 200.00, '2023-06-18', 206),
    (7, FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'A-', 'Plasma', 'A-', 8, 180.00, '2023-07-25', 207),
    (8, FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'O-', 'Red Blood Cells', 'O-', 5, 220.00, '2023-08-02', 208),
    (9, FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'AB+', 'Whole Blood', 'AB+', 3, 150.00, '2023-09-14', 209),
    (10,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'A-', 'Platelets', 'A-', 6, 200.00, '2023-10-01', 210),
    (11,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'B+', 'Plasma', 'B+', 4, 180.00, '2023-11-09', 211),
    (12,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'O+', 'Red Blood Cells', 'O+', 7, 220.00, '2023-11-20', 212),
    (13,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'AB+', 'Whole Blood', 'AB+', 5, 150.00, '2023-01-08', 213),
    (14,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'A+', 'Platelets', 'A+', 2, 200.00, '2023-02-14', 214),
    (15,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'B-', 'Plasma', 'B-', 8, 180.00, '2023-03-22', 215),
    (16,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'O-', 'Red Blood Cells', 'O-', 6, 220.00, '2023-04-30', 216),
    (17,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'AB+', 'Whole Blood', 'AB+', 4, 150.00, '2023-05-09', 217),
    (18,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'A-', 'Platelets', 'A-', 7, 200.00, '2023-06-15', 218),
    (19,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'B+', 'Plasma', 'B+', 3, 180.00, '2023-07-12', 219),
    (20,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'O+', 'Red Blood Cells', 'O+', 5, 220.00, '2023-08-28', 220),
    (21,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'AB-', 'Whole Blood', 'AB-', 6, 150.00, '2023-09-05', 221),
    (22,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'A+', 'Platelets', 'A+', 8, 200.00, '2023-10-18', 222),
    (23,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'B-', 'Plasma', 'B-', 2, 180.00, '2023-11-24', 223),
    (24,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'O-', 'Red Blood Cells', 'O-', 7, 220.00, '2023-12-30', 224),
    (25,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'AB-', 'Whole Blood', 'AB-', 5, 150.00, '2023-01-15', 225),
    (26,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'A-', 'Platelets', 'A-', 3, 200.00, '2023-02-20', 226),
    (27,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'B+', 'Plasma', 'B+', 5, 180.00, '2023-03-28', 227),
    (28,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'O+', 'Red Blood Cells', 'O+', 6, 220.00, '2023-04-05', 228),
    (29,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'AB-', 'Whole Blood', 'AB-', 2, 150.00, '2023-05-12', 229),
    (30,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'A+', 'Platelets', 'A+', 4, 200.00, '2023-06-18', 230),
    (31,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'B-', 'Plasma', 'B-', 6, 180.00, '2023-07-25', 231),
    (32,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'O-', 'Red Blood Cells', 'O-', 3, 220.00, '2023-08-02', 232),
    (33,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'AB+', 'Whole Blood', 'AB+', 7, 150.00, '2023-09-14', 233),
    (34,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'A-', 'Platelets', 'A-', 5, 200.00, '2023-10-01', 234),
    (35,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'B+', 'Plasma', 'B+', 8, 180.00, '2023-11-09', 235),
    (36,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'O+', 'Red Blood Cells', 'O+', 4, 220.00, '2023-11-20', 236),
    (37,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'AB+', 'Whole Blood', 'AB+', 3, 150.00, '2023-01-08', 237),
    (38,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'A+', 'Platelets', 'A+', 7, 200.00, '2023-02-14', 238),
    (39,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'B-', 'Plasma', 'B-', 6, 180.00, '2023-03-22', 239),
    (40,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'O-', 'Red Blood Cells', 'O-', 5, 220.00, '2023-04-30', 240),
    (41,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'AB+', 'Whole Blood', 'AB+', 2, 150.00, '2023-05-09', 241),
    (42,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'A-', 'Platelets', 'A-', 8, 200.00, '2023-06-15', 242),
    (43,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'B+', 'Plasma', 'B+', 4, 180.00, '2023-07-12', 243),
    (44,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'O+', 'Red Blood Cells', 'O+', 6, 220.00, '2023-08-28', 244),
    (45,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'AB-', 'Whole Blood', 'AB-', 7, 150.00, '2023-09-05', 245),
    (46,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'A+', 'Platelets', 'A+', 3, 200.00, '2023-10-18', 246),
    (47,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'B-', 'Plasma', 'B-', 5, 180.00, '2023-11-24', 247),
    (48,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'O-', 'Red Blood Cells', 'O-', 6, 220.00, '2023-12-30', 248),
    (49,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'AB-', 'Whole Blood', 'AB-', 8, 150.00, '2023-01-15', 249),
    (50,FLOOR(RAND() * 10) + 1,FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'A+', 'Platelets', 'A+', 3, 200.00, '2023-02-20',250)
go


INSERT INTO fact_patient_to_hospital (incident_request_id,hospital_id,patient_id,incident_type,priority,blood_type_requested,blood_component_requested,blood_type,units_requested,cost_per_unit,request_date)
VALUES
    (1, FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'A+', 'Whole Blood', 'A+', 5, 150.00, '2023-01-15'),
    (2, FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'B-', 'Platelets', 'B-', 3, 200.00, '2023-02-20'),
    (3, FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'O+', 'Plasma', 'O+', 7, 180.00, '2023-03-10'),
    (4, FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'AB+', 'Whole Blood', 'AB+', 6, 150.00, '2023-04-05'),
    (5, FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'A-', 'Platelets', 'A-', 4, 200.00, '2023-05-18'),
    (6, FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'B+', 'Plasma', 'B+', 8, 180.00, '2023-06-22'),
    (7, FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'O-', 'Red Blood Cells', 'O-', 5, 220.00, '2023-07-30'),
    (8, FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'AB-', 'Whole Blood', 'AB-', 7, 150.00, '2023-08-12'),
    (9, FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'A+', 'Platelets', 'A+', 3, 200.00, '2023-09-25'),
    (10,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'B-', 'Plasma', 'B-', 6, 180.00, '2023-10-08'),
    (11,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'O+', 'Red Blood Cells', 'O+', 4, 220.00, '2023-11-15'),
    (12,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'AB+', 'Whole Blood', 'AB+', 5, 150.00, '2023-12-22'),
    (13,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'A-', 'Platelets', 'A-', 8, 200.00, '2023-01-08'),
    (14,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'B+', 'Plasma', 'B+', 7, 180.00, '2023-02-14'),
    (15,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'O-', 'Red Blood Cells', 'O-', 3, 220.00, '2023-03-28'),
    (16,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'AB-', 'Whole Blood', 'AB-', 6, 150.00, '2023-04-10'),
    (17,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'A+', 'Platelets', 'A+', 5, 200.00, '2023-05-18'),
    (18,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'B-', 'Plasma', 'B-', 4, 180.00, '2023-06-25'),
    (19,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'O+', 'Red Blood Cells', 'O+', 7, 220.00, '2023-07-08'),
    (20,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'AB+', 'Whole Blood', 'AB+', 8, 150.00, '2023-08-15'),
    (21,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'A-', 'Platelets', 'A-', 3, 200.00, '2023-09-22'),
    (22,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'B+', 'Plasma', 'B+', 5, 180.00, '2023-10-05'),
    (23,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'O-', 'Red Blood Cells', 'O-', 4, 220.00, '2023-11-12'),
    (24,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'AB-', 'Whole Blood', 'AB-', 6, 150.00, '2023-11-20'),
    (25,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'A+', 'Platelets', 'A+', 8, 200.00, '2023-01-15'),
    (26,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'B-', 'Plasma', 'B-', 7, 180.00, '2023-02-28'),
    (27,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'O+', 'Red Blood Cells', 'O+', 3, 220.00, '2023-03-10'),
    (28,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'AB+', 'Whole Blood', 'AB+', 5, 150.00, '2023-04-18'),
    (29,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'A-', 'Platelets', 'A-', 6, 200.00, '2023-05-25'),
    (30,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'B+', 'Plasma', 'B+', 4, 180.00, '2023-06-22'),
    (31,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'O-', 'Red Blood Cells', 'O-', 7, 220.00, '2023-07-08'),
    (32,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'AB-', 'Whole Blood', 'AB-', 8, 150.00, '2023-08-15'),
    (33,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'AB+', 'Platelets', 'AB+', 7, 200.00, '2023-09-14'),
    (34,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'A-', 'Plasma', 'A-', 5, 180.00, '2023-10-01'),
    (35,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'B+', 'Red Blood Cells', 'B+', 8, 220.00, '2023-11-18'),
    (36,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'O+', 'Whole Blood', 'O+', 6, 150.00, '2023-12-05'),
    (37,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'AB-', 'Platelets', 'AB-', 4, 200.00, '2023-01-12'),
    (38,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'A+', 'Plasma', 'A+', 3, 180.00, '2023-02-25'),
    (39,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'B-', 'Red Blood Cells', 'B-', 5, 220.00, '2023-03-10'),
    (40,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'O-', 'Whole Blood', 'O-', 7, 150.00, '2023-04-15'),
    (41,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'AB+', 'Platelets', 'AB+', 6, 200.00, '2023-05-22'),
    (42,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'A-', 'Plasma', 'A-', 8, 180.00, '2023-06-28'),
    (43,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'B+', 'Red Blood Cells', 'B+', 4, 220.00, '2023-07-12'),
    (44,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'O+', 'Whole Blood', 'O+', 3, 150.00, '2023-08-20'),
    (45,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'AB-', 'Platelets', 'AB-', 5, 200.00, '2023-09-28'),
    (46,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'A+', 'Plasma', 'A+', 7, 180.00, '2023-10-15'),
    (47,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'B-', 'Red Blood Cells', 'B-', 6, 220.00, '2023-11-22'),
    (48,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Trauma', 'High', 'O+', 'Whole Blood', 'O+', 5, 150.00, '2023-12-30'),
    (49,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Emergency', 'High', 'AB-', 'Platelets', 'AB-', 8, 200.00, '2023-01-15'),
    (50,FLOOR(RAND() * 10) + 1, FLOOR(RAND() * 30) + 1, 'Surgery', 'Medium', 'A+', 'Plasma', 'A+', 3, 180.00, '2023-02-20')
go


-----------------------------------------------------------> Stored Procedure


--1---------Procedure 1
DROP PROCEDURE IF EXISTS InsertBloodRequest
GO


CREATE PROCEDURE InsertBloodRequest (
    @request_id INT,
    @hospital_id INT,
    @blood_type_requested NVARCHAR(255),
    @blood_component_requested NVARCHAR(255),
    @blood_type NVARCHAR(255),
    @units_requested INT,
    @request_date DATE,
    @hospital_staff_id INT )
AS
BEGIN

    BEGIN
    -- Check if the hospital exists
    IF NOT EXISTS (SELECT 1 FROM dim_hospital WHERE hospital_id = @hospital_id) THROW 50001,'Wrong Hospital ID Entered',1;
    END

    BEGIN   
    -- Check if the blood type is valid (You may have a reference table for valid blood types)
    IF NOT EXISTS (SELECT 1 FROM dim_blood_collection WHERE blood_type = @blood_type) THROW 50002,'Wrong Blood Type Entered',1;

    END

    BEGIN
    -- Check if the blood component is valid (You may have a reference table for valid components)
    IF NOT EXISTS (SELECT 1 FROM dim_component WHERE component_name = @blood_component_requested) THROW 50003,'Wrong Blood Component Entered',1;
    END

    -- Insert the blood request
    INSERT INTO fact_blood_requests (request_id,hospital_id, blood_type_requested, blood_component_requested, blood_type, units_requested, request_date, hospital_staff_id)
    VALUES (@request_id,@hospital_id, @blood_type_requested, @blood_component_requested, @blood_type, @units_requested, @request_date, @hospital_staff_id);
END;
GO

 --EXEC InsertBloodRequest 
 --    @request_id = 60,
 --    @hospital_id  = 2,
 --    @blood_type_requested  = 'AB-',
 --    @blood_component_requested = 'Platelets' ,
 --    @blood_type = 'AB-' ,
 --    @units_requested = 6 ,
 --    @request_date = '2023-12-12',
 --    @hospital_staff_id = 210  
 --GO


-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS InsertPatientToHospital;
GO

-- Create the procedure
CREATE PROCEDURE InsertPatientToHospital (
    @incident_request_id INT,
    @hospital_id INT,
    @patient_id INT,
    @incident_type VARCHAR(50),
    @priority VARCHAR(20),
    @blood_type_requested VARCHAR(5),
    @blood_component_requested VARCHAR(20),
    @blood_type VARCHAR(5),
    @units_requested INT,
    @cost_per_unit DECIMAL(10, 2),
    @request_date DATE
)
AS
BEGIN
    BEGIN
        -- Check if the hospital exists
        IF NOT EXISTS (SELECT 1 FROM dim_hospital WHERE hospital_id = @hospital_id)
        THROW 50001, 'Wrong Hospital ID Entered', 1;
    END

    BEGIN
        -- Check if the patient exists
        IF NOT EXISTS (SELECT 1 FROM dim_recipient WHERE recipient_id = @patient_id)
        THROW 50002, 'Wrong Patient ID Entered', 1;
    END

    -- Insert the patient to hospital record
    INSERT INTO fact_patient_to_hospital (
        incident_request_id,
        hospital_id,
        patient_id,
        incident_type,
        priority,
        blood_type_requested,
        blood_component_requested,
        blood_type,
        units_requested,
        cost_per_unit,
        request_date
    )
    VALUES (
        @incident_request_id,
        @hospital_id,
        @patient_id,
        @incident_type,
        @priority,
        @blood_type_requested,
        @blood_component_requested,
        @blood_type,
        @units_requested,
        @cost_per_unit,
        @request_date
    );
END;
GO

 --EXEC InsertPatientToHospital
 --    @incident_request_id = 1,
 --    @hospital_id  = 3,
 --    @patient_id  = 10,
 --    @incident_type = 'Emergency',
 --    @priority = 'High',
 --    @blood_type_requested = 'O+',
 --    @blood_component_requested = 'Whole Blood',
 --    @blood_type = 'O+',
 --    @units_requested = 4,
 --    @cost_per_unit = 150.00,
 --    @request_date = '2023-12-15'
 --GO

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS InsertBloodDonationDrive;
GO

-- Create the procedure
CREATE PROCEDURE InsertBloodDonationDrive (
    @camp_id INT,
    @donor_id INT,
    @bag_id INT,
    @staff_id INT,
    @inventory_id INT,
    @collection_date DATE,
    @blood_units_collected INT,
    @blood_type VARCHAR(5)
)
AS
BEGIN
    BEGIN
        -- Check if the blood donation camp exists
        IF NOT EXISTS (SELECT 1 FROM dim_camp WHERE camp_id = @camp_id)
        THROW 50001, 'Wrong Blood Donation Camp ID Entered', 1;
    END

    BEGIN
        -- Check if the donor exists
        IF NOT EXISTS (SELECT 1 FROM dim_donor WHERE donor_id = @donor_id)
        THROW 50002, 'Wrong Donor ID Entered', 1;
    END

    BEGIN
        -- Check if the staff exists
        IF NOT EXISTS (SELECT 1 FROM dim_staff WHERE staff_id = @staff_id)
        THROW 50003, 'Wrong Staff ID Entered', 1;
    END

    BEGIN
        -- Check if the inventory exists
        IF NOT EXISTS (SELECT 1 FROM dim_inventory WHERE inventory_id = @inventory_id)
        THROW 50004, 'Wrong Inventory ID Entered', 1;
    END

    BEGIN
        -- Check if the blood collection bag exists
        IF NOT EXISTS (SELECT 1 FROM dim_blood_collection WHERE bag_id = @bag_id)
        THROW 50005, 'Wrong Blood Collection Bag ID Entered', 1;
    END

    -- Insert the blood donation drive record
    INSERT INTO fact_blood_donation_drive (
        camp_id,
        donor_id,
        bag_id,
        staff_id,
        inventory_id,
        collection_date,
        blood_units_collected,
        blood_type
    )
    VALUES (
        @camp_id,
        @donor_id,
        @bag_id,
        @staff_id,
        @inventory_id,
        @collection_date,
        @blood_units_collected,
        @blood_type
    );
END;
GO

 --EXEC InsertBloodDonationDrive
 --    @camp_id = 1,
 --    @donor_id = 44,
 --    @bag_id = 41,
 --    @staff_id = 19,
 --    @inventory_id = 14,
 --    @collection_date = '2023-12-20',
 --    @blood_units_collected = 3,
 --    @blood_type = 'A+'
 --GO


----------------------------------------------------------> Views


-- Create the vw_blood_donation_drive_details view
-- Create the vw_blood_donation_drive_details view with a join on bag_id
-- Create the vw_blood_donation_drive_details view with a join on bag_id
CREATE VIEW vw_blood_donation_drive_details AS
SELECT
    dd.first_name AS donor_first_name,
    dd.last_name AS donor_last_name,
    ds.first_name AS staff_first_name,
    ds.last_name AS staff_last_name,
    di.storage_unit_name,
    di.storage_location,
    bd.collection_date,
    bd.blood_units_collected,
    bd.blood_type,
    -- Include columns from the dim_blood_disease table
    bdisease.disease,
    bdisease.disease_status
FROM
    fact_blood_donation_drive bd
JOIN dim_donor dd ON bd.donor_id = dd.donor_id
JOIN dim_staff ds ON bd.staff_id = ds.staff_id
JOIN dim_inventory di ON bd.inventory_id = di.inventory_id
-- Join on bag_id to include columns from dim_blood_disease
LEFT JOIN dim_blood_disease bdisease ON bd.bag_id = bdisease.bag_id;
GO



-- Create the vw_blood_requests_from_hospitals view
CREATE VIEW vw_blood_requests_from_hospitals AS
SELECT
    dh.hospital_name,
    br.blood_type_requested,
    br.blood_component_requested,
    br.units_requested,
    br.request_date,
    br.hospital_staff_id,
	concat(hs.first_name,' ',hs.last_name) as hospital_staff_name
FROM
    fact_blood_requests br
JOIN dim_hospital dh ON br.hospital_id = dh.hospital_id
JOIN dim_hospital_staff_details hs ON br.hospital_staff_id = hs.hospital_staff_id;
GO



