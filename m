From: akpm@linux-foundation.org
Subject: - viafb-tbl1636c-tbl1636h-tbldpasettingc-tbldpasettingh.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:16:40 -0700
Message-ID: <200810182316.m9INGesu028851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbYJRXQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JosephChan@via.com.tw, geert@linux-m68k.org, josephchan@via.com.tw, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb: tbl1636.c, tbl1636.h, tblDPASetting.c, tblDPASetting.h
has been removed from the -mm tree.  Its filename was
     viafb-tbl1636c-tbl1636h-tbldpasettingc-tbldpasettingh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: tbl1636.c, tbl1636.h, tblDPASetting.c, tblDPASetting.h
From: Joseph Chan <JosephChan@via.com.tw>

tbl1636.c, tbl1636.h: patch setting for VT1636.
tblDPASetting.c, tblDPASetting.h: patch for graphic clock skew.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/tbl1636.c       |   71 ++++++++++++++++++
 drivers/video/via/tbl1636.h       |   34 ++++++++
 drivers/video/via/tblDPASetting.c |  109 ++++++++++++++++++++++++++++
 drivers/video/via/tblDPASetting.h |   47 ++++++++++++
 4 files changed, 261 insertions(+)

diff -puN /dev/null drivers/video/via/tbl1636.c
--- /dev/null
+++ a/drivers/video/via/tbl1636.c
@@ -0,0 +1,71 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include "global.h"
+struct IODATA COMMON_INIT_TBL_VT1636[] = {
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
+struct IODATA DUAL_CHANNEL_ENABLE_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x08, 0xF0, 0xE0}	/* Input Data Mode Select */
+};
+
+struct IODATA SINGLE_CHANNEL_ENABLE_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x08, 0xF0, 0x00}	/* Input Data Mode Select */
+};
+
+struct IODATA DITHERING_ENABLE_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x0A, 0x70, 0x50}
+};
+
+struct IODATA DITHERING_DISABLE_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x0A, 0x70, 0x00}
+};
+
+struct IODATA VDD_ON_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x10, 0x20, 0x20}
+};
+
+struct IODATA VDD_OFF_TBL_VT1636[] = {
+/*  Index, Mask, Value */
+	{0x10, 0x20, 0x00}
+};
diff -puN /dev/null drivers/video/via/tbl1636.h
--- /dev/null
+++ a/drivers/video/via/tbl1636.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef _TBL1636_H_
+#define _TBL1636_H_
+#include "hw.h"
+
+extern struct IODATA COMMON_INIT_TBL_VT1636[8];
+extern struct IODATA DUAL_CHANNEL_ENABLE_TBL_VT1636[1];
+extern struct IODATA SINGLE_CHANNEL_ENABLE_TBL_VT1636[1];
+extern struct IODATA DITHERING_ENABLE_TBL_VT1636[1];
+extern struct IODATA DITHERING_DISABLE_TBL_VT1636[1];
+extern struct IODATA VDD_ON_TBL_VT1636[1];
+extern struct IODATA VDD_OFF_TBL_VT1636[1];
+
+#endif /* _VIA_TBL1636_H_ */
diff -puN /dev/null drivers/video/via/tblDPASetting.c
--- /dev/null
+++ a/drivers/video/via/tblDPASetting.c
@@ -0,0 +1,109 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include "global.h"
+/* For VT3324: */
+struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3324[] = {
+	/* Panel ID,       CLK_SEL_ST1[09],    CLK_SEL_ST2[08] */
+	{LCD_PANEL_ID0_640X480, 0x00, 0x00},	/* For 640x480   */
+	{LCD_PANEL_ID1_800X600, 0x00, 0x00},	/* For 800x600   */
+	{LCD_PANEL_ID2_1024X768, 0x00, 0x00},	/* For 1024x768  */
+	{LCD_PANEL_ID3_1280X768, 0x00, 0x00},	/* For 1280x768  */
+	{LCD_PANEL_ID4_1280X1024, 0x00, 0x00},	/* For 1280x1024 */
+	{LCD_PANEL_ID5_1400X1050, 0x00, 0x00},	/* For 1400x1050 */
+	{LCD_PANEL_ID6_1600X1200, 0x0B, 0x03}	/* For 1600x1200 */
+};
+
+struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3324[] = {
+/*  ClkRange, DVP0, DVP0DataDriving,  DVP0ClockDriving, DVP1,
+					DVP1Driving, DFPHigh, DFPLow */
+/*  CR96, SR2A[5], SR1B[1], SR2A[4], SR1E[2], CR9B,
+					SR65,        CR97,    CR99   */
+	/* LCK/VCK < 30000000 will use this value */
+	{DPA_CLK_RANGE_30M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00,
+	 0x00},
+	/* 30000000 < LCK/VCK < 50000000 will use this value */
+	{DPA_CLK_RANGE_30_50M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00,
+	 0x00},
+	/* 50000000 < LCK/VCK < 70000000 will use this value */
+	{DPA_CLK_RANGE_50_70M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00,
+	 0x00},
+	/* 70000000 < LCK/VCK < 100000000 will use this value */
+	{DPA_CLK_RANGE_70_100M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00,
+	 0x00},
+	/* 100000000 < LCK/VCK < 15000000 will use this value */
+	{DPA_CLK_RANGE_100_150M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00,
+	 0x00},
+	/* 15000000 < LCK/VCK will use this value */
+	{DPA_CLK_RANGE_150M, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x0E, 0x00,
+	 0x00},
+};
+
+/* For VT3327: */
+struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3327[] = {
+	/* Panel ID,       CLK_SEL_ST1[09],    CLK_SEL_ST2[08] */
+	{LCD_PANEL_ID0_640X480, 0x00, 0x00},	/* For 640x480   */
+	{LCD_PANEL_ID1_800X600, 0x00, 0x00},	/* For 800x600   */
+	{LCD_PANEL_ID2_1024X768, 0x00, 0x00},	/* For 1024x768  */
+	{LCD_PANEL_ID3_1280X768, 0x00, 0x00},	/* For 1280x768  */
+	{LCD_PANEL_ID4_1280X1024, 0x00, 0x00},	/* For 1280x1024 */
+	{LCD_PANEL_ID5_1400X1050, 0x00, 0x00},	/* For 1400x1050 */
+	{LCD_PANEL_ID6_1600X1200, 0x00, 0x00}	/* For 1600x1200 */
+};
+
+struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3327[] = {
+/*  ClkRange,DVP0, DVP0DataDriving,  DVP0ClockDriving, DVP1,
+					DVP1Driving, DFPHigh,   DFPLow */
+/*   CR96, SR2A[5], SR1B[1], SR2A[4], SR1E[2], CR9B,
+					SR65,        CR97,      CR99   */
+/* LCK/VCK < 30000000 will use this value */
+{DPA_CLK_RANGE_30M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x08, 0x01},
+/* 30000000 < LCK/VCK < 50000000 will use this value */
+{DPA_CLK_RANGE_30_50M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x08, 0x01},
+/* 50000000 < LCK/VCK < 70000000 will use this value */
+{DPA_CLK_RANGE_50_70M, 0x06, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x08, 0x01},
+/* 70000000 < LCK/VCK < 100000000 will use this value */
+{DPA_CLK_RANGE_70_100M, 0x03, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x08, 0x03},
+/* 100000000 < LCK/VCK < 15000000 will use this value */
+{DPA_CLK_RANGE_100_150M, 0x03, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x01, 0x02},
+/* 15000000 < LCK/VCK will use this value */
+{DPA_CLK_RANGE_150M, 0x00, 0x20, 0x00, 0x10, 0x00, 0x03, 0x00, 0x0D, 0x03},
+};
+
+/* For VT3364: */
+struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3364[] = {
+/*  ClkRange,DVP0, DVP0DataDriving,  DVP0ClockDriving, DVP1,
+					DVP1Driving, DFPHigh,   DFPLow */
+/*   CR96, SR2A[5], SR1B[1], SR2A[4], SR1E[2], CR9B,
+					SR65,        CR97,      CR99   */
+/* LCK/VCK < 30000000 will use this value */
+{DPA_CLK_RANGE_30M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x08},
+/* 30000000 < LCK/VCK < 50000000 will use this value */
+{DPA_CLK_RANGE_30_50M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x08},
+/* 50000000 < LCK/VCK < 70000000 will use this value */
+{DPA_CLK_RANGE_50_70M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x08},
+/* 70000000 < LCK/VCK < 100000000 will use this value */
+{DPA_CLK_RANGE_70_100M, 0x07, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x08},
+/* 100000000 < LCK/VCK < 15000000 will use this value */
+{DPA_CLK_RANGE_100_150M, 0x03, 0x00, 0x02, 0x00, 0x00, 0x03, 0x00, 0x00, 0x08},
+/* 15000000 < LCK/VCK will use this value */
+{DPA_CLK_RANGE_150M, 0x01, 0x00, 0x02, 0x10, 0x00, 0x03, 0x00, 0x00, 0x08},
+};
diff -puN /dev/null drivers/video/via/tblDPASetting.h
--- /dev/null
+++ a/drivers/video/via/tblDPASetting.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef _TBLDPASETTING_H_
+#define _TBLDPASETTING_H_
+#include "global.h"
+
+#define DPA_CLK_30M       30000000
+#define DPA_CLK_50M       50000000
+#define DPA_CLK_70M       70000000
+#define DPA_CLK_100M      100000000
+#define DPA_CLK_150M      150000000
+
+enum DPA_RANGE {
+	DPA_CLK_RANGE_30M,
+	DPA_CLK_RANGE_30_50M,
+	DPA_CLK_RANGE_50_70M,
+	DPA_CLK_RANGE_70_100M,
+	DPA_CLK_RANGE_100_150M,
+	DPA_CLK_RANGE_150M
+};
+
+extern struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3324[7];
+extern struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3324[6];
+extern struct VT1636_DPA_SETTING VT1636_DPA_SETTING_TBL_VT3327[7];
+extern struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3327[];
+extern struct GFX_DPA_SETTING GFX_DPA_SETTING_TBL_VT3364[6];
+
+#endif
_

Patches currently in -mm which might be from JosephChan@via.com.tw are

origin.patch

