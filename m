From: akpm@linux-foundation.org
Subject: + lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch added to -mm tree
Date: Wed, 09 Apr 2008 19:44:14 -0700
Message-ID: <200804100244.m3A2iEku009323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbYDJCo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 22:44:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com


The patch titled
     lxfb/gxfb: when blanking with FB_BLANK_POWERDOWN, also turn off the CRT
has been added to the -mm tree.  Its filename is
     lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch

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
Subject: lxfb/gxfb: when blanking with FB_BLANK_POWERDOWN, also turn off the CRT
From: Andres Salomon <dilinger@queued.net>

The Display Control's CRT_EN can be shut off when we enter FB_BLANK_POWERDOWN
in an attempt to save additional power.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_ops.c |   17 ++++++++++-------
 drivers/video/geode/video_gx.c |   18 ++++++++++--------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff -puN drivers/video/geode/lxfb_ops.c~lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt
+++ a/drivers/video/geode/lxfb_ops.c
@@ -524,37 +524,40 @@ int lx_blank_display(struct fb_info *inf
 {
 	struct lxfb_par *par = info->par;
 	u32 dcfg, fp_pm;
-	int blank, hsync, vsync;
+	int blank, hsync, vsync, crt;
 
 	/* CRT power saving modes. */
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
-		blank = 0; hsync = 1; vsync = 1;
+		blank = 0; hsync = 1; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_NORMAL:
-		blank = 1; hsync = 1; vsync = 1;
+		blank = 1; hsync = 1; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
-		blank = 1; hsync = 1; vsync = 0;
+		blank = 1; hsync = 1; vsync = 0; crt = 1;
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
-		blank = 1; hsync = 0; vsync = 1;
+		blank = 1; hsync = 0; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_POWERDOWN:
-		blank = 1; hsync = 0; vsync = 0;
+		blank = 1; hsync = 0; vsync = 0; crt = 0;
 		break;
 	default:
 		return -EINVAL;
 	}
 
 	dcfg = read_vp(par, VP_DCFG);
-	dcfg &= ~(VP_DCFG_DAC_BL_EN | VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN);
+	dcfg &= ~(VP_DCFG_DAC_BL_EN | VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN |
+			VP_DCFG_CRT_EN);
 	if (!blank)
 		dcfg |= VP_DCFG_DAC_BL_EN;
 	if (hsync)
 		dcfg |= VP_DCFG_HSYNC_EN;
 	if (vsync)
 		dcfg |= VP_DCFG_VSYNC_EN;
+	if (crt)
+		dcfg |= VP_DCFG_CRT_EN;
 	write_vp(par, VP_DCFG, dcfg);
 
 	/* Power on/off flat panel */
diff -puN drivers/video/geode/video_gx.c~lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt drivers/video/geode/video_gx.c
--- a/drivers/video/geode/video_gx.c~lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt
+++ a/drivers/video/geode/video_gx.c
@@ -299,37 +299,39 @@ int gx_blank_display(struct fb_info *inf
 {
 	struct gxfb_par *par = info->par;
 	u32 dcfg, fp_pm;
-	int blank, hsync, vsync;
+	int blank, hsync, vsync, crt;
 
 	/* CRT power saving modes. */
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
-		blank = 0; hsync = 1; vsync = 1;
+		blank = 0; hsync = 1; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_NORMAL:
-		blank = 1; hsync = 1; vsync = 1;
+		blank = 1; hsync = 1; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
-		blank = 1; hsync = 1; vsync = 0;
+		blank = 1; hsync = 1; vsync = 0; crt = 1;
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
-		blank = 1; hsync = 0; vsync = 1;
+		blank = 1; hsync = 0; vsync = 1; crt = 1;
 		break;
 	case FB_BLANK_POWERDOWN:
-		blank = 1; hsync = 0; vsync = 0;
+		blank = 1; hsync = 0; vsync = 0; crt = 0;
 		break;
 	default:
 		return -EINVAL;
 	}
 	dcfg = read_vp(par, VP_DCFG);
-	dcfg &= ~(VP_DCFG_DAC_BL_EN
-		  | VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN);
+	dcfg &= ~(VP_DCFG_DAC_BL_EN | VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN |
+			VP_DCFG_CRT_EN);
 	if (!blank)
 		dcfg |= VP_DCFG_DAC_BL_EN;
 	if (hsync)
 		dcfg |= VP_DCFG_HSYNC_EN;
 	if (vsync)
 		dcfg |= VP_DCFG_VSYNC_EN;
+	if (crt)
+		dcfg |= VP_DCFG_CRT_EN;
 	write_vp(par, VP_DCFG, dcfg);
 
 	/* Power on/off flat panel. */
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-geode-msr-cleanup.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
gxfb-clean-up-register-definitions.patch
gxfb-move-msr-bit-fields-into-gxfbh.patch
gxfb-stop-sharing-code-with-gx1fb.patch
gxfb-add-power-management-functionality.patch
gxfb-add-power-management-functionality-fix.patch
gxfb-add-power-management-functionality-update.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-create-gp-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
lxfb-clean-up-register-definitions.patch
lxfb-clean-up-final-bits-of-df_regs.patch
lxfb-rearrange-rename-msr-bitfields.patch
lxfb-add-power-management-functionality.patch
lxfb-add-power-management-functionality-fix.patch
lxfb-add-power-management-functionality-update.patch
lxfb-rename-kernel-arg-fbsize-to-vram.patch
lxfb-disable-suspend-vt-switch-by-default.patch
lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch

