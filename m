From: akpm@linux-foundation.org
Subject: [folded] viafb-2d-engine-rewrite-v2.patch removed from -mm tree
Date: Tue, 22 Sep 2009 14:53:38 -0700
Message-ID: <200909222153.n8MLrcgO020744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbZIVVyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 17:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, laforge@gnumonks.org, mm-commits@vger.kernel.org


The patch titled
     viafb-2d-engine-rewrite-v2
has been removed from the -mm tree.  Its filename was
     viafb-2d-engine-rewrite-v2.patch

This patch was dropped because it was folded into viafb-2d-engine-rewrite.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb-2d-engine-rewrite-v2
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

v2: - fix copyarea with overlapping areas
    - add raster operation code conversion and checking

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c    |   84 ++++++++++++++++++++++++++-------
 drivers/video/via/viafbdev.c |    8 ++-
 2 files changed, 75 insertions(+), 17 deletions(-)

diff -puN drivers/video/via/accel.c~viafb-2d-engine-rewrite-v2 drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-2d-engine-rewrite-v2
+++ a/drivers/video/via/accel.c
@@ -25,13 +25,40 @@ static int hw_bitblt_1(void __iomem *eng
 	u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
 	u32 fg_color, u32 bg_color, u8 fill_rop)
 {
-	u32 tmp, i;
+	u32 ge_cmd = 0, tmp, i;
 
 	if (!op || op > 3) {
 		printk(KERN_WARNING "hw_bitblt_1: Invalid operation: %d\n", op);
 		return -EINVAL;
 	}
 
+	if (op != VIA_BITBLT_FILL && !src_mem && src_addr == dst_addr) {
+		if (src_x < dst_x) {
+			ge_cmd |= 0x00008000;
+			src_x += width - 1;
+			dst_x += width - 1;
+		}
+		if (src_y < dst_y) {
+			ge_cmd |= 0x00004000;
+			src_y += height - 1;
+			dst_y += height - 1;
+		}
+	}
+
+	if (op == VIA_BITBLT_FILL) {
+		switch (fill_rop) {
+		case 0x00: /* blackness */
+		case 0x5A: /* pattern inversion */
+		case 0xF0: /* pattern copy */
+		case 0xFF: /* whiteness */
+			break;
+		default:
+			printk(KERN_WARNING "hw_bitblt_1: Invalid fill rop: "
+				"%u\n", fill_rop);
+			return -EINVAL;
+		}
+	}
+
 	switch (dst_bpp) {
 	case 8:
 		tmp = 0x00000000;
@@ -113,19 +140,18 @@ static int hw_bitblt_1(void __iomem *eng
 	tmp = (tmp >> 3) | (dst_pitch << (16 - 3));
 	writel(tmp, engine + 0x38);
 
-	tmp = 0;
 	if (op == VIA_BITBLT_FILL)
-		tmp |= fill_rop << 24 | 0x00002000 | 0x00000001;
+		ge_cmd |= fill_rop << 24 | 0x00002000 | 0x00000001;
 	else {
-		tmp = 0xCC000000; /* ROP=SRCCOPY */
+		ge_cmd |= 0xCC000000; /* ROP=SRCCOPY */
 		if (src_mem)
-			tmp |= 0x00000040;
+			ge_cmd |= 0x00000040;
 		if (op == VIA_BITBLT_MONO)
-			tmp |= 0x00000002 | 0x00000100 | 0x00020000;
+			ge_cmd |= 0x00000002 | 0x00000100 | 0x00020000;
 		else
-			tmp |= 0x00000001;
+			ge_cmd |= 0x00000001;
 	}
-	writel(tmp, engine);
+	writel(ge_cmd, engine);
 
 	if (op == VIA_BITBLT_FILL || !src_mem)
 		return 0;
@@ -144,13 +170,40 @@ static int hw_bitblt_2(void __iomem *eng
 	u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
 	u32 fg_color, u32 bg_color, u8 fill_rop)
 {
-	u32 tmp, i;
+	u32 ge_cmd = 0, tmp, i;
 
 	if (!op || op > 3) {
 		printk(KERN_WARNING "hw_bitblt_2: Invalid operation: %d\n", op);
 		return -EINVAL;
 	}
 
+	if (op != VIA_BITBLT_FILL && !src_mem && src_addr == dst_addr) {
+		if (src_x < dst_x) {
+			ge_cmd |= 0x00008000;
+			src_x += width - 1;
+			dst_x += width - 1;
+		}
+		if (src_y < dst_y) {
+			ge_cmd |= 0x00004000;
+			src_y += height - 1;
+			dst_y += height - 1;
+		}
+	}
+
+	if (op == VIA_BITBLT_FILL) {
+		switch (fill_rop) {
+		case 0x00: /* blackness */
+		case 0x5A: /* pattern inversion */
+		case 0xF0: /* pattern copy */
+		case 0xFF: /* whiteness */
+			break;
+		default:
+			printk(KERN_WARNING "hw_bitblt_2: Invalid fill rop: "
+				"%u\n", fill_rop);
+			return -EINVAL;
+		}
+	}
+
 	switch (dst_bpp) {
 	case 8:
 		tmp = 0x00000000;
@@ -230,19 +283,18 @@ static int hw_bitblt_2(void __iomem *eng
 	if (op == VIA_BITBLT_MONO)
 		writel(bg_color, engine + 0x50);
 
-	tmp = 0;
 	if (op == VIA_BITBLT_FILL)
-		tmp |= fill_rop << 24 | 0x00002000 | 0x00000001;
+		ge_cmd |= fill_rop << 24 | 0x00002000 | 0x00000001;
 	else {
-		tmp = 0xCC000000; /* ROP=SRCCOPY */
+		ge_cmd |= 0xCC000000; /* ROP=SRCCOPY */
 		if (src_mem)
-			tmp |= 0x00000040;
+			ge_cmd |= 0x00000040;
 		if (op == VIA_BITBLT_MONO)
-			tmp |= 0x00000002 | 0x00000100 | 0x00020000;
+			ge_cmd |= 0x00000002 | 0x00000100 | 0x00020000;
 		else
-			tmp |= 0x00000001;
+			ge_cmd |= 0x00000001;
 	}
-	writel(tmp, engine);
+	writel(ge_cmd, engine);
 
 	if (op == VIA_BITBLT_FILL || !src_mem)
 		return 0;
diff -puN drivers/video/via/viafbdev.c~viafb-2d-engine-rewrite-v2 drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-2d-engine-rewrite-v2
+++ a/drivers/video/via/viafbdev.c
@@ -768,6 +768,7 @@ static void viafb_fillrect(struct fb_inf
 {
 	struct viafb_par *viapar = info->par;
 	u32 fg_color;
+	u8 rop;
 
 	if (!viapar->shared->hw_bitblt) {
 		cfb_fillrect(info, rect);
@@ -782,11 +783,16 @@ static void viafb_fillrect(struct fb_inf
 	else
 		fg_color = rect->color;
 
+	if (rect->rop == ROP_XOR)
+		rop = 0x5A;
+	else
+		rop = 0xF0;
+
 	DEBUG_MSG(KERN_DEBUG "viafb 2D engine: fillrect\n");
 	if (viapar->shared->hw_bitblt(viapar->io_virt, VIA_BITBLT_FILL,
 		rect->width, rect->height, info->var.bits_per_pixel,
 		viapar->vram_addr, info->fix.line_length, rect->dx, rect->dy,
-		NULL, 0, 0, 0, 0, fg_color, 0, rect->rop))
+		NULL, 0, 0, 0, 0, fg_color, 0, rop))
 		cfb_fillrect(info, rect);
 }
 
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
viafb-remove-unused-video-device-stuff.patch
viafb-remove-lvds-initialization.patch
viafb-another-small-cleanup-of-viafb_par.patch
viafb-improve-viafb_par.patch
viafb-2d-engine-rewrite.patch
viafb-2d-engine-rewrite-v2.patch
viafb-switch-to-seq_file.patch
viafb-cleanup-viafb_cursor.patch
viafb-improve-pitch-handling.patch
viafb-hardware-acceleration-initialization-cleanup.patch
viafb-make-module-parameters-visible-in-sysfs.patch
viafb-remove-unused-structure-member.patch
viafb-use-read-only-mode-parsing.patch
viafb-add-support-for-the-vx855-chipset.patch
viafb-choose-acceleration-engine-for-vx855.patch
viafb-make-viafb-a-first-class-citizen-using-pci_driver.patch
viafb-pass-reference-to-pci-device-when-calling-framebuffer_alloc.patch
fb-fix-fb_pan_display-range-check.patch
fb-do-not-ignore-fb_set_par-errors.patch

