From: akpm@linux-foundation.org
Subject: - fbdev-add-tile-operation-to-get-the-maximum-length.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:44 -0700
Message-ID: <200705090301.l4931ikm010742@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032498AbXEIDBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: add tile operation to get the maximum length of the map
has been removed from the -mm tree.  Its filename was
     fbdev-add-tile-operation-to-get-the-maximum-length.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: add tile operation to get the maximum length of the map
From: "Antonino A. Daplas" <adaplas@gmail.com>

Add a tile method, fb_get_tilemax(), that returns the maximum length of
the tile map (or font map).  This is needed by s3fb which can only handle
256 characters.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fb.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/fb.h~fbdev-add-tile-operation-to-get-the-maximum-length include/linux/fb.h
--- a/include/linux/fb.h~fbdev-add-tile-operation-to-get-the-maximum-length
+++ a/include/linux/fb.h
@@ -655,7 +655,6 @@ struct fb_ops {
 };
 
 #ifdef CONFIG_FB_TILEBLITTING
-
 #define FB_TILE_CURSOR_NONE        0
 #define FB_TILE_CURSOR_UNDERLINE   1
 #define FB_TILE_CURSOR_LOWER_THIRD 2
@@ -727,6 +726,8 @@ struct fb_tile_ops {
 	/* cursor */
 	void (*fb_tilecursor)(struct fb_info *info,
 			      struct fb_tilecursor *cursor);
+	/* get maximum length of the tile map */
+	int (*fb_get_tilemax)(struct fb_info *info);
 };
 #endif /* CONFIG_FB_TILEBLITTING */
 
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
