From: akpm@linux-foundation.org
Subject: - lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:03 -0700
Message-ID: <200804282159.m3SLx35D018547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965457AbYD1V7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     lxfb/gxfb: when blanking with FB_BLANK_POWERDOWN, also turn off the CRT
has been removed from the -mm tree.  Its filename was
     lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kbuild.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch

