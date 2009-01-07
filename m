From: akpm@linux-foundation.org
Subject: - adt7470-make-automatic-fan-control-really-work.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:20 -0800
Message-ID: <200901072217.n07MHKQS016953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762099AbZAGWSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:18:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     adt7470: make automatic fan control really work
has been removed from the -mm tree.  Its filename was
     adt7470-make-automatic-fan-control-really-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adt7470: make automatic fan control really work
From: "Darrick J. Wong" <djwong@us.ibm.com>

It turns out that the adt7470's automatic fan control algorithm only works
when the temperature sensors get updated.  This in turn happens only when
someone tells the chip to read its temperature sensors.  Regrettably, this
means that we have to drive the chip periodically.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/adt7470 |   19 +---
 drivers/hwmon/adt7470.c     |  156 +++++++++++++++++++++++++++++-----
 2 files changed, 142 insertions(+), 33 deletions(-)

diff -puN Documentation/hwmon/adt7470~adt7470-make-automatic-fan-control-really-work Documentation/hwmon/adt7470
--- a/Documentation/hwmon/adt7470~adt7470-make-automatic-fan-control-really-work
+++ a/Documentation/hwmon/adt7470
@@ -31,15 +31,11 @@ Each of the measured inputs (temperature
 limit values. The ADT7470 will signal an ALARM if any measured value exceeds
 either limit.
 
-The ADT7470 DOES NOT sample all inputs continuously.  A single pin on the
-ADT7470 is connected to a multitude of thermal diodes, but the chip must be
-instructed explicitly to read the multitude of diodes.  If you want to use
-automatic fan control mode, you must manually read any of the temperature
-sensors or the fan control algorithm will not run.  The chip WILL NOT DO THIS
-AUTOMATICALLY; this must be done from userspace.  This may be a bug in the chip
-design, given that many other AD chips take care of this.  The driver will not
-read the registers more often than once every 5 seconds.  Further,
-configuration data is only read once per minute.
+The ADT7470 samples all inputs continuously.  A kernel thread is started up for
+the purpose of periodically querying the temperature sensors, thus allowing the
+automatic fan pwm control to set the fan speed.  The driver will not read the
+registers more often than once every 5 seconds.  Further, configuration data is
+only read once per minute.
 
 Special Features
 ----------------
@@ -72,5 +68,6 @@ pwm#_auto_point2_temp.
 Notes
 -----
 
-As stated above, the temperature inputs must be read periodically from
-userspace in order for the automatic pwm algorithm to run.
+The temperature inputs no longer need to be read periodically from userspace in
+order for the automatic pwm algorithm to run.  This was the case for earlier
+versions of the driver.
diff -puN drivers/hwmon/adt7470.c~adt7470-make-automatic-fan-control-really-work drivers/hwmon/adt7470.c
--- a/drivers/hwmon/adt7470.c~adt7470-make-automatic-fan-control-really-work
+++ a/drivers/hwmon/adt7470.c
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/log2.h>
+#include <linux/kthread.h>
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = { 0x2C, 0x2E, 0x2F, I2C_CLIENT_END };
@@ -132,6 +133,9 @@ I2C_CLIENT_INSMOD_1(adt7470);
 /* Wait at least 200ms per sensor for 10 sensors */
 #define TEMP_COLLECTION_TIME	2000
 
+/* auto update thing won't fire more than every 2s */
+#define AUTO_UPDATE_INTERVAL	2000
+
 /* datasheet says to divide this number by the fan reading to get fan rpm */
 #define FAN_PERIOD_TO_RPM(x)	((90000 * 60) / (x))
 #define FAN_RPM_TO_PERIOD	FAN_PERIOD_TO_RPM
@@ -148,6 +152,7 @@ struct adt7470_data {
 	unsigned long		limits_last_updated;	/* In jiffies */
 
 	int			num_temp_sensors;	/* -1 = probe */
+	int			temperatures_probed;
 
 	s8			temp[ADT7470_TEMP_COUNT];
 	s8			temp_min[ADT7470_TEMP_COUNT];
@@ -164,6 +169,10 @@ struct adt7470_data {
 	u8			pwm_min[ADT7470_PWM_COUNT];
 	s8			pwm_tmin[ADT7470_PWM_COUNT];
 	u8			pwm_auto_temp[ADT7470_PWM_COUNT];
+
+	struct task_struct	*auto_update;
+	struct completion	auto_update_stop;
+	unsigned int		auto_update_interval;
 };
 
 static int adt7470_probe(struct i2c_client *client,
@@ -221,19 +230,13 @@ static void adt7470_init_client(struct i
 	}
 }
 
-static struct adt7470_data *adt7470_update_device(struct device *dev)
+/* Probe for temperature sensors.  Assumes lock is held */
+static int adt7470_read_temperatures(struct i2c_client *client,
+				     struct adt7470_data *data)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct adt7470_data *data = i2c_get_clientdata(client);
-	unsigned long local_jiffies = jiffies;
-	u8 cfg, pwm[4], pwm_cfg[2];
+	unsigned long res;
 	int i;
-
-	mutex_lock(&data->lock);
-	if (time_before(local_jiffies, data->sensors_last_updated +
-		SENSOR_REFRESH_INTERVAL)
-		&& data->sensors_valid)
-		goto no_sensor_update;
+	u8 cfg, pwm[4], pwm_cfg[2];
 
 	/* save pwm[1-4] config register */
 	pwm_cfg[0] = i2c_smbus_read_byte_data(client, ADT7470_REG_PWM_CFG(0));
@@ -259,9 +262,9 @@ static struct adt7470_data *adt7470_upda
 	i2c_smbus_write_byte_data(client, ADT7470_REG_CFG, cfg);
 
 	/* Delay is 200ms * number of temp sensors. */
-	msleep((data->num_temp_sensors >= 0 ?
-		data->num_temp_sensors * 200 :
-		TEMP_COLLECTION_TIME));
+	res = msleep_interruptible((data->num_temp_sensors >= 0 ?
+				    data->num_temp_sensors * 200 :
+				    TEMP_COLLECTION_TIME));
 
 	/* done reading temperature sensors */
 	cfg = i2c_smbus_read_byte_data(client, ADT7470_REG_CFG);
@@ -272,15 +275,81 @@ static struct adt7470_data *adt7470_upda
 	i2c_smbus_write_byte_data(client, ADT7470_REG_PWM_CFG(0), pwm_cfg[0]);
 	i2c_smbus_write_byte_data(client, ADT7470_REG_PWM_CFG(2), pwm_cfg[1]);
 
-	for (i = 0; i < ADT7470_TEMP_COUNT; i++)
+	if (res) {
+		printk(KERN_ERR "ha ha, interrupted");
+		return -EAGAIN;
+	}
+
+	/* Only count fans if we have to */
+	if (data->num_temp_sensors >= 0)
+		return 0;
+
+	for (i = 0; i < ADT7470_TEMP_COUNT; i++) {
 		data->temp[i] = i2c_smbus_read_byte_data(client,
 						ADT7470_TEMP_REG(i));
+		if (data->temp[i])
+			data->num_temp_sensors = i + 1;
+	}
+	data->temperatures_probed = 1;
+	return 0;
+}
+
+static int adt7470_update_thread(void *p)
+{
+	struct i2c_client *client = p;
+	struct adt7470_data *data = i2c_get_clientdata(client);
+
+	while (!kthread_should_stop()) {
+		mutex_lock(&data->lock);
+		adt7470_read_temperatures(client, data);
+		mutex_unlock(&data->lock);
+		if (kthread_should_stop())
+			break;
+		msleep_interruptible(data->auto_update_interval);
+	}
+
+	complete_all(&data->auto_update_stop);
+	return 0;
+}
+
+static struct adt7470_data *adt7470_update_device(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct adt7470_data *data = i2c_get_clientdata(client);
+	unsigned long local_jiffies = jiffies;
+	u8 cfg;
+	int i;
+	int need_sensors = 1;
+	int need_limits = 1;
+
+	/*
+	 * Figure out if we need to update the shadow registers.
+	 * Lockless means that we may occasionally report out of
+	 * date data.
+	 */
+	if (time_before(local_jiffies, data->sensors_last_updated +
+			SENSOR_REFRESH_INTERVAL) &&
+	    data->sensors_valid)
+		need_sensors = 0;
+
+	if (time_before(local_jiffies, data->limits_last_updated +
+			LIMIT_REFRESH_INTERVAL) &&
+	    data->limits_valid)
+		need_limits = 0;
+
+	if (!need_sensors && !need_limits)
+		return data;
+
+	mutex_lock(&data->lock);
+	if (!need_sensors)
+		goto no_sensor_update;
 
-	/* Figure out the number of temp sensors */
-	if (data->num_temp_sensors < 0)
+	if (!data->temperatures_probed)
+		adt7470_read_temperatures(client, data);
+	else
 		for (i = 0; i < ADT7470_TEMP_COUNT; i++)
-			if (data->temp[i])
-				data->num_temp_sensors = i + 1;
+			data->temp[i] = i2c_smbus_read_byte_data(client,
+						ADT7470_TEMP_REG(i));
 
 	for (i = 0; i < ADT7470_FAN_COUNT; i++)
 		data->fan[i] = adt7470_read_word_data(client,
@@ -329,9 +398,7 @@ static struct adt7470_data *adt7470_upda
 	data->sensors_valid = 1;
 
 no_sensor_update:
-	if (time_before(local_jiffies, data->limits_last_updated +
-		LIMIT_REFRESH_INTERVAL)
-		&& data->limits_valid)
+	if (!need_limits)
 		goto out;
 
 	for (i = 0; i < ADT7470_TEMP_COUNT; i++) {
@@ -365,6 +432,35 @@ out:
 	return data;
 }
 
+static ssize_t show_auto_update_interval(struct device *dev,
+					 struct device_attribute *devattr,
+					 char *buf)
+{
+	struct adt7470_data *data = adt7470_update_device(dev);
+	return sprintf(buf, "%d\n", data->auto_update_interval);
+}
+
+static ssize_t set_auto_update_interval(struct device *dev,
+					struct device_attribute *devattr,
+					const char *buf,
+					size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct adt7470_data *data = i2c_get_clientdata(client);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, 0, 60000);
+
+	mutex_lock(&data->lock);
+	data->auto_update_interval = temp;
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
 static ssize_t show_num_temp_sensors(struct device *dev,
 				     struct device_attribute *devattr,
 				     char *buf)
@@ -389,6 +485,8 @@ static ssize_t set_num_temp_sensors(stru
 
 	mutex_lock(&data->lock);
 	data->num_temp_sensors = temp;
+	if (temp < 0)
+		data->temperatures_probed = 0;
 	mutex_unlock(&data->lock);
 
 	return count;
@@ -862,6 +960,8 @@ static ssize_t show_alarm(struct device 
 static DEVICE_ATTR(alarm_mask, S_IRUGO, show_alarm_mask, NULL);
 static DEVICE_ATTR(num_temp_sensors, S_IWUSR | S_IRUGO, show_num_temp_sensors,
 		   set_num_temp_sensors);
+static DEVICE_ATTR(auto_update_interval, S_IWUSR | S_IRUGO,
+		   show_auto_update_interval, set_auto_update_interval);
 
 static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp_max,
 		    set_temp_max, 0);
@@ -1035,6 +1135,7 @@ static struct attribute *adt7470_attr[] 
 {
 	&dev_attr_alarm_mask.attr,
 	&dev_attr_num_temp_sensors.attr,
+	&dev_attr_auto_update_interval.attr,
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
 	&sensor_dev_attr_temp2_max.dev_attr.attr,
 	&sensor_dev_attr_temp3_max.dev_attr.attr,
@@ -1168,6 +1269,7 @@ static int adt7470_probe(struct i2c_clie
 	}
 
 	data->num_temp_sensors = -1;
+	data->auto_update_interval = AUTO_UPDATE_INTERVAL;
 
 	i2c_set_clientdata(client, data);
 	mutex_init(&data->lock);
@@ -1188,8 +1290,16 @@ static int adt7470_probe(struct i2c_clie
 		goto exit_remove;
 	}
 
+	init_completion(&data->auto_update_stop);
+	data->auto_update = kthread_run(adt7470_update_thread, client,
+					dev_name(data->hwmon_dev));
+	if (IS_ERR(data->auto_update))
+		goto exit_unregister;
+
 	return 0;
 
+exit_unregister:
+	hwmon_device_unregister(data->hwmon_dev);
 exit_remove:
 	sysfs_remove_group(&client->dev.kobj, &data->attrs);
 exit_free:
@@ -1202,6 +1312,8 @@ static int adt7470_remove(struct i2c_cli
 {
 	struct adt7470_data *data = i2c_get_clientdata(client);
 
+	kthread_stop(data->auto_update);
+	wait_for_completion(&data->auto_update_stop);
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&client->dev.kobj, &data->attrs);
 	kfree(data);
_

Patches currently in -mm which might be from djwong@us.ibm.com are

origin.patch
linux-next.patch
fakephp-allocate-pci-resources-before-adding-the-device.patch

