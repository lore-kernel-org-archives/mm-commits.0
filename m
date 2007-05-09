From: akpm@linux-foundation.org
Subject: - svgalib-move-fb_get_caps-to-svgalib.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:44 -0700
Message-ID: <200705092154.l49LsifD003191@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758403AbXEIVzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     svgalib: move fb_get_caps to svgalib
has been removed from the -mm tree.  Its filename was
     svgalib-move-fb_get_caps-to-svgalib.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: svgalib: move fb_get_caps to svgalib
From: "Antonino A. Daplas" <adaplas@gmail.com>

Move fb_get_caps() method to svgalib.c as svga_get_caps() so it can be used by
s3fb, arkfb and vt8623fb.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c    |    1 +
 drivers/video/s3fb.c     |   19 +------------------
 drivers/video/svgalib.c  |   17 +++++++++++++++++
 drivers/video/vt8623fb.c |    1 +
 include/linux/svga.h     |    2 ++
 5 files changed, 22 insertions(+), 18 deletions(-)

diff -puN drivers/video/arkfb.c~svgalib-move-fb_get_caps-to-svgalib drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~svgalib-move-fb_get_caps-to-svgalib
+++ a/drivers/video/arkfb.c
@@ -919,6 +919,7 @@ static struct fb_ops arkfb_ops = {
 	.fb_fillrect	= arkfb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
 	.fb_imageblit	= arkfb_imageblit,
+	.fb_get_caps    = svga_get_caps,
 };
 
 
diff -puN drivers/video/s3fb.c~svgalib-move-fb_get_caps-to-svgalib drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~svgalib-move-fb_get_caps-to-svgalib
+++ a/drivers/video/s3fb.c
@@ -796,23 +796,6 @@ static int s3fb_pan_display(struct fb_va
 	return 0;
 }
 
-/* Get capabilities of accelerator based on the mode */
-
-static void s3fb_get_caps(struct fb_info *info, struct fb_blit_caps *caps,
-			  struct fb_var_screeninfo *var)
-{
-	if (var->bits_per_pixel == 0) {
-		/* can only support 256 8x16 bitmap */
-		caps->x = 1 << (8 - 1);
-		caps->y = 1 << (16 - 1);
-		caps->len = 256;
-	} else {
-		caps->x = ~(u32)0;
-		caps->y = ~(u32)0;
-		caps->len = ~(u32)0;
-	}
-}
-
 /* ------------------------------------------------------------------------- */
 
 /* Frame buffer operations */
@@ -829,7 +812,7 @@ static struct fb_ops s3fb_ops = {
 	.fb_fillrect	= s3fb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
 	.fb_imageblit	= s3fb_imageblit,
-	.fb_get_caps    = s3fb_get_caps,
+	.fb_get_caps    = svga_get_caps,
 };
 
 /* ------------------------------------------------------------------------- */
diff -puN drivers/video/svgalib.c~svgalib-move-fb_get_caps-to-svgalib drivers/video/svgalib.c
--- a/drivers/video/svgalib.c~svgalib-move-fb_get_caps-to-svgalib
+++ a/drivers/video/svgalib.c
@@ -347,6 +347,23 @@ int svga_get_tilemax(struct fb_info *inf
 	return 256;
 }
 
+/* Get capabilities of accelerator based on the mode */
+
+void svga_get_caps(struct fb_info *info, struct fb_blit_caps *caps,
+		   struct fb_var_screeninfo *var)
+{
+	if (var->bits_per_pixel == 0) {
+		/* can only support 256 8x16 bitmap */
+		caps->x = 1 << (8 - 1);
+		caps->y = 1 << (16 - 1);
+		caps->len = 256;
+	} else {
+		caps->x = (var->bits_per_pixel == 4) ? 1 << (8 - 1) : ~(u32)0;
+		caps->y = ~(u32)0;
+		caps->len = ~(u32)0;
+	}
+}
+EXPORT_SYMBOL(svga_get_caps);
 
 /* ------------------------------------------------------------------------- */
 
diff -puN drivers/video/vt8623fb.c~svgalib-move-fb_get_caps-to-svgalib drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~svgalib-move-fb_get_caps-to-svgalib
+++ a/drivers/video/vt8623fb.c
@@ -635,6 +635,7 @@ static struct fb_ops vt8623fb_ops = {
 	.fb_fillrect	= vt8623fb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
 	.fb_imageblit	= vt8623fb_imageblit,
+	.fb_get_caps    = svga_get_caps,
 };
 
 
diff -puN include/linux/svga.h~svgalib-move-fb_get_caps-to-svgalib include/linux/svga.h
--- a/include/linux/svga.h~svgalib-move-fb_get_caps-to-svgalib
+++ a/include/linux/svga.h
@@ -113,6 +113,8 @@ void svga_tilefill(struct fb_info *info,
 void svga_tileblit(struct fb_info *info, struct fb_tileblit *blit);
 void svga_tilecursor(struct fb_info *info, struct fb_tilecursor *cursor);
 int svga_get_tilemax(struct fb_info *info);
+void svga_get_caps(struct fb_info *info, struct fb_blit_caps *caps,
+		   struct fb_var_screeninfo *var);
 
 int svga_compute_pll(const struct svga_pll *pll, u32 f_wanted, u16 *m, u16 *n, u16 *r, int node);
 int svga_check_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var, int node);
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
