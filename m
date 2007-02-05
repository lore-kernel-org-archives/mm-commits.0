From: akpm@linux-foundation.org
Subject: + fbdev-driver-for-s3-trio-virge-update.patch added to -mm tree
Date: Mon, 05 Feb 2007 15:10:14 -0800
Message-ID: <200702052310.l15NAFrA002183@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38311 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964996AbXBEXKj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 18:10:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santiago@crfreenet.org, jsimmons@infradead.org


The patch titled
     fbdev driver for S3 Trio/Virge update
has been added to the -mm tree.  Its filename is
     fbdev-driver-for-s3-trio-virge-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev driver for S3 Trio/Virge update
From: Ondrej Zajicek <santiago@crfreenet.org>

 * proper Virge VX support
 * suspend/resume support
 * S3 fasttext support
 * several minor bugs corrected

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/s3fb.txt |   15 -
 drivers/video/Kconfig     |    2 
 drivers/video/s3fb.c      |  422 +++++++++++++-----------------------
 drivers/video/svgalib.c   |  238 +++++++++++++++++---
 include/linux/fb.h        |    7 
 include/linux/svga.h      |   29 +-
 6 files changed, 398 insertions(+), 315 deletions(-)

diff -puN Documentation/fb/s3fb.txt~fbdev-driver-for-s3-trio-virge-update Documentation/fb/s3fb.txt
--- a/Documentation/fb/s3fb.txt~fbdev-driver-for-s3-trio-virge-update
+++ a/Documentation/fb/s3fb.txt
@@ -16,7 +16,8 @@ Supported Hardware
 	- only BIOS initialized VGA devices supported
 	- probably not working on big endian
 
-I tested s3fb on Trio64 (plain, V+ and V2/DX) and Virge DX, all on i386.
+I tested s3fb on Trio64 (plain, V+ and V2/DX) and Virge (plain, VX, DX),
+all on i386.
 
 
 Supported Features
@@ -25,11 +26,13 @@ Supported Features
 	*  4 bpp pseudocolor modes (with 18bit palette, two variants)
 	*  8 bpp pseudocolor mode (with 18bit palette)
 	* 16 bpp truecolor modes (RGB 555 and RGB 565)
-	* 32 bpp truecolor mode (RGB 888)
+	* 24 bpp truecolor mode (RGB 888) on (only on Virge VX)
+	* 32 bpp truecolor mode (RGB 888) on (not on Virge VX)
 	* text mode (activated by bpp = 0)
 	* interlaced mode variant (not available in text mode)
 	* doublescan mode variant (not available in text mode)
 	* panning in both directions
+	* suspend/resume support
 	* DPMS support
 
 Text mode is supported even in higher resolutions, but there is limitation
@@ -42,17 +45,19 @@ packed pixels, high nibble first. Second
 with interleaved planes (1 byte interleave), MSB first. Both modes support
 8bit wide fonts only (driver limitation).
 
+Suspend/resume works on systems that initialize video card during resume and
+if device is active (for example used by fbcon).
+
 
 Missing Features
 ================
 (alias TODO list)
 
 	* secondary (not initialized by BIOS) device support
-	* suspend/resume support
    	* big endian support
 	* Zorro bus support
 	* MMIO support
-	* 24 bpp mode support
+	* 24 bpp mode support on more cards
 	* support for fontwidths != 8 in 4 bpp modes
 	* support for fontheight != 16 in text mode
 	* composite and external sync (is anyone able to test this?)
@@ -68,8 +73,6 @@ Known bugs
 ==========
 
 	* cursor disable in text mode doesn't work
-	* there is some small (but larger than usual) difference between
-	  requested and used timings
 
 --
 Ondrej Zajicek <santiago@crfreenet.org>
diff -puN drivers/video/Kconfig~fbdev-driver-for-s3-trio-virge-update drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-driver-for-s3-trio-virge-update
+++ a/drivers/video/Kconfig
@@ -1208,7 +1208,6 @@ config FB_SAVAGE_ACCEL
           the resulting framebuffer console has bothersome glitches, then
           choose N here.
 
-
 config FB_SIS
 	tristate "SiS/XGI display support"
 	depends on FB && PCI
@@ -1356,7 +1355,6 @@ config FB_TRIDENT_ACCEL
 	This will compile the Trident frame buffer device with
 	acceleration functions.
 
-
 config FB_PM3
 	tristate "Permedia3 support"
 	depends on FB && PCI && BROKEN
diff -puN drivers/video/Makefile~fbdev-driver-for-s3-trio-virge-update drivers/video/Makefile
diff -puN drivers/video/s3fb.c~fbdev-driver-for-s3-trio-virge-update drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~fbdev-driver-for-s3-trio-virge-update
+++ a/drivers/video/s3fb.c
@@ -1,15 +1,15 @@
 /*
-*  linux/drivers/video/s3fb.c -- Frame buffer device driver for S3 Trio32/64
-*
-*  Copyright (c) 2006 Ondrej Zajicek <santiago@crfreenet.org>
-*
-*  This file is subject to the terms and conditions of the GNU General Public
-*  License.  See the file COPYING in the main directory of this archive for
-*  more details.
-*
-*  Code is based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
-*  which is based on the code of neofb.
-*/
+ * linux/drivers/video/s3fb.c -- Frame buffer device driver for S3 Trio/Virge
+ *
+ * Copyright (c) 2006 Ondrej Zajicek <santiago@crfreenet.org>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive for
+ * more details.
+ *
+ * Code is based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
+ * which is based on the code of neofb.
+ */
 
 #include <linux/version.h>
 #include <linux/module.h>
@@ -24,7 +24,7 @@
 #include <linux/svga.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-// #include <linux/console.h> /* Why should fb driver call console functions? strange ...*/
+#include <linux/console.h> /* Why should fb driver call console functions? because acquire_console_sem() */
 #include <video/vga.h>
 
 #ifdef CONFIG_MTRR
@@ -46,25 +46,24 @@ struct s3fb_info {
 
 static const struct svga_fb_format s3fb_formats[] = {
 	{ 0,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
-		FB_TYPE_TEXT, 5,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
+		FB_TYPE_TEXT, FB_AUX_TEXT_SVGA_STEP4,	FB_VISUAL_PSEUDOCOLOR, 8, 16},
 	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
-		FB_TYPE_PACKED_PIXELS, 0,	FB_VISUAL_PSEUDOCOLOR, 8, 16},
+		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
 	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 1,
-		FB_TYPE_INTERLEAVED_PLANES, 1,	FB_VISUAL_PSEUDOCOLOR, 8, 16},
+		FB_TYPE_INTERLEAVED_PLANES, 1,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
 	{ 8,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
-		FB_TYPE_PACKED_PIXELS, 0,	FB_VISUAL_PSEUDOCOLOR, 4, 8},
+		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_PSEUDOCOLOR, 4, 8},
 	{16,  {10, 5, 0}, {5, 5, 0},  {0, 5, 0}, {0, 0, 0}, 0,
-		FB_TYPE_PACKED_PIXELS, 0,	FB_VISUAL_TRUECOLOR, 2, 4},
+		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_TRUECOLOR, 2, 4},
 	{16,  {11, 5, 0}, {5, 6, 0},  {0, 5, 0}, {0, 0, 0}, 0,
-		FB_TYPE_PACKED_PIXELS, 0,	FB_VISUAL_TRUECOLOR, 2, 4},
+		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_TRUECOLOR, 2, 4},
+	{24,  {16, 8, 0}, {8, 8, 0},  {0, 8, 0}, {0, 0, 0}, 0,
+		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_TRUECOLOR, 1, 2},
 	{32,  {16, 8, 0}, {8, 8, 0},  {0, 8, 0}, {0, 0, 0}, 0,
-		FB_TYPE_PACKED_PIXELS, 0,	FB_VISUAL_TRUECOLOR, 1, 2},
+		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_TRUECOLOR, 1, 2},
 	SVGA_FORMAT_END
 };
 
-//	{24,  {16, 8, 0}, {8, 8, 0},  {0, 8, 0}, {0, 0, 0}, 0,
-//	 FB_TYPE_PACKED_PIXELS,	0, FB_VISUAL_TRUECOLOR, 4, 8},
-
 
 static const struct svga_pll s3_pll = {3, 129, 3, 33, 0, 3,
 	60000, 240000, 14318};
@@ -78,12 +77,12 @@ static const char * const s3_names[] = {
 			"S3 Virge/GX2", "S3 Virge/GX2P", "S3 Virge/GX2P"};
 
 #define CHIP_UNKNOWN		0x00
-#define CHIP_732_TRIO32 	0x01
+#define CHIP_732_TRIO32		0x01
 #define CHIP_764_TRIO64		0x02
 #define CHIP_765_TRIO64VP	0x03
 #define CHIP_767_TRIO64UVP	0x04
-#define	CHIP_775_TRIO64V2_DX	0x05
-#define	CHIP_785_TRIO64V2_GX	0x06
+#define CHIP_775_TRIO64V2_DX	0x05
+#define CHIP_785_TRIO64V2_GX	0x06
 #define CHIP_551_PLATO_PX	0x07
 #define CHIP_M65_AURORA64VP	0x08
 #define CHIP_325_VIRGE		0x09
@@ -113,7 +112,6 @@ static const struct vga_regset s3_h_sync
 static const struct vga_regset s3_v_total_regs[]        = {{0x06, 0, 7}, {0x07, 0, 0}, {0x07, 5, 5}, {0x5E, 0, 0}, VGA_REGSET_END};
 static const struct vga_regset s3_v_display_regs[]      = {{0x12, 0, 7}, {0x07, 1, 1}, {0x07, 6, 6}, {0x5E, 1, 1}, VGA_REGSET_END};
 static const struct vga_regset s3_v_blank_start_regs[]  = {{0x15, 0, 7}, {0x07, 3, 3}, {0x09, 5, 5}, {0x5E, 2, 2}, VGA_REGSET_END};
-// const struct vga_regset s3_v_blank_end_regs[]    = {{0x16, 0, 6}, VGA_REGSET_END};
 static const struct vga_regset s3_v_blank_end_regs[]    = {{0x16, 0, 7}, VGA_REGSET_END};
 static const struct vga_regset s3_v_sync_start_regs[]   = {{0x10, 0, 7}, {0x07, 2, 2}, {0x07, 7, 7}, {0x5E, 4, 4}, VGA_REGSET_END};
 static const struct vga_regset s3_v_sync_end_regs[]     = {{0x11, 0, 3}, VGA_REGSET_END};
@@ -138,30 +136,36 @@ static const struct svga_timing_regs s3_
 static char *mode = "640x480-8@60";
 
 #ifdef CONFIG_MTRR
-static int mtrr   = 1;
+static int mtrr = 1;
 #endif
 
+static int fasttext = 1;
+
 #ifdef MODULE
 
 MODULE_AUTHOR("(c) 2006 Ondrej Zajicek <santiago@crfreenet.org>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("fbdev driver for S3 Trio/Virge");
 
-module_param(mode, charp, 0);
-MODULE_PARM_DESC(mode, "Preferred video mode ('640x480-8@60', etc)");
+module_param(mode, charp, 0444);
+MODULE_PARM_DESC(mode, "Default video mode ('640x480-8@60', etc)");
 
 #ifdef CONFIG_MTRR
-module_param(mtrr, int, 0);
+module_param(mtrr, int, 0444);
 MODULE_PARM_DESC(mtrr, "Enable write-combining with MTRR (1=enable, 0=disable, default=1)");
 #endif
 
+module_param(fasttext, int, 0644);
+MODULE_PARM_DESC(fasttext, "Enable S3 fast text mode (1=enable, 0=disable, default=1)");
+
 #endif
 
 /* ------------------------------------------------------------------------- */
 
-/* Set font in text (tileblit) mode */
+/* Set font in S3 fast text mode */
 
-void s3fb_settile(struct fb_info *info, struct fb_tilemap *map) {
+static void s3fb_settile_fast(struct fb_info *info, struct fb_tilemap *map)
+{
 	const u8 *font = map->data;
 	u8* fb = (u8 *) info->screen_base;
 	int i, c;
@@ -169,156 +173,35 @@ void s3fb_settile(struct fb_info *info, 
 	if ((map->width != 8) || (map->height != 16) ||
 	    (map->depth != 1) || (map->length != 256)) {
 	    	printk(KERN_ERR "fb%d: unsupported font parameters: width %d, height %d, depth %d, length %d\n",
-			map->width, map->height, map->depth, map->length, info->node);
+			info->node, map->width, map->height, map->depth, map->length);
 		return;
 	}
 
 	fb += 2;
-	for (c = 0; c < map->length; c++) {
-		for (i = 0; i < map->height; i++) {
-			fb[i * 4] = font[i];
-		}
-		fb += 128;
-		font += map->height;
-	}
-}
-
-/* Copy area in text (tileblit) mode */
-
-void s3fb_tilecopy(struct fb_info *info, struct fb_tilearea *area) {
-	int dx, dy;
-//	int colstride = 4;
-	int colstride = 2;
-	int rowstride = colstride * (info->var.xres_virtual / 8);
-	u16 *fb = (u16 *) info->screen_base;
-	u16 *src, *dst;
-
-	if ((area->sy > area->dy) ||
-	    ((area->sy == area->dy) && (area->sx > area->dx))) {
-		src = fb + area->sx * colstride + area->sy * rowstride;
-		dst = fb + area->dx * colstride + area->dy * rowstride;
-	    } else {
-		src = fb + (area->sx + area->width - 1) * colstride
-			 + (area->sy + area->height - 1) * rowstride;
-		dst = fb + (area->dx + area->width - 1) * colstride
-			 + (area->dy + area->height - 1) * rowstride;
-
-		colstride = -colstride;
-		rowstride = -rowstride;
-	    }
-
-	for (dy = 0; dy < area->height; dy++) {
-		u16* src2 = src;
-		u16* dst2 = dst;
-		for (dx = 0; dx < area->width; dx++) {
-			*dst2 = *src2;
-			src2 += colstride;
-			dst2 += colstride;
+	for (i = 0; i < map->height; i++) {
+		for (c = 0; c < map->length; c++) {
+			fb[c * 4] = font[c * map->height + i];
 		}
-		src += rowstride;
-		dst += rowstride;
+		fb += 1024;
 	}
 }
 
-/* Fill area in text (tileblit) mode */
-
-void s3fb_tilefill(struct fb_info *info, struct fb_tilerect *rect) {
-	int dx, dy;
-//	int colstride = 8;
-	int colstride = 4;
-	int rowstride = colstride * (info->var.xres_virtual / 8);
-	int attr = (0x0F & rect->bg) << 4 | (0x0F & rect->fg);
-	u8  *fb = (u8 *) info->screen_base;
-	fb += rect->sx * colstride + rect->sy * rowstride;
-
-	for (dy = 0; dy < rect->height; dy++) {
-		u8* fb2 = fb;
-		for (dx = 0; dx < rect->width; dx++) {
-			fb2[0] = rect->index;
-			fb2[1] = attr;
-			fb2 += colstride;
-		}
-		fb += rowstride;
-	}
-}
-
-/* Write text in text (tileblit) mode */
-
-void s3fb_tileblit(struct fb_info *info, struct fb_tileblit *blit) {
-	int dx, dy, i;
-//	int colstride = 8;
-	int colstride = 4;
-	int rowstride = colstride * (info->var.xres_virtual / 8);
-	int attr = (0x0F & blit->bg) << 4 | (0x0F & blit->fg);
-	u8* fb = (u8 *) info->screen_base;
-	fb += blit->sx * colstride + blit->sy * rowstride;
-
-	i=0;
-	for (dy=0; dy < blit->height; dy ++) {
-		u8* fb2 = fb;
-		for (dx = 0; dx < blit->width; dx ++) {
-			fb2[0] = blit->indices[i];
-			fb2[1] = attr;
-			fb2 += colstride;
-			i ++;
-			if (i == blit->length) return;
-		}
-		fb += rowstride;
-	}
-
-}
-
-/* Set cursor in text (tileblit) mode */
-
-void s3fb_tilecursor(struct fb_info *info, struct fb_tilecursor *cursor) {
-	u8 cs = 0x0d;
-	u8 ce = 0x0e;
-	u16 pos =  cursor->sx + (info->var.xoffset /  8)
-		+ (cursor->sy + (info->var.yoffset / 16))
-		   * (info->var.xres_virtual / 8);
-
-	if (! cursor -> mode)
-		return;
-
-	svga_wcrt_mask(0x0A, 0x20, 0x20); /* disable cursor */
-
-	if (cursor -> shape == FB_TILE_CURSOR_NONE)
-		return;
-
-	switch (cursor -> shape)
-	{
-		case FB_TILE_CURSOR_UNDERLINE:
-			cs = 0x0d;
-			break;
-		case FB_TILE_CURSOR_LOWER_THIRD:
-			cs = 0x09;
-			break;
-		case FB_TILE_CURSOR_LOWER_HALF:
-			cs = 0x07;
-			break;
-		case FB_TILE_CURSOR_TWO_THIRDS:
-			cs = 0x05;
-			break;
-		case FB_TILE_CURSOR_BLOCK:
-			cs = 0x01;
-			break;
-	}
-
-	/* set cursor position */
-	vga_wcrt(NULL, 0x0E, pos >> 8);
-	vga_wcrt(NULL, 0x0F, pos & 0xFF);
-
-	vga_wcrt(NULL, 0x0B, ce); /* set cursor end */
-	vga_wcrt(NULL, 0x0A, cs); /* set cursor start and enable it */
-}
 
 
 static struct fb_tile_ops s3fb_tile_ops = {
-	.fb_settile	= s3fb_settile,
-	.fb_tilecopy	= s3fb_tilecopy,
-	.fb_tilefill    = s3fb_tilefill,
-	.fb_tileblit    = s3fb_tileblit,
-	.fb_tilecursor  = s3fb_tilecursor,
+	.fb_settile	= svga_settile,
+	.fb_tilecopy	= svga_tilecopy,
+	.fb_tilefill    = svga_tilefill,
+	.fb_tileblit    = svga_tileblit,
+	.fb_tilecursor  = svga_tilecursor,
+};
+
+static struct fb_tile_ops s3fb_fast_tile_ops = {
+	.fb_settile	= s3fb_settile_fast,
+	.fb_tilecopy	= svga_tilecopy,
+	.fb_tilefill    = svga_tilefill,
+	.fb_tileblit    = svga_tileblit,
+	.fb_tilecursor  = svga_tilecursor,
 };
 
 
@@ -460,7 +343,7 @@ static void s3_set_pixclock(struct fb_in
 	udelay(1000);
 
 	/* Activate clock - write 0, 1, 0 to seq/15 bit 5 */
-	regval = vga_rseq (NULL, 0x15);
+	regval = vga_rseq (NULL, 0x15); /* | 0x80; */
 	vga_wseq(NULL, 0x15, regval & ~(1<<5));
 	vga_wseq(NULL, 0x15, regval |  (1<<5));
 	vga_wseq(NULL, 0x15, regval & ~(1<<5));
@@ -509,12 +392,13 @@ static int s3fb_release(struct fb_info *
 
 static int s3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	struct s3fb_info *par = (struct s3fb_info *) info;
 	int rv, mem, step;
 
 	/* Find appropriate format */
 	rv = svga_match_format (s3fb_formats, var, NULL);
-	if (rv < 0)
-	{
+	if ((rv < 0) || ((par->chip == CHIP_988_VIRGE_VX) ? (rv == 7) : (rv == 6)))
+	{		/* 24bpp on VIRGE VX, 32bpp on others */
 		printk(KERN_ERR "fb%d: unsupported mode requested\n", info->node);
 		return rv;
 	}
@@ -553,7 +437,7 @@ static int s3fb_check_var(struct fb_var_
 static int s3fb_set_par(struct fb_info *info)
 {
 	struct s3fb_info *par = (struct s3fb_info *) info;
-	u32 value, mode, hmul, offset_value, screen_size;
+	u32 value, mode, hmul, offset_value, screen_size, multiplex;
 	u32 bpp = info->var.bits_per_pixel;
 
 	if (bpp != 0) {
@@ -570,11 +454,10 @@ static int s3fb_set_par(struct fb_info *
 		info->fix.line_length = 0;
 
 		info->flags |= FBINFO_MISC_TILEBLITTING;
-		info->tileops = &s3fb_tile_ops;
+		info->tileops = fasttext ? &s3fb_fast_tile_ops : &s3fb_tile_ops;
 
 		offset_value = info->var.xres_virtual / 16;
 		screen_size = (info->var.xres_virtual * info->var.yres_virtual) / 64;
-		// FIXME test screen_size
 	}
 
 	info->var.xoffset = 0;
@@ -603,36 +486,27 @@ static int s3fb_set_par(struct fb_info *
 	svga_wcrt_mask(0x58, 0x10, 0x10); /* enable linear framebuffer */
 	svga_wcrt_mask(0x31, 0x08, 0x08); /* enable sequencer access to framebuffer above 256 kB */
 
-	svga_wcrt_mask(0x33, 0x08, 0x08); // DDR ?
-	svga_wcrt_mask(0x43, 0x01, 0x01); // DDR ?
-
+/*	svga_wcrt_mask(0x33, 0x08, 0x08); */ /* DDR ?	*/
+/*	svga_wcrt_mask(0x43, 0x01, 0x01); */ /* DDR ?	*/
+	svga_wcrt_mask(0x33, 0x00, 0x08); /* no DDR ?	*/
+	svga_wcrt_mask(0x43, 0x00, 0x01); /* no DDR ?	*/
 
-//	svga_wcrt_mask(0x58, 0x03, 0x03); /* XXX */
+	svga_wcrt_mask(0x5D, 0x00, 0x28); // Clear strange HSlen bits
 
-//	svga_wcrt_mask(0x53, 0x12, 0x13); /* enable MMIO */
-//	svga_wcrt_mask(0x40, 0x08, 0x08); /* enable write buffer */
-
-//	pr_debug "fb%d: MCLK reg values %x %x\n", info->node,
-//			  vga_rseq(NULL, 0x10), vga_rseq(NULL, 0x11));
+/*	svga_wcrt_mask(0x58, 0x03, 0x03); */
 
+/*	svga_wcrt_mask(0x53, 0x12, 0x13); */ /* enable MMIO */
+/*	svga_wcrt_mask(0x40, 0x08, 0x08); */ /* enable write buffer */
 
 
 	/* Set the offset register */
 	pr_debug("fb%d: offset register       : %d\n", info->node, offset_value);
 	svga_wcrt_multi(s3_offset_regs, offset_value);
 
-		/* Set the fetch count register */
-/*		value = (info->var.xres / 8) + 8;
-		pr_debug( "viafb: fetch count register  : %d\n", value);
-		via_wseq_multi(via_fetch_count_regs, value);
-*/
-
-
-//	vga_wcrt(NULL, 0x54, info->var.nonstd << 3); // M parameter 0x18
-	vga_wcrt(NULL, 0x54, 0x18); // M parameter 0x18
-	vga_wcrt(NULL, 0x60, 0xff); // N parameter
-	vga_wcrt(NULL, 0x61, 0xff); // L parameter
-	vga_wcrt(NULL, 0x62, 0xff); // L parameter
+	vga_wcrt(NULL, 0x54, 0x18); /* M parameter */
+	vga_wcrt(NULL, 0x60, 0xff); /* N parameter */
+	vga_wcrt(NULL, 0x61, 0xff); /* L parameter */
+	vga_wcrt(NULL, 0x62, 0xff); /* L parameter */
 
 	vga_wcrt(NULL, 0x3A, 0x35);
 	svga_wattr(0x33, 0x00);
@@ -652,14 +526,30 @@ static int s3fb_set_par(struct fb_info *
 	/* Disable Streams engine */
 	svga_wcrt_mask(0x67, 0x00, 0x0C);
 
+
+
+	mode = svga_match_format(s3fb_formats, &(info->var), &(info->fix));
+
 	/* S3 virge DX hack */
 	if (par->chip == CHIP_375_VIRGE_DX) {
 		vga_wcrt(NULL, 0x86, 0x80);
 		vga_wcrt(NULL, 0x90, 0x00);
 	}
 
+	/* S3 virge VX hack */
+	if (par->chip == CHIP_988_VIRGE_VX) {
+		vga_wcrt(NULL, 0x50, 0x00);
+		vga_wcrt(NULL, 0x67, 0x50);
+
+		vga_wcrt(NULL, 0x63, (mode <= 2) ? 0x90 : 0x09);
+		vga_wcrt(NULL, 0x66, 0x90);
+	}
+
+	svga_wcrt_mask(0x31, 0x00, 0x40);
+	multiplex = 0;
+	hmul = 1;
+
 	/* Set mode-specific register values */
-	mode = svga_match_format(s3fb_formats, &(info->var), &(info->fix));
 	switch (mode) {
 		case 0:
 			pr_debug("fb%d: text mode\n", info->node);
@@ -672,7 +562,10 @@ static int s3fb_set_par(struct fb_info *
 			/* Disable enhanced mode */
 			svga_wcrt_mask(0x3A, 0x00, 0x30);
 
-			hmul = 1;
+			if (fasttext) {
+				pr_debug("fb%d: high speed text mode set\n", info->node);
+				svga_wcrt_mask(0x31, 0x40, 0x40);
+			}
 		break;
 		case 1:
 			pr_debug("fb%d: 4 bit pseudocolor\n", info->node);
@@ -684,8 +577,6 @@ static int s3fb_set_par(struct fb_info *
 
 			/* disable enhanced mode */
 			svga_wcrt_mask(0x3A, 0x00, 0x30);
-
-			hmul = 1;
 		break;
 		case 2:
 			pr_debug("fb%d: 4 bit pseudocolor, planar\n", info->node);
@@ -696,57 +587,71 @@ static int s3fb_set_par(struct fb_info *
 
 			/* disable enhanced mode */
 			svga_wcrt_mask(0x3A, 0x00, 0x30);
-
-			hmul = 1;
 		break;
 		case 3:
 			pr_debug("fb%d: 8 bit pseudocolor\n", info->node);
-			svga_wcrt_mask(0x50, 0x00, 0x30);
-			svga_wcrt_mask(0x67, 0x00, 0xF0);
-			hmul = 1;
+			if (info->var.pixclock > 20000) {
+				svga_wcrt_mask(0x50, 0x00, 0x30);
+				svga_wcrt_mask(0x67, 0x00, 0xF0);
+			} else {
+				svga_wcrt_mask(0x50, 0x00, 0x30);
+				svga_wcrt_mask(0x67, 0x10, 0xF0);
+				multiplex = 1;
+			}
 		break;
 		case 4:
 			pr_debug("fb%d: 5/5/5 truecolor\n", info->node);
-			svga_wcrt_mask(0x50, 0x10, 0x30);
-			svga_wcrt_mask(0x67, 0x30, 0xF0);
-			hmul = 2;
+			if (par->chip == CHIP_988_VIRGE_VX) {
+				if (info->var.pixclock > 20000)
+					svga_wcrt_mask(0x67, 0x20, 0xF0);
+				else
+					svga_wcrt_mask(0x67, 0x30, 0xF0);
+			} else {
+				svga_wcrt_mask(0x50, 0x10, 0x30);
+				svga_wcrt_mask(0x67, 0x30, 0xF0);
+				hmul = 2;
+			}
 		break;
 		case 5:
 			pr_debug("fb%d: 5/6/5 truecolor\n", info->node);
-			svga_wcrt_mask(0x50, 0x10, 0x30);
-			svga_wcrt_mask(0x67, 0x50, 0xF0);
-			hmul = 2;
+			if (par->chip == CHIP_988_VIRGE_VX) {
+				if (info->var.pixclock > 20000)
+					svga_wcrt_mask(0x67, 0x40, 0xF0);
+				else
+					svga_wcrt_mask(0x67, 0x50, 0xF0);
+			} else {
+				svga_wcrt_mask(0x50, 0x10, 0x30);
+				svga_wcrt_mask(0x67, 0x50, 0xF0);
+				hmul = 2;
+			}
 		break;
 		case 6:
+			/* VIRGE VX case */
 			pr_debug("fb%d: 8/8/8 truecolor\n", info->node);
-			svga_wcrt_mask(0x50, 0x30, 0x30);
 			svga_wcrt_mask(0x67, 0xD0, 0xF0);
-			hmul = 1;
 		break;
 		case 7:
-/*
-			pr_debug("fb%d: 8/8/8 truecolor X\n", info->node);
+			pr_debug("fb%d: 8/8/8/8 truecolor\n", info->node);
 			svga_wcrt_mask(0x50, 0x30, 0x30);
-			svga_wcrt_mask(0x67, 0x70, 0xF0);
-*/
-			/* disable enhanced mode */
-			svga_wcrt_mask(0x3A, 0x00, 0x30);
-			/* swap nibbles */
-//			svga_wcrt_mask(0x53, 0x40, 0x40);
-
-//			svga_wattr(VGA_ATC_MODE, 0x41);
-			hmul = 1;
+			svga_wcrt_mask(0x67, 0xD0, 0xF0);
 		break;
 		default:
 			printk(KERN_ERR "fb%d: unsupported mode - bug\n", info->node);
 			return -EINVAL;
 	}
 
+	if (par->chip != CHIP_988_VIRGE_VX) {
+		svga_wseq_mask(0x15, multiplex ? 0x10 : 0x00, 0x10);
+		svga_wseq_mask(0x18, multiplex ? 0x80 : 0x00, 0x80);
+	}
+
 	s3_set_pixclock(info, info->var.pixclock);
 	svga_set_timings(&s3_timing_regs, &(info->var), hmul, 1,
 			 (info->var.vmode & FB_VMODE_DOUBLE)     ? 2 : 1,
 			 (info->var.vmode & FB_VMODE_INTERLACED) ? 2 : 1,
-			 info->node);
+			 hmul, info->node);
+
+
 
 	/* Set interlaced mode start/end register */
 	value = info->var.xres + info->var.left_margin + info->var.right_margin + info->var.hsync_len;
@@ -754,7 +659,6 @@ static int s3fb_set_par(struct fb_info *
 	vga_wcrt(NULL, 0x3C, (value + 1) / 2);
 
 	memset((u8*)info->screen_base, 0x00, screen_size);
-
 	/* Device and screen back on */
 	svga_wcrt_mask(0x17, 0x80, 0x80);
 	svga_wseq_mask(0x01, 0x00, 0x20);
@@ -783,9 +687,6 @@ static int s3fb_setcolreg(u_int regno, u
 			outb(red >> 10, VGA_PEL_D);
 			outb(green >> 10, VGA_PEL_D);
 			outb(blue >> 10, VGA_PEL_D);
-
-			((u32*)fb->pseudo_palette)[regno] = ((blue & 0xFF00) >> 8) |
-				(green & 0xFF00) | ((red & 0xFF00) << 8);
 		break;
 		case 8:
 			if (regno >= 256) return -EINVAL;
@@ -794,10 +695,6 @@ static int s3fb_setcolreg(u_int regno, u
 			outb(red >> 10, VGA_PEL_D);
 			outb(green >> 10, VGA_PEL_D);
 			outb(blue >> 10, VGA_PEL_D);
-			if (regno < 16)
-				((u32*)fb->pseudo_palette)[regno] = ((blue & 0xFF00) >> 8) |
-					(green & 0xFF00) | ((red & 0xFF00) << 8);
-
 		break;
 		case 16:
 			if (regno >= 16) return -EINVAL;
@@ -821,6 +718,7 @@ static int s3fb_setcolreg(u_int regno, u
 	return 0;
 }
 
+
 /* Set the display blanking state */
 
 static int s3fb_blank(int blank_mode, struct fb_info *info)
@@ -863,7 +761,7 @@ static int s3fb_pan_display(struct fb_va
 
 	unsigned int offset;
 
-	/* Validate the offsets - At the moment, only the Y offset can be changed */
+	/* Validate the offsets */
 	if ((var->xoffset + var->xres) > var->xres_virtual) return -EINVAL;
 	if ((var->yoffset + var->yres) > var->yres_virtual) return -EINVAL;
 
@@ -883,8 +781,6 @@ static int s3fb_pan_display(struct fb_va
 	return 0;
 }
 
-
-
 /* ------------------------------------------------------------------------- */
 
 /* Frame buffer operations */
@@ -945,6 +841,7 @@ static int __devinit s3_identification(i
 	return CHIP_UNKNOWN;
 }
 
+
 /* PCI probe */
 
 static int __devinit s3_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
@@ -954,6 +851,12 @@ static int __devinit s3_pci_probe(struct
 	int rc;
 	u8 regval, cr38, cr39;
 
+	/* Ignore secondary VGA device because there is no VGA arbitration */
+	if (! svga_primary_device(dev)) {
+		printk(KERN_INFO "s3fb: ignoring secondary device %s\n",  pci_name(dev));
+		return -ENODEV;
+	}
+
 	/* Allocate and fill driver data structure */
 
 	info = framebuffer_alloc(sizeof(struct s3fb_info), NULL);
@@ -1075,6 +978,7 @@ err_enable_device:
 	return rc;
 }
 
+
 /* PCI remove */
 
 static void __devexit s3_pci_remove(struct pci_dev *dev)
@@ -1105,13 +1009,12 @@ static void __devexit s3_pci_remove(stru
 
 /* PCI suspend */
 
-/*
-static int s3_pci_suspend (struct pci_dev* dev, pm_message_t state)
+static int s3_pci_suspend(struct pci_dev* dev, pm_message_t state)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
-	unsigned int count = atomic_read(&(((struct s3_info*)info)->par.ref_count));
+	unsigned int count = atomic_read(&(((struct s3fb_info *) info)->ref_count));
 
-	printk(KERN_INFO "fb%d: suspend\n");
+	printk(KERN_INFO "fb%d: suspend\n", info->node);
 
 	if ((state.event == PM_EVENT_FREEZE) || (!count)) {
 		return 0;
@@ -1127,16 +1030,16 @@ static int s3_pci_suspend (struct pci_de
 
 	return 0;
 }
-*/
+
 
 /* PCI resume */
-/*
-static int s3_pci_resume (struct pci_dev* dev)
+
+static int s3_pci_resume(struct pci_dev* dev)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
-	unsigned int count = atomic_read(&(((struct s3_info*)info)->par.ref_count));
+	unsigned int count = atomic_read(&(((struct s3fb_info *) info)->ref_count));
 
-	printk(KERN_INFO "fb%d: resume\n");
+	printk(KERN_INFO "fb%d: resume\n", info->node);
 
 	if (!count) {
 		return 0;
@@ -1148,13 +1051,13 @@ static int s3_pci_resume (struct pci_dev
 	pci_enable_device(dev);
 	pci_set_master(dev);
 
-	s3fb_set_par (info);
-	fb_set_suspend (info, 0);
+	s3fb_set_par(info);
+	fb_set_suspend(info, 0);
 	release_console_sem();
 
 	return 0;
 }
-*/
+
 
 /* List of boards that we are trying to support */
 
@@ -1177,18 +1080,15 @@ static struct pci_device_id s3_devices[]
 };
 
 
-
-
-
 MODULE_DEVICE_TABLE(pci, s3_devices);
 
 static struct pci_driver s3fb_pci_driver = {
-	name:"s3fb",
-	id_table:s3_devices,
-	probe:s3_pci_probe,
-	remove:__devexit_p(s3_pci_remove),
-//	suspend:s3_pci_suspend,
-//	resume:s3_pci_resume,
+	.name		= "s3fb",
+	.id_table	= s3_devices,
+	.probe		= s3_pci_probe,
+	.remove		= __devexit_p(s3_pci_remove),
+	.suspend	= s3_pci_suspend,
+	.resume		= s3_pci_resume,
 };
 
 /* Parse user speficied options */
@@ -1209,6 +1109,8 @@ static int  __init s3fb_setup(char *opti
 		else if (!strcmp(opt, "mtrr:"))
 			mtrr = simple_strtoul(opt + 5, NULL, 0);
 #endif
+		else if (!strcmp(opt, "fasttext:"))
+			mtrr = simple_strtoul(opt + 9, NULL, 0);
 		else
 			mode = opt;
 	}
@@ -1228,7 +1130,7 @@ static void __exit s3fb_cleanup(void)
 
 /* Driver Initialisation */
 
-int __init s3fb_init(void)
+static int __init s3fb_init(void)
 {
 
 #ifndef MODULE
diff -puN drivers/video/svgalib.c~fbdev-driver-for-s3-trio-virge-update drivers/video/svgalib.c
--- a/drivers/video/svgalib.c~fbdev-driver-for-s3-trio-virge-update
+++ a/drivers/video/svgalib.c
@@ -1,16 +1,15 @@
 /*
- *  Common utility functions for VGA-based graphics cards.
+ * Common utility functions for VGA-based graphics cards.
  *
- *  Copyright (c) 2006 Ondrej Zajicek <santiago@crfreenet.org>
+ * Copyright (c) 2006 Ondrej Zajicek <santiago@crfreenet.org>
  *
- *  This file is subject to the terms and conditions of the GNU General Public
- *  License.  See the file COPYING in the main directory of this archive for
- *  more details.
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive for
+ * more details.
  *
- *  Some parts are based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
+ * Some parts are based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
  */
 
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
@@ -22,7 +21,6 @@
 
 
 /* Write a CRT register value spread across multiple registers */
-
 void svga_wcrt_multi(const struct vga_regset *regset, u32 value) {
 
 	u8 regval, bitval, bitnum;
@@ -43,7 +41,6 @@ void svga_wcrt_multi(const struct vga_re
 }
 
 /* Write a sequence register value spread across multiple registers */
-
 void svga_wseq_multi(const struct vga_regset *regset, u32 value) {
 
 	u8 regval, bitval, bitnum;
@@ -63,7 +60,7 @@ void svga_wseq_multi(const struct vga_re
 	}
 }
 
-unsigned int svga_regset_size(const struct vga_regset *regset)
+static unsigned int svga_regset_size(const struct vga_regset *regset)
 {
 	u8 count = 0;
 
@@ -88,10 +85,10 @@ void svga_set_default_gfx_regs(void)
 	vga_wgfx(NULL, VGA_GFX_DATA_ROTATE, 0x00);
 	vga_wgfx(NULL, VGA_GFX_PLANE_READ, 0x00);
 	vga_wgfx(NULL, VGA_GFX_MODE, 0x00);
-//	vga_wgfx(NULL, VGA_GFX_MODE, 0x20);
-//	vga_wgfx(NULL, VGA_GFX_MODE, 0x40);
+/*	vga_wgfx(NULL, VGA_GFX_MODE, 0x20); */
+/*	vga_wgfx(NULL, VGA_GFX_MODE, 0x40); */
 	vga_wgfx(NULL, VGA_GFX_MISC, 0x05);
-//	vga_wgfx(NULL, VGA_GFX_MISC, 0x01);
+/*	vga_wgfx(NULL, VGA_GFX_MISC, 0x01); */
 	vga_wgfx(NULL, VGA_GFX_COMPARE_MASK, 0x0F);
 	vga_wgfx(NULL, VGA_GFX_BIT_MASK, 0xFF);
 }
@@ -99,17 +96,23 @@ void svga_set_default_gfx_regs(void)
 /* Set attribute controller registers to sane values */
 void svga_set_default_atc_regs(void)
 {
+	vga_r(NULL, 0x3DA);
+	vga_w(NULL, VGA_ATT_W, 0x00);
+
 	/* All standard ATC registers (AR00 - AR14) */
 	u8 count;
 	for (count = 0; count <= 0xF; count ++)
 		svga_wattr(count, count);
 
 	svga_wattr(VGA_ATC_MODE, 0x01);
-//	svga_wattr(VGA_ATC_MODE, 0x41);
+/*	svga_wattr(VGA_ATC_MODE, 0x41); */
 	svga_wattr(VGA_ATC_OVERSCAN, 0x00);
 	svga_wattr(VGA_ATC_PLANE_ENABLE, 0x0F);
 	svga_wattr(VGA_ATC_PEL, 0x00);
 	svga_wattr(VGA_ATC_COLOR_PAGE, 0x00);
+
+	vga_r(NULL, 0x3DA);
+	vga_w(NULL, VGA_ATT_W, 0x20);
 }
 
 /* Set sequencer registers to sane values */
@@ -119,7 +122,7 @@ void svga_set_default_seq_regs(void)
 	vga_wseq(NULL, VGA_SEQ_CLOCK_MODE, VGA_SR01_CHAR_CLK_8DOTS);
 	vga_wseq(NULL, VGA_SEQ_PLANE_WRITE, VGA_SR02_ALL_PLANES);
 	vga_wseq(NULL, VGA_SEQ_CHARACTER_MAP, 0x00);
-//	vga_wseq(NULL, VGA_SEQ_MEMORY_MODE, VGA_SR04_EXT_MEM | VGA_SR04_SEQ_MODE | VGA_SR04_CHN_4M);
+/*	vga_wseq(NULL, VGA_SEQ_MEMORY_MODE, VGA_SR04_EXT_MEM | VGA_SR04_SEQ_MODE | VGA_SR04_CHN_4M); */
 	vga_wseq(NULL, VGA_SEQ_MEMORY_MODE, VGA_SR04_EXT_MEM | VGA_SR04_SEQ_MODE);
 }
 
@@ -163,6 +166,7 @@ void svga_set_textmode_vga_regs(void)
 	vga_w(NULL, VGA_ATT_W, 0x20);
 }
 
+#if 0
 void svga_dump_var(struct fb_var_screeninfo *var, int node)
 {
 	pr_debug("fb%d: var.vmode         : 0x%X\n", node, var->vmode);
@@ -180,6 +184,162 @@ void svga_dump_var(struct fb_var_screeni
 	pr_debug("fb%d: var.sync          : 0x%X\n", node, var->sync);
 	pr_debug("fb%d: var.pixclock      : %d\n\n", node, var->pixclock);
 }
+#endif  /*  0  */
+
+
+/* ------------------------------------------------------------------------- */
+
+
+void svga_settile(struct fb_info *info, struct fb_tilemap *map)
+{
+	const u8 *font = map->data;
+	u8* fb = (u8 *) info->screen_base;
+	int i, c;
+
+	if ((map->width != 8) || (map->height != 16) ||
+	    (map->depth != 1) || (map->length != 256)) {
+	    	printk(KERN_ERR "fb%d: unsupported font parameters: width %d, height %d, depth %d, length %d\n",
+			info->node, map->width, map->height, map->depth, map->length);
+		return;
+	}
+
+	fb += 2;
+	for (c = 0; c < map->length; c++) {
+		for (i = 0; i < map->height; i++) {
+			fb[i * 4] = font[i];
+		}
+		fb += 128;
+		font += map->height;
+	}
+}
+
+/* Copy area in text (tileblit) mode */
+void svga_tilecopy(struct fb_info *info, struct fb_tilearea *area)
+{
+	int dx, dy;
+	/*  colstride is halved in this function because u16 are used */
+	int colstride = 1 << (info->fix.type_aux & FB_AUX_TEXT_SVGA_MASK);
+	int rowstride = colstride * (info->var.xres_virtual / 8);
+	u16 *fb = (u16 *) info->screen_base;
+	u16 *src, *dst;
+
+	if ((area->sy > area->dy) ||
+	    ((area->sy == area->dy) && (area->sx > area->dx))) {
+		src = fb + area->sx * colstride + area->sy * rowstride;
+		dst = fb + area->dx * colstride + area->dy * rowstride;
+	    } else {
+		src = fb + (area->sx + area->width - 1) * colstride
+			 + (area->sy + area->height - 1) * rowstride;
+		dst = fb + (area->dx + area->width - 1) * colstride
+			 + (area->dy + area->height - 1) * rowstride;
+
+		colstride = -colstride;
+		rowstride = -rowstride;
+	    }
+
+	for (dy = 0; dy < area->height; dy++) {
+		u16* src2 = src;
+		u16* dst2 = dst;
+		for (dx = 0; dx < area->width; dx++) {
+			*dst2 = *src2;
+			src2 += colstride;
+			dst2 += colstride;
+		}
+		src += rowstride;
+		dst += rowstride;
+	}
+}
+
+/* Fill area in text (tileblit) mode */
+void svga_tilefill(struct fb_info *info, struct fb_tilerect *rect)
+{
+	int dx, dy;
+	int colstride = 2 << (info->fix.type_aux & FB_AUX_TEXT_SVGA_MASK);
+	int rowstride = colstride * (info->var.xres_virtual / 8);
+	int attr = (0x0F & rect->bg) << 4 | (0x0F & rect->fg);
+	u8  *fb = (u8 *) info->screen_base;
+	fb += rect->sx * colstride + rect->sy * rowstride;
+
+	for (dy = 0; dy < rect->height; dy++) {
+		u8* fb2 = fb;
+		for (dx = 0; dx < rect->width; dx++) {
+			fb2[0] = rect->index;
+			fb2[1] = attr;
+			fb2 += colstride;
+		}
+		fb += rowstride;
+	}
+}
+
+/* Write text in text (tileblit) mode */
+void svga_tileblit(struct fb_info *info, struct fb_tileblit *blit)
+{
+	int dx, dy, i;
+	int colstride = 2 << (info->fix.type_aux & FB_AUX_TEXT_SVGA_MASK);
+	int rowstride = colstride * (info->var.xres_virtual / 8);
+	int attr = (0x0F & blit->bg) << 4 | (0x0F & blit->fg);
+	u8* fb = (u8 *) info->screen_base;
+	fb += blit->sx * colstride + blit->sy * rowstride;
+
+	i=0;
+	for (dy=0; dy < blit->height; dy ++) {
+		u8* fb2 = fb;
+		for (dx = 0; dx < blit->width; dx ++) {
+			fb2[0] = blit->indices[i];
+			fb2[1] = attr;
+			fb2 += colstride;
+			i ++;
+			if (i == blit->length) return;
+		}
+		fb += rowstride;
+	}
+
+}
+
+/* Set cursor in text (tileblit) mode */
+void svga_tilecursor(struct fb_info *info, struct fb_tilecursor *cursor)
+{
+	u8 cs = 0x0d;
+	u8 ce = 0x0e;
+	u16 pos =  cursor->sx + (info->var.xoffset /  8)
+		+ (cursor->sy + (info->var.yoffset / 16))
+		   * (info->var.xres_virtual / 8);
+
+	if (! cursor -> mode)
+		return;
+
+	svga_wcrt_mask(0x0A, 0x20, 0x20); /* disable cursor */
+
+	if (cursor -> shape == FB_TILE_CURSOR_NONE)
+		return;
+
+	switch (cursor -> shape)
+	{
+		case FB_TILE_CURSOR_UNDERLINE:
+			cs = 0x0d;
+			break;
+		case FB_TILE_CURSOR_LOWER_THIRD:
+			cs = 0x09;
+			break;
+		case FB_TILE_CURSOR_LOWER_HALF:
+			cs = 0x07;
+			break;
+		case FB_TILE_CURSOR_TWO_THIRDS:
+			cs = 0x05;
+			break;
+		case FB_TILE_CURSOR_BLOCK:
+			cs = 0x01;
+			break;
+	}
+
+	/* set cursor position */
+	vga_wcrt(NULL, 0x0E, pos >> 8);
+	vga_wcrt(NULL, 0x0F, pos & 0xFF);
+
+	vga_wcrt(NULL, 0x0B, ce); /* set cursor end */
+	vga_wcrt(NULL, 0x0A, cs); /* set cursor start and enable it */
+}
+
 
 /* ------------------------------------------------------------------------- */
 
@@ -263,45 +423,45 @@ int svga_check_timings(const struct svga
 	var->right_margin = (var->right_margin+7)&~7;
 	var->hsync_len    = (var->hsync_len+7)&~7;
 
-	// Check horizontal total
+	/* Check horizontal total */
 	value = var->xres + var->left_margin + var->right_margin + var->hsync_len;
 	if (((value / 8) - 5) >= svga_regset_size (tm->h_total_regs)) return -EINVAL;
 
-	// Check horizontal display and blank start
+	/* Check horizontal display and blank start */
 	value = var->xres;
 	if (((value / 8) - 1) >= svga_regset_size (tm->h_display_regs)) return -EINVAL;
 	if (((value / 8) - 1) >= svga_regset_size (tm->h_blank_start_regs)) return -EINVAL;
 
-	// Check horizontal sync start
+	/* Check horizontal sync start */
 	value = var->xres + var->right_margin;
 	if (((value / 8) - 1) >= svga_regset_size (tm->h_sync_start_regs)) return -EINVAL;
 
-	// Check horizontal blank end (or length)
+	/* Check horizontal blank end (or length) */
 	value = var->left_margin + var->right_margin + var->hsync_len;
 	if ((value == 0) || ((value / 8) >= svga_regset_size (tm->h_blank_end_regs))) return -EINVAL;
 
-	// Check horizontal sync end (or length)
+	/* Check horizontal sync end (or length) */
 	value = var->hsync_len;
 	if ((value == 0) || ((value / 8) >= svga_regset_size (tm->h_sync_end_regs))) return -EINVAL;
 
-	// Check vertical total
+	/* Check vertical total */
 	value = var->yres + var->upper_margin + var->lower_margin + var->vsync_len;
 	if ((value - 1) >= svga_regset_size(tm->v_total_regs)) return -EINVAL;
 
-	// Check vertical display and blank start
+	/* Check vertical display and blank start */
 	value = var->yres;
 	if ((value - 1) >= svga_regset_size(tm->v_display_regs)) return -EINVAL;
 	if ((value - 1) >= svga_regset_size(tm->v_blank_start_regs)) return -EINVAL;
 
-	// Check vertical sync start
+	/* Check vertical sync start */
 	value = var->yres + var->lower_margin;
 	if ((value - 1) >= svga_regset_size(tm->v_sync_start_regs)) return -EINVAL;
 
-	// Check vertical blank end (or length)
+	/* Check vertical blank end (or length) */
 	value = var->upper_margin + var->lower_margin + var->vsync_len;
 	if ((value == 0) || (value >= svga_regset_size (tm->v_blank_end_regs))) return -EINVAL;
 
-	// Check vertical sync end  (or length)
+	/* Check vertical sync end  (or length) */
 	value = var->vsync_len;
 	if ((value == 0) || (value >= svga_regset_size (tm->v_sync_end_regs))) return -EINVAL;
 
@@ -310,7 +470,7 @@ int svga_check_timings(const struct svga
 
 /* Set CRT timing registers */
 void svga_set_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var,
-			u32 hmul, u32 hdiv, u32 vmul, u32 vdiv, int node)
+			u32 hmul, u32 hdiv, u32 vmul, u32 vdiv, u32 hborder, int node)
 {
 	u8 regval;
 	u32 value;
@@ -318,8 +478,7 @@ void svga_set_timings(const struct svga_
 	value = var->xres + var->left_margin + var->right_margin + var->hsync_len;
 	value = (value * hmul) / hdiv;
 	pr_debug("fb%d: horizontal total      : %d\n", node, value);
-	svga_wcrt_multi(tm->h_total_regs, (value / 8));
-	vga_wcrt(NULL, 0x3B, (value / 8) - 5);
+	svga_wcrt_multi(tm->h_total_regs, (value / 8) - 5);
 
 	value = var->xres;
 	value = (value * hmul) / hdiv;
@@ -329,22 +488,22 @@ void svga_set_timings(const struct svga_
 	value = var->xres;
 	value = (value * hmul) / hdiv;
 	pr_debug("fb%d: horizontal blank start: %d\n", node, value);
-	svga_wcrt_multi(tm->h_blank_start_regs, (value / 8));
+	svga_wcrt_multi(tm->h_blank_start_regs, (value / 8) - 1 + hborder);
 
 	value = var->xres + var->left_margin + var->right_margin + var->hsync_len;
 	value = (value * hmul) / hdiv;
 	pr_debug("fb%d: horizontal blank end  : %d\n", node, value);
-	svga_wcrt_multi(tm->h_blank_end_regs, (value / 8) - 2); /* really -2 ? */
+	svga_wcrt_multi(tm->h_blank_end_regs, (value / 8) - 1 - hborder);
 
 	value = var->xres + var->right_margin;
 	value = (value * hmul) / hdiv;
 	pr_debug("fb%d: horizontal sync start : %d\n", node, value);
-	svga_wcrt_multi(tm->h_sync_start_regs, (value / 8) + 2); /* why not -1 ? */
+	svga_wcrt_multi(tm->h_sync_start_regs, (value / 8));
 
 	value = var->xres + var->right_margin + var->hsync_len;
 	value = (value * hmul) / hdiv;
 	pr_debug("fb%d: horizontal sync end   : %d\n", node, value);
-	svga_wcrt_multi(tm->h_sync_end_regs, (value / 8) + 1); /* why not -1 ? */
+	svga_wcrt_multi(tm->h_sync_end_regs, (value / 8));
 
 	value = var->yres + var->upper_margin + var->lower_margin + var->vsync_len;
 	value = (value * vmul) / vdiv;
@@ -364,17 +523,17 @@ void svga_set_timings(const struct svga_
 	value = var->yres + var->upper_margin + var->lower_margin + var->vsync_len;
 	value = (value * vmul) / vdiv;
 	pr_debug("fb%d: vertical blank end    : %d\n", node, value);
-	svga_wcrt_multi(tm->v_blank_end_regs, value - 2); /* really -2 ? */
+	svga_wcrt_multi(tm->v_blank_end_regs, value - 2);
 
 	value = var->yres + var->lower_margin;
 	value = (value * vmul) / vdiv;
 	pr_debug("fb%d: vertical sync start   : %d\n", node, value);
-	svga_wcrt_multi(tm->v_sync_start_regs, value - 1);
+	svga_wcrt_multi(tm->v_sync_start_regs, value);
 
 	value = var->yres + var->lower_margin + var->vsync_len;
 	value = (value * vmul) / vdiv;
 	pr_debug("fb%d: vertical sync end     : %d\n", node, value);
-	svga_wcrt_multi(tm->v_sync_end_regs, value - 1);
+	svga_wcrt_multi(tm->v_sync_end_regs, value);
 
 	/* Set horizontal and vertical sync pulse polarity in misc register */
 
@@ -433,9 +592,8 @@ int svga_match_format(const struct svga_
 }
 
 
-EXPORT_SYMBOL(svga_wseq_multi);
 EXPORT_SYMBOL(svga_wcrt_multi);
-EXPORT_SYMBOL(svga_regset_size);
+EXPORT_SYMBOL(svga_wseq_multi);
 
 EXPORT_SYMBOL(svga_set_default_gfx_regs);
 EXPORT_SYMBOL(svga_set_default_atc_regs);
@@ -443,7 +601,11 @@ EXPORT_SYMBOL(svga_set_default_seq_regs)
 EXPORT_SYMBOL(svga_set_default_crt_regs);
 EXPORT_SYMBOL(svga_set_textmode_vga_regs);
 
-EXPORT_SYMBOL(svga_dump_var);
+EXPORT_SYMBOL(svga_settile);
+EXPORT_SYMBOL(svga_tilecopy);
+EXPORT_SYMBOL(svga_tilefill);
+EXPORT_SYMBOL(svga_tileblit);
+EXPORT_SYMBOL(svga_tilecursor);
 
 EXPORT_SYMBOL(svga_compute_pll);
 EXPORT_SYMBOL(svga_check_timings);
diff -puN include/linux/fb.h~fbdev-driver-for-s3-trio-virge-update include/linux/fb.h
--- a/include/linux/fb.h~fbdev-driver-for-s3-trio-virge-update
+++ a/include/linux/fb.h
@@ -49,6 +49,13 @@
 #define FB_AUX_TEXT_S3_MMIO	2	/* S3 MMIO fasttext */
 #define FB_AUX_TEXT_MGA_STEP16	3	/* MGA Millenium I: text, attr, 14 reserved bytes */
 #define FB_AUX_TEXT_MGA_STEP8	4	/* other MGAs:      text, attr,  6 reserved bytes */
+#define FB_AUX_TEXT_SVGA_GROUP	8	/* 8-15: SVGA tileblit compatible modes */
+#define FB_AUX_TEXT_SVGA_MASK	7	/* lower three bits says step */
+#define FB_AUX_TEXT_SVGA_STEP2	8	/* SVGA text mode:  text, attr */
+#define FB_AUX_TEXT_SVGA_STEP4	9	/* SVGA text mode:  text, attr,  2 reserved bytes */
+#define FB_AUX_TEXT_SVGA_STEP8	10	/* SVGA text mode:  text, attr,  6 reserved bytes */
+#define FB_AUX_TEXT_SVGA_STEP16	11	/* SVGA text mode:  text, attr, 14 reserved bytes */
+#define FB_AUX_TEXT_SVGA_LAST	15	/* reserved up to 15 */
 
 #define FB_AUX_VGA_PLANES_VGA4		0	/* 16 color planes (EGA/VGA) */
 #define FB_AUX_VGA_PLANES_CFB4		1	/* CFB4 in planes (VGA) */
diff -puN include/linux/svga.h~fbdev-driver-for-s3-trio-virge-update include/linux/svga.h
--- a/include/linux/svga.h~fbdev-driver-for-s3-trio-virge-update
+++ a/include/linux/svga.h
@@ -3,6 +3,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/pci.h>
 #include <video/vga.h>
 
 /* Terminator for register set */
@@ -68,8 +69,8 @@ struct svga_pll {
 
 /* Write a value to the attribute register */
 
-static inline void svga_wattr(u8 index, u8 data) {
-
+static inline void svga_wattr(u8 index, u8 data)
+{
 	inb(0x3DA);
 	outb(index, 0x3C0);
 	outb(data, 0x3C0);
@@ -77,22 +78,28 @@ static inline void svga_wattr(u8 index, 
 
 /* Write a value to a sequence register with a mask */
 
-static inline void svga_wseq_mask(u8 index, u8 data, u8 mask) {
-
+static inline void svga_wseq_mask(u8 index, u8 data, u8 mask)
+{
 	vga_wseq(NULL, index, (data & mask) | (vga_rseq(NULL, index) & ~mask));
 }
 
 /* Write a value to a CRT register with a mask */
 
-static inline void svga_wcrt_mask(u8 index, u8 data, u8 mask) {
-
+static inline void svga_wcrt_mask(u8 index, u8 data, u8 mask)
+{
 	vga_wcrt(NULL, index, (data & mask) | (vga_rcrt(NULL, index) & ~mask));
 }
 
+static inline int svga_primary_device(struct pci_dev *dev)
+{
+	u16 flags;
+	pci_read_config_word(dev, PCI_COMMAND, &flags);
+	return (flags & PCI_COMMAND_IO);
+}
+
 
 void svga_wcrt_multi(const struct vga_regset *regset, u32 value);
 void svga_wseq_multi(const struct vga_regset *regset, u32 value);
-unsigned int svga_regset_size(const struct vga_regset *regset);
 
 void svga_set_default_gfx_regs(void);
 void svga_set_default_atc_regs(void);
@@ -100,11 +107,15 @@ void svga_set_default_seq_regs(void);
 void svga_set_default_crt_regs(void);
 void svga_set_textmode_vga_regs(void);
 
-void svga_dump_var(struct fb_var_screeninfo *var, int node);
+void svga_settile(struct fb_info *info, struct fb_tilemap *map);
+void svga_tilecopy(struct fb_info *info, struct fb_tilearea *area);
+void svga_tilefill(struct fb_info *info, struct fb_tilerect *rect);
+void svga_tileblit(struct fb_info *info, struct fb_tileblit *blit);
+void svga_tilecursor(struct fb_info *info, struct fb_tilecursor *cursor);
 
 int svga_compute_pll(const struct svga_pll *pll, u32 f_wanted, u16 *m, u16 *n, u16 *r, int node);
 int svga_check_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var, int node);
-void svga_set_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var, u32 hmul, u32 hdiv, u32 vmul, u32 vdiv, int node);
+void svga_set_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var, u32 hmul, u32 hdiv, u32 vmul, u32 vdiv, u32 hborder, int node);
 
 int svga_match_format(const struct svga_fb_format *frm, struct fb_var_screeninfo *var, struct fb_fix_screeninfo *fix);
 
_

Patches currently in -mm which might be from santiago@crfreenet.org are

fbdev-driver-for-s3-trio-virge.patch
fbdev-driver-for-s3-trio-virge-update.patch
