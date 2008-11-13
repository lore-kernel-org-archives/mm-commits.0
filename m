From: akpm@linux-foundation.org
Subject: - adt7473-check-inputs-from-sysfs-writes.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:27:08 -0800
Message-ID: <200811132127.mADLR80F027781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803AbYKMV1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     adt7473: check inputs from sysfs writes
has been removed from the -mm tree.  Its filename was
     adt7473-check-inputs-from-sysfs-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adt7473: check inputs from sysfs writes
From: "Darrick J. Wong" <djwong@us.ibm.com>

Implement correct range checking for adt7470 to prevent userland from
writing impossible values into the chip, and cap out-of-range values per
standard hwmon conventions.

Implement correct rounding of input values per standard hwmon conventions.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adt7473.c |   89 +++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 15 deletions(-)

diff -puN drivers/hwmon/adt7473.c~adt7473-check-inputs-from-sysfs-writes drivers/hwmon/adt7473.c
--- a/drivers/hwmon/adt7473.c~adt7473-check-inputs-from-sysfs-writes
+++ a/drivers/hwmon/adt7473.c
@@ -129,6 +129,8 @@ I2C_CLIENT_INSMOD_1(adt7473);
 #define FAN_PERIOD_INVALID	65535
 #define FAN_DATA_VALID(x)	((x) && (x) != FAN_PERIOD_INVALID)
 
+#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))
+
 struct adt7473_data {
 	struct device		*hwmon_dev;
 	struct attribute_group	attrs;
@@ -357,7 +359,12 @@ static ssize_t set_volt_min(struct devic
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int volt = encode_volt(attr->index, simple_strtol(buf, NULL, 10));
+	long volt;
+
+	if (strict_strtol(buf, 10, &volt))
+		return -EINVAL;
+
+	volt = encode_volt(attr->index, volt);
 
 	mutex_lock(&data->lock);
 	data->volt_min[attr->index] = volt;
@@ -386,7 +393,12 @@ static ssize_t set_volt_max(struct devic
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int volt = encode_volt(attr->index, simple_strtol(buf, NULL, 10));
+	long volt;
+
+	if (strict_strtol(buf, 10, &volt))
+		return -EINVAL;
+
+	volt = encode_volt(attr->index, volt);
 
 	mutex_lock(&data->lock);
 	data->volt_max[attr->index] = volt;
@@ -419,7 +431,8 @@ static int decode_temp(u8 twos_complemen
 
 static u8 encode_temp(u8 twos_complement, int cooked)
 {
-	return twos_complement ? cooked & 0xFF : cooked + 64;
+	u8 ret = twos_complement ? cooked & 0xFF : cooked + 64;
+	return SENSORS_LIMIT(ret, 0, 255);
 }
 
 static ssize_t show_temp_min(struct device *dev,
@@ -441,7 +454,12 @@ static ssize_t set_temp_min(struct devic
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -472,7 +490,12 @@ static ssize_t set_temp_max(struct devic
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -515,11 +538,13 @@ static ssize_t set_fan_min(struct device
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
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
@@ -558,7 +583,10 @@ static ssize_t set_max_duty_at_crit(stru
 	u8 reg;
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
 
 	mutex_lock(&data->lock);
 	data->max_duty_at_overheat = !!temp;
@@ -587,7 +615,12 @@ static ssize_t set_pwm(struct device *de
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm[attr->index] = temp;
@@ -614,7 +647,12 @@ static ssize_t set_pwm_max(struct device
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm_max[attr->index] = temp;
@@ -642,7 +680,12 @@ static ssize_t set_pwm_min(struct device
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 255);
 
 	mutex_lock(&data->lock);
 	data->pwm_min[attr->index] = temp;
@@ -672,7 +715,12 @@ static ssize_t set_temp_tmax(struct devi
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -703,7 +751,12 @@ static ssize_t set_temp_tmin(struct devi
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10) / 1000;
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = ROUND_DIV(temp, 1000);
 	temp = encode_temp(data->temp_twos_complement, temp);
 
 	mutex_lock(&data->lock);
@@ -741,7 +794,10 @@ static ssize_t set_pwm_enable(struct dev
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
 
 	switch (temp) {
 	case 0:
@@ -805,7 +861,10 @@ static ssize_t set_pwm_auto_temp(struct 
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
-	int temp = simple_strtol(buf, NULL, 10);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
 
 	switch (temp) {
 	case 1:
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
linux-next.patch
create-a-div_round_closest-macro-to-do-division-with-rounding.patch
adt7462-70-73-use-div_round_closest-for-rounded-division.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch

