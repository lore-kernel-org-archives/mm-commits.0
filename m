From: akpm@linux-foundation.org
Subject: - lxfb-geode-add-framebuffer-support-for-the-amd-geode-lx.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:11 -0700
Message-ID: <200707312355.l6VNtBUu029212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763297AbXGaXzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:55:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jordan.crouse@amd.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lxfb: GEODE: Add framebuffer support for the AMD Geode LX
has been removed from the -mm tree.  Its filename was
     lxfb-geode-add-framebuffer-support-for-the-amd-geode-lx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lxfb: GEODE: Add framebuffer support for the AMD Geode LX
From: Jordan Crouse <jordan.crouse@amd.com>

Add framebuffer support for the AMD Geode LX graphics engine.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/Kconfig     |   15 
 drivers/video/geode/Makefile    |    2 
 drivers/video/geode/lxfb.h      |  199 +++++++++
 drivers/video/geode/lxfb_core.c |  621 ++++++++++++++++++++++++++++++
 drivers/video/geode/lxfb_ops.c  |  536 +++++++++++++++++++++++++
 5 files changed, 1373 insertions(+)

diff -puN drivers/video/geode/Kconfig~lxfb-geode-add-framebuffer-support-for-the-amd-geode-lx drivers/video/geode/Kconfig
--- a/drivers/video/geode/Kconfig~lxfb-geode-add-framebuffer-support-for-the-amd-geode-lx
+++ a/drivers/video/geode/Kconfig
@@ -8,6 +8,21 @@ config FB_GEODE
 	  Say 'Y' here to allow you to select framebuffer drivers for
 	  the AMD Geode family of processors.
 
+config FB_GEODE_LX
+	tristate "AMD Geode LX framebuffer support (EXPERIMENTAL)"
+	depends on FB && FB_GEODE
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	---help---
+	  Framebuffer driver for the display controller integrated into the
+	  AMD Geode LX processors.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called lxfb.
+
+	  If unsure, say N.
+
 config FB_GEODE_GX
 	tristate "AMD Geode GX framebuffer support (EXPERIMENTAL)"
 	depends on FB && FB_GEODE && EXPERIMENTAL
diff -puN drivers/video/geode/Makefile~lxfb-geode-add-framebuffer-support-for-the-amd-geode-lx drivers/video/geode/Makefile
--- a/drivers/video/geode/Makefile~lxfb-geode-add-framebuffer-support-for-the-amd-geode-lx
+++ a/drivers/video/geode/Makefile
@@ -2,6 +2,8 @@
 
 obj-$(CONFIG_FB_GEODE_GX1) += gx1fb.o
 obj-$(CONFIG_FB_GEODE_GX)  += gxfb.o
+obj-$(CONFIG_FB_GEODE_LX)  += lxfb.o
 
 gx1fb-objs := gx1fb_core.o display_gx1.o video_cs5530.o
 gxfb-objs  := gxfb_core.o display_gx.o video_gx.o
+lxfb-objs  := lxfb_core.o lxfb_ops.o
diff -puN /dev/null drivers/video/geode/lxfb.h
--- /dev/null
+++ a/drivers/video/geode/lxfb.h
@@ -0,0 +1,199 @@
+#ifndef _LXFB_H_
+#define _LXFB_H_
+
+#include <linux/fb.h>
+
+#define OUTPUT_CRT   0x01
+#define OUTPUT_PANEL 0x02
+
+struct lxfb_par {
+	int output;
+	int panel_width;
+	int panel_height;
+
+	void __iomem *gp_regs;
+	void __iomem *dc_regs;
+	void __iomem *df_regs;
+};
+
+static inline unsigned int lx_get_pitch(unsigned int xres, int bpp)
+{
+	return (((xres * (bpp >> 3)) + 7) & ~7);
+}
+
+void lx_set_mode(struct fb_info *);
+void lx_get_gamma(struct fb_info *, unsigned int *, int);
+void lx_set_gamma(struct fb_info *, unsigned int *, int);
+unsigned int lx_framebuffer_size(void);
+int lx_blank_display(struct fb_info *, int);
+void lx_set_palette_reg(struct fb_info *, unsigned int, unsigned int,
+			unsigned int, unsigned int);
+
+/* MSRS */
+
+#define MSR_LX_GLD_CONFIG    0x48002001
+#define MSR_LX_GLCP_DOTPLL   0x4c000015
+#define MSR_LX_DF_PADSEL     0x48000011
+#define MSR_LX_DC_SPARE      0x80000011
+#define MSR_LX_DF_GLCONFIG   0x48002001
+
+#define MSR_LX_GLIU0_P2D_RO0 0x10000029
+
+#define GLCP_DOTPLL_RESET    (1 << 0)
+#define GLCP_DOTPLL_BYPASS   (1 << 15)
+#define GLCP_DOTPLL_HALFPIX  (1 << 24)
+#define GLCP_DOTPLL_LOCK     (1 << 25)
+
+#define DF_CONFIG_OUTPUT_MASK       0x38
+#define DF_OUTPUT_PANEL             0x08
+#define DF_OUTPUT_CRT               0x00
+#define DF_SIMULTANEOUS_CRT_AND_FP  (1 << 15)
+
+#define DF_DEFAULT_TFT_PAD_SEL_LOW  0xDFFFFFFF
+#define DF_DEFAULT_TFT_PAD_SEL_HIGH 0x0000003F
+
+#define DC_SPARE_DISABLE_CFIFO_HGO         0x00000800
+#define DC_SPARE_VFIFO_ARB_SELECT          0x00000400
+#define DC_SPARE_WM_LPEN_OVRD              0x00000200
+#define DC_SPARE_LOAD_WM_LPEN_MASK         0x00000100
+#define DC_SPARE_DISABLE_INIT_VID_PRI      0x00000080
+#define DC_SPARE_DISABLE_VFIFO_WM          0x00000040
+#define DC_SPARE_DISABLE_CWD_CHECK         0x00000020
+#define DC_SPARE_PIX8_PAN_FIX              0x00000010
+#define DC_SPARE_FIRST_REQ_MASK            0x00000002
+
+/* Registers */
+
+#define DC_UNLOCK         0x00
+#define  DC_UNLOCK_CODE   0x4758
+
+#define DC_GENERAL_CFG    0x04
+#define  DC_GCFG_DFLE     (1 << 0)
+#define  DC_GCFG_VIDE     (1 << 3)
+#define  DC_GCFG_VGAE     (1 << 7)
+#define  DC_GCFG_CMPE     (1 << 5)
+#define  DC_GCFG_DECE     (1 << 6)
+#define  DC_GCFG_FDTY     (1 << 17)
+
+#define DC_DISPLAY_CFG    0x08
+#define  DC_DCFG_TGEN     (1 << 0)
+#define  DC_DCFG_GDEN     (1 << 3)
+#define  DC_DCFG_VDEN     (1 << 4)
+#define  DC_DCFG_TRUP     (1 << 6)
+#define  DC_DCFG_DCEN     (1 << 24)
+#define  DC_DCFG_PALB     (1 << 25)
+#define  DC_DCFG_VISL     (1 << 27)
+
+#define  DC_DCFG_16BPP           0x0
+
+#define  DC_DCFG_DISP_MODE_MASK  0x00000300
+#define  DC_DCFG_DISP_MODE_8BPP  0x00000000
+#define  DC_DCFG_DISP_MODE_16BPP 0x00000100
+#define  DC_DCFG_DISP_MODE_24BPP 0x00000200
+#define  DC_DCFG_DISP_MODE_32BPP 0x00000300
+
+
+#define DC_ARB_CFG        0x0C
+
+#define DC_FB_START       0x10
+#define DC_CB_START       0x14
+#define DC_CURSOR_START   0x18
+
+#define DC_DV_TOP          0x2C
+#define DC_DV_TOP_ENABLE   (1 << 0)
+
+#define DC_LINE_SIZE       0x30
+#define DC_GRAPHICS_PITCH  0x34
+#define DC_H_ACTIVE_TIMING 0x40
+#define DC_H_BLANK_TIMING  0x44
+#define DC_H_SYNC_TIMING   0x48
+#define DC_V_ACTIVE_TIMING 0x50
+#define DC_V_BLANK_TIMING  0x54
+#define DC_V_SYNC_TIMING   0x58
+#define DC_FB_ACTIVE       0x5C
+
+#define DC_PAL_ADDRESS     0x70
+#define DC_PAL_DATA        0x74
+
+#define DC_PHY_MEM_OFFSET  0x84
+
+#define DC_DV_CTL          0x88
+#define DC_DV_LINE_SIZE_MASK               0x00000C00
+#define DC_DV_LINE_SIZE_1024               0x00000000
+#define DC_DV_LINE_SIZE_2048               0x00000400
+#define DC_DV_LINE_SIZE_4096               0x00000800
+#define DC_DV_LINE_SIZE_8192               0x00000C00
+
+
+#define DC_GFX_SCALE       0x90
+#define DC_IRQ_FILT_CTL    0x94
+
+
+#define DC_IRQ               0xC8
+#define  DC_IRQ_MASK         (1 << 0)
+#define  DC_VSYNC_IRQ_MASK   (1 << 1)
+#define  DC_IRQ_STATUS       (1 << 20)
+#define  DC_VSYNC_IRQ_STATUS (1 << 21)
+
+#define DC_GENLCK_CTRL      0xD4
+#define  DC_GENLCK_ENABLE   (1 << 18)
+#define  DC_GC_ALPHA_FLICK_ENABLE  (1 << 25)
+#define  DC_GC_FLICKER_FILTER_ENABLE (1 << 24)
+#define  DC_GC_FLICKER_FILTER_MASK (0x0F << 28)
+
+#define DC_COLOR_KEY       0xB8
+#define DC_CLR_KEY_ENABLE (1 << 24)
+
+
+#define DC3_DV_LINE_SIZE_MASK               0x00000C00
+#define DC3_DV_LINE_SIZE_1024               0x00000000
+#define DC3_DV_LINE_SIZE_2048               0x00000400
+#define DC3_DV_LINE_SIZE_4096               0x00000800
+#define DC3_DV_LINE_SIZE_8192               0x00000C00
+
+#define DF_VIDEO_CFG       0x0
+#define  DF_VCFG_VID_EN    (1 << 0)
+
+#define DF_DISPLAY_CFG     0x08
+
+#define DF_DCFG_CRT_EN     (1 << 0)
+#define DF_DCFG_HSYNC_EN   (1 << 1)
+#define DF_DCFG_VSYNC_EN   (1 << 2)
+#define DF_DCFG_DAC_BL_EN  (1 << 3)
+#define DF_DCFG_CRT_HSYNC_POL  (1 << 8)
+#define DF_DCFG_CRT_VSYNC_POL  (1 << 9)
+#define DF_DCFG_GV_PAL_BYP     (1 << 21)
+
+#define DF_DCFG_CRT_SYNC_SKW_INIT 0x10000
+#define DF_DCFG_CRT_SYNC_SKW_MASK  0x1c000
+
+#define DF_DCFG_PWR_SEQ_DLY_INIT     0x80000
+#define DF_DCFG_PWR_SEQ_DLY_MASK     0xe0000
+
+#define DF_MISC            0x50
+
+#define  DF_MISC_GAM_BYPASS (1 << 0)
+#define  DF_MISC_DAC_PWRDN  (1 << 10)
+#define  DF_MISC_A_PWRDN    (1 << 11)
+
+#define DF_PAR             0x38
+#define DF_PDR             0x40
+#define DF_ALPHA_CONTROL_1 0xD8
+#define DF_VIDEO_REQUEST   0x120
+
+#define DF_PANEL_TIM1      0x400
+#define DF_DEFAULT_TFT_PMTIM1 0x0
+
+#define DF_PANEL_TIM2      0x408
+#define DF_DEFAULT_TFT_PMTIM2 0x08000000
+
+#define DF_FP_PM             0x410
+#define  DF_FP_PM_P          (1 << 24)
+
+#define DF_DITHER_CONTROL    0x418
+#define DF_DEFAULT_TFT_DITHCTL                  0x00000070
+#define GP_BLT_STATUS      0x44
+#define  GP_BS_BLT_BUSY    (1 << 0)
+#define  GP_BS_CB_EMPTY    (1 << 4)
+
+#endif
diff -puN /dev/null drivers/video/geode/lxfb_core.c
--- /dev/null
+++ a/drivers/video/geode/lxfb_core.c
@@ -0,0 +1,621 @@
+/*
+ * Geode LX framebuffer driver.
+ *
+ * Copyright (C) 2007 Advanced Micro Devices, Inc.
+ * Built from gxfb (which is Copyright (C) 2006 Arcom Control Systems Ltd.)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/console.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/uaccess.h>
+
+#include "lxfb.h"
+
+static char *mode_option;
+static int noclear, nopanel, nocrt;
+static int fbsize;
+
+/* Most of these modes are sorted in ascending order, but
+ * since the first entry in this table is the "default" mode,
+ * we try to make it something sane - 640x480-60 is sane
+ */
+
+const struct fb_videomode geode_modedb[] __initdata = {
+	/* 640x480-60 */
+	{ NULL, 60, 640, 480, 39682, 48, 8, 25, 2, 88, 2,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 640x400-70 */
+	{ NULL, 70, 640, 400, 39770, 40, 8, 28, 5, 96, 2,
+	  FB_SYNC_HOR_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 640x480-70 */
+	{ NULL, 70, 640, 480, 35014, 88, 24, 15, 2, 64, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 640x480-72 */
+	{ NULL, 72, 640, 480, 32102, 120, 16, 20, 1, 40, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 640x480-75 */
+	{ NULL, 75, 640, 480, 31746, 120, 16, 16, 1, 64, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 640x480-85 */
+	{ NULL, 85, 640, 480, 27780, 80, 56, 25, 1, 56, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 640x480-90 */
+	{ NULL, 90, 640, 480, 26392, 96, 32, 22, 1, 64, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 640x480-100 */
+	{ NULL, 100, 640, 480, 23167, 104, 40, 25, 1, 64, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 640x480-60 */
+	{ NULL, 60, 640, 480, 39682, 48, 16, 25, 10, 88, 2,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 800x600-56 */
+	{ NULL, 56, 800, 600, 27901, 128, 24, 22, 1, 72, 2,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 800x600-60 */
+	{ NULL, 60, 800, 600, 25131, 72, 32, 23, 1, 136, 4,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 800x600-70 */
+	{ NULL, 70, 800, 600, 21873, 120, 40, 21, 4, 80, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 800x600-72 */
+	{ NULL, 72, 800, 600, 20052, 64, 56, 23, 37, 120, 6,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 800x600-75 */
+	{ NULL, 75, 800, 600, 20202, 160, 16, 21, 1, 80, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 800x600-85 */
+	{ NULL, 85, 800, 600, 17790, 152, 32, 27, 1, 64, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 800x600-90 */
+	{ NULL, 90, 800, 600, 16648, 128, 40, 28, 1, 88, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 800x600-100 */
+	{ NULL, 100, 800, 600, 14667, 136, 48, 27, 1, 88, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 800x600-60 */
+	{ NULL, 60, 800, 600, 25131, 88, 40, 23, 1, 128, 4,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 1024x768-60 */
+	{ NULL, 60, 1024, 768, 15385, 160, 24, 29, 3, 136, 6,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 1024x768-70 */
+	{ NULL, 70, 1024, 768, 13346, 144, 24, 29, 3, 136, 6,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 1024x768-72 */
+	{ NULL, 72, 1024, 768, 12702, 168, 56, 29, 4, 112, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1024x768-75 */
+	{ NULL, 75, 1024, 768, 12703, 176, 16, 28, 1, 96, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1024x768-85 */
+	{ NULL, 85, 1024, 768, 10581, 208, 48, 36, 1, 96, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1024x768-90 */
+	{ NULL, 90, 1024, 768, 9981, 176, 64, 37, 1, 112, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1024x768-100 */
+	{ NULL, 100, 1024, 768, 8825, 184, 72, 42, 1, 112, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1024x768-60 */
+	{ NULL, 60, 1024, 768, 15385, 160, 24, 29, 3, 136, 6,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 1152x864-60 */
+	{ NULL, 60, 1152, 864, 12251, 184, 64, 27, 1, 120, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1152x864-70 */
+	{ NULL, 70, 1152, 864, 10254, 192, 72, 32, 8, 120, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1152x864-72 */
+	{ NULL, 72, 1152, 864, 9866, 200, 72, 33, 7, 128, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1152x864-75 */
+	{ NULL, 75, 1152, 864, 9259, 256, 64, 32, 1, 128, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1152x864-85 */
+	{ NULL, 85, 1152, 864, 8357, 200, 72, 37, 3, 128, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1152x864-90 */
+	{ NULL, 90, 1152, 864, 7719, 208, 80, 42, 9, 128, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1152x864-100 */
+	{ NULL, 100, 1152, 864, 6947, 208, 80, 48, 3, 128, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1152x864-60 */
+	{ NULL, 60, 1152, 864, 12251, 184, 64, 27, 1, 120, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 1280x1024-60 */
+	{ NULL, 60, 1280, 1024, 9262, 248, 48, 38, 1, 112, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1280x1024-70 */
+	{ NULL, 70, 1280, 1024, 7719, 224, 88, 38, 6, 136, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1280x1024-72 */
+	{ NULL, 72, 1280, 1024, 7490, 224, 88, 39, 7, 136, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1280x1024-75 */
+	{ NULL, 75, 1280, 1024, 7409, 248, 16, 38, 1, 144, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1280x1024-85 */
+	{ NULL, 85, 1280, 1024, 6351, 224, 64, 44, 1, 160, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1280x1024-90 */
+	{ NULL, 90, 1280, 1024, 5791, 240, 96, 51, 12, 144, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1280x1024-100 */
+	{ NULL, 100, 1280, 1024, 5212, 240, 96, 57, 6, 144, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1280x1024-60 */
+	{ NULL, 60, 1280, 1024, 9262, 248, 48, 38, 1, 112, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 1600x1200-60 */
+	{ NULL, 60, 1600, 1200, 6172, 304, 64, 46, 1, 192, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1600x1200-70 */
+	{ NULL, 70, 1600, 1200, 5291, 304, 64, 46, 1, 192, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1600x1200-72 */
+	{ NULL, 72, 1600, 1200, 5053, 288, 112, 47, 13, 176, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1600x1200-75 */
+	{ NULL, 75, 1600, 1200, 4938, 304, 64, 46, 1, 192, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1600x1200-85 */
+	{ NULL, 85, 1600, 1200, 4357, 304, 64, 46, 1, 192, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1600x1200-90 */
+	{ NULL, 90, 1600, 1200, 3981, 304, 128, 60, 1, 176, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1600x1200-100 */
+	{ NULL, 100, 1600, 1200, 3563, 304, 128, 67, 1, 176, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1600x1200-60 */
+	{ NULL, 60, 1600, 1200, 6172, 304, 64, 46, 1, 192, 3,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
+	/* 1920x1440-60 */
+	{ NULL, 60, 1920, 1440, 4273, 344, 128, 56, 1, 208, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1920x1440-70 */
+	{ NULL, 70, 1920, 1440, 3593, 360, 152, 55, 8, 208, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1920x1440-72 */
+	{ NULL, 72, 1920, 1440, 3472, 360, 152, 68, 4, 208, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1920x1440-75 */
+	{ NULL, 75, 1920, 1440, 3367, 352, 144, 56, 1, 224, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+	/* 1920x1440-85 */
+	{ NULL, 85, 1920, 1440, 2929, 368, 152, 68, 1, 216, 3,
+	  0, FB_VMODE_NONINTERLACED, 0 },
+};
+
+static int lxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	if (var->xres > 1920 || var->yres > 1440)
+		return -EINVAL;
+
+	if (var->bits_per_pixel == 32) {
+		var->red.offset   = 16; var->red.length   = 8;
+		var->green.offset =  8; var->green.length = 8;
+		var->blue.offset  =  0; var->blue.length  = 8;
+	} else if (var->bits_per_pixel == 16) {
+		var->red.offset   = 11; var->red.length   = 5;
+		var->green.offset =  5; var->green.length = 6;
+		var->blue.offset  =  0; var->blue.length  = 5;
+	} else if (var->bits_per_pixel == 8) {
+		var->red.offset   = 0; var->red.length   = 8;
+		var->green.offset = 0; var->green.length = 8;
+		var->blue.offset  = 0; var->blue.length  = 8;
+	} else
+		return -EINVAL;
+
+	var->transp.offset = 0; var->transp.length = 0;
+
+	/* Enough video memory? */
+	if ((lx_get_pitch(var->xres, var->bits_per_pixel) * var->yres)
+	    > info->fix.smem_len)
+	  return -EINVAL;
+
+	return 0;
+}
+
+static int lxfb_set_par(struct fb_info *info)
+{
+	if (info->var.bits_per_pixel > 8) {
+		info->fix.visual = FB_VISUAL_TRUECOLOR;
+		fb_dealloc_cmap(&info->cmap);
+	} else {
+		info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
+		fb_alloc_cmap(&info->cmap, 1<<info->var.bits_per_pixel, 0);
+	}
+
+	info->fix.line_length = lx_get_pitch(info->var.xres,
+		info->var.bits_per_pixel);
+
+	lx_set_mode(info);
+	return 0;
+}
+
+static inline u_int chan_to_field(u_int chan, struct fb_bitfield *bf)
+{
+	chan &= 0xffff;
+	chan >>= 16 - bf->length;
+	return chan << bf->offset;
+}
+
+static int lxfb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			   unsigned blue, unsigned transp,
+			   struct fb_info *info)
+{
+	if (info->var.grayscale) {
+		/* grayscale = 0.30*R + 0.59*G + 0.11*B */
+		red = green = blue = (red * 77 + green * 151 + blue * 28) >> 8;
+	}
+
+	/* Truecolor has hardware independent palette */
+	if (info->fix.visual == FB_VISUAL_TRUECOLOR) {
+		u32 *pal = info->pseudo_palette;
+		u32 v;
+
+		if (regno >= 16)
+			return -EINVAL;
+
+		v  = chan_to_field(red, &info->var.red);
+		v |= chan_to_field(green, &info->var.green);
+		v |= chan_to_field(blue, &info->var.blue);
+
+		pal[regno] = v;
+	} else {
+		if (regno >= 256)
+			return -EINVAL;
+
+		lx_set_palette_reg(info, regno, red, green, blue);
+	}
+
+	return 0;
+}
+
+static int lxfb_blank(int blank_mode, struct fb_info *info)
+{
+	return lx_blank_display(info, blank_mode);
+}
+
+
+static int __init lxfb_map_video_memory(struct fb_info *info,
+					struct pci_dev *dev)
+{
+	struct lxfb_par *par = info->par;
+	int ret;
+
+	ret = pci_enable_device(dev);
+
+	if (ret)
+		return ret;
+
+	ret = pci_request_region(dev, 0, "lxfb-framebuffer");
+
+	if (ret)
+		return ret;
+
+	ret = pci_request_region(dev, 1, "lxfb-gp");
+
+	if (ret)
+		return ret;
+
+	ret = pci_request_region(dev, 2, "lxfb-vg");
+
+	if (ret)
+		return ret;
+
+	ret = pci_request_region(dev, 3, "lxfb-vip");
+
+	if (ret)
+		return ret;
+
+	info->fix.smem_start = pci_resource_start(dev, 0);
+	info->fix.smem_len = fbsize ? fbsize : lx_framebuffer_size();
+
+	info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
+
+	ret = -ENOMEM;
+
+	if (info->screen_base == NULL)
+		return ret;
+
+	par->gp_regs = ioremap(pci_resource_start(dev, 1),
+				pci_resource_len(dev, 1));
+
+	if (par->gp_regs == NULL)
+		return ret;
+
+	par->dc_regs = ioremap(pci_resource_start(dev, 2),
+			       pci_resource_len(dev, 2));
+
+	if (par->dc_regs == NULL)
+		return ret;
+
+	par->df_regs = ioremap(pci_resource_start(dev, 3),
+			       pci_resource_len(dev, 3));
+
+	if (par->df_regs == NULL)
+		return ret;
+
+	writel(DC_UNLOCK_CODE, par->dc_regs + DC_UNLOCK);
+
+	writel(info->fix.smem_start & 0xFF000000,
+	       par->dc_regs + DC_PHY_MEM_OFFSET);
+
+	writel(0, par->dc_regs + DC_UNLOCK);
+
+	dev_info(&dev->dev, "%d KB of video memory at 0x%lx\n",
+		 info->fix.smem_len / 1024, info->fix.smem_start);
+
+	return 0;
+}
+
+static struct fb_ops lxfb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_check_var	= lxfb_check_var,
+	.fb_set_par	= lxfb_set_par,
+	.fb_setcolreg	= lxfb_setcolreg,
+	.fb_blank       = lxfb_blank,
+	/* No HW acceleration for now. */
+	.fb_fillrect	= cfb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= cfb_imageblit,
+};
+
+static struct fb_info * __init lxfb_init_fbinfo(struct device *dev)
+{
+	struct lxfb_par *par;
+	struct fb_info *info;
+
+	/* Alloc enough space for the pseudo palette. */
+	info = framebuffer_alloc(sizeof(struct lxfb_par) + sizeof(u32) * 16,
+				 dev);
+	if (!info)
+		return NULL;
+
+	par = info->par;
+
+	strcpy(info->fix.id, "Geode LX");
+
+	info->fix.type		= FB_TYPE_PACKED_PIXELS;
+	info->fix.type_aux	= 0;
+	info->fix.xpanstep	= 0;
+	info->fix.ypanstep	= 0;
+	info->fix.ywrapstep	= 0;
+	info->fix.accel		= FB_ACCEL_NONE;
+
+	info->var.nonstd	= 0;
+	info->var.activate	= FB_ACTIVATE_NOW;
+	info->var.height	= -1;
+	info->var.width	= -1;
+	info->var.accel_flags = 0;
+	info->var.vmode	= FB_VMODE_NONINTERLACED;
+
+	info->fbops		= &lxfb_ops;
+	info->flags		= FBINFO_DEFAULT;
+	info->node		= -1;
+
+	info->pseudo_palette	= (void *)par + sizeof(struct lxfb_par);
+
+	info->var.grayscale	= 0;
+
+	return info;
+}
+
+static int __init lxfb_probe(struct pci_dev *pdev,
+			     const struct pci_device_id *id)
+{
+	struct lxfb_par *par;
+	struct fb_info *info;
+	int ret;
+
+	struct fb_videomode *modedb_ptr;
+	int modedb_size;
+
+	info = lxfb_init_fbinfo(&pdev->dev);
+
+	if (info == NULL)
+		return -ENOMEM;
+
+	par = info->par;
+
+	ret = lxfb_map_video_memory(info, pdev);
+
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"failed to map frame buffer or controller registers\n");
+		goto err;
+	}
+
+	/* Set up the desired outputs */
+
+	par->output = 0;
+	par->output |= (nopanel) ? 0 : OUTPUT_PANEL;
+	par->output |= (nocrt) ? 0 : OUTPUT_CRT;
+
+	/* Set up the mode database */
+
+	modedb_ptr = (struct fb_videomode *) geode_modedb;
+	modedb_size = ARRAY_SIZE(geode_modedb);
+
+	ret = fb_find_mode(&info->var, info, mode_option,
+			   modedb_ptr, modedb_size, NULL, 16);
+
+	if (ret == 0 || ret == 4) {
+		dev_err(&pdev->dev, "could not find valid video mode\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* Clear the screen of garbage, unless noclear was specified,
+	 * in which case we assume the user knows what he is doing */
+
+	if (!noclear)
+		memset_io(info->screen_base, 0, info->fix.smem_len);
+
+	/* Set the mode */
+
+	lxfb_check_var(&info->var, info);
+	lxfb_set_par(info);
+
+	if (register_framebuffer(info) < 0) {
+		ret = -EINVAL;
+		goto err;
+	}
+	pci_set_drvdata(pdev, info);
+	printk(KERN_INFO "fb%d: %s frame buffer device\n",
+		info->node, info->fix.id);
+
+	return 0;
+
+err:
+	if (info->screen_base) {
+		iounmap(info->screen_base);
+		pci_release_region(pdev, 0);
+	}
+	if (par->gp_regs) {
+		iounmap(par->gp_regs);
+		pci_release_region(pdev, 1);
+	}
+	if (par->dc_regs) {
+		iounmap(par->dc_regs);
+		pci_release_region(pdev, 2);
+	}
+	if (par->df_regs) {
+		iounmap(par->df_regs);
+		pci_release_region(pdev, 3);
+	}
+
+	if (info)
+		framebuffer_release(info);
+
+	return ret;
+}
+
+static void lxfb_remove(struct pci_dev *pdev)
+{
+	struct fb_info *info = pci_get_drvdata(pdev);
+	struct lxfb_par *par = info->par;
+
+	unregister_framebuffer(info);
+
+	iounmap(info->screen_base);
+	pci_release_region(pdev, 0);
+
+	iounmap(par->gp_regs);
+	pci_release_region(pdev, 1);
+
+	iounmap(par->dc_regs);
+	pci_release_region(pdev, 2);
+
+	iounmap(par->df_regs);
+	pci_release_region(pdev, 3);
+
+	pci_set_drvdata(pdev, NULL);
+	framebuffer_release(info);
+}
+
+static struct pci_device_id lxfb_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LX_VIDEO) },
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, lxfb_id_table);
+
+static struct pci_driver lxfb_driver = {
+	.name		= "lxfb",
+	.id_table	= lxfb_id_table,
+	.probe		= lxfb_probe,
+	.remove		= lxfb_remove,
+};
+
+#ifndef MODULE
+static int __init lxfb_setup(char *options)
+{
+	char *opt;
+
+	if (!options || !*options)
+		return 0;
+
+	while (1) {
+		char *opt = strsep(&options, ",");
+
+		if (opt == NULL)
+			break;
+
+		if (!*opt)
+			continue;
+
+		if (!strncmp(opt, "fbsize:", 7))
+			fbsize = simple_strtoul(opt+7, NULL, 0);
+		else if (!strcmp(opt, "noclear"))
+			noclear = 1;
+		else if (!strcmp(opt, "nopanel"))
+			nopanel = 1;
+		else if (!strcmp(opt, "nocrt"))
+			nocrt = 1;
+		else
+			mode_option = opt;
+	}
+
+	return 0;
+}
+#endif
+
+static int __init lxfb_init(void)
+{
+#ifndef MODULE
+	char *option = NULL;
+
+	if (fb_get_options("lxfb", &option))
+		return -ENODEV;
+
+	lxfb_setup(option);
+#endif
+	return pci_register_driver(&lxfb_driver);
+}
+static void __exit lxfb_cleanup(void)
+{
+	pci_unregister_driver(&lxfb_driver);
+}
+
+module_init(lxfb_init);
+module_exit(lxfb_cleanup);
+
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
+
+module_param(fbsize, int, 0);
+MODULE_PARM_DESC(fbsize, "video memory size");
+
+MODULE_DESCRIPTION("Framebuffer driver for the AMD Geode LX");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/video/geode/lxfb_ops.c
--- /dev/null
+++ a/drivers/video/geode/lxfb_ops.c
@@ -0,0 +1,536 @@
+/* Geode LX framebuffer driver
+ *
+ * Copyright (C) 2006-2007, Advanced Micro Devices,Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include <linux/uaccess.h>
+#include <linux/delay.h>
+
+#include "lxfb.h"
+
+/* TODO
+ * Support panel scaling
+ * Add acceleration
+ * Add support for interlacing (TV out)
+ * Support compression
+ */
+
+/* This is the complete list of PLL frequencies that we can set -
+ * we will choose the closest match to the incoming clock.
+ * freq is the frequency of the dotclock * 1000 (for example,
+ * 24823 = 24.983 Mhz).
+ * pllval is the corresponding PLL value
+*/
+
+static const struct {
+  unsigned int pllval;
+  unsigned int freq;
+} pll_table[] = {
+  { 0x000031AC, 24923 },
+  { 0x0000215D, 25175 },
+  { 0x00001087, 27000 },
+  { 0x0000216C, 28322 },
+  { 0x0000218D, 28560 },
+  { 0x000010C9, 31200 },
+  { 0x00003147, 31500 },
+  { 0x000010A7, 33032 },
+  { 0x00002159, 35112 },
+  { 0x00004249, 35500 },
+  { 0x00000057, 36000 },
+  { 0x0000219A, 37889 },
+  { 0x00002158, 39168 },
+  { 0x00000045, 40000 },
+  { 0x00000089, 43163 },
+  { 0x000010E7, 44900 },
+  { 0x00002136, 45720 },
+  { 0x00003207, 49500 },
+  { 0x00002187, 50000 },
+  { 0x00004286, 56250 },
+  { 0x000010E5, 60065 },
+  { 0x00004214, 65000 },
+  { 0x00001105, 68179 },
+  { 0x000031E4, 74250 },
+  { 0x00003183, 75000 },
+  { 0x00004284, 78750 },
+  { 0x00001104, 81600 },
+  { 0x00006363, 94500 },
+  { 0x00005303, 97520 },
+  { 0x00002183, 100187 },
+  { 0x00002122, 101420 },
+  { 0x00001081, 108000 },
+  { 0x00006201, 113310 },
+  { 0x00000041, 119650 },
+  { 0x000041A1, 129600 },
+  { 0x00002182, 133500 },
+  { 0x000041B1, 135000 },
+  { 0x00000051, 144000 },
+  { 0x000041E1, 148500 },
+  { 0x000062D1, 157500 },
+  { 0x000031A1, 162000 },
+  { 0x00000061, 169203 },
+  { 0x00004231, 172800 },
+  { 0x00002151, 175500 },
+  { 0x000052E1, 189000 },
+  { 0x00000071, 192000 },
+  { 0x00003201, 198000 },
+  { 0x00004291, 202500 },
+  { 0x00001101, 204750 },
+  { 0x00007481, 218250 },
+  { 0x00004170, 229500 },
+  { 0x00006210, 234000 },
+  { 0x00003140, 251182 },
+  { 0x00006250, 261000 },
+  { 0x000041C0, 278400 },
+  { 0x00005220, 280640 },
+  { 0x00000050, 288000 },
+  { 0x000041E0, 297000 },
+  { 0x00002130, 320207 }
+};
+
+
+static void lx_set_dotpll(u32 pllval)
+{
+	u32 dotpll_lo, dotpll_hi;
+	int i;
+
+	rdmsr(MSR_LX_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
+
+	if ((dotpll_lo & GLCP_DOTPLL_LOCK) && (dotpll_hi == pllval))
+		return;
+
+	dotpll_hi = pllval;
+	dotpll_lo &= ~(GLCP_DOTPLL_BYPASS | GLCP_DOTPLL_HALFPIX);
+	dotpll_lo |= GLCP_DOTPLL_RESET;
+
+	wrmsr(MSR_LX_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
+
+	/* Wait 100us for the PLL to lock */
+
+	udelay(100);
+
+	/* Now, loop for the lock bit */
+
+	for (i = 0; i < 1000; i++) {
+		rdmsr(MSR_LX_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
+		if (dotpll_lo & GLCP_DOTPLL_LOCK)
+			break;
+	}
+
+	/* Clear the reset bit */
+
+	dotpll_lo &= ~GLCP_DOTPLL_RESET;
+	wrmsr(MSR_LX_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
+}
+
+/* Set the clock based on the frequency specified by the current mode */
+
+static void lx_set_clock(struct fb_info *info)
+{
+	unsigned int diff, min, best = 0;
+	unsigned int freq, i;
+
+	freq = (unsigned int) (0x3b9aca00 / info->var.pixclock);
+
+	min = abs(pll_table[0].freq - freq);
+
+	for (i = 0; i < ARRAY_SIZE(pll_table); i++) {
+		diff = abs(pll_table[i].freq - freq);
+		if (diff < min) {
+			min = diff;
+			best = i;
+		}
+	}
+
+	lx_set_dotpll(pll_table[best].pllval & 0x7FFF);
+}
+
+static void lx_graphics_disable(struct fb_info *info)
+{
+	struct lxfb_par *par = info->par;
+	unsigned int val, gcfg;
+
+	/* Note:  This assumes that the video is in a quitet state */
+
+	writel(0, par->df_regs + DF_ALPHA_CONTROL_1);
+	writel(0, par->df_regs + DF_ALPHA_CONTROL_1 + 32);
+	writel(0, par->df_regs + DF_ALPHA_CONTROL_1 + 64);
+
+	/* Turn off the VGA and video enable */
+	val = readl (par->dc_regs + DC_GENERAL_CFG) &
+		~(DC_GCFG_VGAE | DC_GCFG_VIDE);
+
+	writel(val, par->dc_regs + DC_GENERAL_CFG);
+
+	val = readl(par->df_regs + DF_VIDEO_CFG) & ~DF_VCFG_VID_EN;
+	writel(val, par->df_regs + DF_VIDEO_CFG);
+
+	writel( DC_IRQ_MASK | DC_VSYNC_IRQ_MASK |
+		DC_IRQ_STATUS | DC_VSYNC_IRQ_STATUS,
+		par->dc_regs + DC_IRQ);
+
+	val = readl(par->dc_regs + DC_GENLCK_CTRL) & ~DC_GENLCK_ENABLE;
+	writel(val, par->dc_regs + DC_GENLCK_CTRL);
+
+	val = readl(par->dc_regs + DC_COLOR_KEY) & ~DC_CLR_KEY_ENABLE;
+	writel(val & ~DC_CLR_KEY_ENABLE, par->dc_regs + DC_COLOR_KEY);
+
+	/* We don't actually blank the panel, due to the long latency
+	   involved with bringing it back */
+
+	val = readl(par->df_regs + DF_MISC) | DF_MISC_DAC_PWRDN;
+	writel(val, par->df_regs + DF_MISC);
+
+	/* Turn off the display */
+
+	val = readl(par->df_regs + DF_DISPLAY_CFG);
+	writel(val & ~(DF_DCFG_CRT_EN | DF_DCFG_HSYNC_EN | DF_DCFG_VSYNC_EN |
+		       DF_DCFG_DAC_BL_EN), par->df_regs + DF_DISPLAY_CFG);
+
+	gcfg = readl(par->dc_regs + DC_GENERAL_CFG);
+	gcfg &= ~(DC_GCFG_CMPE | DC_GCFG_DECE);
+	writel(gcfg, par->dc_regs + DC_GENERAL_CFG);
+
+	/* Turn off the TGEN */
+	val = readl(par->dc_regs + DC_DISPLAY_CFG);
+	val &= ~DC_DCFG_TGEN;
+	writel(val, par->dc_regs + DC_DISPLAY_CFG);
+
+	/* Wait 1000 usecs to ensure that the TGEN is clear */
+	udelay(1000);
+
+	/* Turn off the FIFO loader */
+
+	gcfg &= ~DC_GCFG_DFLE;
+	writel(gcfg, par->dc_regs + DC_GENERAL_CFG);
+
+	/* Lastly, wait for the GP to go idle */
+
+	do {
+		val = readl(par->gp_regs + GP_BLT_STATUS);
+	} while ((val & GP_BS_BLT_BUSY) || !(val & GP_BS_CB_EMPTY));
+}
+
+static void lx_graphics_enable(struct fb_info *info)
+{
+	struct lxfb_par *par = info->par;
+	u32 temp, config;
+
+	/* Set the video request register */
+	writel(0, par->df_regs + DF_VIDEO_REQUEST);
+
+	/* Set up the polarities */
+
+	config = readl(par->df_regs + DF_DISPLAY_CFG);
+
+	config &= ~(DF_DCFG_CRT_SYNC_SKW_MASK | DF_DCFG_PWR_SEQ_DLY_MASK |
+		  DF_DCFG_CRT_HSYNC_POL     | DF_DCFG_CRT_VSYNC_POL);
+
+	config |= (DF_DCFG_CRT_SYNC_SKW_INIT | DF_DCFG_PWR_SEQ_DLY_INIT  |
+		   DF_DCFG_GV_PAL_BYP);
+
+	if (info->var.sync & FB_SYNC_HOR_HIGH_ACT)
+		config |= DF_DCFG_CRT_HSYNC_POL;
+
+	if (info->var.sync & FB_SYNC_VERT_HIGH_ACT)
+		config |= DF_DCFG_CRT_VSYNC_POL;
+
+	if (par->output & OUTPUT_PANEL) {
+		u32 msrlo, msrhi;
+
+		writel(DF_DEFAULT_TFT_PMTIM1,
+		       par->df_regs + DF_PANEL_TIM1);
+		writel(DF_DEFAULT_TFT_PMTIM2,
+		       par->df_regs + DF_PANEL_TIM2);
+		writel(DF_DEFAULT_TFT_DITHCTL,
+		       par->df_regs + DF_DITHER_CONTROL);
+
+		msrlo = DF_DEFAULT_TFT_PAD_SEL_LOW;
+		msrhi = DF_DEFAULT_TFT_PAD_SEL_HIGH;
+
+		wrmsr(MSR_LX_DF_PADSEL, msrlo, msrhi);
+	}
+
+	if (par->output & OUTPUT_CRT) {
+		config |= DF_DCFG_CRT_EN   | DF_DCFG_HSYNC_EN |
+			DF_DCFG_VSYNC_EN | DF_DCFG_DAC_BL_EN;
+	}
+
+	writel(config, par->df_regs + DF_DISPLAY_CFG);
+
+	/* Turn the CRT dacs back on */
+
+	if (par->output & OUTPUT_CRT) {
+		temp = readl(par->df_regs + DF_MISC);
+		temp &= ~(DF_MISC_DAC_PWRDN  | DF_MISC_A_PWRDN);
+		writel(temp, par->df_regs + DF_MISC);
+	}
+
+	/* Turn the panel on (if it isn't already) */
+
+	if (par->output & OUTPUT_PANEL) {
+		temp = readl(par->df_regs + DF_FP_PM);
+
+		if (!(temp & 0x09))
+			writel(temp | DF_FP_PM_P, par->df_regs + DF_FP_PM);
+	}
+
+	temp = readl(par->df_regs + DF_MISC);
+	temp = readl(par->df_regs + DF_DISPLAY_CFG);
+}
+
+unsigned int lx_framebuffer_size(void)
+{
+	unsigned int val;
+
+	/* The frame buffer size is reported by a VSM in VSA II */
+	/* Virtual Register Class    = 0x02                     */
+	/* VG_MEM_SIZE (1MB units)   = 0x00                     */
+
+	outw(0xFC53, 0xAC1C);
+	outw(0x0200, 0xAC1C);
+
+	val = (unsigned int)(inw(0xAC1E)) & 0xFE;
+	return (val << 20);
+}
+
+void lx_set_mode(struct fb_info *info)
+{
+	struct lxfb_par *par = info->par;
+	u64 msrval;
+
+	unsigned int max, dv, val, size;
+
+	unsigned int gcfg, dcfg;
+	int hactive, hblankstart, hsyncstart, hsyncend, hblankend, htotal;
+	int vactive, vblankstart, vsyncstart, vsyncend, vblankend, vtotal;
+
+	/* Unlock the DC registers */
+	writel(DC_UNLOCK_CODE, par->dc_regs + DC_UNLOCK);
+
+	lx_graphics_disable(info);
+
+	lx_set_clock(info);
+
+	/* Set output mode */
+
+	rdmsrl(MSR_LX_DF_GLCONFIG, msrval);
+	msrval &= ~DF_CONFIG_OUTPUT_MASK;
+
+	if (par->output & OUTPUT_PANEL) {
+		msrval |= DF_OUTPUT_PANEL;
+
+		if (par->output & OUTPUT_CRT)
+			msrval |= DF_SIMULTANEOUS_CRT_AND_FP;
+		else
+			msrval &= ~DF_SIMULTANEOUS_CRT_AND_FP;
+	} else {
+		msrval |= DF_OUTPUT_CRT;
+	}
+
+	wrmsrl(MSR_LX_DF_GLCONFIG, msrval);
+
+	/* Clear the various buffers */
+	/* FIXME:  Adjust for panning here */
+
+	writel(0, par->dc_regs + DC_FB_START);
+	writel(0, par->dc_regs + DC_CB_START);
+	writel(0, par->dc_regs + DC_CURSOR_START);
+
+	/* FIXME: Add support for interlacing */
+	/* FIXME: Add support for scaling */
+
+	val = readl(par->dc_regs + DC_GENLCK_CTRL);
+	val &= ~(DC_GC_ALPHA_FLICK_ENABLE |
+		 DC_GC_FLICKER_FILTER_ENABLE | DC_GC_FLICKER_FILTER_MASK);
+
+	/* Default scaling params */
+
+	writel((0x4000 << 16) | 0x4000, par->dc_regs + DC_GFX_SCALE);
+	writel(0, par->dc_regs + DC_IRQ_FILT_CTL);
+	writel(val, par->dc_regs + DC_GENLCK_CTRL);
+
+	/* FIXME:  Support compression */
+
+	if (info->fix.line_length > 4096)
+		dv = DC_DV_LINE_SIZE_8192;
+	else if (info->fix.line_length > 2048)
+		dv = DC_DV_LINE_SIZE_4096;
+	else if (info->fix.line_length > 1024)
+		dv = DC_DV_LINE_SIZE_2048;
+	else
+		dv = DC_DV_LINE_SIZE_1024;
+
+	max = info->fix.line_length * info->var.yres;
+	max = (max + 0x3FF) & 0xFFFFFC00;
+
+	writel(max | DC_DV_TOP_ENABLE, par->dc_regs + DC_DV_TOP);
+
+	val = readl(par->dc_regs + DC_DV_CTL) & ~DC_DV_LINE_SIZE_MASK;
+	writel(val | dv, par->dc_regs + DC_DV_CTL);
+
+	size = info->var.xres * (info->var.bits_per_pixel >> 3);
+
+	writel(info->fix.line_length >> 3, par->dc_regs + DC_GRAPHICS_PITCH);
+	writel((size + 7) >> 3, par->dc_regs + DC_LINE_SIZE);
+
+	/* Set default watermark values */
+
+	rdmsrl(MSR_LX_DC_SPARE, msrval);
+
+	msrval &= ~(DC_SPARE_DISABLE_CFIFO_HGO | DC_SPARE_VFIFO_ARB_SELECT |
+		    DC_SPARE_LOAD_WM_LPEN_MASK | DC_SPARE_WM_LPEN_OVRD |
+		    DC_SPARE_DISABLE_INIT_VID_PRI | DC_SPARE_DISABLE_VFIFO_WM);
+	msrval |= DC_SPARE_DISABLE_VFIFO_WM | DC_SPARE_DISABLE_INIT_VID_PRI;
+	wrmsrl(MSR_LX_DC_SPARE, msrval);
+
+	gcfg = DC_GCFG_DFLE;   /* Display fifo enable */
+	gcfg |= 0xB600;         /* Set default priority */
+	gcfg |= DC_GCFG_FDTY;  /* Set the frame dirty mode */
+
+	dcfg  = DC_DCFG_VDEN;  /* Enable video data */
+	dcfg |= DC_DCFG_GDEN;  /* Enable graphics */
+	dcfg |= DC_DCFG_TGEN;  /* Turn on the timing generator */
+	dcfg |= DC_DCFG_TRUP;  /* Update timings immediately */
+	dcfg |= DC_DCFG_PALB;  /* Palette bypass in > 8 bpp modes */
+	dcfg |= DC_DCFG_VISL;
+	dcfg |= DC_DCFG_DCEN;  /* Always center the display */
+
+	/* Set the current BPP mode */
+
+	switch (info->var.bits_per_pixel) {
+	case 8:
+		dcfg |= DC_DCFG_DISP_MODE_8BPP;
+		break;
+
+	case 16:
+		dcfg |= DC_DCFG_DISP_MODE_16BPP | DC_DCFG_16BPP;
+		break;
+
+	case 32:
+	case 24:
+		dcfg |= DC_DCFG_DISP_MODE_24BPP;
+		break;
+	}
+
+	/* Now - set up the timings */
+
+	hactive = info->var.xres;
+	hblankstart = hactive;
+	hsyncstart = hblankstart + info->var.right_margin;
+	hsyncend =  hsyncstart + info->var.hsync_len;
+	hblankend = hsyncend + info->var.left_margin;
+	htotal = hblankend;
+
+	vactive = info->var.yres;
+	vblankstart = vactive;
+	vsyncstart = vblankstart + info->var.lower_margin;
+	vsyncend =  vsyncstart + info->var.vsync_len;
+	vblankend = vsyncend + info->var.upper_margin;
+	vtotal = vblankend;
+
+	writel((hactive - 1) | ((htotal - 1) << 16),
+	       par->dc_regs + DC_H_ACTIVE_TIMING);
+	writel((hblankstart - 1) | ((hblankend - 1) << 16),
+	       par->dc_regs + DC_H_BLANK_TIMING);
+	writel((hsyncstart - 1) | ((hsyncend - 1) << 16),
+	       par->dc_regs + DC_H_SYNC_TIMING);
+
+	writel((vactive - 1) | ((vtotal - 1) << 16),
+	       par->dc_regs + DC_V_ACTIVE_TIMING);
+
+	writel((vblankstart - 1) | ((vblankend - 1) << 16),
+	       par->dc_regs + DC_V_BLANK_TIMING);
+
+	writel((vsyncstart - 1)  | ((vsyncend - 1) << 16),
+	       par->dc_regs + DC_V_SYNC_TIMING);
+
+	writel( (info->var.xres - 1) << 16 | (info->var.yres - 1),
+		par->dc_regs + DC_FB_ACTIVE);
+
+	/* And re-enable the graphics output */
+	lx_graphics_enable(info);
+
+	/* Write the two main configuration registers */
+	writel(dcfg, par->dc_regs + DC_DISPLAY_CFG);
+	writel(0, par->dc_regs + DC_ARB_CFG);
+	writel(gcfg, par->dc_regs + DC_GENERAL_CFG);
+
+	/* Lock the DC registers */
+	writel(0, par->dc_regs + DC_UNLOCK);
+}
+
+void lx_set_palette_reg(struct fb_info *info, unsigned regno,
+			unsigned red, unsigned green, unsigned blue)
+{
+	struct lxfb_par *par = info->par;
+	int val;
+
+	/* Hardware palette is in RGB 8-8-8 format. */
+
+	val  = (red   << 8) & 0xff0000;
+	val |= (green)      & 0x00ff00;
+	val |= (blue  >> 8) & 0x0000ff;
+
+	writel(regno, par->dc_regs + DC_PAL_ADDRESS);
+	writel(val, par->dc_regs + DC_PAL_DATA);
+}
+
+int lx_blank_display(struct fb_info *info, int blank_mode)
+{
+	struct lxfb_par *par = info->par;
+	u32 dcfg, fp_pm;
+	int blank, hsync, vsync;
+
+	/* CRT power saving modes. */
+	switch (blank_mode) {
+	case FB_BLANK_UNBLANK:
+		blank = 0; hsync = 1; vsync = 1;
+		break;
+	case FB_BLANK_NORMAL:
+		blank = 1; hsync = 1; vsync = 1;
+		break;
+	case FB_BLANK_VSYNC_SUSPEND:
+		blank = 1; hsync = 1; vsync = 0;
+		break;
+	case FB_BLANK_HSYNC_SUSPEND:
+		blank = 1; hsync = 0; vsync = 1;
+		break;
+	case FB_BLANK_POWERDOWN:
+		blank = 1; hsync = 0; vsync = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	dcfg = readl(par->df_regs + DF_DISPLAY_CFG);
+	dcfg &= ~(DF_DCFG_DAC_BL_EN
+		  | DF_DCFG_HSYNC_EN | DF_DCFG_VSYNC_EN);
+	if (!blank)
+		dcfg |= DF_DCFG_DAC_BL_EN;
+	if (hsync)
+		dcfg |= DF_DCFG_HSYNC_EN;
+	if (vsync)
+		dcfg |= DF_DCFG_VSYNC_EN;
+	writel(dcfg, par->df_regs + DF_DISPLAY_CFG);
+
+	/* Power on/off flat panel */
+
+	if (par->output & OUTPUT_PANEL) {
+		fp_pm = readl(par->df_regs + DF_FP_PM);
+		if (blank_mode == FB_BLANK_POWERDOWN)
+			fp_pm &= ~DF_FP_PM_P;
+		else
+			fp_pm |= DF_FP_PM_P;
+		writel(fp_pm, par->df_regs + DF_FP_PM);
+	}
+
+	return 0;
+}
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

origin.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
