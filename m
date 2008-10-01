From: akpm@linux-foundation.org
Subject: - hwmon-add-support-for-max1618-in-max1619-driver.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:43:02 -0700
Message-ID: <200810012143.m91Lh2wI005493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378AbYJAVni (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:43:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tobias@himmer-online.de, bigeasy@linutronix.de, fishor@mail.ru, khali@linux-fr.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hwmon: add support for MAX1618 in MAX1619 driver
has been removed from the -mm tree.  Its filename was
     hwmon-add-support-for-max1618-in-max1619-driver.patch

This patch was dropped because jdelvare-hwmon-hwmon-max1619-convert-macros-to-inline-functions.patch broke it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: add support for MAX1618 in MAX1619 driver
From: Tobias Himmer <tobias@himmer-online.de>

The difference between MAX1619 and MAX1618 is that the latter has only one
measurement register.

Tested-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Tobias Himmer <tobias@himmer-online.de>
Cc: Alexey Fisher <fishor@mail.ru>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig   |    5 -
 drivers/hwmon/max1619.c |  183 +++++++++++++++++++++++++-------------
 2 files changed, 128 insertions(+), 60 deletions(-)

diff -puN drivers/hwmon/Kconfig~hwmon-add-support-for-max1618-in-max1619-driver drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~hwmon-add-support-for-max1618-in-max1619-driver
+++ a/drivers/hwmon/Kconfig
@@ -548,10 +548,11 @@ config SENSORS_MAX1111
 	  will be called max1111.
 
 config SENSORS_MAX1619
-	tristate "Maxim MAX1619 sensor chip"
+	tristate "Maxim MAX1619 / MAX1618 sensor chip"
 	depends on I2C
 	help
-	  If you say yes here you get support for MAX1619 sensor chip.
+	  If you say yes here you get support for MAX1619 and MAX1618
+	  sensor chips.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called max1619.
diff -puN drivers/hwmon/max1619.c~hwmon-add-support-for-max1618-in-max1619-driver drivers/hwmon/max1619.c
--- a/drivers/hwmon/max1619.c~hwmon-add-support-for-max1618-in-max1619-driver
+++ a/drivers/hwmon/max1619.c
@@ -3,12 +3,15 @@
  *             monitoring
  * Copyright (C) 2003-2004 Alexey Fisher <fishor@mail.ru>
  *                         Jean Delvare <khali@linux-fr.org>
+ *                         Tobias Himmer <tobias@himmer-online.de>
  *
  * Based on the lm90 driver. The MAX1619 is a sensor chip made by Maxim.
- * It reports up to two temperatures (its own plus up to
- * one external one). Complete datasheet can be
- * obtained from Maxim's website at:
+ * It reports up to two temperatures (its own plus up to one external one).
+ * This driver will also work on the MAX1618, a stripped down version with
+ * only one (external) temperature source.
+ * Complete datasheets can be obtained from Maxim's website at:
  *   http://pdfserv.maxim-ic.com/en/ds/MAX1619.pdf
+ *   http://pdfserv.maxim-ic.com/en/ds/MAX1618.pdf
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -44,7 +47,7 @@ static const unsigned short normal_i2c[]
  * Insmod parameters
  */
 
-I2C_CLIENT_INSMOD_1(max1619);
+I2C_CLIENT_INSMOD_2(max1619, max1618);
 
 /*
  * The MAX1619 registers
@@ -93,6 +96,7 @@ static struct max1619_data *max1619_upda
 
 static const struct i2c_device_id max1619_id[] = {
 	{ "max1619", max1619 },
+	{ "max1618", max1618 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max1619_id);
@@ -116,35 +120,50 @@ static struct i2c_driver max1619_driver 
 struct max1619_data {
 	struct device *hwmon_dev;
 	struct mutex update_lock;
+	const struct attribute_group *group;
+	kernel_ulong_t kind; /* max1619 or max1618 */
 	char valid; /* zero until following fields are valid */
 	unsigned long last_updated; /* in jiffies */
 
 	/* registers values */
-	u8 temp_input1; /* local */
-	u8 temp_input2, temp_low2, temp_high2; /* remote */
-	u8 temp_crit2;
-	u8 temp_hyst2;
-	u8 alarms; 
+	u8 local;
+	u8 remote;
+	u8 remote_low, remote_high;
+	u8 remote_crit, remote_hyst;
+	u8 alarms;
 };
 
 /*
  * Sysfs stuff
  */
 
+static ssize_t show_temp1_input(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct max1619_data *data = max1619_update_device(dev);
+	return sprintf(buf, "%d\n", TEMP_FROM_REG((data->kind == max1618) ?
+						data->remote : data->local));
+}
+
+static ssize_t show_temp2_input(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct max1619_data *data = max1619_update_device(dev);
+	return sprintf(buf, "%d\n", TEMP_FROM_REG(data->remote));
+}
+
 #define show_temp(value) \
 static ssize_t show_##value(struct device *dev, struct device_attribute *attr, char *buf) \
 { \
 	struct max1619_data *data = max1619_update_device(dev); \
 	return sprintf(buf, "%d\n", TEMP_FROM_REG(data->value)); \
 }
-show_temp(temp_input1);
-show_temp(temp_input2);
-show_temp(temp_low2);
-show_temp(temp_high2);
-show_temp(temp_crit2);
-show_temp(temp_hyst2);
+show_temp(remote_low);
+show_temp(remote_high);
+show_temp(remote_crit);
+show_temp(remote_hyst);
 
-#define set_temp2(value, reg) \
+#define set_temp(value, reg) \
 static ssize_t set_##value(struct device *dev, struct device_attribute *attr, const char *buf, \
 	size_t count) \
 { \
@@ -158,11 +177,10 @@ static ssize_t set_##value(struct device
 	mutex_unlock(&data->update_lock); \
 	return count; \
 }
-
-set_temp2(temp_low2, MAX1619_REG_W_REMOTE_LOW);
-set_temp2(temp_high2, MAX1619_REG_W_REMOTE_HIGH);
-set_temp2(temp_crit2, MAX1619_REG_W_REMOTE_CRIT);
-set_temp2(temp_hyst2, MAX1619_REG_W_TCRIT_HYST);
+set_temp(remote_low, MAX1619_REG_W_REMOTE_LOW);
+set_temp(remote_high, MAX1619_REG_W_REMOTE_HIGH);
+set_temp(remote_crit, MAX1619_REG_W_REMOTE_CRIT);
+set_temp(remote_hyst, MAX1619_REG_W_TCRIT_HYST);
 
 static ssize_t show_alarms(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -178,22 +196,50 @@ static ssize_t show_alarm(struct device 
 	return sprintf(buf, "%d\n", (data->alarms >> bitnr) & 1);
 }
 
-static DEVICE_ATTR(temp1_input, S_IRUGO, show_temp_input1, NULL);
-static DEVICE_ATTR(temp2_input, S_IRUGO, show_temp_input2, NULL);
-static DEVICE_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_temp_low2,
-	set_temp_low2);
-static DEVICE_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_temp_high2,
-	set_temp_high2);
-static DEVICE_ATTR(temp2_crit, S_IWUSR | S_IRUGO, show_temp_crit2,
-	set_temp_crit2);
-static DEVICE_ATTR(temp2_crit_hyst, S_IWUSR | S_IRUGO, show_temp_hyst2,
-	set_temp_hyst2);
+/* These are for both - MAX1619 and MAX1618 */
+static DEVICE_ATTR(temp1_input, S_IRUGO, show_temp1_input, NULL);
 static DEVICE_ATTR(alarms, S_IRUGO, show_alarms, NULL);
+
+/* These are just for MAX1619 */
+static DEVICE_ATTR(temp2_input, S_IRUGO, show_temp2_input, NULL);
+static DEVICE_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_remote_low,
+		   set_remote_low);
+static DEVICE_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_remote_high,
+		   set_remote_high);
+static DEVICE_ATTR(temp2_crit, S_IWUSR | S_IRUGO, show_remote_crit,
+		   set_remote_crit);
+static DEVICE_ATTR(temp2_crit_hyst, S_IWUSR | S_IRUGO, show_remote_hyst,
+		   set_remote_hyst);
 static SENSOR_DEVICE_ATTR(temp2_crit_alarm, S_IRUGO, show_alarm, NULL, 1);
 static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, show_alarm, NULL, 2);
 static SENSOR_DEVICE_ATTR(temp2_min_alarm, S_IRUGO, show_alarm, NULL, 3);
 static SENSOR_DEVICE_ATTR(temp2_max_alarm, S_IRUGO, show_alarm, NULL, 4);
 
+/* These are just for MAX1618 */
+static DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO, show_remote_low,
+		   set_remote_low);
+static DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_remote_high,
+		   set_remote_high);
+static SENSOR_DEVICE_ATTR(temp1_fault, S_IRUGO, show_alarm, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp1_min_alarm, S_IRUGO, show_alarm, NULL, 3);
+static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, show_alarm, NULL, 4);
+
+static struct attribute *max1618_attributes[] = {
+	&dev_attr_temp1_input.attr,
+	&dev_attr_temp1_min.attr,
+	&dev_attr_temp1_max.attr,
+
+	&dev_attr_alarms.attr,
+	&sensor_dev_attr_temp1_fault.dev_attr.attr,
+	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group max1618_group = {
+	.attrs = max1618_attributes,
+};
+
 static struct attribute *max1619_attributes[] = {
 	&dev_attr_temp1_input.attr,
 	&dev_attr_temp2_input.attr,
@@ -256,14 +302,24 @@ static int max1619_detect(struct i2c_cli
 
 	if (kind <= 0) { /* identification */
 		u8 man_id, chip_id;
-	
+
 		man_id = i2c_smbus_read_byte_data(new_client,
 			 MAX1619_REG_R_MAN_ID);
 		chip_id = i2c_smbus_read_byte_data(new_client,
 			  MAX1619_REG_R_CHIP_ID);
-		
-		if ((man_id == 0x4D) && (chip_id == 0x04))
-			kind = max1619;
+
+		if (man_id == 0x4D) {
+			switch (chip_id) {
+			case 0x04:
+				kind = max1619;
+				strlcpy(info->type, "max1619", I2C_NAME_SIZE);
+				break;
+			case 0x02:
+				kind = max1618;
+				strlcpy(info->type, "max1618", I2C_NAME_SIZE);
+				break;
+			}
+		}
 
 		if (kind <= 0) { /* identification failed */
 			dev_info(&adapter->dev,
@@ -273,8 +329,6 @@ static int max1619_detect(struct i2c_cli
 		}
 	}
 
-	strlcpy(info->type, "max1619", I2C_NAME_SIZE);
-
 	return 0;
 }
 
@@ -298,7 +352,15 @@ static int max1619_probe(struct i2c_clie
 	max1619_init_client(new_client);
 
 	/* Register sysfs hooks */
-	if ((err = sysfs_create_group(&new_client->dev.kobj, &max1619_group)))
+	if (id->driver_data == max1618) {
+		data->group = &max1618_group;
+		data->kind = max1618;
+	} else {
+		data->group = &max1619_group;
+		data->kind = max1619;
+	}
+	err = sysfs_create_group(&new_client->dev.kobj, data->group);
+	if (err)
 		goto exit_free;
 
 	data->hwmon_dev = hwmon_device_register(&new_client->dev);
@@ -310,7 +372,7 @@ static int max1619_probe(struct i2c_clie
 	return 0;
 
 exit_remove_files:
-	sysfs_remove_group(&new_client->dev.kobj, &max1619_group);
+	sysfs_remove_group(&new_client->dev.kobj, data->group);
 exit_free:
 	kfree(data);
 exit:
@@ -337,7 +399,7 @@ static int max1619_remove(struct i2c_cli
 	struct max1619_data *data = i2c_get_clientdata(client);
 
 	hwmon_device_unregister(data->hwmon_dev);
-	sysfs_remove_group(&client->dev.kobj, &max1619_group);
+	sysfs_remove_group(&client->dev.kobj, data->group);
 
 	kfree(data);
 	return 0;
@@ -352,21 +414,25 @@ static struct max1619_data *max1619_upda
 
 	if (time_after(jiffies, data->last_updated + HZ * 2) || !data->valid) {
 		dev_dbg(&client->dev, "Updating max1619 data.\n");
-		data->temp_input1 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_LOCAL_TEMP);
-		data->temp_input2 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_REMOTE_TEMP);
-		data->temp_high2 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_REMOTE_HIGH);
-		data->temp_low2 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_REMOTE_LOW);
-		data->temp_crit2 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_REMOTE_CRIT);
-		data->temp_hyst2 = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_TCRIT_HYST);
-		data->alarms = i2c_smbus_read_byte_data(client,
-					MAX1619_REG_R_STATUS);
-
+		switch (data->kind) {
+		default:
+			data->local = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_LOCAL_TEMP);
+			data->remote_crit = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_REMOTE_CRIT);
+			data->remote_hyst = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_TCRIT_HYST);
+		/* fallthrough */
+		case max1618:
+			data->remote = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_REMOTE_TEMP);
+			data->remote_high = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_REMOTE_HIGH);
+			data->remote_low = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_REMOTE_LOW);
+			data->alarms = i2c_smbus_read_byte_data(
+				client, MAX1619_REG_R_STATUS);
+		}
 		data->last_updated = jiffies;
 		data->valid = 1;
 	}
@@ -386,9 +452,10 @@ static void __exit sensors_max1619_exit(
 	i2c_del_driver(&max1619_driver);
 }
 
-MODULE_AUTHOR("Alexey Fisher <fishor@mail.ru> and "
-	"Jean Delvare <khali@linux-fr.org>");
-MODULE_DESCRIPTION("MAX1619 sensor driver");
+MODULE_AUTHOR("Alexey Fisher <fishor@mail.ru>, "
+	"Jean Delvare <khali@linux-fr.org>, "
+	"Tobias Himmer <tobias@himmer-online.de>");
+MODULE_DESCRIPTION("MAX1619 / MAX1618 sensor driver");
 MODULE_LICENSE("GPL");
 
 module_init(sensors_max1619_init);
_

Patches currently in -mm which might be from tobias@himmer-online.de are

hwmon-add-support-for-max1618-in-max1619-driver.patch

