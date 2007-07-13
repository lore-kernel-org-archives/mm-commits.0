From: akpm@linux-foundation.org
Subject: - touchscreen-fujitsu-touchscreen-driver.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:32:34 -0700
Message-ID: <200707132232.l6DMWYCd025016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34003 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758348AbXGMWdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:33:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     touchscreen: Fujitsu touchscreen driver
has been removed from the -mm tree.  Its filename was
     touchscreen-fujitsu-touchscreen-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: touchscreen: Fujitsu touchscreen driver
From: Stephen Hemminger <shemminger@linux-foundation.org>

Dmitry wrote this, I just cleaned it up and tried on a B6210 laptop. 
Serial touchscreen are found on some Fujitsu lifebook P-series laptops, and
the B6210.  The data stream looks correct but there appear to be
calibration issues with both mouse emulation and the evtouch driver.

Using this requires a new version of inputattach and doing
 inputattach -fjt /dev/ttyS0

It should be possible to automatically do this with udev rules.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/Kconfig      |   13 +
 drivers/input/touchscreen/Makefile     |    1 
 drivers/input/touchscreen/fujitsu_ts.c |  195 +++++++++++++++++++++++
 include/linux/serio.h                  |    1 
 4 files changed, 210 insertions(+)

diff -puN drivers/input/touchscreen/Kconfig~touchscreen-fujitsu-touchscreen-driver drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig~touchscreen-fujitsu-touchscreen-driver
+++ a/drivers/input/touchscreen/Kconfig
@@ -54,6 +54,19 @@ config TOUCHSCREEN_CORGI
 	  To compile this driver as a module, choose M here: the
 	  module will be called corgi_ts.
 
+config TOUCHSCREEN_FUJITSU
+	tristate "Fujitsu serial touchscreen"
+	select SERIO
+	help
+	  Say Y here if you have the Fujitsu touchscreen (such as one
+	  installed in Lifebook P series laptop) connected to your
+	  system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called fujitsu-ts.
+
 config TOUCHSCREEN_GUNZE
 	tristate "Gunze AHL-51S touchscreen"
 	select SERIO
diff -puN drivers/input/touchscreen/Makefile~touchscreen-fujitsu-touchscreen-driver drivers/input/touchscreen/Makefile
--- a/drivers/input/touchscreen/Makefile~touchscreen-fujitsu-touchscreen-driver
+++ a/drivers/input/touchscreen/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h360
 obj-$(CONFIG_TOUCHSCREEN_CORGI)		+= corgi_ts.o
 obj-$(CONFIG_TOUCHSCREEN_GUNZE)		+= gunze.o
 obj-$(CONFIG_TOUCHSCREEN_ELO)		+= elo.o
+obj-$(CONFIG_TOUCHSCREEN_FUJITSU)	+= fujitsu_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MTOUCH)	+= mtouch.o
 obj-$(CONFIG_TOUCHSCREEN_MK712)		+= mk712.o
 obj-$(CONFIG_TOUCHSCREEN_HP600)		+= hp680_ts_input.o
diff -puN /dev/null drivers/input/touchscreen/fujitsu_ts.c
--- /dev/null
+++ a/drivers/input/touchscreen/fujitsu_ts.c
@@ -0,0 +1,195 @@
+/*
+ * Fujitsu serial touchscreen driver
+ *
+ * Copyright (c) Dmitry Torokhov <dtor@mail.ru>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/serio.h>
+#include <linux/init.h>
+
+#define DRIVER_DESC	"Fujitsu serial touchscreen driver"
+
+MODULE_AUTHOR("Dmitry Torokhov <dtor@mail.ru>");
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
+
+#define FUJITSU_LENGTH 5
+
+#define X_AXIS_MIN	90
+#define X_AXIS_MAX	4000
+#define Y_AXIS_MIN	185
+#define Y_AXIS_MAX	4000
+
+/*
+ * Per-touchscreen data.
+ */
+
+struct fujitsu {
+	struct input_dev *dev;
+	struct serio *serio;
+	int idx;
+	unsigned char data[FUJITSU_LENGTH];
+	char phys[32];
+};
+
+/*
+ * Decode serial data
+ */
+
+static irqreturn_t fujitsu_interrupt(struct serio *serio,
+				     unsigned char data, unsigned int flags)
+{
+	struct fujitsu *fujitsu = serio_get_drvdata(serio);
+	struct input_dev *dev = fujitsu->dev;
+
+	if (fujitsu->idx == 0) {
+		/* resync skip until start of frame */
+		if (!(data & 0x80))
+			return IRQ_HANDLED;
+	} else {
+		/* resync skip garbage */
+		if (data & 0x80) {
+			fujitsu->idx = 0;
+			return IRQ_HANDLED;
+		}
+	}
+
+	fujitsu->data[fujitsu->idx++] = data;
+	if (fujitsu->idx == FUJITSU_LENGTH) {
+		input_report_abs(dev, ABS_X,
+				 (fujitsu->data[2] << 7) | fujitsu->data[1]);
+		input_report_abs(dev, ABS_Y,
+				 (fujitsu->data[4] << 7) | fujitsu->data[3]);
+		input_report_key(dev, BTN_TOUCH,
+				 (fujitsu->data[0] & 0x03) != 2);
+		input_sync(dev);
+		fujitsu->idx = 0;
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * fujitsu_disconnect() is the opposite of fujitsu_connect()
+ */
+
+static void fujitsu_disconnect(struct serio *serio)
+{
+	struct fujitsu *fujitsu = serio_get_drvdata(serio);
+
+	input_get_device(fujitsu->dev);
+	input_unregister_device(fujitsu->dev);
+	serio_close(serio);
+	serio_set_drvdata(serio, NULL);
+	input_put_device(fujitsu->dev);
+	kfree(fujitsu);
+}
+
+/*
+ * fujitsu_connect() is the routine that is called when someone adds a
+ * new serio device that supports the Fujitsu protocol and registers it
+ * as input device.
+ */
+
+static int fujitsu_connect(struct serio *serio, struct serio_driver *drv)
+{
+	struct fujitsu *fujitsu;
+	struct input_dev *input_dev;
+	int err;
+
+	fujitsu = kzalloc(sizeof(struct fujitsu), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!fujitsu || !input_dev) {
+		err = -ENOMEM;
+		goto fail1;
+	}
+
+	fujitsu->serio = serio;
+	fujitsu->dev = input_dev;
+	snprintf(fujitsu->phys, sizeof(fujitsu->phys),
+		 "%s/input0", serio->phys);
+
+	input_dev->name = "Fujitsu Serial Touchscreen";
+	input_dev->phys = fujitsu->phys;
+	input_dev->id.bustype = BUS_RS232;
+	input_dev->id.vendor = SERIO_FUJITSU;
+	input_dev->id.product = 0;
+	input_dev->id.version = 0x0100;
+	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+	input_dev->keybit[LONG(BTN_TOUCH)] = BIT(BTN_TOUCH);
+
+	input_set_abs_params(input_dev, ABS_X, X_AXIS_MIN, X_AXIS_MAX, 0, 0);
+	input_set_abs_params(input_dev, ABS_Y, Y_AXIS_MIN, Y_AXIS_MAX, 0, 0);
+	serio_set_drvdata(serio, fujitsu);
+
+	err = serio_open(serio, drv);
+	if (err)
+		goto fail2;
+
+	err = input_register_device(fujitsu->dev);
+	if (err)
+		goto fail3;
+
+	return 0;
+
+ fail3:	serio_close(serio);
+ fail2:	serio_set_drvdata(serio, NULL);
+ fail1:	input_free_device(input_dev);
+	kfree(fujitsu);
+	return err;
+}
+
+/*
+ * The serio driver structure.
+ */
+
+static struct serio_device_id fujitsu_serio_ids[] = {
+	{
+		.type	= SERIO_RS232,
+		.proto	= SERIO_FUJITSU,
+		.id	= SERIO_ANY,
+		.extra	= SERIO_ANY,
+	},
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(serio, fujitsu_serio_ids);
+
+static struct serio_driver fujitsu_drv = {
+	.driver		= {
+		.name	= "fujitsu_ts",
+	},
+	.description	= DRIVER_DESC,
+	.id_table	= fujitsu_serio_ids,
+	.interrupt	= fujitsu_interrupt,
+	.connect	= fujitsu_connect,
+	.disconnect	= fujitsu_disconnect,
+};
+
+/*
+ * The functions for inserting/removing us as a module.
+ */
+
+static int __init fujitsu_init(void)
+{
+	return serio_register_driver(&fujitsu_drv);
+}
+
+static void __exit fujitsu_exit(void)
+{
+	serio_unregister_driver(&fujitsu_drv);
+}
+
+module_init(fujitsu_init);
+module_exit(fujitsu_exit);
diff -puN include/linux/serio.h~touchscreen-fujitsu-touchscreen-driver include/linux/serio.h
--- a/include/linux/serio.h~touchscreen-fujitsu-touchscreen-driver
+++ a/include/linux/serio.h
@@ -209,6 +209,7 @@ static inline void serio_unpin_driver(st
 #define SERIO_PENMOUNT	0x31
 #define SERIO_TOUCHRIGHT	0x32
 #define SERIO_TOUCHWIN	0x33
+#define SERIO_FUJITSU	0x34
 #define SERIO_TAOSEVM	0x40
 
 #endif
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
git-acpi.patch
git-input.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
