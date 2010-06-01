From: akpm@linux-foundation.org
Subject: + misc-rohm-bh1780gli-ambient-light-sensor-driver.patch added to -mm tree
Date: Tue, 01 Jun 2010 13:12:50 -0700
Message-ID: <201006012012.o51KCpil015892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756472Ab0FAUN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 16:13:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hemanthv@ti.com, daniel@caiaq.de, jic23@cam.ac.uk, khali@linux-fr.org, w.sang@pengutronix.de


The patch titled
     drivers/misc: ROHM BH1780GLI ambient light sensor driver
has been added to the -mm tree.  Its filename is
     misc-rohm-bh1780gli-ambient-light-sensor-driver.patch

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
Subject: drivers/misc: ROHM BH1780GLI ambient light sensor driver
From: Hemanth V <hemanthv@ti.com>

Add support for ROHM BH1780GLI Ambient light sensor.

BH1780 supports I2C interface.  Driver supports read/update of power state
and read of lux value (through SYSFS).  Writing value 3 to power_state
enables the sensor and current lux value could be read.

Signed-off-by: Hemanth V <hemanthv@ti.com>
Reviewed-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig     |   10 +
 drivers/misc/Makefile    |    1 
 drivers/misc/bh1780gli.c |  273 +++++++++++++++++++++++++++++++++++++
 3 files changed, 284 insertions(+)

diff -puN drivers/misc/Kconfig~misc-rohm-bh1780gli-ambient-light-sensor-driver drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~misc-rohm-bh1780gli-ambient-light-sensor-driver
+++ a/drivers/misc/Kconfig
@@ -304,6 +304,16 @@ config SENSORS_TSL2550
 	  This driver can also be built as a module.  If so, the module
 	  will be called tsl2550.
 
+config SENSORS_BH1780
+	tristate "ROHM BH1780GLI ambient light sensor"
+	depends on I2C && SYSFS
+	help
+	  If you say yes here you get support for the ROHM BH1780GLI
+	  ambient light sensor.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called bh1780gli.
+
 config EP93XX_PWM
 	tristate "EP93xx PWM support"
 	depends on ARCH_EP93XX
diff -puN drivers/misc/Makefile~misc-rohm-bh1780gli-ambient-light-sensor-driver drivers/misc/Makefile
--- a/drivers/misc/Makefile~misc-rohm-bh1780gli-ambient-light-sensor-driver
+++ a/drivers/misc/Makefile
@@ -31,3 +31,4 @@ obj-$(CONFIG_IWMC3200TOP)      += iwmc32
 obj-y				+= eeprom/
 obj-y				+= cb710/
 obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
+obj-$(CONFIG_SENSORS_BH1780)	+= bh1780gli.o
diff -puN /dev/null drivers/misc/bh1780gli.c
--- /dev/null
+++ a/drivers/misc/bh1780gli.c
@@ -0,0 +1,273 @@
+/*
+ * bh1780gli.c
+ * ROHM Ambient Light Sensor Driver
+ *
+ * Copyright (C) 2010 Texas Instruments
+ * Author: Hemanth V <hemanthv@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+
+#define BH1780_REG_CONTROL	0x80
+#define BH1780_REG_PARTID	0x8A
+#define BH1780_REG_MANFID	0x8B
+#define BH1780_REG_DLOW	0x8C
+#define BH1780_REG_DHIGH	0x8D
+
+#define BH1780_REVMASK		(0xf)
+#define BH1780_POWMASK		(0x3)
+#define BH1780_POFF		(0x0)
+#define BH1780_PON		(0x3)
+
+/* power on settling time in ms */
+#define BH1780_PON_DELAY	2
+
+struct bh1780_data {
+	struct i2c_client *client;
+	int power_state;
+	/* lock for sysfs operations */
+	struct mutex lock;
+};
+
+static int bh1780_write(struct bh1780_data *ddata, u8 reg, u8 val, char *msg)
+{
+	int ret = i2c_smbus_write_byte_data(ddata->client, reg, val);
+	if (ret < 0)
+		dev_err(&ddata->client->dev,
+			"i2c_smbus_write_byte_data failed error %d\
+			Register (%s)\n", ret, msg);
+	return ret;
+}
+
+static int bh1780_read(struct bh1780_data *ddata, u8 reg, char *msg)
+{
+	int ret = i2c_smbus_read_byte_data(ddata->client, reg);
+	if (ret < 0)
+		dev_err(&ddata->client->dev,
+			"i2c_smbus_read_byte_data failed error %d\
+			 Register (%s)\n", ret, msg);
+	return ret;
+}
+
+static ssize_t bh1780_show_lux(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct bh1780_data *ddata = platform_get_drvdata(pdev);
+	int lsb, msb;
+
+	lsb = bh1780_read(ddata, BH1780_REG_DLOW, "DLOW");
+	if (lsb < 0)
+		return lsb;
+
+	msb = bh1780_read(ddata, BH1780_REG_DHIGH, "DHIGH");
+	if (msb < 0)
+		return msb;
+
+	return sprintf(buf, "%d\n", (msb << 8) | lsb);
+}
+
+static ssize_t bh1780_show_power_state(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct bh1780_data *ddata = platform_get_drvdata(pdev);
+	int state;
+
+	state = bh1780_read(ddata, BH1780_REG_CONTROL, "CONTROL");
+	if (state < 0)
+		return state;
+
+	return sprintf(buf, "%d\n", state & BH1780_POWMASK);
+}
+
+static ssize_t bh1780_store_power_state(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct bh1780_data *ddata = platform_get_drvdata(pdev);
+	unsigned long val;
+	int error;
+
+	error = strict_strtoul(buf, 0, &val);
+	if (error)
+		return error;
+
+	if (val < BH1780_POFF || val > BH1780_PON)
+		return -EINVAL;
+
+	mutex_lock(&ddata->lock);
+
+	error = bh1780_write(ddata, BH1780_REG_CONTROL, val, "CONTROL");
+	if (error < 0) {
+		mutex_unlock(&ddata->lock);
+		return error;
+	}
+
+	msleep(BH1780_PON_DELAY);
+	ddata->power_state = val;
+	mutex_unlock(&ddata->lock);
+
+	return count;
+}
+
+static DEVICE_ATTR(lux, S_IRUGO, bh1780_show_lux, NULL);
+
+static DEVICE_ATTR(power_state, S_IWUSR | S_IRUGO,
+		bh1780_show_power_state, bh1780_store_power_state);
+
+static struct attribute *bh1780_attributes[] = {
+	&dev_attr_power_state.attr,
+	&dev_attr_lux.attr,
+	NULL
+};
+
+static const struct attribute_group bh1780_attr_group = {
+	.attrs = bh1780_attributes,
+};
+
+static int __devinit bh1780_probe(struct i2c_client *client,
+						const struct i2c_device_id *id)
+{
+	int ret;
+	struct bh1780_data *ddata = NULL;
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE)) {
+		ret = -EIO;
+		goto err_op_failed;
+	}
+
+	ddata = kzalloc(sizeof(struct bh1780_data), GFP_KERNEL);
+	if (ddata == NULL) {
+		ret = -ENOMEM;
+		goto err_op_failed;
+	}
+
+	ddata->client = client;
+	i2c_set_clientdata(client, ddata);
+
+	ret = bh1780_read(ddata, BH1780_REG_PARTID, "PART ID");
+	if (ret < 0)
+		goto err_op_failed;
+
+	dev_info(&client->dev, "Ambient Light Sensor, Rev : %d\n",
+			(ret & BH1780_REVMASK));
+
+	mutex_init(&ddata->lock);
+
+	ret = sysfs_create_group(&client->dev.kobj, &bh1780_attr_group);
+	if (ret)
+		goto err_op_failed;
+
+	return 0;
+
+err_op_failed:
+	kfree(ddata);
+	return ret;
+}
+
+static int __devexit bh1780_remove(struct i2c_client *client)
+{
+	struct bh1780_data *ddata;
+
+	ddata = i2c_get_clientdata(client);
+	sysfs_remove_group(&client->dev.kobj, &bh1780_attr_group);
+	i2c_set_clientdata(client, NULL);
+	kfree(ddata);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int bh1780_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct bh1780_data *ddata;
+	int state, ret;
+
+	ddata = i2c_get_clientdata(client);
+	state = bh1780_read(ddata, BH1780_REG_CONTROL, "CONTROL");
+	if (state < 0)
+		return state;
+
+	ddata->power_state = state & BH1780_POWMASK;
+
+	ret = bh1780_write(ddata, BH1780_REG_CONTROL, BH1780_POFF,
+				"CONTROL");
+
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int bh1780_resume(struct i2c_client *client)
+{
+	struct bh1780_data *ddata;
+	int state, ret;
+
+	ddata = i2c_get_clientdata(client);
+	state = ddata->power_state;
+
+	ret = bh1780_write(ddata, BH1780_REG_CONTROL, state,
+				"CONTROL");
+
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+#else
+#define bh1780_suspend NULL
+#define bh1780_resume NULL
+#endif /* CONFIG_PM */
+
+static const struct i2c_device_id bh1780_id[] = {
+	{ "bh1780", 0 },
+	{ },
+};
+
+static struct i2c_driver bh1780_driver = {
+	.probe		= bh1780_probe,
+	.remove		= bh1780_remove,
+	.id_table	= bh1780_id,
+	.suspend	= bh1780_suspend,
+	.resume		= bh1780_resume,
+	.driver = {
+		.name = "bh1780"
+	},
+};
+
+static int __init bh1780_init(void)
+{
+	return i2c_add_driver(&bh1780_driver);
+}
+
+static void __exit bh1780_exit(void)
+{
+	i2c_del_driver(&bh1780_driver);
+}
+
+module_init(bh1780_init)
+module_exit(bh1780_exit)
+
+MODULE_DESCRIPTION("BH1780GLI Ambient Light Sensor Driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Hemanth V <hemanthv@ti.com>");
_

Patches currently in -mm which might be from hemanthv@ti.com are

misc-rohm-bh1780gli-ambient-light-sensor-driver.patch

