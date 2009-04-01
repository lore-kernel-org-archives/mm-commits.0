From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-use-24bpp-instead-of-32bpp.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:53 -0700
Message-ID: <200904011842.n31IgrBE009856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760405AbZDASpB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:45:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: use 24bpp instead of 32bpp
has been removed from the -mm tree.  Its filename was
     cirrusfb-use-24bpp-instead-of-32bpp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: use 24bpp instead of 32bpp
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The 32bpp is supported only on the latest Cirrus Logic chips.  Use the
24bpp which is supported at least since Alpine chips (GD543x).

Change 32bpp mode setting to 24bpp mode.  Change acceleration as well.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   79 ++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 35 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-use-24bpp-instead-of-32bpp drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-use-24bpp-instead-of-32bpp
+++ a/drivers/video/cirrusfb.c
@@ -95,10 +95,10 @@
 /* board types */
 enum cirrus_board {
 	BT_NONE = 0,
-	BT_SD64,
-	BT_PICCOLO,
-	BT_PICASSO,
-	BT_SPECTRUM,
+	BT_SD64,	/* GD5434 */
+	BT_PICCOLO,	/* GD5426 */
+	BT_PICASSO,	/* GD5426 or GD5428 */
+	BT_SPECTRUM,	/* GD5426 or GD5428 */
 	BT_PICASSO4,	/* GD5446 */
 	BT_ALPINE,	/* GD543x/4x */
 	BT_GD5480,
@@ -488,7 +488,7 @@ static int cirrusfb_check_pixclock(const
 	 * the VCLK is double the pixel clock. */
 	switch (var->bits_per_pixel) {
 	case 16:
-	case 32:
+	case 24:
 		if (var->xres <= 800)
 			/* Xbh has this type of clock for 32-bit */
 			freq /= 2;
@@ -535,11 +535,11 @@ static int cirrusfb_check_var(struct fb_
 		var->blue.length = 5;
 		break;
 
-	case 32:
+	case 24:
 		if (isPReP) {
-			var->red.offset = 8;
-			var->green.offset = 16;
-			var->blue.offset = 24;
+			var->red.offset = 0;
+			var->green.offset = 8;
+			var->blue.offset = 16;
 		} else {
 			var->red.offset = 16;
 			var->green.offset = 8;
@@ -670,7 +670,7 @@ static int cirrusfb_set_par_foo(struct f
 		break;
 
 	case 16:
-	case 32:
+	case 24:
 		info->fix.line_length = var->xres_virtual *
 					var->bits_per_pixel >> 3;
 		info->fix.visual = FB_VISUAL_TRUECOLOR;
@@ -813,6 +813,9 @@ static int cirrusfb_set_par_foo(struct f
 	vga_wcrt(regbase, CL_CRT1A, tmp);
 
 	freq = PICOS2KHZ(var->pixclock);
+	if (cinfo->btype == BT_ALPINE && var->bits_per_pixel == 24)
+		freq *= 3;
+
 	bestclock(freq, &nom, &den, &div);
 
 	dev_dbg(info->device, "VCLK freq: %ld kHz  nom: %d  den: %d  div: %d\n",
@@ -1140,16 +1143,16 @@ static int cirrusfb_set_par_foo(struct f
 
 	/******************************************************
 	 *
-	 * 32 bpp
+	 * 24 bpp
 	 *
 	 */
 
-	else if (var->bits_per_pixel == 32) {
-		dev_dbg(info->device, "preparing for 32 bit deep display\n");
+	else if (var->bits_per_pixel == 24) {
+		dev_dbg(info->device, "preparing for 24 bit deep display\n");
 		switch (cinfo->btype) {
 		case BT_SD64:
 			/* Extended Sequencer Mode: 256c col. mode */
-			vga_wseq(regbase, CL_SEQR7, 0xf9);
+			vga_wseq(regbase, CL_SEQR7, 0xf5);
 			/* MCLK select */
 			vga_wseq(regbase, CL_SEQR1F, 0x1e);
 			break;
@@ -1173,11 +1176,11 @@ static int cirrusfb_set_par_foo(struct f
 
 		case BT_PICASSO4:
 		case BT_ALPINE:
-			vga_wseq(regbase, CL_SEQR7, 0xa9);
+			vga_wseq(regbase, CL_SEQR7, 0xa5);
 			break;
 
 		case BT_GD5480:
-			vga_wseq(regbase, CL_SEQR7, 0x19);
+			vga_wseq(regbase, CL_SEQR7, 0x15);
 			/* We already set SRF and SR1F */
 			break;
 
@@ -1185,8 +1188,8 @@ static int cirrusfb_set_par_foo(struct f
 		case BT_LAGUNAB:
 			vga_wseq(regbase, CL_SEQR7,
 				vga_rseq(regbase, CL_SEQR7) & ~0x01);
-			control |= 0x6000;
-			format |= 0x3400;
+			control |= 0x4000;
+			format |= 0x2400;
 			threshold |= 0x20;
 			break;
 
@@ -1385,9 +1388,6 @@ static int cirrusfb_pan_display(struct f
 	if (info->var.bits_per_pixel == 1)
 		vga_wattr(cinfo->regbase, CL_AR33, xpix);
 
-	if (!is_laguna(cinfo))
-		cirrusfb_WaitBLT(cinfo->regbase);
-
 	return 0;
 }
 
@@ -1492,22 +1492,18 @@ static void init_vgachip(struct fb_info 
 		/* disable flickerfixer */
 		vga_wcrt(cinfo->regbase, CL_CRT51, 0x00);
 		mdelay(100);
-		/* from Klaus' NetBSD driver: */
-		vga_wgfx(cinfo->regbase, CL_GR2F, 0x00);
-		/* put blitter into 542x compat */
-		vga_wgfx(cinfo->regbase, CL_GR33, 0x00);
 		/* mode */
 		vga_wgfx(cinfo->regbase, CL_GR31, 0x00);
-		break;
-
-	case BT_GD5480:
+	case BT_GD5480:  /* fall through */
 		/* from Klaus' NetBSD driver: */
 		vga_wgfx(cinfo->regbase, CL_GR2F, 0x00);
+	case BT_ALPINE:  /* fall through */
+		/* put blitter into 542x compat */
+		vga_wgfx(cinfo->regbase, CL_GR33, 0x00);
 		break;
 
 	case BT_LAGUNA:
 	case BT_LAGUNAB:
-	case BT_ALPINE:
 		/* Nothing to do to reset the board. */
 		break;
 
@@ -1831,10 +1827,13 @@ static void cirrusfb_imageblit(struct fb
 			       const struct fb_image *image)
 {
 	struct cirrusfb_info *cinfo = info->par;
+	unsigned char op = (info->var.bits_per_pixel == 24) ? 0xc : 0x4;
 
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
-	if (info->flags & FBINFO_HWACCEL_DISABLED)
+	/* Alpine acceleration does not work at 24bpp ?!? */
+	if (info->flags & FBINFO_HWACCEL_DISABLED || image->depth != 1 ||
+	    (cinfo->btype == BT_ALPINE && op == 0xc))
 		cfb_imageblit(info, image);
 	else {
 		unsigned size = ((image->width + 7) >> 3) * image->height;
@@ -1848,15 +1847,22 @@ static void cirrusfb_imageblit(struct fb
 			fg = ((u32 *)(info->pseudo_palette))[image->fg_color];
 			bg = ((u32 *)(info->pseudo_palette))[image->bg_color];
 		}
-		cirrusfb_WaitBLT(cinfo->regbase);
-		/* byte rounded scanlines */
-		vga_wgfx(cinfo->regbase, CL_GR33, 0x00);
+		if (info->var.bits_per_pixel == 24) {
+			/* clear background first */
+			cirrusfb_RectFill(cinfo->regbase,
+					  info->var.bits_per_pixel,
+					  (image->dx * m) / 8, image->dy,
+					  (image->width * m) / 8,
+					  image->height,
+					  bg, bg,
+					  info->fix.line_length, 0x40);
+		}
 		cirrusfb_RectFill(cinfo->regbase,
 				  info->var.bits_per_pixel,
 				  (image->dx * m) / 8, image->dy,
 				  (image->width * m) / 8, image->height,
 				  fg, bg,
-				  info->fix.line_length, 0x04);
+				  info->fix.line_length, op);
 		memcpy(info->screen_base, image->data, size);
 	}
 }
@@ -2743,9 +2749,12 @@ static void cirrusfb_RectFill(u8 __iomem
 		vga_wgfx(regbase, CL_GR11, fg_color >> 8);
 		op = 0x90;
 	}
-	if (bits_per_pixel == 32) {
+	if (bits_per_pixel >= 24) {
 		vga_wgfx(regbase, CL_GR12, bg_color >> 16);
 		vga_wgfx(regbase, CL_GR13, fg_color >> 16);
+		op = 0xa0;
+	}
+	if (bits_per_pixel == 32) {
 		vga_wgfx(regbase, CL_GR14, bg_color >> 24);
 		vga_wgfx(regbase, CL_GR15, fg_color >> 24);
 		op = 0xb0;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

