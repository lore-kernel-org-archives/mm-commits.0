From: akpm@linux-foundation.org
Subject: - fbdev-move-declaration-of-fb_class-to-linux-fbh.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:36 -0700
Message-ID: <200706011747.l51HlZF9015138@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761466AbXFARr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: Move declaration of fb_class to <linux/fb.h>
has been removed from the -mm tree.  Its filename was
     fbdev-move-declaration-of-fb_class-to-linux-fbh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: Move declaration of fb_class to <linux/fb.h>
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Move the forward declaration of fb_class from drivers/video/console/fbcon.h to
<linux/fb.h>, together with the other forward declarations related to
drivers/video/fbmem.c.

This kills the following sparse warning:
| drivers/video/fbmem.c:1363:14: warning: symbol 'fb_class' was not declared. Should it be static?

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.h |    1 -
 include/linux/fb.h            |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.h~fbdev-move-declaration-of-fb_class-to-linux-fbh drivers/video/console/fbcon.h
--- a/drivers/video/console/fbcon.h~fbdev-move-declaration-of-fb_class-to-linux-fbh
+++ a/drivers/video/console/fbcon.h
@@ -176,7 +176,6 @@ extern void fbcon_set_tileops(struct vc_
 #endif
 extern void fbcon_set_bitops(struct fbcon_ops *ops);
 extern int  soft_cursor(struct fb_info *info, struct fb_cursor *cursor);
-extern struct class *fb_class;
 
 #define FBCON_ATTRIBUTE_UNDERLINE 1
 #define FBCON_ATTRIBUTE_REVERSE   2
diff -puN include/linux/fb.h~fbdev-move-declaration-of-fb_class-to-linux-fbh include/linux/fb.h
--- a/include/linux/fb.h~fbdev-move-declaration-of-fb_class-to-linux-fbh
+++ a/include/linux/fb.h
@@ -942,6 +942,7 @@ extern int fb_new_modelist(struct fb_inf
 
 extern struct fb_info *registered_fb[FB_MAX];
 extern int num_registered_fb;
+extern struct class *fb_class;
 
 static inline void __fb_pad_aligned_buffer(u8 *dst, u32 d_pitch,
 					   u8 *src, u32 s_pitch, u32 height)
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
update-documentation-block-barriertxt.patch
