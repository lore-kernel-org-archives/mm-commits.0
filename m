From: akpm@linux-foundation.org
Subject: + adt7470-support-per-sensor-alarm-files.patch added to -mm tree
Date: Fri, 18 Jan 2008 14:19:39 -0800
Message-ID: <200801182219.m0IMJdgU008107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33514 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763648AbYARWUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jan 2008 17:20:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, khali@linux-fr.org, mhoffman@lightlink.com


The patch titled
     adt7470: support per-sensor alarm files
has been added to the -mm tree.  Its filename is
     adt7470-support-per-sensor-alarm-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adt7470: support per-sensor alarm files
From: "Darrick J. Wong" <djwong@us.ibm.com>

Remove the old alarms hack and replace it with per-sensor alarm files.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adt7470.c |   96 +++++++++++++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 12 deletions(-)

diff -puN drivers/hwmon/adt7470.c~adt7470-support-per-sensor-alarm-files drivers/hwmon/adt7470.c
--- a/drivers/hwmon/adt7470.c~adt7470-support-per-sensor-alarm-files
+++ a/drivers/hwmon/adt7470.c
@@ -48,7 +48,22 @@ I2C_CLIENT_INSMOD_1(adt7470);
 #define ADT7470_REG_CFG				0x40
 #define		ADT7470_FSPD_MASK		0x04
 #define ADT7470_REG_ALARM1			0x41
+#define		ADT7470_R1T_ALARM		0x01
+#define		ADT7470_R2T_ALARM		0x02
+#define		ADT7470_R3T_ALARM		0x04
+#define		ADT7470_R4T_ALARM		0x08
+#define		ADT7470_R5T_ALARM		0x10
+#define		ADT7470_R6T_ALARM		0x20
+#define		ADT7470_R7T_ALARM		0x40
+#define		ADT7470_OOL_ALARM		0x80
 #define ADT7470_REG_ALARM2			0x42
+#define		ADT7470_R8T_ALARM		0x01
+#define		ADT7470_R9T_ALARM		0x02
+#define		ADT7470_R10T_ALARM		0x04
+#define		ADT7470_FAN1_ALARM		0x10
+#define		ADT7470_FAN2_ALARM		0x20
+#define		ADT7470_FAN3_ALARM		0x40
+#define		ADT7470_FAN4_ALARM		0x80
 #define ADT7470_REG_TEMP_LIMITS_BASE_ADDR	0x44
 #define ADT7470_REG_TEMP_LIMITS_MAX_ADDR	0x57
 #define ADT7470_REG_FAN_MIN_BASE_ADDR		0x58
@@ -97,6 +112,8 @@ I2C_CLIENT_INSMOD_1(adt7470);
 #define ADT7470_REG_PWM_AUTO_TEMP(x)	(ADT7470_REG_PWM_AUTO_TEMP_BASE_ADDR + \
 					((x) / 2))
 
+#define ALARM2(x)		((x) << 8)
+
 #define ADT7470_VENDOR		0x41
 #define ADT7470_DEVICE		0x70
 /* datasheet only mentions a revision 2 */
@@ -136,7 +153,8 @@ struct adt7470_data {
 	u16			fan[ADT7470_FAN_COUNT];
 	u16			fan_min[ADT7470_FAN_COUNT];
 	u16			fan_max[ADT7470_FAN_COUNT];
-	u16			alarms, alarms_mask;
+	u16			alarm;
+	u16			alarms_mask;
 	u8			force_pwm_max;
 	u8			pwm[ADT7470_PWM_COUNT];
 	u8			pwm_max[ADT7470_PWM_COUNT];
@@ -260,7 +278,10 @@ static struct adt7470_data *adt7470_upda
 	else
 		data->force_pwm_max = 0;
 
-	data->alarms = adt7470_read_word_data(client, ADT7470_REG_ALARM1);
+	data->alarm = i2c_smbus_read_byte_data(client, ADT7470_REG_ALARM1);
+	if (data->alarm & ADT7470_OOL_ALARM)
+		data->alarm |= ALARM2(i2c_smbus_read_byte_data(client,
+							ADT7470_REG_ALARM2));
 	data->alarms_mask = adt7470_read_word_data(client,
 						   ADT7470_REG_ALARM1_MASK);
 
@@ -368,17 +389,13 @@ static ssize_t show_temp(struct device *
 	return sprintf(buf, "%d\n", 1000 * data->temp[attr->index]);
 }
 
-static ssize_t show_alarms(struct device *dev,
+static ssize_t show_alarm_mask(struct device *dev,
 			   struct device_attribute *devattr,
 			   char *buf)
 {
-	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct adt7470_data *data = adt7470_update_device(dev);
 
-	if (attr->index)
-		return sprintf(buf, "%x\n", data->alarms);
-	else
-		return sprintf(buf, "%x\n", data->alarms_mask);
+	return sprintf(buf, "%x\n", data->alarms_mask);
 }
 
 static ssize_t show_fan_max(struct device *dev,
@@ -713,8 +730,20 @@ static ssize_t set_pwm_auto_temp(struct 
 	return count;
 }
 
-static SENSOR_DEVICE_ATTR(alarms, S_IRUGO, show_alarms, NULL, 0);
-static SENSOR_DEVICE_ATTR(alarm_mask, S_IRUGO, show_alarms, NULL, 1);
+static ssize_t show_alarm(struct device *dev,
+			  struct device_attribute *devattr,
+			  char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct adt7470_data *data = adt7470_update_device(dev);
+
+	if (data->alarm & attr->index)
+		return sprintf(buf, "1\n");
+	else
+		return sprintf(buf, "0\n");
+}
+
+static DEVICE_ATTR(alarm_mask, S_IRUGO, show_alarm_mask, NULL);
 
 static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp_max,
 		    set_temp_max, 0);
@@ -769,6 +798,27 @@ static SENSOR_DEVICE_ATTR(temp8_input, S
 static SENSOR_DEVICE_ATTR(temp9_input, S_IRUGO, show_temp, NULL, 8);
 static SENSOR_DEVICE_ATTR(temp10_input, S_IRUGO, show_temp, NULL, 9);
 
+static SENSOR_DEVICE_ATTR(temp1_alarm, S_IRUGO, show_alarm, NULL,
+			  ADT7470_R1T_ALARM);
+static SENSOR_DEVICE_ATTR(temp2_alarm, S_IRUGO, show_alarm, NULL,
+			  ADT7470_R2T_ALARM);
+static SENSOR_DEVICE_ATTR(temp3_alarm, S_IRUGO, show_alarm, NULL,
+			  ADT7470_R3T_ALARM);
+static SENSOR_DEVICE_ATTR(temp4_alarm, S_IRUGO, show_alarm, NULL,
+			  ADT7470_R4T_ALARM);
+static SENSOR_DEVICE_ATTR(temp5_alarm, S_IRUGO, show_alarm, NULL,
+			  ADT7470_R5T_ALARM);
+static SENSOR_DEVICE_ATTR(temp6_alarm, S_IRUGO, show_alarm, NULL,
+			  ADT7470_R6T_ALARM);
+static SENSOR_DEVICE_ATTR(temp7_alarm, S_IRUGO, show_alarm, NULL,
+			  ADT7470_R7T_ALARM);
+static SENSOR_DEVICE_ATTR(temp8_alarm, S_IRUGO, show_alarm, NULL,
+			  ALARM2(ADT7470_R8T_ALARM));
+static SENSOR_DEVICE_ATTR(temp9_alarm, S_IRUGO, show_alarm, NULL,
+			  ALARM2(ADT7470_R9T_ALARM));
+static SENSOR_DEVICE_ATTR(temp10_alarm, S_IRUGO, show_alarm, NULL,
+			  ALARM2(ADT7470_R10T_ALARM));
+
 static SENSOR_DEVICE_ATTR(fan1_max, S_IWUSR | S_IRUGO, show_fan_max,
 		    set_fan_max, 0);
 static SENSOR_DEVICE_ATTR(fan2_max, S_IWUSR | S_IRUGO, show_fan_max,
@@ -792,6 +842,15 @@ static SENSOR_DEVICE_ATTR(fan2_input, S_
 static SENSOR_DEVICE_ATTR(fan3_input, S_IRUGO, show_fan, NULL, 2);
 static SENSOR_DEVICE_ATTR(fan4_input, S_IRUGO, show_fan, NULL, 3);
 
+static SENSOR_DEVICE_ATTR(fan1_alarm, S_IRUGO, show_alarm, NULL,
+			  ALARM2(ADT7470_FAN1_ALARM));
+static SENSOR_DEVICE_ATTR(fan2_alarm, S_IRUGO, show_alarm, NULL,
+			  ALARM2(ADT7470_FAN2_ALARM));
+static SENSOR_DEVICE_ATTR(fan3_alarm, S_IRUGO, show_alarm, NULL,
+			  ALARM2(ADT7470_FAN3_ALARM));
+static SENSOR_DEVICE_ATTR(fan4_alarm, S_IRUGO, show_alarm, NULL,
+			  ALARM2(ADT7470_FAN4_ALARM));
+
 static SENSOR_DEVICE_ATTR(force_pwm_max, S_IWUSR | S_IRUGO,
 		    show_force_pwm_max, set_force_pwm_max, 0);
 
@@ -856,8 +915,7 @@ static SENSOR_DEVICE_ATTR(pwm4_auto_chan
 
 static struct attribute *adt7470_attr[] =
 {
-	&sensor_dev_attr_alarms.dev_attr.attr,
-	&sensor_dev_attr_alarm_mask.dev_attr.attr,
+	&dev_attr_alarm_mask.attr,
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
 	&sensor_dev_attr_temp2_max.dev_attr.attr,
 	&sensor_dev_attr_temp3_max.dev_attr.attr,
@@ -888,6 +946,16 @@ static struct attribute *adt7470_attr[] 
 	&sensor_dev_attr_temp8_input.dev_attr.attr,
 	&sensor_dev_attr_temp9_input.dev_attr.attr,
 	&sensor_dev_attr_temp10_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp3_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp4_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp5_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp6_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp7_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp8_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp9_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp10_alarm.dev_attr.attr,
 	&sensor_dev_attr_fan1_max.dev_attr.attr,
 	&sensor_dev_attr_fan2_max.dev_attr.attr,
 	&sensor_dev_attr_fan3_max.dev_attr.attr,
@@ -900,6 +968,10 @@ static struct attribute *adt7470_attr[] 
 	&sensor_dev_attr_fan2_input.dev_attr.attr,
 	&sensor_dev_attr_fan3_input.dev_attr.attr,
 	&sensor_dev_attr_fan4_input.dev_attr.attr,
+	&sensor_dev_attr_fan1_alarm.dev_attr.attr,
+	&sensor_dev_attr_fan2_alarm.dev_attr.attr,
+	&sensor_dev_attr_fan3_alarm.dev_attr.attr,
+	&sensor_dev_attr_fan4_alarm.dev_attr.attr,
 	&sensor_dev_attr_force_pwm_max.dev_attr.attr,
 	&sensor_dev_attr_pwm1.dev_attr.attr,
 	&sensor_dev_attr_pwm2.dev_attr.attr,
_

Patches currently in -mm which might be from djwong@us.ibm.com are

adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip-fix.patch
adt7470-support-per-sensor-alarm-files.patch
git-scsi-misc.patch
mptbase-reset-ioc-initiator-during-pci-resume.patch
scsi-aic94xx-cleanups.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
