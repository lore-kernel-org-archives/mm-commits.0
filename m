From: akpm@linux-foundation.org
Subject: + lxfb-fix-console-blanking.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:42:35 -0700
Message-ID: <200807111848.m6BImGpN031150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755026AbYGKSs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jordan.crouse@amd.com, dilinger@debian.org


The patch titled
     lxfb: fix console blanking
has been added to the -mm tree.  Its filename is
     lxfb-fix-console-blanking.patch

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
Subject: lxfb: fix console blanking
From: Jordan Crouse <jordan.crouse@amd.com>

Simply enabling DAC blanking without turning off the CRT seems to be resulting
in characters remaining on the screen when the monitor blanks.  This patch
turns off the CRT for all modes, and also powers down the DACs when vsync
and/or hsync are disabled.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Acked-by: Andres Salomon <dilinger@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_ops.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN drivers/video/geode/lxfb_ops.c~lxfb-fix-console-blanking drivers/video/geode/lxfb_ops.c
--- a/drivers/video/geode/lxfb_ops.c~lxfb-fix-console-blanking
+++ a/drivers/video/geode/lxfb_ops.c
@@ -517,25 +517,25 @@ void lx_set_palette_reg(struct fb_info *
 int lx_blank_display(struct fb_info *info, int blank_mode)
 {
 	struct lxfb_par *par = info->par;
-	u32 dcfg, fp_pm;
-	int blank, hsync, vsync, crt;
+	u32 dcfg, misc, fp_pm;
+	int blank, hsync, vsync;
 
 	/* CRT power saving modes. */
 	switch (blank_mode) {
 	case FB_BLANK_UNBLANK:
-		blank = 0; hsync = 1; vsync = 1; crt = 1;
+		blank = 0; hsync = 1; vsync = 1;
 		break;
 	case FB_BLANK_NORMAL:
-		blank = 1; hsync = 1; vsync = 1; crt = 1;
+		blank = 1; hsync = 1; vsync = 1;
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
-		blank = 1; hsync = 1; vsync = 0; crt = 1;
+		blank = 1; hsync = 1; vsync = 0;
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
-		blank = 1; hsync = 0; vsync = 1; crt = 1;
+		blank = 1; hsync = 0; vsync = 1;
 		break;
 	case FB_BLANK_POWERDOWN:
-		blank = 1; hsync = 0; vsync = 0; crt = 0;
+		blank = 1; hsync = 0; vsync = 0;
 		break;
 	default:
 		return -EINVAL;
@@ -545,15 +545,23 @@ int lx_blank_display(struct fb_info *inf
 	dcfg &= ~(VP_DCFG_DAC_BL_EN | VP_DCFG_HSYNC_EN | VP_DCFG_VSYNC_EN |
 			VP_DCFG_CRT_EN);
 	if (!blank)
-		dcfg |= VP_DCFG_DAC_BL_EN;
+		dcfg |= VP_DCFG_DAC_BL_EN | VP_DCFG_CRT_EN;
 	if (hsync)
 		dcfg |= VP_DCFG_HSYNC_EN;
 	if (vsync)
 		dcfg |= VP_DCFG_VSYNC_EN;
-	if (crt)
-		dcfg |= VP_DCFG_CRT_EN;
+
 	write_vp(par, VP_DCFG, dcfg);
 
+	misc = read_vp(par, VP_MISC);
+
+	if (vsync && hsync)
+		misc &= ~VP_MISC_DACPWRDN;
+	else
+		misc |= VP_MISC_DACPWRDN;
+
+	write_vp(par, VP_MISC, misc);
+
 	/* Power on/off flat panel */
 
 	if (par->output & OUTPUT_PANEL) {
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

lxfb-fix-console-blanking.patch

