From: akpm@linux-foundation.org
Subject: + tdfxfb-3-fixes.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:54 -0700
Message-ID: <200707261900.l6QJ0sgU015683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764619AbXGZTMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:12:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     tdfxfb: 3 fixes
has been added to the -mm tree.  Its filename is
     tdfxfb-3-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tdfxfb: 3 fixes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes 3 issues:
- transparency handling in tdfxfb
- panning with more than 4096 virtual height and acceleration (acceleration
with x & y > 4096)
- exit paths on errors in tdfxfb_probe()

Additionally it sets a FBINFO_READS_FAST flag to use smart blitter scrolling
(speed up on tdfxfb).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |  172 ++++++++++++++++++++++++---------------
 1 file changed, 108 insertions(+), 64 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-3-fixes drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-3-fixes
+++ a/drivers/video/tdfxfb.c
@@ -502,6 +502,8 @@ static int tdfxfb_check_var(struct fb_va
 		return -EINVAL;
 	}
 
+	var->transp.offset = 0;
+	var->transp.length = 0;
 	switch (var->bits_per_pixel) {
 	case 8:
 		var->red.length = var->green.length = var->blue.length = 8;
@@ -515,10 +517,12 @@ static int tdfxfb_check_var(struct fb_va
 		var->blue.length  = 5;
 		break;
 	case 32:
+		var->transp.offset = 24;
+		var->transp.length = 8;
 	case 24:
-		var->red.offset=16;
-		var->green.offset=8;
-		var->blue.offset=0;
+		var->red.offset = 16;
+		var->green.offset = 8;
+		var->blue.offset = 0;
 		var->red.length = var->green.length = var->blue.length = 8;
 		break;
 	}
@@ -874,13 +878,26 @@ static void tdfxfb_fillrect(struct fb_in
 	u32 stride = info->fix.line_length;
 	u32 fmt= stride | ((bpp + ((bpp == 8) ? 0 : 8)) << 13);
 	int tdfx_rop;
+	u32 dx = rect->dx;
+	u32 dy = rect->dy;
+	u32 dstbase = 0;
 
 	if (rect->rop == ROP_COPY)
 		tdfx_rop = TDFX_ROP_COPY;
 	else
 		tdfx_rop = TDFX_ROP_XOR;
 
-	banshee_make_room(par, 5);
+	/* asume always rect->height < 4096 */
+	if (dy + rect->height > 4095) {
+		dstbase = stride * dy;
+		dy = 0;
+	}
+	/* asume always rect->width < 4096 */
+	if (dx + rect->width > 4095) {
+		dstbase += dx * bpp >> 3;
+		dx = 0;
+	}
+	banshee_make_room(par, 6);
 	tdfx_outl(par, DSTFORMAT, fmt);
 	if (info->fix.visual == FB_VISUAL_PSEUDOCOLOR) {
 		tdfx_outl(par, COLORFORE, rect->color);
@@ -888,8 +905,9 @@ static void tdfxfb_fillrect(struct fb_in
 		tdfx_outl(par, COLORFORE, par->palette[rect->color]);
 	}
 	tdfx_outl(par, COMMAND_2D, COMMAND_2D_FILLRECT | (tdfx_rop << 24));
+	tdfx_outl(par, DSTBASE, dstbase);
 	tdfx_outl(par, DSTSIZE, rect->width | (rect->height << 16));
-	tdfx_outl(par, LAUNCH_2D, rect->dx | (rect->dy << 16));
+	tdfx_outl(par, LAUNCH_2D, dx | (dy << 16));
 }
 
 /*
@@ -904,6 +922,30 @@ static void tdfxfb_copyarea(struct fb_in
 	u32 stride = info->fix.line_length;
 	u32 blitcmd = COMMAND_2D_S2S_BITBLT | (TDFX_ROP_COPY << 24);
 	u32 fmt = stride | ((bpp + ((bpp == 8) ? 0 : 8)) << 13);
+	u32 dstbase = 0;
+	u32 srcbase = 0;
+
+	/* asume always area->height < 4096 */
+	if (sy + area->height > 4095) {
+		srcbase = stride * sy;
+		sy = 0;
+	}
+	/* asume always area->width < 4096 */
+	if (sx + area->width > 4095) {
+		srcbase += sx * bpp >> 3;
+		sx = 0;
+	}
+	/* asume always area->height < 4096 */
+	if (dy + area->height > 4095) {
+		dstbase = stride * dy;
+		dy = 0;
+	}
+	/* asume always area->width < 4096 */
+	if (dx + area->width > 4095) {
+		dstbase += dx * bpp >> 3;
+		dx = 0;
+	}
+
 
 	if (area->sx <= area->dx) {
 		//-X
@@ -918,13 +960,15 @@ static void tdfxfb_copyarea(struct fb_in
 		dy += area->height - 1;
 	}
 
-	banshee_make_room(par, 6);
+	banshee_make_room(par, 8);
 
 	tdfx_outl(par, SRCFORMAT, fmt);
 	tdfx_outl(par, DSTFORMAT, fmt);
 	tdfx_outl(par, COMMAND_2D, blitcmd);
 	tdfx_outl(par, DSTSIZE, area->width | (area->height << 16));
 	tdfx_outl(par, DSTXY, dx | (dy << 16));
+	tdfx_outl(par, SRCBASE, srcbase);
+	tdfx_outl(par, DSTBASE, dstbase);
 	tdfx_outl(par, LAUNCH_2D, sx | (sy << 16));
 }
 
@@ -938,35 +982,48 @@ static void tdfxfb_imageblit(struct fb_i
 	u32 dstfmt = stride | ((bpp + ((bpp == 8) ? 0 : 8)) << 13);
 	u8 *chardata = (u8 *) image->data;
 	u32 srcfmt;
+	u32 dx = image->dx;
+	u32 dy = image->dy;
+	u32 dstbase = 0;
 
 	if (image->depth != 1) {
 		//banshee_make_room(par, 6 + ((size + 3) >> 2));
 		//srcfmt = stride | ((bpp+((bpp==8) ? 0 : 8)) << 13) | 0x400000;
 		cfb_imageblit(info, image);
 		return;
-	} else {
-		banshee_make_room(par, 8);
-		switch (info->fix.visual) {
-		case FB_VISUAL_PSEUDOCOLOR:
-			tdfx_outl(par, COLORFORE, image->fg_color);
-			tdfx_outl(par, COLORBACK, image->bg_color);
-			break;
-		case FB_VISUAL_TRUECOLOR:
-		default:
-			tdfx_outl(par, COLORFORE,
-				  par->palette[image->fg_color]);
-			tdfx_outl(par, COLORBACK,
-				  par->palette[image->bg_color]);
-		}
+	}
+	banshee_make_room(par, 9);
+	switch (info->fix.visual) {
+	case FB_VISUAL_PSEUDOCOLOR:
+		tdfx_outl(par, COLORFORE, image->fg_color);
+		tdfx_outl(par, COLORBACK, image->bg_color);
+		break;
+	case FB_VISUAL_TRUECOLOR:
+	default:
+		tdfx_outl(par, COLORFORE,
+			  par->palette[image->fg_color]);
+		tdfx_outl(par, COLORBACK,
+			  par->palette[image->bg_color]);
+	}
 #ifdef __BIG_ENDIAN
-		srcfmt = 0x400000 | BIT(20);
+	srcfmt = 0x400000 | BIT(20);
 #else
-		srcfmt = 0x400000;
+	srcfmt = 0x400000;
 #endif
+	/* asume always image->height < 4096 */
+	if (dy + image->height > 4095) {
+		dstbase = stride * dy;
+		dy = 0;
+	}
+	/* asume always image->width < 4096 */
+	if (dx + image->width > 4095) {
+		dstbase += dx * bpp >> 3;
+		dx = 0;
 	}
 
+	tdfx_outl(par, DSTBASE, dstbase);
 	tdfx_outl(par, SRCXY, 0);
-	tdfx_outl(par, DSTXY, image->dx | (image->dy << 16));
+	tdfx_outl(par, DSTXY, dx | (dy << 16));
 	tdfx_outl(par, COMMAND_2D, COMMAND_2D_H2S_BITBLT | (TDFX_ROP_COPY << 24));
 	tdfx_outl(par, SRCFORMAT, srcfmt);
 	tdfx_outl(par, DSTFORMAT, dstfmt);
@@ -1211,44 +1268,36 @@ static int __devinit tdfxfb_probe(struct
 
 	tdfx_fix.mmio_start = pci_resource_start(pdev, 0);
 	tdfx_fix.mmio_len = pci_resource_len(pdev, 0);
+	if (!request_mem_region(tdfx_fix.mmio_start, tdfx_fix.mmio_len,
+				"tdfx regbase")) {
+		printk(KERN_WARNING "tdfxfb: Can't reserve regbase\n");
+		goto out_err;
+	}
+
 	default_par->regbase_virt =
 		ioremap_nocache(tdfx_fix.mmio_start, tdfx_fix.mmio_len);
 	if (!default_par->regbase_virt) {
 		printk("fb: Can't remap %s register area.\n", tdfx_fix.id);
-		goto out_err;
-	}
-
-	if (!request_mem_region(pci_resource_start(pdev, 0),
-				pci_resource_len(pdev, 0), "tdfx regbase")) {
-		printk(KERN_WARNING "tdfxfb: Can't reserve regbase\n");
-		goto out_err;
+		goto out_err_regbase;
 	}
 
 	tdfx_fix.smem_start = pci_resource_start(pdev, 1);
 	if (!(tdfx_fix.smem_len = do_lfb_size(default_par, pdev->device))) {
 		printk("fb: Can't count %s memory.\n", tdfx_fix.id);
-		release_mem_region(pci_resource_start(pdev, 0),
-				   pci_resource_len(pdev, 0));
-		goto out_err;
+		goto out_err_regbase;
 	}
 
-	if (!request_mem_region(pci_resource_start(pdev, 1),
+	if (!request_mem_region(tdfx_fix.smem_start,
 				pci_resource_len(pdev, 1), "tdfx smem")) {
 		printk(KERN_WARNING "tdfxfb: Can't reserve smem\n");
-		release_mem_region(pci_resource_start(pdev, 0),
-				   pci_resource_len(pdev, 0));
-		goto out_err;
+		goto out_err_regbase;
 	}
 
 	info->screen_base = ioremap_nocache(tdfx_fix.smem_start,
 					    tdfx_fix.smem_len);
 	if (!info->screen_base) {
 		printk("fb: Can't remap %s framebuffer.\n", tdfx_fix.id);
-		release_mem_region(pci_resource_start(pdev, 1),
-				   pci_resource_len(pdev, 1));
-		release_mem_region(pci_resource_start(pdev, 0),
-				   pci_resource_len(pdev, 0));
-		goto out_err;
+		goto out_err_screenbase;
 	}
 
 	default_par->iobase = pci_resource_start(pdev, 2);
@@ -1256,11 +1305,7 @@ static int __devinit tdfxfb_probe(struct
 	if (!request_region(pci_resource_start(pdev, 2),
 			    pci_resource_len(pdev, 2), "tdfx iobase")) {
 		printk(KERN_WARNING "tdfxfb: Can't reserve iobase\n");
-		release_mem_region(pci_resource_start(pdev, 1),
-				   pci_resource_len(pdev, 1));
-		release_mem_region(pci_resource_start(pdev, 0),
-				   pci_resource_len(pdev, 0));
-		goto out_err;
+		goto out_err_screenbase;
 	}
 
 	printk("fb: %s memory = %dK\n", tdfx_fix.id, tdfx_fix.smem_len >> 10);
@@ -1274,7 +1319,9 @@ static int __devinit tdfxfb_probe(struct
 	info->flags		= FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
 #ifdef CONFIG_FB_3DFX_ACCEL
 	info->flags             |= FBINFO_HWACCEL_FILLRECT |
-		FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_IMAGEBLIT;
+				   FBINFO_HWACCEL_COPYAREA |
+				   FBINFO_HWACCEL_IMAGEBLIT |
+				   FBINFO_READS_FAST;
 #endif
 
 	if (!mode_option)
@@ -1288,27 +1335,17 @@ static int __devinit tdfxfb_probe(struct
 	lpitch = info->var.xres_virtual * ((info->var.bits_per_pixel + 7) >> 3);
 	info->var.yres_virtual = info->fix.smem_len / lpitch;
 	if (info->var.yres_virtual < info->var.yres)
-		goto out_err;
-
-#ifdef CONFIG_FB_3DFX_ACCEL
-	/*
-	 * FIXME: Limit var->yres_virtual to 4096 because of screen artifacts
-	 * during scrolling. This is only present if 2D acceleration is
-	 * enabled.
-	 */
-	if (info->var.yres_virtual > 4096)
-		info->var.yres_virtual = 4096;
-#endif /* CONFIG_FB_3DFX_ACCEL */
+		goto out_err_iobase;
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
 		printk(KERN_WARNING "tdfxfb: Can't allocate color map\n");
-		goto out_err;
+		goto out_err_iobase;
 	}
 
 	if (register_framebuffer(info) < 0) {
 		printk("tdfxfb: can't register framebuffer\n");
 		fb_dealloc_cmap(&info->cmap);
-		goto out_err;
+		goto out_err_iobase;
 	}
 	/*
 	 * Our driver data
@@ -1316,14 +1353,21 @@ static int __devinit tdfxfb_probe(struct
 	pci_set_drvdata(pdev, info);
 	return 0;
 
-out_err:
+out_err_iobase:
+	release_mem_region(pci_resource_start(pdev, 2),
+			   pci_resource_len(pdev, 2));
+out_err_screenbase:
+	if (info->screen_base)
+		iounmap(info->screen_base);
+	release_mem_region(tdfx_fix.smem_start, pci_resource_len(pdev, 1));
+out_err_regbase:
 	/*
 	 * Cleanup after anything that was remapped/allocated.
 	 */
 	if (default_par->regbase_virt)
 		iounmap(default_par->regbase_virt);
-	if (info->screen_base)
-		iounmap(info->screen_base);
+	release_mem_region(tdfx_fix.mmio_start, tdfx_fix.mmio_len);
+out_err:
 	framebuffer_release(info);
 	return -ENXIO;
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tdfxfb-coding-style-improvement.patch
tridentfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
