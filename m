From: akpm@linux-foundation.org
Subject: - gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:39 -0700
Message-ID: <200804282157.m3SLvdi1018416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965219AbYD1V56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     gxfb: create DC/VP/FP-specific handlers rather than using readl/writel
has been removed from the -mm tree.  Its filename was
     gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gxfb: create DC/VP/FP-specific handlers rather than using readl/writel
From: Andres Salomon <dilinger@queued.net>

This creates read_dc/write_dc, read_vp/write_vp, and read_fp/write_fp for
reading and updating those registers.  It creates gxfb.h to house these.

We also drop a no-op readl() from gx_set_mode.  Other than that, there should
be no functionality change.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/display_gx.c |   50 ++++++++++++++++-------------
 drivers/video/geode/gxfb.h       |   47 +++++++++++++++++++++++++++
 drivers/video/geode/gxfb_core.c  |    4 +-
 drivers/video/geode/video_gx.c   |   41 ++++++++++++-----------
 4 files changed, 98 insertions(+), 44 deletions(-)

diff -puN drivers/video/geode/display_gx.c~gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel drivers/video/geode/display_gx.c
--- a/drivers/video/geode/display_gx.c~gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel
+++ a/drivers/video/geode/display_gx.c
@@ -20,6 +20,7 @@
 
 #include "geodefb.h"
 #include "display_gx.h"
+#include "gxfb.h"
 
 unsigned int gx_frame_buffer_size(void)
 {
@@ -50,22 +51,21 @@ static void gx_set_mode(struct fb_info *
 	int vactive, vblankstart, vsyncstart, vsyncend, vblankend, vtotal;
 
 	/* Unlock the display controller registers. */
-	readl(par->dc_regs + DC_UNLOCK);
-	writel(DC_UNLOCK_CODE, par->dc_regs + DC_UNLOCK);
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_CODE);
 
-	gcfg = readl(par->dc_regs + DC_GENERAL_CFG);
-	dcfg = readl(par->dc_regs + DC_DISPLAY_CFG);
+	gcfg = read_dc(par, DC_GENERAL_CFG);
+	dcfg = read_dc(par, DC_DISPLAY_CFG);
 
 	/* Disable the timing generator. */
 	dcfg &= ~(DC_DCFG_TGEN);
-	writel(dcfg, par->dc_regs + DC_DISPLAY_CFG);
+	write_dc(par, DC_DISPLAY_CFG, dcfg);
 
 	/* Wait for pending memory requests before disabling the FIFO load. */
 	udelay(100);
 
 	/* Disable FIFO load and compression. */
 	gcfg &= ~(DC_GCFG_DFLE | DC_GCFG_CMPE | DC_GCFG_DECE);
-	writel(gcfg, par->dc_regs + DC_GENERAL_CFG);
+	write_dc(par, DC_GENERAL_CFG, gcfg);
 
 	/* Setup DCLK and its divisor. */
 	par->vid_ops->set_dclk(info);
@@ -83,12 +83,12 @@ static void gx_set_mode(struct fb_info *
 	gcfg |= (6 << DC_GCFG_DFHPEL_POS) | (5 << DC_GCFG_DFHPSL_POS) | DC_GCFG_DFLE;
 
 	/* Framebuffer start offset. */
-	writel(0, par->dc_regs + DC_FB_ST_OFFSET);
+	write_dc(par, DC_FB_ST_OFFSET, 0);
 
 	/* Line delta and line buffer length. */
-	writel(info->fix.line_length >> 3, par->dc_regs + DC_GFX_PITCH);
-	writel(((info->var.xres * info->var.bits_per_pixel/8) >> 3) + 2,
-	       par->dc_regs + DC_LINE_SIZE);
+	write_dc(par, DC_GFX_PITCH, info->fix.line_length >> 3);
+	write_dc(par, DC_LINE_SIZE,
+		((info->var.xres * info->var.bits_per_pixel/8) >> 3) + 2);
 
 
 	/* Enable graphics and video data and unmask address lines. */
@@ -127,22 +127,28 @@ static void gx_set_mode(struct fb_info *
 	vblankend = vsyncend + info->var.upper_margin;
 	vtotal = vblankend;
 
-	writel((hactive - 1)     | ((htotal - 1) << 16),    par->dc_regs + DC_H_ACTIVE_TIMING);
-	writel((hblankstart - 1) | ((hblankend - 1) << 16), par->dc_regs + DC_H_BLANK_TIMING);
-	writel((hsyncstart - 1)  | ((hsyncend - 1) << 16),  par->dc_regs + DC_H_SYNC_TIMING);
-
-	writel((vactive - 1)     | ((vtotal - 1) << 16),    par->dc_regs + DC_V_ACTIVE_TIMING);
-	writel((vblankstart - 1) | ((vblankend - 1) << 16), par->dc_regs + DC_V_BLANK_TIMING);
-	writel((vsyncstart - 1)  | ((vsyncend - 1) << 16),  par->dc_regs + DC_V_SYNC_TIMING);
+	write_dc(par, DC_H_ACTIVE_TIMING, (hactive - 1)    |
+			((htotal - 1) << 16));
+	write_dc(par, DC_H_BLANK_TIMING, (hblankstart - 1) |
+			((hblankend - 1) << 16));
+	write_dc(par, DC_H_SYNC_TIMING, (hsyncstart - 1)   |
+			((hsyncend - 1) << 16));
+
+	write_dc(par, DC_V_ACTIVE_TIMING, (vactive - 1)    |
+			((vtotal - 1) << 16));
+	write_dc(par, DC_V_BLANK_TIMING, (vblankstart - 1) |
+			((vblankend - 1) << 16));
+	write_dc(par, DC_V_SYNC_TIMING, (vsyncstart - 1)   |
+			((vsyncend - 1) << 16));
 
 	/* Write final register values. */
-	writel(dcfg, par->dc_regs + DC_DISPLAY_CFG);
-	writel(gcfg, par->dc_regs + DC_GENERAL_CFG);
+	write_dc(par, DC_DISPLAY_CFG, dcfg);
+	write_dc(par, DC_GENERAL_CFG, gcfg);
 
 	par->vid_ops->configure_display(info);
 
 	/* Relock display controller registers */
-	writel(0, par->dc_regs + DC_UNLOCK);
+	write_dc(par, DC_UNLOCK, 0);
 }
 
 static void gx_set_hw_palette_reg(struct fb_info *info, unsigned regno,
@@ -156,8 +162,8 @@ static void gx_set_hw_palette_reg(struct
 	val |= (green)      & 0x00ff00;
 	val |= (blue  >> 8) & 0x0000ff;
 
-	writel(regno, par->dc_regs + DC_PAL_ADDRESS);
-	writel(val, par->dc_regs + DC_PAL_DATA);
+	write_dc(par, DC_PAL_ADDRESS, regno);
+	write_dc(par, DC_PAL_DATA, val);
 }
 
 struct geode_dc_ops gx_dc_ops = {
diff -puN /dev/null drivers/video/geode/gxfb.h
--- /dev/null
+++ a/drivers/video/geode/gxfb.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2008 Andres Salomon <dilinger@debian.org>
+ *
+ * Geode GX2 register tables
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef _GXFB_H_
+#define _GXFB_H_
+
+#include <linux/io.h>
+
+static inline uint32_t read_dc(struct geodefb_par *par, int reg)
+{
+	return readl(par->dc_regs + reg);
+}
+
+static inline void write_dc(struct geodefb_par *par, int reg, uint32_t val)
+{
+	writel(val, par->dc_regs + reg);
+
+}
+
+static inline uint32_t read_vp(struct geodefb_par *par, int reg)
+{
+	return readl(par->vid_regs + reg);
+}
+
+static inline void write_vp(struct geodefb_par *par, int reg, uint32_t val)
+{
+	writel(val, par->vid_regs + reg);
+}
+
+static inline uint32_t read_fp(struct geodefb_par *par, int reg)
+{
+	return readl(par->vid_regs + reg);
+}
+
+static inline void write_fp(struct geodefb_par *par, int reg, uint32_t val)
+{
+	writel(val, par->vid_regs + reg);
+}
+
+#endif
diff -puN drivers/video/geode/gxfb_core.c~gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel
+++ a/drivers/video/geode/gxfb_core.c
@@ -35,6 +35,7 @@
 #include "geodefb.h"
 #include "display_gx.h"
 #include "video_gx.h"
+#include "gxfb.h"
 
 static char *mode_option;
 static int vram;
@@ -243,8 +244,7 @@ static int __init gxfb_map_video_memory(
 	/* Set the 16MiB aligned base address of the graphics memory region
 	 * in the display controller */
 
-	writel(info->fix.smem_start & 0xFF000000,
-			par->dc_regs + DC_GLIU0_MEM_OFFSET);
+	write_dc(par, DC_GLIU0_MEM_OFFSET, info->fix.smem_start & 0xFF000000);
 
 	dev_info(&dev->dev, "%d KiB of video memory at 0x%lx\n",
 		 info->fix.smem_len / 1024, info->fix.smem_start);
diff -puN drivers/video/geode/video_gx.c~gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel drivers/video/geode/video_gx.c
--- a/drivers/video/geode/video_gx.c~gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel
+++ a/drivers/video/geode/video_gx.c
@@ -20,6 +20,7 @@
 
 #include "geodefb.h"
 #include "video_gx.h"
+#include "gxfb.h"
 
 
 /*
@@ -192,16 +193,16 @@ gx_configure_tft(struct fb_info *info)
 
 	/* Turn off the panel */
 
-	fp = readl(par->vid_regs + GX_FP_PM);
+	fp = read_fp(par, GX_FP_PM);
 	fp &= ~GX_FP_PM_P;
-	writel(fp, par->vid_regs + GX_FP_PM);
+	write_fp(par, GX_FP_PM, fp);
 
 	/* Set timing 1 */
 
-	fp = readl(par->vid_regs + GX_FP_PT1);
+	fp = read_fp(par, GX_FP_PT1);
 	fp &= GX_FP_PT1_VSIZE_MASK;
 	fp |= info->var.yres << GX_FP_PT1_VSIZE_SHIFT;
-	writel(fp, par->vid_regs + GX_FP_PT1);
+	write_fp(par, GX_FP_PT1, fp);
 
 	/* Timing 2 */
 	/* Set bits that are always on for TFT */
@@ -216,22 +217,22 @@ gx_configure_tft(struct fb_info *info)
 	if (!(info->var.sync & FB_SYNC_HOR_HIGH_ACT))
 		fp |= GX_FP_PT2_HSP;
 
-	writel(fp, par->vid_regs + GX_FP_PT2);
+	write_fp(par, GX_FP_PT2, fp);
 
 	/*  Set the dither control */
-	writel(0x70, par->vid_regs + GX_FP_DFC);
+	write_fp(par, GX_FP_DFC, 0x70);
 
 	/* Enable the FP data and power (in case the BIOS didn't) */
 
-	fp = readl(par->vid_regs + GX_DCFG);
+	fp = read_vp(par, GX_DCFG);
 	fp |= GX_DCFG_FP_PWR_EN | GX_DCFG_FP_DATA_EN;
-	writel(fp, par->vid_regs + GX_DCFG);
+	write_vp(par, GX_DCFG, fp);
 
 	/* Unblank the panel */
 
-	fp = readl(par->vid_regs + GX_FP_PM);
+	fp = read_fp(par, GX_FP_PM);
 	fp |= GX_FP_PM_P;
-	writel(fp, par->vid_regs + GX_FP_PM);
+	write_fp(par, GX_FP_PM, fp);
 }
 
 static void gx_configure_display(struct fb_info *info)
@@ -240,11 +241,11 @@ static void gx_configure_display(struct 
 	u32 dcfg, misc;
 
 	/* Write the display configuration */
-	dcfg = readl(par->vid_regs + GX_DCFG);
+	dcfg = read_vp(par, GX_DCFG);
 
 	/* Disable hsync and vsync */
 	dcfg &= ~(GX_DCFG_VSYNC_EN | GX_DCFG_HSYNC_EN);
-	writel(dcfg, par->vid_regs + GX_DCFG);
+	write_vp(par, GX_DCFG, dcfg);
 
 	/* Clear bits from existing mode. */
 	dcfg &= ~(GX_DCFG_CRT_SYNC_SKW_MASK
@@ -257,7 +258,7 @@ static void gx_configure_display(struct 
 	/* Enable hsync and vsync. */
 	dcfg |= GX_DCFG_HSYNC_EN | GX_DCFG_VSYNC_EN;
 
-	misc = readl(par->vid_regs + GX_MISC);
+	misc = read_vp(par, GX_MISC);
 
 	/* Disable gamma correction */
 	misc |= GX_MISC_GAM_EN;
@@ -266,7 +267,7 @@ static void gx_configure_display(struct 
 
 		/* Power up the CRT DACs */
 		misc &= ~(GX_MISC_A_PWRDN | GX_MISC_DAC_PWRDN);
-		writel(misc, par->vid_regs + GX_MISC);
+		write_vp(par, GX_MISC, misc);
 
 		/* Only change the sync polarities if we are running
 		 * in CRT mode.  The FP polarities will be handled in
@@ -278,7 +279,7 @@ static void gx_configure_display(struct 
 	} else {
 		/* Power down the CRT DACs if in FP mode */
 		misc |= (GX_MISC_A_PWRDN | GX_MISC_DAC_PWRDN);
-		writel(misc, par->vid_regs + GX_MISC);
+		write_vp(par, GX_MISC, misc);
 	}
 
 	/* Enable the display logic */
@@ -288,7 +289,7 @@ static void gx_configure_display(struct 
 
 	/* Enable the external DAC VREF? */
 
-	writel(dcfg, par->vid_regs + GX_DCFG);
+	write_vp(par, GX_DCFG, dcfg);
 
 	/* Set up the flat panel (if it is enabled) */
 
@@ -322,7 +323,7 @@ static int gx_blank_display(struct fb_in
 	default:
 		return -EINVAL;
 	}
-	dcfg = readl(par->vid_regs + GX_DCFG);
+	dcfg = read_vp(par, GX_DCFG);
 	dcfg &= ~(GX_DCFG_DAC_BL_EN
 		  | GX_DCFG_HSYNC_EN | GX_DCFG_VSYNC_EN);
 	if (!blank)
@@ -331,17 +332,17 @@ static int gx_blank_display(struct fb_in
 		dcfg |= GX_DCFG_HSYNC_EN;
 	if (vsync)
 		dcfg |= GX_DCFG_VSYNC_EN;
-	writel(dcfg, par->vid_regs + GX_DCFG);
+	write_vp(par, GX_DCFG, dcfg);
 
 	/* Power on/off flat panel. */
 
 	if (par->enable_crt == 0) {
-		fp_pm = readl(par->vid_regs + GX_FP_PM);
+		fp_pm = read_fp(par, GX_FP_PM);
 		if (blank_mode == FB_BLANK_POWERDOWN)
 			fp_pm &= ~GX_FP_PM_P;
 		else
 			fp_pm |= GX_FP_PM_P;
-		writel(fp_pm, par->vid_regs + GX_FP_PM);
+		write_fp(par, GX_FP_PM, fp_pm);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

