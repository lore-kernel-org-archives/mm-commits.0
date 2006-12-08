From: akpm@osdl.org
Subject: - gxfb-support-flat-panel-timings.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:38 -0800
Message-ID: <200612082014.kB8KEcoH003197@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59851 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946859AbWLHUOs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jordan.crouse@amd.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     gxfb: Support flat panel timings
has been removed from the -mm tree.  Its filename was
     gxfb-support-flat-panel-timings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gxfb: Support flat panel timings
From: Jordan Crouse <jordan.crouse@amd.com>

Support TFT panels by correctly setting up the flat panel registers

[akpm@osdl.org: cleanups]
Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/geode/display_gx.h |    4 +
 drivers/video/geode/gxfb_core.c  |   10 +++
 drivers/video/geode/video_gx.c   |   76 ++++++++++++++++++++++++-----
 drivers/video/geode/video_gx.h   |   16 ++++++
 4 files changed, 95 insertions(+), 11 deletions(-)

diff -puN drivers/video/geode/display_gx.h~gxfb-support-flat-panel-timings drivers/video/geode/display_gx.h
--- a/drivers/video/geode/display_gx.h~gxfb-support-flat-panel-timings
+++ a/drivers/video/geode/display_gx.h
@@ -16,6 +16,10 @@ int gx_line_delta(int xres, int bpp);
 
 extern struct geode_dc_ops gx_dc_ops;
 
+/* MSR that tells us if a TFT or CRT is attached */
+#define GLD_MSR_CONFIG   0xC0002001
+#define GLD_MSR_CONFIG_FMT_FP 0x01
+
 /* Display controller registers */
 
 #define DC_UNLOCK 0x00
diff -puN drivers/video/geode/gxfb_core.c~gxfb-support-flat-panel-timings drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-support-flat-panel-timings
+++ a/drivers/video/geode/gxfb_core.c
@@ -308,6 +308,7 @@ static int __init gxfb_probe(struct pci_
 	struct geodefb_par *par;
 	struct fb_info *info;
 	int ret;
+	unsigned long val;
 
 	info = gxfb_init_fbinfo(&pdev->dev);
 	if (!info)
@@ -323,6 +324,15 @@ static int __init gxfb_probe(struct pci_
 		goto err;
 	}
 
+	/* Figure out if this is a TFT or CRT part */
+
+	rdmsrl(GLD_MSR_CONFIG, val);
+
+	if (val & GLD_MSR_CONFIG_FMT_FP)
+		par->enable_crt = 0;
+	else
+		par->enable_crt = 1;
+
 	ret = fb_find_mode(&info->var, info, mode_option,
 			   gx_modedb, ARRAY_SIZE(gx_modedb), NULL, 16);
 	if (ret == 0 || ret == 4) {
diff -puN drivers/video/geode/video_gx.c~gxfb-support-flat-panel-timings drivers/video/geode/video_gx.c
--- a/drivers/video/geode/video_gx.c~gxfb-support-flat-panel-timings
+++ a/drivers/video/geode/video_gx.c
@@ -175,10 +175,62 @@ static void gx_set_dclk_frequency(struct
 	} while (timeout-- && !(dotpll & MSR_GLCP_DOTPLL_LOCK));
 }
 
+static void
+gx_configure_tft(struct fb_info *info)
+{
+	struct geodefb_par *par = info->par;
+	unsigned long val;
+	unsigned long fp;
+
+	/* Set up the DF pad select MSR */
+
+	rdmsrl(GX_VP_MSR_PAD_SELECT, val);
+	val &= ~GX_VP_PAD_SELECT_MASK;
+	val |= GX_VP_PAD_SELECT_TFT;
+	wrmsrl(GX_VP_MSR_PAD_SELECT, val);
+
+	/* Turn off the panel */
+
+	fp = readl(par->vid_regs + GX_FP_PM);
+	fp &= ~GX_FP_PM_P;
+	writel(fp, par->vid_regs + GX_FP_PM);
+
+	/* Set timing 1 */
+
+	fp = readl(par->vid_regs + GX_FP_PT1);
+	fp &= GX_FP_PT1_VSIZE_MASK;
+	fp |= info->var.yres << GX_FP_PT1_VSIZE_SHIFT;
+	writel(fp, par->vid_regs + GX_FP_PT1);
+
+	/* Timing 2 */
+	/* Set bits that are always on for TFT */
+
+	fp = 0x0F100000;
+
+	/* Add sync polarity */
+
+	if (!(info->var.sync & FB_SYNC_VERT_HIGH_ACT))
+		fp |= GX_FP_PT2_VSP;
+
+	if (!(info->var.sync & FB_SYNC_HOR_HIGH_ACT))
+		fp |= GX_FP_PT2_HSP;
+
+	writel(fp, par->vid_regs + GX_FP_PT2);
+
+	/*  Set the dither control */
+	writel(0x70, par->vid_regs + GX_FP_DFC);
+
+	/* Turn on the device */
+
+	fp = readl(par->vid_regs + GX_FP_PM);
+	fp |= GX_FP_PM_P;
+	writel(fp, par->vid_regs + GX_FP_PM);
+}
+
 static void gx_configure_display(struct fb_info *info)
 {
 	struct geodefb_par *par = info->par;
-	u32 dcfg, fp_pm, misc;
+	u32 dcfg, misc;
 
 	/* Set up the MISC register */
 
@@ -222,11 +274,10 @@ static void gx_configure_display(struct 
 
 	writel(dcfg, par->vid_regs + GX_DCFG);
 
-	/* Power on flat panel. */
+	/* Set up the flat panel (if it is enabled) */
 
-	fp_pm = readl(par->vid_regs + GX_FP_PM);
-	fp_pm |= GX_FP_PM_P;
-	writel(fp_pm, par->vid_regs + GX_FP_PM);
+	if (par->enable_crt == 0)
+		gx_configure_tft(info);
 }
 
 static int gx_blank_display(struct fb_info *info, int blank_mode)
@@ -267,12 +318,15 @@ static int gx_blank_display(struct fb_in
 	writel(dcfg, par->vid_regs + GX_DCFG);
 
 	/* Power on/off flat panel. */
-	fp_pm = readl(par->vid_regs + GX_FP_PM);
-	if (blank_mode == FB_BLANK_POWERDOWN)
-		fp_pm &= ~GX_FP_PM_P;
-	else
-		fp_pm |= GX_FP_PM_P;
-	writel(fp_pm, par->vid_regs + GX_FP_PM);
+
+	if (par->enable_crt == 0) {
+		fp_pm = readl(par->vid_regs + GX_FP_PM);
+		if (blank_mode == FB_BLANK_POWERDOWN)
+			fp_pm &= ~GX_FP_PM_P;
+		else
+			fp_pm |= GX_FP_PM_P;
+		writel(fp_pm, par->vid_regs + GX_FP_PM);
+	}
 
 	return 0;
 }
diff -puN drivers/video/geode/video_gx.h~gxfb-support-flat-panel-timings drivers/video/geode/video_gx.h
--- a/drivers/video/geode/video_gx.h~gxfb-support-flat-panel-timings
+++ a/drivers/video/geode/video_gx.h
@@ -13,6 +13,11 @@
 
 extern struct geode_vid_ops gx_vid_ops;
 
+/* GX Flatpanel control MSR */
+#define GX_VP_MSR_PAD_SELECT           0x2011
+#define GX_VP_PAD_SELECT_MASK          0x3FFFFFFF
+#define GX_VP_PAD_SELECT_TFT           0x1FFFFFFF
+
 /* Geode GX video processor registers */
 
 #define GX_DCFG		0x0008
@@ -36,9 +41,20 @@ extern struct geode_vid_ops gx_vid_ops;
 #define GX_MISC_A_PWRDN    0x00000800
 
 /* Geode GX flat panel display control registers */
+
+#define GX_FP_PT1 0x0400
+#define GX_FP_PT1_VSIZE_MASK 0x7FF0000
+#define GX_FP_PT1_VSIZE_SHIFT 16
+
+#define GX_FP_PT2 0x408
+#define GX_FP_PT2_VSP (1 << 23)
+#define GX_FP_PT2_HSP (1 << 22)
+
 #define GX_FP_PM 0x410
 #  define GX_FP_PM_P 0x01000000
 
+#define GX_FP_DFC 0x418
+
 /* Geode GX clock control MSRs */
 
 #define MSR_GLCP_SYS_RSTPLL	0x4c000014
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

origin.patch
gxfb-support-flat-panel-timings.patch
gxfb-support-command-line-options.patch
gxfb-fixup-flatpanel-detection.patch
gxfb-turn-on-the-flatpanel-power-and-data.patch
acpi-clear-gpe-before-disabling-it.patch

