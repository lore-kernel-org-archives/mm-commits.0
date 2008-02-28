From: akpm@linux-foundation.org
Subject: + gxfb-dont-enable-the-crt-dacs-when-we-are-in-flatpanel-mode.patch added to -mm tree
Date: Wed, 27 Feb 2008 16:31:41 -0800
Message-ID: <200802280031.m1S0VffR006875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757948AbYB1Acs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 19:32:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jordan.crouse@amd.com, adaplas@pol.net, dilinger@debian.org


The patch titled
     gxfb: don't enable the CRT DACs when we are in flatpanel mode
has been added to the -mm tree.  Its filename is
     gxfb-dont-enable-the-crt-dacs-when-we-are-in-flatpanel-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gxfb: don't enable the CRT DACs when we are in flatpanel mode
From: Jordan Crouse <jordan.crouse@amd.com>

When the FP strap is enabled, don't turn on the CRT DACs - that will save
about 35 mA of power.

Updated/cleaned up by Andres Salomon.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/video_gx.c |   32 ++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN drivers/video/geode/video_gx.c~gxfb-dont-enable-the-crt-dacs-when-we-are-in-flatpanel-mode drivers/video/geode/video_gx.c
--- a/drivers/video/geode/video_gx.c~gxfb-dont-enable-the-crt-dacs-when-we-are-in-flatpanel-mode
+++ a/drivers/video/geode/video_gx.c
@@ -238,18 +238,6 @@ static void gx_configure_display(struct 
 	struct geodefb_par *par = info->par;
 	u32 dcfg, misc;
 
-	/* Set up the MISC register */
-
-	misc = readl(par->vid_regs + GX_MISC);
-
-	/* Power up the DAC */
-	misc &= ~(GX_MISC_A_PWRDN | GX_MISC_DAC_PWRDN);
-
-	/* Disable gamma correction */
-	misc |= GX_MISC_GAM_EN;
-
-	writel(misc, par->vid_regs + GX_MISC);
-
 	/* Write the display configuration */
 	dcfg = readl(par->vid_regs + GX_DCFG);
 
@@ -268,14 +256,28 @@ static void gx_configure_display(struct 
 	/* Enable hsync and vsync. */
 	dcfg |= GX_DCFG_HSYNC_EN | GX_DCFG_VSYNC_EN;
 
-	/* Only change the sync polarities if we are running
-	 * in CRT mode.  The FP polarities will be handled in
-	 * gxfb_configure_tft */
+	misc = readl(par->vid_regs + GX_MISC);
+
+	/* Disable gamma correction */
+	misc |= GX_MISC_GAM_EN;
+
 	if (par->enable_crt) {
+
+		/* Power up the CRT DACs */
+		misc &= ~(GX_MISC_A_PWRDN | GX_MISC_DAC_PWRDN);
+		writel(misc, par->vid_regs + GX_MISC);
+
+		/* Only change the sync polarities if we are running
+		 * in CRT mode.  The FP polarities will be handled in
+		 * gxfb_configure_tft */
 		if (!(info->var.sync & FB_SYNC_HOR_HIGH_ACT))
 			dcfg |= GX_DCFG_CRT_HSYNC_POL;
 		if (!(info->var.sync & FB_SYNC_VERT_HIGH_ACT))
 			dcfg |= GX_DCFG_CRT_VSYNC_POL;
+	} else {
+		/* Power down the CRT DACs if in FP mode */
+		misc |= (GX_MISC_A_PWRDN | GX_MISC_DAC_PWRDN);
+		writel(misc, par->vid_regs + GX_MISC);
 	}
 
 	/* Enable the display logic */
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

gxfb-replace-fbsize-config-option-with-a-kernel-argument.patch
gxfb-set-the-right-registers-to-tweak-the-sync-polarity.patch
gxfb-dont-enable-the-crt-dacs-when-we-are-in-flatpanel-mode.patch
