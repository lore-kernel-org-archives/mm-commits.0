From: akpm@linux-foundation.org
Subject: + hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch added to -mm tree
Date: Wed, 10 Sep 2008 17:03:23 -0700
Message-ID: <200809110003.m8B03NrE001215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbYIKADf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 20:03:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jim.cromie@gmail.com, khali@linux-fr.org, mhoffman@lightlink.com


The patch titled
     hwmon/pc87360 separate alarm files: add in-min/max-alarms
has been added to the -mm tree.  Its filename is
     hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch

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
Subject: hwmon/pc87360 separate alarm files: add in-min/max-alarms
From: Jim Cromie <jim.cromie@gmail.com>

Adds vin-min/max-alarm callbacks, sensor-device-attribute declarations,
and refs to those new decls in the macro used to initialize the vin_group
(of sysfs files)

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/pc87360.c |   52 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms drivers/hwmon/pc87360.c
--- a/drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms
+++ a/drivers/hwmon/pc87360.c
@@ -494,11 +494,61 @@ static struct sensor_device_attribute in
 #define CHAN_ALM_MAX	0x04	/* max limit exceeded */
 #define TEMP_ALM_CRIT	0x08	/* temp crit exceeded (temp only) */
 
+/* show_in_min/max_alarm() reads data from the per-channel status
+   register (sec 11.5.12), not the vin event status registers (sec
+   11.5.2) that (legacy) show_in_alarm() resds (via data->in_alarms) */
+
+static ssize_t show_in_min_alarm(struct device *dev, struct device_attribute
+			     *devattr, char *buf)
+{
+	struct pc87360_data *data = pc87360_update_device(dev);
+	unsigned nr = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%u\n", !!(data->in_status[nr] & CHAN_ALM_MIN));
+}
+static ssize_t show_in_max_alarm(struct device *dev, struct device_attribute
+			     *devattr, char *buf)
+{
+	struct pc87360_data *data = pc87360_update_device(dev);
+	unsigned nr = to_sensor_dev_attr(devattr)->index;
+
+	return sprintf(buf, "%u\n", !!(data->in_status[nr] & CHAN_ALM_MAX));
+}
+
+static struct sensor_device_attribute in_min_alarm[] = {
+	SENSOR_ATTR(in0_min_alarm, S_IRUGO, show_in_min_alarm, NULL, 0),
+	SENSOR_ATTR(in1_min_alarm, S_IRUGO, show_in_min_alarm, NULL, 1),
+	SENSOR_ATTR(in2_min_alarm, S_IRUGO, show_in_min_alarm, NULL, 2),
+	SENSOR_ATTR(in3_min_alarm, S_IRUGO, show_in_min_alarm, NULL, 3),
+	SENSOR_ATTR(in4_min_alarm, S_IRUGO, show_in_min_alarm, NULL, 4),
+	SENSOR_ATTR(in5_min_alarm, S_IRUGO, show_in_min_alarm, NULL, 5),
+	SENSOR_ATTR(in6_min_alarm, S_IRUGO, show_in_min_alarm, NULL, 6),
+	SENSOR_ATTR(in7_min_alarm, S_IRUGO, show_in_min_alarm, NULL, 7),
+	SENSOR_ATTR(in8_min_alarm, S_IRUGO, show_in_min_alarm, NULL, 8),
+	SENSOR_ATTR(in9_min_alarm, S_IRUGO, show_in_min_alarm, NULL, 9),
+	SENSOR_ATTR(in10_min_alarm, S_IRUGO, show_in_min_alarm, NULL, 10),
+};
+static struct sensor_device_attribute in_max_alarm[] = {
+	SENSOR_ATTR(in0_max_alarm, S_IRUGO, show_in_max_alarm, NULL, 0),
+	SENSOR_ATTR(in1_max_alarm, S_IRUGO, show_in_max_alarm, NULL, 1),
+	SENSOR_ATTR(in2_max_alarm, S_IRUGO, show_in_max_alarm, NULL, 2),
+	SENSOR_ATTR(in3_max_alarm, S_IRUGO, show_in_max_alarm, NULL, 3),
+	SENSOR_ATTR(in4_max_alarm, S_IRUGO, show_in_max_alarm, NULL, 4),
+	SENSOR_ATTR(in5_max_alarm, S_IRUGO, show_in_max_alarm, NULL, 5),
+	SENSOR_ATTR(in6_max_alarm, S_IRUGO, show_in_max_alarm, NULL, 6),
+	SENSOR_ATTR(in7_max_alarm, S_IRUGO, show_in_max_alarm, NULL, 7),
+	SENSOR_ATTR(in8_max_alarm, S_IRUGO, show_in_max_alarm, NULL, 8),
+	SENSOR_ATTR(in9_max_alarm, S_IRUGO, show_in_max_alarm, NULL, 9),
+	SENSOR_ATTR(in10_max_alarm, S_IRUGO, show_in_max_alarm, NULL, 10),
+};
+
 #define VIN_UNIT_ATTRS(X) \
 	&in_input[X].dev_attr.attr,	\
 	&in_status[X].dev_attr.attr,	\
 	&in_min[X].dev_attr.attr,	\
-	&in_max[X].dev_attr.attr
+	&in_max[X].dev_attr.attr,	\
+	&in_min_alarm[X].dev_attr.attr,	\
+	&in_max_alarm[X].dev_attr.attr
 
 static ssize_t show_vid(struct device *dev, struct device_attribute *attr, char *buf)
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

