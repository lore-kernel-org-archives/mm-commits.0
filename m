From: akpm@linux-foundation.org
Subject: + isl29020-ambient-light-sensor.patch added to -mm tree
Date: Fri, 22 Oct 2010 12:53:15 -0700
Message-ID: <201010221953.o9MJrFJf004162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759041Ab0JVTxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 15:53:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kalhan.trisal@intel.com, alan@linux.intel.com, arjan@linux.intel.com, hong.liu@intel.com


The patch titled
     drivers/misc/isl29020.c: ambient light sensor
has been added to the -mm tree.  Its filename is
     isl29020-ambient-light-sensor.patch

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
Subject: drivers/misc/isl29020.c: ambient light sensor
From: Kalhan Trisal <kalhan.trisal@intel.com>

The LS driver will read the latest Lux measurement based upon the light
brightness and will report the LUX output through sysfs interface.

This hardware isn't quite the same as the ISL29003 so has a different
driver.

Signed-off-by: Kalhan Trisal <kalhan.trisal@intel.com>
[Runtime power management support added]
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
[Fixes to runtime PM]
Signed-off-by: Liu Hong <hong.liu@intel.com>
[Cleanups and added checks for I2C errors, reworked the API to match the
 saner one agreed for other sensors]
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig    |   10 +
 drivers/misc/Makefile   |    1 
 drivers/misc/isl29020.c |  241 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 252 insertions(+)

diff -puN drivers/misc/Kconfig~isl29020-ambient-light-sensor drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~isl29020-ambient-light-sensor
+++ a/drivers/misc/Kconfig
@@ -304,6 +304,16 @@ config ISL29003
 	  This driver can also be built as a module.  If so, the module
 	  will be called isl29003.
 
+config ISL29020
+	tristate "Intersil ISL29020 ambient light sensor"
+	depends on I2C
+	help
+	  If you say yes here you get support for the Intersil ISL29020
+	  ambient light sensor.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called isl29020.
+
 config SENSORS_TSL2550
 	tristate "Taos TSL2550 ambient light sensor"
 	depends on I2C && SYSFS
diff -puN drivers/misc/Makefile~isl29020-ambient-light-sensor drivers/misc/Makefile
--- a/drivers/misc/Makefile~isl29020-ambient-light-sensor
+++ a/drivers/misc/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_CS5535_MFGPT)	+= cs5535-mfgpt.o
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
 obj-$(CONFIG_ISL29003)		+= isl29003.o
+obj-$(CONFIG_ISL29020)		+= isl29020.o
 obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
 obj-$(CONFIG_EP93XX_PWM)	+= ep93xx_pwm.o
 obj-$(CONFIG_DS1682)		+= ds1682.o
diff -puN /dev/null drivers/misc/isl29020.c
--- /dev/null
+++ a/drivers/misc/isl29020.c
@@ -0,0 +1,241 @@
+/*
+ * isl29020.c - Intersil  ALS Driver
+ *
+ * Copyright (C) 2008 Intel Corp
+ *
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * Data sheet at: http://www.intersil.com/data/fn/fn6505.pdf
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/sysfs.h>
+#include <linux/pm_runtime.h>
+
+static DEFINE_MUTEX(mutex);
+
+static ssize_t als_sensing_range_show(struct device *dev,
+			struct device_attribute *attr,  char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int  val;
+
+	val = i2c_smbus_read_byte_data(client, 0x00);
+
+	if (val < 0)
+		return val;
+	return sprintf(buf, "%d000\n", 1 << (2 * (val & 3)));
+
+}
+
+static ssize_t als_lux_input_data_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret_val, val;
+	unsigned long int lux;
+	int temp;
+
+	pm_runtime_get_sync(dev);
+	msleep(100);
+
+	mutex_lock(&mutex);
+	temp = i2c_smbus_read_byte_data(client, 0x02); /* MSB data */
+	if (temp < 0) {
+		pm_runtime_put_sync(dev);
+		mutex_unlock(&mutex);
+		return temp;
+	}
+
+	ret_val = i2c_smbus_read_byte_data(client, 0x01); /* LSB data */
+	mutex_unlock(&mutex);
+
+	if (ret_val < 0) {
+		pm_runtime_put_sync(dev);
+		return ret_val;
+	}
+
+	ret_val |= temp << 8;
+	val = i2c_smbus_read_byte_data(client, 0x00);
+	pm_runtime_put_sync(dev);
+	if (val < 0)
+		return val;
+	lux = ((((1 << (2 * (val & 3))))*1000) * ret_val) / 65536;
+	return sprintf(buf, "%ld\n", lux);
+}
+
+static ssize_t als_sensing_range_store(struct device *dev,
+		struct device_attribute *attr, const  char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	unsigned int ret_val;
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val))
+		return -EINVAL;
+	if (val < 1 || val > 64000)
+		return -EINVAL;
+
+	/* Pick the smallest sensor range that will meet our requirements */
+	if (val <= 1000)
+		val = 1;
+	else if (val <= 4000)
+		val = 2;
+	else if (val <= 16000)
+		val = 3;
+	else
+		val = 4;
+
+	ret_val = i2c_smbus_read_byte_data(client, 0x00);
+
+	ret_val &= 0xFC; /*reset the bit before setting them */
+	ret_val |= val - 1;
+	ret_val = i2c_smbus_write_byte_data(client, 0x00, ret_val);
+
+	if (ret_val < 0)
+		return ret_val;
+	return count;
+}
+
+static void als_set_power_state(struct i2c_client *client, int enable)
+{
+	int ret_val;
+
+	ret_val = i2c_smbus_read_byte_data(client, 0x00);
+	if (ret_val < 0)
+		return;
+
+	if (enable)
+		ret_val |= 0x80;
+	else
+		ret_val &= 0x7F;
+
+	i2c_smbus_write_byte_data(client, 0x00, ret_val);
+}
+
+static DEVICE_ATTR(lux0_sensor_range, S_IRUGO | S_IWUSR,
+	als_sensing_range_show, als_sensing_range_store);
+static DEVICE_ATTR(lux0_input, S_IRUGO, als_lux_input_data_show, NULL);
+
+static struct attribute *mid_att_als[] = {
+	&dev_attr_lux0_sensor_range.attr,
+	&dev_attr_lux0_input.attr,
+	NULL
+};
+
+static struct attribute_group m_als_gr = {
+	.name = "isl29020",
+	.attrs = mid_att_als
+};
+
+static int als_set_default_config(struct i2c_client *client)
+{
+	int retval;
+
+	retval = i2c_smbus_write_byte_data(client, 0x00, 0xc0);
+	if (retval < 0) {
+		dev_err(&client->dev, "default write failed.");
+		return retval;
+	}
+	return 0;;
+}
+
+static int  isl29020_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	int res;
+
+	res = als_set_default_config(client);
+	if (res <  0)
+		return res;
+
+	res = sysfs_create_group(&client->dev.kobj, &m_als_gr);
+	if (res) {
+		dev_err(&client->dev, "isl29020: device create file failed\n");
+		return res;
+	}
+	dev_info(&client->dev, "%s isl29020: ALS chip found\n", client->name);
+	als_set_power_state(client, 0);
+	pm_runtime_enable(&client->dev);
+	return res;
+}
+
+static int isl29020_remove(struct i2c_client *client)
+{
+	struct als_data *data = i2c_get_clientdata(client);
+	sysfs_remove_group(&client->dev.kobj, &m_als_gr);
+	kfree(data);
+	return 0;
+}
+
+static struct i2c_device_id isl29020_id[] = {
+	{ "isl29020", 0 },
+	{ }
+};
+
+static int isl29020_runtime_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	als_set_power_state(client, 0);
+	return 0;
+}
+
+static int isl29020_runtime_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	als_set_power_state(client, 1);
+	return 0;
+}
+
+MODULE_DEVICE_TABLE(i2c, isl29020_id);
+
+static const struct dev_pm_ops isl29020_pm_ops = {
+	.runtime_suspend = isl29020_runtime_suspend,
+	.runtime_resume = isl29020_runtime_resume,
+};
+
+static struct i2c_driver isl29020_driver = {
+	.driver = {
+		.name = "isl29020",
+		.pm = &isl29020_pm_ops,
+	},
+	.probe = isl29020_probe,
+	.remove = isl29020_remove,
+	.id_table = isl29020_id,
+};
+
+static int __init sensor_isl29020_init(void)
+{
+	return i2c_add_driver(&isl29020_driver);
+}
+
+static void  __exit sensor_isl29020_exit(void)
+{
+	i2c_del_driver(&isl29020_driver);
+}
+
+module_init(sensor_isl29020_init);
+module_exit(sensor_isl29020_exit);
+
+MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com");
+MODULE_DESCRIPTION("Intersil isl29020 ALS Driver");
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from kalhan.trisal@intel.com are

isl29020-ambient-light-sensor.patch
isl29020-ambient-light-sensor-fix.patch

