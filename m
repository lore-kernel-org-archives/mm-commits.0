From: akpm@linux-foundation.org
Subject: - cirrusfb-eliminate-crt-registers-from-global-structure.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:20 -0700
Message-ID: <200810182317.m9INHKk1029069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbYJRXRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: eliminate CRT registers from global structure
has been removed from the -mm tree.  Its filename was
     cirrusfb-eliminate-crt-registers-from-global-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: eliminate CRT registers from global structure
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Move calculations of CRT register values into the cirrusfb_set_par_foo()
where the values are used.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |  192 +++++++++++++++----------------------
 1 file changed, 83 insertions(+), 109 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-eliminate-crt-registers-from-global-structure drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-eliminate-crt-registers-from-global-structure
+++ a/drivers/video/cirrusfb.c
@@ -334,22 +334,6 @@ struct cirrusfb_regs {
 	long multiplexing;
 	long mclk;
 	long divMCLK;
-
-	long HorizRes;		/* The x resolution in pixel */
-	long HorizTotal;
-	long HorizDispEnd;
-	long HorizBlankStart;
-	long HorizBlankEnd;
-	long HorizSyncStart;
-	long HorizSyncEnd;
-
-	long VertRes;		/* the physical y resolution in scanlines */
-	long VertTotal;
-	long VertDispEnd;
-	long VertSyncStart;
-	long VertSyncEnd;
-	long VertBlankStart;
-	long VertBlankEnd;
 };
 
 #ifdef CIRRUSFB_DEBUG
@@ -664,8 +648,6 @@ static int cirrusfb_decode_var(const str
 	long maxclock;
 	int maxclockidx = var->bits_per_pixel >> 3;
 	struct cirrusfb_info *cinfo = info->par;
-	int xres, hfront, hsync, hback;
-	int yres, vfront, vsync, vback;
 
 	switch (var->bits_per_pixel) {
 	case 1:
@@ -723,7 +705,7 @@ static int cirrusfb_decode_var(const str
 	switch (var->bits_per_pixel) {
 	case 16:
 	case 32:
-		if (regs->HorizRes <= 800)
+		if (var->xres <= 800)
 			/* Xbh has this type of clock for 32-bit */
 			freq /= 2;
 		break;
@@ -735,57 +717,6 @@ static int cirrusfb_decode_var(const str
 	regs->mclk = cirrusfb_get_mclk(freq, var->bits_per_pixel,
 					&regs->divMCLK);
 
-	xres = var->xres;
-	hfront = var->right_margin;
-	hsync = var->hsync_len;
-	hback = var->left_margin;
-
-	yres = var->yres;
-	vfront = var->lower_margin;
-	vsync = var->vsync_len;
-	vback = var->upper_margin;
-
-	if (var->vmode & FB_VMODE_DOUBLE) {
-		yres *= 2;
-		vfront *= 2;
-		vsync *= 2;
-		vback *= 2;
-	} else if (var->vmode & FB_VMODE_INTERLACED) {
-		yres = (yres + 1) / 2;
-		vfront = (vfront + 1) / 2;
-		vsync = (vsync + 1) / 2;
-		vback = (vback + 1) / 2;
-	}
-	regs->HorizRes = xres;
-	regs->HorizTotal = (xres + hfront + hsync + hback) / 8 - 5;
-	regs->HorizDispEnd = xres / 8 - 1;
-	regs->HorizBlankStart = xres / 8;
-	/* does not count with "-5" */
-	regs->HorizBlankEnd = regs->HorizTotal + 5;
-	regs->HorizSyncStart = (xres + hfront) / 8 + 1;
-	regs->HorizSyncEnd = (xres + hfront + hsync) / 8 + 1;
-
-	regs->VertRes = yres;
-	regs->VertTotal = yres + vfront + vsync + vback - 2;
-	regs->VertDispEnd = yres - 1;
-	regs->VertBlankStart = yres;
-	regs->VertBlankEnd = regs->VertTotal;
-	regs->VertSyncStart = yres + vfront - 1;
-	regs->VertSyncEnd = yres + vfront + vsync - 1;
-
-	if (regs->VertRes >= 1024) {
-		regs->VertTotal /= 2;
-		regs->VertSyncStart /= 2;
-		regs->VertSyncEnd /= 2;
-		regs->VertDispEnd /= 2;
-	}
-	if (regs->multiplexing) {
-		regs->HorizTotal /= 2;
-		regs->HorizSyncStart /= 2;
-		regs->HorizSyncEnd /= 2;
-		regs->HorizDispEnd /= 2;
-	}
-
 	return 0;
 }
 
@@ -823,6 +754,8 @@ static int cirrusfb_set_par_foo(struct f
 	unsigned char tmp;
 	int offset = 0, err;
 	const struct cirrusfb_board_info_rec *bi;
+	int hdispend, hsyncstart, hsyncend, htotal;
+	int yres, vdispend, vsyncstart, vsyncend, vtotal;
 
 	DPRINTK("ENTER\n");
 	DPRINTK("Requested mode: %dx%dx%d\n",
@@ -840,76 +773,117 @@ static int cirrusfb_set_par_foo(struct f
 
 	bi = &cirrusfb_board_info[cinfo->btype];
 
+	hsyncstart = var->xres + var->right_margin;
+	hsyncend = hsyncstart + var->hsync_len;
+	htotal = (hsyncend + var->left_margin) / 8 - 5;
+	hdispend = var->xres / 8 - 1;
+	hsyncstart = hsyncstart / 8 + 1;
+	hsyncend = hsyncend / 8 + 1;
+
+	yres = var->yres;
+	vsyncstart = yres + var->lower_margin;
+	vsyncend = vsyncstart + var->vsync_len;
+	vtotal = vsyncend + var->upper_margin;
+	vdispend = yres - 1;
+
+	if (var->vmode & FB_VMODE_DOUBLE) {
+		yres *= 2;
+		vsyncstart *= 2;
+		vsyncend *= 2;
+		vtotal *= 2;
+	} else if (var->vmode & FB_VMODE_INTERLACED) {
+		yres = (yres + 1) / 2;
+		vsyncstart = (vsyncstart + 1) / 2;
+		vsyncend = (vsyncend + 1) / 2;
+		vtotal = (vtotal + 1) / 2;
+	}
+
+	vtotal -= 2;
+	vsyncstart -= 1;
+	vsyncend -= 1;
+
+	if (yres >= 1024) {
+		vtotal /= 2;
+		vsyncstart /= 2;
+		vsyncend /= 2;
+		vdispend /= 2;
+	}
+	if (regs.multiplexing) {
+		htotal /= 2;
+		hsyncstart /= 2;
+		hsyncend /= 2;
+		hdispend /= 2;
+	}
 	/* unlock register VGA_CRTC_H_TOTAL..CRT7 */
 	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, 0x20);	/* previously: 0x00) */
 
 	/* if debugging is enabled, all parameters get output before writing */
-	DPRINTK("CRT0: %ld\n", regs.HorizTotal);
-	vga_wcrt(regbase, VGA_CRTC_H_TOTAL, regs.HorizTotal);
+	DPRINTK("CRT0: %d\n", htotal);
+	vga_wcrt(regbase, VGA_CRTC_H_TOTAL, htotal);
 
-	DPRINTK("CRT1: %ld\n", regs.HorizDispEnd);
-	vga_wcrt(regbase, VGA_CRTC_H_DISP, regs.HorizDispEnd);
+	DPRINTK("CRT1: %d\n", hdispend);
+	vga_wcrt(regbase, VGA_CRTC_H_DISP, hdispend);
 
-	DPRINTK("CRT2: %ld\n", regs.HorizBlankStart);
-	vga_wcrt(regbase, VGA_CRTC_H_BLANK_START, regs.HorizBlankStart);
+	DPRINTK("CRT2: %d\n", var->xres / 8);
+	vga_wcrt(regbase, VGA_CRTC_H_BLANK_START, var->xres / 8);
 
 	/*  + 128: Compatible read */
-	DPRINTK("CRT3: 128+%ld\n", regs.HorizBlankEnd % 32);
+	DPRINTK("CRT3: 128+%d\n", (htotal + 5) % 32);
 	vga_wcrt(regbase, VGA_CRTC_H_BLANK_END,
-		 128 + (regs.HorizBlankEnd % 32));
+		 128 + ((htotal + 5) % 32));
 
-	DPRINTK("CRT4: %ld\n", regs.HorizSyncStart);
-	vga_wcrt(regbase, VGA_CRTC_H_SYNC_START, regs.HorizSyncStart);
+	DPRINTK("CRT4: %d\n", hsyncstart);
+	vga_wcrt(regbase, VGA_CRTC_H_SYNC_START, hsyncstart);
 
-	tmp = regs.HorizSyncEnd % 32;
-	if (regs.HorizBlankEnd & 32)
+	tmp = hsyncend % 32;
+	if ((htotal + 5) & 32)
 		tmp += 128;
 	DPRINTK("CRT5: %d\n", tmp);
 	vga_wcrt(regbase, VGA_CRTC_H_SYNC_END, tmp);
 
-	DPRINTK("CRT6: %ld\n", regs.VertTotal & 0xff);
-	vga_wcrt(regbase, VGA_CRTC_V_TOTAL, (regs.VertTotal & 0xff));
+	DPRINTK("CRT6: %d\n", vtotal & 0xff);
+	vga_wcrt(regbase, VGA_CRTC_V_TOTAL, vtotal & 0xff);
 
 	tmp = 16;		/* LineCompare bit #9 */
-	if (regs.VertTotal & 256)
+	if (vtotal & 256)
 		tmp |= 1;
-	if (regs.VertDispEnd & 256)
+	if (vdispend & 256)
 		tmp |= 2;
-	if (regs.VertSyncStart & 256)
+	if (vsyncstart & 256)
 		tmp |= 4;
-	if (regs.VertBlankStart & 256)
+	if ((vdispend + 1) & 256)
 		tmp |= 8;
-	if (regs.VertTotal & 512)
+	if (vtotal & 512)
 		tmp |= 32;
-	if (regs.VertDispEnd & 512)
+	if (vdispend & 512)
 		tmp |= 64;
-	if (regs.VertSyncStart & 512)
+	if (vsyncstart & 512)
 		tmp |= 128;
 	DPRINTK("CRT7: %d\n", tmp);
 	vga_wcrt(regbase, VGA_CRTC_OVERFLOW, tmp);
 
 	tmp = 0x40;		/* LineCompare bit #8 */
-	if (regs.VertBlankStart & 512)
+	if ((vdispend + 1) & 512)
 		tmp |= 0x20;
 	if (var->vmode & FB_VMODE_DOUBLE)
 		tmp |= 0x80;
 	DPRINTK("CRT9: %d\n", tmp);
 	vga_wcrt(regbase, VGA_CRTC_MAX_SCAN, tmp);
 
-	DPRINTK("CRT10: %ld\n", regs.VertSyncStart & 0xff);
-	vga_wcrt(regbase, VGA_CRTC_V_SYNC_START, regs.VertSyncStart & 0xff);
+	DPRINTK("CRT10: %d\n", vsyncstart & 0xff);
+	vga_wcrt(regbase, VGA_CRTC_V_SYNC_START, vsyncstart & 0xff);
 
-	DPRINTK("CRT11: 64+32+%ld\n", regs.VertSyncEnd % 16);
-	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, regs.VertSyncEnd % 16 + 64 + 32);
+	DPRINTK("CRT11: 64+32+%d\n", vsyncend % 16);
+	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, vsyncend % 16 + 64 + 32);
 
-	DPRINTK("CRT12: %ld\n", regs.VertDispEnd & 0xff);
-	vga_wcrt(regbase, VGA_CRTC_V_DISP_END, regs.VertDispEnd & 0xff);
+	DPRINTK("CRT12: %d\n", vdispend & 0xff);
+	vga_wcrt(regbase, VGA_CRTC_V_DISP_END, vdispend & 0xff);
 
-	DPRINTK("CRT15: %ld\n", regs.VertBlankStart & 0xff);
-	vga_wcrt(regbase, VGA_CRTC_V_BLANK_START, regs.VertBlankStart & 0xff);
+	DPRINTK("CRT15: %d\n", (vdispend + 1) & 0xff);
+	vga_wcrt(regbase, VGA_CRTC_V_BLANK_START, (vdispend + 1) & 0xff);
 
-	DPRINTK("CRT16: %ld\n", regs.VertBlankEnd & 0xff);
-	vga_wcrt(regbase, VGA_CRTC_V_BLANK_END, regs.VertBlankEnd & 0xff);
+	DPRINTK("CRT16: %d\n", vtotal & 0xff);
+	vga_wcrt(regbase, VGA_CRTC_V_BLANK_END, vtotal & 0xff);
 
 	DPRINTK("CRT18: 0xff\n");
 	vga_wcrt(regbase, VGA_CRTC_LINE_COMPARE, 0xff);
@@ -917,13 +891,13 @@ static int cirrusfb_set_par_foo(struct f
 	tmp = 0;
 	if (var->vmode & FB_VMODE_INTERLACED)
 		tmp |= 1;
-	if (regs.HorizBlankEnd & 64)
+	if ((htotal + 5) & 64)
 		tmp |= 16;
-	if (regs.HorizBlankEnd & 128)
+	if ((htotal + 5) & 128)
 		tmp |= 32;
-	if (regs.VertBlankEnd & 256)
+	if (vtotal & 256)
 		tmp |= 64;
-	if (regs.VertBlankEnd & 512)
+	if (vtotal & 512)
 		tmp |= 128;
 
 	DPRINTK("CRT1a: %d\n", tmp);
@@ -948,7 +922,7 @@ static int cirrusfb_set_par_foo(struct f
 	DPRINTK("CL_SEQR1B: %ld\n", (long) tmp);
 	vga_wseq(regbase, CL_SEQR1B, tmp);
 
-	if (regs.VertRes >= 1024)
+	if (yres >= 1024)
 		/* 1280x1024 */
 		vga_wcrt(regbase, VGA_CRTC_MODE, 0xc7);
 	else
@@ -962,7 +936,7 @@ static int cirrusfb_set_par_foo(struct f
 	/* don't know if it would hurt to also program this if no interlaced */
 	/* mode is used, but I feel better this way.. :-) */
 	if (var->vmode & FB_VMODE_INTERLACED)
-		vga_wcrt(regbase, VGA_CRTC_REGS, regs.HorizTotal / 2);
+		vga_wcrt(regbase, VGA_CRTC_REGS, htotal / 2);
 	else
 		vga_wcrt(regbase, VGA_CRTC_REGS, 0x00);	/* interlace control */
 
@@ -1208,7 +1182,7 @@ static int cirrusfb_set_par_foo(struct f
 
 		case BT_ALPINE:
 			DPRINTK(" (for GD543x)\n");
-			if (regs.HorizRes >= 1024)
+			if (var->xres >= 1024)
 				vga_wseq(regbase, CL_SEQR7, 0xa7);
 			else
 				vga_wseq(regbase, CL_SEQR7, 0xa3);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch

