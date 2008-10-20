From: akpm@linux-foundation.org
Subject: - hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:54 -0700
Message-ID: <200810202034.m9KKYspE010963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635AbYJTUfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:35:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim.cromie@gmail.com, khali@linux-fr.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hwmon/pc87360 separate alarm files: add temp-min/max/crit/fault-alarms
has been removed from the -mm tree.  Its filename was
     hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon/pc87360 separate alarm files: add temp-min/max/crit/fault-alarms
From: Jim Cromie <jim.cromie@gmail.com>

Adds temp-min/max/crit/fault-alarm callbacks, sensor-device-attribute
declarations, and refs to those new decls in the macro used to initialize
the temp_group (of sysfs files)

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/pc87360.c |   84 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 4 deletions(-)

diff -puN drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms drivers/hwmon/pc87360.c
--- a/drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms
+++ a/drivers/hwmon/pc87360.c
@@ -845,12 +845,76 @@ static ssize_t show_temp_alarms(struct d
 }
 static DEVICE_ATTR(alarms_temp, S_IRUGO, show_temp_alarms, NULL);
 
+/* show_temp_min/max_alarm() reads data from the per-channel status
+   register (sec 12.3.7), not the temp event status registers (sec
+   12.3.2) that show_temp_alarm() reads (via data->temp_alarms) */
+
+static ssize_t show_temp_min_alarm(struct device *dev,
+			struct device_attribute *devattr, char *buf)
+{
+	struct pc87360_data *data = pc87360_update_device(dev);
+	unsigned nr = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%u\n", !!(data->temp_status[nr] & CHAN_ALM_MIN));
+}
+static ssize_t show_temp_max_alarm(struct device *dev,
+			struct device_attribute *devattr, char *buf)
+{
+	struct pc87360_data *data = pc87360_update_device(dev);
+	unsigned nr = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%u\n", !!(data->temp_status[nr] & CHAN_ALM_MAX));
+}
+static ssize_t show_temp_crit_alarm(struct device *dev,
+			struct device_attribute *devattr, char *buf)
+{
+	struct pc87360_data *data = pc87360_update_device(dev);
+	unsigned nr = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%u\n", !!(data->temp_status[nr] & TEMP_ALM_CRIT));
+}
+
+static struct sensor_device_attribute temp_min_alarm[] = {
+	SENSOR_ATTR(temp1_min_alarm, S_IRUGO, show_temp_min_alarm, NULL, 0),
+	SENSOR_ATTR(temp2_min_alarm, S_IRUGO, show_temp_min_alarm, NULL, 1),
+	SENSOR_ATTR(temp3_min_alarm, S_IRUGO, show_temp_min_alarm, NULL, 2),
+};
+static struct sensor_device_attribute temp_max_alarm[] = {
+	SENSOR_ATTR(temp1_max_alarm, S_IRUGO, show_temp_max_alarm, NULL, 0),
+	SENSOR_ATTR(temp2_max_alarm, S_IRUGO, show_temp_max_alarm, NULL, 1),
+	SENSOR_ATTR(temp3_max_alarm, S_IRUGO, show_temp_max_alarm, NULL, 2),
+};
+static struct sensor_device_attribute temp_crit_alarm[] = {
+	SENSOR_ATTR(temp1_crit_alarm, S_IRUGO, show_temp_crit_alarm, NULL, 0),
+	SENSOR_ATTR(temp2_crit_alarm, S_IRUGO, show_temp_crit_alarm, NULL, 1),
+	SENSOR_ATTR(temp3_crit_alarm, S_IRUGO, show_temp_crit_alarm, NULL, 2),
+};
+
+#define TEMP_FAULT	0x40	/* open diode */
+static ssize_t show_temp_fault(struct device *dev,
+			struct device_attribute *devattr, char *buf)
+{
+	struct pc87360_data *data = pc87360_update_device(dev);
+	unsigned nr = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%u\n", !!(data->temp_status[nr] & TEMP_FAULT));
+}
+static struct sensor_device_attribute temp_fault[] = {
+	SENSOR_ATTR(temp1_fault, S_IRUGO, show_temp_fault, NULL, 0),
+	SENSOR_ATTR(temp2_fault, S_IRUGO, show_temp_fault, NULL, 1),
+	SENSOR_ATTR(temp3_fault, S_IRUGO, show_temp_fault, NULL, 2),
+};
+
 #define TEMP_UNIT_ATTRS(X) \
 	&temp_input[X].dev_attr.attr,	\
 	&temp_status[X].dev_attr.attr,	\
 	&temp_min[X].dev_attr.attr,	\
 	&temp_max[X].dev_attr.attr,	\
-	&temp_crit[X].dev_attr.attr
+	&temp_crit[X].dev_attr.attr,	\
+	&temp_min_alarm[X].dev_attr.attr, \
+	&temp_max_alarm[X].dev_attr.attr, \
+	&temp_crit_alarm[X].dev_attr.attr, \
+	&temp_fault[X].dev_attr.attr
 
 static struct attribute * pc8736x_temp_attr_array[] = {
 	TEMP_UNIT_ATTRS(0),
@@ -864,8 +928,8 @@ static const struct attribute_group pc87
 	.attrs = pc8736x_temp_attr_array,
 };
 
-static ssize_t show_name(struct device *dev, struct device_attribute
-			 *devattr, char *buf)
+static ssize_t show_name(struct device *dev,
+			struct device_attribute *devattr, char *buf)
 {
 	struct pc87360_data *data = dev_get_drvdata(dev);
 	return sprintf(buf, "%s\n", data->name);
@@ -1086,7 +1150,15 @@ static int __devinit pc87360_probe(struc
 			    || (err = device_create_file(dev,
 					&temp_crit[i].dev_attr))
 			    || (err = device_create_file(dev,
-					&temp_status[i].dev_attr)))
+					&temp_status[i].dev_attr))
+			    || (err = device_create_file(dev,
+					&temp_min_alarm[i].dev_attr))
+			    || (err = device_create_file(dev,
+					&temp_max_alarm[i].dev_attr))
+			    || (err = device_create_file(dev,
+					&temp_crit_alarm[i].dev_attr))
+			    || (err = device_create_file(dev,
+					&temp_fault[i].dev_attr)))
 				goto ERROR3;
 		}
 		if ((err = device_create_file(dev, &dev_attr_alarms_temp)))
@@ -1192,6 +1264,10 @@ static void pc87360_write_value(struct p
 #define CHAN_ALM_ENA	0x10	/* propagate to alarms-reg ?? (chk val!) */
 #define CHAN_READY	(CHAN_ENA|CHAN_CNVRTD) /* sample ready mask */
 
+#define TEMP_OTS_OE	0x20	/* OTS Output Enable */
+#define VIN_RW1C_MASK	(CHAN_READY|CHAN_ALM_MAX|CHAN_ALM_MIN)   /* 0x87 */
+#define TEMP_RW1C_MASK	(VIN_RW1C_MASK|TEMP_ALM_CRIT|TEMP_FAULT) /* 0xCF */
+
 static void pc87360_init_device(struct platform_device *pdev,
 				int use_thermistors)
 {
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

origin.patch

