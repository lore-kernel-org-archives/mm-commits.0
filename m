From: akpm@linux-foundation.org
Subject: - touchkit-ps-2-touchscreen-driver.patch removed from -mm tree
Date: Thu, 15 Feb 2007 15:02:01 -0800
Message-ID: <200702152302.l1FN215V011395@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37935 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161652AbXBOXDO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 18:03:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefan@lucke.in-berlin.de, dtor@mail.ru, michal.k.k.piotrowski@gmail.com, pazke@donpac.ru, vojtech@suse.cz, mm-commits@vger.kernel.org


The patch titled
     touchkit PS/2 touchscreen driver
has been removed from the -mm tree.  Its filename was
     touchkit-ps-2-touchscreen-driver.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: touchkit PS/2 touchscreen driver
From: Stefan Lucke <stefan@lucke.in-berlin.de>

Based on the touchkit USB and livebook PS/2 touchscreen driver, I made a
driver for the touchkit PS/2 version.

The egalax touchsreen controller (PS/2 or USB version) is used in this 7"
device: http://www.cartft.com/catalog/il/449

Currently I'm using the PS/2 version in a DirectFB enviroment.

http://www.directfb.org/
http://mail.directfb.org/pipermail/directfb-dev/2005-September/000705.html
http://mail.directfb.org/pipermail/directfb-dev/2005-September/000706.html

[michal.k.k.piotrowski@gmail.com: config.h is obsolete]
[akpm@osdl.org: build fix]
Cc: Andrey Panin <pazke@donpac.ru>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Vojtech Pavlik <vojtech@suse.cz>
Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/Makefile       |    3 
 drivers/input/mouse/psmouse-base.c |   15 ++
 drivers/input/mouse/psmouse.h      |    1 
 drivers/input/mouse/touchkit_ps2.c |  192 +++++++++++++++++++++++++++
 drivers/input/mouse/touchkit_ps2.h |   18 ++
 5 files changed, 228 insertions(+), 1 deletion(-)

diff -puN drivers/input/mouse/Makefile~touchkit-ps-2-touchscreen-driver drivers/input/mouse/Makefile
--- a/drivers/input/mouse/Makefile~touchkit-ps-2-touchscreen-driver
+++ a/drivers/input/mouse/Makefile
@@ -14,4 +14,5 @@ obj-$(CONFIG_MOUSE_SERIAL)	+= sermouse.o
 obj-$(CONFIG_MOUSE_HIL)		+= hil_ptr.o
 obj-$(CONFIG_MOUSE_VSXXXAA)	+= vsxxxaa.o
 
-psmouse-objs  := psmouse-base.o alps.o logips2pp.o synaptics.o lifebook.o trackpoint.o
+psmouse-objs  := psmouse-base.o alps.o logips2pp.o synaptics.o lifebook.o \
+		trackpoint.o touchkit_ps2.o
diff -puN drivers/input/mouse/psmouse-base.c~touchkit-ps-2-touchscreen-driver drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~touchkit-ps-2-touchscreen-driver
+++ a/drivers/input/mouse/psmouse-base.c
@@ -28,6 +28,7 @@
 #include "alps.h"
 #include "lifebook.h"
 #include "trackpoint.h"
+#include "touchkit_ps2.h"
 
 #define DRIVER_DESC	"PS/2 mouse driver"
 
@@ -633,6 +634,13 @@ static int psmouse_extensions(struct psm
 	if (max_proto >= PSMOUSE_IMPS && intellimouse_detect(psmouse, set_properties) == 0)
 		return PSMOUSE_IMPS;
 
+	if (touchkit_ps2_detect(psmouse, set_properties) == 0) {
+		if (max_proto >= PSMOUSE_TOUCHKIT_PS2) {
+			if (!set_properties || touchkit_ps2_init(psmouse) == 0)
+				return PSMOUSE_TOUCHKIT_PS2;
+		}
+	}
+
 /*
  * Okay, all failed, we have a standard mouse here. The number of the buttons
  * is still a question, though. We assume 3.
@@ -719,6 +727,13 @@ static const struct psmouse_protocol psm
 		.detect		= trackpoint_detect,
 	},
 	{
+		.type		= PSMOUSE_TOUCHKIT_PS2,
+		.name		= "touchkitPS/2",
+		.alias		= "touchkit",
+		.detect		= touchkit_ps2_detect,
+		.init		= touchkit_ps2_init,
+	},
+	{
 		.type		= PSMOUSE_AUTO,
 		.name		= "auto",
 		.alias		= "any",
diff -puN drivers/input/mouse/psmouse.h~touchkit-ps-2-touchscreen-driver drivers/input/mouse/psmouse.h
--- a/drivers/input/mouse/psmouse.h~touchkit-ps-2-touchscreen-driver
+++ a/drivers/input/mouse/psmouse.h
@@ -86,6 +86,7 @@ enum psmouse_type {
 	PSMOUSE_ALPS,
 	PSMOUSE_LIFEBOOK,
 	PSMOUSE_TRACKPOINT,
+	PSMOUSE_TOUCHKIT_PS2,
 	PSMOUSE_AUTO		/* This one should always be last */
 };
 
diff -puN /dev/null drivers/input/mouse/touchkit_ps2.c
--- /dev/null
+++ a/drivers/input/mouse/touchkit_ps2.c
@@ -0,0 +1,192 @@
+/* ----------------------------------------------------------------------------
+ * touchkit_ps2.c  --  Driver for eGalax TouchKit PS/2 Touchscreens
+ *
+ * Copyright (C) 2005 by Stefan Lucke
+ * Copyright (C) 2004 by Daniel Ritz
+ * Copyright (C) by Todd E. Johnson (mtouchusb.c)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Based upon touchkitusb.c
+ *
+ * Vendor documentation is available in support section of:
+ * http://www.egalax.com.tw/
+ *
+ */
+
+/*
+ * Changelog:
+ *
+ * 2005-10-14:	whitespace & indentaion cleanup
+ *		touchkit commands defined
+ * initial version 0.1
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#include <linux/input.h>
+#include <linux/serio.h>
+#include <linux/libps2.h>
+#include <linux/dmi.h>
+
+#include "psmouse.h"
+#include "touchkit_ps2.h"
+
+#define TOUCHKIT_MIN_XC			0x0
+#define TOUCHKIT_MAX_XC			0x07ff
+#define TOUCHKIT_XC_FUZZ		0x0
+#define TOUCHKIT_XC_FLAT		0x0
+#define TOUCHKIT_MIN_YC			0x0
+#define TOUCHKIT_MAX_YC			0x07ff
+#define TOUCHKIT_YC_FUZZ		0x0
+#define TOUCHKIT_YC_FLAT		0x0
+#define TOUCHKIT_REPORT_DATA_SIZE	8
+
+#define TOUCHKIT_CMD			0x0A
+#define TOUCHKIT_CMD_LENGTH		1
+
+#define TOUCHKIT_CMD_ACTIVE		'A'
+#define TOUCHKIT_CMD_FIRMWARE_VERSION	'D'
+#define TOUCHKIT_CMD_CONTROLLER_TYPE	'E'
+
+#define TOUCHKIT_SEND_PARMS(s,r,c)	((s) << 12 | (r) << 8 | (c))
+
+#define TOUCHKIT_DOWN			0x01
+#define TOUCHKIT_POINT_TOUCH		0x81
+#define TOUCHKIT_POINT_NOTOUCH		0x80
+
+#define TOUCHKIT_GET_TOUCHED(dat)	((((dat)[0]) & TOUCHKIT_DOWN) ? 1 : 0)
+#define TOUCHKIT_GET_X(dat)		(((dat)[1] << 7) | (dat)[2])
+#define TOUCHKIT_GET_Y(dat)		(((dat)[3] << 7) | (dat)[4])
+
+#define DRIVER_VERSION			"v0.2"
+#define DRIVER_AUTHOR			"Stefan Lucke <stefan@lucke.in-berlin.de>"
+#define DRIVER_DESC			"eGalax TouchKit PS/2 Touchscreen Driver"
+
+static int xyswap = 0;
+module_param(xyswap, bool, 0644);
+MODULE_PARM_DESC(xyswap, "If set X and Y axes are swapped.");
+
+static int  xinvert = 0;
+module_param(xinvert, bool, 0644);
+MODULE_PARM_DESC(xinvert, "Invert direction of x axis.");
+
+static int  yinvert = 0;
+module_param(yinvert, bool, 0644);
+MODULE_PARM_DESC(yinvert, "Invert direction of y axis.");
+
+static int  xfuzz = 0;
+module_param(xfuzz, uint, 0644);
+MODULE_PARM_DESC(xinvert, "Fuzz value for x axis.");
+
+static int  yfuzz = 0;
+module_param(yfuzz, uint, 0644);
+MODULE_PARM_DESC(yfuzz, "Fuzz value for y axis.");
+
+static int  smartpad = 0;
+module_param(smartpad, bool, 0644);
+MODULE_PARM_DESC(smartpad, "Act as a smartpad device.");
+
+static int  mouse = 0;
+module_param(mouse, bool, 0644);
+MODULE_PARM_DESC(mouse, "Report mouse button");
+
+static psmouse_ret_t touchkit_ps2_process_byte(struct psmouse *psmouse)
+{
+	unsigned char 		*packet = psmouse->packet;
+	struct input_dev 	*dev = psmouse->dev;
+	int 			x,y;
+
+	if (psmouse->pktcnt != 5)
+		return PSMOUSE_GOOD_DATA;
+
+	if (xyswap) {
+		y = TOUCHKIT_GET_X(packet);
+		x = TOUCHKIT_GET_Y(packet);
+	} else {
+		x = TOUCHKIT_GET_X(packet);
+		y = TOUCHKIT_GET_Y(packet);
+	}
+
+	y = (yinvert) ? TOUCHKIT_MAX_YC - y : y;
+	x = (xinvert) ? TOUCHKIT_MAX_XC - x : x;
+
+	input_report_key(dev,
+			 (mouse) ? BTN_MOUSE : BTN_TOUCH,
+			 TOUCHKIT_GET_TOUCHED(packet));
+
+	if (smartpad)
+		input_report_key(dev, BTN_TOOL_FINGER, 1);
+
+	input_report_abs(dev, ABS_X, x);
+	input_report_abs(dev, ABS_Y, y);
+
+	input_sync(dev);
+
+	return PSMOUSE_FULL_PACKET;
+}
+
+int touchkit_ps2_detect(struct psmouse *psmouse, int set_properties)
+{
+	unsigned char	param[3];
+	int		command;
+
+	param[0] = TOUCHKIT_CMD_LENGTH;
+	param[1] = TOUCHKIT_CMD_ACTIVE;
+	command = TOUCHKIT_SEND_PARMS(2, 3, TOUCHKIT_CMD);
+
+	if (ps2_command(&psmouse->ps2dev, param, command) == 0 &&
+	    param[0] == TOUCHKIT_CMD &&
+	    param[1] == 0x01 &&
+	    param[2] == TOUCHKIT_CMD_ACTIVE){
+		printk(KERN_INFO "touchkit_ps2: device detected\n");
+		if (set_properties) {
+			psmouse->vendor = "eGalax";
+			psmouse->name = "Touchscreen";
+		}
+		return 0;
+	}
+	return -1;
+}
+
+int touchkit_ps2_init(struct psmouse *psmouse)
+{
+	psmouse->dev->evbit[0] = BIT(EV_KEY) | BIT(EV_ABS);
+
+	set_bit((mouse) ? BTN_MOUSE : BTN_TOUCH,psmouse->dev->keybit);
+	if (smartpad)
+		set_bit(BTN_TOOL_FINGER,psmouse->dev->keybit);
+
+	psmouse->dev->absbit[0] = BIT(ABS_X) | BIT(ABS_Y);
+
+	/* Used to Scale Compensated Data */
+	psmouse->dev->absmin[ABS_X] = TOUCHKIT_MIN_XC;
+	psmouse->dev->absmax[ABS_X] = TOUCHKIT_MAX_XC;
+	psmouse->dev->absfuzz[ABS_X] = xfuzz;
+	psmouse->dev->absflat[ABS_X] = TOUCHKIT_XC_FLAT;
+	psmouse->dev->absmin[ABS_Y] = TOUCHKIT_MIN_YC;
+	psmouse->dev->absmax[ABS_Y] = TOUCHKIT_MAX_YC;
+	psmouse->dev->absfuzz[ABS_Y] = yfuzz;
+	psmouse->dev->absflat[ABS_Y] = TOUCHKIT_YC_FLAT;
+
+	input_set_abs_params(psmouse->dev, ABS_X, 0, 0x07ff, xfuzz, 0);
+	input_set_abs_params(psmouse->dev, ABS_Y, 0, 0x07ff, yfuzz, 0);
+
+	psmouse->protocol_handler = touchkit_ps2_process_byte;
+	psmouse->pktsize = 5;
+
+	return 0;
+}
diff -puN /dev/null drivers/input/mouse/touchkit_ps2.h
--- /dev/null
+++ a/drivers/input/mouse/touchkit_ps2.h
@@ -0,0 +1,18 @@
+/* ----------------------------------------------------------------------------
+ * touchkit_ps2.h  --  Driver for eGalax TouchKit PS/2 Touchscreens
+ *
+ * Copyright (C) 2005 by Stefan Lucke
+ * Copyright (c) 2005 Vojtech Pavlik
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _TOUCHKIT_PS2_H
+#define _TOUCHKIT_PS2_H
+
+int touchkit_ps2_detect(struct psmouse *psmouse, int set_properties);
+int touchkit_ps2_init(struct psmouse *psmouse);
+
+#endif
_

Patches currently in -mm which might be from stefan@lucke.in-berlin.de are

touchkit-ps-2-touchscreen-driver.patch
