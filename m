From: akpm@linux-foundation.org
Subject: + s3fb-updates.patch added to -mm tree
Date: Mon, 07 May 2007 15:26:58 -0700
Message-ID: <200705072227.l47MQwqV006958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967024AbXEGW1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santiago@crfreenet.org, adaplas@gmail.com


The patch titled
     s3fb: updates
has been added to the -mm tree.  Its filename is
     s3fb-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s3fb: updates
From: Ondrej Zajicek <santiago@crfreenet.org>

Move s3fb_get_tilemax to svgalib.c as svga_get_tilemax, because it reports
limitation of other code from svgalib (svga_settile, svga_tilecopy, ...)

Limit font width to 8 pixels in 4 bpp mode.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c    |   15 ++++++---------
 drivers/video/svgalib.c |    6 ++++++
 include/linux/svga.h    |    1 +
 3 files changed, 13 insertions(+), 9 deletions(-)

diff -puN drivers/video/s3fb.c~s3fb-updates drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-updates
+++ a/drivers/video/s3fb.c
@@ -183,18 +183,13 @@ static void s3fb_settile_fast(struct fb_
 	}
 }
 
-static int s3fb_get_tilemax(struct fb_info *info)
-{
-	return 256;
-}
-
 static struct fb_tile_ops s3fb_tile_ops = {
 	.fb_settile	= svga_settile,
 	.fb_tilecopy	= svga_tilecopy,
 	.fb_tilefill    = svga_tilefill,
 	.fb_tileblit    = svga_tileblit,
 	.fb_tilecursor  = svga_tilecursor,
-	.fb_get_tilemax = s3fb_get_tilemax,
+	.fb_get_tilemax = svga_get_tilemax,
 };
 
 static struct fb_tile_ops s3fb_fast_tile_ops = {
@@ -203,7 +198,7 @@ static struct fb_tile_ops s3fb_fast_tile
 	.fb_tilefill    = svga_tilefill,
 	.fb_tileblit    = svga_tileblit,
 	.fb_tilecursor  = svga_tilecursor,
-	.fb_get_tilemax = s3fb_get_tilemax,
+	.fb_get_tilemax = svga_get_tilemax,
 };
 
 
@@ -459,9 +454,10 @@ static int s3fb_set_par(struct fb_info *
 		info->flags &= ~FBINFO_MISC_TILEBLITTING;
 		info->tileops = NULL;
 
-		/* supports blit rectangles of any dimension */
-		info->pixmap.blit_x = ~(u32)0;
+		/* in 4bpp supports 8p wide tiles only, any tiles otherwise */
+		info->pixmap.blit_x = (bpp == 4) ? (1 << (8 - 1)) : (~(u32)0);
 		info->pixmap.blit_y = ~(u32)0;
+
 		offset_value = (info->var.xres_virtual * bpp) / 64;
 		screen_size = info->var.yres_virtual * info->fix.line_length;
 	} else {
@@ -470,6 +466,7 @@ static int s3fb_set_par(struct fb_info *
 
 		info->flags |= FBINFO_MISC_TILEBLITTING;
 		info->tileops = fasttext ? &s3fb_fast_tile_ops : &s3fb_tile_ops;
+
 		/* supports 8x16 tiles only */
 		info->pixmap.blit_x = 1 << (8 - 1);
 		info->pixmap.blit_y = 1 << (16 - 1);
diff -puN drivers/video/svgalib.c~s3fb-updates drivers/video/svgalib.c
--- a/drivers/video/svgalib.c~s3fb-updates
+++ a/drivers/video/svgalib.c
@@ -342,6 +342,11 @@ void svga_tilecursor(struct fb_info *inf
 	vga_wcrt(NULL, 0x0A, cs); /* set cursor start and enable it */
 }
 
+int svga_get_tilemax(struct fb_info *info)
+{
+	return 256;
+}
+
 
 /* ------------------------------------------------------------------------- */
 
@@ -623,6 +628,7 @@ EXPORT_SYMBOL(svga_tilecopy);
 EXPORT_SYMBOL(svga_tilefill);
 EXPORT_SYMBOL(svga_tileblit);
 EXPORT_SYMBOL(svga_tilecursor);
+EXPORT_SYMBOL(svga_get_tilemax);
 
 EXPORT_SYMBOL(svga_compute_pll);
 EXPORT_SYMBOL(svga_check_timings);
diff -puN include/linux/svga.h~s3fb-updates include/linux/svga.h
--- a/include/linux/svga.h~s3fb-updates
+++ a/include/linux/svga.h
@@ -112,6 +112,7 @@ void svga_tilecopy(struct fb_info *info,
 void svga_tilefill(struct fb_info *info, struct fb_tilerect *rect);
 void svga_tileblit(struct fb_info *info, struct fb_tileblit *blit);
 void svga_tilecursor(struct fb_info *info, struct fb_tilecursor *cursor);
+int svga_get_tilemax(struct fb_info *info);
 
 int svga_compute_pll(const struct svga_pll *pll, u32 f_wanted, u16 *m, u16 *n, u16 *r, int node);
 int svga_check_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var, int node);
_

Patches currently in -mm which might be from santiago@crfreenet.org are

s3fb-driver-fixes.patch
vga-vgastate-fix.patch
s3fb-updates.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
