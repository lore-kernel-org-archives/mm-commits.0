From: akpm@linux-foundation.org
Subject: - s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:41 -0700
Message-ID: <200705090301.l4931fDY010737@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033214AbXEIDBn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     s3fb: limit 8x16 rectangles when tileblitting is enabled
has been removed from the -mm tree.  Its filename was
     s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3fb: limit 8x16 rectangles when tileblitting is enabled
From: "Antonino A. Daplas" <adaplas@gmail.com>

If tileblitting is enabled (text mode), the hardware can only accept 8x16
bitmaps. Advertise this to the upper layer. And to ensure that an appropriate
font is always available, select an 8x16 font in Kconfig.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    1 +
 drivers/video/s3fb.c  |    6 ++++++
 2 files changed, 7 insertions(+)

diff -puN drivers/video/Kconfig~s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled drivers/video/Kconfig
--- a/drivers/video/Kconfig~s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled
+++ a/drivers/video/Kconfig
@@ -1194,6 +1194,7 @@ config FB_S3
 	select FB_TILEBLITTING
 	select FB_SVGALIB
 	select VGASTATE
+	select FONT_8x16 if FRAMEBUFFER_CONSOLE
 	---help---
 	  Driver for graphics boards with S3 Trio / S3 Virge chip.
 
diff -puN drivers/video/s3fb.c~s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled
+++ a/drivers/video/s3fb.c
@@ -449,6 +449,9 @@ static int s3fb_set_par(struct fb_info *
 		info->flags &= ~FBINFO_MISC_TILEBLITTING;
 		info->tileops = NULL;
 
+		/* supports blit rectangles of any dimension */
+		info->pixmap.blit_x = ~(u32)0;
+		info->pixmap.blit_y = ~(u32)0;
 		offset_value = (info->var.xres_virtual * bpp) / 64;
 		screen_size = info->var.yres_virtual * info->fix.line_length;
 	} else {
@@ -457,6 +460,9 @@ static int s3fb_set_par(struct fb_info *
 
 		info->flags |= FBINFO_MISC_TILEBLITTING;
 		info->tileops = fasttext ? &s3fb_fast_tile_ops : &s3fb_tile_ops;
+		/* supports 8x16 tiles only */
+		info->pixmap.blit_x = 1 << (8 - 1);
+		info->pixmap.blit_y = 1 << (16 - 1);
 
 		offset_value = info->var.xres_virtual / 16;
 		screen_size = (info->var.xres_virtual * info->var.yres_virtual) / 64;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
