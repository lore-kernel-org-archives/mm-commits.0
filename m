From: akpm@linux-foundation.org
Subject: [merged] viafb-rework-color-setting.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:56:46 -0400
Message-ID: <201003150657.o2F6vJUf016363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934519Ab0COG5X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:57:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, mm-commits@vger.kernel.org


The patch titled
     viafb: rework color setting
has been removed from the -mm tree.  Its filename was
     viafb-rework-color-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: rework color setting
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

This is a rewritten version of viafb_setcolreg.  The hardware register
writes were split up and moved to hw.c where they belong as this is really
low level stuff.  It was made dual fb aware.

Furthermore viafb_setcmap was removed as the problem with 8bpp originated
from a bug in writing multiple color registers at once.  The removal of
viafb_setcmap might introduce a small performance regression but its
certainly better to receive the correct result a bit slower than a garbled
picture fast.  It should give us a working 8bpp mode and is more
extensible than the old hardcoded code.  No other regressions are expected
but as the hardware might be a bit picky it might cause some regressions
in 8bpp mode on some hardware although I doubt that.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c       |   28 +++
 drivers/video/via/hw.h       |    2 
 drivers/video/via/viafbdev.c |  239 +++------------------------------
 3 files changed, 52 insertions(+), 217 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-rework-color-setting drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-rework-color-setting
+++ a/drivers/video/via/hw.c
@@ -691,7 +691,7 @@ void viafb_set_primary_color_depth(u8 de
 
 	DEBUG_MSG(KERN_DEBUG "viafb_set_primary_color_depth(%d)\n", depth);
 	switch (depth) {
-	case 6:
+	case 8:
 		value = 0x00;
 		break;
 	case 16:
@@ -715,7 +715,7 @@ void viafb_set_secondary_color_depth(u8 
 
 	DEBUG_MSG(KERN_DEBUG "viafb_set_secondary_color_depth(%d)\n", depth);
 	switch (depth) {
-	case 6:
+	case 8:
 		value = 0x00;
 		break;
 	case 16:
@@ -733,6 +733,27 @@ void viafb_set_secondary_color_depth(u8 
 	viafb_write_reg_mask(0x67, VIACR, value, 0xC0);
 }
 
+static void set_color_register(u8 index, u8 red, u8 green, u8 blue)
+{
+	outb(0xFF, 0x3C6); /* bit mask of palette */
+	outb(index, 0x3C8);
+	outb(red, 0x3C9);
+	outb(green, 0x3C9);
+	outb(blue, 0x3C9);
+}
+
+void viafb_set_primary_color_register(u8 index, u8 red, u8 green, u8 blue)
+{
+	viafb_write_reg_mask(0x1A, VIASR, 0x00, 0x01);
+	set_color_register(index, red, green, blue);
+}
+
+void viafb_set_secondary_color_register(u8 index, u8 red, u8 green, u8 blue)
+{
+	viafb_write_reg_mask(0x1A, VIASR, 0x01, 0x01);
+	set_color_register(index, red, green, blue);
+}
+
 void viafb_set_output_path(int device, int set_iga, int output_interface)
 {
 	switch (device) {
@@ -2210,8 +2231,7 @@ int viafb_setmode(struct VideoModeTable 
 		outb(VPIT.SR[i - 1], VIASR + 1);
 	}
 
-	viafb_write_reg_mask(0x15, VIASR, viafbinfo->fix.visual
-		== FB_VISUAL_PSEUDOCOLOR ? 0x22 : 0xA2, 0xA2);
+	viafb_write_reg_mask(0x15, VIASR, 0xA2, 0xA2);
 	viafb_set_iga_path();
 
 	/* Write CRTC */
diff -puN drivers/video/via/hw.h~viafb-rework-color-setting drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-rework-color-setting
+++ a/drivers/video/via/hw.h
@@ -914,6 +914,8 @@ void viafb_set_primary_address(u32 addr)
 void viafb_set_secondary_address(u32 addr);
 void viafb_set_primary_pitch(u32 pitch);
 void viafb_set_secondary_pitch(u32 pitch);
+void viafb_set_primary_color_register(u8 index, u8 red, u8 green, u8 blue);
+void viafb_set_secondary_color_register(u8 index, u8 red, u8 green, u8 blue);
 void viafb_get_fb_info(unsigned int *fb_base, unsigned int *fb_len);
 
 #endif /* __HW_H__ */
diff -puN drivers/video/via/viafbdev.c~viafb-rework-color-setting drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-rework-color-setting
+++ a/drivers/video/via/viafbdev.c
@@ -76,9 +76,9 @@ static void viafb_fill_var_color_info(st
 		var->red.offset = 0;
 		var->green.offset = 0;
 		var->blue.offset = 0;
-		var->red.length = 6;
-		var->green.length = 6;
-		var->blue.length = 6;
+		var->red.length = 8;
+		var->green.length = 8;
+		var->blue.length = 8;
 		break;
 	case 16:
 		var->bits_per_pixel = 16;
@@ -255,219 +255,33 @@ static int viafb_set_par(struct fb_info 
 static int viafb_setcolreg(unsigned regno, unsigned red, unsigned green,
 unsigned blue, unsigned transp, struct fb_info *info)
 {
-	u8 sr1a, sr1b, cr67, cr6a, rev = 0, shift = 10;
-	unsigned cmap_entries = (info->var.bits_per_pixel == 8) ? 256 : 16;
-	DEBUG_MSG(KERN_INFO "viafb_setcolreg!\n");
-	if (regno >= cmap_entries)
-		return 1;
-	if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name) {
-		/*
-		 * Read PCI bus 0,dev 0,function 0,index 0xF6 to get chip rev.
-		 */
-		outl(0x80000000 | (0xf6 & ~3), (unsigned long)0xCF8);
-		rev = (inl((unsigned long)0xCFC) >> ((0xf6 & 3) * 8)) & 0xff;
-	}
-	switch (info->var.bits_per_pixel) {
-	case 8:
-		outb(0x1A, 0x3C4);
-		sr1a = inb(0x3C5);
-		outb(0x1B, 0x3C4);
-		sr1b = inb(0x3C5);
-		outb(0x67, 0x3D4);
-		cr67 = inb(0x3D5);
-		outb(0x6A, 0x3D4);
-		cr6a = inb(0x3D5);
-
-		/* Map the 3C6/7/8/9 to the IGA2 */
-		outb(0x1A, 0x3C4);
-		outb(sr1a | 0x01, 0x3C5);
-		/* Second Display Engine colck always on */
-		outb(0x1B, 0x3C4);
-		outb(sr1b | 0x80, 0x3C5);
-		/* Second Display Color Depth 8 */
-		outb(0x67, 0x3D4);
-		outb(cr67 & 0x3F, 0x3D5);
-		outb(0x6A, 0x3D4);
-		/* Second Display Channel Reset CR6A[6]) */
-		outb(cr6a & 0xBF, 0x3D5);
-		/* Second Display Channel Enable CR6A[7] */
-		outb(cr6a | 0x80, 0x3D5);
-		/* Second Display Channel stop reset) */
-		outb(cr6a | 0x40, 0x3D5);
-
-		/* Bit mask of palette */
-		outb(0xFF, 0x3c6);
-		/* Write one register of IGA2 */
-		outb(regno, 0x3C8);
-		if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name &&
-			rev >= 15) {
-			shift = 8;
-			viafb_write_reg_mask(CR6A, VIACR, BIT5, BIT5);
-			viafb_write_reg_mask(SR15, VIASR, BIT7, BIT7);
-		} else {
-			shift = 10;
-			viafb_write_reg_mask(CR6A, VIACR, 0, BIT5);
-			viafb_write_reg_mask(SR15, VIASR, 0, BIT7);
-		}
-		outb(red >> shift, 0x3C9);
-		outb(green >> shift, 0x3C9);
-		outb(blue >> shift, 0x3C9);
-
-		/* Map the 3C6/7/8/9 to the IGA1 */
-		outb(0x1A, 0x3C4);
-		outb(sr1a & 0xFE, 0x3C5);
-		/* Bit mask of palette */
-		outb(0xFF, 0x3c6);
-		/* Write one register of IGA1 */
-		outb(regno, 0x3C8);
-		outb(red >> shift, 0x3C9);
-		outb(green >> shift, 0x3C9);
-		outb(blue >> shift, 0x3C9);
-
-		outb(0x1A, 0x3C4);
-		outb(sr1a, 0x3C5);
-		outb(0x1B, 0x3C4);
-		outb(sr1b, 0x3C5);
-		outb(0x67, 0x3D4);
-		outb(cr67, 0x3D5);
-		outb(0x6A, 0x3D4);
-		outb(cr6a, 0x3D5);
-		break;
-	case 16:
-		((u32 *) info->pseudo_palette)[regno] = (red & 0xF800) |
-		    ((green & 0xFC00) >> 5) | ((blue & 0xF800) >> 11);
-		break;
-	case 32:
-		((u32 *) info->pseudo_palette)[regno] =
-		    ((transp & 0xFF00) << 16) |
-		    ((red & 0xFF00) << 8) |
-		    ((green & 0xFF00)) | ((blue & 0xFF00) >> 8);
-		break;
-	}
+	struct viafb_par *viapar = info->par;
+	u32 r, g, b;
 
-	return 0;
+	if (info->fix.visual == FB_VISUAL_PSEUDOCOLOR) {
+		if (regno > 255)
+			return -EINVAL;
 
-}
+		if (!viafb_dual_fb || viapar->iga_path == IGA1)
+			viafb_set_primary_color_register(regno, red >> 8,
+				green >> 8, blue >> 8);
+
+		if (!viafb_dual_fb || viapar->iga_path == IGA2)
+			viafb_set_secondary_color_register(regno, red >> 8,
+				green >> 8, blue >> 8);
+	} else {
+		if (regno > 15)
+			return -EINVAL;
 
-/*CALLED BY: fb_set_cmap */
-/*           fb_set_var, pass 256 colors */
-/*CALLED BY: fb_set_cmap */
-/*           fbcon_set_palette, pass 16 colors */
-static int viafb_setcmap(struct fb_cmap *cmap, struct fb_info *info)
-{
-	u32 len = cmap->len;
-	u32 i;
-	u16 *pred = cmap->red;
-	u16 *pgreen = cmap->green;
-	u16 *pblue = cmap->blue;
-	u16 *ptransp = cmap->transp;
-	u8 sr1a, sr1b, cr67, cr6a, rev = 0, shift = 10;
-	if (len > 256)
-		return 1;
-	if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name) {
-		/*
-		 * Read PCI bus 0, dev 0, function 0, index 0xF6 to get chip
-		 * rev.
-		 */
-		outl(0x80000000 | (0xf6 & ~3), (unsigned long)0xCF8);
-		rev = (inl((unsigned long)0xCFC) >> ((0xf6 & 3) * 8)) & 0xff;
-	}
-	switch (info->var.bits_per_pixel) {
-	case 8:
-		outb(0x1A, 0x3C4);
-		sr1a = inb(0x3C5);
-		outb(0x1B, 0x3C4);
-		sr1b = inb(0x3C5);
-		outb(0x67, 0x3D4);
-		cr67 = inb(0x3D5);
-		outb(0x6A, 0x3D4);
-		cr6a = inb(0x3D5);
-		/* Map the 3C6/7/8/9 to the IGA2 */
-		outb(0x1A, 0x3C4);
-		outb(sr1a | 0x01, 0x3C5);
-		outb(0x1B, 0x3C4);
-		/* Second Display Engine colck always on */
-		outb(sr1b | 0x80, 0x3C5);
-		outb(0x67, 0x3D4);
-		/* Second Display Color Depth 8 */
-		outb(cr67 & 0x3F, 0x3D5);
-		outb(0x6A, 0x3D4);
-		/* Second Display Channel Reset CR6A[6]) */
-		outb(cr6a & 0xBF, 0x3D5);
-		/* Second Display Channel Enable CR6A[7] */
-		outb(cr6a | 0x80, 0x3D5);
-		/* Second Display Channel stop reset) */
-		outb(cr6a | 0xC0, 0x3D5);
-
-		/* Bit mask of palette */
-		outb(0xFF, 0x3c6);
-		outb(0x00, 0x3C8);
-		if (UNICHROME_CLE266 == viaparinfo->chip_info->gfx_chip_name &&
-			rev >= 15) {
-			shift = 8;
-			viafb_write_reg_mask(CR6A, VIACR, BIT5, BIT5);
-			viafb_write_reg_mask(SR15, VIASR, BIT7, BIT7);
-		} else {
-			shift = 10;
-			viafb_write_reg_mask(CR6A, VIACR, 0, BIT5);
-			viafb_write_reg_mask(SR15, VIASR, 0, BIT7);
-		}
-		for (i = 0; i < len; i++) {
-			outb((*(pred + i)) >> shift, 0x3C9);
-			outb((*(pgreen + i)) >> shift, 0x3C9);
-			outb((*(pblue + i)) >> shift, 0x3C9);
-		}
-
-		outb(0x1A, 0x3C4);
-		/* Map the 3C6/7/8/9 to the IGA1 */
-		outb(sr1a & 0xFE, 0x3C5);
-		/* Bit mask of palette */
-		outb(0xFF, 0x3c6);
-		outb(0x00, 0x3C8);
-		for (i = 0; i < len; i++) {
-			outb((*(pred + i)) >> shift, 0x3C9);
-			outb((*(pgreen + i)) >> shift, 0x3C9);
-			outb((*(pblue + i)) >> shift, 0x3C9);
-		}
-
-		outb(0x1A, 0x3C4);
-		outb(sr1a, 0x3C5);
-		outb(0x1B, 0x3C4);
-		outb(sr1b, 0x3C5);
-		outb(0x67, 0x3D4);
-		outb(cr67, 0x3D5);
-		outb(0x6A, 0x3D4);
-		outb(cr6a, 0x3D5);
-		break;
-	case 16:
-		if (len > 17)
-			return 0;	/* Because static u32 pseudo_pal[17]; */
-		for (i = 0; i < len; i++)
-			((u32 *) info->pseudo_palette)[i] =
-			    (*(pred + i) & 0xF800) |
-			    ((*(pgreen + i) & 0xFC00) >> 5) |
-			    ((*(pblue + i) & 0xF800) >> 11);
-		break;
-	case 32:
-		if (len > 17)
-			return 0;
-		if (ptransp) {
-			for (i = 0; i < len; i++)
-				((u32 *) info->pseudo_palette)[i] =
-				    ((*(ptransp + i) & 0xFF00) << 16) |
-				    ((*(pred + i) & 0xFF00) << 8) |
-				    ((*(pgreen + i) & 0xFF00)) |
-				    ((*(pblue + i) & 0xFF00) >> 8);
-		} else {
-			for (i = 0; i < len; i++)
-				((u32 *) info->pseudo_palette)[i] =
-				    0x00000000 |
-				    ((*(pred + i) & 0xFF00) << 8) |
-				    ((*(pgreen + i) & 0xFF00)) |
-				    ((*(pblue + i) & 0xFF00) >> 8);
-		}
-		break;
+		r = (red >> (16 - info->var.red.length))
+			<< info->var.red.offset;
+		b = (blue >> (16 - info->var.blue.length))
+			<< info->var.blue.offset;
+		g = (green >> (16 - info->var.green.length))
+			<< info->var.green.offset;
+		((u32 *) info->pseudo_palette)[regno] = r | g | b;
 	}
+
 	return 0;
 }
 
@@ -2286,7 +2100,6 @@ static struct fb_ops viafb_ops = {
 	.fb_cursor = viafb_cursor,
 	.fb_ioctl = viafb_ioctl,
 	.fb_sync = viafb_sync,
-	.fb_setcmap = viafb_setcmap,
 };
 
 module_init(viafb_init);
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

