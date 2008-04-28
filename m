From: akpm@linux-foundation.org
Subject: - gxfb-add-power-management-functionality.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:47 -0700
Message-ID: <200804282157.m3SLvlfl018428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934217AbYD1V6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     gxfb: add power management functionality
has been removed from the -mm tree.  Its filename was
     gxfb-add-power-management-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gxfb: add power management functionality
From: Andres Salomon <dilinger@queued.net>

This adds the ability to suspend/resume the gxfb driver, which includes:
  - The addition of a Graphics Processor register table in gxfb.h, and
    associated GP handling.
  - Register and palette saving code; registers are stored in gxfb_par.
    A few MSR values are saved as well.
  - gx_powerup and gx_powerdown functions which restore/save registers and
    enable/disable graphic engines.
  - gxfb_suspend/gxfb_resume

Originally based on a patch by Jordan Crouse.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/Makefile     |    2 
 drivers/video/geode/gxfb.h       |   72 +++++++
 drivers/video/geode/gxfb_core.c  |   57 ++++++
 drivers/video/geode/suspend_gx.c |  267 +++++++++++++++++++++++++++++
 4 files changed, 396 insertions(+), 2 deletions(-)

diff -puN drivers/video/geode/Makefile~gxfb-add-power-management-functionality drivers/video/geode/Makefile
--- a/drivers/video/geode/Makefile~gxfb-add-power-management-functionality
+++ a/drivers/video/geode/Makefile
@@ -5,5 +5,5 @@ obj-$(CONFIG_FB_GEODE_GX)  += gxfb.o
 obj-$(CONFIG_FB_GEODE_LX)  += lxfb.o
 
 gx1fb-objs := gx1fb_core.o display_gx1.o video_cs5530.o
-gxfb-objs  := gxfb_core.o display_gx.o video_gx.o
+gxfb-objs  := gxfb_core.o display_gx.o video_gx.o suspend_gx.o
 lxfb-objs  := lxfb_core.o lxfb_ops.o
diff -puN drivers/video/geode/gxfb.h~gxfb-add-power-management-functionality drivers/video/geode/gxfb.h
--- a/drivers/video/geode/gxfb.h~gxfb-add-power-management-functionality
+++ a/drivers/video/geode/gxfb.h
@@ -13,10 +13,34 @@
 
 #include <linux/io.h>
 
+#define GP_REG_COUNT   (0x50 / 4)
+#define DC_REG_COUNT   (0x90 / 4)
+#define VP_REG_COUNT   (0x138 / 8)
+#define FP_REG_COUNT   (0x68 / 8)
+
+#define DC_PAL_COUNT   0x104
+
 struct gxfb_par {
 	int enable_crt;
 	void __iomem *dc_regs;
 	void __iomem *vid_regs;
+	void __iomem *gp_regs;
+#ifdef CONFIG_PM
+	int powered_down;
+
+	/* register state, for power management functionality */
+	struct {
+		uint64_t padsel;
+		uint64_t dotpll;
+	} msr;
+
+	uint32_t gp[GP_REG_COUNT];
+	uint32_t dc[DC_REG_COUNT];
+	uint64_t vp[VP_REG_COUNT];
+	uint64_t fp[FP_REG_COUNT];
+
+	uint32_t pal[DC_PAL_COUNT];
+#endif
 };
 
 unsigned int gx_frame_buffer_size(void);
@@ -29,6 +53,43 @@ void gx_set_dclk_frequency(struct fb_inf
 void gx_configure_display(struct fb_info *info);
 int gx_blank_display(struct fb_info *info, int blank_mode);
 
+#ifdef CONFIG_PM
+int gx_powerdown(struct fb_info *info);
+int gx_powerup(struct fb_info *info);
+#endif
+
+
+/* Graphics Processor registers (table 6-23 from the data book) */
+enum gp_registers {
+	GP_DST_OFFSET = 0,
+	GP_SRC_OFFSET,
+	GP_STRIDE,
+	GP_WID_HEIGHT,
+
+	GP_SRC_COLOR_FG,
+	GP_SRC_COLOR_BG,
+	GP_PAT_COLOR_0,
+	GP_PAT_COLOR_1,
+
+	GP_PAT_COLOR_2,
+	GP_PAT_COLOR_3,
+	GP_PAT_COLOR_4,
+	GP_PAT_COLOR_5,
+
+	GP_PAT_DATA_0,
+	GP_PAT_DATA_1,
+	GP_RASTER_MODE,
+	GP_VECTOR_MODE,
+
+	GP_BLT_MODE,
+	GP_BLT_STATUS,
+	GP_HST_SRC,
+	GP_BASE_OFFSET, /* 0x4c */
+};
+
+#define GP_BLT_STATUS_BLT_PENDING	(1 << 2)
+#define GP_BLT_STATUS_BLT_BUSY		(1 << 0)
+
 
 /* Display Controller registers (table 6-38 from the data book) */
 enum dc_registers {
@@ -238,6 +299,16 @@ enum fp_registers {
 
 /* register access functions */
 
+static inline uint32_t read_gp(struct gxfb_par *par, int reg)
+{
+	return readl(par->gp_regs + 4*reg);
+}
+
+static inline void write_gp(struct gxfb_par *par, int reg, uint32_t val)
+{
+	writel(val, par->gp_regs + 4*reg);
+}
+
 static inline uint32_t read_dc(struct gxfb_par *par, int reg)
 {
 	return readl(par->dc_regs + 4*reg);
@@ -248,7 +319,6 @@ static inline void write_dc(struct gxfb_
 	writel(val, par->dc_regs + 4*reg);
 }
 
-
 static inline uint32_t read_vp(struct gxfb_par *par, int reg)
 {
 	return readl(par->vid_regs + 8*reg);
diff -puN drivers/video/geode/gxfb_core.c~gxfb-add-power-management-functionality drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-add-power-management-functionality
+++ a/drivers/video/geode/gxfb_core.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/fb.h>
+#include <linux/console.h>
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <asm/geode.h>
@@ -222,6 +223,15 @@ static int __init gxfb_map_video_memory(
 	if (!par->dc_regs)
 		return -ENOMEM;
 
+	ret = pci_request_region(dev, 1, "gxfb (graphics processor)");
+	if (ret < 0)
+		return ret;
+	par->gp_regs = ioremap(pci_resource_start(dev, 1),
+	pci_resource_len(dev, 1));
+
+	if (!par->gp_regs)
+		return -ENOMEM;
+
 	ret = pci_request_region(dev, 0, "gxfb (framebuffer)");
 	if (ret < 0)
 		return ret;
@@ -295,6 +305,42 @@ static struct fb_info * __init gxfb_init
 	return info;
 }
 
+#ifdef CONFIG_PM
+static int gxfb_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct fb_info *info = pci_get_drvdata(pdev);
+
+	if (state.event == PM_EVENT_SUSPEND) {
+		acquire_console_sem();
+		gx_powerdown(info);
+		fb_set_suspend(info, 1);
+		release_console_sem();
+	}
+
+	/* there's no point in setting PCI states; we emulate PCI, so
+	 * we don't end up getting power savings anyways */
+
+	return 0;
+}
+
+static int gxfb_resume(struct pci_dev *pdev)
+{
+	struct fb_info *info = pci_get_drvdata(pdev);
+	int ret;
+
+	acquire_console_sem();
+	ret = gx_powerup(info);
+	if (ret) {
+		printk(KERN_ERR "gxfb:  power up failed!\n");
+		return ret;
+	}
+
+	fb_set_suspend(info, 0);
+	release_console_sem();
+	return 0;
+}
+#endif
+
 static int __init gxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct gxfb_par *par;
@@ -357,6 +403,10 @@ static int __init gxfb_probe(struct pci_
 		iounmap(par->dc_regs);
 		pci_release_region(pdev, 2);
 	}
+	if (par->gp_regs) {
+		iounmap(par->gp_regs);
+		pci_release_region(pdev, 1);
+	}
 
 	if (info)
 		framebuffer_release(info);
@@ -379,6 +429,9 @@ static void gxfb_remove(struct pci_dev *
 	iounmap(par->dc_regs);
 	pci_release_region(pdev, 2);
 
+	iounmap(par->gp_regs);
+	pci_release_region(pdev, 1);
+
 	pci_set_drvdata(pdev, NULL);
 
 	framebuffer_release(info);
@@ -396,6 +449,10 @@ static struct pci_driver gxfb_driver = {
 	.id_table	= gxfb_id_table,
 	.probe		= gxfb_probe,
 	.remove		= gxfb_remove,
+#ifdef CONFIG_PM
+	.suspend	= gxfb_suspend,
+	.resume		= gxfb_resume,
+#endif
 };
 
 #ifndef MODULE
diff -puN /dev/null drivers/video/geode/suspend_gx.c
--- /dev/null
+++ a/drivers/video/geode/suspend_gx.c
@@ -0,0 +1,267 @@
+/*
+ *   Copyright (C) 2007 Advanced Micro Devices, Inc.
+ *   Copyright (C) 2008 Andres Salomon <dilinger@debian.org>
+ *
+ *   This program is free software; you can redistribute it and/or modify it
+ *   under the terms of the GNU General Public License as published by the
+ *   Free Software Foundation; either version 2 of the License, or (at your
+ *   option) any later version.
+ */
+#include <linux/fb.h>
+#include <asm/io.h>
+#include <asm/msr.h>
+#include <asm/geode.h>
+#include <asm/delay.h>
+
+#include "gxfb.h"
+
+#ifdef CONFIG_PM
+
+static void gx_save_regs(struct gxfb_par *par)
+{
+	int i;
+
+	/* wait for the BLT engine to stop being busy */
+	do {
+		i = read_gp(par, GP_BLT_STATUS);
+	} while (i & (GP_BLT_STATUS_BLT_PENDING | GP_BLT_STATUS_BLT_BUSY));
+
+	/* save MSRs */
+	rdmsrl(MSR_GX_MSR_PADSEL, par->msr.padsel);
+	rdmsrl(MSR_GLCP_DOTPLL, par->msr.dotpll);
+
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_UNLOCK);
+
+	/* save registers */
+	memcpy(par->gp, par->gp_regs, sizeof(par->gp));
+	memcpy(par->dc, par->dc_regs, sizeof(par->dc));
+	memcpy(par->vp, par->vid_regs, sizeof(par->vp));
+	memcpy(par->fp, par->vid_regs + VP_FP_START, sizeof(par->fp));
+
+	/* save the palette */
+	write_dc(par, DC_PAL_ADDRESS, 0);
+	for (i = 0; i < ARRAY_SIZE(par->pal); i++)
+		par->pal[i] = read_dc(par, DC_PAL_DATA);
+}
+
+static void gx_set_dotpll(uint32_t dotpll_hi)
+{
+	uint32_t dotpll_lo;
+	int i;
+
+	rdmsrl(MSR_GLCP_DOTPLL, dotpll_lo);
+	dotpll_lo |= MSR_GLCP_DOTPLL_DOTRESET;
+	dotpll_lo &= ~MSR_GLCP_DOTPLL_BYPASS;
+	wrmsr(MSR_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
+
+	/* wait for the PLL to lock */
+	for (i = 0; i < 200; i++) {
+		rdmsrl(MSR_GLCP_DOTPLL, dotpll_lo);
+		if (dotpll_lo & MSR_GLCP_DOTPLL_LOCK)
+			break;
+		udelay(1);
+	}
+
+	/* PLL set, unlock */
+	dotpll_lo &= ~MSR_GLCP_DOTPLL_DOTRESET;
+	wrmsr(MSR_GLCP_DOTPLL, dotpll_lo, dotpll_hi);
+}
+
+static void gx_restore_gfx_proc(struct gxfb_par *par)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(par->gp); i++) {
+		switch (i) {
+		case GP_VECTOR_MODE:
+		case GP_BLT_MODE:
+		case GP_BLT_STATUS:
+		case GP_HST_SRC:
+			/* don't restore these registers */
+			break;
+		default:
+			write_gp(par, i, par->gp[i]);
+		}
+	}
+}
+
+static void gx_restore_display_ctlr(struct gxfb_par *par)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(par->dc); i++) {
+		switch (i) {
+		case DC_UNLOCK:
+			/* unlock the DC; runs first */
+			write_dc(par, DC_UNLOCK, DC_UNLOCK_UNLOCK);
+			break;
+
+		case DC_GENERAL_CFG:
+			/* write without the enables */
+			write_dc(par, i, par->dc[i] & ~(DC_GENERAL_CFG_VIDE |
+					DC_GENERAL_CFG_ICNE |
+					DC_GENERAL_CFG_CURE |
+					DC_GENERAL_CFG_DFLE));
+			break;
+
+		case DC_DISPLAY_CFG:
+			/* write without the enables */
+			write_dc(par, i, par->dc[i] & ~(DC_DISPLAY_CFG_VDEN |
+					DC_DISPLAY_CFG_GDEN |
+					DC_DISPLAY_CFG_TGEN));
+			break;
+
+		case DC_RSVD_0:
+		case DC_RSVD_1:
+		case DC_RSVD_2:
+		case DC_RSVD_3:
+		case DC_RSVD_4:
+		case DC_LINE_CNT:
+		case DC_PAL_ADDRESS:
+		case DC_PAL_DATA:
+		case DC_DFIFO_DIAG:
+		case DC_CFIFO_DIAG:
+		case DC_RSVD_5:
+			/* don't restore these registers */
+			break;
+		default:
+			write_dc(par, i, par->dc[i]);
+		}
+	}
+
+	/* restore the palette */
+	write_dc(par, DC_PAL_ADDRESS, 0);
+	for (i = 0; i < ARRAY_SIZE(par->pal); i++)
+		write_dc(par, DC_PAL_DATA, par->pal[i]);
+}
+
+static void gx_restore_video_proc(struct gxfb_par *par)
+{
+	int i;
+
+	wrmsrl(MSR_GX_MSR_PADSEL, par->msr.padsel);
+
+	for (i = 0; i < ARRAY_SIZE(par->vp); i++) {
+		switch (i) {
+		case VP_VCFG:
+			/* don't enable video yet */
+			write_vp(par, i, par->vp[i] & ~VP_VCFG_VID_EN);
+			break;
+
+		case VP_DCFG:
+			/* don't enable CRT yet */
+			write_vp(par, i, par->vp[i] &
+					~(VP_DCFG_DAC_BL_EN | VP_DCFG_VSYNC_EN |
+					VP_DCFG_HSYNC_EN | VP_DCFG_CRT_EN));
+			break;
+
+		case VP_GAR:
+		case VP_GDR:
+		case VP_RSVD_0:
+		case VP_RSVD_1:
+		case VP_RSVD_2:
+		case VP_RSVD_3:
+		case VP_CRC32:
+		case VP_AWT:
+		case VP_VTM:
+			/* don't restore these registers */
+			break;
+		default:
+			write_vp(par, i, par->vp[i]);
+		}
+	}
+}
+
+static void gx_restore_regs(struct gxfb_par *par)
+{
+	int i;
+
+	gx_set_dotpll((uint32_t) (par->msr.dotpll >> 32));
+	gx_restore_gfx_proc(par);
+	gx_restore_display_ctlr(par);
+	gx_restore_video_proc(par);
+
+	/* Flat Panel */
+	for (i = 0; i < ARRAY_SIZE(par->fp); i++) {
+		if (i != FP_PM && i != FP_RSVD_0)
+			write_fp(par, i, par->fp[i]);
+	}
+}
+
+static void gx_disable_graphics(struct gxfb_par *par)
+{
+	/* shut down the engine */
+	write_vp(par, VP_VCFG, par->vp[VP_VCFG] & ~VP_VCFG_VID_EN);
+	write_vp(par, VP_DCFG, par->vp[VP_DCFG] & ~(VP_DCFG_DAC_BL_EN |
+			VP_DCFG_VSYNC_EN | VP_DCFG_HSYNC_EN | VP_DCFG_CRT_EN));
+
+	/* turn off the flat panel */
+	write_fp(par, FP_PM, par->fp[FP_PM] & ~FP_PM_P);
+
+
+	/* turn off display */
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_UNLOCK);
+	write_dc(par, DC_GENERAL_CFG, par->dc[DC_GENERAL_CFG] &
+			~(DC_GENERAL_CFG_VIDE | DC_GENERAL_CFG_ICNE |
+			DC_GENERAL_CFG_CURE | DC_GENERAL_CFG_DFLE));
+	write_dc(par, DC_DISPLAY_CFG, par->dc[DC_DISPLAY_CFG] &
+			~(DC_DISPLAY_CFG_VDEN | DC_DISPLAY_CFG_GDEN |
+			DC_DISPLAY_CFG_TGEN));
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_LOCK);
+}
+
+static void gx_enable_graphics(struct gxfb_par *par)
+{
+	uint32_t fp;
+
+	fp = read_fp(par, FP_PM);
+	if (par->fp[FP_PM] & FP_PM_P) {
+		/* power on the panel if not already power{ed,ing} on */
+		if (!(fp & (FP_PM_PANEL_ON|FP_PM_PANEL_PWR_UP)))
+			write_fp(par, FP_PM, par->fp[FP_PM]);
+	} else {
+		/* power down the panel if not already power{ed,ing} down */
+		if (!(fp & (FP_PM_PANEL_OFF|FP_PM_PANEL_PWR_DOWN)))
+			write_fp(par, FP_PM, par->fp[FP_PM]);
+	}
+
+	/* turn everything on */
+	write_vp(par, VP_VCFG, par->vp[VP_VCFG]);
+	write_vp(par, VP_DCFG, par->vp[VP_DCFG]);
+	write_dc(par, DC_DISPLAY_CFG, par->dc[DC_DISPLAY_CFG]);
+	/* do this last; it will enable the FIFO load */
+	write_dc(par, DC_GENERAL_CFG, par->dc[DC_GENERAL_CFG]);
+
+	/* lock the door behind us */
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_LOCK);
+}
+
+int gx_powerdown(struct fb_info *info)
+{
+	struct gxfb_par *par = info->par;
+
+	if (par->powered_down)
+		return 0;
+
+	gx_save_regs(par);
+	gx_disable_graphics(par);
+
+	par->powered_down = 1;
+	return 0;
+}
+
+int gx_powerup(struct fb_info *info)
+{
+	struct gxfb_par *par = info->par;
+
+	if (!par->powered_down)
+		return 0;
+
+	gx_restore_regs(par);
+	gx_enable_graphics(par);
+
+	par->powered_down  = 0;
+	return 0;
+}
+
+#endif
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

