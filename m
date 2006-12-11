From: akpm@osdl.org
Subject: + fbdev-driver-for-s3-trio-virge.patch added to -mm tree
Date: Mon, 11 Dec 2006 14:31:04 -0800
Message-ID: <200612112231.kBBMV5G6010504@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43575 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937683AbWLKWbZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 17:31:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santiago@crfreenet.org, jsimmons@infradead.org


The patch titled
     fbdev driver for S3 Trio/Virge
has been added to the -mm tree.  Its filename is
     fbdev-driver-for-s3-trio-virge.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev driver for S3 Trio/Virge
From: Ondrej Zajicek <santiago@crfreenet.org>

Add a driver for S3 Trio / S3 Virge.  Driver is tested with most versions
of S3 Trio and with S3 Virge/DX, on i386.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/fb/s3fb.txt |   75 ++
 drivers/video/Kconfig     |   21 
 drivers/video/Makefile    |    2 
 drivers/video/s3fb.c      | 1251 ++++++++++++++++++++++++++++++++++++
 drivers/video/svgalib.c   |  455 +++++++++++++
 include/linux/svga.h      |  113 +++
 6 files changed, 1917 insertions(+)

diff -puN /dev/null Documentation/fb/s3fb.txt
--- /dev/null
+++ a/Documentation/fb/s3fb.txt
@@ -0,0 +1,75 @@
+
+	s3fb - fbdev driver for S3 Trio/Virge chips
+	===========================================
+
+
+Supported Hardware
+==================
+
+	S3 Trio32
+	S3 Trio64 (and variants V+, UV+, V2/DX, V2/GX)
+	S3 Virge  (and variants VX, DX, GX and GX2+)
+	S3 Plato/PX		(completely untested)
+	S3 Aurora64V+		(completely untested)
+
+	- only PCI bus supported
+	- only BIOS initialized VGA devices supported
+	- probably not working on big endian
+
+I tested s3fb on Trio64 (plain, V+ and V2/DX) and Virge DX, all on i386.
+
+
+Supported Features
+==================
+
+	*  4 bpp pseudocolor modes (with 18bit palette, two variants)
+	*  8 bpp pseudocolor mode (with 18bit palette)
+	* 16 bpp truecolor modes (RGB 555 and RGB 565)
+	* 32 bpp truecolor mode (RGB 888)
+	* text mode (activated by bpp = 0)
+	* interlaced mode variant (not available in text mode)
+	* doublescan mode variant (not available in text mode)
+	* panning in both directions
+	* DPMS support
+
+Text mode is supported even in higher resolutions, but there is limitation
+to lower pixclocks (maximum between 50-60 MHz, depending on specific hardware).
+This limitation is not enforced by driver. Text mode supports 8bit wide fonts
+only (hardware limitation) and 16bit tall fonts (driver limitation).
+
+There are two 4 bpp modes. First mode (selected if nonstd == 0) is mode with
+packed pixels, high nibble first. Second mode (selected if nonstd == 1) is mode
+with interleaved planes (1 byte interleave), MSB first. Both modes support
+8bit wide fonts only (driver limitation).
+
+
+Missing Features
+================
+(alias TODO list)
+
+	* secondary (not initialized by BIOS) device support
+	* suspend/resume support
+   	* big endian support
+	* Zorro bus support
+	* MMIO support
+	* 24 bpp mode support
+	* support for fontwidths != 8 in 4 bpp modes
+	* support for fontheight != 16 in text mode
+	* composite and external sync (is anyone able to test this?)
+	* hardware cursor
+	* video overlay support
+	* vsync synchronization
+	* feature connector support
+	* acceleration support (8514-like 2D, Virge 3D, busmaster transfers)
+	* better values for some magic registers (performance issues)
+
+
+Known bugs
+==========
+
+	* cursor disable in text mode doesn't work
+	* there is some small (but larger than usual) difference between
+	  requested and used timings
+
+--
+Ondrej Zajicek <santiago@crfreenet.org>
diff -puN drivers/video/Kconfig~fbdev-driver-for-s3-trio-virge drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-driver-for-s3-trio-virge
+++ a/drivers/video/Kconfig
@@ -92,6 +92,14 @@ config FB_CFB_IMAGEBLIT
 	  blitting. This is used by drivers that don't provide their own
 	  (accelerated) version.
 
+config FB_SVGALIB
+	tristate
+	depends on FB
+	default n
+	---help---
+	  Common utility functions useful to fbdev drivers of VGA-based
+	  cards.
+
 config FB_MACMODES
        tristate
        depends on FB
@@ -1151,6 +1159,17 @@ config FB_S3TRIO
 	help
 	  If you have a S3 Trio say Y. Say N for S3 Virge.
 
+config FB_S3
+	tristate "S3 Trio/Virge support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_TILEBLITTING
+	select FB_SVGALIB
+	---help---
+	  Driver for graphics boards with S3 Trio / S3 Virge chip.
+
 config FB_SAVAGE
 	tristate "S3 Savage support"
 	depends on FB && PCI && EXPERIMENTAL
@@ -1189,6 +1208,7 @@ config FB_SAVAGE_ACCEL
           the resulting framebuffer console has bothersome glitches, then
           choose N here.
 
+
 config FB_SIS
 	tristate "SiS/XGI display support"
 	depends on FB && PCI
@@ -1336,6 +1356,7 @@ config FB_TRIDENT_ACCEL
 	This will compile the Trident frame buffer device with
 	acceleration functions.
 
+
 config FB_PM3
 	tristate "Permedia3 support"
 	depends on FB && PCI && BROKEN
diff -puN drivers/video/Makefile~fbdev-driver-for-s3-trio-virge drivers/video/Makefile
--- a/drivers/video/Makefile~fbdev-driver-for-s3-trio-virge
+++ a/drivers/video/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_SYSFS)		  += backlight/
 obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
 obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
 obj-$(CONFIG_FB_CFB_IMAGEBLIT) += cfbimgblt.o
+obj-$(CONFIG_FB_SVGALIB)       += svgalib.o
 obj-$(CONFIG_FB_MACMODES)      += macmodes.o
 obj-$(CONFIG_FB_DDC)           += fb_ddc.o
 
@@ -54,6 +55,7 @@ obj-$(CONFIG_FB_S3TRIO)           += S3t
 obj-$(CONFIG_FB_FM2)              += fm2fb.o
 obj-$(CONFIG_FB_CYBLA)            += cyblafb.o
 obj-$(CONFIG_FB_TRIDENT)          += tridentfb.o
+obj-$(CONFIG_FB_S3)               += s3fb.o vgastate.o
 obj-$(CONFIG_FB_STI)              += stifb.o
 obj-$(CONFIG_FB_FFB)              += ffb.o sbuslib.o
 obj-$(CONFIG_FB_CG6)              += cg6.o sbuslib.o
diff -puN /dev/null drivers/video/s3fb.c
--- /dev/null
+++ a/drivers/video/s3fb.c
@@ -0,0 +1,1251 @@
+/*
+*  linux/drivers/video/s3fb.c -- Frame buffer device driver for S3 Trio32/64
+*
+*  Copyright (c) 2006 Ondrej Zajicek <santiago@crfreenet.org>
+*
+*  This file is subject to the terms and conditions of the GNU General Public
+*  License.  See the file COPYING in the main directory of this archive for
+*  more details.
+*
+*  Code is based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
+*  which is based on the code of neofb.
+*/
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/tty.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/svga.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+// #include <linux/console.h> /* Why should fb driver call console functions? strange ...*/
+#include <video/vga.h>
+
+#ifdef CONFIG_MTRR
+#include <asm/mtrr.h>
+#endif
+
+struct s3fb_info {
+	struct fb_info fb;
+
+	int chip, rev, mclk_freq;
+	int mtrr_reg;
+	struct vgastate state;
+	atomic_t ref_count;
+	u32 pseudo_palette[16];
+};
+
+
+/* ------------------------------------------------------------------------- */
+
+static const struct svga_fb_format s3fb_formats[] = {
+	{ 0,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
+		FB_TYPE_TEXT, 5,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
+	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
+		FB_TYPE_PACKED_PIXELS, 0,	FB_VISUAL_PSEUDOCOLOR, 8, 16},
+	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 1,
+		FB_TYPE_INTERLEAVED_PLANES, 1,	FB_VISUAL_PSEUDOCOLOR, 8, 16},
+	{ 8,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
+		FB_TYPE_PACKED_PIXELS, 0,	FB_VISUAL_PSEUDOCOLOR, 4, 8},
+	{16,  {10, 5, 0}, {5, 5, 0},  {0, 5, 0}, {0, 0, 0}, 0,
+		FB_TYPE_PACKED_PIXELS, 0,	FB_VISUAL_TRUECOLOR, 2, 4},
+	{16,  {11, 5, 0}, {5, 6, 0},  {0, 5, 0}, {0, 0, 0}, 0,
+		FB_TYPE_PACKED_PIXELS, 0,	FB_VISUAL_TRUECOLOR, 2, 4},
+	{32,  {16, 8, 0}, {8, 8, 0},  {0, 8, 0}, {0, 0, 0}, 0,
+		FB_TYPE_PACKED_PIXELS, 0,	FB_VISUAL_TRUECOLOR, 1, 2},
+	SVGA_FORMAT_END
+};
+
+//	{24,  {16, 8, 0}, {8, 8, 0},  {0, 8, 0}, {0, 0, 0}, 0,
+//	 FB_TYPE_PACKED_PIXELS,	0, FB_VISUAL_TRUECOLOR, 4, 8},
+
+
+static const struct svga_pll s3_pll = {3, 129, 3, 33, 0, 3,
+	60000, 240000, 14318};
+
+static const int s3_memsizes[] = {4096, 0, 3072, 8192, 2048, 6144, 1024, 512};
+
+static const char * const s3_names[] = {"S3 Unknown", "S3 Trio32", "S3 Trio64", "S3 Trio64V+",
+			"S3 Trio64UV+", "S3 Trio64V2/DX", "S3 Trio64V2/GX",
+			"S3 Plato/PX", "S3 Aurora64VP", "S3 Virge",
+			"S3 Virge/VX", "S3 Virge/DX", "S3 Virge/GX",
+			"S3 Virge/GX2", "S3 Virge/GX2P", "S3 Virge/GX2P"};
+
+#define CHIP_UNKNOWN		0x00
+#define CHIP_732_TRIO32 	0x01
+#define CHIP_764_TRIO64		0x02
+#define CHIP_765_TRIO64VP	0x03
+#define CHIP_767_TRIO64UVP	0x04
+#define	CHIP_775_TRIO64V2_DX	0x05
+#define	CHIP_785_TRIO64V2_GX	0x06
+#define CHIP_551_PLATO_PX	0x07
+#define CHIP_M65_AURORA64VP	0x08
+#define CHIP_325_VIRGE		0x09
+#define CHIP_988_VIRGE_VX	0x0A
+#define CHIP_375_VIRGE_DX	0x0B
+#define CHIP_385_VIRGE_GX	0x0C
+#define CHIP_356_VIRGE_GX2	0x0D
+#define CHIP_357_VIRGE_GX2P	0x0E
+#define CHIP_359_VIRGE_GX2P	0x0F
+
+#define CHIP_XXX_TRIO		0x80
+#define CHIP_XXX_TRIO64V2_DXGX	0x81
+#define CHIP_XXX_VIRGE_DXGX	0x82
+
+#define CHIP_UNDECIDED_FLAG	0x80
+#define CHIP_MASK		0xFF
+
+/* CRT timing register sets */
+
+static const struct vga_regset s3_h_total_regs[]        = {{0x00, 0, 7}, {0x5D, 0, 0}, VGA_REGSET_END};
+static const struct vga_regset s3_h_display_regs[]      = {{0x01, 0, 7}, {0x5D, 1, 1}, VGA_REGSET_END};
+static const struct vga_regset s3_h_blank_start_regs[]  = {{0x02, 0, 7}, {0x5D, 2, 2}, VGA_REGSET_END};
+static const struct vga_regset s3_h_blank_end_regs[]    = {{0x03, 0, 4}, {0x05, 7, 7}, VGA_REGSET_END};
+static const struct vga_regset s3_h_sync_start_regs[]   = {{0x04, 0, 7}, {0x5D, 4, 4}, VGA_REGSET_END};
+static const struct vga_regset s3_h_sync_end_regs[]     = {{0x05, 0, 4}, VGA_REGSET_END};
+
+static const struct vga_regset s3_v_total_regs[]        = {{0x06, 0, 7}, {0x07, 0, 0}, {0x07, 5, 5}, {0x5E, 0, 0}, VGA_REGSET_END};
+static const struct vga_regset s3_v_display_regs[]      = {{0x12, 0, 7}, {0x07, 1, 1}, {0x07, 6, 6}, {0x5E, 1, 1}, VGA_REGSET_END};
+static const struct vga_regset s3_v_blank_start_regs[]  = {{0x15, 0, 7}, {0x07, 3, 3}, {0x09, 5, 5}, {0x5E, 2, 2}, VGA_REGSET_END};
+// const struct vga_regset s3_v_blank_end_regs[]    = {{0x16, 0, 6}, VGA_REGSET_END};
+static const struct vga_regset s3_v_blank_end_regs[]    = {{0x16, 0, 7}, VGA_REGSET_END};
+static const struct vga_regset s3_v_sync_start_regs[]   = {{0x10, 0, 7}, {0x07, 2, 2}, {0x07, 7, 7}, {0x5E, 4, 4}, VGA_REGSET_END};
+static const struct vga_regset s3_v_sync_end_regs[]     = {{0x11, 0, 3}, VGA_REGSET_END};
+
+static const struct vga_regset s3_line_compare_regs[]   = {{0x18, 0, 7}, {0x07, 4, 4}, {0x09, 6, 6}, {0x5E, 6, 6}, VGA_REGSET_END};
+static const struct vga_regset s3_start_address_regs[]  = {{0x0d, 0, 7}, {0x0c, 0, 7}, {0x31, 4, 5}, {0x51, 0, 1}, VGA_REGSET_END};
+static const struct vga_regset s3_offset_regs[]         = {{0x13, 0, 7}, {0x51, 4, 5}, VGA_REGSET_END}; /* set 0x43 bit 2 to 0 */
+
+static const struct svga_timing_regs s3_timing_regs     = {
+	s3_h_total_regs, s3_h_display_regs, s3_h_blank_start_regs,
+	s3_h_blank_end_regs, s3_h_sync_start_regs, s3_h_sync_end_regs,
+	s3_v_total_regs, s3_v_display_regs, s3_v_blank_start_regs,
+	s3_v_blank_end_regs, s3_v_sync_start_regs, s3_v_sync_end_regs,
+};
+
+
+/* ------------------------------------------------------------------------- */
+
+/* Module parameters */
+
+
+static char *mode = "640x480-8@60";
+
+#ifdef CONFIG_MTRR
+static int mtrr   = 1;
+#endif
+
+#ifdef MODULE
+
+MODULE_AUTHOR("(c) 2006 Ondrej Zajicek <santiago@crfreenet.org>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("fbdev driver for S3 Trio/Virge");
+
+module_param(mode, charp, 0);
+MODULE_PARM_DESC(mode, "Preferred video mode ('640x480-8@60', etc)");
+
+#ifdef CONFIG_MTRR
+module_param(mtrr, int, 0);
+MODULE_PARM_DESC(mtrr, "Enable write-combining with MTRR (1=enable, 0=disable, default=1)");
+#endif
+
+#endif
+
+/* ------------------------------------------------------------------------- */
+
+/* Set font in text (tileblit) mode */
+
+void s3fb_settile(struct fb_info *info, struct fb_tilemap *map) {
+	const u8 *font = map->data;
+	u8* fb = (u8 *) info->screen_base;
+	int i, c;
+
+	if ((map->width != 8) || (map->height != 16) ||
+	    (map->depth != 1) || (map->length != 256)) {
+	    	printk(KERN_ERR "fb%d: unsupported font parameters: width %d, height %d, depth %d, length %d\n",
+			map->width, map->height, map->depth, map->length, info->node);
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
+
+void s3fb_tilecopy(struct fb_info *info, struct fb_tilearea *area) {
+	int dx, dy;
+//	int colstride = 4;
+	int colstride = 2;
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
+
+void s3fb_tilefill(struct fb_info *info, struct fb_tilerect *rect) {
+	int dx, dy;
+//	int colstride = 8;
+	int colstride = 4;
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
+
+void s3fb_tileblit(struct fb_info *info, struct fb_tileblit *blit) {
+	int dx, dy, i;
+//	int colstride = 8;
+	int colstride = 4;
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
+
+void s3fb_tilecursor(struct fb_info *info, struct fb_tilecursor *cursor) {
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
+
+static struct fb_tile_ops s3fb_tile_ops = {
+	.fb_settile	= s3fb_settile,
+	.fb_tilecopy	= s3fb_tilecopy,
+	.fb_tilefill    = s3fb_tilefill,
+	.fb_tileblit    = s3fb_tileblit,
+	.fb_tilecursor  = s3fb_tilecursor,
+};
+
+
+/* ------------------------------------------------------------------------- */
+
+/* image data is MSB-first, fb structure is MSB-first too */
+static inline u32 expand_color(u32 c)
+{ return ((c & 1) | ((c & 2) << 7) | ((c & 4) << 14) | ((c & 8) << 21)) * 0xFF; }
+
+/* s3fb_iplan_imageblit silently assumes that almost everything is 8-pixel aligned */
+static void s3fb_iplan_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	u32 fg = expand_color(image->fg_color);
+	u32 bg = expand_color(image->bg_color);
+	const u8 *src1, *src;
+	u8 __iomem *dst1;
+	u32 __iomem *dst;
+	u32 val;
+	int x, y;
+
+	src1 = image->data;
+        dst1 = info->screen_base + (image->dy * info->fix.line_length)
+		 + ((image->dx / 8) * 4);
+
+	for (y = 0; y < image->height; y++) {
+		src = src1;
+		dst = (u32 __iomem *) dst1;
+		for (x = 0; x < image->width; x += 8) {
+			val = *(src++) * 0x01010101;
+			val = (val & fg) | (~val & bg);
+			fb_writel(val, dst++);
+		}
+		src1 += image->width / 8;
+		dst1 += info->fix.line_length;
+	}
+
+}
+
+/* s3fb_iplan_fillrect silently assumes that almost everything is 8-pixel aligned */
+static void s3fb_iplan_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
+{
+	u32 fg = expand_color(rect->color);
+	u8 __iomem *dst1;
+	u32 __iomem *dst;
+	int x, y;
+
+        dst1 = info->screen_base + (rect->dy * info->fix.line_length)
+		 + ((rect->dx / 8) * 4);
+
+	for (y = 0; y < rect->height; y++) {
+		dst = (u32 __iomem *) dst1;
+		for (x = 0; x < rect->width; x += 8) {
+			fb_writel(fg, dst++);
+		}
+		dst1 += info->fix.line_length;
+	}
+
+}
+
+
+/* image data is MSB-first, fb structure is high-nibble-in-low-byte-first */
+static inline u32 expand_pixel(u32 c)
+{
+	return (((c &  1) << 24) | ((c &  2) << 27) | ((c &  4) << 14) | ((c &   8) << 17) |
+		((c & 16) <<  4) | ((c & 32) <<  7) | ((c & 64) >>  6) | ((c & 128) >>  3)) * 0xF;
+}
+
+/* s3fb_cfb4_imageblit silently assumes that almost everything is 8-pixel aligned */
+static void s3fb_cfb4_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	u32 fg = image->fg_color * 0x11111111;
+	u32 bg = image->bg_color * 0x11111111;
+	const u8 *src1, *src;
+	u8 __iomem *dst1;
+	u32 __iomem *dst;
+	u32 val;
+	int x, y;
+
+	src1 = image->data;
+        dst1 = info->screen_base + (image->dy * info->fix.line_length)
+		 + ((image->dx / 8) * 4);
+
+	for (y = 0; y < image->height; y++) {
+		src = src1;
+		dst = (u32 __iomem *) dst1;
+		for (x = 0; x < image->width; x += 8) {
+			val = expand_pixel(*(src++));
+			val = (val & fg) | (~val & bg);
+			fb_writel(val, dst++);
+		}
+		src1 += image->width / 8;
+		dst1 += info->fix.line_length;
+	}
+
+}
+
+static void s3fb_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	if ((info->var.bits_per_pixel == 4) && (image->depth == 1)
+	    && ((image->width % 8) == 0) && ((image->dx % 8) == 0)) {
+		if (info->fix.type == FB_TYPE_INTERLEAVED_PLANES)
+			s3fb_iplan_imageblit(info, image);
+		else
+			s3fb_cfb4_imageblit(info, image);
+	} else
+		cfb_imageblit(info, image);
+}
+
+static void s3fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
+{
+	if ((info->var.bits_per_pixel == 4)
+	    && ((rect->width % 8) == 0) && ((rect->dx % 8) == 0)
+	    && (info->fix.type == FB_TYPE_INTERLEAVED_PLANES))
+		s3fb_iplan_fillrect(info, rect);
+	 else
+		cfb_fillrect(info, rect);
+}
+
+
+
+/* ------------------------------------------------------------------------- */
+
+
+static void s3_set_pixclock(struct fb_info *info, u32 pixclock)
+{
+	u16 m, n, r;
+	u8 regval;
+
+	svga_compute_pll(&s3_pll, 1000000000 / pixclock, &m, &n, &r, info->node);
+
+	/* Set VGA misc register  */
+	regval = vga_r(NULL, VGA_MIS_R);
+	vga_w(NULL, VGA_MIS_W, regval | VGA_MIS_ENB_PLL_LOAD);
+
+	/* Set S3 clock registers */
+	vga_wseq(NULL, 0x12, ((n - 2) | (r << 5)));
+	vga_wseq(NULL, 0x13, m - 2);
+
+	udelay(1000);
+
+	/* Activate clock - write 0, 1, 0 to seq/15 bit 5 */
+	regval = vga_rseq (NULL, 0x15);
+	vga_wseq(NULL, 0x15, regval & ~(1<<5));
+	vga_wseq(NULL, 0x15, regval |  (1<<5));
+	vga_wseq(NULL, 0x15, regval & ~(1<<5));
+}
+
+
+/* Open framebuffer */
+
+static int s3fb_open(struct fb_info *info, int user)
+{
+	struct s3fb_info *par = (struct s3fb_info *) info;
+	unsigned int count = atomic_read(&(par->ref_count));
+
+	if (!count) {
+		memset(&(par->state), 0, sizeof(struct vgastate));
+		par->state.flags = VGA_SAVE_MODE | VGA_SAVE_FONTS | VGA_SAVE_CMAP;
+		par->state.num_crtc = 0x70;
+		par->state.num_seq = 0x20;
+		save_vga(&(par->state));
+	}
+
+	atomic_inc(&(par->ref_count));
+
+	return 0;
+}
+
+/* Close framebuffer */
+
+static int s3fb_release(struct fb_info *info, int user)
+{
+	struct s3fb_info *par = (struct s3fb_info *) info;
+	unsigned int count = atomic_read(&(par->ref_count));
+
+	if (!count)
+		return -EINVAL;
+
+	if (count == 1)
+		restore_vga(&(par->state));
+
+	atomic_dec(&(par->ref_count));
+
+	return 0;
+}
+
+/* Validate passed in var */
+
+static int s3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	int rv, mem, step;
+
+	/* Find appropriate format */
+	rv = svga_match_format (s3fb_formats, var, NULL);
+	if (rv < 0)
+	{
+		printk(KERN_ERR "fb%d: unsupported mode requested\n", info->node);
+		return rv;
+	}
+
+	/* Do not allow to have real resoulution larger than virtual */
+	if (var->xres > var->xres_virtual)
+		var->xres_virtual = var->xres;
+
+	if (var->yres > var->yres_virtual)
+		var->yres_virtual = var->yres;
+
+	/* Round up xres_virtual to have proper alignment of lines */
+	step = s3fb_formats[rv].xresstep - 1;
+	var->xres_virtual = (var->xres_virtual+step) & ~step;
+
+	/* Check whether have enough memory */
+	mem = ((var->bits_per_pixel * var->xres_virtual) >> 3) * var->yres_virtual;
+	if (mem > info->screen_size)
+	{
+		printk(KERN_ERR "fb%d: not enough framebuffer memory (%d kB requested , %d kB available)\n", info->node, mem >> 10, (unsigned int) (info->screen_size >> 10));
+		return -EINVAL;
+	}
+
+	rv = svga_check_timings (&s3_timing_regs, var, info->node);
+	if (rv < 0)
+	{
+		printk(KERN_ERR "fb%d: invalid timings requested\n", info->node);
+		return rv;
+	}
+
+	return 0;
+}
+
+/* Set video mode from par */
+
+static int s3fb_set_par(struct fb_info *info)
+{
+	struct s3fb_info *par = (struct s3fb_info *) info;
+	u32 value, mode, hmul, offset_value, screen_size;
+	u32 bpp = info->var.bits_per_pixel;
+
+	if (bpp != 0) {
+		info->fix.ypanstep = 1;
+		info->fix.line_length = (info->var.xres_virtual * bpp) / 8;
+
+		info->flags &= ~FBINFO_MISC_TILEBLITTING;
+		info->tileops = NULL;
+
+		offset_value = (info->var.xres_virtual * bpp) / 64;
+		screen_size = info->var.yres_virtual * info->fix.line_length;
+	} else {
+		info->fix.ypanstep = 16;
+		info->fix.line_length = 0;
+
+		info->flags |= FBINFO_MISC_TILEBLITTING;
+		info->tileops = &s3fb_tile_ops;
+
+		offset_value = info->var.xres_virtual / 16;
+		screen_size = (info->var.xres_virtual * info->var.yres_virtual) / 64;
+		// FIXME test screen_size
+	}
+
+	info->var.xoffset = 0;
+	info->var.yoffset = 0;
+	info->var.activate = FB_ACTIVATE_NOW;
+
+	/* Unlock registers */
+	vga_wcrt(NULL, 0x38, 0x48);
+	vga_wcrt(NULL, 0x39, 0xA5);
+	vga_wseq(NULL, 0x08, 0x06);
+	svga_wcrt_mask(0x11, 0x00, 0x80);
+
+	/* Blank screen and turn off sync */
+	svga_wseq_mask(0x01, 0x20, 0x20);
+	svga_wcrt_mask(0x17, 0x00, 0x80);
+
+	/* Set default values */
+	svga_set_default_gfx_regs();
+	svga_set_default_atc_regs();
+	svga_set_default_seq_regs();
+	svga_set_default_crt_regs();
+	svga_wcrt_multi(s3_line_compare_regs, 0xFFFFFFFF);
+	svga_wcrt_multi(s3_start_address_regs, 0);
+
+	/* S3 specific initialization */
+	svga_wcrt_mask(0x58, 0x10, 0x10); /* enable linear framebuffer */
+	svga_wcrt_mask(0x31, 0x08, 0x08); /* enable sequencer access to framebuffer above 256 kB */
+
+	svga_wcrt_mask(0x33, 0x08, 0x08); // DDR ?
+	svga_wcrt_mask(0x43, 0x01, 0x01); // DDR ?
+
+
+//	svga_wcrt_mask(0x58, 0x03, 0x03); /* XXX */
+
+//	svga_wcrt_mask(0x53, 0x12, 0x13); /* enable MMIO */
+//	svga_wcrt_mask(0x40, 0x08, 0x08); /* enable write buffer */
+
+//	pr_debug "fb%d: MCLK reg values %x %x\n", info->node,
+//			  vga_rseq(NULL, 0x10), vga_rseq(NULL, 0x11));
+
+
+
+	/* Set the offset register */
+	pr_debug("fb%d: offset register       : %d\n", info->node, offset_value);
+	svga_wcrt_multi(s3_offset_regs, offset_value);
+
+		/* Set the fetch count register */
+/*		value = (info->var.xres / 8) + 8;
+		pr_debug( "viafb: fetch count register  : %d\n", value);
+		via_wseq_multi(via_fetch_count_regs, value);
+*/
+
+
+//	vga_wcrt(NULL, 0x54, info->var.nonstd << 3); // M parameter 0x18
+	vga_wcrt(NULL, 0x54, 0x18); // M parameter 0x18
+	vga_wcrt(NULL, 0x60, 0xff); // N parameter
+	vga_wcrt(NULL, 0x61, 0xff); // L parameter
+	vga_wcrt(NULL, 0x62, 0xff); // L parameter
+
+	vga_wcrt(NULL, 0x3A, 0x35);
+	svga_wattr(0x33, 0x00);
+
+	if (info->var.vmode & FB_VMODE_DOUBLE)
+		svga_wcrt_mask(0x09, 0x80, 0x80);
+	else
+		svga_wcrt_mask(0x09, 0x00, 0x80);
+
+	if (info->var.vmode & FB_VMODE_INTERLACED)
+		svga_wcrt_mask(0x42, 0x20, 0x20);
+	else
+		svga_wcrt_mask(0x42, 0x00, 0x20);
+
+	/* Disable hardware graphics cursor */
+	svga_wcrt_mask(0x45, 0x00, 0x01);
+	/* Disable Streams engine */
+	svga_wcrt_mask(0x67, 0x00, 0x0C);
+
+	/* S3 virge DX hack */
+	if (par->chip == CHIP_375_VIRGE_DX) {
+		vga_wcrt(NULL, 0x86, 0x80);
+		vga_wcrt(NULL, 0x90, 0x00);
+	}
+
+	/* Set mode-specific register values */
+	mode = svga_match_format(s3fb_formats, &(info->var), &(info->fix));
+	switch (mode) {
+		case 0:
+			pr_debug("fb%d: text mode\n", info->node);
+			svga_set_textmode_vga_regs();
+
+			/* Set additional registers like in 8-bit mode */
+			svga_wcrt_mask(0x50, 0x00, 0x30);
+			svga_wcrt_mask(0x67, 0x00, 0xF0);
+
+			/* Disable enhanced mode */
+			svga_wcrt_mask(0x3A, 0x00, 0x30);
+
+			hmul = 1;
+		break;
+		case 1:
+			pr_debug("fb%d: 4 bit pseudocolor\n", info->node);
+			vga_wgfx(NULL, VGA_GFX_MODE, 0x40);
+
+			/* Set additional registers like in 8-bit mode */
+			svga_wcrt_mask(0x50, 0x00, 0x30);
+			svga_wcrt_mask(0x67, 0x00, 0xF0);
+
+			/* disable enhanced mode */
+			svga_wcrt_mask(0x3A, 0x00, 0x30);
+
+			hmul = 1;
+		break;
+		case 2:
+			pr_debug("fb%d: 4 bit pseudocolor, planar\n", info->node);
+
+			/* Set additional registers like in 8-bit mode */
+			svga_wcrt_mask(0x50, 0x00, 0x30);
+			svga_wcrt_mask(0x67, 0x00, 0xF0);
+
+			/* disable enhanced mode */
+			svga_wcrt_mask(0x3A, 0x00, 0x30);
+
+			hmul = 1;
+		break;
+		case 3:
+			pr_debug("fb%d: 8 bit pseudocolor\n", info->node);
+			svga_wcrt_mask(0x50, 0x00, 0x30);
+			svga_wcrt_mask(0x67, 0x00, 0xF0);
+			hmul = 1;
+		break;
+		case 4:
+			pr_debug("fb%d: 5/5/5 truecolor\n", info->node);
+			svga_wcrt_mask(0x50, 0x10, 0x30);
+			svga_wcrt_mask(0x67, 0x30, 0xF0);
+			hmul = 2;
+		break;
+		case 5:
+			pr_debug("fb%d: 5/6/5 truecolor\n", info->node);
+			svga_wcrt_mask(0x50, 0x10, 0x30);
+			svga_wcrt_mask(0x67, 0x50, 0xF0);
+			hmul = 2;
+		break;
+		case 6:
+			pr_debug("fb%d: 8/8/8 truecolor\n", info->node);
+			svga_wcrt_mask(0x50, 0x30, 0x30);
+			svga_wcrt_mask(0x67, 0xD0, 0xF0);
+			hmul = 1;
+		break;
+		case 7:
+/*
+			pr_debug("fb%d: 8/8/8 truecolor X\n", info->node);
+			svga_wcrt_mask(0x50, 0x30, 0x30);
+			svga_wcrt_mask(0x67, 0x70, 0xF0);
+*/
+			/* disable enhanced mode */
+			svga_wcrt_mask(0x3A, 0x00, 0x30);
+			/* swap nibbles */
+//			svga_wcrt_mask(0x53, 0x40, 0x40);
+
+//			svga_wattr(VGA_ATC_MODE, 0x41);
+			hmul = 1;
+		break;
+		default:
+			printk(KERN_ERR "fb%d: unsupported mode - bug\n", info->node);
+			return -EINVAL;
+	}
+
+	s3_set_pixclock(info, info->var.pixclock);
+	svga_set_timings(&s3_timing_regs, &(info->var), hmul, 1,
+			 (info->var.vmode & FB_VMODE_DOUBLE)     ? 2 : 1,
+			 (info->var.vmode & FB_VMODE_INTERLACED) ? 2 : 1,
+			 info->node);
+
+	/* Set interlaced mode start/end register */
+	value = info->var.xres + info->var.left_margin + info->var.right_margin + info->var.hsync_len;
+	value = ((value * hmul) / 8) - 5;
+	vga_wcrt(NULL, 0x3C, (value + 1) / 2);
+
+	memset((u8*)info->screen_base, 0x00, screen_size);
+
+	/* Device and screen back on */
+	svga_wcrt_mask(0x17, 0x80, 0x80);
+	svga_wseq_mask(0x01, 0x00, 0x20);
+
+	return 0;
+}
+
+/* Set a colour register */
+
+static int s3fb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
+				u_int transp, struct fb_info *fb)
+{
+	switch (fb->var.bits_per_pixel) {
+		case 0:
+		case 4:
+			if (regno >= 16) return -EINVAL;
+
+			if ((fb->var.bits_per_pixel == 4) &&
+			    (fb->var.nonstd == 0)) {
+				outb(0xF0, VGA_PEL_MSK);
+				outb(regno*16, VGA_PEL_IW);
+			} else {
+				outb(0x0F, VGA_PEL_MSK);
+				outb(regno, VGA_PEL_IW);
+			}
+			outb(red >> 10, VGA_PEL_D);
+			outb(green >> 10, VGA_PEL_D);
+			outb(blue >> 10, VGA_PEL_D);
+
+			((u32*)fb->pseudo_palette)[regno] = ((blue & 0xFF00) >> 8) |
+				(green & 0xFF00) | ((red & 0xFF00) << 8);
+		break;
+		case 8:
+			if (regno >= 256) return -EINVAL;
+			outb(0xFF, VGA_PEL_MSK);
+			outb(regno, VGA_PEL_IW);
+			outb(red >> 10, VGA_PEL_D);
+			outb(green >> 10, VGA_PEL_D);
+			outb(blue >> 10, VGA_PEL_D);
+			if (regno < 16)
+				((u32*)fb->pseudo_palette)[regno] = ((blue & 0xFF00) >> 8) |
+					(green & 0xFF00) | ((red & 0xFF00) << 8);
+
+		break;
+		case 16:
+			if (regno >= 16) return -EINVAL;
+			if (fb->var.green.length == 5)
+				((u32*)fb->pseudo_palette)[regno] = ((red & 0xF800) >> 1) | ((green & 0xF800) >> 6) | ((blue & 0xF800) >> 11);
+			else if (fb->var.green.length == 6)
+				((u32*)fb->pseudo_palette)[regno] = (red & 0xF800) | ((green & 0xFC00) >> 5) | ((blue & 0xF800) >> 11);
+			else return -EINVAL;
+		break;
+
+		case 24:
+		case 32:
+			if (regno >= 16) return -EINVAL;
+			((u32*)fb->pseudo_palette)[regno] = ((transp & 0xFF00) >> 16 ) | ((blue & 0xFF00) >> 8) |
+				(green & 0xFF00) | ((red & 0xFF00) << 8);
+		break;
+		default:
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Set the display blanking state */
+
+static int s3fb_blank(int blank_mode, struct fb_info *info)
+{
+	switch (blank_mode) {
+		case FB_BLANK_UNBLANK:
+			pr_debug("fb%d: unblank\n", info->node);
+			svga_wcrt_mask(0x56, 0x00, 0x06);
+			svga_wseq_mask(0x01, 0x00, 0x20);
+		break;
+		case FB_BLANK_NORMAL:
+			pr_debug("fb%d: blank\n", info->node);
+			svga_wcrt_mask(0x56, 0x00, 0x06);
+			svga_wseq_mask(0x01, 0x20, 0x20);
+		break;
+		case FB_BLANK_HSYNC_SUSPEND:
+			pr_debug("fb%d: hsync\n", info->node);
+			svga_wcrt_mask(0x56, 0x02, 0x06);
+			svga_wseq_mask(0x01, 0x20, 0x20);
+		break;
+		case FB_BLANK_VSYNC_SUSPEND:
+			pr_debug("fb%d: vsync\n", info->node);
+			svga_wcrt_mask(0x56, 0x04, 0x06);
+			svga_wseq_mask(0x01, 0x20, 0x20);
+		break;
+		case FB_BLANK_POWERDOWN:
+			pr_debug("fb%d: sync down\n", info->node);
+			svga_wcrt_mask(0x56, 0x06, 0x06);
+			svga_wseq_mask(0x01, 0x20, 0x20);
+		break;
+	}
+
+	return 0;
+}
+
+
+/* Pan the display */
+
+static int s3fb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info) {
+
+	unsigned int offset;
+
+	/* Validate the offsets - At the moment, only the Y offset can be changed */
+	if ((var->xoffset + var->xres) > var->xres_virtual) return -EINVAL;
+	if ((var->yoffset + var->yres) > var->yres_virtual) return -EINVAL;
+
+	/* Calculate the offset */
+	if (var->bits_per_pixel == 0) {
+		offset = (var->yoffset / 16) * (var->xres_virtual / 2) + (var->xoffset / 2);
+		offset = offset >> 2;
+	} else {
+		offset = (var->yoffset * info->fix.line_length) +
+			 (var->xoffset * var->bits_per_pixel / 8);
+		offset = offset >> 2;
+	}
+
+	/* Set the offset */
+	svga_wcrt_multi(s3_start_address_regs, offset);
+
+	return 0;
+}
+
+
+
+/* ------------------------------------------------------------------------- */
+
+/* Frame buffer operations */
+
+static struct fb_ops s3fb_ops = {
+	.owner		= THIS_MODULE,
+	.fb_open	= s3fb_open,
+	.fb_release	= s3fb_release,
+	.fb_check_var	= s3fb_check_var,
+	.fb_set_par	= s3fb_set_par,
+	.fb_setcolreg	= s3fb_setcolreg,
+	.fb_blank	= s3fb_blank,
+	.fb_pan_display	= s3fb_pan_display,
+	.fb_fillrect	= s3fb_fillrect,
+	.fb_copyarea	= cfb_copyarea,
+	.fb_imageblit	= s3fb_imageblit,
+};
+
+/* ------------------------------------------------------------------------- */
+
+static int __devinit s3_identification(int chip)
+{
+	if (chip == CHIP_XXX_TRIO) {
+		u8 cr30 = vga_rcrt(NULL, 0x30);
+		u8 cr2e = vga_rcrt(NULL, 0x2e);
+		u8 cr2f = vga_rcrt(NULL, 0x2f);
+
+		if ((cr30 == 0xE0) || (cr30 == 0xE1)) {
+			if (cr2e == 0x10)
+				return CHIP_732_TRIO32;
+			if (cr2e == 0x11) {
+				if (! (cr2f & 0x40))
+					return CHIP_764_TRIO64;
+				else
+					return CHIP_765_TRIO64VP;
+			}
+		}
+	}
+
+	if (chip == CHIP_XXX_TRIO64V2_DXGX) {
+		u8 cr6f = vga_rcrt(NULL, 0x6f);
+
+		if (! (cr6f & 0x01))
+			return CHIP_775_TRIO64V2_DX;
+		else
+			return CHIP_785_TRIO64V2_GX;
+	}
+
+	if (chip == CHIP_XXX_VIRGE_DXGX) {
+		u8 cr6f = vga_rcrt(NULL, 0x6f);
+
+		if (! (cr6f & 0x01))
+			return CHIP_375_VIRGE_DX;
+		else
+			return CHIP_385_VIRGE_GX;
+	}
+
+	return CHIP_UNKNOWN;
+}
+
+/* PCI probe */
+
+static int __devinit s3_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	struct fb_info *info;
+	struct s3fb_info *par;
+	int rc;
+	u8 regval, cr38, cr39;
+
+	/* Allocate and fill driver data structure */
+
+	info = framebuffer_alloc(sizeof(struct s3fb_info), NULL);
+	if (!info) return -ENOMEM;
+	par = (struct s3fb_info*) info;
+
+	info->flags = FBINFO_PARTIAL_PAN_OK | FBINFO_HWACCEL_YPAN;
+	info->fbops = &s3fb_ops;
+
+	/* Prepare PCI device */
+
+	rc = pci_enable_device(dev);
+	if (rc < 0) {
+		printk(KERN_ERR "s3fb: cannot enable PCI device\n");
+		goto err_enable_device;
+	}
+
+	rc = pci_request_regions(dev, "s3fb");
+	if (rc < 0) {
+		printk(KERN_ERR "s3fb: cannot reserve framebuffer region\n");
+		goto err_request_regions;
+	}
+
+	/* Map physical IO memory address into kernel space */
+
+	info->fix.smem_start = pci_resource_start(dev, 0);
+	info->fix.smem_len = pci_resource_len(dev, 0);
+
+	info->screen_base = ioremap_nocache(info->fix.smem_start, info->fix.smem_len);
+	if (! info->screen_base) {
+		rc = -ENOMEM;
+		printk(KERN_ERR "s3fb: ioremap for framebuffer failed\n");
+		goto err_ioremap;
+	}
+
+	/* Unlock regs */
+	cr38 = vga_rcrt(NULL, 0x38);
+	cr39 = vga_rcrt(NULL, 0x39);
+	vga_wseq(NULL, 0x08, 0x06);
+	vga_wcrt(NULL, 0x38, 0x48);
+	vga_wcrt(NULL, 0x39, 0xA5);
+
+	/* Find how many physical memory there is on card */
+	/* 0x36 register is accessible even if other registers are locked */
+	regval = vga_rcrt(NULL, 0x36);
+	info->screen_size = s3_memsizes[regval >> 5] << 10;
+	info->fix.smem_len = info->screen_size;
+
+	par->chip = id->driver_data & CHIP_MASK;
+	par->rev = vga_rcrt(NULL, 0x2f);
+	if (par->chip & CHIP_UNDECIDED_FLAG)
+		par->chip = s3_identification(par->chip);
+
+	/* Find MCLK frequency */
+	regval = vga_rseq(NULL, 0x10);
+	par->mclk_freq = ((vga_rseq(NULL, 0x11) + 2) * 14318) / ((regval & 0x1F)  + 2);
+	par->mclk_freq = par->mclk_freq >> (regval >> 5);
+
+	/* Restore locks */
+	vga_wcrt(NULL, 0x38, cr38);
+	vga_wcrt(NULL, 0x39, cr39);
+
+	strcpy(info->fix.id, s3_names [par->chip]);
+	info->fix.mmio_start = 0;
+	info->fix.mmio_len = 0;
+	info->fix.type = FB_TYPE_PACKED_PIXELS;
+	info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
+	info->fix.ypanstep = 0;
+	info->fix.accel = FB_ACCEL_NONE;
+	info->pseudo_palette = (void*) (par->pseudo_palette);
+
+	/* Prepare startup mode */
+
+	rc = fb_find_mode(&(info->var), info, mode, NULL, 0, NULL, 8);
+	if (! ((rc == 1) || (rc == 2))) {
+		rc = -EINVAL;
+		printk(KERN_ERR "s3fb: mode %s not found\n", mode);
+		goto err_find_mode;
+	}
+
+	rc = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (rc < 0) goto err_alloc_cmap;
+
+	rc = register_framebuffer(info);
+	if (rc < 0) goto err_reg_fb;
+
+	printk(KERN_INFO "fb%d: %s on %s, %d MB RAM, %d MHz MCLK\n", info->node, info->fix.id,
+		 pci_name(dev), info->fix.smem_len >> 20, (par->mclk_freq + 500) / 1000);
+
+	if (par->chip == CHIP_UNKNOWN)
+		printk(KERN_INFO "fb%d: unknown chip, CR2D=%x, CR2E=%x, CRT2F=%x, CRT30=%x\n",
+			info->node, vga_rcrt(NULL, 0x2d), vga_rcrt(NULL, 0x2e),
+			vga_rcrt(NULL, 0x2f), vga_rcrt(NULL, 0x30));
+
+	/* Record a reference to the driver data */
+	pci_set_drvdata(dev, info);
+
+#ifdef CONFIG_MTRR
+	if (mtrr) {
+		par->mtrr_reg = -1;
+		par->mtrr_reg = mtrr_add(info->fix.smem_start, info->fix.smem_len, MTRR_TYPE_WRCOMB, 1);
+	}
+#endif
+
+	return 0;
+
+	/* Error handling */
+err_reg_fb:
+	fb_dealloc_cmap(&info->cmap);
+err_alloc_cmap:
+err_find_mode:
+	iounmap(info->screen_base);
+err_ioremap:
+	pci_release_regions(dev);
+err_request_regions:
+/*	pci_disable_device(dev); */
+err_enable_device:
+	framebuffer_release(info);
+	return rc;
+}
+
+/* PCI remove */
+
+static void __devexit s3_pci_remove(struct pci_dev *dev)
+{
+	struct fb_info *info = pci_get_drvdata(dev);
+	struct s3fb_info *par = (struct s3fb_info *) info;
+
+	if (info) {
+
+#ifdef CONFIG_MTRR
+		if (par->mtrr_reg >= 0) {
+			mtrr_del(par->mtrr_reg, 0, 0);
+			par->mtrr_reg = -1;
+		}
+#endif
+
+		unregister_framebuffer(info);
+		fb_dealloc_cmap(&info->cmap);
+
+		iounmap(info->screen_base);
+		pci_release_regions(dev);
+/*		pci_disable_device(dev); */
+
+		pci_set_drvdata(dev, NULL);
+		framebuffer_release(info);
+	}
+}
+
+/* PCI suspend */
+
+/*
+static int s3_pci_suspend (struct pci_dev* dev, pm_message_t state)
+{
+	struct fb_info *info = pci_get_drvdata(dev);
+	unsigned int count = atomic_read(&(((struct s3_info*)info)->par.ref_count));
+
+	printk(KERN_INFO "fb%d: suspend\n");
+
+	if ((state.event == PM_EVENT_FREEZE) || (!count)) {
+		return 0;
+	}
+
+	acquire_console_sem();
+	fb_set_suspend(info, 1);
+
+	pci_save_state(dev);
+	pci_disable_device(dev);
+	pci_set_power_state(dev, pci_choose_state(dev, state));
+	release_console_sem();
+
+	return 0;
+}
+*/
+
+/* PCI resume */
+/*
+static int s3_pci_resume (struct pci_dev* dev)
+{
+	struct fb_info *info = pci_get_drvdata(dev);
+	unsigned int count = atomic_read(&(((struct s3_info*)info)->par.ref_count));
+
+	printk(KERN_INFO "fb%d: resume\n");
+
+	if (!count) {
+		return 0;
+	}
+
+	acquire_console_sem();
+	pci_set_power_state(dev, PCI_D0);
+	pci_restore_state(dev);
+	pci_enable_device(dev);
+	pci_set_master(dev);
+
+	s3fb_set_par (info);
+	fb_set_suspend (info, 0);
+	release_console_sem();
+
+	return 0;
+}
+*/
+
+/* List of boards that we are trying to support */
+
+static struct pci_device_id s3_devices[] __devinitdata = {
+	{PCI_VENDOR_ID_S3,	0x8810,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_TRIO},
+	{PCI_VENDOR_ID_S3,	0x8811,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_TRIO},
+	{PCI_VENDOR_ID_S3,	0x8812,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_M65_AURORA64VP},
+	{PCI_VENDOR_ID_S3,	0x8814,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_767_TRIO64UVP},
+	{PCI_VENDOR_ID_S3,	0x8901,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_TRIO64V2_DXGX},
+	{PCI_VENDOR_ID_S3,	0x8902,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_551_PLATO_PX},
+
+	{PCI_VENDOR_ID_S3,	0x5631,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_325_VIRGE},
+	{PCI_VENDOR_ID_S3,	0x883D,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_988_VIRGE_VX},
+	{PCI_VENDOR_ID_S3,	0x8A01,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_VIRGE_DXGX},
+	{PCI_VENDOR_ID_S3,	0x8A10,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_356_VIRGE_GX2},
+	{PCI_VENDOR_ID_S3,	0x8A11,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_357_VIRGE_GX2P},
+	{PCI_VENDOR_ID_S3,	0x8A12,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_359_VIRGE_GX2P},
+
+	{0, 0, 0, 0, 0, 0, 0}
+};
+
+
+
+
+
+MODULE_DEVICE_TABLE(pci, s3_devices);
+
+static struct pci_driver s3fb_pci_driver = {
+	name:"s3fb",
+	id_table:s3_devices,
+	probe:s3_pci_probe,
+	remove:__devexit_p(s3_pci_remove),
+//	suspend:s3_pci_suspend,
+//	resume:s3_pci_resume,
+};
+
+/* Parse user speficied options */
+
+#ifndef MODULE
+static int  __init s3fb_setup(char *options)
+{
+	char *opt;
+
+	if (!options || !*options)
+		return 0;
+
+	while ((opt = strsep(&options, ",")) != NULL) {
+
+		if (!*opt)
+			continue;
+#ifdef CONFIG_MTRR
+		else if (!strcmp(opt, "mtrr:"))
+			mtrr = simple_strtoul(opt + 5, NULL, 0);
+#endif
+		else
+			mode = opt;
+	}
+
+	return 0;
+}
+#endif
+
+/* Cleanup */
+
+static void __exit s3fb_cleanup(void)
+{
+
+	pr_debug("s3fb: cleaning up\n");
+	pci_unregister_driver(&s3fb_pci_driver);
+}
+
+/* Driver Initialisation */
+
+int __init s3fb_init(void)
+{
+
+#ifndef MODULE
+        char *option = NULL;
+
+        if (fb_get_options("s3fb", &option))
+                return -ENODEV;
+        s3fb_setup(option);
+#endif
+
+	pr_debug("s3fb: initializing\n");
+	return pci_register_driver(&s3fb_pci_driver);
+}
+
+/* ------------------------------------------------------------------------- */
+
+/* Modularization */
+
+module_init(s3fb_init);
+module_exit(s3fb_cleanup);
diff -puN /dev/null drivers/video/svgalib.c
--- /dev/null
+++ a/drivers/video/svgalib.c
@@ -0,0 +1,455 @@
+/*
+ *  Common utility functions for VGA-based graphics cards.
+ *
+ *  Copyright (c) 2006 Ondrej Zajicek <santiago@crfreenet.org>
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License.  See the file COPYING in the main directory of this archive for
+ *  more details.
+ *
+ *  Some parts are based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
+ */
+
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/fb.h>
+#include <linux/svga.h>
+#include <linux/slab.h>
+#include <asm/types.h>
+#include <asm/io.h>
+
+
+/* Write a CRT register value spread across multiple registers */
+
+void svga_wcrt_multi(const struct vga_regset *regset, u32 value) {
+
+	u8 regval, bitval, bitnum;
+
+	while (regset->regnum != VGA_REGSET_END_VAL) {
+		regval = vga_rcrt(NULL, regset->regnum);
+		bitnum = regset->lowbit;
+		while (bitnum <= regset->highbit) {
+			bitval = 1 << bitnum;
+			regval = regval & ~bitval;
+			if (value & 1) regval = regval | bitval;
+			bitnum ++;
+			value = value >> 1;
+		}
+		vga_wcrt(NULL, regset->regnum, regval);
+		regset ++;
+	}
+}
+
+/* Write a sequence register value spread across multiple registers */
+
+void svga_wseq_multi(const struct vga_regset *regset, u32 value) {
+
+	u8 regval, bitval, bitnum;
+
+	while (regset->regnum != VGA_REGSET_END_VAL) {
+		regval = vga_rseq(NULL, regset->regnum);
+		bitnum = regset->lowbit;
+		while (bitnum <= regset->highbit) {
+			bitval = 1 << bitnum;
+			regval = regval & ~bitval;
+			if (value & 1) regval = regval | bitval;
+			bitnum ++;
+			value = value >> 1;
+		}
+		vga_wseq(NULL, regset->regnum, regval);
+		regset ++;
+	}
+}
+
+unsigned int svga_regset_size(const struct vga_regset *regset)
+{
+	u8 count = 0;
+
+	while (regset->regnum != VGA_REGSET_END_VAL) {
+		count += regset->highbit - regset->lowbit + 1;
+		regset ++;
+	}
+	return 1 << count;
+}
+
+
+/* ------------------------------------------------------------------------- */
+
+
+/* Set graphics controller registers to sane values */
+void svga_set_default_gfx_regs(void)
+{
+	/* All standard GFX registers (GR00 - GR08) */
+	vga_wgfx(NULL, VGA_GFX_SR_VALUE, 0x00);
+	vga_wgfx(NULL, VGA_GFX_SR_ENABLE, 0x00);
+	vga_wgfx(NULL, VGA_GFX_COMPARE_VALUE, 0x00);
+	vga_wgfx(NULL, VGA_GFX_DATA_ROTATE, 0x00);
+	vga_wgfx(NULL, VGA_GFX_PLANE_READ, 0x00);
+	vga_wgfx(NULL, VGA_GFX_MODE, 0x00);
+//	vga_wgfx(NULL, VGA_GFX_MODE, 0x20);
+//	vga_wgfx(NULL, VGA_GFX_MODE, 0x40);
+	vga_wgfx(NULL, VGA_GFX_MISC, 0x05);
+//	vga_wgfx(NULL, VGA_GFX_MISC, 0x01);
+	vga_wgfx(NULL, VGA_GFX_COMPARE_MASK, 0x0F);
+	vga_wgfx(NULL, VGA_GFX_BIT_MASK, 0xFF);
+}
+
+/* Set attribute controller registers to sane values */
+void svga_set_default_atc_regs(void)
+{
+	/* All standard ATC registers (AR00 - AR14) */
+	u8 count;
+	for (count = 0; count <= 0xF; count ++)
+		svga_wattr(count, count);
+
+	svga_wattr(VGA_ATC_MODE, 0x01);
+//	svga_wattr(VGA_ATC_MODE, 0x41);
+	svga_wattr(VGA_ATC_OVERSCAN, 0x00);
+	svga_wattr(VGA_ATC_PLANE_ENABLE, 0x0F);
+	svga_wattr(VGA_ATC_PEL, 0x00);
+	svga_wattr(VGA_ATC_COLOR_PAGE, 0x00);
+}
+
+/* Set sequencer registers to sane values */
+void svga_set_default_seq_regs(void)
+{
+	/* Standard sequencer registers (SR01 - SR04), SR00 is not set */
+	vga_wseq(NULL, VGA_SEQ_CLOCK_MODE, VGA_SR01_CHAR_CLK_8DOTS);
+	vga_wseq(NULL, VGA_SEQ_PLANE_WRITE, VGA_SR02_ALL_PLANES);
+	vga_wseq(NULL, VGA_SEQ_CHARACTER_MAP, 0x00);
+//	vga_wseq(NULL, VGA_SEQ_MEMORY_MODE, VGA_SR04_EXT_MEM | VGA_SR04_SEQ_MODE | VGA_SR04_CHN_4M);
+	vga_wseq(NULL, VGA_SEQ_MEMORY_MODE, VGA_SR04_EXT_MEM | VGA_SR04_SEQ_MODE);
+}
+
+/* Set CRTC registers to sane values */
+void svga_set_default_crt_regs(void)
+{
+	/* Standard CRT registers CR03 CR08 CR09 CR14 CR17 */
+	svga_wcrt_mask(0x03, 0x80, 0x80);	/* Enable vertical retrace EVRA */
+	vga_wcrt(NULL, VGA_CRTC_PRESET_ROW, 0);
+	svga_wcrt_mask(VGA_CRTC_MAX_SCAN, 0, 0x1F);
+	vga_wcrt(NULL, VGA_CRTC_UNDERLINE, 0);
+	vga_wcrt(NULL, VGA_CRTC_MODE, 0xE3);
+}
+
+void svga_set_textmode_vga_regs(void)
+{
+	/* svga_wseq_mask(0x1, 0x00, 0x01); */   /* Switch 8/9 pixel per char */
+	vga_wseq(NULL, VGA_SEQ_MEMORY_MODE,	VGA_SR04_EXT_MEM);
+	vga_wseq(NULL, VGA_SEQ_PLANE_WRITE,	0x03);
+
+	vga_wcrt(NULL, VGA_CRTC_MAX_SCAN,	0x0f); /* 0x4f */
+	vga_wcrt(NULL, VGA_CRTC_UNDERLINE,	0x1f);
+	svga_wcrt_mask(VGA_CRTC_MODE,		0x23, 0x7f);
+
+	vga_wcrt(NULL, VGA_CRTC_CURSOR_START,	0x0d);
+	vga_wcrt(NULL, VGA_CRTC_CURSOR_END,	0x0e);
+	vga_wcrt(NULL, VGA_CRTC_CURSOR_HI,	0x00);
+	vga_wcrt(NULL, VGA_CRTC_CURSOR_LO,	0x00);
+
+	vga_wgfx(NULL, VGA_GFX_MODE,		0x10); /* Odd/even memory mode */
+	vga_wgfx(NULL, VGA_GFX_MISC,		0x0E); /* Misc graphics register - text mode enable */
+	vga_wgfx(NULL, VGA_GFX_COMPARE_MASK,	0x00);
+
+	vga_r(NULL, 0x3DA);
+	vga_w(NULL, VGA_ATT_W, 0x00);
+
+	svga_wattr(0x10, 0x0C);			/* Attribute Mode Control Register - text mode, blinking and line graphics */
+	svga_wattr(0x13, 0x08);			/* Horizontal Pixel Panning Register  */
+
+	vga_r(NULL, 0x3DA);
+	vga_w(NULL, VGA_ATT_W, 0x20);
+}
+
+void svga_dump_var(struct fb_var_screeninfo *var, int node)
+{
+	pr_debug("fb%d: var.vmode         : 0x%X\n", node, var->vmode);
+	pr_debug("fb%d: var.xres          : %d\n", node, var->xres);
+	pr_debug("fb%d: var.yres          : %d\n", node, var->yres);
+	pr_debug("fb%d: var.bits_per_pixel: %d\n", node, var->bits_per_pixel);
+	pr_debug("fb%d: var.xres_virtual  : %d\n", node, var->xres_virtual);
+	pr_debug("fb%d: var.yres_virtual  : %d\n", node, var->yres_virtual);
+	pr_debug("fb%d: var.left_margin   : %d\n", node, var->left_margin);
+	pr_debug("fb%d: var.right_margin  : %d\n", node, var->right_margin);
+	pr_debug("fb%d: var.upper_margin  : %d\n", node, var->upper_margin);
+	pr_debug("fb%d: var.lower_margin  : %d\n", node, var->lower_margin);
+	pr_debug("fb%d: var.hsync_len     : %d\n", node, var->hsync_len);
+	pr_debug("fb%d: var.vsync_len     : %d\n", node, var->vsync_len);
+	pr_debug("fb%d: var.sync          : 0x%X\n", node, var->sync);
+	pr_debug("fb%d: var.pixclock      : %d\n\n", node, var->pixclock);
+}
+
+/* ------------------------------------------------------------------------- */
+
+
+/*
+   Compute PLL settings (M, N, R)
+   F_VCO = (F_BASE * M) / N
+   F_OUT = F_VCO / (2^R)
+*/
+
+static inline u32 abs_diff(u32 a, u32 b) {return (a > b) ? (a - b) : (b - a);}
+
+int svga_compute_pll(const struct svga_pll *pll, u32 f_wanted, u16 *m, u16 *n, u16 *r, int node)
+{
+	u16 am, an, ar;
+	u32 f_vco, f_current, delta_current, delta_best;
+
+	pr_debug("fb%d: ideal frequency: %d kHz\n", node, (unsigned int) f_wanted);
+
+	ar = pll->r_max;
+	f_vco = f_wanted << ar;
+
+	/* overflow check */
+	if ((f_vco >> ar) != f_wanted)
+		return -EINVAL;
+
+	/* It is usually better to have greater VCO clock
+	   because of better frequency stability.
+	   So first try r_max, then r smaller. */
+	while ((ar > pll->r_min) && (f_vco > pll->f_vco_max)) {
+		ar--;
+		f_vco = f_vco >> 1;
+	}
+
+	/* VCO bounds check */
+	if ((f_vco < pll->f_vco_min) || (f_vco > pll->f_vco_max))
+		return -EINVAL;
+
+	delta_best = 0xFFFFFFFF;
+	*m = 0;
+	*n = 0;
+	*r = ar;
+
+	am = pll->m_min;
+	an = pll->n_min;
+
+	while ((am <= pll->m_max) && (an <= pll->n_max)) {
+		f_current = (pll->f_base * am) / an;
+		delta_current = abs_diff (f_current, f_vco);
+
+		if (delta_current < delta_best) {
+			delta_best = delta_current;
+			*m = am;
+			*n = an;
+		}
+
+		if (f_current <= f_vco) {
+			am ++;
+		} else {
+			an ++;
+		}
+	}
+
+	f_current = (pll->f_base * *m) / *n;
+	pr_debug("fb%d: found frequency: %d kHz (VCO %d kHz)\n", node, (int) (f_current >> ar), (int) f_current);
+	pr_debug("fb%d: m = %d n = %d r = %d\n", node, (unsigned int) *m, (unsigned int) *n, (unsigned int) *r);
+	return 0;
+}
+
+
+/* ------------------------------------------------------------------------- */
+
+
+/* Check CRT timing values */
+int svga_check_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var, int node)
+{
+	u32 value;
+
+	var->xres         = (var->xres+7)&~7;
+	var->left_margin  = (var->left_margin+7)&~7;
+	var->right_margin = (var->right_margin+7)&~7;
+	var->hsync_len    = (var->hsync_len+7)&~7;
+
+	// Check horizontal total
+	value = var->xres + var->left_margin + var->right_margin + var->hsync_len;
+	if (((value / 8) - 5) >= svga_regset_size (tm->h_total_regs)) return -EINVAL;
+
+	// Check horizontal display and blank start
+	value = var->xres;
+	if (((value / 8) - 1) >= svga_regset_size (tm->h_display_regs)) return -EINVAL;
+	if (((value / 8) - 1) >= svga_regset_size (tm->h_blank_start_regs)) return -EINVAL;
+
+	// Check horizontal sync start
+	value = var->xres + var->right_margin;
+	if (((value / 8) - 1) >= svga_regset_size (tm->h_sync_start_regs)) return -EINVAL;
+
+	// Check horizontal blank end (or length)
+	value = var->left_margin + var->right_margin + var->hsync_len;
+	if ((value == 0) || ((value / 8) >= svga_regset_size (tm->h_blank_end_regs))) return -EINVAL;
+
+	// Check horizontal sync end (or length)
+	value = var->hsync_len;
+	if ((value == 0) || ((value / 8) >= svga_regset_size (tm->h_sync_end_regs))) return -EINVAL;
+
+	// Check vertical total
+	value = var->yres + var->upper_margin + var->lower_margin + var->vsync_len;
+	if ((value - 1) >= svga_regset_size(tm->v_total_regs)) return -EINVAL;
+
+	// Check vertical display and blank start
+	value = var->yres;
+	if ((value - 1) >= svga_regset_size(tm->v_display_regs)) return -EINVAL;
+	if ((value - 1) >= svga_regset_size(tm->v_blank_start_regs)) return -EINVAL;
+
+	// Check vertical sync start
+	value = var->yres + var->lower_margin;
+	if ((value - 1) >= svga_regset_size(tm->v_sync_start_regs)) return -EINVAL;
+
+	// Check vertical blank end (or length)
+	value = var->upper_margin + var->lower_margin + var->vsync_len;
+	if ((value == 0) || (value >= svga_regset_size (tm->v_blank_end_regs))) return -EINVAL;
+
+	// Check vertical sync end  (or length)
+	value = var->vsync_len;
+	if ((value == 0) || (value >= svga_regset_size (tm->v_sync_end_regs))) return -EINVAL;
+
+	return 0;
+}
+
+/* Set CRT timing registers */
+void svga_set_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var,
+			u32 hmul, u32 hdiv, u32 vmul, u32 vdiv, int node)
+{
+	u8 regval;
+	u32 value;
+
+	value = var->xres + var->left_margin + var->right_margin + var->hsync_len;
+	value = (value * hmul) / hdiv;
+	pr_debug("fb%d: horizontal total      : %d\n", node, value);
+	svga_wcrt_multi(tm->h_total_regs, (value / 8));
+	vga_wcrt(NULL, 0x3B, (value / 8) - 5);
+
+	value = var->xres;
+	value = (value * hmul) / hdiv;
+	pr_debug("fb%d: horizontal display    : %d\n", node, value);
+	svga_wcrt_multi(tm->h_display_regs, (value / 8) - 1);
+
+	value = var->xres;
+	value = (value * hmul) / hdiv;
+	pr_debug("fb%d: horizontal blank start: %d\n", node, value);
+	svga_wcrt_multi(tm->h_blank_start_regs, (value / 8));
+
+	value = var->xres + var->left_margin + var->right_margin + var->hsync_len;
+	value = (value * hmul) / hdiv;
+	pr_debug("fb%d: horizontal blank end  : %d\n", node, value);
+	svga_wcrt_multi(tm->h_blank_end_regs, (value / 8) - 2); /* really -2 ? */
+
+	value = var->xres + var->right_margin;
+	value = (value * hmul) / hdiv;
+	pr_debug("fb%d: horizontal sync start : %d\n", node, value);
+	svga_wcrt_multi(tm->h_sync_start_regs, (value / 8) + 2); /* why not -1 ? */
+
+	value = var->xres + var->right_margin + var->hsync_len;
+	value = (value * hmul) / hdiv;
+	pr_debug("fb%d: horizontal sync end   : %d\n", node, value);
+	svga_wcrt_multi(tm->h_sync_end_regs, (value / 8) + 1); /* why not -1 ? */
+
+	value = var->yres + var->upper_margin + var->lower_margin + var->vsync_len;
+	value = (value * vmul) / vdiv;
+	pr_debug("fb%d: vertical total        : %d\n", node, value);
+	svga_wcrt_multi(tm->v_total_regs, value - 2);
+
+	value = var->yres;
+	value = (value * vmul) / vdiv;
+	pr_debug("fb%d: vertical display      : %d\n", node, value);
+	svga_wcrt_multi(tm->v_display_regs, value - 1);
+
+	value = var->yres;
+	value = (value * vmul) / vdiv;
+	pr_debug("fb%d: vertical blank start  : %d\n", node, value);
+	svga_wcrt_multi(tm->v_blank_start_regs, value);
+
+	value = var->yres + var->upper_margin + var->lower_margin + var->vsync_len;
+	value = (value * vmul) / vdiv;
+	pr_debug("fb%d: vertical blank end    : %d\n", node, value);
+	svga_wcrt_multi(tm->v_blank_end_regs, value - 2); /* really -2 ? */
+
+	value = var->yres + var->lower_margin;
+	value = (value * vmul) / vdiv;
+	pr_debug("fb%d: vertical sync start   : %d\n", node, value);
+	svga_wcrt_multi(tm->v_sync_start_regs, value - 1);
+
+	value = var->yres + var->lower_margin + var->vsync_len;
+	value = (value * vmul) / vdiv;
+	pr_debug("fb%d: vertical sync end     : %d\n", node, value);
+	svga_wcrt_multi(tm->v_sync_end_regs, value - 1);
+
+	/* Set horizontal and vertical sync pulse polarity in misc register */
+
+	regval = vga_r(NULL, VGA_MIS_R);
+	if (var->sync & FB_SYNC_HOR_HIGH_ACT) {
+		pr_debug("fb%d: positive horizontal sync\n", node);
+		regval = regval & ~0x80;
+	} else {
+		pr_debug("fb%d: negative horizontal sync\n", node);
+		regval = regval | 0x80;
+	}
+	if (var->sync & FB_SYNC_VERT_HIGH_ACT) {
+		pr_debug("fb%d: positive vertical sync\n", node);
+		regval = regval & ~0x40;
+	} else {
+		pr_debug("fb%d: negative vertical sync\n\n", node);
+		regval = regval | 0x40;
+	}
+	vga_w(NULL, VGA_MIS_W, regval);
+}
+
+
+/* ------------------------------------------------------------------------- */
+
+
+int svga_match_format(const struct svga_fb_format *frm, struct fb_var_screeninfo *var, struct fb_fix_screeninfo *fix)
+{
+	int i = 0;
+
+	while (frm->bits_per_pixel != SVGA_FORMAT_END_VAL)
+	{
+		if ((var->bits_per_pixel == frm->bits_per_pixel) &&
+		    (var->red.length     <= frm->red.length)     &&
+		    (var->green.length   <= frm->green.length)   &&
+		    (var->blue.length    <= frm->blue.length)    &&
+		    (var->transp.length  <= frm->transp.length)  &&
+		    (var->nonstd	 == frm->nonstd)) {
+		    	var->bits_per_pixel = frm->bits_per_pixel;
+			var->red            = frm->red;
+			var->green          = frm->green;
+			var->blue           = frm->blue;
+			var->transp         = frm->transp;
+			var->nonstd         = frm->nonstd;
+			if (fix != NULL) {
+				fix->type      = frm->type;
+				fix->type_aux  = frm->type_aux;
+				fix->visual    = frm->visual;
+				fix->xpanstep  = frm->xpanstep;
+			}
+			return i;
+		}
+		i++;
+		frm++;
+	}
+	return -EINVAL;
+}
+
+
+EXPORT_SYMBOL(svga_wseq_multi);
+EXPORT_SYMBOL(svga_wcrt_multi);
+EXPORT_SYMBOL(svga_regset_size);
+
+EXPORT_SYMBOL(svga_set_default_gfx_regs);
+EXPORT_SYMBOL(svga_set_default_atc_regs);
+EXPORT_SYMBOL(svga_set_default_seq_regs);
+EXPORT_SYMBOL(svga_set_default_crt_regs);
+EXPORT_SYMBOL(svga_set_textmode_vga_regs);
+
+EXPORT_SYMBOL(svga_dump_var);
+
+EXPORT_SYMBOL(svga_compute_pll);
+EXPORT_SYMBOL(svga_check_timings);
+EXPORT_SYMBOL(svga_set_timings);
+EXPORT_SYMBOL(svga_match_format);
+
+MODULE_AUTHOR("Ondrej Zajicek <santiago@crfreenet.org>");
+MODULE_DESCRIPTION("Common utility functions for VGA-based graphics cards");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/svga.h
--- /dev/null
+++ a/include/linux/svga.h
@@ -0,0 +1,113 @@
+#ifndef _LINUX_SVGA_H
+#define _LINUX_SVGA_H
+
+#ifdef __KERNEL__
+
+#include <video/vga.h>
+
+/* Terminator for register set */
+
+#define VGA_REGSET_END_VAL	0xFF
+#define VGA_REGSET_END		{VGA_REGSET_END_VAL, 0, 0}
+
+struct vga_regset {
+	__u8 regnum;
+	__u8 lowbit;
+	__u8 highbit;
+};
+
+/* ------------------------------------------------------------------------- */
+
+#define SVGA_FORMAT_END_VAL	0xFFFF
+#define SVGA_FORMAT_END		{SVGA_FORMAT_END_VAL, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, {0, 0, 0}, 0, 0, 0, 0, 0, 0}
+
+struct svga_fb_format {
+	/* var part */
+	u32 bits_per_pixel;
+	struct fb_bitfield red;
+	struct fb_bitfield green;
+	struct fb_bitfield blue;
+	struct fb_bitfield transp;
+	u32 nonstd;
+	/* fix part */
+	u32 type;
+	u32 type_aux;
+	u32 visual;
+	u32 xpanstep;
+	u32 xresstep;
+};
+
+struct svga_timing_regs {
+	const struct vga_regset *h_total_regs;
+	const struct vga_regset *h_display_regs;
+	const struct vga_regset *h_blank_start_regs;
+	const struct vga_regset *h_blank_end_regs;
+	const struct vga_regset *h_sync_start_regs;
+	const struct vga_regset *h_sync_end_regs;
+
+	const struct vga_regset *v_total_regs;
+	const struct vga_regset *v_display_regs;
+	const struct vga_regset *v_blank_start_regs;
+	const struct vga_regset *v_blank_end_regs;
+	const struct vga_regset *v_sync_start_regs;
+	const struct vga_regset *v_sync_end_regs;
+};
+
+struct svga_pll {
+	u16 m_min;
+	u16 m_max;
+	u16 n_min;
+	u16 n_max;
+	u16 r_min;
+	u16 r_max;  /* r_max < 32 */
+	u32 f_vco_min;
+	u32 f_vco_max;
+	u32 f_base;
+};
+
+
+/* Write a value to the attribute register */
+
+static inline void svga_wattr(u8 index, u8 data) {
+
+	inb(0x3DA);
+	outb(index, 0x3C0);
+	outb(data, 0x3C0);
+}
+
+/* Write a value to a sequence register with a mask */
+
+static inline void svga_wseq_mask(u8 index, u8 data, u8 mask) {
+
+	vga_wseq(NULL, index, (data & mask) | (vga_rseq(NULL, index) & ~mask));
+}
+
+/* Write a value to a CRT register with a mask */
+
+static inline void svga_wcrt_mask(u8 index, u8 data, u8 mask) {
+
+	vga_wcrt(NULL, index, (data & mask) | (vga_rcrt(NULL, index) & ~mask));
+}
+
+
+void svga_wcrt_multi(const struct vga_regset *regset, u32 value);
+void svga_wseq_multi(const struct vga_regset *regset, u32 value);
+unsigned int svga_regset_size(const struct vga_regset *regset);
+
+void svga_set_default_gfx_regs(void);
+void svga_set_default_atc_regs(void);
+void svga_set_default_seq_regs(void);
+void svga_set_default_crt_regs(void);
+void svga_set_textmode_vga_regs(void);
+
+void svga_dump_var(struct fb_var_screeninfo *var, int node);
+
+int svga_compute_pll(const struct svga_pll *pll, u32 f_wanted, u16 *m, u16 *n, u16 *r, int node);
+int svga_check_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var, int node);
+void svga_set_timings(const struct svga_timing_regs *tm, struct fb_var_screeninfo *var, u32 hmul, u32 hdiv, u32 vmul, u32 vdiv, int node);
+
+int svga_match_format(const struct svga_fb_format *frm, struct fb_var_screeninfo *var, struct fb_fix_screeninfo *fix);
+
+#endif /* __KERNEL__  */
+#endif /* _LINUX_SVGA_H */
+
_

Patches currently in -mm which might be from santiago@crfreenet.org are

fbdev-driver-for-s3-trio-virge.patch

