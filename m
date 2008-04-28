From: akpm@linux-foundation.org
Subject: - gxfb-set-the-right-registers-to-tweak-the-sync-polarity.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:31 -0700
Message-ID: <200804282157.m3SLvVhd018404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965166AbYD1V5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jordan.crouse@amd.com, adaplas@pol.net, dilinger@debian.org, mm-commits@vger.kernel.org


The patch titled
     gxfb: set the right registers to tweak the sync polarity
has been removed from the -mm tree.  Its filename was
     gxfb-set-the-right-registers-to-tweak-the-sync-polarity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -208,7 +208,7 @@ gx_configure_tft(struct fb_info *info)
 
 	fp = 0x0F100000;
 
-	/* Add sync polarity */
+	/* Configure sync polarity */
 
 	if (!(info->var.sync & FB_SYNC_VERT_HIGH_ACT))
 		fp |= GX_FP_PT2_VSP;
@@ -269,11 +269,15 @@ static void gx_configure_display(struct 
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

origin.patch
git-watchdog.patch
x86-olpc-add-one-laptop-per-child-architecture-support.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch

