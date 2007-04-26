From: akpm@linux-foundation.org
Subject: - apple-smc-driver-standardize-and-sanitize-sysfs-tree.patch removed from -mm tree
Date: Thu, 26 Apr 2007 00:13:38 -0700
Message-ID: <200704260713.l3Q7DcZc023485@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933168AbXDZHOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 03:14:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas@boichat.ch, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     Apple SMC driver - standardize and sanitize sysfs tree + minor features addition
has been removed from the -mm tree.  Its filename was
     apple-smc-driver-standardize-and-sanitize-sysfs-tree.patch

This patch was dropped because it was folded into apple-smc-driver-hardware-monitoring-and-control.patch

------------------------------------------------------
Subject: Apple SMC driver - standardize and sanitize sysfs tree + minor features addition
From: Nicolas Boichat <nicolas@boichat.ch>

- Standardize applesmc to use sysfs filenames recommended by
  Documentation/hwmon/sysfs-interface, and register the device with the hwmon
  class.
- Use snprintf instead of sprintf in sysfs show handlers.
- Remove the sysfs files properly in case of initialisation problem, and when
  the driver is unloaded.
- Add data buffer length sanity checks.
- Improvements of SMC keys' comments (add data type reported by the device).
- Add temperature sensors to Macbook Pro.
- Add support for reading fan physical position (e.g. "Left Side")

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |  288 +++++++++++++++++++++++++------------
 1 files changed, 196 insertions(+), 92 deletions(-)

diff -puN drivers/hwmon/applesmc.c~apple-smc-driver-standardize-and-sanitize-sysfs-tree drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~apple-smc-driver-standardize-and-sanitize-sysfs-tree
+++ a/drivers/hwmon/applesmc.c
@@ -37,40 +37,48 @@
 #include <linux/hwmon-sysfs.h>
 #include <asm/io.h>
 #include <linux/leds.h>
+#include <linux/hwmon.h>
 
-/* data port used by apple SMC */
+/* data port used by Apple SMC */
 #define APPLESMC_DATA_PORT	0x300
-/* command/status port used by apple SMC */
+/* command/status port used by Apple SMC */
 #define APPLESMC_CMD_PORT	0x304
 
-#define APPLESMC_NR_PORTS	5 /* 0x300-0x304 */
+#define APPLESMC_NR_PORTS	32 /* 0x300-0x31f */
+
+#define APPLESMC_MAX_DATA_LENGTH 32
 
 #define APPLESMC_STATUS_MASK	0x0f
 #define APPLESMC_READ_CMD	0x10
 #define APPLESMC_WRITE_CMD	0x11
 
-#define LIGHT_SENSOR_LEFT_KEY	"ALV0" /* r-o length 6 */
-#define LIGHT_SENSOR_RIGHT_KEY	"ALV1" /* r-o length 6 */
-#define BACKLIGHT_KEY 		"LKSB" /* w-o */
-
-#define CLAMSHELL_KEY 		"MSLD" /* r-o length 1 (unused) */
-
-#define MOTION_SENSOR_X_KEY	"MO_X" /* r-o length 2 */
-#define MOTION_SENSOR_Y_KEY	"MO_Y" /* r-o length 2 */
-#define MOTION_SENSOR_Z_KEY	"MO_Z" /* r-o length 2 */
-#define MOTION_SENSOR_KEY	"MOCN" /* r/w length 2 */
-
-#define FANS_COUNT		"FNum" /* r-o length 1 */
-#define FANS_MANUAL		"FS! " /* r-w length 2 */
-#define FAN_ACTUAL_SPEED	"F0Ac" /* r-o length 2 */
-#define FAN_MIN_SPEED		"F0Mn" /* r-o length 2 */
-#define FAN_MAX_SPEED		"F0Mx" /* r-o length 2 */
-#define FAN_SAFE_SPEED		"F0Sf" /* r-o length 2 */
-#define FAN_TARGET_SPEED	"F0Tg" /* r-w length 2 */
-
-/* Temperature sensors keys. First set for Macbook(Pro), second for Macmini */
-static const char* temperature_sensors_sets[][8] = {
-	{ "TB0T", "TC0D", "TC0P", "Th0H", "Ts0P", "Th1H", "Ts1P", NULL },
+#define LIGHT_SENSOR_LEFT_KEY	"ALV0" /* r-o {alv (6 bytes) */
+#define LIGHT_SENSOR_RIGHT_KEY	"ALV1" /* r-o {alv (6 bytes) */
+#define BACKLIGHT_KEY 		"LKSB" /* w-o {lkb (2 bytes) */
+
+#define CLAMSHELL_KEY 		"MSLD" /* r-o ui8 (unused) */
+
+#define MOTION_SENSOR_X_KEY	"MO_X" /* r-o sp78 (2 bytes) */
+#define MOTION_SENSOR_Y_KEY	"MO_Y" /* r-o sp78 (2 bytes) */
+#define MOTION_SENSOR_Z_KEY	"MO_Z" /* r-o sp78 (2 bytes) */
+#define MOTION_SENSOR_KEY	"MOCN" /* r/w ui16 */
+
+#define FANS_COUNT		"FNum" /* r-o ui8 */
+#define FANS_MANUAL		"FS! " /* r-w ui16 */
+#define FAN_ACTUAL_SPEED	"F0Ac" /* r-o fpe2 (2 bytes) */
+#define FAN_MIN_SPEED		"F0Mn" /* r-o fpe2 (2 bytes) */
+#define FAN_MAX_SPEED		"F0Mx" /* r-o fpe2 (2 bytes) */
+#define FAN_SAFE_SPEED		"F0Sf" /* r-o fpe2 (2 bytes) */
+#define FAN_TARGET_SPEED	"F0Tg" /* r-w fpe2 (2 bytes) */
+#define FAN_POSITION		"F0ID" /* r-o char[16] */
+
+/*
+ * Temperature sensors keys (sp78 - 2 bytes).
+ * First set for Macbook(Pro), second for Macmini.
+ */
+static const char* temperature_sensors_sets[][13] = {
+	{ "TA0P", "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "Th0H",
+	  "Th1H", "Tm0P", "Ts0P", "Ts1P", NULL },
 	{ "TC0D", "TC0P", NULL }
 };
 
@@ -110,6 +118,7 @@ static s16 rest_x;
 static s16 rest_y;
 static struct timer_list applesmc_timer;
 static struct input_dev *applesmc_idev;
+static struct class_device *hwmon_class_dev;
 
 /* Indicates whether this computer has an accelerometer. */
 static unsigned int applesmc_accelerometer;
@@ -152,17 +161,22 @@ static int __wait_status(u8 val)
  */
 static int applesmc_read_key(const char* key, u8* buffer, u8 len)
 {
-	int ret = -EIO;
 	int i;
 
+	if (len > APPLESMC_MAX_DATA_LENGTH) {
+		printk(KERN_ERR	"applesmc_read_key: cannot read more than "
+					"%d bytes\n", APPLESMC_MAX_DATA_LENGTH);
+		return -EINVAL;
+	}
+
 	outb(APPLESMC_READ_CMD, APPLESMC_CMD_PORT);
 	if (__wait_status(0x0c))
-		goto out;
+		return -EIO;
 
 	for (i = 0; i < 4; i++) {
 		outb(key[i], APPLESMC_DATA_PORT);
 		if (__wait_status(0x04))
-			goto out;
+			return -EIO;
 	}
 	if (debug)
 		printk(KERN_DEBUG "<%s", key);
@@ -173,7 +187,7 @@ static int applesmc_read_key(const char*
 
 	for (i = 0; i < len; i++) {
 		if (__wait_status(0x05))
-			goto out;
+			return -EIO;
 		buffer[i] = inb(APPLESMC_DATA_PORT);
 		if (debug)
 			printk(KERN_DEBUG "<%x", buffer[i]);
@@ -181,10 +195,7 @@ static int applesmc_read_key(const char*
 	if (debug)
 		printk(KERN_DEBUG "\n");
 
-	ret = 0;
-
-out:
-	return ret;
+	return 0;
 }
 
 /*
@@ -194,30 +205,33 @@ out:
  */
 static int applesmc_write_key(const char* key, u8* buffer, u8 len)
 {
-	int ret = -EIO;
 	int i;
 
+	if (len > APPLESMC_MAX_DATA_LENGTH) {
+		printk(KERN_ERR	"applesmc_write_key: cannot write more than "
+					"%d bytes\n", APPLESMC_MAX_DATA_LENGTH);
+		return -EINVAL;
+	}
+
 	outb(APPLESMC_WRITE_CMD, APPLESMC_CMD_PORT);
 	if (__wait_status(0x0c))
-		goto out;
+		return -EIO;
 
 	for (i = 0; i < 4; i++) {
 		outb(key[i], APPLESMC_DATA_PORT);
 		if (__wait_status(0x04))
-			goto out;
+			return -EIO;
 	}
 
 	outb(len, APPLESMC_DATA_PORT);
 
 	for (i = 0; i < len; i++) {
 		if (__wait_status(0x04))
-			goto out;
+			return -EIO;
 		outb(buffer[i], APPLESMC_DATA_PORT);
 	}
 
-	ret = 0;
-out:
-	return ret;
+	return 0;
 }
 
 /*
@@ -415,7 +429,7 @@ out:
 	if (ret)
 		return ret;
 	else
-		return sprintf(buf, "(%d,%d,%d)\n", x, y, z);
+		return snprintf(buf, PAGE_SIZE, "(%d,%d,%d)\n", x, y, z);
 }
 
 static ssize_t applesmc_light_show(struct device *dev,
@@ -439,10 +453,10 @@ out:
 	if (ret)
 		return ret;
 	else
-		return sprintf(sysfsbuf, "(%d,%d)\n", left, right);
+		return snprintf(sysfsbuf, PAGE_SIZE, "(%d,%d)\n", left, right);
 }
 
-/* Displays degree Celsius * 100 */
+/* Displays degree Celsius * 1000 */
 static ssize_t applesmc_show_temperature(struct device *dev,
 			struct device_attribute *devattr, char *sysfsbuf)
 {
@@ -456,15 +470,15 @@ static ssize_t applesmc_show_temperature
 	mutex_lock(&applesmc_lock);
 
 	ret = applesmc_read_key(key, buffer, 2);
-	temp = buffer[0]*100;
-	temp += (buffer[1] >> 6) * 25;
+	temp = buffer[0]*1000;
+	temp += (buffer[1] >> 6) * 250;
 
 	mutex_unlock(&applesmc_lock);
 
 	if (ret)
 		return ret;
 	else
-		return sprintf(sysfsbuf, "%u\n", temp);
+		return snprintf(sysfsbuf, PAGE_SIZE, "%u\n", temp);
 }
 
 static ssize_t applesmc_show_fan_speed(struct device *dev,
@@ -492,7 +506,7 @@ static ssize_t applesmc_show_fan_speed(s
 	if (ret)
 		return ret;
 	else
-		return sprintf(sysfsbuf, "%u\n", speed);
+		return snprintf(sysfsbuf, PAGE_SIZE, "%u\n", speed);
 }
 
 static ssize_t applesmc_store_fan_speed(struct device *dev,
@@ -547,7 +561,7 @@ static ssize_t applesmc_show_fan_manual(
 	if (ret)
 		return ret;
 	else
-		return sprintf(sysfsbuf, "%d\n", manual);
+		return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", manual);
 }
 
 static ssize_t applesmc_store_fan_manual(struct device *dev,
@@ -587,10 +601,37 @@ out:
 		return count;
 }
 
+static ssize_t applesmc_show_fan_position(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	int ret;
+	char newkey[5];
+	u8 buffer[17];
+	struct sensor_device_attribute_2 *sensor_attr =
+						to_sensor_dev_attr_2(attr);
+
+	newkey[0] = FAN_POSITION[0];
+	newkey[1] = '0' + sensor_attr->index;
+	newkey[2] = FAN_POSITION[2];
+	newkey[3] = FAN_POSITION[3];
+	newkey[4] = 0;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_read_key(newkey, buffer, 16);
+	buffer[16] = 0;
+
+	mutex_unlock(&applesmc_lock);
+	if (ret)
+		return ret;
+	else
+		return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", buffer+4);
+}
+
 static ssize_t applesmc_calibrate_show(struct device *dev,
 				struct device_attribute *attr, char *sysfsbuf)
 {
-	return sprintf(sysfsbuf, "(%d,%d)\n", rest_x, rest_y);
+	return snprintf(sysfsbuf, PAGE_SIZE, "(%d,%d)\n", rest_x, rest_y);
 }
 
 static ssize_t applesmc_calibrate_store(struct device *dev,
@@ -625,6 +666,15 @@ static DEVICE_ATTR(position, 0444, apple
 static DEVICE_ATTR(calibrate, 0644,
 			applesmc_calibrate_show, applesmc_calibrate_store);
 
+static struct attribute *accelerometer_attributes[] = {
+	&dev_attr_position.attr,
+	&dev_attr_calibrate.attr,
+	NULL
+};
+
+static const struct attribute_group accelerometer_attributes_group =
+	{ .attrs = accelerometer_attributes };
+
 static DEVICE_ATTR(light, 0444, applesmc_light_show, NULL);
 
 /*
@@ -637,31 +687,35 @@ static DEVICE_ATTR(light, 0444, applesmc
  *  - show/store manual mode
  */
 #define sysfs_fan_speeds_offset(offset) \
-static SENSOR_DEVICE_ATTR_2(fan##offset##_actual_speed, S_IRUGO, \
-			applesmc_show_fan_speed, NULL, 0, offset); \
+static SENSOR_DEVICE_ATTR_2(fan##offset##_input, S_IRUGO, \
+			applesmc_show_fan_speed, NULL, 0, offset-1); \
 \
-static SENSOR_DEVICE_ATTR_2(fan##offset##_minimum_speed, S_IRUGO | S_IWUSR, \
-	applesmc_show_fan_speed, applesmc_store_fan_speed, 1, offset); \
+static SENSOR_DEVICE_ATTR_2(fan##offset##_min, S_IRUGO | S_IWUSR, \
+	applesmc_show_fan_speed, applesmc_store_fan_speed, 1, offset-1); \
 \
-static SENSOR_DEVICE_ATTR_2(fan##offset##_maximum_speed, S_IRUGO, \
-			applesmc_show_fan_speed, NULL, 2, offset); \
+static SENSOR_DEVICE_ATTR_2(fan##offset##_max, S_IRUGO, \
+			applesmc_show_fan_speed, NULL, 2, offset-1); \
 \
-static SENSOR_DEVICE_ATTR_2(fan##offset##_safe_speed, S_IRUGO, \
-			applesmc_show_fan_speed, NULL, 3, offset); \
+static SENSOR_DEVICE_ATTR_2(fan##offset##_safe, S_IRUGO, \
+			applesmc_show_fan_speed, NULL, 3, offset-1); \
 \
-static SENSOR_DEVICE_ATTR_2(fan##offset##_target_speed, S_IRUGO | S_IWUSR, \
-	applesmc_show_fan_speed, applesmc_store_fan_speed, 4, offset); \
+static SENSOR_DEVICE_ATTR_2(fan##offset##_output, S_IRUGO | S_IWUSR, \
+	applesmc_show_fan_speed, applesmc_store_fan_speed, 4, offset-1); \
 \
 static SENSOR_DEVICE_ATTR(fan##offset##_manual, S_IRUGO | S_IWUSR, \
-	applesmc_show_fan_manual, applesmc_store_fan_manual, offset); \
+	applesmc_show_fan_manual, applesmc_store_fan_manual, offset-1); \
+\
+static SENSOR_DEVICE_ATTR(fan##offset##_position, S_IRUGO, \
+	applesmc_show_fan_position, NULL, offset-1); \
 \
 static struct attribute *fan##offset##_attributes[] = { \
-	&sensor_dev_attr_fan##offset##_actual_speed.dev_attr.attr, \
-	&sensor_dev_attr_fan##offset##_minimum_speed.dev_attr.attr, \
-	&sensor_dev_attr_fan##offset##_maximum_speed.dev_attr.attr, \
-	&sensor_dev_attr_fan##offset##_safe_speed.dev_attr.attr, \
-	&sensor_dev_attr_fan##offset##_target_speed.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_input.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_min.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_max.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_safe.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_output.dev_attr.attr, \
 	&sensor_dev_attr_fan##offset##_manual.dev_attr.attr, \
+	&sensor_dev_attr_fan##offset##_position.dev_attr.attr, \
 	NULL \
 };
 
@@ -669,42 +723,61 @@ static struct attribute *fan##offset##_a
  * Create the needed functions for each fan using the macro defined above
  * (2 fans are supported)
  */
-sysfs_fan_speeds_offset(0);
 sysfs_fan_speeds_offset(1);
+sysfs_fan_speeds_offset(2);
 
 static const struct attribute_group fan_attribute_groups[] = {
-	{ .attrs = fan0_attributes },
-	{ .attrs = fan1_attributes }
+	{ .attrs = fan1_attributes },
+	{ .attrs = fan2_attributes }
 };
 
 /*
  * Temperature sensors sysfs entries.
  */
-static SENSOR_DEVICE_ATTR(temperature_0, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp_1_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 0);
-static SENSOR_DEVICE_ATTR(temperature_1, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp_2_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 1);
-static SENSOR_DEVICE_ATTR(temperature_2, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp_3_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 2);
-static SENSOR_DEVICE_ATTR(temperature_3, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp_4_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 3);
-static SENSOR_DEVICE_ATTR(temperature_4, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp_5_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 4);
-static SENSOR_DEVICE_ATTR(temperature_5, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp_6_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 5);
-static SENSOR_DEVICE_ATTR(temperature_6, S_IRUGO,
+static SENSOR_DEVICE_ATTR(temp_7_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 6);
+static SENSOR_DEVICE_ATTR(temp_8_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 7);
+static SENSOR_DEVICE_ATTR(temp_9_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 8);
+static SENSOR_DEVICE_ATTR(temp_10_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 9);
+static SENSOR_DEVICE_ATTR(temp_11_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 10);
+static SENSOR_DEVICE_ATTR(temp_12_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 11);
 
 static struct attribute *temperature_attributes[] = {
-	&sensor_dev_attr_temperature_0.dev_attr.attr,
-	&sensor_dev_attr_temperature_1.dev_attr.attr,
-	&sensor_dev_attr_temperature_2.dev_attr.attr,
-	&sensor_dev_attr_temperature_3.dev_attr.attr,
-	&sensor_dev_attr_temperature_4.dev_attr.attr,
-	&sensor_dev_attr_temperature_5.dev_attr.attr,
-	&sensor_dev_attr_temperature_6.dev_attr.attr,
+	&sensor_dev_attr_temp_1_input.dev_attr.attr,
+	&sensor_dev_attr_temp_2_input.dev_attr.attr,
+	&sensor_dev_attr_temp_3_input.dev_attr.attr,
+	&sensor_dev_attr_temp_4_input.dev_attr.attr,
+	&sensor_dev_attr_temp_5_input.dev_attr.attr,
+	&sensor_dev_attr_temp_6_input.dev_attr.attr,
+	&sensor_dev_attr_temp_7_input.dev_attr.attr,
+	&sensor_dev_attr_temp_8_input.dev_attr.attr,
+	&sensor_dev_attr_temp_9_input.dev_attr.attr,
+	&sensor_dev_attr_temp_10_input.dev_attr.attr,
+	&sensor_dev_attr_temp_11_input.dev_attr.attr,
+	&sensor_dev_attr_temp_12_input.dev_attr.attr,
+	NULL
 };
 
+static const struct attribute_group temperature_attributes_group =
+	{ .attrs = temperature_attributes };
+
 /* Module stuff */
 
 /*
@@ -734,18 +807,15 @@ static int applesmc_create_accelerometer
 {
 	int ret;
 
-	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_position.attr);
-	if (ret)
-		goto out;
-
-	ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_calibrate.attr);
+	ret = sysfs_create_group(&pdev->dev.kobj,
+					&accelerometer_attributes_group);
 	if (ret)
 		goto out;
 
 	applesmc_idev = input_allocate_device();
 	if (!applesmc_idev) {
 		ret = -ENOMEM;
-		goto out;
+		goto out_sysfs;
 	}
 
 	/* initial calibrate for the input device */
@@ -777,6 +847,9 @@ static int applesmc_create_accelerometer
 out_idev:
 	input_free_device(applesmc_idev);
 
+out_sysfs:
+	sysfs_remove_group(&pdev->dev.kobj, &accelerometer_attributes_group);
+
 out:
 	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
 	return ret;
@@ -787,6 +860,7 @@ static void applesmc_release_acceleromet
 {
 	del_timer_sync(&applesmc_timer);
 	input_unregister_device(applesmc_idev);
+	sysfs_remove_group(&pdev->dev.kobj, &accelerometer_attributes_group);
 }
 
 static __initdata struct dmi_match_data applesmc_dmi_data[] = {
@@ -867,7 +941,7 @@ static int __init applesmc_init(void)
 			ret = sysfs_create_group(&pdev->dev.kobj,
 						 &fan_attribute_groups[0]);
 			if (ret)
-				goto out_device;
+				goto out_fan_1;
 		case 0:
 			;
 		}
@@ -876,16 +950,24 @@ static int __init applesmc_init(void)
 	for (i = 0;
 	     temperature_sensors_sets[applesmc_temperature_set][i] != NULL;
 	     i++) {
+		if (temperature_attributes[i] == NULL) {
+			printk(KERN_ERR "applesmc: More temperature sensors "
+				"in temperature_sensors_sets (at least %i)"
+				"than available sysfs files in "
+				"temperature_attributes (%i), please report "
+				"this bug.\n", i, i-1);
+			goto out_temperature;
+		}
 		ret = sysfs_create_file(&pdev->dev.kobj,
 						temperature_attributes[i]);
 		if (ret)
-			goto out_device;
+			goto out_temperature;
 	}
 
 	if (applesmc_accelerometer) {
 		ret = applesmc_create_accelerometer();
 		if (ret)
-			goto out_device;
+			goto out_temperature;
 	}
 
 	if (applesmc_light) {
@@ -897,15 +979,33 @@ static int __init applesmc_init(void)
 		/* register as a led device */
 		ret = led_classdev_register(&pdev->dev, &applesmc_backlight);
 		if (ret < 0)
-			goto out_accelerometer;
+			goto out_light_sysfs;
+	}
+
+	hwmon_class_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(hwmon_class_dev)) {
+		ret = PTR_ERR(hwmon_class_dev);
+		goto out_light;
 	}
 
 	printk(KERN_INFO "applesmc: driver successfully loaded.\n");
+
 	return 0;
 
+out_light:
+	if (applesmc_light)
+		led_classdev_unregister(&applesmc_backlight);
+out_light_sysfs:
+	if (applesmc_light)
+		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_light.attr);
 out_accelerometer:
 	if (applesmc_accelerometer)
 		applesmc_release_accelerometer();
+out_temperature:
+	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
+	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
+out_fan_1:
+	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[1]);
 out_device:
 	platform_device_unregister(pdev);
 out_driver:
@@ -919,10 +1019,14 @@ out:
 
 static void __exit applesmc_exit(void)
 {
+	hwmon_device_unregister(hwmon_class_dev);
 	if (applesmc_light)
 		led_classdev_unregister(&applesmc_backlight);
 	if (applesmc_accelerometer)
 		applesmc_release_accelerometer();
+	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
+	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
+	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[1]);
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&applesmc_driver);
 	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
_

Patches currently in -mm which might be from nicolas@boichat.ch are

git-alsa.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-standardize-and-sanitize-sysfs-tree.patch
apple-smc-driver-implement-key-enumeration.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix.patch
