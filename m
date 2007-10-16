From: akpm@linux-foundation.org
Subject: - pm3fb-imageblit-improved.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:42:00 -0700
Message-ID: <200710162042.l9GKg0E8015838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60389 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbXJPVIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm3fb: imageblit improved
has been removed from the -mm tree.  Its filename was
     pm3fb-imageblit-improved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm3fb: imageblit improved
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch removes the pm3_imageblit() restriction to blit only images with
width divisable by 32.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-imageblit-improved drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-imageblit-improved
+++ a/drivers/video/pm3fb.c
@@ -46,6 +46,8 @@
 #define DPRINTK(a,b...)
 #endif
 
+#define PM3_PIXMAP_SIZE	(2048 * 4)
+
 /*
  * Driver data
  */
@@ -513,7 +515,7 @@ static void pm3fb_imageblit(struct fb_in
 			bgx = par->palette[image->bg_color];
 			break;
 	}
-	if (image->depth != 1 || (image->width & 0x1f)) {
+	if (image->depth != 1) {
 		return cfb_imageblit(info, image);
 	}
 	if (info->var.bits_per_pixel == 8) {
@@ -525,18 +527,24 @@ static void pm3fb_imageblit(struct fb_in
 		bgx |= bgx << 16;
 	}
 
-	PM3_WAIT(par, 5);
+	PM3_WAIT(par, 7);
 
 	PM3_WRITE_REG(par, PM3ForegroundColor, fgx);
 	PM3_WRITE_REG(par, PM3BackgroundColor, bgx);
 
 	/* ROP Ox3 is GXcopy */
 	PM3_WRITE_REG(par, PM3Config2D,
+			PM3Config2D_UserScissorEnable |
 			PM3Config2D_UseConstantSource |
 			PM3Config2D_ForegroundROPEnable |
 			(PM3Config2D_ForegroundROP(0x3)) |
 			PM3Config2D_OpaqueSpan |
 			PM3Config2D_FBWriteEnable);
+	PM3_WRITE_REG(par, PM3ScissorMinXY,
+			((image->dy & 0x0fff) << 16) | (image->dx & 0x0fff));
+	PM3_WRITE_REG(par, PM3ScissorMaxXY,
+			(((image->dy + image->height) & 0x0fff) << 16) |
+			((image->dx + image->width) & 0x0fff));
 	PM3_WRITE_REG(par, PM3RectanglePosition,
 			(PM3RectanglePosition_XOffset(image->dx)) |
 			(PM3RectanglePosition_YOffset(image->dy)));
@@ -550,7 +558,8 @@ static void pm3fb_imageblit(struct fb_in
 
 
 	while (height--) {
-		u32 width = (image->width + 31) >> 5;
+		int width = ((image->width + 7) >> 3) + info->pixmap.scan_align;
+		width >>= 2;
 
 		while (width >= PM3_FIFO_SIZE) {
 			int i = PM3_FIFO_SIZE - 1;
@@ -1239,6 +1248,17 @@ static int __devinit pm3fb_probe(struct 
 			FBINFO_HWACCEL_IMAGEBLIT |
 			FBINFO_HWACCEL_FILLRECT;
 
+	info->pixmap.addr = kmalloc(PM3_PIXMAP_SIZE, GFP_KERNEL);
+	if (!info->pixmap.addr) {
+		retval = -ENOMEM;
+		goto err_exit_pixmap;
+	}
+	info->pixmap.size = PM3_PIXMAP_SIZE;
+	info->pixmap.buf_align = 4;
+	info->pixmap.scan_align = 4;
+	info->pixmap.access_align = 32;
+	info->pixmap.flags = FB_PIXMAP_SYSTEM;
+
 	/*
 	 * This should give a reasonable default video mode. The following is
 	 * done when we can set a video mode.
@@ -1275,6 +1295,8 @@ static int __devinit pm3fb_probe(struct 
  err_exit_all:
 	fb_dealloc_cmap(&info->cmap);
  err_exit_both:
+	kfree(info->pixmap.addr);
+ err_exit_pixmap:
 	iounmap(info->screen_base);
 	release_mem_region(pm3fb_fix.smem_start, pm3fb_fix.smem_len);
  err_exit_mmio:
@@ -1305,6 +1327,7 @@ static void __devexit pm3fb_remove(struc
 		release_mem_region(fix->mmio_start, fix->mmio_len);
 
 		pci_set_drvdata(dev, NULL);
+		kfree(info->pixmap.addr);
 		framebuffer_release(info);
 	}
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
