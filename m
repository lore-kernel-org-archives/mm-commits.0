From: akpm@linux-foundation.org
Subject: + drivers-misc-apds9802alsc-add-runtime-pm-support.patch added to -mm tree
Date: Fri, 22 Oct 2010 13:03:40 -0700
Message-ID: <201010222003.o9MK3ePc004711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757167Ab0JVUEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 16:04:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hong.liu@intel.com, alan@linux.intel.com


The patch titled
     drivers/misc/apds9802als.c: add runtime PM support
has been added to the -mm tree.  Its filename is
     drivers-misc-apds9802alsc-add-runtime-pm-support.patch

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
Subject: drivers/misc/apds9802als.c: add runtime PM support
From: Hong Liu <hong.liu@intel.com>

Update the driver for the needed runtime power features.  Remove the old
user controlled power functions.

Signed-off-by: Hong Liu <hong.liu@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/apds9802als.c |  158 ++++++++++++++++++++---------------
 1 file changed, 94 insertions(+), 64 deletions(-)

diff -puN drivers/misc/apds9802als.c~drivers-misc-apds9802alsc-add-runtime-pm-support drivers/misc/apds9802als.c
--- a/drivers/misc/apds9802als.c~drivers-misc-apds9802alsc-add-runtime-pm-support
+++ a/drivers/misc/apds9802als.c
@@ -29,19 +29,16 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
-#include <linux/hwmon-sysfs.h>
+#include <linux/pm_runtime.h>
 
 #define ALS_MIN_RANGE_VAL 1
 #define ALS_MAX_RANGE_VAL 2
 #define POWER_STA_ENABLE 1
 #define POWER_STA_DISABLE 0
-#define APDS9802ALS_I2C_ADDR 0x29
 
 #define DRIVER_NAME "apds9802als"
 
 struct als_data {
-	struct device *hwmon_dev;
-	bool needresume;
 	struct mutex mutex;
 };
 
@@ -60,29 +57,64 @@ static ssize_t als_sensing_range_show(st
 		return sprintf(buf, "65535\n");
 }
 
+static int als_wait_for_data_ready(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret;
+	int retry = 10;
+
+	do {
+		msleep(30);
+		ret = i2c_smbus_read_byte_data(client, 0x86);
+	} while (!(ret & 0x80) && retry--);
+
+	if (!retry) {
+		dev_warn(dev, "timeout waiting for data ready\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
 static ssize_t als_lux0_input_data_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct als_data *data = i2c_get_clientdata(client);
-	unsigned int ret_val;
+	int ret_val;
 	int temp;
 
 	/* Protect against parallel reads */
+	pm_runtime_get_sync(dev);
 	mutex_lock(&data->mutex);
-	temp = i2c_smbus_read_byte_data(client, 0x8C);/*LSB data*/
+
+	/* clear EOC interrupt status */
+	i2c_smbus_write_byte(client, 0x40);
+	/* start measurement */
+	temp = i2c_smbus_read_byte_data(client, 0x81);
+	i2c_smbus_write_byte_data(client, 0x81, temp | 0x08);
+
+	ret_val = als_wait_for_data_ready(dev);
+	if (ret_val < 0)
+		goto failed;
+
+	temp = i2c_smbus_read_byte_data(client, 0x8C); /* LSB data */
 	if (temp < 0) {
 		ret_val = temp;
 		goto failed;
 	}
-	ret_val = i2c_smbus_read_byte_data(client, 0x8D);/*MSB data*/
+	ret_val = i2c_smbus_read_byte_data(client, 0x8D); /* MSB data */
 	if (ret_val < 0)
 		goto failed;
+
 	mutex_unlock(&data->mutex);
-	ret_val = (ret_val << 8) | temp;
-	return sprintf(buf, "%d\n", ret_val);
+	pm_runtime_put_sync(dev);
+
+	temp = (ret_val << 8) | temp;
+	return sprintf(buf, "%d\n", temp);
 failed:
 	mutex_unlock(&data->mutex);
+	pm_runtime_put_sync(dev);
 	return ret_val;
 }
 
@@ -104,9 +136,10 @@ static ssize_t als_sensing_range_store(s
 	else
 		return -ERANGE;
 
+	pm_runtime_get_sync(dev);
+
 	/* Make sure nobody else reads/modifies/writes 0x81 while we
 	   are active */
-
 	mutex_lock(&data->mutex);
 
 	ret_val = i2c_smbus_read_byte_data(client, 0x81);
@@ -116,34 +149,25 @@ static ssize_t als_sensing_range_store(s
 	/* Reset the bits before setting them */
 	ret_val = ret_val & 0xFA;
 
-	if (val == 1) /* Setting the continous measurement up to 4k LUX */
-		ret_val = (ret_val | 0x05);
-	else /* Setting the continous measurement up to 64k LUX*/
-		ret_val = (ret_val | 0x04);
+	if (val == 1) /* Setting detection range up to 4k LUX */
+		ret_val = (ret_val | 0x01);
+	else /* Setting detection range up to 64k LUX*/
+		ret_val = (ret_val | 0x00);
 
 	ret_val = i2c_smbus_write_byte_data(client, 0x81, ret_val);
+
 	if (ret_val >= 0) {
 		/* All OK */
 		mutex_unlock(&data->mutex);
+		pm_runtime_put_sync(dev);
 		return count;
 	}
 fail:
 	mutex_unlock(&data->mutex);
+	pm_runtime_put_sync(dev);
 	return ret_val;
 }
 
-static ssize_t als_power_status_show(struct device *dev,
-			struct device_attribute *attr, char *buf)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	int ret_val;
-	ret_val = i2c_smbus_read_byte_data(client, 0x80);
-	if (ret_val < 0)
-		return ret_val;
-	ret_val = ret_val & 0x01;
-	return sprintf(buf, "%d\n", ret_val);
-}
-
 static int als_set_power_state(struct i2c_client *client, bool on_off)
 {
 	int ret_val;
@@ -163,39 +187,13 @@ fail:
 	return ret_val;
 }
 
-static ssize_t als_power_status_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct als_data *data = i2c_get_clientdata(client);
-	unsigned long val;
-	int ret_val;
-
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
-	if (val == POWER_STA_ENABLE) {
-		ret_val = als_set_power_state(client, true);
-		data->needresume = true;
-	} else if (val == POWER_STA_DISABLE) {
-		ret_val = als_set_power_state(client, false);
-		data->needresume = false;
-	} else
-		return -EINVAL;
-	if (ret_val < 0)
-		return ret_val;
-	return count;
-}
-
 static DEVICE_ATTR(lux0_sensor_range, S_IRUGO | S_IWUSR,
 	als_sensing_range_show, als_sensing_range_store);
 static DEVICE_ATTR(lux0_input, S_IRUGO, als_lux0_input_data_show, NULL);
-static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR,
-	als_power_status_show, als_power_status_store);
 
 static struct attribute *mid_att_als[] = {
 	&dev_attr_lux0_sensor_range.attr,
 	&dev_attr_lux0_input.attr,
-	&dev_attr_power_state.attr,
 	NULL
 };
 
@@ -213,15 +211,21 @@ static int als_set_default_config(struct
 		dev_err(&client->dev, "failed default switch on write\n");
 		return ret_val;
 	}
-	/* Continous from 1Lux to 64k Lux */
-	ret_val = i2c_smbus_write_byte_data(client, 0x81, 0x04);
+	/* detection range: 1~64K Lux, maunal measurement */
+	ret_val = i2c_smbus_write_byte_data(client, 0x81, 0x08);
 	if (ret_val < 0)
 		dev_err(&client->dev, "failed default LUX on write\n");
+
+	/*  We always get 0 for the 1st measurement after system power on,
+	 *  so make sure it is finished before user asks for data.
+	 */
+	als_wait_for_data_ready(&client->dev);
+
 	return ret_val;
 }
 
-static int  apds9802als_probe(struct i2c_client *client,
-					const struct i2c_device_id *id)
+static int apds9802als_probe(struct i2c_client *client,
+			     const struct i2c_device_id *id)
 {
 	int res;
 	struct als_data *data;
@@ -237,11 +241,14 @@ static int  apds9802als_probe(struct i2c
 		dev_err(&client->dev, "device create file failed\n");
 		goto als_error1;
 	}
-	dev_info(&client->dev,
-		"%s apds9802als: ALS chip found\n", client->name);
+	dev_info(&client->dev, "ALS chip found\n");
 	als_set_default_config(client);
-	data->needresume = true;
 	mutex_init(&data->mutex);
+
+	pm_runtime_enable(&client->dev);
+	pm_runtime_get(&client->dev);
+	pm_runtime_put(&client->dev);
+
 	return res;
 als_error1:
 	i2c_set_clientdata(client, NULL);
@@ -252,6 +259,8 @@ als_error1:
 static int apds9802als_remove(struct i2c_client *client)
 {
 	struct als_data *data = i2c_get_clientdata(client);
+
+	als_set_power_state(client, false);
 	sysfs_remove_group(&client->dev.kobj, &m_als_gr);
 	kfree(data);
 	return 0;
@@ -265,13 +274,34 @@ static int apds9802als_suspend(struct i2
 
 static int apds9802als_resume(struct i2c_client *client)
 {
-	struct als_data *data = i2c_get_clientdata(client);
+	als_set_default_config(client);
+
+	pm_runtime_get(&client->dev);
+	pm_runtime_put(&client->dev);
+	return 0;
+}
+
+static int apds9802als_runtime_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	als_set_power_state(client, false);
+	return 0;
+}
+
+static int apds9802als_runtime_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
 
-	if (data->needresume == true)
-		als_set_power_state(client, true);
+	als_set_power_state(client, true);
 	return 0;
 }
 
+static const struct dev_pm_ops apds9802als_pm_ops = {
+	.runtime_suspend = apds9802als_runtime_suspend,
+	.runtime_resume = apds9802als_runtime_resume,
+};
+
 static struct i2c_device_id apds9802als_id[] = {
 	{ DRIVER_NAME, 0 },
 	{ }
@@ -281,8 +311,8 @@ MODULE_DEVICE_TABLE(i2c, apds9802als_id)
 
 static struct i2c_driver apds9802als_driver = {
 	.driver = {
-	.name = DRIVER_NAME,
-	.owner = THIS_MODULE,
+		.name = DRIVER_NAME,
+		.pm = &apds9802als_pm_ops,
 	},
 	.probe = apds9802als_probe,
 	.remove = apds9802als_remove,
_

Patches currently in -mm which might be from hong.liu@intel.com are

isl29020-ambient-light-sensor.patch
isl29020-ambient-light-sensor-fix.patch
drivers-misc-apds9802alsc-als-drivers-for-the-apds9802als.patch
drivers-misc-apds9802alsc-add-runtime-pm-support.patch
drivers-misc-apds9802alsc-add-runtime-pm-support-fix.patch

