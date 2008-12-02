From: akpm@linux-foundation.org
Subject: - radeonfb-fix-problem-with-color-expansion-alignment.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:45 -0800
Message-ID: <200812021838.mB2IcjJk007083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109AbYLBSjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:39:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, cloos@jhcloos.com, davem@davemloft.net, krzysztof.h1@poczta.fm, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     radeonfb: fix problem with color expansion & alignment
has been removed from the -mm tree.  Its filename was
     radeonfb-fix-problem-with-color-expansion-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: fix problem with color expansion & alignment
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

The engine on some radeon variants locks up if color expansion is called
for non aligned source data.  This patch enables a feature of the core
fbdev to request aligned input pixmaps and uses the HW clipping engine to
clip the output to the requested size

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11875

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Cloos <cloos@jhcloos.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_accel.c |   21 ++++++++++++---------
 drivers/video/aty/radeon_base.c  |   18 ++++++++++++++++++
 2 files changed, 30 insertions(+), 9 deletions(-)

diff -puN drivers/video/aty/radeon_accel.c~radeonfb-fix-problem-with-color-expansion-alignment drivers/video/aty/radeon_accel.c
--- a/drivers/video/aty/radeon_accel.c~radeonfb-fix-problem-with-color-expansion-alignment
+++ a/drivers/video/aty/radeon_accel.c
@@ -174,12 +174,12 @@ static void radeonfb_prim_imageblit(stru
 				    const struct fb_image *image,
 				    u32 fg, u32 bg)
 {
-	unsigned int src_bytes, dwords;
+	unsigned int dwords;
 	u32 *bits;
 
 	radeonfb_set_creg(rinfo, DP_GUI_MASTER_CNTL, &rinfo->dp_gui_mc_cache,
 			  rinfo->dp_gui_mc_base |
-			  GMC_BRUSH_NONE |
+			  GMC_BRUSH_NONE | GMC_DST_CLIP_LEAVE |
 			  GMC_SRC_DATATYPE_MONO_FG_BG |
 			  ROP3_S |
 			  GMC_BYTE_ORDER_MSB_TO_LSB |
@@ -189,9 +189,6 @@ static void radeonfb_prim_imageblit(stru
 	radeonfb_set_creg(rinfo, DP_SRC_FRGD_CLR, &rinfo->dp_src_fg_cache, fg);
 	radeonfb_set_creg(rinfo, DP_SRC_BKGD_CLR, &rinfo->dp_src_bg_cache, bg);
 
-	radeon_fifo_wait(rinfo, 1);
-	OUTREG(DST_Y_X, (image->dy << 16) | image->dx);
-
 	/* Ensure the dst cache is flushed and the engine idle before
 	 * issuing the operation.
 	 *
@@ -205,13 +202,19 @@ static void radeonfb_prim_imageblit(stru
 
 	/* X here pads width to a multiple of 32 and uses the clipper to
 	 * adjust the result. Is that really necessary ? Things seem to
-	 * work ok for me without that and the doco doesn't seem to imply
+	 * work ok for me without that and the doco doesn't seem to imply]
 	 * there is such a restriction.
 	 */
-	OUTREG(DST_WIDTH_HEIGHT, (image->width << 16) | image->height);
+	radeon_fifo_wait(rinfo, 4);
+	OUTREG(SC_TOP_LEFT, (image->dy << 16) | image->dx);
+	OUTREG(SC_BOTTOM_RIGHT, ((image->dy + image->height) << 16) |
+	       (image->dx + image->width));
+	OUTREG(DST_Y_X, (image->dy << 16) | image->dx);
+
+	OUTREG(DST_HEIGHT_WIDTH, (image->height << 16) | ((image->width + 31) & ~31));
 
-	src_bytes = (((image->width * image->depth) + 7) / 8) * image->height;
-	dwords = (src_bytes + 3) / 4;
+	dwords = (image->width + 31) >> 5;
+	dwords *= image->height;
 	bits = (u32*)(image->data);
 
 	while(dwords >= 8) {
diff -puN drivers/video/aty/radeon_base.c~radeonfb-fix-problem-with-color-expansion-alignment drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~radeonfb-fix-problem-with-color-expansion-alignment
+++ a/drivers/video/aty/radeon_base.c
@@ -1875,6 +1875,7 @@ static int __devinit radeon_set_fbinfo (
 	info->fbops = &radeonfb_ops;
 	info->screen_base = rinfo->fb_base;
 	info->screen_size = rinfo->mapped_vram;
+
 	/* Fill fix common fields */
 	strlcpy(info->fix.id, rinfo->name, sizeof(info->fix.id));
         info->fix.smem_start = rinfo->fb_base_phys;
@@ -1889,8 +1890,25 @@ static int __devinit radeon_set_fbinfo (
         info->fix.mmio_len = RADEON_REGSIZE;
 	info->fix.accel = FB_ACCEL_ATI_RADEON;
 
+	/* Allocate colormap */
 	fb_alloc_cmap(&info->cmap, 256, 0);
 
+	/* Setup pixmap used for acceleration */
+#define PIXMAP_SIZE	(2048 * 4)
+
+	info->pixmap.addr = kmalloc(PIXMAP_SIZE, GFP_KERNEL);
+	if (!info->pixmap.addr) {
+		printk(KERN_ERR "radeonfb: Failed to allocate pixmap !\n");
+		noaccel = 1;
+		goto bail;
+	}
+	info->pixmap.size = PIXMAP_SIZE;
+	info->pixmap.flags = FB_PIXMAP_SYSTEM;
+	info->pixmap.scan_align = 4;
+	info->pixmap.buf_align = 4;
+	info->pixmap.access_align = 32;
+
+bail:
 	if (noaccel)
 		info->flags |= FBINFO_HWACCEL_DISABLED;
 
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

linux-next.patch
arch-powerpc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch

