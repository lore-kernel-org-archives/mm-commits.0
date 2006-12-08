From: akpm@osdl.org
Subject: - gxfb-turn-on-the-flatpanel-power-and-data.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:46 -0800
Message-ID: <200612082014.kB8KEkq9003214@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59872 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946875AbWLHUOz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jordan.crouse@amd.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     gxfb: Turn on the flatpanel power and data
has been removed from the -mm tree.  Its filename was
     gxfb-turn-on-the-flatpanel-power-and-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gxfb: Turn on the flatpanel power and data
From: Jordan Crouse <jordan.crouse@amd.com>

For Geode devices without a flatpanel aware BIOS, this enables the flatpanel
power and data.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/geode/video_gx.c |   13 +++++++++++--
 drivers/video/geode/video_gx.h |    2 ++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN drivers/video/geode/video_gx.c~gxfb-turn-on-the-flatpanel-power-and-data drivers/video/geode/video_gx.c
--- a/drivers/video/geode/video_gx.c~gxfb-turn-on-the-flatpanel-power-and-data
+++ a/drivers/video/geode/video_gx.c
@@ -220,7 +220,13 @@ gx_configure_tft(struct fb_info *info)
 	/*  Set the dither control */
 	writel(0x70, par->vid_regs + GX_FP_DFC);
 
-	/* Turn on the device */
+	/* Enable the FP data and power (in case the BIOS didn't) */
+
+	fp = readl(par->vid_regs + GX_DCFG);
+	fp |= GX_DCFG_FP_PWR_EN | GX_DCFG_FP_DATA_EN;
+	writel(fp, par->vid_regs + GX_DCFG);
+
+	/* Unblank the panel */
 
 	fp = readl(par->vid_regs + GX_FP_PM);
 	fp |= GX_FP_PM_P;
@@ -245,9 +251,12 @@ static void gx_configure_display(struct 
 	writel(misc, par->vid_regs + GX_MISC);
 
 	/* Write the display configuration */
-
 	dcfg = readl(par->vid_regs + GX_DCFG);
 
+	/* Disable hsync and vsync */
+	dcfg &= ~(GX_DCFG_VSYNC_EN | GX_DCFG_HSYNC_EN);
+	writel(dcfg, par->vid_regs + GX_DCFG);
+
 	/* Clear bits from existing mode. */
 	dcfg &= ~(GX_DCFG_CRT_SYNC_SKW_MASK
 		  | GX_DCFG_CRT_HSYNC_POL   | GX_DCFG_CRT_VSYNC_POL
diff -puN drivers/video/geode/video_gx.h~gxfb-turn-on-the-flatpanel-power-and-data drivers/video/geode/video_gx.h
--- a/drivers/video/geode/video_gx.h~gxfb-turn-on-the-flatpanel-power-and-data
+++ a/drivers/video/geode/video_gx.h
@@ -25,6 +25,8 @@ extern struct geode_vid_ops gx_vid_ops;
 #  define GX_DCFG_HSYNC_EN		0x00000002
 #  define GX_DCFG_VSYNC_EN		0x00000004
 #  define GX_DCFG_DAC_BL_EN		0x00000008
+#  define GX_DCFG_FP_PWR_EN		0x00000040
+#  define GX_DCFG_FP_DATA_EN		0x00000080
 #  define GX_DCFG_CRT_HSYNC_POL		0x00000100
 #  define GX_DCFG_CRT_VSYNC_POL		0x00000200
 #  define GX_DCFG_CRT_SYNC_SKW_MASK	0x0001C000
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

origin.patch
gxfb-turn-on-the-flatpanel-power-and-data.patch
acpi-clear-gpe-before-disabling-it.patch

