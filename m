From: akpm@linux-foundation.org
Subject: - lxfb-add-power-management-functionality.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:57 -0700
Message-ID: <200804282158.m3SLwv8D018532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965451AbYD1V7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     lxfb: add power management functionality
has been removed from the -mm tree.  Its filename was
     lxfb-add-power-management-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lxfb: add power management functionality
From: Andres Salomon <dilinger@queued.net>

This adds the ability to suspend/resume the lxfb driver, which includes:
  - Register and palette saving code; registers are stored in lxfb_par.
    A few MSR values are saved as well.
  - lx_powerup and lx_powerdown functions which restore/save registers and
    enable/disable graphic engines.
  - lxfb_suspend/lxfb_resume

Originally based on a patch by Jordan Crouse.

[akpm@linux-foundation.org: be conventional, save an ifdef]
Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb.h      |   45 +++++
 drivers/video/geode/lxfb_core.c |   41 ++++
 drivers/video/geode/lxfb_ops.c  |  263 ++++++++++++++++++++++++++++--
 3 files changed, 340 insertions(+), 9 deletions(-)

diff -puN drivers/video/geode/lxfb.h~lxfb-add-power-management-functionality drivers/video/geode/lxfb.h
--- a/drivers/video/geode/lxfb.h~lxfb-add-power-management-functionality
+++ a/drivers/video/geode/lxfb.h
@@ -3,6 +3,16 @@
 
 #include <linux/fb.h>
 
+#define GP_REG_COUNT	(0x7c / 4)
+#define DC_REG_COUNT	(0xf0 / 4)
+#define VP_REG_COUNT	(0x158 / 8)
+#define FP_REG_COUNT	(0x60 / 8)
+
+#define DC_PAL_COUNT	0x104
+#define DC_HFILT_COUNT	0x100
+#define DC_VFILT_COUNT	0x100
+#define VP_COEFF_SIZE	0x1000
+
 #define OUTPUT_CRT   0x01
 #define OUTPUT_PANEL 0x02
 
@@ -12,6 +22,27 @@ struct lxfb_par {
 	void __iomem *gp_regs;
 	void __iomem *dc_regs;
 	void __iomem *vp_regs;
+#ifdef CONFIG_PM
+	int powered_down;
+
+	/* register state, for power mgmt functionality */
+	struct {
+		uint64_t padsel;
+		uint64_t dotpll;
+		uint64_t dfglcfg;
+		uint64_t dcspare;
+	} msr;
+
+	uint32_t gp[GP_REG_COUNT];
+	uint32_t dc[DC_REG_COUNT];
+	uint64_t vp[VP_REG_COUNT];
+	uint64_t fp[FP_REG_COUNT];
+
+	uint32_t pal[DC_PAL_COUNT];
+	uint32_t hcoeff[DC_HFILT_COUNT * 2];
+	uint32_t vcoeff[DC_VFILT_COUNT];
+	uint32_t vp_coeff[VP_COEFF_SIZE / 4];
+#endif
 };
 
 static inline unsigned int lx_get_pitch(unsigned int xres, int bpp)
@@ -27,6 +58,11 @@ int lx_blank_display(struct fb_info *, i
 void lx_set_palette_reg(struct fb_info *, unsigned int, unsigned int,
 			unsigned int, unsigned int);
 
+#ifdef CONFIG_PM
+int lx_powerdown(struct fb_info *info);
+int lx_powerup(struct fb_info *info);
+#endif
+
 
 /* Graphics Processor registers (table 6-29 from the data book) */
 enum gp_registers {
@@ -182,6 +218,9 @@ enum dc_registers {
 #define DC_DV_CTL_DV_LINE_SIZE_2K	(1 << 10)
 #define DC_DV_CTL_DV_LINE_SIZE_4K	(1 << 11)
 #define DC_DV_CTL_DV_LINE_SIZE_8K	((1 << 10) | (1 << 11))
+#define DC_DV_CTL_CLEAR_DV_RAM		(1 << 0)
+
+#define DC_IRQ_FILT_CTL_H_FILT_SEL	(1 << 10)
 
 #define DC_CLR_KEY_CLR_KEY_EN		(1 << 24)
 
@@ -267,6 +306,8 @@ enum vp_registers {
 	VP_A2YE,
 
 	VP_A3YE,	/* 0x150 */
+
+	VP_VCR = 0x1000, /* 0x1000 - 0x1fff */
 };
 
 #define VP_VCFG_VID_EN			(1 << 0)
@@ -319,6 +360,10 @@ enum fp_registers {
 #define FP_PT2_SCRC			(1 << 27)	/* shfclk free */
 
 #define FP_PM_P				(1 << 24)	/* panel power ctl */
+#define FP_PM_PANEL_PWR_UP		(1 << 3)	/* r/o */
+#define FP_PM_PANEL_PWR_DOWN		(1 << 2)	/* r/o */
+#define FP_PM_PANEL_OFF			(1 << 1)	/* r/o */
+#define FP_PM_PANEL_ON			(1 << 0)	/* r/o */
 
 #define FP_DFC_BC			((1 << 4) | (1 << 5) | (1 << 6))
 
diff -puN drivers/video/geode/lxfb_core.c~lxfb-add-power-management-functionality drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~lxfb-add-power-management-functionality
+++ a/drivers/video/geode/lxfb_core.c
@@ -428,6 +428,45 @@ static struct fb_info * __init lxfb_init
 	return info;
 }
 
+#ifdef CONFIG_PM
+static int lxfb_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct fb_info *info = pci_get_drvdata(pdev);
+
+	if (state.event == PM_EVENT_SUSPEND) {
+		acquire_console_sem();
+		lx_powerdown(info);
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
+static int lxfb_resume(struct pci_dev *pdev)
+{
+	struct fb_info *info = pci_get_drvdata(pdev);
+	int ret;
+
+	acquire_console_sem();
+	ret = lx_powerup(info);
+	if (ret) {
+		printk(KERN_ERR "lxfb:  power up failed!\n");
+		return ret;
+	}
+
+	fb_set_suspend(info, 0);
+	release_console_sem();
+	return 0;
+}
+#else
+#define lxfb_suspend NULL
+#define lxfb_resume NULL
+#endif
+
 static int __init lxfb_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -553,6 +592,8 @@ static struct pci_driver lxfb_driver = {
 	.id_table	= lxfb_id_table,
 	.probe		= lxfb_probe,
 	.remove		= lxfb_remove,
+	.suspend	= lxfb_suspend,
+	.resume		= lxfb_resume,
 };
 
 #ifndef MODULE
diff -puN drivers/video/geode/lxfb_ops.c~lxfb-add-power-management-functionality drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~lxfb-add-power-management-functionality
+++ a/drivers/video/geode/lxfb_ops.c
@@ -232,8 +232,8 @@ static void lx_graphics_disable(struct f
 	val = read_dc(par, DC_CLR_KEY);
 	write_dc(par, DC_CLR_KEY, val & ~DC_CLR_KEY_CLR_KEY_EN);
 
-	/* We don't actually blank the panel, due to the long latency
-	   involved with bringing it back */
+	/* turn off the panel */
+	write_fp(par, FP_PM, read_fp(par, FP_PM) & ~FP_PM_P);
 
 	val = read_vp(par, VP_MISC) | VP_MISC_DACPWRDN;
 	write_vp(par, VP_MISC, val);
@@ -321,13 +321,8 @@ static void lx_graphics_enable(struct fb
 	}
 
 	/* Turn the panel on (if it isn't already) */
-
-	if (par->output & OUTPUT_PANEL) {
-		temp = read_fp(par, FP_PM);
-
-		if (!(temp & 0x09))
-			write_fp(par, FP_PM, temp | FP_PM_P);
-	}
+	if (par->output & OUTPUT_PANEL)
+		write_fp(par, FP_PM, read_fp(par, FP_PM) | FP_PM_P);
 }
 
 unsigned int lx_framebuffer_size(void)
@@ -575,3 +570,253 @@ int lx_blank_display(struct fb_info *inf
 
 	return 0;
 }
+
+#ifdef CONFIG_PM
+
+static void lx_save_regs(struct lxfb_par *par)
+{
+	uint32_t filt;
+	int i;
+
+	/* wait for the BLT engine to stop being busy */
+	do {
+		i = read_gp(par, GP_BLT_STATUS);
+	} while ((i & GP_BLT_STATUS_PB) || !(i & GP_BLT_STATUS_CE));
+
+	/* save MSRs */
+	rdmsrl(MSR_LX_MSR_PADSEL, par->msr.padsel);
+	rdmsrl(MSR_GLCP_DOTPLL, par->msr.dotpll);
+	rdmsrl(MSR_LX_GLD_MSR_CONFIG, par->msr.dfglcfg);
+	rdmsrl(MSR_LX_SPARE_MSR, par->msr.dcspare);
+
+	write_dc(par, DC_UNLOCK, DC_UNLOCK_UNLOCK);
+
+	/* save registers */
+	memcpy(par->gp, par->gp_regs, sizeof(par->gp));
+	memcpy(par->dc, par->dc_regs, sizeof(par->dc));
+	memcpy(par->vp, par->vp_regs, sizeof(par->vp));
+	memcpy(par->fp, par->vp_regs + VP_FP_START, sizeof(par->fp));
+
+	/* save the palette */
+	write_dc(par, DC_PAL_ADDRESS, 0);
+	for (i = 0; i < ARRAY_SIZE(par->pal); i++)
+		par->pal[i] = read_dc(par, DC_PAL_DATA);
+
+	/* save the horizontal filter coefficients */
+	filt = par->dc[DC_IRQ_FILT_CTL] | DC_IRQ_FILT_CTL_H_FILT_SEL;
+	for (i = 0; i < ARRAY_SIZE(par->hcoeff); i += 2) {
+		write_dc(par, DC_IRQ_FILT_CTL, (filt & 0xffffff00) | i);
+		par->hcoeff[i] = read_dc(par, DC_FILT_COEFF1);
+		par->hcoeff[i + 1] = read_dc(par, DC_FILT_COEFF2);
+	}
+
+	/* save the vertical filter coefficients */
+	filt &= ~DC_IRQ_FILT_CTL_H_FILT_SEL;
+	for (i = 0; i < ARRAY_SIZE(par->vcoeff); i++) {
+		write_dc(par, DC_IRQ_FILT_CTL, (filt & 0xffffff00) | i);
+		par->vcoeff[i] = read_dc(par, DC_FILT_COEFF1);
+	}
+
+	/* save video coeff ram */
+	memcpy(par->vp_coeff, par->vp_regs + VP_VCR, sizeof(par->vp_coeff));
+}
+
+static void lx_restore_gfx_proc(struct lxfb_par *par)
+{
+	int i;
+
+	/* a bunch of registers require GP_RASTER_MODE to be set first */
+	write_gp(par, GP_RASTER_MODE, par->gp[GP_RASTER_MODE]);
+
+	for (i = 0; i < ARRAY_SIZE(par->gp); i++) {
+		switch (i) {
+		case GP_RASTER_MODE:
+		case GP_VECTOR_MODE:
+		case GP_BLT_MODE:
+		case GP_BLT_STATUS:
+		case GP_HST_SRC:
+			/* FIXME: restore LUT data */
+		case GP_LUT_INDEX:
+		case GP_LUT_DATA:
+			/* don't restore these registers */
+			break;
+
+		default:
+			write_gp(par, i, par->gp[i]);
+		}
+	}
+}
+
+static void lx_restore_display_ctlr(struct lxfb_par *par)
+{
+	uint32_t filt;
+	int i;
+
+	wrmsrl(MSR_LX_SPARE_MSR, par->msr.dcspare);
+
+	for (i = 0; i < ARRAY_SIZE(par->dc); i++) {
+		switch (i) {
+		case DC_UNLOCK:
+			/* unlock the DC; runs first */
+			write_dc(par, DC_UNLOCK, DC_UNLOCK_UNLOCK);
+			break;
+
+		case DC_GENERAL_CFG:
+		case DC_DISPLAY_CFG:
+			/* disable all while restoring */
+			write_dc(par, i, 0);
+			break;
+
+		case DC_DV_CTL:
+			/* set all ram to dirty */
+			write_dc(par, i, par->dc[i] | DC_DV_CTL_CLEAR_DV_RAM);
+
+		case DC_RSVD_1:
+		case DC_RSVD_2:
+		case DC_RSVD_3:
+		case DC_LINE_CNT:
+		case DC_PAL_ADDRESS:
+		case DC_PAL_DATA:
+		case DC_DFIFO_DIAG:
+		case DC_CFIFO_DIAG:
+		case DC_FILT_COEFF1:
+		case DC_FILT_COEFF2:
+		case DC_RSVD_4:
+		case DC_RSVD_5:
+			/* don't restore these registers */
+			break;
+
+		default:
+			write_dc(par, i, par->dc[i]);
+		}
+	}
+
+	/* restore the palette */
+	write_dc(par, DC_PAL_ADDRESS, 0);
+	for (i = 0; i < ARRAY_SIZE(par->pal); i++)
+		write_dc(par, DC_PAL_DATA, par->pal[i]);
+
+	/* restore the horizontal filter coefficients */
+	filt = par->dc[DC_IRQ_FILT_CTL] | DC_IRQ_FILT_CTL_H_FILT_SEL;
+	for (i = 0; i < ARRAY_SIZE(par->hcoeff); i += 2) {
+		write_dc(par, DC_IRQ_FILT_CTL, (filt & 0xffffff00) | i);
+		write_dc(par, DC_FILT_COEFF1, par->hcoeff[i]);
+		write_dc(par, DC_FILT_COEFF2, par->hcoeff[i + 1]);
+	}
+
+	/* restore the vertical filter coefficients */
+	filt &= ~DC_IRQ_FILT_CTL_H_FILT_SEL;
+	for (i = 0; i < ARRAY_SIZE(par->vcoeff); i++) {
+		write_dc(par, DC_IRQ_FILT_CTL, (filt & 0xffffff00) | i);
+		write_dc(par, DC_FILT_COEFF1, par->vcoeff[i]);
+	}
+}
+
+static void lx_restore_video_proc(struct lxfb_par *par)
+{
+	int i;
+
+	wrmsrl(MSR_LX_GLD_MSR_CONFIG, par->msr.dfglcfg);
+	wrmsrl(MSR_LX_MSR_PADSEL, par->msr.padsel);
+
+	for (i = 0; i < ARRAY_SIZE(par->vp); i++) {
+		switch (i) {
+		case VP_VCFG:
+		case VP_DCFG:
+		case VP_PAR:
+		case VP_PDR:
+		case VP_CCS:
+		case VP_RSVD_0:
+		/* case VP_VDC: */ /* why should this not be restored? */
+		case VP_RSVD_1:
+		case VP_CRC32:
+			/* don't restore these registers */
+			break;
+
+		default:
+			write_vp(par, i, par->vp[i]);
+		}
+	}
+
+	/* restore video coeff ram */
+	memcpy(par->vp_regs + VP_VCR, par->vp_coeff, sizeof(par->vp_coeff));
+}
+
+static void lx_restore_regs(struct lxfb_par *par)
+{
+	int i;
+
+	lx_set_dotpll((u32) (par->msr.dotpll >> 32));
+	lx_restore_gfx_proc(par);
+	lx_restore_display_ctlr(par);
+	lx_restore_video_proc(par);
+
+	/* Flat Panel */
+	for (i = 0; i < ARRAY_SIZE(par->fp); i++) {
+		switch (i) {
+		case FP_PM:
+		case FP_RSVD_0:
+		case FP_RSVD_1:
+		case FP_RSVD_2:
+		case FP_RSVD_3:
+		case FP_RSVD_4:
+			/* don't restore these registers */
+			break;
+
+		default:
+			write_fp(par, i, par->fp[i]);
+		}
+	}
+
+	/* control the panel */
+	if (par->fp[FP_PM] & FP_PM_P) {
+		/* power on the panel if not already power{ed,ing} on */
+		if (!(read_fp(par, FP_PM) &
+				(FP_PM_PANEL_ON|FP_PM_PANEL_PWR_UP)))
+			write_fp(par, FP_PM, par->fp[FP_PM]);
+	} else {
+		/* power down the panel if not already power{ed,ing} down */
+		if (!(read_fp(par, FP_PM) &
+				(FP_PM_PANEL_OFF|FP_PM_PANEL_PWR_DOWN)))
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
+int lx_powerdown(struct fb_info *info)
+{
+	struct lxfb_par *par = info->par;
+
+	if (par->powered_down)
+		return 0;
+
+	lx_save_regs(par);
+	lx_graphics_disable(info);
+
+	par->powered_down = 1;
+	return 0;
+}
+
+int lx_powerup(struct fb_info *info)
+{
+	struct lxfb_par *par = info->par;
+
+	if (!par->powered_down)
+		return 0;
+
+	lx_restore_regs(par);
+
+	par->powered_down = 0;
+	return 0;
+}
+
+#endif
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

