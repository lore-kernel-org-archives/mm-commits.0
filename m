From: akpm@linux-foundation.org
Subject: + viafb-vt1636-cleanup.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:37:09 -0700
Message-ID: <201009212237.o8LMb9V8006790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab0IUWho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, corbet@lwn.net


The patch titled
     viafb: vt1636 cleanup
has been added to the -mm tree.  Its filename is
     viafb-vt1636-cleanup.patch

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
Subject: viafb: vt1636 cleanup
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Merge tbl1636 into vt1636 and clean it up as the data was only used there
anyway.  No runtime changes are expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/Makefile  |    2 
 drivers/video/via/global.h  |    1 
 drivers/video/via/tbl1636.c |   71 ----------------------------------
 drivers/video/via/tbl1636.h |   34 ----------------
 drivers/video/via/vt1636.c  |   65 +++++++++++++++++++------------
 5 files changed, 42 insertions(+), 131 deletions(-)

diff -puN drivers/video/via/Makefile~viafb-vt1636-cleanup drivers/video/via/Makefile
--- a/drivers/video/via/Makefile~viafb-vt1636-cleanup
+++ a/drivers/video/via/Makefile
@@ -5,5 +5,5 @@
 obj-$(CONFIG_FB_VIA) += viafb.o
 
 viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o \
-	via_utility.o vt1636.o global.o tblDPASetting.o viamode.o tbl1636.o \
+	via_utility.o vt1636.o global.o tblDPASetting.o viamode.o \
 	via-core.o via-gpio.o via_modesetting.o
diff -puN drivers/video/via/global.h~viafb-vt1636-cleanup drivers/video/via/global.h
--- a/drivers/video/via/global.h~viafb-vt1636-cleanup
+++ a/drivers/video/via/global.h
@@ -48,7 +48,6 @@
 #include "via_utility.h"
 #include "vt1636.h"
 #include "tblDPASetting.h"
-#include "tbl1636.h"
 
 /* External struct*/
 
diff -puN drivers/video/via/tbl1636.c~viafb-vt1636-cleanup /dev/null
--- a/drivers/video/via/tbl1636.c
+++ /dev/null
@@ -1,71 +0,0 @@
-/*
- * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
-
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation;
- * either version 2, or (at your option) any later version.
-
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
- * the implied warranty of MERCHANTABILITY or FITNESS FOR
- * A PARTICULAR PURPOSE.See the GNU General Public License
- * for more details.
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#include "global.h"
-struct IODATA COMMON_INIT_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	/* Set panel power sequence timing */
-	{0x10, 0xC0, 0x00},
-	/* T1: VDD on - Data on. Each increment is 1 ms. (50ms = 031h) */
-	{0x0B, 0xFF, 0x40},
-	/* T2: Data on - Backlight on. Each increment is 2 ms. (210ms = 068h) */
-	{0x0C, 0xFF, 0x31},
-	/* T3: Backlight off -Data off. Each increment is 2 ms. (210ms = 068h)*/
-	{0x0D, 0xFF, 0x31},
-	/* T4: Data off - VDD off. Each increment is 1 ms. (50ms = 031h) */
-	{0x0E, 0xFF, 0x68},
-	/* T5: VDD off - VDD on. Each increment is 100 ms. (500ms = 04h) */
-	{0x0F, 0xFF, 0x68},
-	/* LVDS output power up */
-	{0x09, 0xA0, 0xA0},
-	/* turn on back light */
-	{0x10, 0x33, 0x13}
-};
-
-struct IODATA DUAL_CHANNEL_ENABLE_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x08, 0xF0, 0xE0}	/* Input Data Mode Select */
-};
-
-struct IODATA SINGLE_CHANNEL_ENABLE_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x08, 0xF0, 0x00}	/* Input Data Mode Select */
-};
-
-struct IODATA DITHERING_ENABLE_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x0A, 0x70, 0x50}
-};
-
-struct IODATA DITHERING_DISABLE_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x0A, 0x70, 0x00}
-};
-
-struct IODATA VDD_ON_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x10, 0x20, 0x20}
-};
-
-struct IODATA VDD_OFF_TBL_VT1636[] = {
-/*  Index, Mask, Value */
-	{0x10, 0x20, 0x00}
-};
diff -puN drivers/video/via/tbl1636.h~viafb-vt1636-cleanup /dev/null
--- a/drivers/video/via/tbl1636.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
-
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation;
- * either version 2, or (at your option) any later version.
-
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
- * the implied warranty of MERCHANTABILITY or FITNESS FOR
- * A PARTICULAR PURPOSE.See the GNU General Public License
- * for more details.
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef _TBL1636_H_
-#define _TBL1636_H_
-#include "hw.h"
-
-extern struct IODATA COMMON_INIT_TBL_VT1636[8];
-extern struct IODATA DUAL_CHANNEL_ENABLE_TBL_VT1636[1];
-extern struct IODATA SINGLE_CHANNEL_ENABLE_TBL_VT1636[1];
-extern struct IODATA DITHERING_ENABLE_TBL_VT1636[1];
-extern struct IODATA DITHERING_DISABLE_TBL_VT1636[1];
-extern struct IODATA VDD_ON_TBL_VT1636[1];
-extern struct IODATA VDD_OFF_TBL_VT1636[1];
-
-#endif /* _VIA_TBL1636_H_ */
diff -puN drivers/video/via/vt1636.c~viafb-vt1636-cleanup drivers/video/via/vt1636.c
--- a/drivers/video/via/vt1636.c~viafb-vt1636-cleanup
+++ a/drivers/video/via/vt1636.c
@@ -23,6 +23,34 @@
 #include <linux/via_i2c.h>
 #include "global.h"
 
+static const struct IODATA common_init_data[] = {
+/*  Index, Mask, Value */
+	/* Set panel power sequence timing */
+	{0x10, 0xC0, 0x00},
+	/* T1: VDD on - Data on. Each increment is 1 ms. (50ms = 031h) */
+	{0x0B, 0xFF, 0x40},
+	/* T2: Data on - Backlight on. Each increment is 2 ms. (210ms = 068h) */
+	{0x0C, 0xFF, 0x31},
+	/* T3: Backlight off -Data off. Each increment is 2 ms. (210ms = 068h)*/
+	{0x0D, 0xFF, 0x31},
+	/* T4: Data off - VDD off. Each increment is 1 ms. (50ms = 031h) */
+	{0x0E, 0xFF, 0x68},
+	/* T5: VDD off - VDD on. Each increment is 100 ms. (500ms = 04h) */
+	{0x0F, 0xFF, 0x68},
+	/* LVDS output power up */
+	{0x09, 0xA0, 0xA0},
+	/* turn on back light */
+	{0x10, 0x33, 0x13}
+};
+
+/* Index, Mask, Value */
+static const struct IODATA dual_channel_enable_data = {0x08, 0xF0, 0xE0};
+static const struct IODATA single_channel_enable_data = {0x08, 0xF0, 0x00};
+static const struct IODATA dithering_enable_data = {0x0A, 0x70, 0x50};
+static const struct IODATA dithering_disable_data = {0x0A, 0x70, 0x00};
+static const struct IODATA vdd_on_data = {0x10, 0x20, 0x20};
+static const struct IODATA vdd_off_data = {0x10, 0x20, 0x00};
+
 u8 viafb_gpio_i2c_read_lvds(struct lvds_setting_information
 	*plvds_setting_info, struct lvds_chip_information *plvds_chip_info,
 	u8 index)
@@ -55,52 +83,41 @@ void viafb_init_lvds_vt1636(struct lvds_
 	int reg_num, i;
 
 	/* Common settings: */
-	reg_num = ARRAY_SIZE(COMMON_INIT_TBL_VT1636);
-
-	for (i = 0; i < reg_num; i++) {
+	reg_num = ARRAY_SIZE(common_init_data);
+	for (i = 0; i < reg_num; i++)
 		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
-					 plvds_chip_info,
-					 COMMON_INIT_TBL_VT1636[i]);
-	}
+			plvds_chip_info, common_init_data[i]);
 
 	/* Input Data Mode Select */
-	if (plvds_setting_info->device_lcd_dualedge) {
+	if (plvds_setting_info->device_lcd_dualedge)
 		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
-					 plvds_chip_info,
-					 DUAL_CHANNEL_ENABLE_TBL_VT1636[0]);
-	} else {
+			plvds_chip_info, dual_channel_enable_data);
+	else
 		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
-					 plvds_chip_info,
-					 SINGLE_CHANNEL_ENABLE_TBL_VT1636[0]);
-	}
+			plvds_chip_info, single_channel_enable_data);
 
-	if (plvds_setting_info->LCDDithering) {
+	if (plvds_setting_info->LCDDithering)
 		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
-					 plvds_chip_info,
-					 DITHERING_ENABLE_TBL_VT1636[0]);
-	} else {
+			plvds_chip_info, dithering_enable_data);
+	else
 		viafb_gpio_i2c_write_mask_lvds(plvds_setting_info,
-					 plvds_chip_info,
-					 DITHERING_DISABLE_TBL_VT1636[0]);
-	}
+			plvds_chip_info, dithering_disable_data);
 }
 
 void viafb_enable_lvds_vt1636(struct lvds_setting_information
 			*plvds_setting_info,
 			struct lvds_chip_information *plvds_chip_info)
 {
-
 	viafb_gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info,
-				 VDD_ON_TBL_VT1636[0]);
+		vdd_on_data);
 }
 
 void viafb_disable_lvds_vt1636(struct lvds_setting_information
 			 *plvds_setting_info,
 			 struct lvds_chip_information *plvds_chip_info)
 {
