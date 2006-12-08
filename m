From: akpm@osdl.org
Subject: - gxfb-fixups-for-the-amd-geode-gx.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:35 -0800
Message-ID: <200612082014.kB8KEZLx003192@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59839 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946859AbWLHUOq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jordan.crouse@amd.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     gxfb: Fixups for the AMD Geode GX framebuffer driver
has been removed from the -mm tree.  Its filename was
     gxfb-fixups-for-the-amd-geode-gx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gxfb: Fixups for the AMD Geode GX framebuffer driver
From: Jordan Crouse <jordan.crouse@amd.com>

We cannot assume that the BIOS will be correctly setting up the hardware, so
set some bits in various display registers to enable video output.  Allow an
advanced user to specify a frambuffer size, rather then probing the BIOS.  All
of these fixes were prompted by the OLPC effort.

[akpm@osdl.org: cleanups]
Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/geode/Kconfig      |   20 ++++++++++++++++++++
 drivers/video/geode/display_gx.c |    8 ++++++++
 drivers/video/geode/display_gx.h |    1 +
 drivers/video/geode/gxfb_core.c  |    6 ++++++
 drivers/video/geode/video_gx.c   |   24 +++++++++++++++++++++++-
 drivers/video/geode/video_gx.h   |    7 +++++++
 6 files changed, 65 insertions(+), 1 deletion(-)

diff -puN drivers/video/geode/Kconfig~gxfb-fixups-for-the-amd-geode-gx drivers/video/geode/Kconfig
--- a/drivers/video/geode/Kconfig~gxfb-fixups-for-the-amd-geode-gx
+++ a/drivers/video/geode/Kconfig
@@ -23,6 +23,26 @@ config FB_GEODE_GX
 
 	  If unsure, say N.
 
+config FB_GEODE_GX_SET_FBSIZE
+	bool "Manually specify the Geode GX framebuffer size"
+	depends on FB_GEODE_GX
+	default n
+	---help---
+	  If you want to manually specify the size of your GX framebuffer,
+	  say Y here, otherwise say N to dynamically probe it.
+
+	  Say N unless you know what you are doing.
+
+config FB_GEODE_GX_FBSIZE
+	hex "Size of the GX framebuffer, in bytes"
+	depends on FB_GEODE_GX_SET_FBSIZE
+	default "0x1600000"
+	---help---
+	  Specify the size of the GX framebuffer.  Normally, you will
+	  want this to be MB aligned.  Common values are 0x80000 (8MB)
+	  and 0x1600000 (16MB).  Don't change this unless you know what
+	  you are doing
+
 config FB_GEODE_GX1
 	tristate "AMD Geode GX1 framebuffer support (EXPERIMENTAL)"
 	depends on FB && FB_GEODE && EXPERIMENTAL
diff -puN drivers/video/geode/display_gx.c~gxfb-fixups-for-the-amd-geode-gx drivers/video/geode/display_gx.c
--- a/drivers/video/geode/display_gx.c~gxfb-fixups-for-the-amd-geode-gx
+++ a/drivers/video/geode/display_gx.c
@@ -21,6 +21,12 @@
 #include "geodefb.h"
 #include "display_gx.h"
 
+#ifdef CONFIG_FB_GEODE_GX_SET_FBSIZE
+unsigned int gx_frame_buffer_size(void)
+{
+	return CONFIG_FB_GEODE_GX_FBSIZE;
+}
+#else
 unsigned int gx_frame_buffer_size(void)
 {
 	unsigned int val;
@@ -35,6 +41,7 @@ unsigned int gx_frame_buffer_size(void)
 	val = (unsigned int)(inw(0xAC1E)) & 0xFFl;
 	return (val << 19);
 }
+#endif
 
 int gx_line_delta(int xres, int bpp)
 {
@@ -90,6 +97,7 @@ static void gx_set_mode(struct fb_info *
 	writel(((info->var.xres * info->var.bits_per_pixel/8) >> 3) + 2,
 	       par->dc_regs + DC_LINE_SIZE);
 
+
 	/* Enable graphics and video data and unmask address lines. */
 	dcfg |= DC_DCFG_GDEN | DC_DCFG_VDEN | DC_DCFG_A20M | DC_DCFG_A18M;
 
diff -puN drivers/video/geode/display_gx.h~gxfb-fixups-for-the-amd-geode-gx drivers/video/geode/display_gx.h
--- a/drivers/video/geode/display_gx.h~gxfb-fixups-for-the-amd-geode-gx
+++ a/drivers/video/geode/display_gx.h
@@ -93,4 +93,5 @@ extern struct geode_dc_ops gx_dc_ops;
 #define DC_PAL_ADDRESS 0x70
 #define DC_PAL_DATA    0x74
 
+#define DC_GLIU0_MEM_OFFSET 0x84
 #endif /* !__DISPLAY_GX1_H__ */
diff -puN drivers/video/geode/gxfb_core.c~gxfb-fixups-for-the-amd-geode-gx drivers/video/geode/gxfb_core.c
--- a/drivers/video/geode/gxfb_core.c~gxfb-fixups-for-the-amd-geode-gx
+++ a/drivers/video/geode/gxfb_core.c
@@ -240,6 +240,12 @@ static int __init gxfb_map_video_memory(
 	if (!info->screen_base)
 		return -ENOMEM;
 
+	/* Set the 16MB aligned base address of the graphics memory region
+	 * in the display controller */
+
+	writel(info->fix.smem_start & 0xFF000000,
+			par->dc_regs + DC_GLIU0_MEM_OFFSET);
+
 	dev_info(&dev->dev, "%d Kibyte of video memory at 0x%lx\n",
 		 info->fix.smem_len / 1024, info->fix.smem_start);
 
diff -puN drivers/video/geode/video_gx.c~gxfb-fixups-for-the-amd-geode-gx drivers/video/geode/video_gx.c
--- a/drivers/video/geode/video_gx.c~gxfb-fixups-for-the-amd-geode-gx
+++ a/drivers/video/geode/video_gx.c
@@ -178,7 +178,21 @@ static void gx_set_dclk_frequency(struct
 static void gx_configure_display(struct fb_info *info)
 {
 	struct geodefb_par *par = info->par;
-	u32 dcfg, fp_pm;
+	u32 dcfg, fp_pm, misc;
+
+	/* Set up the MISC register */
+
+	misc = readl(par->vid_regs + GX_MISC);
+
+	/* Power up the DAC */
+	misc &= ~(GX_MISC_A_PWRDN | GX_MISC_DAC_PWRDN);
+
+	/* Disable gamma correction */
+	misc |= GX_MISC_GAM_EN;
+
+	writel(misc, par->vid_regs + GX_MISC);
+
+	/* Write the display configuration */
 
 	dcfg = readl(par->vid_regs + GX_DCFG);
 
@@ -199,9 +213,17 @@ static void gx_configure_display(struct 
 	if (info->var.sync & FB_SYNC_VERT_HIGH_ACT)
 		dcfg |= GX_DCFG_CRT_VSYNC_POL;
 
+	/* Enable the display logic */
+	/* Set up the DACS to blank normally */
+
+	dcfg |= GX_DCFG_CRT_EN | GX_DCFG_DAC_BL_EN;
+
+	/* Enable the external DAC VREF? */
+
 	writel(dcfg, par->vid_regs + GX_DCFG);
 
 	/* Power on flat panel. */
+
 	fp_pm = readl(par->vid_regs + GX_FP_PM);
 	fp_pm |= GX_FP_PM_P;
 	writel(fp_pm, par->vid_regs + GX_FP_PM);
diff -puN drivers/video/geode/video_gx.h~gxfb-fixups-for-the-amd-geode-gx drivers/video/geode/video_gx.h
--- a/drivers/video/geode/video_gx.h~gxfb-fixups-for-the-amd-geode-gx
+++ a/drivers/video/geode/video_gx.h
@@ -28,6 +28,13 @@ extern struct geode_vid_ops gx_vid_ops;
 #  define GX_DCFG_GV_GAM		0x00200000
 #  define GX_DCFG_DAC_VREF		0x04000000
 
+/* Geode GX MISC video configuration */
+
+#define GX_MISC 0x50
+#define GX_MISC_GAM_EN     0x00000001
+#define GX_MISC_DAC_PWRDN  0x00000400
+#define GX_MISC_A_PWRDN    0x00000800
+
 /* Geode GX flat panel display control registers */
 #define GX_FP_PM 0x410
 #  define GX_FP_PM_P 0x01000000
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

origin.patch
gxfb-fixups-for-the-amd-geode-gx.patch
gxfb-support-flat-panel-timings.patch
gxfb-support-command-line-options.patch
gxfb-fixup-flatpanel-detection.patch
gxfb-turn-on-the-flatpanel-power-and-data.patch
acpi-clear-gpe-before-disabling-it.patch

