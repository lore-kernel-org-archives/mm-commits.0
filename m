From: akpm@linux-foundation.org
Subject: [nacked] usb-qti-directemp-usb-thermometer-hygrometer-driver-support.patch removed from -mm tree
Date: Fri, 05 Feb 2010 19:03:27 -0800
Message-ID: <201002060303.o1633RFF003644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab0BFDEI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 22:04:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisv@cyberswitching.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: QTI DirecTEMP USB thermometer/hygrometer driver support
has been removed from the -mm tree.  Its filename was
     usb-qti-directemp-usb-thermometer-hygrometer-driver-support.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: QTI DirecTEMP USB thermometer/hygrometer driver support
From: "Chris Verges" <chrisv@cyberswitching.com>
DESC
usb: QTI DirecTEMP USB thermometer/hygrometer driver support
EDESC

A driver for the QTI DirecTEMP USB thermometer & thermometer/hygrometer
sensors.  Functionality has been verified against both hardware variants
listed in the driver (0x0002 and 0x0006), as both monolithic and modular.

When the QTI DirecTEMP sensor is connected to a system, the directemp
driver adds appropriate sysfs entries for the sensor type(s) supported. 
Examples:

   # PID 0x0002 (temp only)
   /sys/bus/usb/devices/.../temp

   # PID 0x0006 (temp + relative humidity)
   /sys/bus/usb/devices/.../temp
   /sys/bus/usb/devices/.../rh

Using a standard "cat" will display the value.

An additional "raw" sysfs entry has been added to aid in debugging.  If
used, an "echo" will send the data specified in the string to the USB
device, and print back the results.  It is not recommended for customer
use except by expert users.

Signed-off-by: Chris Verges <chrisv@cyberswitching.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/Kconfig     |   11 -
 drivers/usb/misc/Makefile    |    1 
 drivers/usb/misc/directemp.c |  335 +++++++++++++++++++++++++++++++++
 3 files changed, 346 insertions(+), 1 deletion(-)

diff -puN drivers/usb/misc/Kconfig~usb-qti-directemp-usb-thermometer-hygrometer-driver-support drivers/usb/misc/Kconfig
--- a/drivers/usb/misc/Kconfig~usb-qti-directemp-usb-thermometer-hygrometer-driver-support
+++ a/drivers/usb/misc/Kconfig
@@ -124,6 +124,16 @@ config USB_CYTHERM
 	  To compile this driver as a module, choose M here: the
 	  module will be called cytherm.
 
+config USB_DIRECTEMP
+	tristate "QTI DirecTEMP USB thermometer/hygrometer driver support"
+	depends on USB
+	help
+	  Say Y here if you want to connect a QTI DirecTEMP USB
+	  thermometer/hygrometer device to your computer's USB port.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called directemp.
+
 config USB_IDMOUSE
 	tristate "Siemens ID USB Mouse Fingerprint sensor support"
 	depends on USB
@@ -244,4 +254,3 @@ config USB_VST
 	  To compile this driver as a module, choose M here: the
 	  module will be called vstusb.
 
-
diff -puN drivers/usb/misc/Makefile~usb-qti-directemp-usb-thermometer-hygrometer-driver-support drivers/usb/misc/Makefile
--- a/drivers/usb/misc/Makefile~usb-qti-directemp-usb-thermometer-hygrometer-driver-support
+++ a/drivers/usb/misc/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_USB_ADUTUX)	+= adutux.o
 obj-$(CONFIG_USB_APPLEDISPLAY)	+= appledisplay.o
 obj-$(CONFIG_USB_CYPRESS_CY7C63)+= cypress_cy7c63.o
 obj-$(CONFIG_USB_CYTHERM)	+= cytherm.o
+obj-$(CONFIG_USB_DIRECTEMP)	+= directemp.o
 obj-$(CONFIG_USB_EMI26)		+= emi26.o
 obj-$(CONFIG_USB_EMI62)		+= emi62.o
 obj-$(CONFIG_USB_FTDI_ELAN)	+= ftdi-elan.o
diff -puN /dev/null drivers/usb/misc/directemp.c
--- /dev/null
+++ a/drivers/usb/misc/directemp.c
@@ -0,0 +1,335 @@
+/*
+ * QTI DirecTEMP USB thermometer/hygrometer driver
+ *
+ * Copyright (c) 2010 Cyber Switching, Inc.
+ *    Chris Verges <chrisv@cyberswitching.com>
+ *
+ * Copyright (c) 2010 Quality Thermistor, Inc.
+ *
+ * Using code from:
+ *  - directemp.c
+ *      Copyright (c) 2004 Erik Rigtorp <erkki@linux.nu> <erik@rigtorp.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+
+#define QTI_VENDOR_ID		(0x1DFD)
+
+#define DIRECTEMP_STREAM_DATA	(0x31)
+#define DIRECTEMP_SINGLE_POINT	(0x32)
+#define DIRECTEMP_INFO		(0x33)
+#define DIRECTEMP_BOARD_VER	(0x42)
+#define DIRECTEMP_HUMIDITY	(0x48)
+#define DIRECTEMP_SERIAL_NUM	(0x53)
+#define DIRECTEMP_TEMPERATURE	(0x54)
+#define DIRECTEMP_FIRMWARE_REV	(0x56)
+
+#define DIRECTEMP_MSG_SIZE	(16)
+#define DIRECTEMP_TIMEOUT	(1000)
+#define DIRECTEMP_MAX_RETRIES	(3)
+
+struct usb_directemp {
+	struct usb_device	*udev;
+	struct usb_interface	*interface;
+	uint16_t		pid;
+
+	uint8_t			read_temp;
+};
+
+static int directemp_read(struct usb_device *dev, void *data, int len)
+{
+	int actual_len;
+	int err;
+
+	err = usb_interrupt_msg(dev, usb_rcvintpipe(dev, 1),
+			data, len, &actual_len,	DIRECTEMP_TIMEOUT);
+	if (err)
+		return err;
+
+	return actual_len;
+}
+
+static int directemp_write(struct usb_device *dev, void *data, int len)
+{
+	int actual_len;
+	int err;
+
+	err = usb_interrupt_msg(dev, usb_sndintpipe(dev, 2),
+			data, len, &actual_len,	DIRECTEMP_TIMEOUT);
+	if (err)
+		return err;
+
+	return actual_len;
+}
+
+static ssize_t show_helper(struct device *dev,
+				struct device_attribute *attr,
+				char *tx, char *rx, int len)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_directemp *directemp = usb_get_intfdata(intf);
+	int err;
+
+	/* Send the command request */
+	dev_dbg(dev, "sending command\n");
+	err = directemp_write(directemp->udev, tx, DIRECTEMP_MSG_SIZE);
+	if (err < 0) {
+		dev_err(dev, "error %d during communication\n", err);
+		return err;
+	} else {
+		dev_dbg(dev, "transferred %d bytes\n", err);
+	}
+
+	/* Read the response */
+	memset(rx, 0, DIRECTEMP_MSG_SIZE * sizeof(char));
+	dev_dbg(dev, "reading response\n");
+	err = directemp_read(directemp->udev, rx, DIRECTEMP_MSG_SIZE);
+	if (err < 0) {
+		dev_err(dev, "error %d during communication\n", err);
+		return err;
+	} else {
+		dev_dbg(dev, "transferred %d bytes\n", err);
+	}
+
+	return err;
+}
+
+static ssize_t show_temp(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct usb_directemp *directemp = usb_get_intfdata(intf);
+	char data[DIRECTEMP_MSG_SIZE + 1];
+	int err;
+	int i;
+
+	/* Read twice due to a buffer issue on the DirecTEMP */
+	for (i = 0; i < DIRECTEMP_MAX_RETRIES; i++) {
+		memset(data, 0, (DIRECTEMP_MSG_SIZE + 1) * sizeof(char));
+		data[0] = directemp->read_temp;
+		err = show_helper(dev, attr, data, data, DIRECTEMP_MSG_SIZE);
+		if (err < 0)
+			continue;
+		if (data[0] == directemp->read_temp)
+			break;
+	}
+
+	if (i >= DIRECTEMP_MAX_RETRIES) {
+		dev_err(dev, "exceeded maximum retry count\n");
+		return sprintf(buf, "--.- C\n");
+	}
+
+	/* Sanitize the output */
+	for (i = 1; i < DIRECTEMP_MSG_SIZE; i++)
+		if (!isdigit(data[i]) && data[i] != '.') {
+			data[i] = '\0';
+			break;
+		}
+
+	/* Convert for the user */
+	err = snprintf(buf, DIRECTEMP_MSG_SIZE, "%s C\n", &data[1]);
+	if (err < 0) {
+		dev_err(dev, "unable to convert received output");
+		err = 0;
+	}
+
+	return err;
+}
+
+static DEVICE_ATTR(temp, S_IRUGO, show_temp, NULL);
+
+static ssize_t show_rh(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	char data[DIRECTEMP_MSG_SIZE + 1];
+	int err;
+	int i;
+
+	/* Read twice due to a buffer issue on the DirecTEMP */
+	for (i = 0; i < DIRECTEMP_MAX_RETRIES; i++) {
+		memset(data, 0, (DIRECTEMP_MSG_SIZE + 1) * sizeof(char));
+		data[0] = DIRECTEMP_HUMIDITY;
+		err = show_helper(dev, attr, data, data, DIRECTEMP_MSG_SIZE);
+		if (err < 0)
+			continue;
+		if (data[0] == DIRECTEMP_HUMIDITY)
+			break;
+	}
+
+	if (i >= DIRECTEMP_MAX_RETRIES) {
+		dev_err(dev, "exceeded maximum retry count\n");
+		return sprintf(buf, "--.-%%\n");
+	}
+
+	/* Sanitize the output */
+	for (i = 1; i < DIRECTEMP_MSG_SIZE; i++)
+		if (!isdigit(data[i]) && data[i] != '.') {
+			data[i] = '\0';
+			break;
+		}
+
+	/* Convert for the user */
+	err = snprintf(buf, DIRECTEMP_MSG_SIZE, "%s%%\n", &data[1]);
+	if (err < 0) {
+		dev_err(dev, "unable to convert received output");
+		err = 0;
+	}
+
+	return err;
+}
+
+static DEVICE_ATTR(rh, S_IRUGO, show_rh, NULL);
+
+static ssize_t set_raw(struct device *dev, struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	char data[DIRECTEMP_MSG_SIZE + 1];
+	int err;
+	int i;
+
+	if (count > DIRECTEMP_MSG_SIZE)
+		count = DIRECTEMP_MSG_SIZE;
+
+	memset(data, 0, (DIRECTEMP_MSG_SIZE + 1) * sizeof(char));
+	memcpy(data, buf, count);
+
+	printk("Request:\n");
+	for (i = 0; i < DIRECTEMP_MSG_SIZE; i++)
+		printk("  [%02x] 0x%02X %2u %c\n", i,
+				data[i], data[i], data[i]);
+
+	err = show_helper(dev, attr, data, data, DIRECTEMP_MSG_SIZE);
+	if (err < 0)
+		return 0;
+
+	printk("Response:\n");
+	for (i = 0; i < DIRECTEMP_MSG_SIZE; i++)
+		printk("  [%02x] 0x%02X %2u %c\n", i,
+				data[i], data[i], data[i]);
+
+	return 0;
+}
+
+static DEVICE_ATTR(raw, S_IWUGO, NULL, set_raw);
+
+static int directemp_probe(struct usb_interface *interface,
+			 const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(interface);
+	struct usb_directemp *dev;
+	int err;
+
+	dev = kzalloc(sizeof(struct usb_directemp), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->udev = usb_get_dev(udev);
+	usb_set_intfdata(interface, dev);
+	dev->pid = id->idProduct;
+
+	dev_dbg(&interface->dev, "Product:       %s (ID 0x%04X)\n",
+			udev->product, dev->pid);
+	dev_dbg(&interface->dev, "Manufacturer:  %s\n",
+			udev->manufacturer);
+	dev_dbg(&interface->dev, "Serial Number: %s\n",
+			udev->serial);
+
+	/* raw access to USB protocol via sysfs -- debugging only! */
+	err = device_create_file(&interface->dev, &dev_attr_raw);
+	if (err)
+		goto exit_free_sysfs;
+
+	/* sysfs temperature & humidity value */
+	err = device_create_file(&interface->dev, &dev_attr_temp);
+	if (err)
+		goto exit_free_sysfs;
+
+	switch (dev->pid) {
+	case 0x0002:
+		dev->read_temp = '2';
+		break;
+	case 0x0006:
+		dev->read_temp = 'T';
+		err = device_create_file(&interface->dev, &dev_attr_rh);
+		if (err)
+			goto exit_free_sysfs;
+		break;
+	}
+
+	dev_info(&interface->dev, "DirecTEMP USB now attached\n");
+	return 0;
+
+exit_free_sysfs:
+	dev_err(&interface->dev, "error while initializing driver\n");
+	device_remove_file(&interface->dev, &dev_attr_temp);
+	device_remove_file(&interface->dev, &dev_attr_rh);
+	usb_set_intfdata(interface, NULL);
+	usb_put_dev(dev->udev);
+	kfree(dev);
+	return err;
+}
+
+static void directemp_disconnect(struct usb_interface *interface)
+{
+	struct usb_directemp *dev = usb_get_intfdata(interface);
+
+	device_remove_file(&interface->dev, &dev_attr_temp);
+	device_remove_file(&interface->dev, &dev_attr_rh);
+
+	/* first remove the files, then NULL the pointer */
+	usb_set_intfdata(interface, NULL);
+	usb_put_dev(dev->udev);
+
+	kfree(dev);
+
+	dev_info(&interface->dev, "disconnected\n");
+}
+
+static struct usb_device_id id_table[] = {
+	{ USB_DEVICE(QTI_VENDOR_ID, 0x0002) }, /* Thermometer only */
+	{ USB_DEVICE(QTI_VENDOR_ID, 0x0006) }, /* Thermo- and Hygrometer */
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, id_table);
+
+static struct usb_driver directemp_driver = {
+	.name		= "directemp",
+	.probe		= directemp_probe,
+	.disconnect	= directemp_disconnect,
+	.id_table	= id_table,
+};
+
+static int __init usb_directemp_init(void)
+{
+	int result;
+
+	result = usb_register(&directemp_driver);
+	if (result) {
+		printk(KERN_ERR KBUILD_MODNAME ": usb_register failed! "
+				"Error number: %d\n", result);
+		return result;
+	}
+
+	return 0;
+}
+
+static void __exit usb_directemp_exit(void)
+{
+	usb_deregister(&directemp_driver);
+}
+
+module_init(usb_directemp_init);
+module_exit(usb_directemp_exit);
+
+MODULE_AUTHOR("Chris Verges <chrisv@cyberswitching.com>");
+MODULE_DESCRIPTION("QTI DirecTEMP USB thermometer/hygrometer driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from chrisv@cyberswitching.com are

usb-qti-directemp-usb-thermometer-hygrometer-driver-support.patch
usb-qti-directemp-usb-thermometer-hygrometer-driver-support-fix.patch
rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch

