From: akpm@linux-foundation.org
Subject: + cirrusfb-code-improvements.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:46 -0700
Message-ID: <200708272223.l7RMNke0031680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758060AbXH0WXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     cirrusfb: code improvements
has been added to the -mm tree.  Its filename is
     cirrusfb-code-improvements.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cirrusfb: code improvements
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch does some "short-range" code improvements like merging identical
switch clauses, replacing conditional branches with calculation of values,
merging only once-used functions into place they are called from.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |  216 +++++++------------------------------
 1 files changed, 41 insertions(+), 175 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-code-improvements drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-code-improvements
+++ a/drivers/video/cirrusfb.c
@@ -647,31 +647,17 @@ static int cirrusfb_check_var(struct fb_
 	  { -1, -1 } };
 
 	switch (var->bits_per_pixel) {
-	case 0 ... 1:
-		var->bits_per_pixel = 1;
+	case 1:
 		nom = 4;
 		den = 8;
 		break;		/* 8 pixel per byte, only 1/4th of mem usable */
-	case 2 ... 8:
-		var->bits_per_pixel = 8;
-		nom = 1;
+	case 8:
+	case 16:
+	case 24:
+	case 32:
+		nom = var->bits_per_pixel / 8;
 		den = 1;
 		break;		/* 1 pixel == 1 byte */
-	case 9 ... 16:
-		var->bits_per_pixel = 16;
-		nom = 2;
-		den = 1;
-		break;		/* 2 bytes per pixel */
-	case 17 ... 24:
-		var->bits_per_pixel = 24;
-		nom = 3;
-		den = 1;
-		break;		/* 3 bytes per pixel */
-	case 25 ... 32:
-		var->bits_per_pixel = 32;
-		nom = 4;
-		den = 1;
-		break;		/* 4 bytes per pixel */
 	default:
 		printk(KERN_ERR "cirrusfb: mode %dx%dx%d rejected..."
 			"color depth not supported.\n",
@@ -732,19 +718,15 @@ static int cirrusfb_check_var(struct fb_
 	case 1:
 		var->red.offset = 0;
 		var->red.length = 1;
-		var->green.offset = 0;
-		var->green.length = 1;
-		var->blue.offset = 0;
-		var->blue.length = 1;
+		var->green = var->red;
+		var->blue = var->red;
 		break;
 
 	case 8:
 		var->red.offset = 0;
 		var->red.length = 6;
-		var->green.offset = 0;
-		var->green.length = 6;
-		var->blue.offset = 0;
-		var->blue.length = 6;
+		var->green = var->red;
+		var->blue = var->red;
 		break;
 
 	case 16:
@@ -763,20 +745,6 @@ static int cirrusfb_check_var(struct fb_
 		break;
 
 	case 24:
-		if (isPReP) {
-			var->red.offset = 8;
-			var->green.offset = 16;
-			var->blue.offset = 24;
-		} else {
-			var->red.offset = 16;
-			var->green.offset = 8;
-			var->blue.offset = 0;
-		}
-		var->red.length = 8;
-		var->green.length = 8;
-		var->blue.length = 8;
-		break;
-
 	case 32:
 		if (isPReP) {
 			var->red.offset = 8;
@@ -828,7 +796,7 @@ static int cirrusfb_decode_var(const str
 {
 	long freq;
 	long maxclock;
-	int maxclockidx = 0;
+	int maxclockidx = var->bits_per_pixel >> 3;
 	struct cirrusfb_info *cinfo = info->par;
 	int xres, hfront, hsync, hback;
 	int yres, vfront, vsync, vback;
@@ -837,31 +805,18 @@ static int cirrusfb_decode_var(const str
 	case 1:
 		regs->line_length = var->xres_virtual / 8;
 		regs->visual = FB_VISUAL_MONO10;
-		maxclockidx = 0;
 		break;
 
 	case 8:
 		regs->line_length = var->xres_virtual;
 		regs->visual = FB_VISUAL_PSEUDOCOLOR;
-		maxclockidx = 1;
 		break;
 
 	case 16:
-		regs->line_length = var->xres_virtual * 2;
-		regs->visual = FB_VISUAL_DIRECTCOLOR;
-		maxclockidx = 2;
-		break;
-
 	case 24:
-		regs->line_length = var->xres_virtual * 3;
-		regs->visual = FB_VISUAL_DIRECTCOLOR;
-		maxclockidx = 3;
-		break;
-
 	case 32:
-		regs->line_length = var->xres_virtual * 4;
+		regs->line_length = var->xres_virtual * maxclockidx;
 		regs->visual = FB_VISUAL_DIRECTCOLOR;
-		maxclockidx = 4;
 		break;
 
 	default:
@@ -874,7 +829,7 @@ static int cirrusfb_decode_var(const str
 	regs->type = FB_TYPE_PACKED_PIXELS;
 
 	/* convert from ps to kHz */
-	freq = 1000000000 / var->pixclock;
+	freq = PICOS2KHZ(var->pixclock);
 
 	DPRINTK("desired pixclock: %ld kHz\n", freq);
 
@@ -1213,7 +1168,8 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_PICCOLO:
-			DPRINTK("(for Piccolo)\n");
+		case BT_SPECTRUM:
+			DPRINTK("(for Piccolo/Spectrum)\n");
 			/* ### ueberall 0x22? */
 			/* ##vorher 1c MCLK select */
 			vga_wseq(regbase, CL_SEQR1F, 0x22);
@@ -1229,15 +1185,6 @@ static int cirrusfb_set_par_foo(struct f
 			vga_wseq(regbase, CL_SEQRF, 0xd0);
 			break;
 
-		case BT_SPECTRUM:
-			DPRINTK("(for Spectrum)\n");
-			/* ### ueberall 0x22? */
-			/* ##vorher 1c MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
-			/* evtl d0? avoid FIFO underruns..? */
-			vga_wseq(regbase, CL_SEQRF, 0xb0);
-			break;
-
 		case BT_PICASSO4:
 		case BT_ALPINE:
 		case BT_GD5480:
@@ -1306,19 +1253,7 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_PICCOLO:
-			/* ### vorher 1c MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
-			/* Fast Page-Mode writes */
-			vga_wseq(regbase, CL_SEQRF, 0xb0);
-			break;
-
 		case BT_PICASSO:
-			/* ### vorher 1c MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
-			/* Fast Page-Mode writes */
-			vga_wseq(regbase, CL_SEQRF, 0xb0);
-			break;
-
 		case BT_SPECTRUM:
 			/* ### vorher 1c MCLK select */
 			vga_wseq(regbase, CL_SEQR1F, 0x22);
@@ -1385,6 +1320,7 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_PICCOLO:
+		case BT_SPECTRUM:
 			vga_wseq(regbase, CL_SEQR7, 0x87);
 			/* Fast Page-Mode writes */
 			vga_wseq(regbase, CL_SEQRF, 0xb0);
@@ -1400,14 +1336,6 @@ static int cirrusfb_set_par_foo(struct f
 			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
-		case BT_SPECTRUM:
-			vga_wseq(regbase, CL_SEQR7, 0x87);
-			/* Fast Page-Mode writes */
-			vga_wseq(regbase, CL_SEQRF, 0xb0);
-			/* MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
-			break;
-
 		case BT_PICASSO4:
 			vga_wseq(regbase, CL_SEQR7, 0x27);
 /*			vga_wseq(regbase, CL_SEQR1F, 0x1c);  */
@@ -1473,6 +1401,7 @@ static int cirrusfb_set_par_foo(struct f
 			break;
 
 		case BT_PICCOLO:
+		case BT_SPECTRUM:
 			vga_wseq(regbase, CL_SEQR7, 0x85);
 			/* Fast Page-Mode writes */
 			vga_wseq(regbase, CL_SEQRF, 0xb0);
@@ -1488,14 +1417,6 @@ static int cirrusfb_set_par_foo(struct f
 			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
-		case BT_SPECTRUM:
-			vga_wseq(regbase, CL_SEQR7, 0x85);
-			/* Fast Page-Mode writes */
-			vga_wseq(regbase, CL_SEQRF, 0xb0);
-			/* MCLK select */
-			vga_wseq(regbase, CL_SEQR1F, 0x22);
-			break;
-
 		case BT_PICASSO4:
 			vga_wseq(regbase, CL_SEQR7, 0x25);
 /*			vga_wseq(regbase, CL_SEQR1F, 0x1c);  */
@@ -1662,18 +1583,7 @@ static int cirrusfb_setcolreg(unsigned r
 		    (green << info->var.green.offset) |
 		    (blue << info->var.blue.offset);
 
-		switch (info->var.bits_per_pixel) {
-		case 8:
-			cinfo->pseudo_palette[regno] = v;
-			break;
-		case 16:
-			cinfo->pseudo_palette[regno] = v;
-			break;
-		case 24:
-		case 32:
-			cinfo->pseudo_palette[regno] = v;
-			break;
-		}
+		cinfo->pseudo_palette[regno] = v;
 		return 0;
 	}
 
@@ -1743,12 +1653,8 @@ static int cirrusfb_pan_display(struct f
 	vga_wcrt(cinfo->regbase, CL_CRT1B, tmp2);
 
 	/* construct bit 19 of screen start address */
-	if (cirrusfb_board_info[cinfo->btype].scrn_start_bit19) {
-		tmp2 = 0;
-		if (base & 0x80000)
-			tmp2 = 0x80;
-		vga_wcrt(cinfo->regbase, CL_CRT1D, tmp2);
-	}
+	if (cirrusfb_board_info[cinfo->btype].scrn_start_bit19)
+		vga_wcrt(cinfo->regbase, CL_CRT1D, (base >> 12) & 0x80);
 
 	/* write pixel panning value to AR33; this does not quite work in 8bpp
 	 *
@@ -2139,38 +2045,15 @@ static void switch_monitor(struct cirrus
 /* Linux 2.6-style  accelerated functions */
 /******************************************/
 
-static void cirrusfb_prim_fillrect(struct fb_info *info,
-				   const struct fb_fillrect *region)
-{
-	struct cirrusfb_info *cinfo = info->par;
-	int m; /* bytes per pixel */
-	u32 color = (info->fix.visual == FB_VISUAL_TRUECOLOR) ?
-		cinfo->pseudo_palette[region->color] : region->color;
-
-	if (info->var.bits_per_pixel == 1) {
-		cirrusfb_RectFill(cinfo->regbase,
-				  info->var.bits_per_pixel,
-				  region->dx / 8, region->dy,
-				  region->width / 8, region->height,
-				  color,
-				  cinfo->currentmode.line_length);
-	} else {
-		m = (info->var.bits_per_pixel + 7) / 8;
-		cirrusfb_RectFill(cinfo->regbase,
-				  info->var.bits_per_pixel,
-				  region->dx * m, region->dy,
-				  region->width * m, region->height,
-				  color,
-				  cinfo->currentmode.line_length);
-	}
-	return;
-}
-
 static void cirrusfb_fillrect(struct fb_info *info,
 			      const struct fb_fillrect *region)
 {
 	struct fb_fillrect modded;
 	int vxres, vyres;
+	struct cirrusfb_info *cinfo = info->par;
+	int m = info->var.bits_per_pixel;
+	u32 color = (info->fix.visual == FB_VISUAL_TRUECOLOR) ?
+		cinfo->pseudo_palette[region->color] : region->color;
 
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
@@ -2193,30 +2076,12 @@ static void cirrusfb_fillrect(struct fb_
 	if (modded.dy + modded.height > vyres)
 		modded.height = vyres - modded.dy;
 
-	cirrusfb_prim_fillrect(info, &modded);
-}
-
-static void cirrusfb_prim_copyarea(struct fb_info *info,
-				   const struct fb_copyarea *area)
-{
-	struct cirrusfb_info *cinfo = info->par;
-	int m; /* bytes per pixel */
-
-	if (info->var.bits_per_pixel == 1) {
-		cirrusfb_BitBLT(cinfo->regbase, info->var.bits_per_pixel,
-				area->sx / 8, area->sy,
-				area->dx / 8, area->dy,
-				area->width / 8, area->height,
-				cinfo->currentmode.line_length);
-	} else {
-		m = (info->var.bits_per_pixel + 7) / 8;
-		cirrusfb_BitBLT(cinfo->regbase, info->var.bits_per_pixel,
-				area->sx * m, area->sy,
-				area->dx * m, area->dy,
-				area->width * m, area->height,
-				cinfo->currentmode.line_length);
-	}
-	return;
+	cirrusfb_RectFill(cinfo->regbase,
+			  info->var.bits_per_pixel,
+			  (region->dx * m) / 8, region->dy,
+			  (region->width * m) / 8, region->height,
+			  color,
+			  cinfo->currentmode.line_length);
 }
 
 static void cirrusfb_copyarea(struct fb_info *info,
@@ -2224,13 +2089,8 @@ static void cirrusfb_copyarea(struct fb_
 {
 	struct fb_copyarea modded;
 	u32 vxres, vyres;
-
-	modded.sx = area->sx;
-	modded.sy = area->sy;
-	modded.dx = area->dx;
-	modded.dy = area->dy;
-	modded.width  = area->width;
-	modded.height = area->height;
+	struct cirrusfb_info *cinfo = info->par;
+	int m = info->var.bits_per_pixel;
 
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
@@ -2241,6 +2101,7 @@ static void cirrusfb_copyarea(struct fb_
 
 	vxres = info->var.xres_virtual;
 	vyres = info->var.yres_virtual;
+	memcpy(&modded, area, sizeof(struct fb_copyarea));
 
 	if (!modded.width || !modded.height ||
 	   modded.sx >= vxres || modded.sy >= vyres ||
@@ -2256,7 +2117,12 @@ static void cirrusfb_copyarea(struct fb_
 	if (modded.dy + modded.height > vyres)
 		modded.height = vyres - modded.dy;
 
-	cirrusfb_prim_copyarea(info, &modded);
+	cirrusfb_BitBLT(cinfo->regbase, info->var.bits_per_pixel,
+			(area->sx * m) / 8, area->sy,
+			(area->dx * m) / 8, area->dy,
+			(area->width * m) / 8, area->height,
+			cinfo->currentmode.line_length);
+
 }
 
 static void cirrusfb_imageblit(struct fb_info *info,
@@ -2366,7 +2232,6 @@ static void cirrusfb_pci_unmap(struct fb
 	if (release_io_ports)
 		release_region(0x3C0, 32);
 	pci_release_regions(pdev);
-	framebuffer_release(info);
 }
 #endif /* CONFIG_PCI */
 
@@ -2383,7 +2248,6 @@ static void __devexit cirrusfb_zorro_unm
 		if (zorro_resource_start(cinfo->zdev) > 0x01000000)
 			iounmap(info->screen_base);
 	}
-	framebuffer_release(cinfo->info);
 }
 #endif /* CONFIG_ZORRO */
 
@@ -2481,6 +2345,7 @@ err_dealloc_cmap:
 	fb_dealloc_cmap(&info->cmap);
 err_unmap_cirrusfb:
 	cinfo->unmap(info);
+	framebuffer_release(info);
 	return err;
 }
 
@@ -2495,6 +2360,7 @@ static void __devexit cirrusfb_cleanup(s
 	fb_dealloc_cmap(&info->cmap);
 	printk("Framebuffer unregistered\n");
 	cinfo->unmap(info);
+	framebuffer_release(info);
 
 	DPRINTK("EXIT\n");
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
git-arm-master.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
