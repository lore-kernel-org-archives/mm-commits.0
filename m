From: akpm@linux-foundation.org
Subject: - fbdev-advertise-limitation-of-drawing-engine.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:35 -0700
Message-ID: <200705090301.l4931ZAH010721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033207AbXEIDBi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: advertise limitation of drawing engine
has been removed from the -mm tree.  Its filename was
     fbdev-advertise-limitation-of-drawing-engine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: advertise limitation of drawing engine
From: "Antonino A. Daplas" <adaplas@gmail.com>

A few drivers are not capable of blitting rectangles of any dimension.
vga16fb can only blit 8-pixel wide rectangles, while s3fb (in tileblitting
mode) can only blit 8x16 rectangles.  For example, loading a 12x22 font in
vga16fb will result in a corrupt display.

Advertise this limitation/capability in info->pixmap.blit_x and blit_y.  These
fields are 32-bit arrays (font max is 32x32 only), ie, if bit 7 is set, then
width/height of 7+1 is supported.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    6 ++++++
 include/linux/fb.h    |    4 ++++
 2 files changed, 10 insertions(+)

diff -puN drivers/video/fbmem.c~fbdev-advertise-limitation-of-drawing-engine drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-advertise-limitation-of-drawing-engine
+++ a/drivers/video/fbmem.c
@@ -1321,6 +1321,12 @@ register_framebuffer(struct fb_info *fb_
 	}	
 	fb_info->pixmap.offset = 0;
 
+	if (!fb_info->pixmap.blit_x)
+		fb_info->pixmap.blit_x = ~(u32)0;
+
+	if (!fb_info->pixmap.blit_y)
+		fb_info->pixmap.blit_y = ~(u32)0;
+
 	if (!fb_info->modelist.prev || !fb_info->modelist.next)
 		INIT_LIST_HEAD(&fb_info->modelist);
 
diff -puN include/linux/fb.h~fbdev-advertise-limitation-of-drawing-engine include/linux/fb.h
--- a/include/linux/fb.h~fbdev-advertise-limitation-of-drawing-engine
+++ a/include/linux/fb.h
@@ -558,6 +558,10 @@ struct fb_pixmap {
 	u32 scan_align;		/* alignment per scanline		*/
 	u32 access_align;	/* alignment per read/write (bits)	*/
 	u32 flags;		/* see FB_PIXMAP_*			*/
+	u32 blit_x;             /* supported bit block dimensions (1-32)*/
+	u32 blit_y;             /* Format: blit_x = 1 << (width - 1)    */
+	                        /*         blit_y = 1 << (height - 1)   */
+	                        /* if 0, will be set to 0xffffffff (all)*/
 	/* access methods */
 	void (*writeio)(struct fb_info *info, void __iomem *dst, void *src, unsigned int size);
 	void (*readio) (struct fb_info *info, void *dst, void __iomem *src, unsigned int size);
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
