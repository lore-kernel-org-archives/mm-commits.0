From: akpm@linux-foundation.org
Subject: + adt7470-observe-the-number-of-temperature-sensors-to-shorten-update-time.patch added to -mm tree
Date: Tue, 25 Nov 2008 17:07:15 -0800
Message-ID: <200811260107.mAQ17FQn032153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYKZBH4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 20:07:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, khali@linux-fr.org


The patch titled
     adt7470: observe the number of temperature sensors to shorten update time
has been added to the -mm tree.  Its filename is
     adt7470-observe-the-number-of-temperature-sensors-to-shorten-update-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adt7470: observe the number of temperature sensors to shorten update time
From: "Darrick J. Wong" <djwong@us.ibm.com>

The adt7470 driver currently assumes that 1s is the proper time to wait to
read all temperature sensors.  However, the correct time is 200ms *
number_of_sensors.  This patch sets the default time to provide for 10
sensors and then lowers it based on the number of sensor inputs that have
nozero values.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adt7470.c |   56 ++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff -puN drivers/hwmon/adt7470.c~adt7470-observe-the-number-of-temperature-sensors-to-shorten-update-time drivers/hwmon/adt7470.c
--- a/drivers/hwmon/adt7470.c~adt7470-observe-the-number-of-temperature-sensors-to-shorten-update-time
+++ a/drivers/hwmon/adt7470.c
@@ -129,8 +129,8 @@ I2C_CLIENT_INSMOD_1(adt7470);
 /* How often do we reread sensor limit values? (In jiffies) */
 #define LIMIT_REFRESH_INTERVAL	(60 * HZ)
 
-/* sleep 1s while gathering temperature data */
-#define TEMP_COLLECTION_TIME	1000
+/* Wait at least 200ms per sensor for 10 sensors */
+#define TEMP_COLLECTION_TIME	2000
 
 /* datasheet says to divide this number by the fan reading to get fan rpm */
 #define FAN_PERIOD_TO_RPM(x)	((90000 * 60) / (x))
@@ -147,6 +147,8 @@ struct adt7470_data {
 	unsigned long		sensors_last_updated;	/* In jiffies */
 	unsigned long		limits_last_updated;	/* In jiffies */
 
+	int			num_temp_sensors;	/* -1 = probe */
+
 	s8			temp[ADT7470_TEMP_COUNT];
 	s8			temp_min[ADT7470_TEMP_COUNT];
 	s8			temp_max[ADT7470_TEMP_COUNT];
@@ -256,12 +258,10 @@ static struct adt7470_data *adt7470_upda
 	cfg |= 0x80;
 	i2c_smbus_write_byte_data(client, ADT7470_REG_CFG, cfg);
 
-	/*
-	 * Delay is 200ms * number of tmp05 sensors.  Too bad
-	 * there's no way to figure out how many are connected.
-	 * For now, assume 1s will work.
-	 */
-	msleep(TEMP_COLLECTION_TIME);
+	/* Delay is 200ms * number of temp sensors. */
+	msleep((data->num_temp_sensors >= 0 ?
+		data->num_temp_sensors * 200 :
+		TEMP_COLLECTION_TIME));
 
 	/* done reading temperature sensors */
 	cfg = i2c_smbus_read_byte_data(client, ADT7470_REG_CFG);
@@ -276,6 +276,12 @@ static struct adt7470_data *adt7470_upda
 		data->temp[i] = i2c_smbus_read_byte_data(client,
 						ADT7470_TEMP_REG(i));
 
+	/* Figure out the number of temp sensors */
+	if (data->num_temp_sensors < 0)
+		for (i = 0; i < ADT7470_TEMP_COUNT; i++)
+			if (data->temp[i])
+				data->num_temp_sensors = i + 1;
+
 	for (i = 0; i < ADT7470_FAN_COUNT; i++)
 		data->fan[i] = adt7470_read_word_data(client,
 						ADT7470_REG_FAN(i));
@@ -359,6 +365,35 @@ out:
 	return data;
 }
 
+static ssize_t show_num_temp_sensors(struct device *dev,
+				     struct device_attribute *devattr,
+				     char *buf)
+{
+	struct adt7470_data *data = adt7470_update_device(dev);
+	return sprintf(buf, "%d\n", data->num_temp_sensors);
+}
+
+static ssize_t set_num_temp_sensors(struct device *dev,
+				    struct device_attribute *devattr,
+				    const char *buf,
+				    size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct adt7470_data *data = i2c_get_clientdata(client);
+	long temp;
+
+	if (strict_strtol(buf, 10, &temp))
+		return -EINVAL;
+
+	temp = SENSORS_LIMIT(temp, -1, 10);
+
+	mutex_lock(&data->lock);
+	data->num_temp_sensors = temp;
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
 static ssize_t show_temp_min(struct device *dev,
 			     struct device_attribute *devattr,
 			     char *buf)
@@ -825,6 +860,8 @@ static ssize_t show_alarm(struct device 
 }
 
 static DEVICE_ATTR(alarm_mask, S_IRUGO, show_alarm_mask, NULL);
+static DEVICE_ATTR(num_temp_sensors, S_IWUSR | S_IRUGO, show_num_temp_sensors,
+		   set_num_temp_sensors);
 
 static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp_max,
 		    set_temp_max, 0);
@@ -997,6 +1034,7 @@ static SENSOR_DEVICE_ATTR(pwm4_auto_chan
 static struct attribute *adt7470_attr[] =
 {
 	&dev_attr_alarm_mask.attr,
+	&dev_attr_num_temp_sensors.attr,
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
 	&sensor_dev_attr_temp2_max.dev_attr.attr,
 	&sensor_dev_attr_temp3_max.dev_attr.attr,
@@ -1129,6 +1167,8 @@ static int adt7470_probe(struct i2c_clie
 		goto exit;
 	}
 
+	data->num_temp_sensors = -1;
+
 	i2c_set_clientdata(client, data);
 	mutex_init(&data->lock);
 
_

Patches currently in -mm which might be from djwong@us.ibm.com are

linux-next.patch
create-a-div_round_closest-macro-to-do-division-with-rounding.patch
adt7462-70-73-use-div_round_closest-for-rounded-division.patch
adt7470-fix-pwm-at-a-certain-level-during-temperature-sensor-scan.patch
adt7470-observe-the-number-of-temperature-sensors-to-shorten-update-time.patch
adt7470-make-automatic-fan-control-really-work.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch

