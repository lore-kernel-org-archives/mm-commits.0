From: akpm@linux-foundation.org
Subject: [merged] mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:46 -0800
Message-ID: <200912162035.nBGKZkN0013119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935429AbZLPUgP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valentin.sitdikov@siemens.com, agust@denx.de, krzysztof.h1@poczta.fm, virtuoso@slind.org, mm-commits@vger.kernel.org


The patch titled
     mb862xxfb: add acceleration support for Coral-P/Coral-PA. * imageblt * copyarea * fillrect
has been removed from the -mm tree.  Its filename was
     mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mb862xxfb: add acceleration support for Coral-P/Coral-PA. * imageblt * copyarea * fillrect
From: Valentin Sitdikov <valentin.sitdikov@siemens.com>

[akpm@linux-foundation.org: clean up comments, remove do-nothing tests, use min()]
[akpm@linux-foundation.org: fix Alexandr's email address]
[akpm@linux-foundation.org: export mb862xxfb_init_accel]
Signed-off-by: Valentin Sitdikov <valentin.sitdikov@siemens.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mb862xx/Makefile          |    2 
 drivers/video/mb862xx/mb862xxfb.c       |   14 
 drivers/video/mb862xx/mb862xxfb.h       |    2 
 drivers/video/mb862xx/mb862xxfb_accel.c |  331 ++++++++++++++++++++++
 drivers/video/mb862xx/mb862xxfb_accel.h |  203 +++++++++++++
 5 files changed, 551 insertions(+), 1 deletion(-)

diff -puN drivers/video/mb862xx/Makefile~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect drivers/video/mb862xx/Makefile
--- a/drivers/video/mb862xx/Makefile~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect
+++ a/drivers/video/mb862xx/Makefile
@@ -2,4 +2,4 @@
 # Makefile for the MB862xx framebuffer driver
 #
 
-obj-$(CONFIG_FB_MB862XX)	:= mb862xxfb.o
+obj-$(CONFIG_FB_MB862XX)	:= mb862xxfb.o mb862xxfb_accel.o
diff -puN drivers/video/mb862xx/mb862xxfb.c~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect drivers/video/mb862xx/mb862xxfb.c
--- a/drivers/video/mb862xx/mb862xxfb.c~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect
+++ a/drivers/video/mb862xx/mb862xxfb.c
@@ -214,6 +214,8 @@ static int mb862xxfb_set_par(struct fb_i
 	unsigned long reg, sc;
 
 	dev_dbg(par->dev, "%s\n", __func__);
+	if (par->type == BT_CORALP)
+		mb862xxfb_init_accel(fbi, fbi->var.xres);
 
 	if (par->pre_init)
 		return 0;
@@ -453,6 +455,18 @@ static ssize_t mb862xxfb_show_dispregs(s
 		ptr += sprintf(ptr, "%08x = %08x\n",
 			       reg, inreg(disp, reg));
 
+	for (reg = 0x400; reg <= 0x410; reg += 4)
+		ptr += sprintf(ptr, "geo %08x = %08x\n",
+			       reg, inreg(geo, reg));
+
+	for (reg = 0x400; reg <= 0x410; reg += 4)
+		ptr += sprintf(ptr, "draw %08x = %08x\n",
+			       reg, inreg(draw, reg));
+
+	for (reg = 0x440; reg <= 0x450; reg += 4)
+		ptr += sprintf(ptr, "draw %08x = %08x\n",
+			       reg, inreg(draw, reg));
+
 	return ptr - buf;
 }
 
diff -puN drivers/video/mb862xx/mb862xxfb.h~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect drivers/video/mb862xx/mb862xxfb.h
--- a/drivers/video/mb862xx/mb862xxfb.h~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect
+++ a/drivers/video/mb862xx/mb862xxfb.h
@@ -61,6 +61,8 @@ struct mb862xxfb_par {
 	u32			pseudo_palette[16];
 };
 
+extern void mb862xxfb_init_accel(struct fb_info *info, int xres);
+
 #if defined(CONFIG_FB_MB862XX_LIME) && defined(CONFIG_FB_MB862XX_PCI_GDC)
 #error	"Select Lime GDC or CoralP/Carmine support, but not both together"
 #endif
diff -puN /dev/null drivers/video/mb862xx/mb862xxfb_accel.c
--- /dev/null
+++ a/drivers/video/mb862xx/mb862xxfb_accel.c
@@ -0,0 +1,331 @@
+/*
+ * drivers/mb862xx/mb862xxfb_accel.c
+ *
+ * Fujitsu Carmine/Coral-P(A)/Lime framebuffer driver acceleration support
+ *
+ * (C) 2007 Alexander Shishkin <virtuoso@slind.org>
+ * (C) 2009 Valentin Sitdikov <valentin.sitdikov@siemens.com>
+ * (C) 2009 Siemens AG
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/fb.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#if defined(CONFIG_OF)
+#include <linux/of_platform.h>
+#endif
+#include "mb862xxfb.h"
+#include "mb862xx_reg.h"
+#include "mb862xxfb_accel.h"
+
+static void mb862xxfb_write_fifo(u32 count, u32 *data, struct fb_info *info)
+{
+	struct mb862xxfb_par *par = info->par;
+	static u32 free;
+
+	u32 total = 0;
+	while (total < count) {
+		if (free) {
+			outreg(geo, GDC_GEO_REG_INPUT_FIFO, data[total]);
+			total++;
+			free--;
+		} else {
+			free = (u32) inreg(draw, GDC_REG_FIFO_COUNT);
+		}
+	}
+}
+
+static void mb86290fb_copyarea(struct fb_info *info,
+			       const struct fb_copyarea *area)
+{
+	__u32 cmd[6];
+
+	cmd[0] = (GDC_TYPE_SETREGISTER << 24) | (1 << 16) | GDC_REG_MODE_BITMAP;
+	/* Set raster operation */
+	cmd[1] = (2 << 7) | (GDC_ROP_COPY << 9);
+	cmd[2] = GDC_TYPE_BLTCOPYP << 24;
+
+	if (area->sx >= area->dx && area->sy >= area->dy)
+		cmd[2] |= GDC_CMD_BLTCOPY_TOP_LEFT << 16;
+	else if (area->sx >= area->dx && area->sy <= area->dy)
+		cmd[2] |= GDC_CMD_BLTCOPY_BOTTOM_LEFT << 16;
+	else if (area->sx <= area->dx && area->sy >= area->dy)
+		cmd[2] |= GDC_CMD_BLTCOPY_TOP_RIGHT << 16;
+	else
+		cmd[2] |= GDC_CMD_BLTCOPY_BOTTOM_RIGHT << 16;
+
+	cmd[3] = (area->sy << 16) | area->sx;
+	cmd[4] = (area->dy << 16) | area->dx;
+	cmd[5] = (area->height << 16) | area->width;
+	mb862xxfb_write_fifo(6, cmd, info);
+}
+
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 1bit image.
+ * Make sure cmd has enough room!
+ */
+static void mb86290fb_imageblit1(u32 *cmd, u16 step, u16 dx, u16 dy,
+				 u16 width, u16 height, u32 fgcolor,
+				 u32 bgcolor, const struct fb_image *image,
+				 struct fb_info *info)
+{
+	int i;
+	unsigned const char *line;
+	u16 bytes;
+
+	/* set colors and raster operation regs */
+	cmd[0] = (GDC_TYPE_SETREGISTER << 24) | (1 << 16) | GDC_REG_MODE_BITMAP;
+	/* Set raster operation */
+	cmd[1] = (2 << 7) | (GDC_ROP_COPY << 9);
+	cmd[2] =
+	    (GDC_TYPE_SETCOLORREGISTER << 24) | (GDC_CMD_BODY_FORE_COLOR << 16);
+	cmd[3] = fgcolor;
+	cmd[4] =
+	    (GDC_TYPE_SETCOLORREGISTER << 24) | (GDC_CMD_BODY_BACK_COLOR << 16);
+	cmd[5] = bgcolor;
+
+	i = 0;
+	line = image->data;
+	bytes = (image->width + 7) >> 3;
+
+	/* and the image */
+	cmd[6] = (GDC_TYPE_DRAWBITMAPP << 24) |
+	    (GDC_CMD_BITMAP << 16) | (2 + (step * height));
+	cmd[7] = (dy << 16) | dx;
+	cmd[8] = (height << 16) | width;
+
+	while (i < height) {
+		memcpy(&cmd[9 + i * step], line, step << 2);
+#ifdef __LITTLE_ENDIAN
+		{
+			int k = 0;
+			for (k = 0; k < step; k++)
+				cmd[9 + i * step + k] =
+				    cpu_to_be32(cmd[9 + i * step + k]);
+		}
+#endif
+		line += bytes;
+		i++;
+	}
+}
+
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 8bit image.
+ * Make sure cmd has enough room!
+ */
+static void mb86290fb_imageblit8(u32 *cmd, u16 step, u16 dx, u16 dy,
+				 u16 width, u16 height, u32 fgcolor,
+				 u32 bgcolor, const struct fb_image *image,
+				 struct fb_info *info)
+{
+	int i, j;
+	unsigned const char *line, *ptr;
+	u16 bytes;
+
+	cmd[0] = (GDC_TYPE_DRAWBITMAPP << 24) |
+	    (GDC_CMD_BLT_DRAW << 16) | (2 + (height * step));
+	cmd[1] = (dy << 16) | dx;
+	cmd[2] = (height << 16) | width;
+
+	i = 0;
+	line = ptr = image->data;
+	bytes = image->width;
+
+	while (i < height) {
+		ptr = line;
+		for (j = 0; j < step; j++) {
+			cmd[3 + i * step + j] =
+			    (((u32 *) (info->pseudo_palette))[*ptr]) & 0xffff;
+			ptr++;
+			cmd[3 + i * step + j] |=
+			    ((((u32 *) (info->
+					pseudo_palette))[*ptr]) & 0xffff) << 16;
+			ptr++;
+		}
+
+		line += bytes;
+		i++;
+	}
+}
+
+/*
+ * Fill in the cmd array /GDC FIFO commands/ to draw a 16bit image.
+ * Make sure cmd has enough room!
+ */
+static void mb86290fb_imageblit16(u32 *cmd, u16 step, u16 dx, u16 dy,
+				  u16 width, u16 height, u32 fgcolor,
+				  u32 bgcolor, const struct fb_image *image,
+				  struct fb_info *info)
+{
+	int i;
+	unsigned const char *line;
+	u16 bytes;
+
+	i = 0;
+	line = image->data;
+	bytes = image->width << 1;
+
+	cmd[0] = (GDC_TYPE_DRAWBITMAPP << 24) |
+	    (GDC_CMD_BLT_DRAW << 16) | (2 + step * height);
+	cmd[1] = (dy << 16) | dx;
+	cmd[2] = (height << 16) | width;
+
+	while (i < height) {
+		memcpy(&cmd[3 + i * step], line, step);
+		line += bytes;
+		i++;
+	}
+}
+
+static void mb86290fb_imageblit(struct fb_info *info,
+				const struct fb_image *image)
+{
+	int mdr;
+	u32 *cmd = NULL;
+	void (*cmdfn) (u32 *, u16, u16, u16, u16, u16, u32, u32,
+		       const struct fb_image *, struct fb_info *) = NULL;
+	u32 cmdlen;
+	u32 fgcolor = 0, bgcolor = 0;
+	u16 step;
+
+	u16 width = image->width, height = image->height;
+	u16 dx = image->dx, dy = image->dy;
+	int x2, y2, vxres, vyres;
+
+	mdr = (GDC_ROP_COPY << 9);
+	x2 = image->dx + image->width;
+	y2 = image->dy + image->height;
+	vxres = info->var.xres_virtual;
+	vyres = info->var.yres_virtual;
+	x2 = min(x2, vxres);
+	y2 = min(y2, vyres);
+	width = x2 - dx;
+	height = y2 - dy;
+
+	switch (image->depth) {
+	case 1:
+		step = (width + 31) >> 5;
+		cmdlen = 9 + height * step;
+		cmdfn = mb86290fb_imageblit1;
+		if (info->fix.visual == FB_VISUAL_TRUECOLOR ||
+		    info->fix.visual == FB_VISUAL_DIRECTCOLOR) {
+			fgcolor =
+			    ((u32 *) (info->pseudo_palette))[image->fg_color];
+			bgcolor =
+			    ((u32 *) (info->pseudo_palette))[image->bg_color];
+		} else {
+			fgcolor = image->fg_color;
+			bgcolor = image->bg_color;
+		}
+
+		break;
+
+	case 8:
+		step = (width + 1) >> 1;
+		cmdlen = 3 + height * step;
+		cmdfn = mb86290fb_imageblit8;
+		break;
+
+	case 16:
+		step = (width + 1) >> 1;
+		cmdlen = 3 + height * step;
+		cmdfn = mb86290fb_imageblit16;
+		break;
+
+	default:
+		cfb_imageblit(info, image);
+		return;
+	}
+
+	cmd = kmalloc(cmdlen * 4, GFP_DMA);
+	if (!cmd)
+		return cfb_imageblit(info, image);
+	cmdfn(cmd, step, dx, dy, width, height, fgcolor, bgcolor, image, info);
+	mb862xxfb_write_fifo(cmdlen, cmd, info);
+	kfree(cmd);
+}
+
+static void mb86290fb_fillrect(struct fb_info *info,
+			       const struct fb_fillrect *rect)
+{
+
+	u32 x2, y2, vxres, vyres, height, width, fg;
+	u32 cmd[7];
+
+	vxres = info->var.xres_virtual;
+	vyres = info->var.yres_virtual;
+
+	if (!rect->width || !rect->height || rect->dx > vxres
+	    || rect->dy > vyres)
+		return;
+
+	/* We could use hardware clipping but on many cards you get around
+	 * hardware clipping by writing to framebuffer directly. */
+	x2 = rect->dx + rect->width;
+	y2 = rect->dy + rect->height;
+	x2 = min(x2, vxres);
+	y2 = min(y2, vyres);
+	width = x2 - rect->dx;
+	height = y2 - rect->dy;
+	if (info->fix.visual == FB_VISUAL_TRUECOLOR ||
+	    info->fix.visual == FB_VISUAL_DIRECTCOLOR)
+		fg = ((u32 *) (info->pseudo_palette))[rect->color];
+	else
+		fg = rect->color;
+
+	switch (rect->rop) {
+
+	case ROP_XOR:
+		/* Set raster operation */
+		cmd[1] = (2 << 7) | (GDC_ROP_XOR << 9);
+		break;
+
+	case ROP_COPY:
+		/* Set raster operation */
+		cmd[1] = (2 << 7) | (GDC_ROP_COPY << 9);
+		break;
+
+	}
+
+	cmd[0] = (GDC_TYPE_SETREGISTER << 24) | (1 << 16) | GDC_REG_MODE_BITMAP;
+	/* cmd[1] set earlier */
+	cmd[2] =
+	    (GDC_TYPE_SETCOLORREGISTER << 24) | (GDC_CMD_BODY_FORE_COLOR << 16);
+	cmd[3] = fg;
+	cmd[4] = (GDC_TYPE_DRAWRECTP << 24) | (GDC_CMD_BLT_FILL << 16);
+	cmd[5] = (rect->dy << 16) | (rect->dx);
+	cmd[6] = (height << 16) | width;
+
+	mb862xxfb_write_fifo(7, cmd, info);
+}
+
+void mb862xxfb_init_accel(struct fb_info *info, int xres)
+{
+	struct mb862xxfb_par *par = info->par;
+
+	if (info->var.bits_per_pixel == 32) {
+		info->fbops->fb_fillrect = cfb_fillrect;
+		info->fbops->fb_copyarea = cfb_copyarea;
+		info->fbops->fb_imageblit = cfb_imageblit;
+	} else {
+		outreg(disp, GC_L0EM, 3);
+		info->fbops->fb_fillrect = mb86290fb_fillrect;
+		info->fbops->fb_copyarea = mb86290fb_copyarea;
+		info->fbops->fb_imageblit = mb86290fb_imageblit;
+	}
+	outreg(draw, GDC_REG_DRAW_BASE, 0);
+	outreg(draw, GDC_REG_MODE_MISC, 0x8000);
+	outreg(draw, GDC_REG_X_RESOLUTION, xres);
+
+	info->flags |=
+	    FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT |
+	    FBINFO_HWACCEL_IMAGEBLIT;
+	info->fix.accel = 0xff;	/*FIXME: add right define */
+}
+EXPORT_SYMBOL(mb862xxfb_init_accel);
diff -puN /dev/null drivers/video/mb862xx/mb862xxfb_accel.h
--- /dev/null
+++ a/drivers/video/mb862xx/mb862xxfb_accel.h
@@ -0,0 +1,203 @@
+#ifndef __MB826XXFB_ACCEL_H__
+#define __MB826XXFB_ACCEL_H__
+
+/* registers */
+#define GDC_GEO_REG_INPUT_FIFO 0x00000400L
+
+/* Special Registers */
+#define GDC_REG_CTRL                0x00000400L
+#define GDC_REG_FIFO_STATUS         0x00000404L
+#define GDC_REG_FIFO_COUNT          0x00000408L
+#define GDC_REG_SETUP_STATUS        0x0000040CL
+#define GDC_REG_DDA_STATUS          0x00000410L
+#define GDC_REG_ENGINE_STATUS       0x00000414L
+#define GDC_REG_ERROR_STATUS        0x00000418L
+#define GDC_REG_MODE_MISC           0x00000420L	/* MDR0 */
+#define GDC_REG_MODE_LINE           0x00000424L	/* MDR1 */
+#define GDC_REG_MODE_POLYGON        0x00000428L	/* MDR2 */
+#define GDC_REG_MODE_TEXTURE        0x0000042CL	/* MDR3 */
+#define GDC_REG_MODE_BITMAP         0x00000430L	/* MDR4 */
+#define GDC_REG_MODE_EXTENSION      0x0000043CL	/* MDR7 */
+
+/* Configuration Registers */
+#define GDC_REG_DRAW_BASE           0x00000440L
+#define GDC_REG_X_RESOLUTION        0x00000444L
+#define GDC_REG_Z_BASE              0x00000448L
+#define GDC_REG_TEXTURE_BASE        0x0000044CL
+#define GDC_REG_POLYGON_FLAG_BASE   0x00000450L
+#define GDC_REG_CLIP_XMIN           0x00000454L
+#define GDC_REG_CLIP_XMAX           0x00000458L
+#define GDC_REG_CLIP_YMIN           0x0000045CL
+#define GDC_REG_CLIP_YMAX           0x00000460L
+#define GDC_REG_TEXURE_SIZE         0x00000464L
+#define GDC_REG_TILE_SIZE           0x00000468L
+#define GDC_REG_TEX_BUF_OFFSET      0x0000046CL
+
+/* for MB86293 or later */
+#define GDC_REG_ALPHA_MAP_BASE      0x00000474L	/* ABR */
+
+/* Constant Registers */
+#define GDC_REG_FOREGROUND_COLOR    0x00000480L
+#define GDC_REG_BACKGROUND_COLOR    0x00000484L
+#define GDC_REG_ALPHA               0x00000488L
+#define GDC_REG_LINE_PATTERN        0x0000048CL
+#define GDC_REG_TEX_BORDER_COLOR    0x00000494L
+#define GDC_REG_LINE_PATTERN_OFFSET 0x000003E0L
+
+/* Coomand Code */
+#define GDC_CMD_PIXEL                   0x00000000L
+#define GDC_CMD_PIXEL_Z                 0x00000001L
+
+#define GDC_CMD_X_VECTOR                0x00000020L
+#define GDC_CMD_Y_VECTOR                0x00000021L
+#define GDC_CMD_X_VECTOR_NOEND          0x00000022L
+#define GDC_CMD_Y_VECTOR_NOEND          0x00000023L
+#define GDC_CMD_X_VECTOR_BLPO           0x00000024L
+#define GDC_CMD_Y_VECTOR_BLPO           0x00000025L
+#define GDC_CMD_X_VECTOR_NOEND_BLPO     0x00000026L
+#define GDC_CMD_Y_VECTOR_NOEND_BLPO     0x00000027L
+#define GDC_CMD_AA_X_VECTOR             0x00000028L
+#define GDC_CMD_AA_Y_VECTOR             0x00000029L
+#define GDC_CMD_AA_X_VECTOR_NOEND       0x0000002AL
+#define GDC_CMD_AA_Y_VECTOR_NOEND       0x0000002BL
+#define GDC_CMD_AA_X_VECTOR_BLPO        0x0000002CL
+#define GDC_CMD_AA_Y_VECTOR_BLPO        0x0000002DL
+#define GDC_CMD_AA_X_VECTOR_NOEND_BLPO  0x0000002EL
+#define GDC_CMD_AA_Y_VECTOR_NOEND_BLPO  0x0000002FL
+
+#define GDC_CMD_0_VECTOR                0x00000030L
+#define GDC_CMD_1_VECTOR                0x00000031L
+#define GDC_CMD_0_VECTOR_NOEND          0x00000032L
+#define GDC_CMD_1_VECTOR_NOEND          0x00000033L
+#define GDC_CMD_0_VECTOR_BLPO           0x00000034L
+#define GDC_CMD_1_VECTOR_BLPO           0x00000035L
+#define GDC_CMD_0_VECTOR_NOEND_BLPO     0x00000036L
+#define GDC_CMD_1_VECTOR_NOEND_BLPO     0x00000037L
+#define GDC_CMD_AA_0_VECTOR             0x00000038L
+#define GDC_CMD_AA_1_VECTOR             0x00000039L
+#define GDC_CMD_AA_0_VECTOR_NOEND       0x0000003AL
+#define GDC_CMD_AA_1_VECTOR_NOEND       0x0000003BL
+#define GDC_CMD_AA_0_VECTOR_BLPO        0x0000003CL
+#define GDC_CMD_AA_1_VECTOR_BLPO        0x0000003DL
+#define GDC_CMD_AA_0_VECTOR_NOEND_BLPO  0x0000003EL
+#define GDC_CMD_AA_1_VECTOR_NOEND_BLPO  0x0000003FL
+
+#define GDC_CMD_BLT_FILL                0x00000041L
+#define GDC_CMD_BLT_DRAW                0x00000042L
+#define GDC_CMD_BITMAP                  0x00000043L
+#define GDC_CMD_BLTCOPY_TOP_LEFT        0x00000044L
+#define GDC_CMD_BLTCOPY_TOP_RIGHT       0x00000045L
+#define GDC_CMD_BLTCOPY_BOTTOM_LEFT     0x00000046L
+#define GDC_CMD_BLTCOPY_BOTTOM_RIGHT    0x00000047L
+#define GDC_CMD_LOAD_TEXTURE            0x00000048L
+#define GDC_CMD_LOAD_TILE               0x00000049L
+
+#define GDC_CMD_TRAP_RIGHT              0x00000060L
+#define GDC_CMD_TRAP_LEFT               0x00000061L
+#define GDC_CMD_TRIANGLE_FAN            0x00000062L
+#define GDC_CMD_FLAG_TRIANGLE_FAN       0x00000063L
+
+#define GDC_CMD_FLUSH_FB                0x000000C1L
+#define GDC_CMD_FLUSH_Z                 0x000000C2L
+
+#define GDC_CMD_POLYGON_BEGIN           0x000000E0L
+#define GDC_CMD_POLYGON_END             0x000000E1L
+#define GDC_CMD_CLEAR_POLY_FLAG         0x000000E2L
+#define GDC_CMD_NORMAL                  0x000000FFL
+
+#define GDC_CMD_VECTOR_BLPO_FLAG        0x00040000L
+#define GDC_CMD_FAST_VECTOR_BLPO_FLAG   0x00000004L
+
+/* for MB86293 or later */
+#define GDC_CMD_MDR1                            0x00000000L
+#define GDC_CMD_MDR1S                           0x00000002L
+#define GDC_CMD_MDR1B                           0x00000004L
+#define GDC_CMD_MDR2                            0x00000001L
+#define GDC_CMD_MDR2S                           0x00000003L
+#define GDC_CMD_MDR2TL                          0x00000007L
+#define GDC_CMD_GMDR1E                          0x00000010L
+#define GDC_CMD_GMDR2E                          0x00000020L
+#define GDC_CMD_OVERLAP_SHADOW_XY               0x00000000L
+#define GDC_CMD_OVERLAP_SHADOW_XY_COMPOSITION   0x00000001L
+#define GDC_CMD_OVERLAP_Z_PACKED_ONBS           0x00000007L
+#define GDC_CMD_OVERLAP_Z_ORIGIN                0x00000000L
+#define GDC_CMD_OVERLAP_Z_NON_TOPLEFT           0x00000001L
+#define GDC_CMD_OVERLAP_Z_BORDER                0x00000002L
+#define GDC_CMD_OVERLAP_Z_SHADOW                0x00000003L
+#define GDC_CMD_BLTCOPY_ALT_ALPHA               0x00000000L	/* Reserverd */
+#define GDC_CMD_DC_LOGOUT                       0x00000000L	/* Reserverd */
+#define GDC_CMD_BODY_FORE_COLOR                 0x00000000L
+#define GDC_CMD_BODY_BACK_COLOR                 0x00000001L
+#define GDC_CMD_SHADOW_FORE_COLOR               0x00000002L
+#define GDC_CMD_SHADOW_BACK_COLOR               0x00000003L
+#define GDC_CMD_BORDER_FORE_COLOR               0x00000004L
+#define GDC_CMD_BORDER_BACK_COLOR               0x00000005L
+
+/* Type Code Table */
+#define GDC_TYPE_G_NOP                                  0x00000020L
+#define GDC_TYPE_G_BEGIN                                0x00000021L
+#define GDC_TYPE_G_BEGINCONT                            0x00000022L
+#define GDC_TYPE_G_END                                  0x00000023L
+#define GDC_TYPE_G_VERTEX                               0x00000030L
+#define GDC_TYPE_G_VERTEXLOG                            0x00000032L
+#define GDC_TYPE_G_VERTEXNOPLOG                         0x00000033L
+#define GDC_TYPE_G_INIT                                 0x00000040L
+#define GDC_TYPE_G_VIEWPORT                             0x00000041L
+#define GDC_TYPE_G_DEPTHRANGE                           0x00000042L
+#define GDC_TYPE_G_LOADMATRIX                           0x00000043L
+#define GDC_TYPE_G_VIEWVOLUMEXYCLIP                     0x00000044L
+#define GDC_TYPE_G_VIEWVOLUMEZCLIP                      0x00000045L
+#define GDC_TYPE_G_VIEWVOLUMEWCLIP                      0x00000046L
+#define GDC_TYPE_SETLVERTEX2I                           0x00000072L
+#define GDC_TYPE_SETLVERTEX2IP                          0x00000073L
+#define GDC_TYPE_SETMODEREGISTER                        0x000000C0L
+#define GDC_TYPE_SETGMODEREGISTER                       0x000000C1L
+#define GDC_TYPE_OVERLAPXYOFFT                          0x000000C8L
+#define GDC_TYPE_OVERLAPZOFFT                           0x000000C9L
+#define GDC_TYPE_DC_LOGOUTADDR                          0x000000CCL
+#define GDC_TYPE_SETCOLORREGISTER                       0x000000CEL
+#define GDC_TYPE_G_BEGINE                               0x000000E1L
+#define GDC_TYPE_G_BEGINCONTE                           0x000000E2L
+#define GDC_TYPE_G_ENDE                                 0x000000E3L
+#define GDC_TYPE_DRAWPIXEL                              0x00000000L
+#define GDC_TYPE_DRAWPIXELZ                             0x00000001L
+#define GDC_TYPE_DRAWLINE                               0x00000002L
+#define GDC_TYPE_DRAWLINE2I                             0x00000003L
+#define GDC_TYPE_DRAWLINE2IP                            0x00000004L
+#define GDC_TYPE_DRAWTRAP                               0x00000005L
+#define GDC_TYPE_DRAWVERTEX2I                           0x00000006L
+#define GDC_TYPE_DRAWVERTEX2IP                          0x00000007L
+#define GDC_TYPE_DRAWRECTP                              0x00000009L
+#define GDC_TYPE_DRAWBITMAPP                            0x0000000BL
+#define GDC_TYPE_BLTCOPYP                               0x0000000DL
+#define GDC_TYPE_BLTCOPYALTERNATEP                      0x0000000FL
+#define GDC_TYPE_LOADTEXTUREP                           0x00000011L
+#define GDC_TYPE_BLTTEXTUREP                            0x00000013L
+#define GDC_TYPE_BLTCOPYALTALPHABLENDP                  0x0000001FL
+#define GDC_TYPE_SETVERTEX2I                            0x00000070L
+#define GDC_TYPE_SETVERTEX2IP                           0x00000071L
+#define GDC_TYPE_DRAW                                   0x000000F0L
+#define GDC_TYPE_SETREGISTER                            0x000000F1L
+#define GDC_TYPE_SYNC                                   0x000000FCL
+#define GDC_TYPE_INTERRUPT                              0x000000FDL
+#define GDC_TYPE_NOP                                    0x0
+
+/* Raster operation */
+#define GDC_ROP_CLEAR                   0x0000
+#define GDC_ROP_AND                     0x0001
+#define GDC_ROP_AND_REVERSE             0x0002
+#define GDC_ROP_COPY                    0x0003
+#define GDC_ROP_AND_INVERTED            0x0004
+#define GDC_ROP_NOP                     0x0005
+#define GDC_ROP_XOR                     0x0006
+#define GDC_ROP_OR                      0x0007
+#define GDC_ROP_NOR                     0x0008
+#define GDC_ROP_EQUIV                   0x0009
+#define GDC_ROP_INVERT                  0x000A
+#define GDC_ROP_OR_REVERSE              0x000B
+#define GDC_ROP_COPY_INVERTED           0x000C
+#define GDC_ROP_OR_INVERTED             0x000D
+#define GDC_ROP_NAND                    0x000E
+#define GDC_ROP_SET                     0x000F
+
+#endif
_

Patches currently in -mm which might be from valentin.sitdikov@siemens.com are

origin.patch

