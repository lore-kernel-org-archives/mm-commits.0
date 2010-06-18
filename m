From: akpm@linux-foundation.org
Subject: + hmc6352-add-driver-for-the-hmc6352-compass.patch added to -mm tree
Date: Thu, 17 Jun 2010 22:53:44 -0700
Message-ID: <201006180553.o5I5rdQl016005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730Ab0FRFyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 01:54:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kalhan.trisal@intel.com, alan@linux.intel.com, jic23@cam.ac.uk, khali@linux-fr.org


The patch titled
     hmc6352: add driver for the HMC6352 compass
has been added to the -mm tree.  Its filename is
     hmc6352-add-driver-for-the-hmc6352-compass.patch

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
Subject: hmc6352: add driver for the HMC6352 compass
From: Kalhan Trisal <kalhan.trisal@intel.com>

This driver will report the heading values in degrees to the sysfs
interface.  The values returned are headings .  e.g.  245.6

Alan: Cleanups requested now all folded in and a sysfs description to keep
Andrew happy. The sysfs description now resembles hwmon.

Signed-off-by: Kalhan Trisal <kalhan.trisal@intel.com>
Reviewed-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-bus-i2c-devices-hm6352 |   21 +
 drivers/misc/Kconfig                                   |    7 
 drivers/misc/Makefile                                  |    1 
 drivers/misc/hmc6352.c                                 |  166 ++++++++++
 4 files changed, 195 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-bus-i2c-devices-hm6352
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-bus-i2c-devices-hm6352
@@ -0,0 +1,21 @@
+Where:		/sys/bus/i2c/devices/.../heading0_input
+Date:		April 2010
+Kernel Version: 2.6.36?
+Contact:	alan.cox@intel.com
+Description:	Reports the current heading from the compass as a floating
+		point value in degrees.
+
+Where:		/sys/bus/i2c/devices/.../power_state
+Date:		April 2010
+Kernel Version: 2.6.36?
+Contact:	alan.cox@intel.com
+Description:	Sets the power state of the device. 0 sets the device into
+		sleep mode, 1 wakes it up.
+
+Where:		/sys/bus/i2c/devices/.../calibration
+Date:		April 2010
+Kernel Version: 2.6.36?
+Contact:	alan.cox@intel.com
+Description:	Sets the calibration on or off (1 = on, 0 = off). See the
+		chip data sheet.
+
diff -puN drivers/misc/Kconfig~hmc6352-add-driver-for-the-hmc6352-compass drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~hmc6352-add-driver-for-the-hmc6352-compass
+++ a/drivers/misc/Kconfig
@@ -314,6 +314,13 @@ config SENSORS_BH1780
 	  This driver can also be built as a module.  If so, the module
 	  will be called bh1780gli.
 
+config HMC6352
+	tristate "Honeywell HMC6352 compass"
+	depends on I2C
+	help
+	  This driver provides support for the Honeywell HMC6352 compass,
+	  providing configuration and heading data via sysfs.
+
 config EP93XX_PWM
 	tristate "EP93xx PWM support"
 	depends on ARCH_EP93XX
diff -puN drivers/misc/Makefile~hmc6352-add-driver-for-the-hmc6352-compass drivers/misc/Makefile
--- a/drivers/misc/Makefile~hmc6352-add-driver-for-the-hmc6352-compass
+++ a/drivers/misc/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_DS1682)		+= ds1682.o
 obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
+obj-$(CONFIG_HMC6352)		+= hmc6352.o
 obj-y				+= eeprom/
 obj-y				+= cb710/
 obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
diff -puN /dev/null drivers/misc/hmc6352.c
--- /dev/null
+++ a/drivers/misc/hmc6352.c
@@ -0,0 +1,166 @@
+/*
+ * hmc6352.c - Honeywell Compass Driver
+ *
+ * Copyright (C) 2009 Intel Corp
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
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/sysfs.h>
+
+static DEFINE_MUTEX(compass_mutex);
+
+static int compass_command(struct i2c_client *c, u8 cmd)
+{
+	int ret = i2c_master_send(c, &cmd, 1);
+	if (ret < 0)
+		dev_warn(&c->dev, "command '%c' failed.\n", cmd);
+	return ret;
+}
+
+static int compass_store(struct device *dev, const char *buf, size_t count,
+			const char *map)
+{
+	struct i2c_client *c = to_i2c_client(dev);
+	int ret;
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val))
+		return -EINVAL;
+	if (val >= strlen(map))
+		return -EINVAL;
+	mutex_lock(&compass_mutex);
+	ret = compass_command(c, map[val]);
+	mutex_unlock(&compass_mutex);
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+static ssize_t compass_calibration_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return compass_store(dev, buf, count, "EC");
+}
+
+static ssize_t compass_power_mode_store(struct device *dev,
+		struct device_attribute *attr, const  char *buf, size_t count)
+{
+	return compass_store(dev, buf, count, "SW");
+}
+
+static ssize_t compass_heading_data_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	unsigned char i2c_data[2];
+	unsigned int ret;
+
+	mutex_lock(&compass_mutex);
+	ret = compass_command(client, 'A');
+	if (ret != 1) {
+		mutex_unlock(&compass_mutex);
+		return ret;
+	}
+	msleep(10); /* sending 'A' cmd we need to wait for 7-10 millisecs */
+	ret = i2c_master_recv(client, i2c_data, 2);
+	mutex_unlock(&compass_mutex);
+	if (ret != 1) {
+		dev_warn(dev, "i2c read data cmd failed\n");
+		return ret;
+	}
+	ret = (i2c_data[0] << 8) | i2c_data[1];
+	return sprintf(buf, "%d.%d\n", ret/10, ret%10);
+}
+
+
+static DEVICE_ATTR(heading0_input, S_IRUGO, compass_heading_data_show, NULL);
+static DEVICE_ATTR(calibration, S_IWUSR, NULL, compass_calibration_store);
+static DEVICE_ATTR(power_state, S_IWUSR, NULL, compass_power_mode_store);
+
+static struct attribute *mid_att_compass[] = {
+	&dev_attr_heading0_input.attr,
+	&dev_attr_calibration.attr,
+	&dev_attr_power_state.attr,
+	NULL
+};
+
+static const struct attribute_group m_compass_gr = {
+	.name = "hmc6352",
+	.attrs = mid_att_compass
+};
+
+static int hmc6352_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	int res;
+
+	res = sysfs_create_group(&client->dev.kobj, &m_compass_gr);
+	if (res) {
+		dev_err(&client->dev, "device_create_file failed\n");
+		return res;
+	}
+	dev_info(&client->dev, "%s HMC6352 compass chip found\n",
+							client->name);
+	return 0;
+}
+
+static int hmc6352_remove(struct i2c_client *client)
+{
+	sysfs_remove_group(&client->dev.kobj, &m_compass_gr);
+	return 0;
+}
+
+static struct i2c_device_id hmc6352_id[] = {
+	{ "hmc6352", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, hmc6352_id);
+
+static struct i2c_driver hmc6352_driver = {
+	.driver = {
+		.name = "hmc6352",
+	},
+	.probe = hmc6352_probe,
+	.remove = hmc6352_remove,
+	.id_table = hmc6352_id,
+};
+
+static int __init sensor_hmc6352_init(void)
+{
+	return i2c_add_driver(&hmc6352_driver);
+}
+
+static void  __exit sensor_hmc6352_exit(void)
+{
+	i2c_del_driver(&hmc6352_driver);
+}
+
+module_init(sensor_hmc6352_init);
+module_exit(sensor_hmc6352_exit);
+
+MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com");
+MODULE_DESCRIPTION("hmc6352 Compass Driver");
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from kalhan.trisal@intel.com are

hmc6352-add-driver-for-the-hmc6352-compass.patch

