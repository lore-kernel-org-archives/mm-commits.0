From: akpm@linux-foundation.org
Subject: - apple-smc-driver-implement-key-enumeration.patch removed from -mm tree
Date: Thu, 26 Apr 2007 00:13:40 -0700
Message-ID: <200704260713.l3Q7DesA023494@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933185AbXDZHOy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 03:14:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas@boichat.ch, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     Apple SMC driver: implement key enumeration
has been removed from the -mm tree.  Its filename was
     apple-smc-driver-implement-key-enumeration.patch

This patch was dropped because it was folded into apple-smc-driver-hardware-monitoring-and-control.patch

------------------------------------------------------
Subject: Apple SMC driver: implement key enumeration
From: Nicolas Boichat <nicolas@boichat.ch>

Apple SMC allows to enumerate all keys available on the device. This is
useful to discover new sensors. With this feature, I'll be able to ask
people with different macintel for their key lists, and update the
driver accordingly. (note: I don't think it is reasonable to auto-detect
temperature sensors when the driver is loaded, as enumerating all the
keys takes a long time)

It works this way:
# cd /sys/devices/platform/applesmc
# echo 2 > key_at_index
(replace 2 with any number between 0 and the value you can read in
key_count)
# cat key_at_index_name
ACID
# cat key_at_index_type
ch8*
# cat key_at_index_data_length
8
# hexdump -C key_at_index_data
00000000  ba 31 96 0b 50 05 10 74 |.1..P..t|
(key_at_index_data output is binary, is it acceptable for a sysfs file?)

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/applesmc.c |  263 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 262 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/applesmc.c~apple-smc-driver-implement-key-enumeration drivers/hwmon/applesmc.c
--- a/drivers/hwmon/applesmc.c~apple-smc-driver-implement-key-enumeration
+++ a/drivers/hwmon/applesmc.c
@@ -51,6 +51,10 @@
 #define APPLESMC_STATUS_MASK	0x0f
 #define APPLESMC_READ_CMD	0x10
 #define APPLESMC_WRITE_CMD	0x11
+#define APPLESMC_GET_KEY_BY_INDEX_CMD	0x12
+#define APPLESMC_GET_KEY_TYPE_CMD	0x13
+
+#define KEY_COUNT_KEY		"#KEY" /* r-o ui32 */
 
 #define LIGHT_SENSOR_LEFT_KEY	"ALV0" /* r-o {alv (6 bytes) */
 #define LIGHT_SENSOR_RIGHT_KEY	"ALV1" /* r-o {alv (6 bytes) */
@@ -132,6 +136,12 @@ static unsigned int applesmc_temperature
 static struct mutex applesmc_lock;
 
 /*
+ * Last index written to key_at_index sysfs file, and value to use for all other
+ * key_at_index_* sysfs files.
+ */
+static unsigned int key_at_index;
+
+/*
  * __wait_status - Wait up to 100ms for the status port to get a certain value
  * (masked with 0x0f), returning zero if the value is obtained.  Callers must
  * hold applesmc_lock.
@@ -235,6 +245,73 @@ static int applesmc_write_key(const char
 }
 
 /*
+ * applesmc_get_key_at_index - get key at index, and put the result in key
+ * (char[6]). Returns zero on success or a negative error on failure. Callers
+ * must hold applesmc_lock.
+ */
+static int applesmc_get_key_at_index(int index, char* key)
+{
+	int i;
+	u8 readkey[4];
+	readkey[0] = index >> 24;
+	readkey[1] = index >> 16;
+	readkey[2] = index >> 8;
+	readkey[3] = index;
+
+	outb(APPLESMC_GET_KEY_BY_INDEX_CMD, APPLESMC_CMD_PORT);
+	if (__wait_status(0x0c))
+		return -EIO;
+
+	for (i = 0; i < 4; i++) {
+		outb(readkey[i], APPLESMC_DATA_PORT);
+		if (__wait_status(0x04))
+			return -EIO;
+	}
+
+	outb(4, APPLESMC_DATA_PORT);
+
+	for (i = 0; i < 4; i++) {
+		if (__wait_status(0x05))
+			return -EIO;
+		key[i] = inb(APPLESMC_DATA_PORT);
+	}
+	key[4] = 0;
+
+	return 0;
+}
+
+/*
+ * applesmc_get_key_type - get key type, and put the result in type (char[6]).
+ * Returns zero on success or a negative error on failure. Callers must
+ * hold applesmc_lock.
+ */
+static int applesmc_get_key_type(char* key, char* type)
+{
+	int i;
+
+	outb(APPLESMC_GET_KEY_TYPE_CMD, APPLESMC_CMD_PORT);
+	if (__wait_status(0x0c))
+		return -EIO;
+
+	for (i = 0; i < 4; i++) {
+		outb(key[i], APPLESMC_DATA_PORT);
+		if (__wait_status(0x04))
+			return -EIO;
+	}
+
+	outb(5, APPLESMC_DATA_PORT);
+
+	for (i = 0; i < 6; i++) {
+		if (__wait_status(0x05))
+			return -EIO;
+		type[i] = inb(APPLESMC_DATA_PORT);
+	}
+	type[5] = 0;
+
+	return 0;
+}
+
+/*
  * applesmc_read_motion_sensor - Read motion sensor (X, Y or Z). Callers must
  * hold applesmc_lock.
  */
@@ -656,6 +733,157 @@ static void applesmc_backlight_set(struc
 	mutex_unlock(&applesmc_lock);
 }
 
+static ssize_t applesmc_key_count_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	int ret;
+	u8 buffer[4];
+	u32 count;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_read_key(KEY_COUNT_KEY, buffer, 4);
+	count = ((u32)buffer[0]<<24) + ((u32)buffer[1]<<16) +
+						((u32)buffer[2]<<8) + buffer[3];
+
+	mutex_unlock(&applesmc_lock);
+	if (ret)
+		return ret;
+	else
+		return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", count);
+}
+
+static ssize_t applesmc_key_at_index_read_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	char key[5];
+	char info[6];
+	int ret;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_get_key_at_index(key_at_index, key);
+
+	if (ret || !key[0]) {
+		mutex_unlock(&applesmc_lock);
+
+		return -EINVAL;
+	}
+
+	ret = applesmc_get_key_type(key, info);
+
+	if (ret) {
+		mutex_unlock(&applesmc_lock);
+
+		return ret;
+	}
+
+	/*
+	 * info[0] maximum value (APPLESMC_MAX_DATA_LENGTH) is much lower than
+	 * PAGE_SIZE, so we don't need any checks before writing to sysfsbuf.
+	 */
+	ret = applesmc_read_key(key, sysfsbuf, info[0]);
+
+	mutex_unlock(&applesmc_lock);
+
+	if (!ret) {
+		return info[0];
+	}
+	else {
+		return ret;
+	}
+}
+
+static ssize_t applesmc_key_at_index_data_length_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	char key[5];
+	char info[6];
+	int ret;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_get_key_at_index(key_at_index, key);
+
+	if (ret || !key[0]) {
+		mutex_unlock(&applesmc_lock);
+
+		return -EINVAL;
+	}
+
+	ret = applesmc_get_key_type(key, info);
+
+	mutex_unlock(&applesmc_lock);
+
+	if (!ret)
+		return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", info[0]);
+	else
+		return ret;
+}
+
+static ssize_t applesmc_key_at_index_type_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	char key[5];
+	char info[6];
+	int ret;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_get_key_at_index(key_at_index, key);
+
+	if (ret || !key[0]) {
+		mutex_unlock(&applesmc_lock);
+
+		return -EINVAL;
+	}
+
+	ret = applesmc_get_key_type(key, info);
+
+	mutex_unlock(&applesmc_lock);
+
+	if (!ret)
+		return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", info+1);
+	else
+		return ret;
+}
+
+static ssize_t applesmc_key_at_index_name_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	char key[5];
+	int ret;
+
+	mutex_lock(&applesmc_lock);
+
+	ret = applesmc_get_key_at_index(key_at_index, key);
+
+	mutex_unlock(&applesmc_lock);
+
+	if (!ret && key[0])
+		return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", key);
+	else
+		return -EINVAL;
+}
+
+static ssize_t applesmc_key_at_index_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	return snprintf(sysfsbuf, PAGE_SIZE, "%d\n", key_at_index);
+}
+
+static ssize_t applesmc_key_at_index_store(struct device *dev,
+	struct device_attribute *attr, const char *sysfsbuf, size_t count)
+{
+	mutex_lock(&applesmc_lock);
+
+	key_at_index = simple_strtoul(sysfsbuf, NULL, 10);
+
+	mutex_unlock(&applesmc_lock);
+
+	return count;
+}
+
 static struct led_classdev applesmc_backlight = {
 	.name			= "smc:kbd_backlight",
 	.default_trigger	= "nand-disk",
@@ -677,6 +905,31 @@ static const struct attribute_group acce
 
 static DEVICE_ATTR(light, 0444, applesmc_light_show, NULL);
 
+static DEVICE_ATTR(key_count, 0444, applesmc_key_count_show, NULL);
+static DEVICE_ATTR(key_at_index, 0644,
+		applesmc_key_at_index_show, applesmc_key_at_index_store);
+static DEVICE_ATTR(key_at_index_name, 0444,
+					applesmc_key_at_index_name_show, NULL);
+static DEVICE_ATTR(key_at_index_type, 0444,
+					applesmc_key_at_index_type_show, NULL);
+static DEVICE_ATTR(key_at_index_data_length, 0444,
+				applesmc_key_at_index_data_length_show, NULL);
+static DEVICE_ATTR(key_at_index_data, 0444,
+				applesmc_key_at_index_read_show, NULL);
+
+static struct attribute *key_enumeration_attributes[] = {
+	&dev_attr_key_count.attr,
+	&dev_attr_key_at_index.attr,
+	&dev_attr_key_at_index_name.attr,
+	&dev_attr_key_at_index_type.attr,
+	&dev_attr_key_at_index_data_length.attr,
+	&dev_attr_key_at_index_data.attr,
+	NULL
+};
+
+static const struct attribute_group key_enumeration_group =
+	{ .attrs = key_enumeration_attributes };
+
 /*
  * Macro defining SENSOR_DEVICE_ATTR for a fan sysfs entries.
  *  - show actual speed
@@ -920,6 +1173,11 @@ static int __init applesmc_init(void)
 		goto out_driver;
 	}
 
+	/* Create key enumeration sysfs files */
+	ret = sysfs_create_group(&pdev->dev.kobj, &key_enumeration_group);
+	if (ret)
+		goto out_device;
+
 	/* create fan files */
 	count = applesmc_get_fan_count();
 	if (count < 0) {
@@ -936,7 +1194,7 @@ static int __init applesmc_init(void)
 			ret = sysfs_create_group(&pdev->dev.kobj,
 						 &fan_attribute_groups[1]);
 			if (ret)
-				goto out_device;
+				goto out_key_enumeration;
 		case 1:
 			ret = sysfs_create_group(&pdev->dev.kobj,
 						 &fan_attribute_groups[0]);
@@ -1006,6 +1264,8 @@ out_temperature:
 	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
 out_fan_1:
 	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[1]);
+out_key_enumeration:
+	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
 out_device:
 	platform_device_unregister(pdev);
 out_driver:
@@ -1027,6 +1287,7 @@ static void __exit applesmc_exit(void)
 	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);
 	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[0]);
 	sysfs_remove_group(&pdev->dev.kobj, &fan_attribute_groups[1]);
+	sysfs_remove_group(&pdev->dev.kobj, &key_enumeration_group);
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&applesmc_driver);
 	release_region(APPLESMC_DATA_PORT, APPLESMC_NR_PORTS);
_

Patches currently in -mm which might be from nicolas@boichat.ch are

git-alsa.patch
apple-smc-driver-hardware-monitoring-and-control.patch
apple-smc-driver-implement-key-enumeration.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue.patch
applesmc-fix-crash-when-activating-a-led-trigger-on-the-keyboard-backlight-use-a-workqueue-fix.patch
