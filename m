From: akpm@linux-foundation.org
Subject: + drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver.patch added to -mm tree
Date: Mon, 20 Jul 2009 23:09:43 -0700
Message-ID: <200907210609.n6L69hfT010643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753944AbZGUGK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 02:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@araneidae.co.uk, khali@linux-fr.org, michael.abbott@diamond.ac.uk


The patch titled
     drivers/hwmon/adm1021.c: add low_power support for adm1021 driver
has been added to the -mm tree.  Its filename is
     drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver.patch

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
Subject: drivers/hwmon/adm1021.c: add low_power support for adm1021 driver
From: Michael Abbott <michael@araneidae.co.uk>

Occasionally it is helpful to be able to turn a temperature sensor off
(for example if it's making unwanted electrical noise).  This patch
adds a sysfs node to put any adm1021 compatible device into low power mode.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/adm1021.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN drivers/hwmon/adm1021.c~drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver drivers/hwmon/adm1021.c
--- a/drivers/hwmon/adm1021.c~drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver
+++ a/drivers/hwmon/adm1021.c
@@ -83,6 +83,7 @@ struct adm1021_data {
 
 	struct mutex update_lock;
 	char valid;		/* !=0 if following fields are valid */
+	char low_power;		/* !=0 if device in low power mode */
 	unsigned long last_updated;	/* In jiffies */
 
 	int temp_max[2];		/* Register values */
@@ -213,6 +214,35 @@ static ssize_t set_temp_min(struct devic
 	return count;
 }
 
+static ssize_t show_low_power(
+	struct device *dev, struct device_attribute *devattr, char *buf)
+{
+	struct adm1021_data *data = adm1021_update_device(dev);
+	return sprintf(buf, "%d\n", data->low_power);
+}
+
+static ssize_t set_low_power(
+	struct device *dev, struct device_attribute *devattr,
+	const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct adm1021_data *data = i2c_get_clientdata(client);
+	int low_power = simple_strtol(buf, NULL, 10) != 0;
+	mutex_lock(&data->update_lock);
+
+	if (low_power != data->low_power) {
+		int config = i2c_smbus_read_byte_data(
+			client, ADM1021_REG_CONFIG_R);
+		data->low_power = low_power;
+		i2c_smbus_write_byte_data(client, ADM1021_REG_CONFIG_W,
+			(config & 0xBF) | (low_power << 6));
+	}
+	mutex_unlock(&data->update_lock);
+
+	return count;
+}
+
+
 static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL, 0);
 static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_temp_max,
 			  set_temp_max, 0);
@@ -230,6 +260,8 @@ static SENSOR_DEVICE_ATTR(temp2_min_alar
 static SENSOR_DEVICE_ATTR(temp2_fault, S_IRUGO, show_alarm, NULL, 2);
 
 static DEVICE_ATTR(alarms, S_IRUGO, show_alarms, NULL);
+static DEVICE_ATTR(
+	low_power, S_IWUSR | S_IRUGO, show_low_power, set_low_power);
 
 static struct attribute *adm1021_attributes[] = {
 	&sensor_dev_attr_temp1_max.dev_attr.attr,
@@ -244,6 +276,7 @@ static struct attribute *adm1021_attribu
 	&sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
 	&sensor_dev_attr_temp2_fault.dev_attr.attr,
 	&dev_attr_alarms.attr,
+	&dev_attr_low_power.attr,
 	NULL
 };
 
_

Patches currently in -mm which might be from michael@araneidae.co.uk are

drivers-hwmon-adm1021c-support-high-precision-adm1023-remote-sensor.patch
drivers-hwmon-adm1021c-add-low_power-support-for-adm1021-driver.patch

