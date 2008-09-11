From: akpm@linux-foundation.org
Subject: + hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch added to -mm tree
Date: Wed, 10 Sep 2008 17:03:27 -0700
Message-ID: <200809110003.m8B03RnW001224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYIKADj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 20:03:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim.cromie@gmail.com, khali@linux-fr.org, mhoffman@lightlink.com


The patch titled
     hwmon/pc87360 separate alarm files: add temp-min/max/crit/fault-alarms
has been added to the -mm tree.  Its filename is
     hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon/pc87360 separate alarm files: add temp-min/max/crit/fault-alarms
From: Jim Cromie <jim.cromie@gmail.com>

Adds temp-min/max/crit/fault-alarm callbacks, sensor-device-attribute
declarations, and refs to those new decls in the macro used to initialize
the temp_group (of sysfs files)

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/pc87360.c |   80 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 2 deletions(-)

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
+static ssize_t show_temp_min_alarm(struct device *dev, struct device_attribute
+				   *devattr, char *buf)
+{
+	struct pc87360_data *data = pc87360_update_device(dev);
+	unsigned nr = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%u\n", !!(data->temp_status[nr] & CHAN_ALM_MIN));
+}
+static ssize_t show_temp_max_alarm(struct device *dev, struct device_attribute
+				   *devattr, char *buf)
+{
+	struct pc87360_data *data = pc87360_update_device(dev);
+	unsigned nr = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%u\n", !!(data->temp_status[nr] & CHAN_ALM_MAX));
+}
+static ssize_t show_temp_crit_alarm(struct device *dev, struct device_attribute
+				   *devattr, char *buf)
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
+static ssize_t show_temp_fault(struct device *dev, struct device_attribute
+			       *devattr, char *buf)
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

hwmon-pc87360-separate-alarm-files-define-some-constants.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-define-ldni_max-const.patch
hwmon-pc87360-separate-alarm-files-add-dev_dbg-help.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch

