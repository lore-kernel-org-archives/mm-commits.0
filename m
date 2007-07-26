From: akpm@linux-foundation.org
Subject: + pm2fb-accelerated-imageblit.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:34 -0700
Message-ID: <200707261900.l6QJ0YL5015642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764507AbXGZTMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: accelerated imageblit
has been added to the -mm tree.  Its filename is
     pm2fb-accelerated-imageblit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: accelerated imageblit
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds accelerated imageblit function.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c     |  123 +++++++++++++++++++++++++++++++++++-
 include/video/permedia2.h |    7 ++
 2 files changed, 127 insertions(+), 3 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-accelerated-imageblit drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-accelerated-imageblit
+++ a/drivers/video/pm2fb.c
@@ -60,6 +60,8 @@
 #define DPRINTK(a,b...)
 #endif
 
+#define PM2_PIXMAP_SIZE	(1600 * 4)
+
 /*
  * Driver data
  */
@@ -1166,6 +1168,104 @@ static void pm2fb_copyarea(struct fb_inf
 			modded.width, modded.height, 0);
 }
 
+static void pm2fb_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	struct pm2fb_par *par = info->par;
+	u32 height = image->height;
+	u32 fgx, bgx;
+	const u32 *src = (const u32*)image->data;
+	u32 xres = (info->var.xres + 31) & ~31;
+
+	if (info->state != FBINFO_STATE_RUNNING)
+		return;
+	if (info->flags & FBINFO_HWACCEL_DISABLED || image->depth != 1) {
+		cfb_imageblit(info, image);
+		return;
+	}
+	switch (info->fix.visual) {
+		case FB_VISUAL_PSEUDOCOLOR:
+			fgx = image->fg_color;
+			bgx = image->bg_color;
+			break;
+		case FB_VISUAL_TRUECOLOR:
+		default:
+			fgx = par->palette[image->fg_color];
+			bgx = par->palette[image->bg_color];
+			break;
+	}
+	if (info->var.bits_per_pixel == 8) {
+		fgx |= fgx << 8;
+		bgx |= bgx << 8;
+	}
+	if (info->var.bits_per_pixel <= 16) {
+		fgx |= fgx << 16;
+		bgx |= bgx << 16;
+	}
+
+	WAIT_FIFO(par, 13);
+	pm2_WR(par, PM2R_FB_READ_MODE, partprod(xres));
+	pm2_WR(par, PM2R_SCISSOR_MIN_XY,
+			((image->dy & 0xfff) << 16) | (image->dx & 0x0fff));
+	pm2_WR(par, PM2R_SCISSOR_MAX_XY,
+			(((image->dy + image->height) & 0x0fff) << 16) |
+			((image->dx + image->width) & 0x0fff));
+	pm2_WR(par, PM2R_SCISSOR_MODE, 1);
+	/* GXcopy & UNIT_ENABLE */
+	pm2_WR(par, PM2R_LOGICAL_OP_MODE, (0x3 << 1) | 1 );
+	pm2_WR(par, PM2R_RECTANGLE_ORIGIN,
+			((image->dy & 0xfff) << 16) | (image->dx & 0x0fff));
+	pm2_WR(par, PM2R_RECTANGLE_SIZE,
+			((image->height & 0x0fff) << 16) |
+			((image->width) & 0x0fff));
+	if (info->var.bits_per_pixel == 24) {
+		pm2_WR(par, PM2R_COLOR_DDA_MODE, 1);
+		/* clear area */
+		pm2_WR(par, PM2R_CONSTANT_COLOR, bgx);
+		pm2_WR(par, PM2R_RENDER,
+			PM2F_RENDER_RECTANGLE |
+			PM2F_INCREASE_X | PM2F_INCREASE_Y );
+		/* BitMapPackEachScanline & invert bits and byte order*/
+		/* force background */
+		pm2_WR(par, PM2R_RASTERIZER_MODE,  (1<<9) | 1 | (3<<7));
+		pm2_WR(par, PM2R_CONSTANT_COLOR, fgx);
+		pm2_WR(par, PM2R_RENDER,
+			PM2F_RENDER_RECTANGLE |
+			PM2F_INCREASE_X | PM2F_INCREASE_Y |
+			PM2F_RENDER_SYNC_ON_BIT_MASK);
+	} else {
+		pm2_WR(par, PM2R_COLOR_DDA_MODE, 0);
+		/* clear area */
+		pm2_WR(par, PM2R_FB_BLOCK_COLOR, bgx);
+		pm2_WR(par, PM2R_RENDER,
+			PM2F_RENDER_RECTANGLE |
+			PM2F_RENDER_FASTFILL |
+			PM2F_INCREASE_X | PM2F_INCREASE_Y );
+		/* invert bits and byte order*/
+		pm2_WR(par, PM2R_RASTERIZER_MODE,  1 | (3<<7) );
+		pm2_WR(par, PM2R_FB_BLOCK_COLOR, fgx);
+		pm2_WR(par, PM2R_RENDER,
+			PM2F_RENDER_RECTANGLE |
+			PM2F_INCREASE_X | PM2F_INCREASE_Y |
+			PM2F_RENDER_FASTFILL |
+			PM2F_RENDER_SYNC_ON_BIT_MASK);
+	}
+
+	while (height--) {
+		int width = ((image->width + 7) >> 3)
+				+ info->pixmap.scan_align - 1;
+		width >>= 2;
+		WAIT_FIFO(par, width);
+		while (width--) {
+			pm2_WR(par, PM2R_BIT_MASK_PATTERN, *src);
+			src++;
+		}
+	}
+	WAIT_FIFO(par, 3);
+	pm2_WR(par, PM2R_RASTERIZER_MODE, 0);
+	pm2_WR(par, PM2R_COLOR_DDA_MODE, 0);
+	pm2_WR(par, PM2R_SCISSOR_MODE, 0);
+}
+
 /* ------------ Hardware Independent Functions ------------ */
 
 /*
@@ -1181,7 +1281,7 @@ static struct fb_ops pm2fb_ops = {
 	.fb_pan_display	= pm2fb_pan_display,
 	.fb_fillrect	= pm2fb_fillrect,
 	.fb_copyarea	= pm2fb_copyarea,
-	.fb_imageblit	= cfb_imageblit,
+	.fb_imageblit	= pm2fb_imageblit,
 	.fb_sync	= pm2fb_sync,
 };
 
@@ -1340,11 +1440,24 @@ static int __devinit pm2fb_probe(struct 
 	info->flags		= FBINFO_DEFAULT |
 				  FBINFO_HWACCEL_YPAN |
 				  FBINFO_HWACCEL_COPYAREA |
+				  FBINFO_HWACCEL_IMAGEBLIT |
 				  FBINFO_HWACCEL_FILLRECT;
 
+	info->pixmap.addr = kmalloc(PM2_PIXMAP_SIZE, GFP_KERNEL);
+	if (!info->pixmap.addr) {
+		err_retval = -ENOMEM;
+		goto err_exit_pixmap;
+	}
+	info->pixmap.size = PM2_PIXMAP_SIZE;
+	info->pixmap.buf_align = 4;
+	info->pixmap.scan_align = 4;
+	info->pixmap.access_align = 32;
+	info->pixmap.flags = FB_PIXMAP_SYSTEM;
+
 	if (noaccel) {
-	    	printk(KERN_DEBUG "disabling acceleration\n");
-  		info->flags |= FBINFO_HWACCEL_DISABLED;
+		printk(KERN_DEBUG "disabling acceleration\n");
+		info->flags |= FBINFO_HWACCEL_DISABLED;
+		info->pixmap.scan_align = 1;
 	}
 
 	if (!mode)
@@ -1373,6 +1486,8 @@ static int __devinit pm2fb_probe(struct 
  err_exit_all:
 	fb_dealloc_cmap(&info->cmap);
  err_exit_both:
+	kfree(info->pixmap.addr);
+ err_exit_pixmap:
 	iounmap(info->screen_base);
 	release_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
  err_exit_mmio:
@@ -1409,6 +1524,8 @@ static void __devexit pm2fb_remove(struc
 	release_mem_region(fix->mmio_start, fix->mmio_len);
 
 	pci_set_drvdata(pdev, NULL);
+	if (info->pixmap.addr)
+		kfree(info->pixmap.addr);
 	kfree(info);
 }
 
diff -puN include/video/permedia2.h~pm2fb-accelerated-imageblit include/video/permedia2.h
--- a/include/video/permedia2.h~pm2fb-accelerated-imageblit
+++ a/include/video/permedia2.h
@@ -68,11 +68,14 @@
 #define PM2R_D_Y					0x8028
 #define PM2R_COUNT					0x8030
 #define PM2R_RENDER					0x8038
+#define PM2R_BIT_MASK_PATTERN				0x8068
 #define PM2R_RASTERIZER_MODE				0x80a0
 #define PM2R_RECTANGLE_ORIGIN				0x80d0
 #define PM2R_RECTANGLE_SIZE				0x80d8
 #define PM2R_PACKED_DATA_LIMITS				0x8150
 #define PM2R_SCISSOR_MODE				0x8180
+#define PM2R_SCISSOR_MIN_XY				0x8188
+#define PM2R_SCISSOR_MAX_XY				0x8190
 #define PM2R_SCREEN_SIZE				0x8198
 #define PM2R_AREA_STIPPLE_MODE				0x81a0
 #define PM2R_WINDOW_ORIGIN				0x81c8
@@ -83,7 +86,9 @@
 #define PM2R_TEXEL_LUT_MODE				0x8678
 #define PM2R_TEXTURE_COLOR_MODE				0x8680
 #define PM2R_FOG_MODE					0x8690
+#define PM2R_TEXEL0					0x8760
 #define PM2R_COLOR_DDA_MODE				0x87e0
+#define PM2R_CONSTANT_COLOR				0x87e8
 #define PM2R_ALPHA_BLEND_MODE				0x8810
 #define PM2R_DITHER_MODE				0x8818
 #define PM2R_FB_SOFT_WRITE_MASK				0x8820
@@ -169,6 +174,8 @@
 #define PM2F_RENDER_TRAPEZOID				(1L<<6)
 #define PM2F_RENDER_POINT				(2L<<6)
 #define PM2F_RENDER_RECTANGLE				(3L<<6)
+#define PM2F_RENDER_SYNC_ON_BIT_MASK			(1L<<11)
+#define PM2F_RENDER_TEXTURE_ENABLE			(1L<<13)
 #define PM2F_SYNCHRONIZATION				(1L<<10)
 #define PM2F_PLL_LOCKED					0x10
 #define PM2F_BEING_RESET				(1L<<31)
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
