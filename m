From: akpm@linux-foundation.org
Subject: - hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:35:00 -0700
Message-ID: <200810202035.m9KKZ0d0010980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753677AbYJTUfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim.cromie@gmail.com, khali@linux-fr.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hwmon/pc87360 separate alarm files: add therm-min/max/crit-alarms
has been removed from the -mm tree.  Its filename was
     hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon/pc87360 separate alarm files: add therm-min/max/crit-alarms
From: Jim Cromie <jim.cromie@gmail.com>

Adds therm-min/max/crit-alarm callbacks, sensor-device-attribute
declarations, and refs to those new decls in the macro used to initialize
the therm_group (of sysfs files)

The thermistors use voltage channels to measure; so they don't have a
fault-alarm, but unlike the other voltages, they do have an overtemp,
which we call crit (by convention).

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/pc87360.c |   58 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms drivers/hwmon/pc87360.c
--- a/drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms
+++ a/drivers/hwmon/pc87360.c
@@ -714,12 +714,68 @@ static struct sensor_device_attribute th
 		    show_therm_crit, set_therm_crit, 2+11),
 };
 
+/* show_therm_min/max_alarm() reads data from the per-channel voltage
+   status register (sec 11.5.12) */
+
+static ssize_t show_therm_min_alarm(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	struct pc87360_data *data = pc87360_update_device(dev);
+	unsigned nr = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%u\n", !!(data->in_status[nr] & CHAN_ALM_MIN));
+}
+static ssize_t show_therm_max_alarm(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	struct pc87360_data *data = pc87360_update_device(dev);
+	unsigned nr = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%u\n", !!(data->in_status[nr] & CHAN_ALM_MAX));
+}
+static ssize_t show_therm_crit_alarm(struct device *dev,
+				struct device_attribute *devattr, char *buf)
+{
+	struct pc87360_data *data = pc87360_update_device(dev);
+	unsigned nr = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%u\n", !!(data->in_status[nr] & TEMP_ALM_CRIT));
+}
+
+static struct sensor_device_attribute therm_min_alarm[] = {
+	SENSOR_ATTR(temp4_min_alarm, S_IRUGO,
+		    show_therm_min_alarm, NULL, 0+11),
+	SENSOR_ATTR(temp5_min_alarm, S_IRUGO,
+		    show_therm_min_alarm, NULL, 1+11),
+	SENSOR_ATTR(temp6_min_alarm, S_IRUGO,
+		    show_therm_min_alarm, NULL, 2+11),
+};
+static struct sensor_device_attribute therm_max_alarm[] = {
+	SENSOR_ATTR(temp4_max_alarm, S_IRUGO,
+		    show_therm_max_alarm, NULL, 0+11),
+	SENSOR_ATTR(temp5_max_alarm, S_IRUGO,
+		    show_therm_max_alarm, NULL, 1+11),
+	SENSOR_ATTR(temp6_max_alarm, S_IRUGO,
+		    show_therm_max_alarm, NULL, 2+11),
+};
+static struct sensor_device_attribute therm_crit_alarm[] = {
+	SENSOR_ATTR(temp4_crit_alarm, S_IRUGO,
+		    show_therm_crit_alarm, NULL, 0+11),
+	SENSOR_ATTR(temp5_crit_alarm, S_IRUGO,
+		    show_therm_crit_alarm, NULL, 1+11),
+	SENSOR_ATTR(temp6_crit_alarm, S_IRUGO,
+		    show_therm_crit_alarm, NULL, 2+11),
+};
+
 #define THERM_UNIT_ATTRS(X) \
 	&therm_input[X].dev_attr.attr,	\
 	&therm_status[X].dev_attr.attr,	\
 	&therm_min[X].dev_attr.attr,	\
 	&therm_max[X].dev_attr.attr,	\
-	&therm_crit[X].dev_attr.attr
+	&therm_crit[X].dev_attr.attr,	\
+	&therm_min_alarm[X].dev_attr.attr, \
+	&therm_max_alarm[X].dev_attr.attr, \
+	&therm_crit_alarm[X].dev_attr.attr
 
 static struct attribute * pc8736x_therm_attr_array[] = {
 	THERM_UNIT_ATTRS(0),
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

origin.patch

