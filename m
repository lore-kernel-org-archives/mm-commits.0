From: akpm@linux-foundation.org
Subject: + gxfb-set-the-right-registers-to-tweak-the-sync-polarity.patch added to -mm tree
Date: Wed, 27 Feb 2008 16:31:38 -0800
Message-ID: <200802280031.m1S0VcI8006867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757407AbYB1Ack (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 19:32:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jordan.crouse@amd.com, adaplas@pol.net, dilinger@debian.org


The patch titled
     gxfb: set the right registers to tweak the sync polarity
has been added to the -mm tree.  Its filename is
     gxfb-set-the-right-registers-to-tweak-the-sync-polarity.patch

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
Subject: gxfb: set the right registers to tweak the sync polarity
From: Jordan Crouse <jordan.crouse@amd.com>

While running in flatpanel mode it is important to change the FP sync bits (VG
register 0x408) rather then the CRT sync bits (VG register 0x008).  This patch
keeps the CRT sync bits at default when a flatpanel exists.

Note that this also fixes inverted logic; we want CRT_VSYNC_POL to be set (ie,
vsync is normally high) when FB_SYNC_VERT_HIGH_ACT is unset.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/video_gx.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/video/geode/video_gx.c~gxfb-set-the-right-registers-to-tweak-the-sync-polarity drivers/video/geode/video_gx.c
--- a/drivers/video/geode/video_gx.c~gxfb-set-the-right-registers-to-tweak-the-sync-polarity
+++ a/drivers/video/geode/video_gx.c
@@ -207,7 +207,7 @@ gx_configure_tft(struct fb_info *info)
 
 	fp = 0x0F100000;
 
-	/* Add sync polarity */
+	/* Configure sync polarity */
 
 	if (!(info->var.sync & FB_SYNC_VERT_HIGH_ACT))
 		fp |= GX_FP_PT2_VSP;
@@ -268,11 +268,15 @@ static void gx_configure_display(struct 
 	/* Enable hsync and vsync. */
 	dcfg |= GX_DCFG_HSYNC_EN | GX_DCFG_VSYNC_EN;
 
-	/* Sync polarities. */
-	if (info->var.sync & FB_SYNC_HOR_HIGH_ACT)
-		dcfg |= GX_DCFG_CRT_HSYNC_POL;
-	if (info->var.sync & FB_SYNC_VERT_HIGH_ACT)
-		dcfg |= GX_DCFG_CRT_VSYNC_POL;
+	/* Only change the sync polarities if we are running
+	 * in CRT mode.  The FP polarities will be handled in
+	 * gxfb_configure_tft */
+	if (par->enable_crt) {
+		if (!(info->var.sync & FB_SYNC_HOR_HIGH_ACT))
+			dcfg |= GX_DCFG_CRT_HSYNC_POL;
+		if (!(info->var.sync & FB_SYNC_VERT_HIGH_ACT))
+			dcfg |= GX_DCFG_CRT_VSYNC_POL;
+	}
 
 	/* Enable the display logic */
 	/* Set up the DACS to blank normally */
_

Patches currently in -mm which might be from jordan.crouse@amd.com are

gxfb-replace-fbsize-config-option-with-a-kernel-argument.patch
gxfb-set-the-right-registers-to-tweak-the-sync-polarity.patch
gxfb-dont-enable-the-crt-dacs-when-we-are-in-flatpanel-mode.patch
