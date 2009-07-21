From: akpm@linux-foundation.org
Subject: + drivers-hwmon-adm1021c-support-high-precision-adm1023-remote-sensor.patch added to -mm tree
Date: Mon, 20 Jul 2009 23:08:49 -0700
Message-ID: <200907210608.n6L68nj0009252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787AbZGUGJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 02:09:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@araneidae.co.uk, khali@linux-fr.org, michael.abbott@diamond.ac.uk


The patch titled
     drivers/hwmon/adm1021.c: support high precision ADM1023 remote sensor
has been added to the -mm tree.  Its filename is
     drivers-hwmon-adm1021c-support-high-precision-adm1023-remote-sensor.patch

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
Subject: drivers/hwmon/adm1021.c: support high precision ADM1023 remote sensor
From: Michael Abbott <michael@araneidae.co.uk>

The ADM1023 temperature sensor supports higher resolution for its external
sensor (sensitivity of 1/8 deg C).  This patch makes this higher
resolution available through the appropriate temperature sysfs nodes.

Curiously, this functionality was available in the 2.4 kernel driver (but
formatted in a less helpful manner).

Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adm1021.c |   47 ++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff -puN drivers/hwmon/adm1021.c~drivers-hwmon-adm1021c-support-high-precision-adm1023-remote-sensor drivers/hwmon/adm1021.c
--- a/drivers/hwmon/adm1021.c~drivers-hwmon-adm1021c-support-high-precision-adm1023-remote-sensor
+++ a/drivers/hwmon/adm1021.c
@@ -85,14 +85,11 @@ struct adm1021_data {
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
 
-	s8 temp_max[2];		/* Register values */
-	s8 temp_min[2];
-	s8 temp[2];
+	int temp_max[2];		/* Register values */
+	int temp_min[2];
+	int temp[2];
 	u8 alarms;
 	/* Special values for ADM1023 only */
-	u8 remote_temp_prec;
-	u8 remote_temp_os_prec;
-	u8 remote_temp_hyst_prec;
 	u8 remote_temp_offset;
 	u8 remote_temp_offset_prec;
 };
@@ -141,7 +138,7 @@ static ssize_t show_temp(struct device *
 	int index = to_sensor_dev_attr(devattr)->index;
 	struct adm1021_data *data = adm1021_update_device(dev);
 
-	return sprintf(buf, "%d\n", 1000 * data->temp[index]);
+	return sprintf(buf, "%d\n", data->temp[index]);
 }
 
 static ssize_t show_temp_max(struct device *dev,
@@ -150,7 +147,7 @@ static ssize_t show_temp_max(struct devi
 	int index = to_sensor_dev_attr(devattr)->index;
 	struct adm1021_data *data = adm1021_update_device(dev);
 
-	return sprintf(buf, "%d\n", 1000 * data->temp_max[index]);
+	return sprintf(buf, "%d\n", data->temp_max[index]);
 }
 
 static ssize_t show_temp_min(struct device *dev,
@@ -159,7 +156,7 @@ static ssize_t show_temp_min(struct devi
 	int index = to_sensor_dev_attr(devattr)->index;
 	struct adm1021_data *data = adm1021_update_device(dev);
 
-	return sprintf(buf, "%d\n", 1000 * data->temp_min[index]);
+	return sprintf(buf, "%d\n", data->temp_min[index]);
 }
 
 static ssize_t show_alarm(struct device *dev, struct device_attribute *attr,
@@ -412,25 +409,27 @@ static struct adm1021_data *adm1021_upda
 		dev_dbg(&client->dev, "Starting adm1021 update\n");
 
 		for (i = 0; i < 2; i++) {
-			data->temp[i] = i2c_smbus_read_byte_data(client,
-						ADM1021_REG_TEMP(i));
-			data->temp_max[i] = i2c_smbus_read_byte_data(client,
-						ADM1021_REG_TOS_R(i));
-			data->temp_min[i] = i2c_smbus_read_byte_data(client,
-						ADM1021_REG_THYST_R(i));
+			data->temp[i] = 1000 *
+				(s8) i2c_smbus_read_byte_data(
+					client, ADM1021_REG_TEMP(i));
+			data->temp_max[i] = 1000 *
+				(s8) i2c_smbus_read_byte_data(
+					client, ADM1021_REG_TOS_R(i));
+			data->temp_min[i] = 1000 *
+				(s8) i2c_smbus_read_byte_data(
+					client, ADM1021_REG_THYST_R(i));
 		}
 		data->alarms = i2c_smbus_read_byte_data(client,
 						ADM1021_REG_STATUS) & 0x7c;
 		if (data->type == adm1023) {
-			data->remote_temp_prec =
-				i2c_smbus_read_byte_data(client,
-						ADM1023_REG_REM_TEMP_PREC);
-			data->remote_temp_os_prec =
-				i2c_smbus_read_byte_data(client,
-						ADM1023_REG_REM_TOS_PREC);
-			data->remote_temp_hyst_prec =
-				i2c_smbus_read_byte_data(client,
-						ADM1023_REG_REM_THYST_PREC);
+			/* The ADM1023 provides 3 extra bits of precision for
+			 * the remote sensor in extra registers. */
+			data->temp[1] += 125 * (i2c_smbus_read_byte_data(
+				client, ADM1023_REG_REM_TEMP_PREC) >> 5);
+			data->temp_max[1] += 125 * (i2c_smbus_read_byte_data(
+				client, ADM1023_REG_REM_TOS_PREC) >> 5);
+			data->temp_min[1] += 125 * (i2c_smbus_read_byte_data(
+				client, ADM1023_REG_REM_THYST_PREC) >> 5);
 			data->remote_temp_offset =
 				i2c_smbus_read_byte_data(client,
 						ADM1023_REG_REM_OFFSET);
_

Patches currently in -mm which might be from michael@araneidae.co.uk are

drivers-hwmon-adm1021c-support-high-precision-adm1023-remote-sensor.patch

