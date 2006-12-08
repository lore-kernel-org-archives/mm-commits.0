From: akpm@osdl.org
Subject: - softcursorc-avoid-unaligned-accesses.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:24 -0800
Message-ID: <200612082014.kB8KEO9l003164@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59790 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946814AbWLHUOf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fbuihuu@gmail.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     softcursor.c: avoid unaligned accesses
has been removed from the -mm tree.  Its filename was
     softcursorc-avoid-unaligned-accesses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: softcursor.c: avoid unaligned accesses
From: Franck Bui-Huu <fbuihuu@gmail.com>

Fix some possible unaligned accesses when accessing fields of 'image'
pointer.  Indeed this pointer was obtained by allocating a block of memory
that embeds a temporary array plus an image structure.  The temporary
buffer was located at the start of the allocated block and depending on its
size, the image structure which comes right after can be unaligned.

For example when using mini fonts (4x6) (cursor's width is 4 and its height
is 6) the temporary buf size is 6 bytes.

Therefore this patch moves the image structure to the start of the block
and moves the temporary buffer right after.  It makes 'image' pointer
always aligned and since the tempo buf is a buffer of char, it's always
correctly aligned as well.

It also fixes the file header alignement.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/console/softcursor.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/video/console/softcursor.c~softcursorc-avoid-unaligned-accesses drivers/video/console/softcursor.c
--- a/drivers/video/console/softcursor.c~softcursorc-avoid-unaligned-accesses
+++ a/drivers/video/console/softcursor.c
@@ -1,11 +1,13 @@
 /*
- * linux/drivers/video/softcursor.c -- Generic software cursor for frame buffer devices
+ * linux/drivers/video/softcursor.c
+ *
+ * Generic software cursor for frame buffer devices
  *
  *  Created 14 Nov 2002 by James Simmons
  *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of this archive
- * for more details.
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License.  See the file COPYING in the main directory of this
+ * archive for more details.
  */
 
 #include <linux/module.h>
@@ -25,7 +27,7 @@ int soft_cursor(struct fb_info *info, st
 	unsigned int buf_align = info->pixmap.buf_align - 1;
 	unsigned int i, size, dsize, s_pitch, d_pitch;
 	struct fb_image *image;
-	u8 *dst;
+	u8 *src, *dst;
 
 	if (info->state != FBINFO_STATE_RUNNING)
 		return 0;
@@ -45,7 +47,8 @@ int soft_cursor(struct fb_info *info, st
 		}
 	}
 
-	image = (struct fb_image *) (ops->cursor_src + dsize);
+	src = ops->cursor_src + sizeof(struct fb_image);
+	image = (struct fb_image *)ops->cursor_src;
 	*image = cursor->image;
 	d_pitch = (s_pitch + scan_align) & ~scan_align;
 
@@ -57,21 +60,18 @@ int soft_cursor(struct fb_info *info, st
 		switch (cursor->rop) {
 		case ROP_XOR:
 			for (i = 0; i < dsize; i++)
-				ops->cursor_src[i] = image->data[i] ^
-					cursor->mask[i];
+				src[i] = image->data[i] ^ cursor->mask[i];
 			break;
 		case ROP_COPY:
 		default:
 			for (i = 0; i < dsize; i++)
-				ops->cursor_src[i] = image->data[i] &
-					cursor->mask[i];
+				src[i] = image->data[i] & cursor->mask[i];
 			break;
 		}
 	} else
-		memcpy(ops->cursor_src, image->data, dsize);
+		memcpy(src, image->data, dsize);
 
-	fb_pad_aligned_buffer(dst, d_pitch, ops->cursor_src, s_pitch,
-			      image->height);
+	fb_pad_aligned_buffer(dst, d_pitch, src, s_pitch, image->height);
 	image->data = dst;
 	info->fbops->fb_imageblit(info, image);
 	return 0;
_

Patches currently in -mm which might be from fbuihuu@gmail.com are

origin.patch
softcursorc-avoid-unaligned-accesses.patch

