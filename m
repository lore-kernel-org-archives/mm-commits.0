From: akpm@linux-foundation.org
Subject: - maple-add-driver-for-sega-dreamcast-controller.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:39:48 -0700
Message-ID: <200804261639.m3QGdmwx030956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412AbYDZQkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian@newgolddream.dyndns.info, adrian@mcmen.demon.co.uk, dtor@mail.ru, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     maple: add driver for Sega Dreamcast controller
has been removed from the -mm tree.  Its filename was
     maple-add-driver-for-sega-dreamcast-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: maple: add driver for Sega Dreamcast controller
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>

Add support for the SEGA Dreamcast controller as a joystick device.  Based on
Yaegashi Takeshi's old 2.4 driver (never in mainline) with the addition of
functioning removal (and reinsertion) code.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/Kconfig        |   13 +
 drivers/input/joystick/Makefile       |    1 
 drivers/input/joystick/maplecontrol.c |  223 ++++++++++++++++++++++++
 3 files changed, 237 insertions(+)

diff -puN drivers/input/joystick/Kconfig~maple-add-driver-for-sega-dreamcast-controller drivers/input/joystick/Kconfig
--- a/drivers/input/joystick/Kconfig~maple-add-driver-for-sega-dreamcast-controller
+++ a/drivers/input/joystick/Kconfig
@@ -282,4 +282,17 @@ config JOYSTICK_XPAD_LEDS
 	  This option enables support for the LED which surrounds the Big X on
 	  XBox 360 controller.
 
+config JOYSTICK_MAPLE
+	tristate "Dreamcast control pad"
+	depends on SH_DREAMCAST
+	select MAPLE
+	help
+	  Say Y here if you have a SEGA Dreamcast and want to use your
+	  controller.
+
+	  Most Dreamcast users will say Y.
+
+	  To compile this as a module choose M here: the
+	  module will be called maplecontrol.
+
 endif
diff -puN drivers/input/joystick/Makefile~maple-add-driver-for-sega-dreamcast-controller drivers/input/joystick/Makefile
--- a/drivers/input/joystick/Makefile~maple-add-driver-for-sega-dreamcast-controller
+++ a/drivers/input/joystick/Makefile
@@ -27,5 +27,6 @@ obj-$(CONFIG_JOYSTICK_TURBOGRAFX)	+= tur
 obj-$(CONFIG_JOYSTICK_TWIDJOY)		+= twidjoy.o
 obj-$(CONFIG_JOYSTICK_WARRIOR)		+= warrior.o
 obj-$(CONFIG_JOYSTICK_XPAD)		+= xpad.o
+obj-$(CONFIG_JOYSTICK_MAPLE)		+= maplecontrol.o
 
 obj-$(CONFIG_JOYSTICK_IFORCE)		+= iforce/
diff -puN /dev/null drivers/input/joystick/maplecontrol.c
--- /dev/null
+++ a/drivers/input/joystick/maplecontrol.c
@@ -0,0 +1,223 @@
+/*
+ * 	SEGA Dreamcast controller driver
+ *	Based on drivers/usb/iforce.c
+ *
+ * 	Copyright Yaegashi Takeshi, 2001
+ *	Porting to 2.6 by Adrian McMenamin, copyright 2008
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/maple.h>
+#include <asm/mach/maple.h>
+
+MODULE_AUTHOR("YAEGASHI Takeshi <t@keshi.org>");
+MODULE_DESCRIPTION("SEGA Dreamcast controller driver");
+MODULE_LICENSE("GPL");
+
+struct dc_pad {
+	struct input_dev *dev;
+	struct maple_device *mdev;
+	int open;
+};
+
+static void dc_pad_callback(struct mapleq *mq)
+{
+	unsigned short buttons;
+	struct maple_device *mapledev = mq->dev;
+	struct dc_pad *pad = mapledev->private_data;
+	struct input_dev *dev = pad->dev;
+	unsigned char *res = mq->recvbuf;
+
+	buttons = ~cpu_to_le16(*(unsigned short *)(res + 8));
+
+	input_report_abs(dev, ABS_HAT0Y,
+			 (buttons & 0x0010 ? -1:0) + (buttons & 0x0020 ? 1:0));
+	input_report_abs(dev, ABS_HAT0X,
+			 (buttons & 0x0040 ? -1:0) + (buttons & 0x0080 ? 1:0));
+	input_report_abs(dev, ABS_HAT1Y,
+			 (buttons & 0x1000 ? -1:0) + (buttons & 0x2000 ? 1:0));
+	input_report_abs(dev, ABS_HAT1X,
+			 (buttons & 0x4000 ? -1:0) + (buttons & 0x8000 ? 1:0));
+
+	input_report_key(dev, BTN_C,      buttons & 0x0001);
+	input_report_key(dev, BTN_B,      buttons & 0x0002);
+	input_report_key(dev, BTN_A,      buttons & 0x0004);
+	input_report_key(dev, BTN_START,  buttons & 0x0008);
+	input_report_key(dev, BTN_Z,      buttons & 0x0100);
+	input_report_key(dev, BTN_Y,      buttons & 0x0200);
+	input_report_key(dev, BTN_X,      buttons & 0x0400);
+	input_report_key(dev, BTN_SELECT, buttons & 0x0800);
+
+	input_report_abs(dev, ABS_GAS,   res[10]);
+	input_report_abs(dev, ABS_BRAKE, res[11]);
+	input_report_abs(dev, ABS_X,     res[12]);
+	input_report_abs(dev, ABS_Y,     res[13]);
+	input_report_abs(dev, ABS_RX,    res[14]);
+	input_report_abs(dev, ABS_RY,    res[15]);
+}
+
+static int dc_pad_connect(struct maple_device *mdev)
+{
+	int i, error;
+	unsigned long data = be32_to_cpu(mdev->devinfo.function_data[0]);
+	struct dc_pad *pad;
+	struct input_dev *dev;
+
+	const short btn_bit[32] = {
+		BTN_C, BTN_B, BTN_A, BTN_START, -1, -1, -1, -1,
+		BTN_Z, BTN_Y, BTN_X, BTN_SELECT, -1, -1, -1, -1,
+		-1, -1, -1, -1, -1, -1, -1, -1,
+		-1, -1, -1, -1, -1, -1, -1, -1,
+	};
+
+	const short abs_bit[32] = {
+		-1, -1, -1, -1, ABS_HAT0Y, ABS_HAT0Y, ABS_HAT0X, ABS_HAT0X,
+		-1, -1, -1, -1, ABS_HAT1Y, ABS_HAT1Y, ABS_HAT1X, ABS_HAT1X,
+		ABS_GAS, ABS_BRAKE, ABS_X, ABS_Y, ABS_RX, ABS_RY, -1, -1,
+		-1, -1, -1, -1, -1, -1, -1, -1,
+	};
+
+	pad = kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
+	if (!pad) {
+		error = ENOMEM;
+		goto fail_nomem_1;
+	}
+
+	dev = input_allocate_device();
+	if (!dev) {
+		error = ENOMEM;
+		goto fail_nomem_2;
+	}
+
+	pad->dev = dev;
+	pad->mdev = mdev;
+	mdev->private_data = pad;
+
+	for (i = 0; i < 32; i++)
+		if (data & (1<<i) && btn_bit[i] >= 0)
+			pad->dev->keybit[BIT_WORD(BTN_JOYSTICK)] |=
+					BIT_MASK(btn_bit[i]);
+
+	if (pad->dev->keybit[BTN_JOYSTICK/32])
+		pad->dev->evbit[0] |= BIT_MASK(EV_KEY);
+
+	for (i = 0; i < 32; i++)
+		if (data & (1<<i) && abs_bit[i] >= 0)
+			pad->dev->absbit[0] |= BIT_MASK(abs_bit[i]);
+
+	if (pad->dev->absbit[0])
+		pad->dev->evbit[0] |= BIT_MASK(EV_ABS);
+
+	for (i = ABS_X; i <= ABS_BRAKE; i++) {
+		pad->dev->absmax[i] = 255;
+		pad->dev->absmin[i] = 0;
+		pad->dev->absfuzz[i] = 0;
+		pad->dev->absflat[i] = 0;
+	}
+
+	for (i = ABS_HAT0X; i <= ABS_HAT3Y; i++) {
+		pad->dev->absmax[i] = 1;
+		pad->dev->absmin[i] = -1;
+		pad->dev->absfuzz[i] = 0;
+		pad->dev->absflat[i] = 0;
+	}
+
+	pad->dev->private = pad;
+	pad->dev->event = NULL;
+	pad->dev->dev.parent = &mdev->dev;
+	pad->dev->name = mdev->product_name;
+	pad->dev->id.bustype = BUS_HOST;
+	input_set_drvdata(dev, pad);
+
+	error = input_register_device(pad->dev);
+	if (error)
+		goto fail_register;
+
+	maple_getcond_callback(mdev, dc_pad_callback, HZ/10,
+		MAPLE_FUNC_CONTROLLER);
+
+	return error;
+
+fail_register:
+	input_free_device(pad->dev);
+fail_nomem_2:
+	kfree(pad);
+fail_nomem_1:
+	return -error;
+}
+
+static void dc_pad_disconnect(struct maple_device *mdev)
+{
+	struct dc_pad *pad = mdev->private_data;
+
+	mdev->callback = NULL;
+	input_unregister_device(pad->dev);
+	kfree(pad);
+}
+
+/* allow the controller to be used */
+static int probe_maple_controller(struct device *dev)
+{
+	struct maple_device *mdev = to_maple_dev(dev);
+	struct maple_driver *mdrv = to_maple_driver(dev->driver);
+	int error;
+
+	error = dc_pad_connect(mdev);
+	if (error)
+		return error;
+
+	mdev->driver = mdrv;
+
+	return 0;
+}
+
+static int remove_maple_controller(struct device *dev)
+{
+	struct maple_device *mdev = to_maple_dev(dev);
+
+	dc_pad_disconnect(mdev);
+	return 0;
+}
+
+static struct maple_driver dc_pad_driver = {
+	.function =	MAPLE_FUNC_CONTROLLER,
+	.connect =	dc_pad_connect,
+	.disconnect =	dc_pad_disconnect,
+	.drv = {
+		.name = "Dreamcast_controller",
+		.probe = probe_maple_controller,
+		.remove = remove_maple_controller,
+	},
+};
+
+static int unplug_maple_control(struct device *dev, void *ignored)
+{
+	/* Please DO NOT really unplug your controller */
+	struct maple_device *mdev;
+
+	mdev = to_maple_dev(dev);
+	if ((mdev->function & MAPLE_FUNC_CONTROLLER)
+		&& (mdev->driver == &dc_pad_driver))
+		remove_maple_controller(dev);
+
+	return 0;
+}
+
+static int __init dc_pad_init(void)
+{
+	return 	maple_driver_register(&dc_pad_driver.drv);
+}
+
+static void __exit dc_pad_exit(void)
+{
+	bus_for_each_dev(&maple_bus_type, NULL, NULL, unplug_maple_control);
+	driver_unregister(&dc_pad_driver.drv);
+}
+
+module_init(dc_pad_init);
+module_exit(dc_pad_exit);
_

Patches currently in -mm which might be from adrian@newgolddream.dyndns.info are

maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch

