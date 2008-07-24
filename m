From: akpm@linux-foundation.org
Subject: - tridentfb-fix-timing-calculations.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:30:55 -0700
Message-ID: <200807242330.m6ONUtY3011562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756373AbYGXXa6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tridentfb: fix timing calculations
has been removed from the -mm tree.  Its filename was
     tridentfb-fix-timing-calculations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: fix timing calculations
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix broken timings calculations. This patch helps with following
problems:
 - no left part of screen visible (up to half of the screen)
 - monitor's frequencies are not the ones intended for selected modes
 - if mode with resoultion y > 1024 is selected at least once then
   all modes with y < 1024 are "out of sync" (no display)

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-fix-timing-calculations drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-fix-timing-calculations
+++ a/drivers/video/tridentfb.c
@@ -886,20 +886,19 @@ static int tridentfb_set_par(struct fb_i
 
 	debug("enter\n");
 	hdispend = var->xres / 8 - 1;
-	hsyncstart = (var->xres + var->right_margin) / 8;
-	hsyncend = var->hsync_len / 8;
-	htotal =
-		(var->xres + var->left_margin + var->right_margin +
-		 var->hsync_len) / 8 - 10;
-	hblankstart = hdispend + 1;
-	hblankend = htotal + 5;
+	hsyncstart = (var->xres + var->right_margin) / 8 - 1;
+	hsyncend = (var->xres + var->right_margin + var->hsync_len) / 8 - 1;
+	htotal = (var->xres + var->left_margin + var->right_margin +
+		  var->hsync_len) / 8 - 5;
+	hblankstart = hdispend + 2;
+	hblankend = htotal + 3;
 
 	vdispend = var->yres - 1;
 	vsyncstart = var->yres + var->lower_margin;
-	vsyncend = var->vsync_len;
-	vtotal = var->upper_margin + vsyncstart + vsyncend - 2;
-	vblankstart = var->yres;
-	vblankend = vtotal + 2;
+	vsyncend = vsyncstart + var->vsync_len;
+	vtotal = var->upper_margin + vsyncend - 2;
+	vblankstart = vdispend + 2;
+	vblankend = vtotal;
 
 	crtc_unlock(par);
 	write3CE(par, CyberControl, 8);
@@ -930,7 +929,7 @@ static int tridentfb_set_par(struct fb_i
 	write3X4(par, VGA_CRTC_V_SYNC_START, vsyncstart & 0xFF);
 	write3X4(par, VGA_CRTC_V_SYNC_END, (vsyncend & 0x0F));
 	write3X4(par, VGA_CRTC_V_BLANK_START, vblankstart & 0xFF);
-	write3X4(par, VGA_CRTC_V_BLANK_END, 0 /* p->vblankend & 0xFF */);
+	write3X4(par, VGA_CRTC_V_BLANK_END, vblankend & 0xFF);
 
 	/* horizontal timing values */
 	write3X4(par, VGA_CRTC_H_TOTAL, htotal & 0xFF);
@@ -939,7 +938,7 @@ static int tridentfb_set_par(struct fb_i
 	write3X4(par, VGA_CRTC_H_SYNC_END,
 		 (hsyncend & 0x1F) | ((hblankend & 0x20) << 2));
 	write3X4(par, VGA_CRTC_H_BLANK_START, hblankstart & 0xFF);
-	write3X4(par, VGA_CRTC_H_BLANK_END, 0 /* (p->hblankend & 0x1F) */);
+	write3X4(par, VGA_CRTC_H_BLANK_END, hblankend & 0x1F);
 
 	/* higher bits of vertical timing values */
 	tmp = 0x10;
@@ -953,16 +952,18 @@ static int tridentfb_set_par(struct fb_i
 	if (vsyncstart & 0x200) tmp |= 0x80;
 	write3X4(par, VGA_CRTC_OVERFLOW, tmp);
 
-	tmp = read3X4(par, CRTHiOrd) | 0x08;	/* line compare bit 10 */
+	tmp = read3X4(par, CRTHiOrd) & 0x07;
+	tmp |= 0x08;	/* line compare bit 10 */
 	if (vtotal & 0x400) tmp |= 0x80;
 	if (vblankstart & 0x400) tmp |= 0x40;
 	if (vsyncstart & 0x400) tmp |= 0x20;
 	if (vdispend & 0x400) tmp |= 0x10;
 	write3X4(par, CRTHiOrd, tmp);
 
-	tmp = 0;
-	if (htotal & 0x800) tmp |= 0x800 >> 11;
-	if (hblankstart & 0x800) tmp |= 0x800 >> 7;
+	tmp = (htotal >> 8) & 0x01;
+	tmp |= (hdispend >> 7) & 0x02;
+	tmp |= (hsyncstart >> 5) & 0x08;
+	tmp |= (hblankstart >> 4) & 0x10;
 	write3X4(par, HorizOverflow, tmp);
 
 	tmp = 0x40;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

