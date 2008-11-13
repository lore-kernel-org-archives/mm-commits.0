From: akpm@linux-foundation.org
Subject: - adt7470-check-input-range-when-sysfs-files-are-written.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:27:06 -0800
Message-ID: <200811132127.mADLR63g027745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbYKMV1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     adt7470: check input range when sysfs files are written
has been removed from the -mm tree.  Its filename was
     adt7470-check-input-range-when-sysfs-files-are-written.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adt7470: check input range when sysfs files are written
From: "Darrick J. Wong" <djwong@us.ibm.com>

Implement correct range checking for adt7470 to prevent userland from
writing impossible values into the chip, and cap out-of-range values per
standard hwmon conventions.

Implement correct rounding of input values per standard hwmon conventions.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adt7470.c |   75 +++++++++++++++++++++++++++++++-------
 1 file changed, 62 insertions(+), 13 deletions(-)

diff -puN drivers/hwmon/adt7470.c~adt7470-check-input-range-when-sysfs-files-are-written drivers/hwmon/adt7470.c
--- a/drivers/hwmon/adt7470.c~adt7470-check-input-range-when-sysfs-files-are-written
+++ a/drivers/hwmon/adt7470.c
@@ -137,6 +137,8 @@ I2C_CLIENT_INSMOD_1(adt7470);
 #define FAN_PERIOD_INVALID	65535
 #define FAN_DATA_VALID(x)	((x) && (x) != FAN_PERIOD_INVALID)
 
+#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
+
 struct adt7470_data {
 	struct device		*hwmon_dev;
 	struct attribute_group	attrs;
@@ -353,7 +355,13 @@ static ssize_t set_temp_min(struct devic
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->temp_min[attr->index] = temp;
@@ -381,7 +389,13 @@ static ssize_t set_temp_max(struct devic
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->temp_max[attr->index] = temp;
@@ -430,11 +444,13 @@ static ssize_t set_fan_max(struct device
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
 
-	if (!temp)
+	if (strict_strtol(buf, 10, &temp) || !temp)
 		return -EINVAL;
+
 	temp = FAN_RPM_TO_PERIOD(temp);
+	temp = SENSORS_LIMIT(temp, 1, 65534);
 
 	mutex_lock(&data->lock);
 	data->fan_max[attr->index] = temp;
@@ -465,11 +481,13 @@ static ssize_t set_fan_min(struct device
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
 
-	if (!temp)
+	if (strict_strtol(buf, 10, &temp) || !temp)
 		return -EINVAL;
+
 	temp = FAN_RPM_TO_PERIOD(temp);
+	temp = SENSORS_LIMIT(temp, 1, 65534);
 
 	mutex_lock(&data->lock);
 	data->fan_min[attr->index] = temp;
@@ -507,9 +525,12 @@ static ssize_t set_force_pwm_max(struct 
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
 	u8 reg;
 
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
 	mutex_lock(&data->lock);
 	data->force_pwm_max = temp;
 	reg = i2c_smbus_read_byte_data(client, ADT7470_REG_CFG);
@@ -537,7 +558,12 @@ static ssize_t set_pwm(struct device *de
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm[attr->index] = temp;
@@ -564,7 +590,12 @@ static ssize_t set_pwm_max(struct device
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm_max[attr->index] = temp;
@@ -592,7 +623,12 @@ static ssize_t set_pwm_min(struct device
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm_min[attr->index] = temp;
@@ -630,7 +666,13 @@ static ssize_t set_pwm_tmin(struct devic
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm_tmin[attr->index] = temp;
@@ -658,11 +700,14 @@ static ssize_t set_pwm_auto(struct devic
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
 	int pwm_auto_reg = ADT7470_REG_PWM_CFG(attr->index);
 	int pwm_auto_reg_mask;
+	long temp;
 	u8 reg;
 
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
 	if (attr->index % 2)
 		pwm_auto_reg_mask = ADT7470_PWM2_AUTO_MASK;
 	else
@@ -716,10 +761,14 @@ static ssize_t set_pwm_auto_temp(struct 
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7470_data *data = i2c_get_clientdata(client);
-	int temp = cvt_auto_temp(simple_strtol(buf, NULL, 10));
 	int pwm_auto_reg = ADT7470_REG_PWM_AUTO_TEMP(attr->index);
+	long temp;
 	u8 reg;
 
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = cvt_auto_temp(temp);
 	if (temp < 0)
 		return temp;
 
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
linux-next.patch
create-a-div_round_closest-macro-to-do-division-with-rounding.patch
adt7462-70-73-use-div_round_closest-for-rounded-division.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch

