From: akpm@linux-foundation.org
Subject: - i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch removed from -mm tree
Date: Tue, 15 May 2007 11:07:31 -0700
Message-ID: <200705151807.l4FI7UJU014171@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755792AbXEOSIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 May 2007 14:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant.likely@secretlab.ca, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i2c: add driver for Dallas DS1682 elapsed time recorder
has been removed from the -mm tree.  Its filename was
     i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i2c: add driver for Dallas DS1682 elapsed time recorder
From: Grant Likely <grant.likely@secretlab.ca>

[akpm@linux-foundation.org: build fix]
[akpm@linux-foundation.org: printk warning fixes]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/Kconfig  |   10 
 drivers/i2c/chips/Makefile |    1 
 drivers/i2c/chips/ds1682.c |  361 +++++++++++++++++++++++++++++++++++
 3 files changed, 372 insertions(+)

diff -puN drivers/i2c/chips/Kconfig~i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder drivers/i2c/chips/Kconfig
--- a/drivers/i2c/chips/Kconfig~i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder
+++ a/drivers/i2c/chips/Kconfig
@@ -24,6 +24,16 @@ config SENSORS_DS1374
 	  This driver can also be built as a module.  If so, the module
 	  will be called ds1374.
 
+config SENSORS_DS1682
+	tristate "Maxim/Dallas DS1682 Total Elapsed Time Recorder with Alarm"
+	depends on I2C && EXPERIMENTAL
+	help
+	  If you say yes here you get support for Dallas Semiconductor
+	  DS1682 Total Elapsed Time Recorder
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called ds1682.
+
 config SENSORS_EEPROM
 	tristate "EEPROM reader"
 	depends on EXPERIMENTAL
diff -puN drivers/i2c/chips/Makefile~i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder drivers/i2c/chips/Makefile
--- a/drivers/i2c/chips/Makefile~i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder
+++ a/drivers/i2c/chips/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_SENSORS_DS1337)	+= ds1337.o
 obj-$(CONFIG_SENSORS_DS1374)	+= ds1374.o
+obj-$(CONFIG_SENSORS_DS1682)	+= ds1682.o
 obj-$(CONFIG_SENSORS_EEPROM)	+= eeprom.o
 obj-$(CONFIG_SENSORS_MAX6875)	+= max6875.o
 obj-$(CONFIG_SENSORS_M41T00)	+= m41t00.o
diff -puN /dev/null drivers/i2c/chips/ds1682.c
--- /dev/null
+++ a/drivers/i2c/chips/ds1682.c
@@ -0,0 +1,361 @@
+/*
+ * Dallas Semiconductor DS1682 Elapsed Time Recorder device driver
+ *
+ * Written by: Grant Likely <grant.likely@secretlab.ca>
+ *
+ * Copyright (C) 2007 Secret Lab Technologies Ltd.
+ * Copyright (C) 2005 James Chapman <jchapman@katalix.com>
+ * Copyright (C) 2000 Russell King
+ *
+ * Derived from ds1337 real time clock device driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * The DS1682 elapsed timer recorder is a simple device that implements
+ * one elapsed time counters, one event counter, an alarm signal and 10
+ * bytes of general purpose EEPROM.
+ *
+ * This driver provides access to the DS1682 counters and user data via
+ * the sysfs.  The following attributes are added to the device node:
+ *     elapsed_time (u32): Total elapsed event time in 1/4s resolution
+ *     alarm_time (u32): When elapsed time exceeds the value in alarm_time,
+ *                       then the alarm pin is asserted.
+ *     event_count (u16): number of times the event pin has gone low.
+ *     user_data (u8[10]): general purpose EEPROM
+ *
+ * Counter registers and user data are both read/write unless the device
+ * has been write protected.  This driver does not support turning on write
+ * protection.  Once write protection is turned on, it is impossible to
+ * turn off so I have left the feature out of this driver to avoid
+ * accidental enabling, but it is trivial to add write protect support.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/string.h>
+#include <linux/bcd.h>
+#include <linux/list.h>
+#include <linux/sysfs.h>
+#include <linux/ctype.h>
+
+/* Device registers */
+#define DS1682_ADDR			0x6B
+
+#define DS1682_REG_CONFIG		0x00
+#define DS1682_REG_ALARM		0x01
+#define DS1682_REG_ELAPSED		0x05
+#define DS1682_REG_EVT_CNTR		0x09
+#define DS1682_REG_USER_DATA		0x0b
+#define DS1682_REG_RESET		0x1d
+#define DS1682_REG_WRITE_DISABLE	0x1e
+#define DS1682_REG_WRITE_MEM_DISABLE	0x1f
+
+/*
+ * Probing class
+ */
+static unsigned short normal_i2c[] = { DS1682_ADDR, I2C_CLIENT_END };
+
+I2C_CLIENT_INSMOD;
+
+/*
+ * Low level chip access functions
+ */
+static int ds1682_read(struct i2c_client *client, int reg, void *buf, int len)
+{
+	u8 *bytes = buf;
+	int val;
+
+	while (len--) {
+		val = i2c_smbus_read_byte_data(client, reg++);
+		if (val < 0)
+			return -EIO;
+		*bytes++ = val;
+	}
+	return 0;
+}
+
+/*
+ * Generic counter attributes
+ */
+static int ds1682_attr_to_reg(struct device_attribute *attr, int *regsize);
+
+static ssize_t ds1682_show(struct device *dev,
+			   struct device_attribute *attr, char *buf)
+{
+	u32 val = 0;
+	int reg;
+	int regsize;
+
+	dev_dbg(dev, "ds1682_show() called for %s\n", attr->attr.name);
+
+	/* Get the register address */
+	reg = ds1682_attr_to_reg(attr, &regsize);
+	if (reg < 0)
+		return -EIO;
+
+	/* Read the register */
+	if (ds1682_read(to_i2c_client(dev), reg, &val, regsize))
+		return -EIO;
+
+	/* Format the output string and return # of bytes */
+	return sprintf(buf, "0x%.2x\n", le32_to_cpu(val));
+}
+
+static ssize_t ds1682_store(struct device *dev,
+			    struct device_attribute *attr, const char *buf,
+			    size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int reg;
+	int regsize;
+	char *endp;
+	u32 val;
+	int rc;
+
+	/* Sanitize the input */
+	reg = ds1682_attr_to_reg(attr, &regsize);
+
+	if ((reg < 0) || (count >= 16) || (buf[count] != '\0')) {
+		dev_dbg(dev, "insane input; reg=0x%i count=%zd%s\n",
+			reg, count, buf[count] == '\0' ? " unterminated" : "");
+		return -EIO;
+	}
+
+	/* Decode input */
+	val = simple_strtoul(buf, &endp, 0);
+	if (buf == endp) {
+		dev_dbg(dev, "input string not a number\n");
+		return -EIO;
+	}
+
+	/* write out the value */
+	val = cpu_to_le32(val);
+	rc = i2c_smbus_write_i2c_block_data(client, reg, regsize, (void *)&val);
+	if (rc < 0) {
+		dev_err(dev, "register write failed; reg=0x%x, size=%i\n",
+			reg, regsize);
+		return -EIO;
+	}
+
+	return count;
+}
+
+/*
+ * Simple register attributes
+ */
+DEVICE_ATTR(config, S_IRUGO, ds1682_show, NULL);
+DEVICE_ATTR(elapsed_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store);
+DEVICE_ATTR(alarm_time, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store);
+DEVICE_ATTR(event_count, S_IRUGO | S_IWUSR, ds1682_show, ds1682_store);
+
+/* Get register size and address from device_attribute structure.  This
+ * function must come after the DEVICE_ATTR() lines as it depends on the
+ * device_attribute lines being declared */
+static int ds1682_attr_to_reg(struct device_attribute *attr, int *regsize)
+{
+	if (attr == &dev_attr_elapsed_time) {
+		*regsize = 4;
+		return DS1682_REG_ELAPSED;
+	}
+
+	if (attr == &dev_attr_alarm_time) {
+		*regsize = 4;
+		return DS1682_REG_ALARM;
+	}
+
+	if (attr == &dev_attr_event_count) {
+		*regsize = 2;
+		return DS1682_REG_EVT_CNTR;
+	}
+
+	if (attr == &dev_attr_config) {
+		*regsize = 1;
+		return DS1682_REG_CONFIG;
+	}
+
+	pr_debug("Cannot find registers for device_attribute %p\n", attr);
+	return -ENODEV;
+}
+
+/*
+ * User data attribute
+ */
+static ssize_t ds1682_user_data_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	char *end = buf;
+	u8 val[10];
+	int i;
+
+	if (ds1682_read(to_i2c_client(dev), DS1682_REG_USER_DATA, &val, 10))
+		return -EIO;
+
+	for (i = 0; i < 10; i++)
+		end += sprintf(end, "%.2x ", val[i]);
+
+	*(end - 1) = '\n';	/* Eliminate trailing space */
+	return end - buf;
+}
+
+static ssize_t ds1682_user_data_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	u8 data[10];
+	char *endp;
+	int bytecount = 0;
+
+	/* Check input for sanity */
+	if ((count >= 80) || (buf[count] != '\0')) {
+		dev_dbg(dev, "insane input; count=%zd%s\n",
+			count, buf[count] == '\0' ? " unterminated" : "");
+		return -EIO;
+	}
+
+	/* Parse the data */
+	while (bytecount < 10) {
+		while (isspace(*buf))
+			buf++;
+
+		data[bytecount] = simple_strtoul(buf, &endp, 16);
+		if (endp == buf)	/* make sure it's a real data value */
+			break;
+
+		buf = endp;
+		bytecount++;
+	}
+	while (isspace(*endp))
+		endp++;
+
+	/* Abort on invalid data */
+	if ((bytecount == 0) || (*endp != '\0')) {
+		dev_dbg(dev, "invalid input *buf=\"%s\" *endp=\"%s\"\n",
+			buf, endp);
+		return -EIO;
+	}
+
+	/* Write out to the device */
+	if (i2c_smbus_write_i2c_block_data(to_i2c_client(dev),
+					   DS1682_REG_USER_DATA, bytecount,
+					   data) < 0)
+		return -EIO;
+	return count;
+}
+
+DEVICE_ATTR(user_data, S_IRUGO | S_IWUSR, ds1682_user_data_show,
+	    ds1682_user_data_store);
+
+/*
+ * Called when a device is found at the ds1682 address
+ */
+static struct i2c_driver ds1682_driver;
+static int ds1682_detect(struct i2c_adapter *adapter, int address, int kind)
+{
+	struct i2c_client *new_client;
+	int err = 0;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA |
+				     I2C_FUNC_I2C))
+		goto exit;
+
+	if (!(new_client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL))) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	new_client->addr = address;
+	new_client->adapter = adapter;
+	new_client->driver = &ds1682_driver;
+	new_client->flags = 0;
+
+	/* Note: Ignoring 'kind' value as the ds1682 uses a fixed address */
+
+	/* We can fill in the remaining client fields */
+	strlcpy(new_client->name, "ds1682", I2C_NAME_SIZE);
+
+	/* Tell the I2C layer a new client has arrived */
+	if ((err = i2c_attach_client(new_client)))
+		goto exit_free;
+
+	if (device_create_file(&new_client->dev, &dev_attr_config))
+		goto exit_attr_config;
+	if (device_create_file(&new_client->dev, &dev_attr_elapsed_time))
+		goto exit_attr_elapsed;
+	if (device_create_file(&new_client->dev, &dev_attr_alarm_time))
+		goto exit_attr_alarm;
+	if (device_create_file(&new_client->dev, &dev_attr_event_count))
+		goto exit_attr_event;
+	if (device_create_file(&new_client->dev, &dev_attr_user_data))
+		goto exit_attr_userdata;
+
+	return 0;
+
+      exit_attr_userdata:
+	device_remove_file(&new_client->dev, &dev_attr_event_count);
+      exit_attr_event:
+	device_remove_file(&new_client->dev, &dev_attr_alarm_time);
+      exit_attr_alarm:
+	device_remove_file(&new_client->dev, &dev_attr_elapsed_time);
+      exit_attr_elapsed:
+	device_remove_file(&new_client->dev, &dev_attr_config);
+      exit_attr_config:
+	i2c_detach_client(new_client);
+      exit_free:
+	kfree(new_client);
+      exit:
+	return err;
+}
+
+static int ds1682_attach_adapter(struct i2c_adapter *adapter)
+{
+	return i2c_probe(adapter, &addr_data, ds1682_detect);
+}
+
+static int ds1682_detach_client(struct i2c_client *client)
+{
+	int err;
+	device_remove_file(&client->dev, &dev_attr_user_data);
+	device_remove_file(&client->dev, &dev_attr_event_count);
+	device_remove_file(&client->dev, &dev_attr_alarm_time);
+	device_remove_file(&client->dev, &dev_attr_elapsed_time);
+	device_remove_file(&client->dev, &dev_attr_config);
+
+	if ((err = i2c_detach_client(client)))
+		return err;
+
+	kfree(client);
+	return 0;
+}
+
+static struct i2c_driver ds1682_driver = {
+	.driver = {
+		   .name = "ds1682",
+		   },
+	.attach_adapter = ds1682_attach_adapter,
+	.detach_client = ds1682_detach_client,
+};
+
+static int __init ds1682_init(void)
+{
+	return i2c_add_driver(&ds1682_driver);
+}
+
+static void __exit ds1682_exit(void)
+{
+	i2c_del_driver(&ds1682_driver);
+}
+
+MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
+MODULE_DESCRIPTION("DS1682 Elapsed Time Indicator driver");
+MODULE_LICENSE("GPL");
+
+module_init(ds1682_init);
+module_exit(ds1682_exit);
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

add-support-for-xilinx-systemace-compactflash-interface.patch
