From: akpm@linux-foundation.org
Subject: - tridentfb-add-imageblit-acceleration-for-blade3d-family.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:31:35 -0700
Message-ID: <200807242331.m6ONVZAp011646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756743AbYGXXbh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:31:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: add imageblit acceleration for Blade3D family
has been removed from the -mm tree.  Its filename was
     tridentfb-add-imageblit-acceleration-for-blade3d-family.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: add imageblit acceleration for Blade3D family
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add imageblit acceleration for the Blade3D family of cores.  The code is
based on code from the cyblafb driver.

It is a step toward assimilating back the cyblafb driver into the
tridentfb driver.  The cyblafb driver handles a subfamily of the Trident
Blade3d cores.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   79 ++++++++++++++++++++++++++++++++++--
 include/video/trident.h   |    1 
 2 files changed, 77 insertions(+), 3 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-add-imageblit-acceleration-for-blade3d-family drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-add-imageblit-acceleration-for-blade3d-family
+++ a/drivers/video/tridentfb.c
@@ -35,11 +35,12 @@ struct tridentfb_par {
 		(struct tridentfb_par *par, u32, u32, u32, u32, u32, u32);
 	void (*copy_rect)
 		(struct tridentfb_par *par, u32, u32, u32, u32, u32, u32);
+	void (*image_blit)
+		(struct tridentfb_par *par, const char*,
+		 u32, u32, u32, u32, u32, u32);
 	unsigned char eng_oper;	/* engine operation... */
 };
 
-static struct fb_ops tridentfb_ops;
-
 static struct fb_fix_screeninfo tridentfb_fix = {
 	.id = "Trident",
 	.type = FB_TYPE_PACKED_PIXELS,
@@ -212,6 +213,21 @@ static void blade_fill_rect(struct tride
 	writemmr(par, DST2, point(x + w - 1, y + h - 1));
 }
 
+static void blade_image_blit(struct tridentfb_par *par, const char *data,
+			     u32 x, u32 y, u32 w, u32 h, u32 c, u32 b)
+{
+	unsigned size = ((w + 31) >> 5) * h;
+
+	writemmr(par, COLOR, c);
+	writemmr(par, BGCOLOR, b);
+	writemmr(par, CMD, 0xa0000000 | 3 << 19);
+
+	writemmr(par, DST1, point(x, y));
+	writemmr(par, DST2, point(x + w - 1, y + h - 1));
+
+	memcpy(par->io_virt + 0x10000, data, 4 * size);
+}
+
 static void blade_copy_rect(struct tridentfb_par *par,
 			    u32 x1, u32 y1, u32 x2, u32 y2, u32 w, u32 h)
 {
@@ -497,6 +513,36 @@ static void tridentfb_fillrect(struct fb
 		       fr->height, col, fr->rop);
 }
 
+static void tridentfb_imageblit(struct fb_info *info,
+				const struct fb_image *img)
+{
+	struct tridentfb_par *par = info->par;
+	int col, bgcol;
+
+	if ((info->flags & FBINFO_HWACCEL_DISABLED) || img->depth != 1) {
+		cfb_imageblit(info, img);
+		return;
+	}
+	if (info->var.bits_per_pixel == 8) {
+		col = img->fg_color;
+		col |= col << 8;
+		col |= col << 16;
+		bgcol = img->bg_color;
+		bgcol |= bgcol << 8;
+		bgcol |= bgcol << 16;
+	} else {
+		col = ((u32 *)(info->pseudo_palette))[img->fg_color];
+		bgcol = ((u32 *)(info->pseudo_palette))[img->bg_color];
+	}
+
+	par->wait_engine(par);
+	if (par->image_blit)
+		par->image_blit(par, img->data, img->dx, img->dy,
+				img->width, img->height, col, bgcol);
+	else
+		cfb_imageblit(info, img);
+}
+
 static void tridentfb_copyarea(struct fb_info *info,
 			       const struct fb_copyarea *ca)
 {
@@ -522,6 +568,7 @@ static int tridentfb_sync(struct fb_info
 #else
 #define tridentfb_fillrect cfb_fillrect
 #define tridentfb_copyarea cfb_copyarea
+#define tridentfb_imageblit cfb_imageblit
 #endif /* CONFIG_FB_TRIDENT_ACCEL */
 
 /*
@@ -1285,7 +1332,7 @@ static struct fb_ops tridentfb_ops = {
 	.fb_set_par = tridentfb_set_par,
 	.fb_fillrect = tridentfb_fillrect,
 	.fb_copyarea = tridentfb_copyarea,
-	.fb_imageblit = cfb_imageblit,
+	.fb_imageblit = tridentfb_imageblit,
 #ifdef CONFIG_FB_TRIDENT_ACCEL
 	.fb_sync = tridentfb_sync,
 #endif
@@ -1369,6 +1416,7 @@ static int __devinit trident_pci_probe(s
 		default_par->wait_engine = blade_wait_engine;
 		default_par->fill_rect = blade_fill_rect;
 		default_par->copy_rect = blade_copy_rect;
+		default_par->image_blit = blade_image_blit;
 		tridentfb_fix.accel = FB_ACCEL_TRIDENT_BLADE3D;
 	} else if (chip3D) {			/* 3DImage family left */
 		default_par->init_accel = image_init_accel;
@@ -1446,6 +1494,29 @@ static int __devinit trident_pci_probe(s
 	} else
 		info->flags |= FBINFO_HWACCEL_DISABLED;
 
+	info->pixmap.addr = kmalloc(4096, GFP_KERNEL);
+	if (!info->pixmap.addr) {
+		err = -ENOMEM;
+		goto out_unmap2;
+	}
+
+	info->pixmap.size = 4096;
+	info->pixmap.buf_align = 4;
+	info->pixmap.scan_align = 1;
+	info->pixmap.access_align = 32;
+	info->pixmap.flags = FB_PIXMAP_SYSTEM;
+
+	if (default_par->image_blit) {
+		info->flags |= FBINFO_HWACCEL_IMAGEBLIT;
+		info->pixmap.scan_align = 4;
+	}
+
+	if (noaccel) {
+		printk(KERN_DEBUG "disabling acceleration\n");
+		info->flags |= FBINFO_HWACCEL_DISABLED;
+		info->pixmap.scan_align = 1;
+	}
+
 	if (!fb_find_mode(&info->var, info,
 			  mode_option, NULL, 0, NULL, bpp)) {
 		err = -EINVAL;
@@ -1471,6 +1542,7 @@ static int __devinit trident_pci_probe(s
 	return 0;
 
 out_unmap2:
+	kfree(info->pixmap.addr);
 	if (info->screen_base)
 		iounmap(info->screen_base);
 	release_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len);
@@ -1494,6 +1566,7 @@ static void __devexit trident_pci_remove
 	release_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len);
 	release_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len);
 	pci_set_drvdata(dev, NULL);
+	kfree(info->pixmap.addr);
 	framebuffer_release(info);
 }
 
diff -puN include/video/trident.h~tridentfb-add-imageblit-acceleration-for-blade3d-family include/video/trident.h
--- a/include/video/trident.h~tridentfb-add-imageblit-acceleration-for-blade3d-family
+++ a/include/video/trident.h
@@ -135,6 +135,7 @@
 #define CMD	0x2144
 #define ROP	0x2148
 #define COLOR	0x2160
+#define BGCOLOR	0x2164
 #define SRC1	0x2100
 #define SRC2	0x2104
 #define DST1	0x2108
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

