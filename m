From: akpm@linux-foundation.org
Subject: [folded] mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch removed from -mm tree
Date: Tue, 15 Dec 2009 16:32:55 -0800
Message-ID: <200912160032.nBG0WtoV023619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756086AbZLPAdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:33:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agust@denx.de, krzysztof.h1@poczta.fm, valentin.sitdikov@siemens.com, mm-commits@vger.kernel.org


The patch titled
     mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix
has been removed from the -mm tree.  Its filename was
     mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch

This patch was dropped because it was folded into mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix
From: Andrew Morton <akpm@linux-foundation.org>

- clean up comments
- remove do-nothing tests
- use min()

Cc: Anatolij Gustschin <agust@denx.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Valentin Sitdikov <valentin.sitdikov@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mb862xx/mb862xxfb_accel.c |   28 ++++++++++++----------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/video/mb862xx/mb862xxfb_accel.c~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix drivers/video/mb862xx/mb862xxfb_accel.c
--- a/drivers/video/mb862xx/mb862xxfb_accel.c~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix
+++ a/drivers/video/mb862xx/mb862xxfb_accel.c
@@ -66,8 +66,10 @@ static void mb86290fb_copyarea(struct fb
 	mb862xxfb_write_fifo(6, cmd, info);
 }
 
-/* Fill in the cmd array /GDC FIFO commands/ to draw a 1bit image.
- * Make sure cmd has enough room! */
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 1bit image.
+ * Make sure cmd has enough room!
+ */
 static void mb86290fb_imageblit1(u32 *cmd, u16 step, u16 dx, u16 dy,
 				 u16 width, u16 height, u32 fgcolor,
 				 u32 bgcolor, const struct fb_image *image,
@@ -113,8 +115,10 @@ static void mb86290fb_imageblit1(u32 *cm
 	}
 }
 
-/* Fill in the cmd array /GDC FIFO commands/ to draw a 8bit image.
- * Make sure cmd has enough room! */
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 8bit image.
+ * Make sure cmd has enough room!
+ */
 static void mb86290fb_imageblit8(u32 *cmd, u16 step, u16 dx, u16 dy,
 				 u16 width, u16 height, u32 fgcolor,
 				 u32 bgcolor, const struct fb_image *image,
@@ -150,8 +154,10 @@ static void mb86290fb_imageblit8(u32 *cm
 	}
 }
 
-/* Fill in the cmd array /GDC FIFO commands/ to draw a 16bit image.
- * Make sure cmd has enough room! */
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 16bit image.
+ * Make sure cmd has enough room!
+ */
 static void mb86290fb_imageblit16(u32 *cmd, u16 step, u16 dx, u16 dy,
 				  u16 width, u16 height, u32 fgcolor,
 				  u32 bgcolor, const struct fb_image *image,
@@ -195,12 +201,10 @@ static void mb86290fb_imageblit(struct f
 	mdr = (GDC_ROP_COPY << 9);
 	x2 = image->dx + image->width;
 	y2 = image->dy + image->height;
-	dx = image->dx > 0 ? image->dx : 0;
-	dy = image->dy > 0 ? image->dy : 0;
 	vxres = info->var.xres_virtual;
 	vyres = info->var.yres_virtual;
-	x2 = x2 < vxres ? x2 : vxres;
-	y2 = y2 < vyres ? y2 : vyres;
+	x2 = min(x2, vxres);
+	y2 = min(y2, vyres);
 	width = x2 - dx;
 	height = y2 - dy;
 
@@ -265,8 +269,8 @@ static void mb86290fb_fillrect(struct fb
 	 * hardware clipping by writing to framebuffer directly. */
 	x2 = rect->dx + rect->width;
 	y2 = rect->dy + rect->height;
-	x2 = x2 < vxres ? x2 : vxres;
-	y2 = y2 < vyres ? y2 : vyres;
+	x2 = min(x2, vxres);
+	y2 = min(y2, vyres);
 	width = x2 - rect->dx;
 	height = y2 - rect->dy;
 	if (info->fix.visual == FB_VISUAL_TRUECOLOR ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch

