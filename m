From: akpm@linux-foundation.org
Subject: + drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver-update.patch added to -mm tree
Date: Tue, 18 Aug 2009 15:57:40 -0700
Message-ID: <200908182257.n7IMveUM010008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbZHRW6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 18:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@araneidae.co.uk, khali@linux-fr.org, michael.abbott@diamond.ac.uk


The patch titled
     drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver-update
has been added to the -mm tree.  Its filename is
     drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver-update.patch

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
Subject: drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver-update
From: Michael Abbott <michael@araneidae.co.uk>

Layout patch to fix earlier adm1021.c patch

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adm1021.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/hwmon/adm1021.c~drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver-update drivers/hwmon/adm1021.c
--- a/drivers/hwmon/adm1021.c~drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver-update
+++ a/drivers/hwmon/adm1021.c
@@ -214,22 +214,22 @@ static ssize_t set_temp_min(struct devic
 	return count;
 }
 
-static ssize_t show_low_power(
-	struct device *dev, struct device_attribute *devattr, char *buf)
+static ssize_t show_low_power(struct device *dev,
+			      struct device_attribute *devattr, char *buf)
 {
 	struct adm1021_data *data = adm1021_update_device(dev);
 	return sprintf(buf, "%d\n", data->low_power);
 }
 
-static ssize_t set_low_power(
-	struct device *dev, struct device_attribute *devattr,
-	const char *buf, size_t count)
+static ssize_t set_low_power(struct device *dev,
+			     struct device_attribute *devattr,
+			     const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adm1021_data *data = i2c_get_clientdata(client);
 	int low_power = simple_strtol(buf, NULL, 10) != 0;
-	mutex_lock(&data->update_lock);
 
+	mutex_lock(&data->update_lock);
 	if (low_power != data->low_power) {
 		int config = i2c_smbus_read_byte_data(
 			client, ADM1021_REG_CONFIG_R);
@@ -260,8 +260,7 @@ static SENSOR_DEVICE_ATTR(temp2_min_alar
 static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, show_alarm, NULL, 2);
 
 static DEVICE_ATTR(alarms, S_IRUGO, show_alarms, NULL);
-static DEVICE_ATTR(
-	low_power, S_IWUSR | S_IRUGO, show_low_power, set_low_power);
+static DEVICE_ATTR(low_power, S_IWUSR | S_IRUGO, show_low_power, set_low_power);
 
 static struct attribute *adm1021_attributes[] = {
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
_

Patches currently in -mm which might be from michael@araneidae.co.uk are

drivers-hwmon-adm1021c-support-high-precision-adm1023-remote-sensor.patch
drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver.patch
drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver-update.patch

