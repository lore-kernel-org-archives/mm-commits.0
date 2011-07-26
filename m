From: akpm@linux-foundation.org
Subject: [merged] drivers-misc-add-support-the-fsa9480-usb-switch.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:20 -0700
Message-ID: <201107260754.p6Q7sN80003347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832Ab1GZHzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dg77.kim@samsung.com, greg@kroah.com, kyungmin.park@samsung.com, mk7.kang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     drivers/misc: add support the FSA9480 USB Switch
has been removed from the -mm tree.  Its filename was
     drivers-misc-add-support-the-fsa9480-usb-switch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/misc: add support the FSA9480 USB Switch
From: Donggeun Kim <dg77.kim@samsung.com>

The FSA9480 is a USB port accessory detector and switch.  This patch adds
support the FSA9480 USB Switch.

[akpm@linux-foundation.org: make a couple of things static]
Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-bus-i2c-devices-fsa9480 |   21 
 drivers/misc/Kconfig                                    |    9 
 drivers/misc/Makefile                                   |    1 
 drivers/misc/fsa9480.c                                  |  557 ++++++++++
 include/linux/platform_data/fsa9480.h                   |   27 
 5 files changed, 615 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-bus-i2c-devices-fsa9480
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-bus-i2c-devices-fsa9480
@@ -0,0 +1,21 @@
+What:		/sys/bus/i2c/devices/.../device
+Date:		February 2011
+Contact:	Minkyu Kang <mk7.kang@samsung.com>
+Description:
+		show what device is attached
+		NONE - no device
+		USB - USB device is attached
+		UART - UART is attached
+		CHARGER - Charger is attaced
+		JIG - JIG is attached
+
+What:		/sys/bus/i2c/devices/.../switch
+Date:		February 2011
+Contact:	Minkyu Kang <mk7.kang@samsung.com>
+Description:
+		show or set the state of manual switch
+		VAUDIO - switch to VAUDIO path
+		UART - switch to UART path
+		AUDIO - switch to AUDIO path
+		DHOST - switch to DHOST path
+		AUTO - switch automatically by device
diff -puN drivers/misc/Kconfig~drivers-misc-add-support-the-fsa9480-usb-switch drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~drivers-misc-add-support-the-fsa9480-usb-switch
+++ a/drivers/misc/Kconfig
@@ -489,6 +489,15 @@ config PCH_PHUB
 	  To compile this driver as a module, choose M here: the module will
 	  be called pch_phub.
 
+config USB_SWITCH_FSA9480
+	tristate "FSA9480 USB Switch"
+	depends on I2C
+	help
+	  The FSA9480 is a USB port accessory detector and switch.
+	  The FSA9480 is fully controlled using I2C and enables USB data,
+	  stereo and mono audio, video, microphone and UART data to use
+	  a common connector port.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff -puN drivers/misc/Makefile~drivers-misc-add-support-the-fsa9480-usb-switch drivers/misc/Makefile
--- a/drivers/misc/Makefile~drivers-misc-add-support-the-fsa9480-usb-switch
+++ a/drivers/misc/Makefile
@@ -46,3 +46,4 @@ obj-y				+= ti-st/
 obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
 obj-y				+= lis3lv02d/
 obj-y				+= carma/
+obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
diff -puN /dev/null drivers/misc/fsa9480.c
--- /dev/null
+++ a/drivers/misc/fsa9480.c
@@ -0,0 +1,557 @@
+/*
+ * fsa9480.c - FSA9480 micro USB switch device driver
+ *
+ * Copyright (C) 2010 Samsung Electronics
+ * Minkyu Kang <mk7.kang@samsung.com>
+ * Wonguk Jeong <wonguk.jeong@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/platform_data/fsa9480.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/pm_runtime.h>
+
+/* FSA9480 I2C registers */
+#define FSA9480_REG_DEVID		0x01
+#define FSA9480_REG_CTRL		0x02
+#define FSA9480_REG_INT1		0x03
+#define FSA9480_REG_INT2		0x04
+#define FSA9480_REG_INT1_MASK		0x05
+#define FSA9480_REG_INT2_MASK		0x06
+#define FSA9480_REG_ADC			0x07
+#define FSA9480_REG_TIMING1		0x08
+#define FSA9480_REG_TIMING2		0x09
+#define FSA9480_REG_DEV_T1		0x0a
+#define FSA9480_REG_DEV_T2		0x0b
+#define FSA9480_REG_BTN1		0x0c
+#define FSA9480_REG_BTN2		0x0d
+#define FSA9480_REG_CK			0x0e
+#define FSA9480_REG_CK_INT1		0x0f
+#define FSA9480_REG_CK_INT2		0x10
+#define FSA9480_REG_CK_INTMASK1		0x11
+#define FSA9480_REG_CK_INTMASK2		0x12
+#define FSA9480_REG_MANSW1		0x13
+#define FSA9480_REG_MANSW2		0x14
+
+/* Control */
+#define CON_SWITCH_OPEN		(1 << 4)
+#define CON_RAW_DATA		(1 << 3)
+#define CON_MANUAL_SW		(1 << 2)
+#define CON_WAIT		(1 << 1)
+#define CON_INT_MASK		(1 << 0)
+#define CON_MASK		(CON_SWITCH_OPEN | CON_RAW_DATA | \
+				CON_MANUAL_SW | CON_WAIT)
+
+/* Device Type 1 */
+#define DEV_USB_OTG		(1 << 7)
+#define DEV_DEDICATED_CHG	(1 << 6)
+#define DEV_USB_CHG		(1 << 5)
+#define DEV_CAR_KIT		(1 << 4)
+#define DEV_UART		(1 << 3)
+#define DEV_USB			(1 << 2)
+#define DEV_AUDIO_2		(1 << 1)
+#define DEV_AUDIO_1		(1 << 0)
+
+#define DEV_T1_USB_MASK		(DEV_USB_OTG | DEV_USB)
+#define DEV_T1_UART_MASK	(DEV_UART)
+#define DEV_T1_CHARGER_MASK	(DEV_DEDICATED_CHG | DEV_USB_CHG)
+
+/* Device Type 2 */
+#define DEV_AV			(1 << 6)
+#define DEV_TTY			(1 << 5)
+#define DEV_PPD			(1 << 4)
+#define DEV_JIG_UART_OFF	(1 << 3)
+#define DEV_JIG_UART_ON		(1 << 2)
+#define DEV_JIG_USB_OFF		(1 << 1)
+#define DEV_JIG_USB_ON		(1 << 0)
+
+#define DEV_T2_USB_MASK		(DEV_JIG_USB_OFF | DEV_JIG_USB_ON)
+#define DEV_T2_UART_MASK	(DEV_JIG_UART_OFF | DEV_JIG_UART_ON)
+#define DEV_T2_JIG_MASK		(DEV_JIG_USB_OFF | DEV_JIG_USB_ON | \
+				DEV_JIG_UART_OFF | DEV_JIG_UART_ON)
+
+/*
+ * Manual Switch
+ * D- [7:5] / D+ [4:2]
+ * 000: Open all / 001: USB / 010: AUDIO / 011: UART / 100: V_AUDIO
+ */
+#define SW_VAUDIO		((4 << 5) | (4 << 2))
+#define SW_UART			((3 << 5) | (3 << 2))
+#define SW_AUDIO		((2 << 5) | (2 << 2))
+#define SW_DHOST		((1 << 5) | (1 << 2))
+#define SW_AUTO			((0 << 5) | (0 << 2))
+
+/* Interrupt 1 */
+#define INT_DETACH		(1 << 1)
+#define INT_ATTACH		(1 << 0)
+
+struct fsa9480_usbsw {
+	struct i2c_client		*client;
+	struct fsa9480_platform_data	*pdata;
+	int				dev1;
+	int				dev2;
+	int				mansw;
+};
+
+static struct fsa9480_usbsw *chip;
+
+static int fsa9480_write_reg(struct i2c_client *client,
+		int reg, int value)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, reg, value);
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static int fsa9480_read_reg(struct i2c_client *client, int reg)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static int fsa9480_read_irq(struct i2c_client *client, int *value)
+{
+	int ret;
+
+	ret = i2c_smbus_read_i2c_block_data(client,
+			FSA9480_REG_INT1, 2, (u8 *)value);
+	*value &= 0xffff;
+
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static void fsa9480_set_switch(const char *buf)
+{
+	struct fsa9480_usbsw *usbsw = chip;
+	struct i2c_client *client = usbsw->client;
+	unsigned int value;
+	unsigned int path = 0;
+
+	value = fsa9480_read_reg(client, FSA9480_REG_CTRL);
+
+	if (!strncmp(buf, "VAUDIO", 6)) {
+		path = SW_VAUDIO;
+		value &= ~CON_MANUAL_SW;
+	} else if (!strncmp(buf, "UART", 4)) {
+		path = SW_UART;
+		value &= ~CON_MANUAL_SW;
+	} else if (!strncmp(buf, "AUDIO", 5)) {
+		path = SW_AUDIO;
+		value &= ~CON_MANUAL_SW;
+	} else if (!strncmp(buf, "DHOST", 5)) {
+		path = SW_DHOST;
+		value &= ~CON_MANUAL_SW;
+	} else if (!strncmp(buf, "AUTO", 4)) {
+		path = SW_AUTO;
+		value |= CON_MANUAL_SW;
+	} else {
+		printk(KERN_ERR "Wrong command\n");
+		return;
+	}
+
+	usbsw->mansw = path;
+	fsa9480_write_reg(client, FSA9480_REG_MANSW1, path);
+	fsa9480_write_reg(client, FSA9480_REG_CTRL, value);
+}
+
+static ssize_t fsa9480_get_switch(char *buf)
+{
+	struct fsa9480_usbsw *usbsw = chip;
+	struct i2c_client *client = usbsw->client;
+	unsigned int value;
+
+	value = fsa9480_read_reg(client, FSA9480_REG_MANSW1);
+
+	if (value == SW_VAUDIO)
+		return sprintf(buf, "VAUDIO\n");
+	else if (value == SW_UART)
+		return sprintf(buf, "UART\n");
+	else if (value == SW_AUDIO)
+		return sprintf(buf, "AUDIO\n");
+	else if (value == SW_DHOST)
+		return sprintf(buf, "DHOST\n");
+	else if (value == SW_AUTO)
+		return sprintf(buf, "AUTO\n");
+	else
+		return sprintf(buf, "%x", value);
+}
+
+static ssize_t fsa9480_show_device(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct fsa9480_usbsw *usbsw = dev_get_drvdata(dev);
+	struct i2c_client *client = usbsw->client;
+	int dev1, dev2;
+
+	dev1 = fsa9480_read_reg(client, FSA9480_REG_DEV_T1);
+	dev2 = fsa9480_read_reg(client, FSA9480_REG_DEV_T2);
+
+	if (!dev1 && !dev2)
+		return sprintf(buf, "NONE\n");
+
+	/* USB */
+	if (dev1 & DEV_T1_USB_MASK || dev2 & DEV_T2_USB_MASK)
+		return sprintf(buf, "USB\n");
+
+	/* UART */
+	if (dev1 & DEV_T1_UART_MASK || dev2 & DEV_T2_UART_MASK)
+		return sprintf(buf, "UART\n");
+
+	/* CHARGER */
+	if (dev1 & DEV_T1_CHARGER_MASK)
+		return sprintf(buf, "CHARGER\n");
+
+	/* JIG */
+	if (dev2 & DEV_T2_JIG_MASK)
+		return sprintf(buf, "JIG\n");
+
+	return sprintf(buf, "UNKNOWN\n");
+}
+
+static ssize_t fsa9480_show_manualsw(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return fsa9480_get_switch(buf);
+
+}
+
+static ssize_t fsa9480_set_manualsw(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	fsa9480_set_switch(buf);
+
+	return count;
+}
+
+static DEVICE_ATTR(device, S_IRUGO, fsa9480_show_device, NULL);
+static DEVICE_ATTR(switch, S_IRUGO | S_IWUSR,
+		fsa9480_show_manualsw, fsa9480_set_manualsw);
+
+static struct attribute *fsa9480_attributes[] = {
+	&dev_attr_device.attr,
+	&dev_attr_switch.attr,
+	NULL
+};
+
+static const struct attribute_group fsa9480_group = {
+	.attrs = fsa9480_attributes,
+};
+
+static void fsa9480_detect_dev(struct fsa9480_usbsw *usbsw, int intr)
+{
+	int val1, val2, ctrl;
+	struct fsa9480_platform_data *pdata = usbsw->pdata;
+	struct i2c_client *client = usbsw->client;
+
+	val1 = fsa9480_read_reg(client, FSA9480_REG_DEV_T1);
+	val2 = fsa9480_read_reg(client, FSA9480_REG_DEV_T2);
+	ctrl = fsa9480_read_reg(client, FSA9480_REG_CTRL);
+
+	dev_info(&client->dev, "intr: 0x%x, dev1: 0x%x, dev2: 0x%x\n",
+			intr, val1, val2);
+
+	if (!intr)
+		goto out;
+
+	if (intr & INT_ATTACH) {	/* Attached */
+		/* USB */
+		if (val1 & DEV_T1_USB_MASK || val2 & DEV_T2_USB_MASK) {
+			if (pdata->usb_cb)
+				pdata->usb_cb(FSA9480_ATTACHED);
+
+			if (usbsw->mansw) {
+				fsa9480_write_reg(client,
+					FSA9480_REG_MANSW1, usbsw->mansw);
+			}
+		}
+
+		/* UART */
+		if (val1 & DEV_T1_UART_MASK || val2 & DEV_T2_UART_MASK) {
+			if (pdata->uart_cb)
+				pdata->uart_cb(FSA9480_ATTACHED);
+
+			if (!(ctrl & CON_MANUAL_SW)) {
+				fsa9480_write_reg(client,
+					FSA9480_REG_MANSW1, SW_UART);
+			}
+		}
+
+		/* CHARGER */
+		if (val1 & DEV_T1_CHARGER_MASK) {
+			if (pdata->charger_cb)
+				pdata->charger_cb(FSA9480_ATTACHED);
+		}
+
+		/* JIG */
+		if (val2 & DEV_T2_JIG_MASK) {
+			if (pdata->jig_cb)
+				pdata->jig_cb(FSA9480_ATTACHED);
+		}
+	} else if (intr & INT_DETACH) {	/* Detached */
+		/* USB */
+		if (usbsw->dev1 & DEV_T1_USB_MASK ||
+			usbsw->dev2 & DEV_T2_USB_MASK) {
+			if (pdata->usb_cb)
+				pdata->usb_cb(FSA9480_DETACHED);
+		}
+
+		/* UART */
+		if (usbsw->dev1 & DEV_T1_UART_MASK ||
+			usbsw->dev2 & DEV_T2_UART_MASK) {
+			if (pdata->uart_cb)
+				pdata->uart_cb(FSA9480_DETACHED);
+		}
+
+		/* CHARGER */
+		if (usbsw->dev1 & DEV_T1_CHARGER_MASK) {
+			if (pdata->charger_cb)
+				pdata->charger_cb(FSA9480_DETACHED);
+		}
+
+		/* JIG */
+		if (usbsw->dev2 & DEV_T2_JIG_MASK) {
+			if (pdata->jig_cb)
+				pdata->jig_cb(FSA9480_DETACHED);
+		}
+	}
+
+	usbsw->dev1 = val1;
+	usbsw->dev2 = val2;
+
+out:
+	ctrl &= ~CON_INT_MASK;
+	fsa9480_write_reg(client, FSA9480_REG_CTRL, ctrl);
+}
+
+static irqreturn_t fsa9480_irq_handler(int irq, void *data)
+{
+	struct fsa9480_usbsw *usbsw = data;
+	struct i2c_client *client = usbsw->client;
+	int intr;
+
+	/* clear interrupt */
+	fsa9480_read_irq(client, &intr);
+
+	/* device detection */
+	fsa9480_detect_dev(usbsw, intr);
+
+	return IRQ_HANDLED;
+}
+
+static int fsa9480_irq_init(struct fsa9480_usbsw *usbsw)
+{
+	struct fsa9480_platform_data *pdata = usbsw->pdata;
+	struct i2c_client *client = usbsw->client;
+	int ret;
+	int intr;
+	unsigned int ctrl = CON_MASK;
+
+	/* clear interrupt */
+	fsa9480_read_irq(client, &intr);
+
+	/* unmask interrupt (attach/detach only) */
+	fsa9480_write_reg(client, FSA9480_REG_INT1_MASK, 0xfc);
+	fsa9480_write_reg(client, FSA9480_REG_INT2_MASK, 0x1f);
+
+	usbsw->mansw = fsa9480_read_reg(client, FSA9480_REG_MANSW1);
+
+	if (usbsw->mansw)
+		ctrl &= ~CON_MANUAL_SW;	/* Manual Switching Mode */
+
+	fsa9480_write_reg(client, FSA9480_REG_CTRL, ctrl);
+
+	if (pdata && pdata->cfg_gpio)
+		pdata->cfg_gpio();
+
+	if (client->irq) {
+		ret = request_threaded_irq(client->irq, NULL,
+				fsa9480_irq_handler,
+				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				"fsa9480 micro USB", usbsw);
+		if (ret) {
+			dev_err(&client->dev, "failed to reqeust IRQ\n");
+			return ret;
+		}
+
+		device_init_wakeup(&client->dev, pdata->wakeup);
+	}
+
+	return 0;
+}
+
+static int __devinit fsa9480_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	struct fsa9480_usbsw *usbsw;
+	int ret = 0;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	usbsw = kzalloc(sizeof(struct fsa9480_usbsw), GFP_KERNEL);
+	if (!usbsw) {
+		dev_err(&client->dev, "failed to allocate driver data\n");
+		return -ENOMEM;
+	}
+
+	usbsw->client = client;
+	usbsw->pdata = client->dev.platform_data;
+
+	chip = usbsw;
+
+	i2c_set_clientdata(client, usbsw);
+
+	ret = fsa9480_irq_init(usbsw);
+	if (ret)
+		goto fail1;
+
+	ret = sysfs_create_group(&client->dev.kobj, &fsa9480_group);
+	if (ret) {
+		dev_err(&client->dev,
+				"failed to create fsa9480 attribute group\n");
+		goto fail2;
+	}
+
+	/* ADC Detect Time: 500ms */
+	fsa9480_write_reg(client, FSA9480_REG_TIMING1, 0x6);
+
+	if (chip->pdata->reset_cb)
+		chip->pdata->reset_cb();
+
+	/* device detection */
+	fsa9480_detect_dev(usbsw, INT_ATTACH);
+
+	pm_runtime_set_active(&client->dev);
+
+	return 0;
+
+fail2:
+	if (client->irq)
+		free_irq(client->irq, NULL);
+fail1:
+	i2c_set_clientdata(client, NULL);
+	kfree(usbsw);
+	return ret;
+}
+
+static int __devexit fsa9480_remove(struct i2c_client *client)
+{
+	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
+	if (client->irq)
+		free_irq(client->irq, NULL);
+	i2c_set_clientdata(client, NULL);
+
+	sysfs_remove_group(&client->dev.kobj, &fsa9480_group);
+	device_init_wakeup(&client->dev, 0);
+	kfree(usbsw);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+static int fsa9480_suspend(struct i2c_client *client, pm_message_t state)
+{
+	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
+	struct fsa9480_platform_data *pdata = usbsw->pdata;
+
+	if (device_may_wakeup(&client->dev) && client->irq)
+		enable_irq_wake(client->irq);
+
+	if (pdata->usb_power)
+		pdata->usb_power(0);
+
+	return 0;
+}
+
+static int fsa9480_resume(struct i2c_client *client)
+{
+	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
+	int dev1, dev2;
+
+	if (device_may_wakeup(&client->dev) && client->irq)
+		disable_irq_wake(client->irq);
+
+	/*
+	 * Clear Pending interrupt. Note that detect_dev does what
+	 * the interrupt handler does. So, we don't miss pending and
+	 * we reenable interrupt if there is one.
+	 */
+	fsa9480_read_reg(client, FSA9480_REG_INT1);
+	fsa9480_read_reg(client, FSA9480_REG_INT2);
+
+	dev1 = fsa9480_read_reg(client, FSA9480_REG_DEV_T1);
+	dev2 = fsa9480_read_reg(client, FSA9480_REG_DEV_T2);
+
+	/* device detection */
+	fsa9480_detect_dev(usbsw, (dev1 || dev2) ? INT_ATTACH : INT_DETACH);
+
+	return 0;
+}
+
+#else
+
+#define fsa9480_suspend NULL
+#define fsa9480_resume NULL
+
+#endif /* CONFIG_PM */
+
+static const struct i2c_device_id fsa9480_id[] = {
+	{"fsa9480", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, fsa9480_id);
+
+static struct i2c_driver fsa9480_i2c_driver = {
+	.driver = {
+		.name = "fsa9480",
+	},
+	.probe = fsa9480_probe,
+	.remove = __devexit_p(fsa9480_remove),
+	.resume = fsa9480_resume,
+	.suspend = fsa9480_suspend,
+	.id_table = fsa9480_id,
+};
+
+static int __init fsa9480_init(void)
+{
+	return i2c_add_driver(&fsa9480_i2c_driver);
+}
+module_init(fsa9480_init);
+
+static void __exit fsa9480_exit(void)
+{
+	i2c_del_driver(&fsa9480_i2c_driver);
+}
+module_exit(fsa9480_exit);
+
+MODULE_AUTHOR("Minkyu Kang <mk7.kang@samsung.com>");
+MODULE_DESCRIPTION("FSA9480 USB Switch driver");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/platform_data/fsa9480.h
--- /dev/null
+++ a/include/linux/platform_data/fsa9480.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2010 Samsung Electronics
+ * Minkyu Kang <mk7.kang@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _FSA9480_H_
+#define _FSA9480_H_
+
+#define FSA9480_ATTACHED	1
+#define FSA9480_DETACHED	0
+
+struct fsa9480_platform_data {
+	void (*cfg_gpio) (void);
+	void (*usb_cb) (u8 attached);
+	void (*uart_cb) (u8 attached);
+	void (*charger_cb) (u8 attached);
+	void (*jig_cb) (u8 attached);
+	void (*reset_cb) (void);
+	void (*usb_power) (u8 on);
+	int wakeup;
+};
+
+#endif /* _FSA9480_H_ */
_

Patches currently in -mm which might be from dg77.kim@samsung.com are

origin.patch
linux-next.patch

