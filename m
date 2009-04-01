From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-fix-interlaced-modes.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:05 -0700
Message-ID: <200904011843.n31Ih5s0009928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933585AbZDASpQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:45:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: fix interlaced modes
has been removed from the -mm tree.  Its filename was
     cirrusfb-fix-interlaced-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: fix interlaced modes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix calculations of timings for interlaced modes.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-interlaced-modes drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-interlaced-modes
+++ a/drivers/video/cirrusfb.c
@@ -701,45 +701,52 @@ static int cirrusfb_set_par_foo(struct f
 
 	hsyncstart = var->xres + var->right_margin;
 	hsyncend = hsyncstart + var->hsync_len;
-	htotal = (hsyncend + var->left_margin) / 8 - 5;
-	hdispend = var->xres / 8 - 1;
-	hsyncstart = hsyncstart / 8 + 1;
-	hsyncend = hsyncend / 8 + 1;
+	htotal = (hsyncend + var->left_margin) / 8;
+	hdispend = var->xres / 8;
+	hsyncstart = hsyncstart / 8;
+	hsyncend = hsyncend / 8;
 
-	yres = var->yres;
-	vsyncstart = yres + var->lower_margin;
+	vdispend = var->yres;
+	vsyncstart = vdispend + var->lower_margin;
 	vsyncend = vsyncstart + var->vsync_len;
 	vtotal = vsyncend + var->upper_margin;
-	vdispend = yres - 1;
 
 	if (var->vmode & FB_VMODE_DOUBLE) {
-		yres *= 2;
+		vdispend *= 2;
 		vsyncstart *= 2;
 		vsyncend *= 2;
 		vtotal *= 2;
 	} else if (var->vmode & FB_VMODE_INTERLACED) {
-		yres = (yres + 1) / 2;
+		vdispend = (vdispend + 1) / 2;
 		vsyncstart = (vsyncstart + 1) / 2;
 		vsyncend = (vsyncend + 1) / 2;
 		vtotal = (vtotal + 1) / 2;
 	}
-
-	vtotal -= 2;
-	vsyncstart -= 1;
-	vsyncend -= 1;
-
+	yres = vdispend;
 	if (yres >= 1024) {
 		vtotal /= 2;
 		vsyncstart /= 2;
 		vsyncend /= 2;
 		vdispend /= 2;
 	}
+
+	vdispend -= 1;
+	vsyncstart -= 1;
+	vsyncend -= 1;
+	vtotal -= 2;
+
 	if (cinfo->multiplexing) {
 		htotal /= 2;
 		hsyncstart /= 2;
 		hsyncend /= 2;
 		hdispend /= 2;
 	}
+
+	htotal -= 5;
+	hdispend -= 1;
+	hsyncstart += 1;
+	hsyncend += 1;
+
 	/* unlock register VGA_CRTC_H_TOTAL..CRT7 */
 	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, 0x20);	/* previously: 0x00) */
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

