From: akpm@linux-foundation.org
Subject: - v4l-stk11xx-add-a-new-webcam-driver.patch removed from -mm tree
Date: Tue, 06 Nov 2007 00:37:23 -0800
Message-ID: <200711060844.lA68iBHD014980@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35179 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbXKFIoV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 03:44:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     V4L: stk11xx, add a new webcam driver
has been removed from the -mm tree.  Its filename was
     v4l-stk11xx-add-a-new-webcam-driver.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: V4L: stk11xx, add a new webcam driver
From: Jiri Slaby <jirislaby@gmail.com>

Adds support for stk1125, stk1135 and stkdcnew webcam built-in some
notebooks.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                        |    5 
 drivers/media/video/Kconfig        |    9 
 drivers/media/video/Makefile       |    5 
 drivers/media/video/stk1125.c      |  667 ++++++++++++++++++
 drivers/media/video/stk1135.c      |  549 +++++++++++++++
 drivers/media/video/stk11xx-core.c |  962 +++++++++++++++++++++++++++
 drivers/media/video/stk11xx-v4l.c  |  790 ++++++++++++++++++++++
 drivers/media/video/stk11xx.h      |  217 ++++++
 drivers/media/video/stkdcnew.c     |  669 ++++++++++++++++++
 9 files changed, 3873 insertions(+)

diff -puN MAINTAINERS~v4l-stk11xx-add-a-new-webcam-driver MAINTAINERS
--- a/MAINTAINERS~v4l-stk11xx-add-a-new-webcam-driver
+++ a/MAINTAINERS
@@ -3526,6 +3526,11 @@ M:	chrisw@sous-sol.org
 L:	stable@kernel.org
 S:	Maintained
 
+STK11XX WEBCAM DRIVER
+P:	Jiri Slaby
+M:	jirislaby@gmail.com
+S:	Maintained
+
 TPM DEVICE DRIVER
 P:	Kylene Hall
 M:	tpmdd-devel@lists.sourceforge.net
diff -puN drivers/media/video/Kconfig~v4l-stk11xx-add-a-new-webcam-driver drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig~v4l-stk11xx-add-a-new-webcam-driver
+++ a/drivers/media/video/Kconfig
@@ -802,6 +802,15 @@ config USB_ZR364XX
 	  To compile this driver as a module, choose M here: the
 	  module will be called zr364xx.
 
+config USB_STK11XX
+	tristate "Syntek chip based webcams"
+	depends on VIDEO_V4L2
+	---help---
+	  This will add support for Syntek webcams such as dc1125, stk1135 and
+	  DC NEW. Some notebooks have these cards built-in in their displays.
+
+	  If you choose to build this as module, it will be called stk11xx.
+
 endif # V4L_USB_DRIVERS
 
 endif # VIDEO_CAPTURE_DRIVERS
diff -puN drivers/media/video/Makefile~v4l-stk11xx-add-a-new-webcam-driver drivers/media/video/Makefile
--- a/drivers/media/video/Makefile~v4l-stk11xx-add-a-new-webcam-driver
+++ a/drivers/media/video/Makefile
@@ -6,6 +6,9 @@ zr36067-objs	:=	zoran_procfs.o zoran_dev
 			zoran_driver.o zoran_card.o
 tuner-objs	:=	tuner-core.o tuner-types.o
 
+stk11xx-objs	:=	stk11xx-core.o stk11xx-v4l.o stk1125.o stk1135.o \
+			stkdcnew.o
+
 msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
 
 obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-common.o compat_ioctl32.o \
@@ -115,6 +118,8 @@ obj-$(CONFIG_USB_STV680)        += stv68
 obj-$(CONFIG_USB_W9968CF)       += w9968cf.o
 obj-$(CONFIG_USB_ZR364XX)       += zr364xx.o
 
+obj-$(CONFIG_USB_STK11XX)	+= stk11xx.o
+
 obj-$(CONFIG_USB_SN9C102)       += sn9c102/
 obj-$(CONFIG_USB_ET61X251)      += et61x251/
 obj-$(CONFIG_USB_PWC)           += pwc/
diff -puN /dev/null drivers/media/video/stk1125.c
--- /dev/null
+++ a/drivers/media/video/stk1125.c
@@ -0,0 +1,667 @@
+/*
+ * STK-1125 part
+ *
+ * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
+ *
+ * Based on Nicolas VIVIEN's driver
+ *
+ * Licences
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/usb.h>
+#include <linux/types.h>
+
+#include "stk11xx.h"
+
+static int stk1125_load_microcode(struct stk11xx *dev)
+{
+	unsigned int i;
+	const u8 *values_204, *values_205;
+	int retok;
+
+	/* From 80x60 to 640x480 */
+	const u8 values_1_204[] = {
+		0x12, 0x11, 0x3b, 0x6a, 0x13, 0x10, 0x00, 0x01, 0x02, 0x13,
+		0x39, 0x38, 0x37, 0x35, 0x0e, 0x12, 0x04, 0x0c, 0x0d, 0x17,
+		0x18, 0x32, 0x19, 0x1a, 0x03, 0x1b, 0x16, 0x33, 0x34, 0x41,
+		0x96, 0x3d, 0x69, 0x3a, 0x8e, 0x3c, 0x8f, 0x8b, 0x8c, 0x94,
+		0x95, 0x40, 0x29, 0x0f, 0xa5, 0x1e, 0xa9, 0xaa, 0xab, 0x90,
+		0x91, 0x9f, 0xa0, 0x24, 0x25, 0x26, 0x14, 0x2a, 0x2b
+	};
+	const u8 values_1_205[] = {
+		0x45, 0x80, 0x01, 0x7d, 0x80, 0x00, 0x00, 0x80, 0x80, 0x80,
+		0x50, 0x93, 0x00, 0x81, 0x20, 0x45, 0x00, 0x00, 0x00, 0x24,
+		0xc4, 0xb6, 0x00, 0x3c, 0x36, 0x00, 0x07, 0xe2, 0xbf, 0x00,
+		0x04, 0x19, 0x40, 0x0d, 0x00, 0x73, 0xdf, 0x06, 0x20, 0x88,
+		0x88, 0xc1, 0x3f, 0x42, 0x80, 0x04, 0xb8, 0x92, 0x0a, 0x00,
+		0x00, 0x00, 0x00, 0x68, 0x5c, 0xc3, 0x2e, 0x00, 0x00
+	};
+
+	/* From 800x600 to 1280x1024 */
+	const u8 values_2_204[] = {
+		0x12, 0x11, 0x3b, 0x6a, 0x13, 0x10, 0x00, 0x01, 0x02, 0x13,
+		0x39, 0x38, 0x37, 0x35, 0x0e, 0x12, 0x04, 0x0c, 0x0d, 0x17,
+		0x18, 0x32, 0x19, 0x1a, 0x03, 0x1b, 0x16, 0x33, 0x34, 0x41,
+		0x96, 0x3d, 0x69, 0x3a, 0x8e, 0x3c, 0x8f, 0x8b, 0x8c, 0x94,
+		0x95, 0x40, 0x29, 0x0f, 0xa5, 0x1e, 0xa9, 0xaa, 0xab, 0x90,
+		0x91, 0x9f, 0xa0, 0x24, 0x25, 0x26, 0x14, 0x2a, 0x2b
+	};
+	const u8 values_2_205[] = {
+		0x05, 0x80, 0x01, 0x7d, 0x80, 0x00, 0x00, 0x80, 0x80, 0x80,
+		0x50, 0x93, 0x00, 0x81, 0x20, 0x05, 0x00, 0x00, 0x00, 0x1b,
+		0xbb, 0xa4, 0x01, 0x81, 0x12, 0x00, 0x07, 0xe2, 0xbf, 0x00,
+		0x04, 0x19, 0x40, 0x0d, 0x00, 0x73, 0xdf, 0x06, 0x20, 0x88,
+		0x88, 0xc1, 0x3f, 0x42, 0x80, 0x04, 0xb8, 0x92, 0x0a, 0x00,
+		0x00, 0x00, 0x00, 0x68, 0x5c, 0xc3, 0x2e, 0x00, 0x00
+	};
+
+	/* From the resolution */
+	switch (dev->resolution) {
+	case STK11XX_1280x1024:
+	case STK11XX_1024x768:
+	case STK11XX_800x600:
+		values_204 = values_2_204;
+		values_205 = values_2_205;
+		break;
+
+	case STK11XX_640x480:
+	case STK11XX_320x240:
+	case STK11XX_160x120:
+	case STK11XX_80x60:
+	default:
+		values_204 = values_1_204;
+		values_205 = values_1_205;
+		break;
+	}
+
+	for (i = 0; i < 59; i++) {
+		stk11xx_read_dummy(dev, 0x02ff);
+		stk11xx_write_reg(dev, 0x02ff, 0x00);
+
+		stk11xx_write_reg(dev, 0x0204, values_204[i]);
+		stk11xx_write_reg(dev, 0x0205, values_205[i]);
+		stk11xx_write_reg(dev, 0x0200, 0x01);
+
+		retok = stk11xx_check_device(dev, 500);
+		if (retok != 1) {
+			dev_err(&dev->udev->dev, "load microcode fail\n");
+			return -EIO;
+		}
+
+		stk11xx_write_reg(dev, 0x02ff, 0x00);
+	}
+
+	stk11xx_check_device(dev, 500);
+
+	return 0;
+}
+
+/*
+ * The configuration of device is composed of 11 steps.
+ * This function is called by the initialization process.
+ *
+ * We don't know the meaning of these steps! We only replay the USB log.
+ *
+ * The steps 0 to 9 are called during the initialization.
+ * Then, the driver choose the last step :
+ *   10 : for a resolution from 80x60 to 640x480
+ *   11 : for a resolution from 800x600 to 1280x1024
+ */
+static int stk1125_dev_configure(struct stk11xx *dev, unsigned int step)
+{
+	int ret;
+	/*      0,    1,    2,    3,    4,    5,    6,    7,    8,    9,
+		10,   11 */
+
+	const u8 vals_001B[] = {
+		0x0e, 0x03, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e,
+		0x0e, 0x0e
+	};
+	const u8 vals_001C[] = {
+		0x06, 0x02, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46,
+		0x46, 0x0e
+	};
+	const u8 vals_0202[] = {
+		0x1e, 0x0a, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e,
+		0x1e, 0x1e
+	};
+	const u8 vals_0110[] = {
+		0x07, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x3e, 0x00, 0x00, 0x00,
+		0x00, 0x00
+	};
+	const u8 vals_0112[] = {
+		0x07, 0x00, 0x00, 0x00, 0x00, 0x09, 0x09, 0x00, 0x00, 0x00,
+		0x00, 0x00
+	};
+	const u8 vals_0114[] = {
+		0x87, 0x80, 0x80, 0x80, 0x80, 0xbe, 0xbe, 0x80, 0x80, 0x80,
+		0x80, 0x00
+	};
+	const u8 vals_0115[] = {
+		0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+		0x02, 0x05
+	};
+	const u8 vals_0116[] = {
+		0xe7, 0xe0, 0xe0, 0xe0, 0xe0, 0xe9, 0xe9, 0xe0, 0xe0, 0xe0,
+		0xe0, 0x00
+	};
+	const u8 vals_0117[] = {
+		0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+		0x01, 0x04
+	};
+	const u8 vals_0100[] = {
+		0x20, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21,
+		0x21, 0x21
+	};
+	struct stk11xx_table table_1[] = {
+		{ 0x0000, 0x24, 2 }, { 0x0002, 0x68, 2 }, { 0x0003, 0x80, 2 },
+		{ 0x0005, 0x00, 2 }, { 0x0007, 0x03, 2 }, { 0x000d, 0x00, 2 },
+		{ 0x000f, 0x02, 2 }, { 0x0300, 0x12, 2 }, { 0x0350, 0x41, 2 },
+		{ 0x0351, 0x00, 2 }, { 0x0352, 0x00, 2 }, { 0x0353, 0x00, 2 },
+		{ 0x0018, 0x10, 2 }, { 0x0019, 0x00, 2 },
+		{ 0x001b, vals_001B[step], 2 }, { 0x001c, vals_001C[step], 2 },
+		{ 0x0300, 0x80, 2 }, { 0x001a, 0x04, 2 },
+		{ 0x0202, vals_0202[step], 2 },
+
+		{ 0x0110, vals_0110[step], 2 }, { 0x0111, 0x00, 2 },
+		{ 0x0112, vals_0112[step], 2 }, { 0x0113, 0x00, 2 },
+		{ 0x0114, vals_0114[step], 2 }, { 0x0115, vals_0115[step], 2 },
+		{ 0x0116, vals_0116[step], 2 }, { 0x0117, vals_0117[step], 2 },
+
+		{ 0x0100, 0x00, 1 },
+		{ 0x0100, vals_0100[step], 2 },
+
+		{ 0x0200, 0x80, 2 }, { 0x0200, 0x00, 2 }, { 0x02ff, 0x00, 2 },
+		{ }
+	};
+
+	dev_dbg(&dev->udev->dev, "%s: %u\n", __FUNCTION__, step);
+
+	ret = stk11xx_process_table(dev, table_1);
+	if (ret)
+		goto err;
+
+
+	switch (step) {
+	case 0: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x40, 2 }, { 0x0204, 0x41, 2 },
+			{ 0x0205, 0x01, 2 }, { 0x0204, 0x1c, 2 },
+			{ 0x0205, 0x02, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 1: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x22, 2 }, { 0x0204, 0x27, 2 },
+			{ 0x0205, 0xa5, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 2: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xbf, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 3: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x42, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x24, 2 },
+			{ 0x0205, 0xa5, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 4: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x42, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xe0, 2 }, { 0x0204, 0x24, 2 },
+			{ 0x0205, 0xa5, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 5: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xff, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 6: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xff, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 7: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xb7, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 8:
+		stk11xx_write_reg(dev, 0x0203, 0x60);
+
+		ret = stk1125_load_microcode(dev);
+
+		stk11xx_write_reg(dev, 0x0200, 0x80);
+		stk11xx_write_reg(dev, 0x0200, 0x00);
+		stk11xx_write_reg(dev, 0x02ff, 0x01);
+		stk11xx_write_reg(dev, 0x0203, 0xa0);
+
+		break;
+
+	case 9:
+		stk11xx_write_reg(dev, 0x0203, 0x60);
+
+		ret = stk1125_load_microcode(dev);
+
+		stk11xx_write_reg(dev, 0x0104, 0x00);
+		stk11xx_write_reg(dev, 0x0105, 0x00);
+		stk11xx_write_reg(dev, 0x0106, 0x00);
+
+		break;
+
+	case 10:
+	case 11: {
+		const struct stk11xx_table table[] = {
+			{ 0x0106, 0x00, 2 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0204, 0x2a, 2 },
+			{ 0x0205, 0x00, 2 }, { 0x0200, 0x01, 2 },
+			{    500, 0x00, 3 }, { 0x02ff, 0x00, 2 },
+			{ 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+			{ 0x0204, 0x2b, 2 }, { 0x0205, 0x00, 2 },
+			{ 0x0200, 0x01, 2 }, {    500, 0x00, 3 },
+			{ 0x02ff, 0x00, 2 }, { }
+		};
+
+		stk11xx_write_reg(dev, 0x0203, 0x60);
+
+		ret = stk1125_load_microcode(dev);
+		if (ret)
+			goto err;
+
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	}
+err:
+	return ret;
+}
+
+static int stk1125_cam_asleep(struct stk11xx *dev)
+{
+	const struct stk11xx_table table[] = {
+		{ 0x0104, 0x00, 1 }, { 0x0105, 0x00, 1 }, { 0x0106, 0x00, 1 },
+		{ 0x0100, 0x21, 2 }, { 0x0116, 0x00, 2 }, { 0x0117, 0x00, 2 },
+		{ 0x0018, 0x00, 2 }, { 0x0000, 0x00, 1 }, { 0x0000, 0x4c, 2 },
+		{ }
+	};
+
+	return stk11xx_process_table(dev, table);
+}
+
+static u16 stk1125_get_fps_code(unsigned int fps)
+{
+	switch (fps) {
+	case 10:
+		return 0x0004;
+	case 15:
+		return 0x0002;
+	case 20:
+		return 0x0001;
+	default:
+	case 25:
+		return 0x6400;
+	case 30:
+		return 0x0000;
+	}
+}
+
+/*
+ * This functions permits to modify the settings :
+ *   - brightness
+ *   - contrast
+ *   - white balance
+ *   - ...
+ *
+ * 0x204 = 0xa1 : unknown (by default 0x00)
+ * 0x204 = 0x10 : contrast (by default 0x7c)
+ * 0x204 = 0x04 : Mode (unknown) (by default 0x00) (=> already looked 0x01 and
+ * 		  0x02)
+ * 0x204 = 0x00 : brightness / white balance (by default 0x00)
+ * 0x204 = 0x2e : Fps MSB (by default 0x01)
+ * 0x204 = 0x2d : Fps LSB (by default 0x00)
+ *
+ * 0x2e | 0x2d | Nbr fps
+ * -----+------+--------
+ * 0x00 | 0x00 |  30
+ * 0x00 | 0x64 |  25
+ * 0x01 | 0x00 |  20
+ * 0x02 | 0x00 |  15
+ * 0x03 | 0x00 |  12
+ * 0x04 | 0x00 |  10
+ */
+static int stk1125_cam_setting(struct stk11xx *dev)
+{
+	int ret;
+	u16 fps = stk1125_get_fps_code(dev->vsettings.fps);
+
+	struct stk11xx_table table_1[] = {
+		{ 0x0200, 0x00, 2 },
+		/* Unknown register */
+		{ 0x0204, 0xa1, 2 }, { 0x0205, 0x00, 2 },
+		/* Contrast register */
+		{ 0x0204, 0x10, 2 }, { 0x0205, dev->vsettings.contrast, 2 },
+		/* Unknown register */
+		{ 0x0204, 0x04, 2 }, { 0x0205, 0x00, 2 },
+		/* Whiteness register */
+		{ 0x0204, 0x00, 2 }, { 0x0205, dev->vsettings.whiteness, 2 },
+		{ 0x0204, 0x2e, 2 }, { 0x0205, fps & 0xff, 2 },
+		{ 0x0204, 0x2d, 2 }, { 0x0205, fps >> 8, 2 },
+		{ 0x0200, 0x06, 2 }, { }
+	};
+
+	ret = stk11xx_process_table(dev, table_1);
+	if (ret)
+		goto end;
+
+	dev_dbg(&dev->udev->dev, "set contrast: %d, whiteness: %d, ",
+			dev->vsettings.contrast, dev->vsettings.whiteness);
+
+	ret = stk11xx_check_device(dev, 500);
+	if (!ret)
+		dev_dbg(&dev->udev->dev, "find not 0x4 ... seems OK\n");
+	ret = 0;
+end:
+	return ret;
+}
+
+static int stk1125_cam_init(struct stk11xx *dev)
+{
+	int ret;
+
+	const struct stk11xx_table table[] = {
+		{ 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 }, { 0x0204, 0x2a, 2 },
+		{ 0x0205, 0x00, 2 }, { 0x0200, 0x01, 2 }, {    500, 0x00, 3 },
+		{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+		{ 0x0204, 0x2b, 2 }, { 0x0205, 0x00, 2 }, { 0x0200, 0x01, 2 },
+		{    500, 0x00, 3 }, { 0x02ff, 0x00, 2 },
+		{ }
+	};
+
+	stk1125_cam_asleep(dev);
+
+	stk11xx_set_feature(dev, 0);
+
+	stk11xx_write_reg(dev, 0x0000, 0xe0);
+	stk11xx_write_reg(dev, 0x0002, 0xe8);
+	stk11xx_write_reg(dev, 0x0002, 0x68);
+	stk11xx_write_reg(dev, 0x0000, 0x20);
+
+	stk1125_dev_configure(dev, 9);
+
+	stk11xx_cam_off(dev);
+
+	ret = stk11xx_process_table(dev, table);
+	if (ret)
+		return ret;
+
+	return stk1125_cam_setting(dev);
+}
+
+static int stk1125_stream_start(struct stk11xx *dev)
+{
+	u8 value_116, value_117;
+
+	stk11xx_read_reg(dev, 0x0116, &value_116);
+	stk11xx_read_reg(dev, 0x0117, &value_117);
+
+	stk11xx_write_reg(dev, 0x0116, 0x00);
+	stk11xx_write_reg(dev, 0x0117, 0x00);
+
+	stk11xx_read_dummy(dev, 0x0100);	/* read 0x21 */
+	stk11xx_write_reg(dev, 0x0100, 0xa1);
+
+	stk11xx_write_reg(dev, 0x0116, value_116);
+	stk11xx_write_reg(dev, 0x0117, value_117);
+
+	return 0;
+}
+
+static int stk1125_stream_stop(struct stk11xx *dev)
+{
+	stk11xx_read_dummy(dev, 0x0100);
+	stk11xx_write_reg(dev, 0x0100, 0x21);
+
+	return 0;
+}
+
+static int stk1125_cam_reconf(struct stk11xx *dev)
+{
+	int step;
+
+	switch (dev->resolution) {
+	case STK11XX_1280x1024:
+	case STK11XX_1024x768:
+	case STK11XX_800x600:
+		step = 11;
+		break;
+
+	case STK11XX_640x480:
+	case STK11XX_320x240:
+	case STK11XX_160x120:
+	case STK11XX_80x60:
+	default:
+		step = 10;
+		break;
+	}
+
+	stk1125_dev_configure(dev, step);
+
+	return 0;
+}
+
+/* this function is written from the USB log */
+static int stk1125_dev_init(struct stk11xx *dev)
+{
+	unsigned int i;
+	int ret;
+	u8 value;
+
+	const struct stk11xx_table table_1[] = {
+		{ 0x0000, 0x24, 2 }, { 0x0002, 0x68, 2 }, { 0x0003, 0x80, 2 },
+		{ 0x0002, 0x6f, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0002, 0x6d, 2 },
+		{ 0x0000, 0x24, 2 },
+		{ }
+	};
+	const struct stk11xx_table table_2[] = {
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x20, 2 }, { 0x0002, 0x6f, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0002, 0x6d, 2 }, { 0x0000, 0x24, 2 },
+		{ }
+	};
+	const struct stk11xx_table table_3[] = {
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x20, 2 }, { 0x0002, 0x6f, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0002, 0x6d, 2 }, { 0x0000, 0x24, 2 },
+		{ }
+	};
+	const struct stk11xx_table table_4[] = {
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x20, 2 }, { 0x0002, 0x6f, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x20, 2 }, { 0x0117, 0x00, 2 },
+		{ 0x0103, 0x00, 1 }, { 0x0103, 0x01, 2 }, { 0x0103, 0x00, 1 },
+		{ 0x0103, 0x00, 2 }, { 0x0000, 0xe0, 2 }, { 0x0002, 0xe8, 2 },
+		{ 0x0002, 0x68, 2 }, { 0x0000, 0x20, 2 },
+
+		{      0, 0x00, 4 }, {    65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      1, 0x00, 4 }, {    65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+
+		{      2, 0x00, 4 }, {    500, 0x00, 3 }, { 0x02ff, 0x00, 1 },
+		{ 0x02ff, 0x00, 2 }, { 0x0208, 0x13, 2 }, { 0x0200, 0x20, 2 },
+		{    500, 0x00, 3 }, { 0x0209, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+		{ 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 }, { 0x0208, 0x0a, 2 },
+		{ 0x0200, 0x20, 2 }, {    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+		{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+		{ 0x0208, 0x0b, 2 }, { 0x0200, 0x20, 2 }, {    500, 0x00, 3 },
+		{ 0x0209, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+
+		{      3, 0x00, 4 }, {    65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      4, 0x00, 4 }, {    65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+
+		{      5, 0x00, 4 }, {    500, 0x00, 3 }, { 0x02ff, 0x00, 1 },
+		{ 0x02ff, 0x00, 2 }, { 0x0208, 0x13, 2 }, { 0x0200, 0x20, 2 },
+		{    500, 0x00, 3 }, { 0x0209, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+		{ 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 }, { 0x0208, 0x0a, 2 },
+		{ 0x0200, 0x20, 2 }, {    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+		{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+		{ 0x0208, 0x0b, 2 }, { 0x0200, 0x20, 2 }, {    500, 0x00, 3 },
+		{ 0x0209, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+
+		{      6, 0x00, 4 }, {    500, 0x00, 3 }, { 0x02ff, 0x00, 1 },
+		{ 0x02ff, 0x00, 2 }, { 0x0208, 0x13, 2 }, { 0x0200, 0x20, 2 },
+		{    500, 0x00, 3 }, { 0x0209, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+		{ 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 }, { 0x0208, 0x0a, 2 },
+		{ 0x0200, 0x20, 2 }, {    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+		{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+		{ 0x0208, 0x0b, 2 }, { 0x0200, 0x20, 2 }, {    500, 0x00, 3 },
+		{ 0x0209, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+
+		{      7, 0x00, 4 }, {    500, 0x00, 3 }, { 0x02ff, 0x00, 1 },
+		{ 0x02ff, 0x00, 2 }, { 0x0208, 0x13, 2 }, { 0x0200, 0x20, 2 },
+		{    500, 0x00, 3 }, { 0x0209, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+		{ 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 }, { 0x0208, 0x0a, 2 },
+		{ 0x0200, 0x20, 2 }, {    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+		{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+		{ 0x0208, 0x0b, 2 }, { 0x0200, 0x20, 2 }, {    500, 0x00, 3 },
+		{ 0x0209, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+
+		{ 0x0002, 0x6f, 2 }, { 0x0000, 0x24, 2 }, { 0x0002, 0x6d, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0000, 0x20, 2 },
+
+		{      8, 0x00, 4 },
+		{ }
+	};
+
+	ret = stk11xx_process_table(dev, table_1);
+	if (ret)
+		goto end;
+
+	for (i = 0; i < 16; i++) {
+		stk11xx_write_reg(dev, 0x0000, 0x25);
+		stk11xx_write_reg(dev, 0x0000, 0x24);
+		stk11xx_read_reg(dev, 0x0000, &value);
+
+		dev_dbg(&dev->udev->dev, "Loop 1: Read 0x0000 = %02x\n", value);
+	}
+
+	ret = stk11xx_process_table(dev, table_2);
+	if (ret)
+		goto end;
+
+	for (i = 0; i < 16; i++) {
+		stk11xx_write_reg(dev, 0x0000, 0x25);
+		stk11xx_write_reg(dev, 0x0000, 0x24);
+		stk11xx_read_reg(dev, 0x0000, &value);
+
+		dev_dbg(&dev->udev->dev, "Loop 2: Read 0x0000 = %02x\n", value);
+	}
+
+	ret = stk11xx_process_table(dev, table_3);
+	if (ret)
+		goto end;
+
+	for (i = 0; i < 16; i++) {
+		stk11xx_write_reg(dev, 0x0000, 0x25);
+		stk11xx_write_reg(dev, 0x0000, 0x24);
+		stk11xx_read_reg(dev, 0x0000, &value);
+
+		dev_dbg(&dev->udev->dev, "Loop 3: Read 0x0000 = %02x\n", value);
+	}
+
+	ret = stk11xx_process_table(dev, table_4);
+	if (ret)
+		goto end;
+
+	stk1125_cam_asleep(dev);
+
+	stk11xx_set_feature(dev, 0);
+
+end:
+	return ret;
+}
+
+struct stk_model stk_model_1125 = {
+	.model = SYNTEK_STK1125,
+	.name = "1125",
+	.dev_init = stk1125_dev_init,
+	.dev_configure = stk1125_dev_configure,
+	.cam_init = stk1125_cam_init,
+	.cam_setting = stk1125_cam_setting,
+	.cam_asleep = stk1125_cam_asleep,
+	.cam_reconf = stk1125_cam_reconf,
+	.stream_start = stk1125_stream_start,
+	.stream_stop = stk1125_stream_stop,
+};
diff -puN /dev/null drivers/media/video/stk1135.c
--- /dev/null
+++ a/drivers/media/video/stk1135.c
@@ -0,0 +1,549 @@
+/*
+ * STK-1135 part
+ *
+ * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
+ *
+ * Based on Nicolas VIVIEN's driver
+ *
+ * Licences
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/usb.h>
+#include <linux/types.h>
+
+#include "stk11xx.h"
+
+static int stk1135_load_microcode(struct stk11xx *dev)
+{
+	unsigned int i;
+	int retok;
+
+	const u8 values_204[] = {
+		0x17, 0x19, 0xb4, 0xa6, 0x12, 0x13, 0x1e, 0x21, 0x24, 0x32,
+		0x36, 0x39, 0x4d, 0x53, 0x5d, 0x5f, 0x60, 0x61, 0x62, 0x63,
+		0x64, 0x65, 0x66, 0x82, 0x83, 0x85, 0x86, 0x89, 0x97, 0x98,
+		0xad, 0xae, 0xb8, 0xb9, 0xba, 0xbb, 0xbc, 0xbf, 0x48, 0xd8,
+		0x76, 0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f,
+		0x80, 0x81, 0xd8, 0x76, 0x77, 0x78, 0x79, 0x7a, 0x7b, 0x7c,
+		0x7d, 0x7e, 0x7f, 0x80, 0x81, 0xd8, 0x76, 0x77, 0x78, 0x79,
+		0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f, 0x80, 0x81, 0x5c, 0xc0,
+		0x59, 0x5a, 0x5b, 0xd4, 0x8e, 0x8f, 0x90, 0x91, 0x92, 0x93,
+		0x94, 0x95, 0x96, 0xb3, 0x73, 0x06, 0x07, 0x0b, 0x15, 0x20,
+		0x4e, 0x4f, 0x49, 0x4a, 0x4b, 0x4c, 0x46, 0x06, 0x07, 0xb9,
+		0xba, 0xbb, 0xbc, 0x61, 0x62, 0x65, 0x66
+	};
+	const u8 values_205[] = {
+		0x41, 0x41, 0x03, 0x06, 0x06, 0x08, 0x06, 0x00, 0x02, 0x69,
+		0x35, 0x60, 0xfe, 0x1c, 0x04, 0x08, 0x08, 0x08, 0x08, 0x00,
+		0x00, 0x10, 0x14, 0x01, 0x80, 0x0c, 0xb6, 0x00, 0x25, 0x25,
+		0x3f, 0x24, 0x10, 0x07, 0xcc, 0x1f, 0x30, 0x02, 0x9c, 0x80,
+		0x00, 0x0d, 0x18, 0x22, 0x2c, 0x3e, 0x4f, 0x6f, 0x8e, 0xac,
+		0xc8, 0xe5, 0xa0, 0x00, 0x0d, 0x18, 0x22, 0x2c, 0x3e, 0x4f,
+		0x6f, 0x8e, 0xac, 0xc8, 0xe5, 0xc0, 0x00, 0x0d, 0x18, 0x22,
+		0x2c, 0x3e, 0x4f, 0x6f, 0x8e, 0xac, 0xc8, 0xe5, 0x70, 0x18,
+		0x09, 0x07, 0x07, 0x3c, 0x3d, 0x95, 0x88, 0x89, 0x47, 0x9c,
+		0x81, 0x9c, 0x3d, 0x76, 0x76, 0x01, 0xf3, 0x05, 0x00, 0x44,
+		0x06, 0x0a, 0x96, 0x00, 0x7d, 0x00, 0x20, 0x01, 0xf3, 0x04,
+		0xe4, 0x09, 0xc8, 0x08, 0x08, 0x10, 0x14
+	};
+
+	for (i = 0; i < 117; i++) {
+		stk11xx_read_dummy(dev, 0x02ff);
+		stk11xx_write_reg(dev, 0x02ff, 0x00);
+
+		stk11xx_write_reg(dev, 0x0204, values_204[i]);
+		stk11xx_write_reg(dev, 0x0205, values_205[i]);
+		stk11xx_write_reg(dev, 0x0200, 0x01);
+
+		retok = stk11xx_check_device(dev, 500);
+		if (retok != 1) {
+			dev_err(&dev->udev->dev, "load microcode failed\n");
+			return -EIO;
+		}
+
+		stk11xx_write_reg(dev, 0x02ff, 0x00);
+	}
+
+	stk11xx_check_device(dev, 500);
+
+	return 0;
+}
+
+/*
+ * The configuration of device is composed of 12 steps.
+ * This function is called by the initialization process.
+ *
+ * We don't know the meaning of these steps! We only replay the USB log.
+ */
+static int stk1135_dev_configure(struct stk11xx *dev, unsigned int step)
+{
+	int ret;
+	/*      0,    1,    2,    3,    4,    5,    6,    7,    8,    9,
+		10,   11,   12,   13 */
+
+	const u8 vals_001B[] = {
+		0x0e, 0x03, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x07,
+		0x07, 0x07, 0x07, 0x07
+	};
+	const u8 vals_001C[] = {
+		0x06, 0x02, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x06, 0x06,
+		0x06, 0x06, 0x06, 0x06
+	};
+	const u8 vals_0202[] = {
+		0x1e, 0x0a, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e,
+		0x1e, 0x1e, 0x1e, 0x1e
+	};
+	const u8 vals_0110[] = {
+		0x07, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x3e, 0x00, 0x04, 0x00,
+		0x00, 0x00, 0x00, 0x00
+	};
+	const u8 vals_0112[] = {
+		0x07, 0x00, 0x00, 0x00, 0x00, 0x09, 0x09, 0x00, 0x04, 0x00,
+		0x00, 0x00, 0x00, 0x00
+	};
+	const u8 vals_0114[] = {
+		0x87, 0x80, 0x80, 0x80, 0x80, 0xbe, 0xbe, 0x80, 0x84, 0x80,
+		0x80, 0x80, 0x80, 0x80
+	};
+	const u8 vals_0116[] = {
+		0xe7, 0xe0, 0xe0, 0xe0, 0xe0, 0xe9, 0xe9, 0xe0, 0xe4, 0xe0,
+		0xe0, 0xe0, 0xe0, 0xe0
+	};
+	const u8 vals_0100[] = {
+		0x20, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x23, 0x20,
+		0x20, 0x20, 0x20, 0x20
+	};
+	struct stk11xx_table table_1[] = {
+		{ 0x0000, 0x24, 2 }, { 0x0002, 0x68, 2 }, { 0x0003, 0x80, 2 },
+		{ 0x0005, 0x00, 2 }, { 0x0007, 0x03, 2 }, { 0x000d, 0x00, 2 },
+		{ 0x000f, 0x02, 2 }, { 0x0300, 0x12, 2 }, { 0x0350, 0x41, 2 },
+		{ 0x0351, 0x00, 2 }, { 0x0352, 0x00, 2 }, { 0x0353, 0x00, 2 },
+		{ 0x0018, 0x10, 2 }, { 0x0019, 0x00, 2 },
+
+		{ 0x001b, vals_001B[step], 2 }, { 0x001c, vals_001C[step], 2 },
+		{ 0x0300, 0x80, 2 }, { 0x001a, 0x04, 2 },
+		{ 0x0202, vals_0202[step], 2 },
+
+		{ 0x0110, vals_0110[step], 2 }, { 0x0111, 0x00, 2 },
+		{ 0x0112, vals_0112[step], 2 }, { 0x0113, 0x00, 2 },
+		{ 0x0114, vals_0114[step], 2 }, { 0x0115, 0x02, 2 },
+		{ 0x0116, vals_0116[step], 2 }, { 0x0117, 0x01, 2 },
+
+		{ 0x0100, 0x00, 1 }, { 0x0100, vals_0100[step], 2 },
+
+		{ 0x0200, 0x80, 2 }, { 0x0200, 0x00, 2 }, { 0x02ff, 0x00, 2 },
+		{ }
+	};
+
+	dev_dbg(&dev->udev->dev, "stk1135_dev_configure: %d\n", step);
+
+	ret = stk11xx_process_table(dev, table_1);
+	if (ret)
+		goto err;
+
+	switch (step) {
+	case 0: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x40, 2 }, { 0x0204, 0x41, 2 },
+			{ 0x0205, 0x01, 2 }, { 0x0204, 0x1c, 2 },
+			{ 0x0205, 0x02, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 1: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x22, 2 }, { 0x0204, 0x27, 2 },
+			{ 0x0205, 0xa5, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 2: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xbf, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 3: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x42, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x24, 2 },
+			{ 0x0205, 0xa5, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 4: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x42, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xe0, 2 }, { 0x0204, 0x24, 2 },
+			{ 0x0205, 0xa5, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 5: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xff, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 6: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xff, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 7: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xb7, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 8: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x80, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x0a, 2 },
+			{ 0x0205, 0xff, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 9: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0xdc, 2 }, { 0x0204, 0x15, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0200, 0x05, 2 },
+			{    500, 0x00, 3 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0208, 0x00, 2 },
+			{ 0x0200, 0x20, 2 }, {    500, 0x00, 3 },
+			{ 0x0209, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+			{ 0x02ff, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+			{ 0x0208, 0x01, 2 }, { 0x0200, 0x20, 2 },
+			{    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0208, 0x02, 2 },
+			{ 0x0200, 0x20, 2 }, {    500, 0x00, 3 },
+			{ 0x0209, 0x00, 1 }, { 0x02ff, 0x00, 2 },
+			{ 0x0002, 0x6f, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 10:
+		stk11xx_write_reg(dev, 0x0203, 0xdc);
+
+		ret = stk1135_load_microcode(dev);
+
+		break;
+
+	case 11:
+		stk11xx_write_reg(dev, 0x0203, 0xdc);
+
+		ret = stk1135_load_microcode(dev);
+
+		stk11xx_write_reg(dev, 0x0104, 0x00);
+		stk11xx_write_reg(dev, 0x0105, 0x00);
+		stk11xx_write_reg(dev, 0x0106, 0x00);
+
+		break;
+
+	case 12:
+		stk11xx_write_reg(dev, 0x0203, 0xdc);
+
+		ret = stk1135_load_microcode(dev);
+
+		stk11xx_write_reg(dev, 0x0104, 0x00);
+		stk11xx_write_reg(dev, 0x0105, 0x00);
+		stk11xx_write_reg(dev, 0x0106, 0x00);
+
+		break;
+
+	case 13:
+		stk11xx_write_reg(dev, 0x0203, 0xdc);
+
+		ret = stk1135_load_microcode(dev);
+
+		stk11xx_write_reg(dev, 0x0106, 0x00);
+
+		break;
+	}
+
+err:
+	return ret;
+}
+
+static int stk1135_cam_asleep(struct stk11xx *dev)
+{
+	const struct stk11xx_table table[] = {
+		{ 0x0104, 0x00, 1 }, { 0x0105, 0x00, 1 }, { 0x0106, 0x00, 1 },
+		{ 0x0100, 0x21, 2 }, { 0x0116, 0x00, 2 }, { 0x0117, 0x00, 2 },
+		{ 0x0018, 0x00, 2 }, { 0x0000, 0x00, 1 }, { 0x0000, 0x49, 2 },
+		{ }
+	};
+
+	return stk11xx_process_table(dev, table);
+}
+
+static int stk1135_cam_setting(struct stk11xx *dev)
+{
+	unsigned int i;
+
+	const u8 values_204[] = {
+		0xb3, 0x73, 0x46, 0x06, 0x07, 0xb9, 0xba, 0xbb, 0xbc, 0x61,
+		0x62, 0x65, 0x66
+	};
+	const u8 values_205[] = {
+		0x76, 0x76, 0x20, 0x01, 0xf3, 0x04, 0xe4, 0x09, 0xc8, 0x08,
+		0x08, 0x10, 0x14
+	};
+
+	for (i = 0; i < ARRAY_SIZE(values_204); i++) {
+		stk11xx_read_dummy(dev, 0x02ff);
+		stk11xx_write_reg(dev, 0x02ff, 0x00);
+
+		stk11xx_write_reg(dev, 0x0204, values_204[i]);
+		stk11xx_write_reg(dev, 0x0205, values_205[i]);
+
+		stk11xx_write_reg(dev, 0x0200, 0x01);
+		stk11xx_check_device(dev, 500);
+		stk11xx_write_reg(dev, 0x02ff, 0x00);
+	}
+
+	return 0;
+}
+
+static int stk1135_cam_init(struct stk11xx *dev)
+{
+	stk1135_cam_asleep(dev);
+
+	stk11xx_set_feature(dev, 0);
+
+	stk11xx_write_reg(dev, 0x0000, 0xe0);
+	stk11xx_write_reg(dev, 0x0002, 0xe8);
+	stk11xx_write_reg(dev, 0x0002, 0x68);
+	stk11xx_write_reg(dev, 0x0000, 0x20);
+
+	stk1135_dev_configure(dev, 11);
+
+	stk11xx_cam_off(dev);
+	stk1135_cam_setting(dev);
+	stk1135_cam_asleep(dev);
+
+	stk11xx_set_feature(dev, 0);
+
+	stk11xx_write_reg(dev, 0x0000, 0xe0);
+	stk11xx_write_reg(dev, 0x0002, 0xe8);
+	stk11xx_write_reg(dev, 0x0002, 0x68);
+	stk11xx_write_reg(dev, 0x0000, 0x20);
+
+	stk1135_dev_configure(dev, 12);
+
+	stk11xx_cam_off(dev);
+	stk1135_cam_setting(dev);
+
+	return 0;
+}
+
+static int stk1135_cam_reconf(struct stk11xx *dev)
+{
+	stk1135_dev_configure(dev, 13);
+
+	return 0;
+}
+
+static int stk1135_stream_start(struct stk11xx *dev)
+{
+	u8 value_116, value_117;
+
+	stk11xx_read_reg(dev, 0x0116, &value_116);
+	stk11xx_read_reg(dev, 0x0117, &value_117);
+
+	stk11xx_write_reg(dev, 0x0116, 0x00);
+	stk11xx_write_reg(dev, 0x0117, 0x00);
+
+	stk11xx_read_dummy(dev, 0x0100);	/* read 0x21 */
+	stk11xx_write_reg(dev, 0x0100, 0xa0);
+
+	stk11xx_write_reg(dev, 0x0116, value_116);
+	stk11xx_write_reg(dev, 0x0117, value_117);
+
+	return 0;
+}
+
+static int stk1135_stream_stop(struct stk11xx *dev)
+{
+	stk11xx_read_dummy(dev, 0x0100);
+	stk11xx_write_reg(dev, 0x0100, 0x20);
+
+	return 0;
+}
+
+/* this function is written from the USB log */
+static int stk1135_dev_init(struct stk11xx *dev)
+{
+	unsigned int i;
+	int ret;
+	u8 value;
+
+	const struct stk11xx_table table_1[] = {
+		{ 0x0000, 0x24, 2 }, { 0x0002, 0x68, 2 }, { 0x0003, 0x80, 2 },
+		{ 0x0002, 0x6f, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0002, 0x6d, 2 },
+		{ 0x0000, 0x24, 2 },
+		{ }
+	};
+	const struct stk11xx_table table_2[] = {
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x20, 2 }, { 0x0002, 0x6f, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0002, 0x6d, 2 }, { 0x0000, 0x24, 2 },
+		{ }
+	};
+	const struct stk11xx_table table_3[] = {
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x20, 2 }, { 0x0002, 0x6f, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0002, 0x6d, 2 }, { 0x0000, 0x24, 2 },
+		{ }
+	};
+	const struct stk11xx_table table_4[] = {
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x20, 2 }, { 0x0002, 0x6f, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x20, 2 }, { 0x0117, 0x00, 2 },
+		{ 0x0103, 0x00, 1 }, { 0x0103, 0x01, 2 }, { 0x0103, 0x00, 1 },
+		{ 0x0103, 0x00, 2 }, { 0x0000, 0xe0, 2 }, { 0x0002, 0xe8, 2 },
+		{ 0x0002, 0x68, 2 }, { 0x0000, 0x20, 2 },
+
+		{      0, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      1, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      2, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      3, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      4, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      5, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      6, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      7, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      8, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      9, 0x00, 4 }, { 0x0000, 0x24, 2 }, { 0x0002, 0x6d, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0000, 0x20, 2 },
+		{     10, 0x00, 4 }, { 0x0200, 0x80, 2 }, { 0x0200, 0x00, 2 },
+		{ 0x02ff, 0x01, 2 }, { 0x0203, 0xa0, 2 },
+		{ }
+	};
+
+	ret = stk11xx_process_table(dev, table_1);
+	if (ret)
+		goto end;
+
+	for (i = 0; i < 16; i++) {
+		stk11xx_write_reg(dev, 0x0000, 0x25);
+		stk11xx_write_reg(dev, 0x0000, 0x24);
+		stk11xx_read_reg(dev, 0x0000, &value);
+
+		dev_dbg(&dev->udev->dev, "Loop 1: Read 0x0000 = %02x\n", value);
+	}
+
+	ret = stk11xx_process_table(dev, table_2);
+	if (ret)
+		goto end;
+
+	for (i = 0; i < 16; i++) {
+		stk11xx_write_reg(dev, 0x0000, 0x25);
+		stk11xx_write_reg(dev, 0x0000, 0x24);
+		stk11xx_read_reg(dev, 0x0000, &value);
+
+		dev_dbg(&dev->udev->dev, "Loop 2: Read 0x0000 = %02x\n", value);
+	}
+
+	ret = stk11xx_process_table(dev, table_3);
+	if (ret)
+		goto end;
+
+	for (i = 0; i < 16; i++) {
+		stk11xx_write_reg(dev, 0x0000, 0x25);
+		stk11xx_write_reg(dev, 0x0000, 0x24);
+		stk11xx_read_reg(dev, 0x0000, &value);
+
+		dev_dbg(&dev->udev->dev, "Loop 3: Read 0x0000 = %02x\n", value);
+	}
+
+	ret = stk11xx_process_table(dev, table_4);
+	if (ret)
+		goto end;
+
+	stk1135_cam_asleep(dev);
+
+	stk11xx_set_feature(dev, 0);
+
+end:
+	return ret;
+}
+
+struct stk_model stk_model_1135 = {
+	.model = SYNTEK_STK1135,
+	.name = "1135",
+	.dev_init = stk1135_dev_init,
+	.dev_configure = stk1135_dev_configure,
+	.cam_init = stk1135_cam_init,
+	.cam_setting = stk1135_cam_setting,
+	.cam_asleep = stk1135_cam_asleep,
+	.cam_reconf = stk1135_cam_reconf,
+	.stream_start = stk1135_stream_start,
+	.stream_stop = stk1135_stream_stop,
+};
diff -puN /dev/null drivers/media/video/stk11xx-core.c
--- /dev/null
+++ a/drivers/media/video/stk11xx-core.c
@@ -0,0 +1,962 @@
+/*
+ * Driver for Syntek USB video camera
+ *
+ * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
+ *
+ * Based on Nicolas VIVIEN's driver
+ *
+ * Licences
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/usb.h>
+#include <media/v4l2-common.h>
+
+#include "stk11xx.h"
+
+#define USB_SYNTEK1_VENDOR_ID		0x174f
+#define USB_SYNTEK2_VENDOR_ID		0x05e1
+
+#define USB_STK1125_PRODUCT_ID		0xa311
+#define USB_STK1135_PRODUCT_ID		0xa821
+#define USB_STKDCNEW_PRODUCT_ID		0x6a31
+#define USB_DC1125_PRODUCT_ID		0x0501
+
+static const struct stk11xx_coord stk11xx_image_sizes[STK11XX_NBR_SIZES] = {
+	{   80,   60 },
+	{  160,  120 },
+	{  320,  240 },
+	{  640,  480 },
+	{  800,  600 },
+	{ 1024,  768 },
+	{ 1280, 1024 }
+};
+
+static unsigned int fps = 10;
+module_param(fps, uint, 0444);
+MODULE_PARM_DESC(fps, "Frames per second [10-30]");
+
+int stk11xx_read_reg(struct stk11xx *dev, u16 index, u8 *value)
+{
+	struct usb_device *udev = dev->udev;
+	int result;
+
+	*value = 0;
+
+	result = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x00,
+			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE, 0x00,
+			index, value, sizeof(u8), 500);
+
+	if (result < 0)
+		dev_err(&udev->dev, "Read registry fails %02X\n", index);
+	else
+		result = 0;
+
+	return result;
+}
+
+int stk11xx_write_reg(struct stk11xx *dev, u16 index, u16 value)
+{
+	struct usb_device *udev = dev->udev;
+	int result;
+
+	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x01,
+			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE, value,
+			index, NULL, 0, 500);
+
+	if (result < 0)
+		dev_err(&udev->dev, "Write registry fails %02X = %02X\n", index,
+				value);
+	else
+		result = 0;
+
+	return result;
+}
+
+int stk11xx_set_feature(struct stk11xx *dev, int index)
+{
+	struct usb_device *udev = dev->udev;
+	int result;
+
+	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+				 USB_REQ_SET_FEATURE,
+				 USB_TYPE_STANDARD | USB_DIR_OUT |
+				 USB_RECIP_DEVICE, USB_DEVICE_REMOTE_WAKEUP,
+				 index, NULL, 0, 500);
+
+	if (result < 0)
+		dev_err(&udev->dev, "SET FEATURE fail !\n");
+
+	return result;
+}
+
+int stk11xx_process_table(struct stk11xx *dev,
+		const struct stk11xx_table *table)
+{
+	int ret = 0;
+
+	for (; table->type; table++)
+		switch (table->type) {
+		case 1:
+			ret = stk11xx_read_dummy(dev, table->addr);
+			break;
+		case 2:
+			ret = stk11xx_write_reg(dev, table->addr, table->val);
+			break;
+		case 3:
+			ret = stk11xx_check_device(dev, table->addr);
+			if (ret > 0)
+				ret = 0;
+			break;
+		case 4:
+			dev->model->dev_configure(dev, table->addr);
+			break;
+		}
+
+	return ret;
+}
+
+/*
+ * Bayer conversion
+ */
+
+#define STK11XX_AVG2(x, y) (u8)(((int)x + (int)y) / 2)
+#define STK11XX_AVG4(a, b, c, d) (u8)(((int)a + (int)b + (int)c + (int)d) / 4)
+
+static void stk11xx_bayer_to_rgb(u8 *rgb, const u8 *bayer,
+		  unsigned int width, unsigned int height, unsigned int factor)
+{
+	const u8 *src;
+	u8 *dst;
+	unsigned int x, y, pos, above, below;
+
+	/*
+	 * Picture from cam is vertically flipped and is of this form:
+	 * .   .      .
+	 * .   .    .
+	 * .   .  .
+	 * GRGRGR . . .
+	 * BGBGBG
+	 * GRGRGR . . .
+	 */
+	/* blit out initial data */
+	for (y = 0; y < height; y += factor) {
+		src = &bayer[(height - y - 1) * width];
+		dst = &rgb[y * width * 3 / (factor * factor)];
+		for (x = 0; x < width; x += factor, src += factor, dst += 3)
+			dst[!(y & 1) + (x & 1)] = *src;
+	}
+
+	/* blit in everything but the borders */
+	for (y = factor; y < height - factor; y += factor) {
+		pos = (height - y - 1) * width + factor;
+		dst = &rgb[y * width * 3 / (factor * factor) + 3];
+		for (x = factor; x < width - factor; x += factor, pos += factor,
+				dst += 3) {
+			above = pos - width;
+			below = pos + width;
+
+			if (y & 1) {
+				/* XGBGBG line */
+				if (x & 1) {	/* G is known */
+					dst[2] = STK11XX_AVG2( /* R */
+						bayer[above],	bayer[below]);
+					dst[0] = STK11XX_AVG2( /* B */
+						bayer[pos - 1],	bayer[pos + 1]);
+				} else {	/* B is known */
+					dst[2] = STK11XX_AVG4( /* R */
+						bayer[above-1],	bayer[above+1],
+						bayer[below-1],	bayer[below+1]);
+					dst[1] = STK11XX_AVG4( /* G */
+						bayer[above],	bayer[below],
+						bayer[pos - 1],	bayer[pos + 1]);
+				}
+			} else {
+				/* XRGRGR line */
+				if (x & 1) {	/* R is known */
+					dst[0] = STK11XX_AVG4( /* B */
+						bayer[above-1],	bayer[above+1],
+						bayer[below-1],	bayer[below+1]);
+					dst[1] = STK11XX_AVG4( /* G */
+						bayer[above],	bayer[below],
+						bayer[pos - 1],	bayer[pos + 1]);
+				} else {	/* G is known */
+					dst[0] = STK11XX_AVG2( /* B */
+						bayer[above], bayer[below]);
+					dst[2] = STK11XX_AVG2( /* R */
+						bayer[pos - 1],	bayer[pos + 1]);
+				}
+			}
+		}
+	}
+}
+
+int stk11xx_decompress(struct stk11xx *dev)
+{
+	struct stk11xx_frame_buf *framebuf = dev->read_frame;
+	void *data, *image = dev->image_data;
+	unsigned int width, height, factor;
+
+	if (framebuf == NULL)
+		return -EFAULT;
+
+	image += dev->images[dev->fill_image].offset;
+
+	data = framebuf->data;
+
+	switch (dev->resolution) {
+	case STK11XX_80x60:
+		factor = 8;
+		width = stk11xx_image_sizes[STK11XX_640x480].x;
+		height = stk11xx_image_sizes[STK11XX_640x480].y;
+		break;
+
+	case STK11XX_160x120:
+		factor = 4;
+		width = stk11xx_image_sizes[STK11XX_640x480].x;
+		height = stk11xx_image_sizes[STK11XX_640x480].y;
+		break;
+
+	case STK11XX_320x240:
+		factor = 2;
+		width = stk11xx_image_sizes[STK11XX_640x480].x;
+		height = stk11xx_image_sizes[STK11XX_640x480].y;
+		break;
+
+	case STK11XX_640x480:
+		factor = 1;
+		width = stk11xx_image_sizes[STK11XX_640x480].x;
+		height = stk11xx_image_sizes[STK11XX_640x480].y;
+		break;
+
+	case STK11XX_800x600:
+		factor = 1;
+		width = stk11xx_image_sizes[STK11XX_1280x1024].x;
+		height = stk11xx_image_sizes[STK11XX_1280x1024].y;
+		break;
+
+	case STK11XX_1024x768:
+		factor = 1;
+		width = stk11xx_image_sizes[STK11XX_1280x1024].x;
+		height = stk11xx_image_sizes[STK11XX_1280x1024].y;
+		break;
+
+	case STK11XX_1280x1024:
+		factor = 1;
+		width = stk11xx_image_sizes[STK11XX_1280x1024].x;
+		height = stk11xx_image_sizes[STK11XX_1280x1024].y;
+		break;
+
+	default:
+		return -EFAULT;
+	}
+
+	stk11xx_bayer_to_rgb(image, data, width, height, factor);
+
+	return 0;
+}
+
+/*
+ * Device
+ */
+
+/*
+ * called when a frame is ready to prepare the next frame
+ */
+static int stk11xx_next_frame(struct stk11xx *dev)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	STK_STREAM("Select next frame\n");
+
+	spin_lock_irqsave(&dev->spinlock, flags);
+
+	if (dev->fill_frame != NULL) {
+		if (dev->full_frames == NULL) {
+			dev->full_frames = dev->fill_frame;
+			dev->full_frames_tail = dev->full_frames;
+		} else {
+			dev->full_frames_tail->next = dev->fill_frame;
+			dev->full_frames_tail = dev->fill_frame;
+		}
+	}
+
+	if (dev->empty_frames != NULL) {
+		dev->fill_frame = dev->empty_frames;
+		dev->empty_frames = dev->empty_frames->next;
+	} else {
+		if (dev->full_frames == NULL) {
+			dev_err(&dev->udev->dev, "neither empty or full frames "
+					"available!\n");
+			spin_unlock_irqrestore(&dev->spinlock, flags);
+			return -EINVAL;
+		}
+
+		dev->fill_frame = dev->full_frames;
+		dev->full_frames = dev->full_frames->next;
+
+		ret = 1;
+	}
+
+	dev->fill_frame->next = NULL;
+
+	spin_unlock_irqrestore(&dev->spinlock, flags);
+
+	return ret;
+}
+
+/*
+ * This function is called as an URB transfert is complete (Isochronous pipe).
+ * So, the traitement is done in interrupt time, so it has be fast, not crash,
+ * ans not stall. Neat.
+ */
+static void stk11xx_isoc_handler(struct urb *urb)
+{
+	struct stk11xx *dev = urb->context;
+	struct stk11xx_frame_buf *framebuf;
+	unsigned char *fill = NULL, *iso_buf = NULL;
+	unsigned int i;
+	int ret, skip, awake = 0, framestatus, framelen;
+
+	STK_STREAM("Isoc handler\n");
+
+	if (dev == NULL) {
+		dev_err(&dev->udev->dev, "isoc_handler called with NULL "
+				"device\n");
+		return;
+	}
+
+	switch (urb->status) {
+	case 0:
+	case -ETIMEDOUT:
+		break;
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		return;
+	default:
+		dev_warn(&dev->udev->dev, "unknown urb status %d\n",
+				urb->status);
+
+	}
+
+	framebuf = dev->fill_frame;
+	if (framebuf == NULL) {
+		dev_err(&dev->udev->dev, "isoc_handler without valid fill "
+				"frame\n");
+
+		wake_up_interruptible(&dev->wait_frame);
+
+		urb->dev = dev->udev;
+		ret = usb_submit_urb(urb, GFP_ATOMIC);
+
+		if (ret != 0)
+			dev_err(&dev->udev->dev, "error (%d) re-submitting urb "
+					"in isoc_handler\n", ret);
+
+		return;
+	}
+
+	fill = framebuf->data + framebuf->filled;
+
+	/* Compact data */
+	for (i = 0; i < urb->number_of_packets; i++) {
+		framestatus = urb->iso_frame_desc[i].status;
+		framelen = urb->iso_frame_desc[i].actual_length;
+		iso_buf = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
+
+		if (framestatus == 0) {
+			skip = 4;
+
+			if (framelen > 4) {
+	/* we found something informational from there */
+	/* the isoc frames have two type of headers */
+	/* type1: 00 xx 00 00 or 20 xx 00 00 */
+	/* type2: 80 xx 00 00 00 00 00 00 or a0 xx 00 00 00 00 00 00 */
+	/* xx is a sequencer which has never been seen over 0x3f */
+
+	/* imho data written down looks like bayer, i see similarities after */
+	/* every 640 bytes */
+				if (*iso_buf & 0x80)
+					skip = 8;
+
+				if (framelen - skip + framebuf->filled >
+						dev->frame_size) {
+					dev_err(&dev->udev->dev, "frame buffer "
+							"overflow\n");
+				} else {
+					memcpy(fill, iso_buf + skip,
+					       framelen - skip);
+					fill += framelen - skip;
+				}
+
+				framebuf->filled += framelen - skip;
+			}
+
+			STK_STREAM("URB : Length = %d - Skip = %d - Buffer "
+					"size = %d\n", framelen, skip,
+					framebuf->filled);
+
+			if (framelen == 4) {
+				if (framebuf->filled > 0) {
+					stk11xx_next_frame(dev);
+
+					awake = 1;
+					framebuf = dev->fill_frame;
+					framebuf->filled = 0;
+					fill = framebuf->data;
+				}
+			}
+		} else
+			dev_err(&dev->udev->dev, "iso frame %d has error %d\n",
+					i, framestatus);
+	}
+
+	if (awake == 1)
+		wake_up_interruptible(&dev->wait_frame);
+
+	urb->dev = dev->udev;
+
+	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (ret != 0)
+		dev_err(&dev->udev->dev, "error (%d) re-submitting urb in "
+				"isoc_handler.\n", ret);
+}
+
+void stk11xx_isoc_cleanup(struct stk11xx *dev)
+{
+	unsigned int i;
+
+	dev_dbg(&dev->udev->dev, "isoc cleanup\n");
+
+	if (!test_bit(STK11XX_STAT_ISOC, dev->status))
+		return;
+
+	/* Unlinking ISOC buffers */
+	for (i = 0; i < MAX_ISO_BUFS; i++) {
+		struct urb *urb;
+
+		urb = dev->isobuf[i].urb;
+
+		if (urb != 0) {
+			if (test_bit(STK11XX_STAT_ISOC, dev->status))
+				usb_kill_urb(urb);
+
+			usb_free_urb(urb);
+			dev->isobuf[i].urb = NULL;
+		}
+	}
+
+	/* All is done */
+	clear_bit(STK11XX_STAT_ISOC, dev->status);;
+}
+
+int stk11xx_isoc_init(struct stk11xx *dev)
+{
+	struct usb_device *udev = dev->udev;
+	struct urb *urb;
+	unsigned int i, j;
+	int ret = 0;
+
+	if (test_bit(STK11XX_STAT_ISOC, dev->status))
+		return 0;
+
+	/* Allocate URB structure */
+	for (i = 0; i < MAX_ISO_BUFS; i++) {
+		urb = usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
+
+		if (urb == NULL) {
+			dev_err(&udev->dev, "failed to allocate URB %d\n", i);
+			ret = -ENOMEM;
+			goto err_free;
+		}
+
+		dev->isobuf[i].urb = urb;
+	}
+
+	for (i = 0; i < MAX_ISO_BUFS; i++) {
+		urb = dev->isobuf[i].urb;
+
+		urb->interval = 1;
+		urb->dev = udev;
+		urb->pipe = usb_rcvisocpipe(udev, dev->isoc_in_endpointAddr);
+		urb->transfer_flags = URB_ISO_ASAP;
+		urb->transfer_buffer = dev->isobuf[i].data;
+		urb->transfer_buffer_length = ISO_BUFFER_SIZE;
+		urb->complete = stk11xx_isoc_handler;
+		urb->context = dev;
+		urb->start_frame = 0;
+		urb->number_of_packets = ISO_FRAMES_PER_DESC;
+
+		for (j = 0; j < ISO_FRAMES_PER_DESC; j++) {
+			urb->iso_frame_desc[j].offset = j * ISO_MAX_FRAME_SIZE;
+			urb->iso_frame_desc[j].length = ISO_MAX_FRAME_SIZE;
+		}
+
+		ret = usb_submit_urb(urb, GFP_KERNEL);
+		if (ret)
+			dev_err(&udev->dev, "isoc_init submit_urb %d "
+					"failed with error %d\n", i, ret);
+		else
+			dev_dbg(&udev->dev, "URB 0x%p submitted\n", urb);
+	}
+
+	dev_dbg(&udev->dev, "isoc_in_endpointAddr = %x\n",
+			dev->isoc_in_endpointAddr);
+
+	/* All is done */
+	set_bit(STK11XX_STAT_ISOC, dev->status);
+
+	return 0;
+err_free:
+	for (; i > 0; i--) { /* i is unsigned */
+		usb_free_urb(dev->isobuf[i - 1].urb);
+		dev->isobuf[i - 1].urb = NULL;
+	}
+
+	return ret;
+}
+
+/*
+ * When we configure the stk11xx, this function is used to check the device
+ * status.
+ *   - If the read value is 0x00, then the device isn't ready.
+ *   - If the read value is 0x04, then the device is ready.
+ *   - If the read value is other, then the device is misconfigured.
+ */
+int stk11xx_check_device(struct stk11xx *dev, unsigned int nbr)
+{
+	unsigned int i;
+	int ret = 0;
+	u8 value;
+
+	for (i = 0; i < nbr; i++) {
+		ret = stk11xx_read_reg(dev, 0x201, &value);
+		if (ret)
+			goto end;
+
+		switch (value) {
+		case 0x00:
+			break;
+		case 0x01:
+		case 0x04:
+			return 1;
+		default:
+			dev_err(&dev->udev->dev, "check device return error "
+					"(0x201 = %02X)\n", value);
+			return -EIO;
+		}
+	}
+end:
+	return ret;
+}
+
+int stk11xx_cam_on(struct stk11xx *dev)
+{
+	struct usb_device *udev = dev->udev;
+	int ret;
+
+	ret = usb_set_interface(udev, 0, 5);
+
+	if (ret < 0)
+		dev_err(&udev->dev, "usb_set_interface failed\n");
+
+	return ret;
+}
+
+int stk11xx_cam_off(struct stk11xx *dev)
+{
+	struct usb_device *udev = dev->udev;
+	int ret;
+
+	ret = usb_set_interface(udev, 0, 0);
+
+	if (ret < 0)
+		dev_err(&udev->dev, "usb_set_interface failed\n");
+
+	return 0;
+}
+
+/*
+ * This function reads periodically the value of register 0x0001.
+ * We don't know the purpose. I assume that it seems to a software watchdog.
+ */
+int stk11xx_cam_watchdog(struct stk11xx *dev)
+{
+	u8 value;
+
+	stk11xx_read_reg(dev, 0x0001, &value);
+
+	if (value != 0x03)
+		dev_err(&dev->udev->dev, "Error: Register 0x0001 = %02X\n",
+				value);
+
+	return value;
+}
+
+int stk11xx_check_image_size(struct stk11xx *dev, unsigned int *width,
+		unsigned int *height)
+{
+	unsigned int a;
+
+	for (a = 0; a < ARRAY_SIZE(stk11xx_image_sizes); a++)
+		if (*width == stk11xx_image_sizes[a].x &&
+				*height == stk11xx_image_sizes[a].y)
+			break;
+
+	if (*width < stk11xx_image_sizes[0].x)
+		*width = stk11xx_image_sizes[0].x;
+	else if (*width > stk11xx_image_sizes[STK11XX_NBR_SIZES - 1].x)
+		*width = stk11xx_image_sizes[STK11XX_NBR_SIZES - 1].x;
+
+	if (*height < stk11xx_image_sizes[0].y)
+		*height = stk11xx_image_sizes[0].y;
+	else if (*height > stk11xx_image_sizes[STK11XX_NBR_SIZES - 1].y)
+		*height = stk11xx_image_sizes[STK11XX_NBR_SIZES - 1].y;
+
+	if (a >= ARRAY_SIZE(stk11xx_image_sizes))
+		return -EINVAL;
+
+	return 0;
+}
+
+int stk11xx_select_video_mode(struct stk11xx *dev, int width, int height)
+{
+	unsigned int i, find;
+
+	/* Check width and height */
+	/* Driver can't build an image more little than the minimal
+	 * resolution ! */
+	if ((width < stk11xx_image_sizes[0].x) ||
+			(height < stk11xx_image_sizes[0].y))
+		return -EINVAL;
+
+	/* Seek the best resolution */
+	switch (dev->model->model) {
+	case SYNTEK_STK1125:
+	case SYNTEK_STKDCNEW:
+		for (i = 0, find = 0; i < STK11XX_NBR_SIZES; i++) {
+			if (stk11xx_image_sizes[i].x <= width &&
+					stk11xx_image_sizes[i].y <= height)
+				find = i;
+		}
+		break;
+
+	case SYNTEK_STK1135:
+		for (i = 0, find = 0; i < STK11XX_NBR_SIZES - 3; i++) {
+			if (stk11xx_image_sizes[i].x <= width &&
+					stk11xx_image_sizes[i].y <= height)
+				find = i;
+		}
+		break;
+
+	default:
+		return -ENODEV;
+	}
+
+	/* Save the new resolution */
+	dev->resolution = find;
+
+	dev_dbg(&dev->udev->dev, "set mode %d [%dx%d]\n", dev->resolution,
+			stk11xx_image_sizes[dev->resolution].x,
+			stk11xx_image_sizes[dev->resolution].y);
+
+	/* Save the new size */
+	dev->view.x = stk11xx_image_sizes[dev->resolution].x;
+	dev->view.y = stk11xx_image_sizes[dev->resolution].y;
+
+	/* Calculate the frame size */
+	switch (dev->resolution) {
+	case STK11XX_80x60:
+	case STK11XX_160x120:
+	case STK11XX_320x240:
+	case STK11XX_640x480:
+		dev->frame_size = stk11xx_image_sizes[STK11XX_640x480].x *
+				stk11xx_image_sizes[STK11XX_640x480].y;
+		dev->image_size = 3 * dev->frame_size;
+		break;
+
+	case STK11XX_800x600:
+	case STK11XX_1024x768:
+	case STK11XX_1280x1024:
+		dev->frame_size = stk11xx_image_sizes[STK11XX_1280x1024].x *
+				stk11xx_image_sizes[STK11XX_1280x1024].y;
+		dev->image_size = 3 * dev->frame_size;
+		break;
+	}
+
+	return 0;
+}
+
+
+/*
+ * sysfs stuff
+ */
+
+static ssize_t show_contrast(struct class_device *class, char *buf)
+{
+	struct stk11xx *dev = video_get_drvdata(to_video_device(class));
+
+	return sprintf(buf, "%X\n", dev->vsettings.contrast);
+}
+
+static ssize_t show_whitebalance(struct class_device *class, char *buf)
+{
+	struct stk11xx *dev = video_get_drvdata(to_video_device(class));
+
+	return sprintf(buf, "%X\n", dev->vsettings.whiteness);
+}
+
+static CLASS_DEVICE_ATTR(contrast, S_IRUGO, show_contrast, NULL);
+static CLASS_DEVICE_ATTR(whitebalance, S_IRUGO, show_whitebalance, NULL);
+
+static inline int stk11xx_create_sysfs_file(const struct stk11xx *dev,
+		const struct class_device_attribute *cda)
+{
+	int ret;
+
+	ret = class_device_create_file(&dev->vdev->class_dev, cda);
+	if (ret)
+		dev_err(&dev->udev->dev, "can't create sysfs file %s: %d\n",
+				attr_name(*cda), ret);
+
+	return ret;
+}
+
+/*
+ * USB
+ */
+
+static int stk11xx_usb_probe(struct usb_interface *interface,
+			     const struct usb_device_id *id)
+{
+	struct stk11xx *dev = NULL;
+	struct usb_device *udev = interface_to_usbdev(interface);
+	struct usb_host_interface *iface_desc;
+	struct usb_endpoint_descriptor *endpoint;
+	unsigned int i;
+	int retval;
+
+	/* The interface are probed one by one. */
+	/* We are interested in the video interface (always the interface '0')*/
+	/* The interfaces '1' or '2' (if presents) are the audio control. */
+	if (interface->cur_altsetting->desc.bInterfaceNumber > 0) {
+		retval = -ENODEV;
+		goto err;
+	}
+
+	dev = kzalloc(sizeof(struct stk11xx), GFP_KERNEL);
+	if (dev == NULL) {
+		dev_err(&udev->dev, "can't alloc device info!\n");
+		retval = -ENOMEM;
+		goto err;
+	}
+
+	mutex_init(&dev->open_lock);
+	spin_lock_init(&dev->spinlock);
+	init_waitqueue_head(&dev->wait_frame);
+
+	set_bit(STK11XX_STAT_PRESENT, dev->status);
+	dev->model = (void *)id->driver_info;
+	dev->udev = udev;
+
+	dev->vsettings.fps = fps;
+
+/* TODO: check why is no driver that we can see claiming the interfaces ? */
+/* the apis say it should be done, none of the video usb drivers are doing it */
+/* NICKLAS: Claiming the interface is usefull when the driver want manage
+ * severals interfaces. */
+/*          For us, we have only one interface (the video) */
+
+	stk11xx_cam_on(dev);
+
+	/* Set up the endpoint information use only the first isoc-in */
+	/* endpoint for the current alternate setting */
+	iface_desc = interface->cur_altsetting;
+
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+		endpoint = &iface_desc->endpoint[i].desc;
+
+		if (!dev->isoc_in_endpointAddr && ((endpoint->bEndpointAddress &
+					USB_ENDPOINT_DIR_MASK) == USB_DIR_IN) &&
+				((endpoint->bmAttributes &
+					USB_ENDPOINT_XFERTYPE_MASK) ==
+				USB_ENDPOINT_XFER_ISOC)) {
+			/* we've found an isoc in endpoint */
+			dev->isoc_in_endpointAddr =
+					(endpoint->bEndpointAddress & 0xf);
+		}
+	}
+
+	if (!dev->isoc_in_endpointAddr) {
+		dev_err(&udev->dev, "can't find both isoc-in endpoint\n");
+		retval = -ENODEV;
+		goto err_free;
+	}
+
+	stk11xx_cam_off(dev);
+
+	dev->vdev = video_device_alloc();
+	if (dev->vdev == NULL) {
+		dev_err(&udev->dev, "can't allocate videodevice\n");
+		retval = -ENOMEM;
+		goto err_free;
+	}
+
+	retval = dev->model->dev_init(dev);
+	if (retval)
+		goto err_vfree;
+
+	memcpy(dev->vdev, &stk11xx_vdev_template, sizeof(*dev->vdev));
+
+	video_set_drvdata(dev->vdev, dev);
+
+	retval = video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1);
+	if (retval) {
+		dev_err(&udev->dev, "can't register video device\n");
+		goto err_vfree;
+	}
+
+	stk11xx_create_sysfs_file(dev, &class_device_attr_contrast);
+	stk11xx_create_sysfs_file(dev, &class_device_attr_whitebalance);
+	usb_set_intfdata(interface, dev);
+
+	dev_info(&udev->dev, "Syntek USB2.0 - STK-%s based webcam found and "
+		"ready\n", dev->model->name);
+
+	return 0;
+err_vfree:
+	video_device_release(dev->vdev);
+err_free:
+	kfree(dev);
+err:
+	return retval;
+}
+
+static void stk11xx_usb_disconnect(struct usb_interface *interface)
+{
+	struct stk11xx *dev = usb_get_intfdata(interface);
+	unsigned int free = 0;
+
+	class_device_remove_file(&dev->vdev->class_dev,
+					&class_device_attr_contrast);
+	class_device_remove_file(&dev->vdev->class_dev,
+					&class_device_attr_whitebalance);
+	mutex_lock(&dev->open_lock);
+	clear_bit(STK11XX_STAT_PRESENT, dev->status);
+	if (dev->vopen == 0) {
+		free++;
+		video_unregister_device(dev->vdev);
+	} else {
+		dev->model->stream_stop(dev);
+		stk11xx_isoc_cleanup(dev);
+		stk11xx_cam_off(dev);
+		dev->model->cam_asleep(dev);
+	}
+	mutex_unlock(&dev->open_lock);
+	if (free)
+		kfree(dev);
+}
+
+#ifdef CONFIG_PM
+static int stk11xx_usb_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct stk11xx *dev = usb_get_intfdata(intf);
+
+	mutex_lock(&dev->open_lock);
+	if (dev->vopen) {
+		dev->model->stream_stop(dev);
+		stk11xx_isoc_cleanup(dev);
+		stk11xx_cam_off(dev);
+		dev->model->cam_asleep(dev);
+	}
+	mutex_unlock(&dev->open_lock);
+	return 0;
+}
+
+static int stk11xx_usb_resume(struct usb_interface *intf)
+{
+	struct stk11xx *dev = usb_get_intfdata(intf);
+
+	mutex_lock(&dev->open_lock);
+	if (dev->vopen && test_bit(STK11XX_STAT_PRESENT, dev->status)) {
+		if (stk11xx_select_video_mode(dev, dev->view.x, dev->view.y)) {
+			dev_err(&dev->udev->dev, "Select video mode failed\n");
+			return -EINVAL;
+		}
+
+		dev->model->cam_init(dev);
+		stk11xx_cam_on(dev);
+		dev->model->cam_reconf(dev);
+		stk11xx_isoc_init(dev);
+		dev->model->stream_start(dev);
+	}
+	mutex_unlock(&dev->open_lock);
+	return 0;
+}
+#else
+#define stk11xx_usb_suspend NULL
+#define stk11xx_usb_resume NULL
+#endif
+
+static struct usb_device_id stk11xx_usb_ids[] = {
+	{ USB_DEVICE(USB_SYNTEK1_VENDOR_ID, USB_STK1125_PRODUCT_ID),
+		.driver_info = (unsigned long)&stk_model_1125 },
+	{ USB_DEVICE(USB_SYNTEK1_VENDOR_ID, USB_STK1135_PRODUCT_ID),
+		.driver_info = (unsigned long)&stk_model_1135 },
+	{ USB_DEVICE(USB_SYNTEK1_VENDOR_ID, USB_STKDCNEW_PRODUCT_ID),
+		.driver_info = (unsigned long)&stk_model_dcnew},
+	{ USB_DEVICE(USB_SYNTEK2_VENDOR_ID, USB_DC1125_PRODUCT_ID),
+		.driver_info = (unsigned long)&stk_model_1125 },
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, stk11xx_usb_ids);
+
+static struct usb_driver stk11xx_usb_driver = {
+	.name = "stk11xx",
+	.id_table = stk11xx_usb_ids,
+	.probe = stk11xx_usb_probe,
+	.disconnect = stk11xx_usb_disconnect,
+	.suspend = stk11xx_usb_suspend,
+	.resume = stk11xx_usb_resume,
+};
+
+static int __init stk11xx_init(void)
+{
+	int result;
+
+	if (fps < 10 || fps > 30) {
+		printk(KERN_ERR "stk11xx: framerate out of bounds "
+				"[10-30]\n");
+		return -EINVAL;
+	}
+
+	result = usb_register(&stk11xx_usb_driver);
+	if (result)
+		printk(KERN_ERR "stk11xx: usb_register failed!\n");
+
+	return result;
+}
+
+static void __exit stk11xx_exit(void)
+{
+	usb_deregister(&stk11xx_usb_driver);
+}
+
+module_init(stk11xx_init);
+module_exit(stk11xx_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jiri Slaby");
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_SUPPORTED_DEVICE("Syntek USB Camera: DC1125, STK1135");
diff -puN /dev/null drivers/media/video/stk11xx-v4l.c
--- /dev/null
+++ a/drivers/media/video/stk11xx-v4l.c
@@ -0,0 +1,790 @@
+/*
+ * STK V4L layer stuff
+ *
+ * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
+ *
+ * Based on Nicolas VIVIEN's driver
+ *
+ * Licences
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/usb.h>
+#include <linux/vmalloc.h>
+
+#include "stk11xx.h"
+
+/*
+ * helper functions
+ */
+
+static void stk11xx_free_buffers(struct stk11xx *dev);
+
+static int stk11xx_allocate_buffers(struct stk11xx *dev)
+{
+	unsigned int i;
+
+	dev_dbg(&dev->udev->dev, "%s\n", __FUNCTION__);
+
+	/* Allocate isochronous pipe buffers */
+	for (i = 0; i < MAX_ISO_BUFS; i++)
+		if (dev->isobuf[i].data == NULL) {
+			dev->isobuf[i].data = kzalloc(ISO_BUFFER_SIZE,
+					GFP_KERNEL);
+			if (dev->isobuf[i].data == NULL) {
+				dev_err(&dev->udev->dev, "failed to allocate "
+					"iso buffer %d\n", i);
+				goto err;
+			}
+		}
+
+	/* Create frame buffers and make circular ring */
+	for (i = 0; i < STK11XX_FRAMEBUF_COUNT; i++)
+		if (dev->framebuf[i].data == NULL) {
+			dev->framebuf[i].data = vmalloc(STK11XX_FRAME_SIZE);
+			if (dev->framebuf[i].data == NULL) {
+				dev_err(&dev->udev->dev, "failed to allocate "
+						"frame buffer %d\n", i);
+				goto err;
+			}
+			memset(dev->framebuf[i].data, 0, STK11XX_FRAME_SIZE);
+		}
+
+	/* Allocate image buffer; double buffer for mmap() */
+	dev->image_data = vmalloc_32_user(STK11XX_MAX_IMAGES *
+				STK11XX_IMAGE_LEN);
+	if (dev->image_data == NULL) {
+		dev_err(&dev->udev->dev, "failed to allocate image buffer(s). "
+			"needed (%lu)\n", STK11XX_MAX_IMAGES*STK11XX_IMAGE_LEN);
+		goto err;
+	}
+
+	for (i = 0; i < STK11XX_MAX_IMAGES; i++)
+		dev->images[i].offset = i * STK11XX_IMAGE_LEN;
+
+	return 0;
+err:
+	stk11xx_free_buffers(dev);
+	return -ENOMEM;
+}
+
+static void stk11xx_free_buffers(struct stk11xx *dev)
+{
+	unsigned int i;
+
+	dev_dbg(&dev->udev->dev, "%s\n", __FUNCTION__);
+
+	if (WARN_ON(dev == NULL))
+		return;
+
+	/* Release iso pipe buffers */
+	for (i = 0; i < MAX_ISO_BUFS; i++)
+		if (dev->isobuf[i].data != NULL) {
+			kfree(dev->isobuf[i].data);
+			dev->isobuf[i].data = NULL;
+		}
+
+	/* Release frame buffers */
+	for (i = 0; i < STK11XX_FRAMEBUF_COUNT; i++)
+		if (dev->framebuf[i].data != NULL) {
+			vfree(dev->framebuf[i].data);
+			dev->framebuf[i].data = NULL;
+		}
+
+	/* Release image buffers */
+	if (dev->image_data != NULL)
+		vfree(dev->image_data);
+
+	dev->image_data = NULL;
+}
+
+static int stk11xx_reset_buffers(struct stk11xx *dev)
+{
+	unsigned long flags;
+	unsigned int i;
+
+	dev_dbg(&dev->udev->dev, "%s\n", __FUNCTION__);
+
+	spin_lock_irqsave(&dev->spinlock, flags);
+
+	dev->full_frames = NULL;
+	dev->full_frames_tail = NULL;
+
+	for (i = 0; i < STK11XX_MAX_IMAGES; i++) {
+		dev->framebuf[i].filled = 0;
+
+		if (i > 0)
+			dev->framebuf[i].next = &dev->framebuf[i - 1];
+		else
+			dev->framebuf->next = NULL;
+		dev->images[i].flags = 0;
+	}
+
+	dev->empty_frames = &dev->framebuf[STK11XX_MAX_IMAGES - 1];
+	dev->empty_frames_tail = dev->framebuf;
+	dev->read_frame = NULL;
+	dev->fill_frame = dev->empty_frames;
+	dev->empty_frames = dev->empty_frames->next;
+
+	dev->image_read_pos = 0;
+	dev->fill_image = 0;
+
+	spin_unlock_irqrestore(&dev->spinlock, flags);
+
+	return 0;
+}
+
+/*
+ * This function gets called for the isochronous pipe. This function is only
+ * called when a frame is ready. So we have to be fast to decompress the data.
+ */
+static int stk11xx_handle_frame(struct stk11xx *dev)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	STK_STREAM("Sync Handle Frame\n");
+
+	spin_lock_irqsave(&dev->spinlock, flags);
+
+	if (dev->read_frame != NULL) {
+		spin_unlock_irqrestore(&dev->spinlock, flags);
+		return ret;
+	}
+
+	if (dev->full_frames != NULL) {
+		dev->read_frame = dev->full_frames;
+		dev->full_frames = dev->full_frames->next;
+		dev->read_frame->next = NULL;
+	}
+
+	if (dev->read_frame != NULL) {
+		spin_unlock_irqrestore(&dev->spinlock, flags);
+		ret = stk11xx_decompress(dev);
+		spin_lock_irqsave(&dev->spinlock, flags);
+
+		if (dev->empty_frames == NULL) {
+			dev->empty_frames = dev->read_frame;
+			dev->empty_frames_tail = dev->empty_frames;
+		} else {
+			dev->empty_frames_tail->next = dev->read_frame;
+			dev->empty_frames_tail = dev->read_frame;
+		}
+
+		dev->read_frame = NULL;
+	}
+
+	spin_unlock_irqrestore(&dev->spinlock, flags);
+
+	stk11xx_cam_watchdog(dev);
+
+	return ret;
+}
+
+/* called when an image is ready to prepare the next image */
+static void stk11xx_next_image(struct stk11xx *dev)
+{
+	STK_STREAM("Select next image\n");
+
+	dev->images[dev->fill_image].flags = 0;
+	dev->fill_image = (dev->fill_image + 1) % STK11XX_MAX_IMAGES;
+}
+
+
+/*
+ * fops
+ */
+
+static int stk11xx_open(struct inode *inode, struct file *fp)
+{
+	struct video_device *vdev = video_devdata(fp);
+	struct stk11xx *dev = video_get_drvdata(vdev);
+	int retval;
+
+	BUG_ON(dev == NULL);
+
+	nonseekable_open(inode, fp);
+
+	if (mutex_lock_interruptible(&dev->open_lock))
+		return -ERESTARTSYS;
+
+	if (!test_bit(STK11XX_STAT_PRESENT, dev->status)) {
+		retval = -ENODEV;
+		goto end;
+	}
+
+	if (dev->vopen) {
+		retval = -EBUSY;
+		goto end;
+	}
+
+	retval = stk11xx_allocate_buffers(dev);
+	if (retval < 0) {
+		dev_err(&dev->udev->dev, "failed to allocate buffer memory\n");
+		goto end;
+	}
+
+	stk11xx_reset_buffers(dev);
+
+	dev->vsettings.contrast = 0x7c;
+	dev->vsettings.whiteness = 0x80;
+	dev->vsettings.pixformat = V4L2_PIX_FMT_BGR24;
+
+	stk11xx_select_video_mode(dev, 640, 480);
+
+	dev->model->cam_init(dev);
+	stk11xx_cam_on(dev);
+	dev->model->cam_reconf(dev);
+
+	retval = stk11xx_isoc_init(dev);
+	if (retval) {
+		dev_err(&dev->udev->dev, "failed to init ISOC stuff\n");
+		stk11xx_isoc_cleanup(dev);
+		stk11xx_free_buffers(dev);
+		goto end;
+	}
+
+	dev->model->stream_start(dev);
+	dev->model->cam_setting(dev);
+
+	dev->vopen++;
+	fp->private_data = dev;
+	retval = 0;
+end:
+	mutex_unlock(&dev->open_lock);
+
+	return retval;
+}
+
+static int stk11xx_release(struct inode *inode, struct file *fp)
+{
+	struct stk11xx *dev = fp->private_data;
+	unsigned int free = 0;
+
+	BUG_ON(dev == NULL);
+
+	mutex_lock(&dev->open_lock);
+	if (dev->vopen == 0)
+		dev_warn(&dev->udev->dev, "v4l_release called on closed "
+				"device\n");
+
+	if (--dev->vopen == 0) {
+		dev->model->stream_stop(dev);
+		stk11xx_isoc_cleanup(dev);
+		stk11xx_free_buffers(dev);
+		stk11xx_cam_off(dev);
+		dev->model->cam_asleep(dev);
+		if (!test_bit(STK11XX_STAT_PRESENT, dev->status)) {
+			free++;
+			video_unregister_device(dev->vdev);
+		}
+	}
+	mutex_unlock(&dev->open_lock);
+
+	if (free)
+		kfree(dev);
+
+	return 0;
+}
+
+static ssize_t stk11xx_read(struct file *fp, char __user *buf, size_t count,
+		loff_t *f_pos)
+{
+	struct stk11xx *dev = fp->private_data;
+	void *image_buffer_addr;
+	int bytes_to_read, retval;
+
+	STK_STREAM("Read buf=0x%p, count=%zd\n", buf, count);
+
+	if (dev->image_read_pos == 0) {
+		if ((fp->f_flags & O_NONBLOCK) && dev->full_frames == NULL)
+			return -EWOULDBLOCK;
+
+		retval = wait_event_interruptible(dev->wait_frame,
+			dev->full_frames != NULL);
+
+		if (retval)
+			return retval;
+
+		if (stk11xx_handle_frame(dev))
+			return -EFAULT;
+	}
+
+	bytes_to_read = dev->image_size;
+
+	if (count + dev->image_read_pos > bytes_to_read)
+		count = bytes_to_read - dev->image_read_pos;
+
+	image_buffer_addr = dev->image_data;
+	image_buffer_addr += dev->images[dev->fill_image].offset;
+	image_buffer_addr += dev->image_read_pos;
+
+	if (copy_to_user(buf, image_buffer_addr, count))
+		return -EFAULT;
+
+	dev->image_read_pos += count;
+
+	if (dev->image_read_pos >= bytes_to_read) {
+		dev->image_read_pos = 0;
+		stk11xx_next_image(dev);
+	}
+
+	return count;
+}
+
+static unsigned int stk11xx_poll(struct file *fp, poll_table * wait)
+{
+	struct stk11xx *dev = fp->private_data;
+
+	STK_STREAM("Poll\n");
+
+	poll_wait(fp, &dev->wait_frame, wait);
+
+	if (dev->full_frames != NULL)
+		return (POLLIN | POLLRDNORM);
+
+	return 0;
+}
+
+static int stk11xx_mmap(struct file *fp, struct vm_area_struct *vma)
+{
+	struct stk11xx *dev = fp->private_data;
+	unsigned long pos, size = vma->vm_end - vma->vm_start;
+	unsigned int i;
+
+	/* Find the buffer for this mapping... */
+	for (i = 0; i < STK11XX_MAX_IMAGES; i++) {
+		pos = dev->images[i].offset;
+
+		if ((pos >> PAGE_SHIFT) == vma->vm_pgoff)
+			break;
+	}
+
+	if (i >= STK11XX_MAX_IMAGES) {
+		dev_err(&dev->udev->dev, "mmap no buffer found\n");
+		return -EINVAL;
+	}
+
+	/* map either whole space or only one buffer! */
+	if (size > STK11XX_IMAGE_LEN && (i > 0 || (i == 0 &&
+				size != STK11XX_MAX_IMAGES*STK11XX_IMAGE_LEN)))
+		return -EINVAL;
+
+	vma->vm_flags |= VM_IO;
+
+	return remap_vmalloc_range(vma, dev->image_data, vma->vm_pgoff);
+}
+
+/*
+ * v4l functions
+ */
+
+static struct v4l2_queryctrl stk11xx_controls[] = {
+	{
+		.id      = V4L2_CID_CONTRAST,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Contrast",
+		.minimum = 0,
+		.maximum = 0xff,
+		.step    = 1,
+		.default_value = 0x7c,
+	},
+	{
+		.id      = V4L2_CID_WHITENESS,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Whiteness",
+		.minimum = 0,
+		.maximum = 0xff,
+		.step    = 1,
+		.default_value = 0x80,
+	},
+};
+
+static int stk11xx_querycap(struct file *file, void *fh,
+		struct v4l2_capability *cap)
+{
+	struct stk11xx *dev = fh;
+
+	strlcpy(cap->driver, "stk11xx", sizeof(cap->driver));
+
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
+			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->version = DRIVER_VERSION_NUM;
+	strlcpy(cap->card, dev->vdev->name, sizeof(cap->card));
+
+	if (usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info)) < 0)
+		strlcpy(cap->bus_info, dev->vdev->name, sizeof(cap->bus_info));
+
+	return 0;
+}
+static int stk11xx_enum_input(struct file *file, void *fh, struct v4l2_input *i)
+{
+	if (i->index)
+		return -EINVAL;
+
+	strlcpy(i->name, "USB", sizeof(i->name));
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+
+	return 0;
+}
+
+static int stk11xx_g_input(struct file *file, void *fh, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int stk11xx_s_input(struct file *file, void *fh, unsigned int i)
+{
+	return i ? -EINVAL : 0;
+}
+
+static int stk11xx_queryctrl(struct file *file, void *fh,
+		struct v4l2_queryctrl *c)
+{
+	unsigned int i;
+
+	pr_debug("VIDIOC_QUERYCTRL id = %d\n", c->id);
+
+	for (i = 0; i < ARRAY_SIZE(stk11xx_controls); i++)
+		if (stk11xx_controls[i].id == c->id) {
+			pr_debug("VIDIOC_QUERYCTRL found\n");
+			memcpy(c, &stk11xx_controls[i], sizeof(*c));
+			break;
+		}
+
+	if (i >= ARRAY_SIZE(stk11xx_controls))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int stk11xx_g_ctrl(struct file *file, void *fh, struct v4l2_control *c)
+{
+	struct stk11xx *dev = fh;
+
+	dev_dbg(&dev->udev->dev, "GET CTRL id=%d\n", c->id);
+
+	switch (c->id) {
+	case V4L2_CID_CONTRAST:
+		c->value = dev->vsettings.contrast;
+		break;
+	case V4L2_CID_WHITENESS:
+		c->value = dev->vsettings.whiteness;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int stk11xx_s_ctrl(struct file *file, void *fh, struct v4l2_control *c)
+{
+	struct stk11xx *dev = fh;
+
+	dev_dbg(&dev->udev->dev, "SET CTRL id=%d\n", c->id);
+
+	switch (c->id) {
+	case V4L2_CID_CONTRAST:
+		dev->vsettings.contrast = c->value;
+		break;
+	case V4L2_CID_WHITENESS:
+		dev->vsettings.whiteness = c->value;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return dev->model->cam_setting(dev) ? -EIO : 0;
+}
+
+static int stk11xx_enum_fmt_cap(struct file *file, void *fh,
+		struct v4l2_fmtdesc *fmtd)
+{
+	u32 index = fmtd->index;
+
+	pr_debug("VIDIOC_ENUM_FMT %d\n", index);
+
+	if (index)
+		return -EINVAL;
+
+	fmtd->pixelformat = V4L2_PIX_FMT_BGR24;
+	strcpy(fmtd->description, "rgb24");
+
+	return 0;
+}
+
+static int stk11xx_g_fmt_cap(struct file *file, void *fh,
+		struct v4l2_format *fmtd)
+{
+	struct stk11xx *dev = fh;
+	struct v4l2_pix_format *pix = &fmtd->fmt.pix;
+
+	pix->width = dev->view.x;
+	pix->height = dev->view.y;
+	pix->pixelformat = V4L2_PIX_FMT_BGR24;
+	pix->field = V4L2_FIELD_NONE;
+	pix->bytesperline = 3 * pix->width;
+	pix->sizeimage = pix->width * pix->height * 3;
+	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	pix->priv = 0;
+
+	return 0;
+}
+
+static int stk11xx_s_fmt_cap(struct file *file, void *fh,
+		struct v4l2_format *fmtd)
+{
+	struct stk11xx *dev = fh;
+	struct v4l2_pix_format *pix = &fmtd->fmt.pix;
+
+	dev_dbg(&dev->udev->dev, "set width=%d, height=%d\n", pix->width,
+			pix->height);
+
+	if (pix->pixelformat && pix->pixelformat != V4L2_PIX_FMT_BGR24)
+		return -EINVAL;
+
+	if (stk11xx_check_image_size(dev, &pix->width, &pix->height))
+		return -EINVAL;
+
+	dev->model->stream_stop(dev);
+	stk11xx_isoc_cleanup(dev);
+	stk11xx_cam_off(dev);
+	dev->model->cam_asleep(dev);
+
+	/* Reset buffers and parameters */
+	stk11xx_reset_buffers(dev);
+
+	if (stk11xx_select_video_mode(dev, pix->width, pix->height)) {
+		dev_err(&dev->udev->dev, "Select video mode failed\n");
+		return -EINVAL;
+	}
+
+	dev->model->cam_init(dev);
+	stk11xx_cam_on(dev);
+	dev->model->cam_reconf(dev);
+	stk11xx_isoc_init(dev);
+	dev->model->stream_start(dev);
+	dev->model->cam_setting(dev);
+
+	return 0;
+}
+
+static int stk11xx_try_fmt_cap(struct file *file, void *fh,
+		struct v4l2_format *fmtd)
+{
+	struct v4l2_pix_format *pix = &fmtd->fmt.pix;
+
+	if (pix->pixelformat != V4L2_PIX_FMT_BGR24)
+		return -EINVAL;
+
+	stk11xx_check_image_size(fh, &pix->width, &pix->height);
+
+	return 0;
+}
+
+static int stk11xx_querystd(struct file *file, void *fh, v4l2_std_id *a)
+{
+	*a = V4L2_STD_ALL;
+	return 0;
+}
+
+static int stk11xx_s_std(struct file *file, void *fh, v4l2_std_id *a)
+{
+	return *a == V4L2_STD_ALL ? 0 : -EINVAL;
+}
+
+static int stk11xx_reqbufs(struct file *file, void *fh,
+		struct v4l2_requestbuffers *rb)
+{
+	if (rb->memory != V4L2_MEMORY_MMAP)
+		return -EINVAL;
+
+	rb->count = STK11XX_MAX_IMAGES;
+
+	return 0;
+}
+
+static int stk11xx_querybuf(struct file *file, void *fh,
+		struct v4l2_buffer *buf)
+{
+	struct stk11xx *dev = fh;
+	u32 index = buf->index;
+
+	dev_dbg(&dev->udev->dev, "QUERY BUFFERS %d\n", buf->index);
+
+	if (index >= STK11XX_MAX_IMAGES)
+		return -EINVAL;
+
+	memset(buf, 0, sizeof(struct v4l2_buffer));
+
+	buf->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	buf->index = index;
+	buf->memory = V4L2_MEMORY_MMAP;
+	buf->m.offset = index * STK11XX_IMAGE_LEN;
+	buf->bytesused = dev->image_size;
+	buf->field = V4L2_FIELD_NONE;
+	buf->length = STK11XX_IMAGE_LEN;
+	buf->flags = V4L2_BUF_FLAG_MAPPED | dev->images[index].flags;
+	if (dev->full_frames != NULL)
+		buf->flags |= V4L2_BUF_FLAG_DONE;
+
+	return 0;
+}
+
+static int stk11xx_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+{
+	struct stk11xx *dev = fh;
+
+	dev_dbg(&dev->udev->dev, "VIDIOC_QBUF\n");
+
+	if (buf->memory != V4L2_MEMORY_MMAP)
+		return -EINVAL;
+
+	if (buf->index >= STK11XX_MAX_IMAGES)
+		return -EINVAL;
+
+	if (dev->images[buf->index].flags & V4L2_BUF_FLAG_QUEUED)
+		return -EBUSY;
+
+	dev->images[buf->index].flags |= V4L2_BUF_FLAG_QUEUED;
+	buf->flags |= V4L2_BUF_FLAG_QUEUED;
+	buf->flags &= ~V4L2_BUF_FLAG_DONE;
+
+	return 0;
+}
+
+static int stk11xx_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
+{
+	struct stk11xx *dev = fh;
+	int retval;
+
+	dev_dbg(&dev->udev->dev, "VIDIOC_DQBUF\n");
+
+	if (dev->full_frames == NULL && (file->f_flags & O_NONBLOCK))
+		return -EAGAIN;
+
+	retval = wait_event_interruptible(dev->wait_frame,
+			dev->full_frames != NULL);
+	if (retval)
+		return retval;
+
+	dev_dbg(&dev->udev->dev, "VIDIOC_DQBUF: frame ready\n");
+
+	retval = stk11xx_handle_frame(dev);
+
+	if (retval)
+		return -EFAULT;
+
+	buf->index = dev->fill_image;
+	buf->bytesused = dev->image_size;
+	buf->flags = V4L2_BUF_FLAG_MAPPED | V4L2_BUF_FLAG_DONE;
+	buf->field = V4L2_FIELD_NONE;
+	do_gettimeofday(&buf->timestamp);
+	buf->sequence = 0;
+	buf->memory = V4L2_MEMORY_MMAP;
+	buf->m.offset = dev->fill_image * STK11XX_IMAGE_LEN;
+	buf->length = buf->bytesused;
+
+	stk11xx_next_image(dev);
+
+	return 0;
+}
+
+static int stk11xx_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
+{
+	return i == V4L2_BUF_TYPE_VIDEO_CAPTURE ? stk11xx_isoc_init(fh):-EINVAL;
+}
+
+static int stk11xx_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
+{
+	return i == V4L2_BUF_TYPE_VIDEO_CAPTURE ?
+		stk11xx_isoc_cleanup(fh), 0 : -EINVAL;
+}
+
+static int stk11xx_g_parm(struct file *file, void *fh,
+		struct v4l2_streamparm *sp)
+{
+	pr_debug("GET PARM %d\n", sp->type);
+
+	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	sp->parm.capture.capability = 0;
+	sp->parm.capture.capturemode = 0;
+	sp->parm.capture.timeperframe.numerator = 1;
+	sp->parm.capture.timeperframe.denominator = 30;
+	sp->parm.capture.readbuffers = 2;
+	sp->parm.capture.extendedmode = 0;
+
+	return 0;
+}
+
+#ifdef CONFIG_VIDEO_V4L1_COMPAT
+static int stk11xx_gmbuf(struct file *file, void *fh, struct video_mbuf *vm)
+{
+	struct stk11xx *dev = fh;
+	unsigned int i;
+
+	dev_dbg(&dev->udev->dev, "VIDIOCGMBUF\n");
+
+	vm->size = STK11XX_MAX_IMAGES * STK11XX_IMAGE_LEN;
+	vm->frames = STK11XX_MAX_IMAGES;
+
+	for (i = 0; i < STK11XX_MAX_IMAGES; i++)
+		vm->offsets[i] = i * STK11XX_IMAGE_LEN;
+
+	return 0;
+}
+#else
+#define stk11xx_gmbuf NULL
+#endif
+
+static struct file_operations stk11xx_fops = {
+	.owner = THIS_MODULE,
+	.open = stk11xx_open,
+	.release = stk11xx_release,
+	.read = stk11xx_read,
+	.poll = stk11xx_poll,
+	.mmap = stk11xx_mmap,
+	.ioctl = video_ioctl2
+};
+
+const struct video_device stk11xx_vdev_template = {
+	.name = DRIVER_DESC,
+
+	.type2 = VID_TYPE_CAPTURE,
+	.tvnorms = V4L2_STD_UNKNOWN,
+	.current_norm = V4L2_STD_UNKNOWN,
+	.fops = &stk11xx_fops,
+	.release = video_device_release,
+	.minor = -1,
+
+	.vidioc_querycap = stk11xx_querycap,
+	.vidioc_enum_input = stk11xx_enum_input,
+	.vidioc_g_input = stk11xx_g_input,
+	.vidioc_s_input = stk11xx_s_input,
+	.vidioc_queryctrl = stk11xx_queryctrl,
+	.vidioc_g_ctrl = stk11xx_g_ctrl,
+	.vidioc_s_ctrl = stk11xx_s_ctrl,
+	.vidioc_enum_fmt_cap = stk11xx_enum_fmt_cap,
+	.vidioc_g_fmt_cap = stk11xx_g_fmt_cap,
+	.vidioc_s_fmt_cap = stk11xx_s_fmt_cap,
+	.vidioc_try_fmt_cap = stk11xx_try_fmt_cap,
+	.vidioc_querystd = stk11xx_querystd,
+	.vidioc_s_std = stk11xx_s_std,
+	.vidioc_reqbufs = stk11xx_reqbufs,
+	.vidioc_querybuf = stk11xx_querybuf,
+	.vidioc_qbuf = stk11xx_qbuf,
+	.vidioc_dqbuf = stk11xx_dqbuf,
+	.vidioc_streamon = stk11xx_streamon,
+	.vidioc_streamoff = stk11xx_streamoff,
+	.vidioc_g_parm = stk11xx_g_parm,
+
+	.vidiocgmbuf = stk11xx_gmbuf,
+};
diff -puN /dev/null drivers/media/video/stk11xx.h
--- /dev/null
+++ a/drivers/media/video/stk11xx.h
@@ -0,0 +1,217 @@
+/*
+ * common include file
+ *
+ * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
+ *
+ * Based on Nicolas VIVIEN's driver
+ *
+ * Licences
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#ifndef STK11XX_H
+#define STK11XX_H
+
+#include <linux/mutex.h>
+#include <linux/types.h>
+#include <linux/version.h>
+#include <linux/wait.h>
+#include <media/v4l2-common.h>
+
+#define DRIVER_DESC			"Syntek USB Video Camera"
+#define DRIVER_VERSION			"v1.0"
+#define DRIVER_VERSION_NUM		KERNEL_VERSION(0, 1, 0)
+
+/**
+ * @def MAX_ISO_BUFS
+ *   Number maximal of ISOC buffers
+ *
+ * @def ISO_FRAMES_PER_DESC
+ *   Number frames per ISOC descriptor
+ *
+ * @def ISO_MAX_FRAME_SIZE
+ *   Maximale size of frame
+ *
+ * @def ISO_BUFFER_SIZE
+ *   Maximal size of buffer
+ */
+#define MAX_ISO_BUFS		16 /* 2 */
+#define ISO_FRAMES_PER_DESC	10
+#define ISO_MAX_FRAME_SIZE	3 * 1024
+#define ISO_BUFFER_SIZE		(ISO_FRAMES_PER_DESC * ISO_MAX_FRAME_SIZE)
+
+/**
+ * @def STK11XX_FRAME_SIZE
+ *   Maximum size after decompression
+ */
+#define STK11XX_MAX_IMAGES	2
+#define STK11XX_FRAME_SIZE	(1280 * 1024)
+#define STK11XX_IMAGE_LEN	PAGE_ALIGN(1280 * 1024 * 3)
+#define STK11XX_FRAMEBUF_COUNT	3
+
+#ifndef STK11XX_DEBUG_STREAM
+#define STK11XX_DEBUG_STREAM	0
+#endif
+
+#if STK11XX_DEBUG_STREAM
+#define STK_STREAM(str, args...)	printk(KERN_DEBUG "stk11xx: " str, \
+									##args)
+#else
+#define STK_STREAM(str, args...)	do { } while (0)
+#endif
+
+enum {
+	SYNTEK_STK1125 = 1,
+	SYNTEK_STK1135 = 2,
+	SYNTEK_STKDCNEW = 3
+};
+
+enum {
+	STK11XX_80x60,
+	STK11XX_160x120,
+	STK11XX_320x240,
+	STK11XX_640x480,
+	STK11XX_800x600,
+	STK11XX_1024x768,
+	STK11XX_1280x1024,
+	STK11XX_NBR_SIZES
+};
+
+struct stk11xx_table {
+	u16 addr;
+	u8 val;
+	u8 type;
+};
+
+struct stk11xx_iso_buf {
+	void *data;
+	struct urb *urb;
+};
+
+struct stk11xx_frame_buf {
+	void *data;
+	unsigned int filled;
+	struct stk11xx_frame_buf *next;
+};
+
+struct stk11xx_image_buf {
+	unsigned long offset;
+	u32 flags;
+};
+
+struct stk11xx_coord {
+	unsigned int x;
+	unsigned int y;
+};
+
+struct stk11xx_video {
+	unsigned int fps;
+	int contrast;
+	int whiteness;
+	u32 pixformat;
+};
+
+struct stk11xx;
+
+struct stk_model {
+	unsigned int model;
+	char *name;
+	/*
+	 * It's the start. This function has to be called at first, before
+	 * enabling the video stream.
+	 */
+	int (*dev_init)(struct stk11xx *);
+	int (*dev_configure)(struct stk11xx *, unsigned int);
+
+	int (*cam_init)(struct stk11xx *);
+	int (*cam_setting)(struct stk11xx *);
+	int (*cam_asleep)(struct stk11xx *);
+	/* Before enabling the video stream, you have to reconfigure the
+	 * device */
+	int (*cam_reconf)(struct stk11xx *);
+
+	/*
+	 * After the initialization of the device and the initialization of
+	 * the video stream, this function enables the stream.
+	 */
+	int (*stream_start)(struct stk11xx *);
+	int (*stream_stop)(struct stk11xx *);
+};
+
+/* flags used in struct stk11xx.status */
+#define STK11XX_STAT_PRESENT	0
+#define STK11XX_STAT_ISOC	1
+
+struct stk11xx {
+	struct video_device *vdev;
+	struct usb_device *udev;
+
+	struct stk_model *model;
+
+	u8 isoc_in_endpointAddr;	/**< Isochrone IN endpoint address */
+
+	struct stk11xx_video vsettings;	/**< Video settings (contrast, whiteness...) */
+
+	struct mutex open_lock;
+	unsigned int vopen;
+	DECLARE_BITMAP(status, 16);
+
+	spinlock_t spinlock;
+	wait_queue_head_t wait_frame;
+
+	/* isoc */
+	struct stk11xx_iso_buf isobuf[MAX_ISO_BUFS];
+
+	/* frame */
+	unsigned int frame_size;
+	struct stk11xx_frame_buf framebuf[STK11XX_FRAMEBUF_COUNT];
+	struct stk11xx_frame_buf *empty_frames, *empty_frames_tail;
+	struct stk11xx_frame_buf *full_frames, *full_frames_tail;
+	struct stk11xx_frame_buf *fill_frame;
+	struct stk11xx_frame_buf *read_frame;
+
+	/* image */
+	unsigned int image_size;
+	void *image_data;
+	struct stk11xx_image_buf images[STK11XX_MAX_IMAGES];
+	int image_read_pos;
+	int fill_image;
+	unsigned int resolution;
+	struct stk11xx_coord view;
+};
+
+extern struct stk_model stk_model_1125, stk_model_1135, stk_model_dcnew;
+extern const struct video_device stk11xx_vdev_template;
+
+extern int stk11xx_decompress(struct stk11xx *);
+extern int stk11xx_check_image_size(struct stk11xx *, unsigned int *,
+		unsigned int *);
+extern int stk11xx_select_video_mode(struct stk11xx *, int, int);
+
+extern int stk11xx_isoc_init(struct stk11xx *);
+extern void stk11xx_isoc_cleanup(struct stk11xx *);
+
+extern int stk11xx_read_reg(struct stk11xx *, u16, u8 *);
+extern int stk11xx_write_reg(struct stk11xx *, u16, u16);
+extern int stk11xx_process_table(struct stk11xx *,
+		const struct stk11xx_table *);
+extern int stk11xx_check_device(struct stk11xx *, unsigned int);
+extern int stk11xx_set_feature(struct stk11xx *, int);
+
+extern int stk11xx_cam_on(struct stk11xx *);
+extern int stk11xx_cam_off(struct stk11xx *);
+extern int stk11xx_cam_watchdog(struct stk11xx *);
+
+static inline int stk11xx_read_dummy(struct stk11xx *dev, u16 index)
+{
+	u8 value;
+
+	return stk11xx_read_reg(dev, index, &value);
+}
+
+#endif
diff -puN /dev/null drivers/media/video/stkdcnew.c
--- /dev/null
+++ a/drivers/media/video/stkdcnew.c
@@ -0,0 +1,669 @@
+/*
+ * STK-6A31 part
+ *
+ * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
+ *
+ * Based on Nicolas VIVIEN's driver
+ *
+ * Licences
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/usb.h>
+#include <linux/types.h>
+
+#include "stk11xx.h"
+
+/*
+ * WARNING, the microcode can be different following the situation.
+ */
+static int stkdcnew_load_microcode(struct stk11xx *dev)
+{
+	unsigned int i;
+	int retok;
+
+	const u8 values_204[] = {
+		0xf0, 0xf1, 0x0d, 0xf1, 0x0d, 0xf1, 0xf0, 0xf1, 0x35, 0xf1,
+		0xf0, 0xf1, 0x06, 0xf1, 0xf0, 0xf1, 0xdd, 0xf1, 0xf0, 0xf1,
+		0x1f, 0xf1, 0x20, 0xf1, 0x21, 0xf1, 0x22, 0xf1, 0x23, 0xf1,
+		0x24, 0xf1, 0x28, 0xf1, 0x29, 0xf1, 0x5e, 0xf1, 0x5f, 0xf1,
+		0x60, 0xf1, 0xef, 0xf1, 0xf2, 0xf1, 0x02, 0xf1, 0x03, 0xf1,
+		0x04, 0xf1, 0x09, 0xf1, 0x0a, 0xf1, 0x0b, 0xf1, 0x0c, 0xf1,
+		0x0d, 0xf1, 0x0e, 0xf1, 0x0f, 0xf1, 0x10, 0xf1, 0x11, 0xf1,
+		0x15, 0xf1, 0x16, 0xf1, 0x17, 0xf1, 0x18, 0xf1, 0x19, 0xf1,
+		0x1a, 0xf1, 0x1b, 0xf1, 0x1c, 0xf1, 0x1d, 0xf1, 0x1e, 0xf1,
+		0xf0, 0xf1, 0x06, 0xf1, 0x06, 0xf1, 0xf0, 0xf1, 0x80, 0xf1,
+		0x81, 0xf1, 0x82, 0xf1, 0x83, 0xf1, 0x84, 0xf1, 0x85, 0xf1,
+		0x86, 0xf1, 0x87, 0xf1, 0x88, 0xf1, 0x89, 0xf1, 0x8a, 0xf1,
+		0x8b, 0xf1, 0x8c, 0xf1, 0x8d, 0xf1, 0x8e, 0xf1, 0x8f, 0xf1,
+		0x90, 0xf1, 0x91, 0xf1, 0x92, 0xf1, 0x93, 0xf1, 0x94, 0xf1,
+		0x95, 0xf1, 0xb6, 0xf1, 0xb7, 0xf1, 0xb8, 0xf1, 0xb9, 0xf1,
+		0xba, 0xf1, 0xbb, 0xf1, 0xbc, 0xf1, 0xbd, 0xf1, 0xbe, 0xf1,
+		0xbf, 0xf1, 0xc0, 0xf1, 0xc1, 0xf1, 0xc2, 0xf1, 0xc3, 0xf1,
+		0xc4, 0xf1, 0x06, 0xf1, 0xf0, 0xf1, 0x53, 0xf1, 0x54, 0xf1,
+		0x55, 0xf1, 0x56, 0xf1, 0x57, 0xf1, 0x58, 0xf1, 0xdc, 0xf1,
+		0xdd, 0xf1, 0xde, 0xf1, 0xdf, 0xf1, 0xe0, 0xf1, 0xe1, 0xf1,
+		0xf0, 0xf1, 0xa7, 0xf1, 0xaa, 0xf1, 0x3a, 0xf1, 0xa1, 0xf1,
+		0xa4, 0xf1, 0x9b, 0xf1, 0x08, 0xf1, 0xf0, 0xf1, 0x2f, 0xf1,
+		0x9c, 0xf1, 0xd2, 0xf1, 0xcc, 0xf1, 0xcb, 0xf1, 0x2e, 0xf1,
+		0x67, 0xf1, 0xf0, 0xf1, 0x65, 0xf1, 0x66, 0xf1, 0x67, 0xf1,
+		0x65, 0xf1, 0xf0, 0xf1, 0x05, 0xf1, 0x07, 0xf1, 0xf0, 0xf1,
+		0x39, 0xf1, 0x3b, 0xf1, 0x3a, 0xf1, 0x3c, 0xf1, 0x57, 0xf1,
+		0x58, 0xf1, 0x59, 0xf1, 0x5a, 0xf1, 0x5c, 0xf1, 0x5d, 0xf1,
+		0x64, 0xf1, 0xf0, 0xf1, 0x5b, 0xf1, 0xf0, 0xf1, 0x36, 0xf1,
+		0x37, 0xf1, 0xf0, 0xf1, 0x08, 0xf1
+	};
+	const u8 values_205[] = {
+		0x00, 0x00, 0x00, 0x0b, 0x00, 0x08, 0x00, 0x00, 0x00, 0x22,
+		0x00, 0x01, 0x70, 0x0e, 0x00, 0x02, 0x18, 0xe0, 0x00, 0x02,
+		0x01, 0x80, 0xc8, 0x14, 0x80, 0x80, 0xa0, 0x78, 0xa0, 0x78,
+		0x5f, 0x20, 0xea, 0x02, 0x86, 0x7a, 0x59, 0x4c, 0x4d, 0x51,
+		0x00, 0x02, 0x00, 0x08, 0x00, 0x00, 0x00, 0xee, 0x39, 0x23,
+		0x07, 0x24, 0x00, 0xcd, 0x00, 0x93, 0x00, 0x04, 0x00, 0x5c,
+		0x00, 0xd9, 0x00, 0x53, 0x00, 0x08, 0x00, 0x91, 0x00, 0xcf,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x01, 0xf0, 0x0e, 0x70, 0x0e, 0x00, 0x01, 0x00, 0x07,
+		0xde, 0x13, 0xeb, 0xe2, 0x00, 0xf6, 0xe1, 0x14, 0xea, 0xdd,
+		0xfd, 0xf6, 0xe5, 0x11, 0xed, 0xe6, 0xfb, 0xf7, 0xd6, 0x13,
+		0xed, 0xec, 0xf9, 0xf2, 0x00, 0x00, 0xd8, 0x15, 0xe9, 0xea,
+		0xf9, 0xf1, 0x00, 0x02, 0xde, 0x10, 0xef, 0xef, 0xfb, 0xf4,
+		0x00, 0x02, 0x0e, 0x06, 0x27, 0x13, 0x11, 0x06, 0x27, 0x13,
+		0x0c, 0x03, 0x2a, 0x0f, 0x12, 0x08, 0x1a, 0x16, 0x00, 0x22,
+		0x15, 0x0a, 0x1c, 0x1a, 0x00, 0x2d, 0x11, 0x09, 0x14, 0x14,
+		0x00, 0x2a, 0x74, 0x0e, 0x00, 0x01, 0x0b, 0x03, 0x47, 0x22,
+		0xac, 0x82, 0xda, 0xc7, 0xf5, 0xe9, 0xff, 0x00, 0x0b, 0x03,
+		0x47, 0x22, 0xac, 0x82, 0xda, 0xc7, 0xf5, 0xe9, 0xff, 0x00,
+		0x00, 0x01, 0x02, 0x80, 0x01, 0xe0, 0x43, 0x00, 0x05, 0x00,
+		0x04, 0x00, 0x43, 0x00, 0x01, 0x80, 0x00, 0x02, 0xd1, 0x00,
+		0xd1, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x01, 0x0c, 0x3c,
+		0x10, 0x10, 0x00, 0x00, 0xa0, 0x00, 0x20, 0x03, 0x05, 0x01,
+		0x20, 0x00, 0x00, 0x00, 0x01, 0xb8, 0x00, 0xd8, 0x00, 0x02,
+		0x06, 0xc0, 0x04, 0x0e, 0x06, 0xc0, 0x05, 0x64, 0x02, 0x08,
+		0x02, 0x71, 0x02, 0x09, 0x02, 0x71, 0x12, 0x0d, 0x17, 0x12,
+		0x5e, 0x1c, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02, 0x78, 0x10,
+		0x83, 0x04, 0x00, 0x00, 0x00, 0x21
+	};
+
+
+	for (i = 0; i < ARRAY_SIZE(values_204); i++) {
+		stk11xx_read_dummy(dev, 0x02ff);
+		stk11xx_write_reg(dev, 0x02ff, 0x00);
+
+		stk11xx_write_reg(dev, 0x0203, 0xba);
+
+		stk11xx_write_reg(dev, 0x0204, values_204[i]);
+		stk11xx_write_reg(dev, 0x0205, values_205[i]);
+		stk11xx_write_reg(dev, 0x0200, 0x01);
+
+		retok = stk11xx_check_device(dev, 500);
+
+		if (retok != 1) {
+			dev_err(&dev->udev->dev, "load microcode fail!\n");
+			return -EIO;
+		}
+
+		stk11xx_write_reg(dev, 0x02ff, 0x00);
+	}
+
+	stk11xx_check_device(dev, 500);
+
+	return 0;
+}
+
+/*
+ * We don't know the meaning of these steps ! We only replay the USB log.
+ */
+static int stkdcnew_dev_configure(struct stk11xx *dev, unsigned int step)
+{
+	int ret;
+
+	/*      0,    1,    2,    3,    4,    5,    6,    7,    8,    9,
+		10,   11,   12,   13,   14,   15,   16 */
+	const u8 vals_001B[] = {
+		0x03, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x07,
+		0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07
+	};
+	const u8 vals_001C[] = {
+		0x02, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x46, 0x06,
+		0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06
+	};
+	const u8 vals_0202[] = {
+		0x0a, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e, 0x1e,
+		0x1e, 0x0a, 0x1e, 0x1f, 0x1f, 0x1f, 0x1f
+	};
+	const u8 vals_0110[] = {
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
+	};
+	const u8 vals_0112[] = {
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
+	};
+	const u8 vals_0114[] = {
+		0x80, 0x80, 0x80, 0x80, 0x00, 0xbe, 0x80, 0x80, 0x00, 0x80,
+		0x80, 0x80, 0x00, 0x80, 0x80, 0x80, 0x80
+	};
+	const u8 vals_0115[] = {
+		0x02, 0x02, 0x02, 0x02, 0x05, 0x02, 0x02, 0x02, 0x00, 0x02,
+		0x02, 0x02, 0x05, 0x02, 0x02, 0x02, 0x02
+	};
+	const u8 vals_0116[] = {
+		0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe9, 0xe0, 0xe0, 0x00, 0xe0,
+		0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0, 0xe0
+	};
+	const u8 vals_0117[] = {
+		0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x01,
+		0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
+	};
+	const u8 vals_0100[] = {
+		0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x21, 0x20,
+		0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20
+	};
+	struct stk11xx_table table_1[] = {
+		{ 0x0000, 0x24, 2 }, { 0x0002, 0x78, 2 }, { 0x0003, 0x80, 2 },
+		{ 0x0005, 0x00, 2 }, { 0x0007, 0x03, 2 }, { 0x000d, 0x00, 2 },
+		{ 0x000f, 0x02, 2 }, { 0x0300, 0x12, 2 }, { 0x0350, 0x41, 2 },
+		{ 0x0351, 0x00, 2 }, { 0x0352, 0x00, 2 }, { 0x0353, 0x00, 2 },
+		{ 0x0018, 0x10, 2 }, { 0x0019, 0x00, 2 },
+		{ 0x001b, vals_001B[step], 2 }, { 0x001c, vals_001C[step], 2 },
+		{ 0x0300, 0x80, 2 }, { 0x001a, 0x04, 2 },
+		{ 0x0202, vals_0202[step], 2 }, { 0x0110, vals_0110[step], 2 },
+		{ 0x0111, 0x00, 2 }, { 0x0112, vals_0112[step], 2 },
+		{ 0x0113, 0x00, 2 }, { 0x0114, vals_0114[step], 2 },
+		{ 0x0115, vals_0115[step], 2 }, { 0x0116, vals_0116[step], 2 },
+		{ 0x0117, vals_0117[step], 2 }, { 0x0100, 0x00, 1 },
+		{ 0x0100, vals_0100[step], 2 },/* { 0x0200, 0x80, 2 },
+		{ 0x0200, 0x00, 2 }, */{ 0x02ff, 0x00, 2 },
+		{ }
+	};
+
+	dev_dbg(&dev->udev->dev, "%s: %u\n", __func__, step);
+
+	ret = stk11xx_process_table(dev, table_1);
+	if (ret)
+		goto end;
+
+	switch (step) {
+	case 0: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x22, 2 }, { 0x0204, 0x27, 2 },
+			{ 0x0205, 0xa5, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 1: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xbf, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 2: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x42, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x24, 2 },
+			{ 0x0205, 0xa5, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 3: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x42, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xe0, 2 }, { 0x0204, 0x24, 2 },
+			{ 0x0205, 0xa5, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 4: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x42, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xbf, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 5: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xff, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 6: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xB7, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+		break;
+	}
+	case 7: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x0204, 0x12, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0204, 0x13, 2 },
+			{ 0x0205, 0xb7, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 8: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0x60, 2 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0203, 0x60, 2 },
+			{ 0x0204, 0xff, 2 }, { 0x0205, 0x01, 2 },
+			{ 0x0200, 0x01, 2 }, {    500, 0x00, 3 },
+			{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0203, 0x60, 2 },
+			{ 0x0208, 0x0a, 2 }, { 0x0200, 0x20, 2 },
+			{    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0203, 0x60, 2 },
+			{ 0x0208, 0x0b, 2 }, { 0x0200, 0x20, 2 },
+			{    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0203, 0x60, 2 },
+			{ 0x0208, 0x1c, 2 }, { 0x0200, 0x20, 2 },
+			{    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0203, 0x60, 2 },
+			{ 0x0208, 0x1d, 2 }, { 0x0200, 0x20, 2 },
+			{    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 },
+			{ }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 9: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0xdc, 2 }, { 0x0204, 0x15, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 10: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0xec, 2 }, { 0x0204, 0x15, 2 },
+			{ 0x0205, 0x80, 2 }, { 0x0200, 0x05, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 11: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0xba, 2 }, { 0x0208, 0x00, 2 },
+			{ 0x0200, 0x20, 2 }, {    500, 0x00, 3 },
+			{ 0x0209, 0x00, 1 }, { 0x02ff, 0x00, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 12: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0xba, 2 }, { 0x0204, 0xf0, 2 },
+			{ 0x0205, 0x00, 2 }, { 0x0200, 0x05, 2 },
+			{    500, 0x00, 3 }, { 0x0204, 0xf1, 2 },
+			{ 0x0205, 0x00, 2 }, { 0x0200, 0x05, 2 },
+			{    500, 0x00, 3 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0203, 0xba, 2 },
+			{ 0x0208, 0x00, 2 }, { 0x0200, 0x20, 2 },
+			{    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0203, 0xba, 2 },
+			{ 0x0208, 0xf1, 2 }, { 0x0200, 0x20, 2 },
+			{    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 13: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0xba, 2 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0203, 0xba, 2 },
+			{ 0x0208, 0x00, 2 }, { 0x0200, 0x20, 2 },
+			{    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0203, 0xba, 2 },
+			{ 0x0208, 0xf1, 2 }, { 0x0200, 0x20, 2 },
+			{    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 14: {
+		const struct stk11xx_table table[] = {
+			{ 0x0203, 0xba, 2 }, { 0x0204, 0x01, 2 },
+			{ 0x0205, 0x00, 2 }, { 0x0200, 0x05, 2 },
+			{    500, 0x00, 3 }, { 0x0204, 0xf1, 2 },
+			{ 0x0205, 0x00, 2 }, { 0x0200, 0x05, 2 },
+			{    500, 0x00, 3 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0203, 0xba, 2 },
+			{ 0x0208, 0x00, 2 }, { 0x0200, 0x20, 2 },
+			{    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x02ff, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { 0x0203, 0xba, 2 },
+			{ 0x0208, 0xf1, 2 }, { 0x0200, 0x20, 2 },
+			{    500, 0x00, 3 }, { 0x0209, 0x00, 1 },
+			{ 0x02ff, 0x00, 2 }, { }
+		};
+		ret = stk11xx_process_table(dev, table);
+
+		break;
+	}
+	case 15:
+		stk11xx_write_reg(dev, 0x0203, 0xba);
+
+		ret = stkdcnew_load_microcode(dev);
+		if (ret)
+			goto end;
+
+		stk11xx_write_reg(dev, 0x0200, 0x80);
+		stk11xx_write_reg(dev, 0x0200, 0x00);
+		stk11xx_write_reg(dev, 0x02ff, 0x01);
+		stk11xx_write_reg(dev, 0x0203, 0xa0);
+
+
+		break;
+
+	case 16:
+		stk11xx_write_reg(dev, 0x0203, 0xba);
+
+		ret = stkdcnew_load_microcode(dev);
+
+		break;
+	}
+end:
+	return ret;
+}
+
+static int stkdcnew_cam_asleep(struct stk11xx *dev)
+{
+	const struct stk11xx_table table[] = {
+		{ 0x0104, 0x00, 1 }, { 0x0105, 0x00, 1 }, { 0x0106, 0x00, 1 },
+		{ 0x0100, 0x21, 2 }, { 0x0116, 0x00, 2 }, { 0x0117, 0x00, 2 },
+		{ 0x0018, 0x00, 2 }, { 0x0000, 0x00, 1 }, { 0x0000, 0x49, 2 },
+		{ }
+	};
+
+	return stk11xx_process_table(dev, table);
+}
+
+static int stkdcnew_cam_init(struct stk11xx *dev)
+{
+	stkdcnew_cam_asleep(dev);
+
+	stk11xx_set_feature(dev, 0);
+
+	stkdcnew_cam_asleep(dev);
+
+	stk11xx_write_reg(dev, 0x0000, 0xe0);
+	stk11xx_write_reg(dev, 0x0002, 0xf8);
+	stk11xx_write_reg(dev, 0x0002, 0x78);
+	stk11xx_write_reg(dev, 0x0000, 0x20);
+
+	stkdcnew_dev_configure(dev, 15);
+
+	stk11xx_cam_off(dev);
+
+	return 0;
+}
+
+/**
+ * This functions permits to modify the settings :
+ *   - brightness
+ *   - contrast
+ *   - white balance
+ *   - ...
+ */
+static int stkdcnew_cam_setting(struct stk11xx *dev)
+{
+	unsigned int i;
+	int ret;
+
+	const u8 values_204[] = {
+		0xf0, 0xf1, 0x2e, 0xf1, 0xf0, 0xf1, 0x5b, 0xf1, 0xf0, 0xf1,
+		0x36, 0xf1, 0x37, 0xf1, 0xf0, 0xf1, 0x08, 0xf1
+	};
+	const u8 values_205[] = {
+		0x00, 0x02, 0x0c, 0x3c, 0x00, 0x02, 0x00, 0x03, 0x00, 0x02,
+		0x78, 0x10, 0x83, 0x04, 0x00, 0x00, 0x00, 0x21
+	};
+
+	/* Contrast register */
+	stk11xx_read_dummy(dev, 0x02ff);
+	stk11xx_write_reg(dev, 0x02ff, 0x00);
+
+	stk11xx_write_reg(dev, 0x0204, 0xb3);
+	stk11xx_write_reg(dev, 0x0205, (dev->vsettings.contrast >> 8));
+
+	stk11xx_write_reg(dev, 0x0200, 0x01);
+	ret = stk11xx_check_device(dev, 500);
+	stk11xx_write_reg(dev, 0x02ff, 0x00);
+
+	for (i = 0; i < ARRAY_SIZE(values_204); i++) {
+		stk11xx_read_dummy(dev, 0x02ff);
+		stk11xx_write_reg(dev, 0x02ff, 0x00);
+
+		stk11xx_write_reg(dev, 0x0204, values_204[i]);
+		stk11xx_write_reg(dev, 0x0205, values_205[i]);
+
+		stk11xx_write_reg(dev, 0x0200, 0x01);
+		ret = stk11xx_check_device(dev, 500);
+		stk11xx_write_reg(dev, 0x02ff, 0x00);
+	}
+
+	dev_dbg(&dev->udev->dev, "set contrast: %d, whiteness: %d\n",
+		dev->vsettings.contrast, dev->vsettings.whiteness);
+
+	return 0;
+}
+
+static int stkdcnew_stream_start(struct stk11xx *dev)
+{
+	u8 value_116, value_117;
+
+	stk11xx_read_dummy(dev, 0x0114); /* read 0x80 */
+	stk11xx_read_dummy(dev, 0x0115); /* read 0x02 */
+
+	stk11xx_read_reg(dev, 0x0116, &value_116);
+	stk11xx_read_reg(dev, 0x0117, &value_117);
+
+	stk11xx_write_reg(dev, 0x0116, 0x00);
+	stk11xx_write_reg(dev, 0x0117, 0x00);
+
+	stk11xx_read_dummy(dev, 0x0100); /* read 0x21 */
+	stk11xx_write_reg(dev, 0x0100, 0xa0);
+
+	stk11xx_write_reg(dev, 0x0116, value_116);
+	stk11xx_write_reg(dev, 0x0117, value_117);
+
+	return 0;
+}
+
+static int stkdcnew_cam_reconf(struct stk11xx *dev)
+{
+	stkdcnew_dev_configure(dev, 16);
+
+	stkdcnew_cam_setting(dev);
+
+	return 0;
+}
+
+static int stkdcnew_stream_stop(struct stk11xx *dev)
+{
+	return 0;
+}
+
+/*
+ * This function is written from the USB log.
+ */
+static int stkdcnew_dev_init(struct stk11xx *dev)
+{
+/*	unsigned int i;
+	int value;*/
+	int ret;
+
+/*	const struct stk11xx_table table_1[] = {
+		{ 0x0000, 0x24, 2 }, { 0x0002, 0x78, 2 }, { 0x0003, 0x80, 2 },
+		{ 0x0002, 0x7f, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x26, 2 }, { 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x25, 2 }, { 0x0002, 0x7d, 2 },
+		{ 0x0000, 0x24, 2 },
+		{ }
+	};
+	const struct stk11xx_table table_2[] = {
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x20, 2 }, { 0x0002, 0x7f, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0002, 0x7d, 2 }, { 0x0000, 0x24, 2 },
+		{ }
+	};
+	const struct stk11xx_table table_3[] = {
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x20, 2 }, { 0x0002, 0x7f, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0000, 0x24, 2 }, { 0x0000, 0x26, 2 },
+		{ 0x0000, 0x27, 2 }, { 0x0000, 0x26, 2 }, { 0x0000, 0x24, 2 },
+		{ 0x0000, 0x25, 2 }, { 0x0002, 0x7d, 2 }, { 0x0000, 0x24, 2 },
+		{ }
+	};*/
+	const struct stk11xx_table table_4[] = {
+/*		{ 0x0000, 0x25, 2 }, { 0x0000, 0x20, 2 }, { 0x0002, 0x7f, 2 },
+		{ 0x0000, 0x24, 2 }, { 0x0000, 0x20, 2 }, { 0x0117, 0x00, 2 },
+		{ 0x0103, 0x00, 1 }, { 0x0103, 0x01, 2 }, { 0x0103, 0x00, 1 },
+		{ 0x0103, 0x00, 2 },*/ { 0x0000, 0xe0, 2 }, { 0x0002, 0xf8, 2 },
+		{ 0x0002, 0x78, 2 }, { 0x0000, 0x20, 2 },
+		{      0, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      1, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      2, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      3, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      4, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      5, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      6, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      7, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{      8, 0x00, 4 },
+		{      9, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{     10, 0x00, 4 }, {     65, 0x00, 3 }, { 0x0200, 0x08, 2 },
+		{     11, 0x00, 4 }, {     12, 0x00, 4 }, {     13, 0x00, 4 },
+		{     14, 0x00, 4 },
+		{ }
+	};
+#if 0
+	ret = stk11xx_process_table(dev, table_1);
+	if (ret)
+		goto end;
+
+	for (i = 0; i < 16; i++) {
+		stk11xx_write_reg(dev, 0x0000, 0x25);
+		stk11xx_write_reg(dev, 0x0000, 0x24);
+		stk11xx_read_reg(dev, 0x0000, &value);
+
+		dev_dbg(&dev->udev->dev, "loop 1: Read 0x0000 = %02X\n", value);
+	}
+
+	ret = stk11xx_process_table(dev, table_2);
+	if (ret)
+		goto end;
+
+	for (i = 0; i < 16; i++) {
+		stk11xx_write_reg(dev, 0x0000, 0x25);
+		stk11xx_write_reg(dev, 0x0000, 0x24);
+		stk11xx_read_reg(dev, 0x0000, &value);
+
+		dev_dbg(&dev->udev->dev, "loop 2: Read 0x0000 = %02X\n", value);
+	}
+
+	ret = stk11xx_process_table(dev, table_3);
+	if (ret)
+		goto end;
+
+	for (i = 0; i < 16; i++) {
+		stk11xx_write_reg(dev, 0x0000, 0x25);
+		stk11xx_write_reg(dev, 0x0000, 0x24);
+		stk11xx_read_reg(dev, 0x0000, &value);
+
+		dev_dbg(&dev->udev->dev, "loop 3: Read 0x0000 = %02X\n", value);
+	}
+#endif
+	ret = stk11xx_process_table(dev, table_4);
+	if (ret)
+		goto end;
+
+
+	stkdcnew_cam_asleep(dev);
+
+	stk11xx_set_feature(dev, 0);
+
+end:
+	return ret;
+}
+
+struct stk_model stk_model_dcnew = {
+	.model = SYNTEK_STKDCNEW,
+	.name = "DCNEW",
+	.dev_init = stkdcnew_dev_init,
+	.dev_configure = stkdcnew_dev_configure,
+	.cam_init = stkdcnew_cam_init,
+	.cam_setting = stkdcnew_cam_setting,
+	.cam_asleep = stkdcnew_cam_asleep,
+	.cam_reconf = stkdcnew_cam_reconf,
+	.stream_start = stkdcnew_stream_start,
+	.stream_stop = stkdcnew_stream_stop,
+};
_

Patches currently in -mm which might be from jirislaby@gmail.com are

v4l-stk11xx-add-a-new-webcam-driver.patch
git-wireless.patch
crisv10-serial-driver-rewrite-take-three.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
