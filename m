From: akpm@linux-foundation.org
Subject: + fbdev-driver-for-s3-trio-virge-update-2.patch added to -mm tree
Date: Fri, 09 Feb 2007 15:13:44 -0800
Message-ID: <200702092313.l19NDjQl028989@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53498 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbXBIXOB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 18:14:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santiago@crfreenet.org, jsimmons@infradead.org


The patch titled
     fbdev driver for S3 Trio/Virge, updated
has been added to the -mm tree.  Its filename is
     fbdev-driver-for-s3-trio-virge-update-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev driver for S3 Trio/Virge, updated
From: Ondrej Zajicek <santiago@crfreenet.org>

This is version 3. There are some minor modifications from version 2
(mostly coding style cleanups).

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3fb.c    |  435 ++++++++++++++++++++------------------
 drivers/video/svgalib.c |   86 ++++---
 include/linux/svga.h    |    6 
 3 files changed, 284 insertions(+), 243 deletions(-)

diff -puN drivers/video/s3fb.c~fbdev-driver-for-s3-trio-virge-update-2 drivers/video/s3fb.c
--- a/drivers/video/s3fb.c~fbdev-driver-for-s3-trio-virge-update-2
+++ a/drivers/video/s3fb.c
@@ -1,7 +1,7 @@
 /*
  * linux/drivers/video/s3fb.c -- Frame buffer device driver for S3 Trio/Virge
  *
- * Copyright (c) 2006 Ondrej Zajicek <santiago@crfreenet.org>
+ * Copyright (c) 2006-2007 Ondrej Zajicek <santiago@crfreenet.org>
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive for
@@ -32,12 +32,11 @@
 #endif
 
 struct s3fb_info {
-	struct fb_info fb;
-
 	int chip, rev, mclk_freq;
 	int mtrr_reg;
 	struct vgastate state;
-	atomic_t ref_count;
+	struct mutex open_lock;
+	unsigned int ref_count;
 	u32 pseudo_palette[16];
 };
 
@@ -141,9 +140,8 @@ static int mtrr = 1;
 
 static int fasttext = 1;
 
-#ifdef MODULE
 
-MODULE_AUTHOR("(c) 2006 Ondrej Zajicek <santiago@crfreenet.org>");
+MODULE_AUTHOR("(c) 2006-2007 Ondrej Zajicek <santiago@crfreenet.org>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("fbdev driver for S3 Trio/Virge");
 
@@ -158,7 +156,6 @@ MODULE_PARM_DESC(mtrr, "Enable write-com
 module_param(fasttext, int, 0644);
 MODULE_PARM_DESC(fasttext, "Enable S3 fast text mode (1=enable, 0=disable, default=1)");
 
-#endif
 
 /* ------------------------------------------------------------------------- */
 
@@ -209,7 +206,9 @@ static struct fb_tile_ops s3fb_fast_tile
 
 /* image data is MSB-first, fb structure is MSB-first too */
 static inline u32 expand_color(u32 c)
-{ return ((c & 1) | ((c & 2) << 7) | ((c & 4) << 14) | ((c & 8) << 21)) * 0xFF; }
+{
+	return ((c & 1) | ((c & 2) << 7) | ((c & 4) << 14) | ((c & 8) << 21)) * 0xFF;
+}
 
 /* s3fb_iplan_imageblit silently assumes that almost everything is 8-pixel aligned */
 static void s3fb_iplan_imageblit(struct fb_info *info, const struct fb_image *image)
@@ -223,7 +222,7 @@ static void s3fb_iplan_imageblit(struct 
 	int x, y;
 
 	src1 = image->data;
-        dst1 = info->screen_base + (image->dy * info->fix.line_length)
+	dst1 = info->screen_base + (image->dy * info->fix.line_length)
 		 + ((image->dx / 8) * 4);
 
 	for (y = 0; y < image->height; y++) {
@@ -248,7 +247,7 @@ static void s3fb_iplan_fillrect(struct f
 	u32 __iomem *dst;
 	int x, y;
 
-        dst1 = info->screen_base + (rect->dy * info->fix.line_length)
+	dst1 = info->screen_base + (rect->dy * info->fix.line_length)
 		 + ((rect->dx / 8) * 4);
 
 	for (y = 0; y < rect->height; y++) {
@@ -258,7 +257,6 @@ static void s3fb_iplan_fillrect(struct f
 		}
 		dst1 += info->fix.line_length;
 	}
-
 }
 
 
@@ -281,7 +279,7 @@ static void s3fb_cfb4_imageblit(struct f
 	int x, y;
 
 	src1 = image->data;
-        dst1 = info->screen_base + (image->dy * info->fix.line_length)
+	dst1 = info->screen_base + (image->dy * info->fix.line_length)
 		 + ((image->dx / 8) * 4);
 
 	for (y = 0; y < image->height; y++) {
@@ -295,7 +293,6 @@ static void s3fb_cfb4_imageblit(struct f
 		src1 += image->width / 8;
 		dst1 += info->fix.line_length;
 	}
-
 }
 
 static void s3fb_imageblit(struct fb_info *info, const struct fb_image *image)
@@ -354,10 +351,10 @@ static void s3_set_pixclock(struct fb_in
 
 static int s3fb_open(struct fb_info *info, int user)
 {
-	struct s3fb_info *par = (struct s3fb_info *) info;
-	unsigned int count = atomic_read(&(par->ref_count));
+	struct s3fb_info *par = info->par;
 
-	if (!count) {
+	mutex_lock(&(par->open_lock));
+	if (par->ref_count == 0) {
 		memset(&(par->state), 0, sizeof(struct vgastate));
 		par->state.flags = VGA_SAVE_MODE | VGA_SAVE_FONTS | VGA_SAVE_CMAP;
 		par->state.num_crtc = 0x70;
@@ -365,7 +362,8 @@ static int s3fb_open(struct fb_info *inf
 		save_vga(&(par->state));
 	}
 
-	atomic_inc(&(par->ref_count));
+	par->ref_count++;
+	mutex_unlock(&(par->open_lock));
 
 	return 0;
 }
@@ -374,16 +372,19 @@ static int s3fb_open(struct fb_info *inf
 
 static int s3fb_release(struct fb_info *info, int user)
 {
-	struct s3fb_info *par = (struct s3fb_info *) info;
-	unsigned int count = atomic_read(&(par->ref_count));
+	struct s3fb_info *par = info->par;
 
-	if (!count)
+	mutex_lock(&(par->open_lock));
+	if (par->ref_count == 0) {
+		mutex_unlock(&(par->open_lock));
 		return -EINVAL;
+	}
 
-	if (count == 1)
+	if (par->ref_count == 1)
 		restore_vga(&(par->state));
 
-	atomic_dec(&(par->ref_count));
+	par->ref_count--;
+	mutex_unlock(&(par->open_lock));
 
 	return 0;
 }
@@ -392,7 +393,7 @@ static int s3fb_release(struct fb_info *
 
 static int s3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
-	struct s3fb_info *par = (struct s3fb_info *) info;
+	struct s3fb_info *par = info->par;
 	int rv, mem, step;
 
 	/* Find appropriate format */
@@ -418,7 +419,8 @@ static int s3fb_check_var(struct fb_var_
 	mem = ((var->bits_per_pixel * var->xres_virtual) >> 3) * var->yres_virtual;
 	if (mem > info->screen_size)
 	{
-		printk(KERN_ERR "fb%d: not enough framebuffer memory (%d kB requested , %d kB available)\n", info->node, mem >> 10, (unsigned int) (info->screen_size >> 10));
+		printk(KERN_ERR "fb%d: not enough framebuffer memory (%d kB requested , %d kB available)\n",
+			info->node, mem >> 10, (unsigned int) (info->screen_size >> 10));
 		return -EINVAL;
 	}
 
@@ -436,7 +438,7 @@ static int s3fb_check_var(struct fb_var_
 
 static int s3fb_set_par(struct fb_info *info)
 {
-	struct s3fb_info *par = (struct s3fb_info *) info;
+	struct s3fb_info *par = info->par;
 	u32 value, mode, hmul, offset_value, screen_size, multiplex;
 	u32 bpp = info->var.bits_per_pixel;
 
@@ -526,8 +528,6 @@ static int s3fb_set_par(struct fb_info *
 	/* Disable Streams engine */
 	svga_wcrt_mask(0x67, 0x00, 0x0C);
 
-
-
 	mode = svga_match_format(s3fb_formats, &(info->var), &(info->fix));
 
 	/* S3 virge DX hack */
@@ -551,93 +551,93 @@ static int s3fb_set_par(struct fb_info *
 
 	/* Set mode-specific register values */
 	switch (mode) {
-		case 0:
-			pr_debug("fb%d: text mode\n", info->node);
-			svga_set_textmode_vga_regs();
-
-			/* Set additional registers like in 8-bit mode */
-			svga_wcrt_mask(0x50, 0x00, 0x30);
-			svga_wcrt_mask(0x67, 0x00, 0xF0);
-
-			/* Disable enhanced mode */
-			svga_wcrt_mask(0x3A, 0x00, 0x30);
+	case 0:
+		pr_debug("fb%d: text mode\n", info->node);
+		svga_set_textmode_vga_regs();
+
+		/* Set additional registers like in 8-bit mode */
+		svga_wcrt_mask(0x50, 0x00, 0x30);
+		svga_wcrt_mask(0x67, 0x00, 0xF0);
+
+		/* Disable enhanced mode */
+		svga_wcrt_mask(0x3A, 0x00, 0x30);
+
+		if (fasttext) {
+			pr_debug("fb%d: high speed text mode set\n", info->node);
+			svga_wcrt_mask(0x31, 0x40, 0x40);
+		}
+		break;
+	case 1:
+		pr_debug("fb%d: 4 bit pseudocolor\n", info->node);
+		vga_wgfx(NULL, VGA_GFX_MODE, 0x40);
+
+		/* Set additional registers like in 8-bit mode */
+		svga_wcrt_mask(0x50, 0x00, 0x30);
+		svga_wcrt_mask(0x67, 0x00, 0xF0);
 
-			if (fasttext) {
-				pr_debug("fb%d: high speed text mode set\n", info->node);
-				svga_wcrt_mask(0x31, 0x40, 0x40);
-			}
+		/* disable enhanced mode */
+		svga_wcrt_mask(0x3A, 0x00, 0x30);
 		break;
-		case 1:
-			pr_debug("fb%d: 4 bit pseudocolor\n", info->node);
-			vga_wgfx(NULL, VGA_GFX_MODE, 0x40);
+	case 2:
+		pr_debug("fb%d: 4 bit pseudocolor, planar\n", info->node);
 
-			/* Set additional registers like in 8-bit mode */
-			svga_wcrt_mask(0x50, 0x00, 0x30);
-			svga_wcrt_mask(0x67, 0x00, 0xF0);
+		/* Set additional registers like in 8-bit mode */
+		svga_wcrt_mask(0x50, 0x00, 0x30);
+		svga_wcrt_mask(0x67, 0x00, 0xF0);
 
-			/* disable enhanced mode */
-			svga_wcrt_mask(0x3A, 0x00, 0x30);
+		/* disable enhanced mode */
+		svga_wcrt_mask(0x3A, 0x00, 0x30);
 		break;
-		case 2:
-			pr_debug("fb%d: 4 bit pseudocolor, planar\n", info->node);
-
-			/* Set additional registers like in 8-bit mode */
+	case 3:
+		pr_debug("fb%d: 8 bit pseudocolor\n", info->node);
+		if (info->var.pixclock > 20000) {
 			svga_wcrt_mask(0x50, 0x00, 0x30);
 			svga_wcrt_mask(0x67, 0x00, 0xF0);
-
-			/* disable enhanced mode */
-			svga_wcrt_mask(0x3A, 0x00, 0x30);
-		break;
-		case 3:
-			pr_debug("fb%d: 8 bit pseudocolor\n", info->node);
-			if (info->var.pixclock > 20000) {
-				svga_wcrt_mask(0x50, 0x00, 0x30);
-				svga_wcrt_mask(0x67, 0x00, 0xF0);
-			} else {
-				svga_wcrt_mask(0x50, 0x00, 0x30);
-				svga_wcrt_mask(0x67, 0x10, 0xF0);
-				multiplex = 1;
-			}
+		} else {
+			svga_wcrt_mask(0x50, 0x00, 0x30);
+			svga_wcrt_mask(0x67, 0x10, 0xF0);
+			multiplex = 1;
+		}
 		break;
-		case 4:
-			pr_debug("fb%d: 5/5/5 truecolor\n", info->node);
-			if (par->chip == CHIP_988_VIRGE_VX) {
-				if (info->var.pixclock > 20000)
-					svga_wcrt_mask(0x67, 0x20, 0xF0);
-				else
-					svga_wcrt_mask(0x67, 0x30, 0xF0);
-			} else {
-				svga_wcrt_mask(0x50, 0x10, 0x30);
+	case 4:
+		pr_debug("fb%d: 5/5/5 truecolor\n", info->node);
+		if (par->chip == CHIP_988_VIRGE_VX) {
+			if (info->var.pixclock > 20000)
+				svga_wcrt_mask(0x67, 0x20, 0xF0);
+			else
 				svga_wcrt_mask(0x67, 0x30, 0xF0);
-				hmul = 2;
-			}
+		} else {
+			svga_wcrt_mask(0x50, 0x10, 0x30);
+			svga_wcrt_mask(0x67, 0x30, 0xF0);
+			hmul = 2;
+		}
 		break;
-		case 5:
-			pr_debug("fb%d: 5/6/5 truecolor\n", info->node);
-			if (par->chip == CHIP_988_VIRGE_VX) {
-				if (info->var.pixclock > 20000)
-					svga_wcrt_mask(0x67, 0x40, 0xF0);
-				else
-					svga_wcrt_mask(0x67, 0x50, 0xF0);
-			} else {
-				svga_wcrt_mask(0x50, 0x10, 0x30);
+	case 5:
+		pr_debug("fb%d: 5/6/5 truecolor\n", info->node);
+		if (par->chip == CHIP_988_VIRGE_VX) {
+			if (info->var.pixclock > 20000)
+				svga_wcrt_mask(0x67, 0x40, 0xF0);
+			else
 				svga_wcrt_mask(0x67, 0x50, 0xF0);
-				hmul = 2;
-			}
+		} else {
+			svga_wcrt_mask(0x50, 0x10, 0x30);
+			svga_wcrt_mask(0x67, 0x50, 0xF0);
+			hmul = 2;
+		}
 		break;
-		case 6:
-			/* VIRGE VX case */
-			pr_debug("fb%d: 8/8/8 truecolor\n", info->node);
-			svga_wcrt_mask(0x67, 0xD0, 0xF0);
+	case 6:
+		/* VIRGE VX case */
+		pr_debug("fb%d: 8/8/8 truecolor\n", info->node);
+		svga_wcrt_mask(0x67, 0xD0, 0xF0);
 		break;
-		case 7:
-			pr_debug("fb%d: 8/8/8/8 truecolor\n", info->node);
-			svga_wcrt_mask(0x50, 0x30, 0x30);
-			svga_wcrt_mask(0x67, 0xD0, 0xF0);
+	case 7:
+		pr_debug("fb%d: 8/8/8/8 truecolor\n", info->node);
+		svga_wcrt_mask(0x50, 0x30, 0x30);
+		svga_wcrt_mask(0x67, 0xD0, 0xF0);
 		break;
-		default:
-			printk(KERN_ERR "fb%d: unsupported mode - bug\n", info->node);
-			return -EINVAL;
+	default:
+		printk(KERN_ERR "fb%d: unsupported mode - bug\n", info->node);
+		return -EINVAL;
 	}
 
 	if (par->chip != CHIP_988_VIRGE_VX) {
@@ -651,8 +651,6 @@ static int s3fb_set_par(struct fb_info *
 			 (info->var.vmode & FB_VMODE_INTERLACED) ? 2 : 1,
 			 hmul, info->node);
 
-
-
 	/* Set interlaced mode start/end register */
 	value = info->var.xres + info->var.left_margin + info->var.right_margin + info->var.hsync_len;
 	value = ((value * hmul) / 8) - 5;
@@ -672,47 +670,55 @@ static int s3fb_setcolreg(u_int regno, u
 				u_int transp, struct fb_info *fb)
 {
 	switch (fb->var.bits_per_pixel) {
-		case 0:
-		case 4:
-			if (regno >= 16) return -EINVAL;
-
-			if ((fb->var.bits_per_pixel == 4) &&
-			    (fb->var.nonstd == 0)) {
-				outb(0xF0, VGA_PEL_MSK);
-				outb(regno*16, VGA_PEL_IW);
-			} else {
-				outb(0x0F, VGA_PEL_MSK);
-				outb(regno, VGA_PEL_IW);
-			}
-			outb(red >> 10, VGA_PEL_D);
-			outb(green >> 10, VGA_PEL_D);
-			outb(blue >> 10, VGA_PEL_D);
-		break;
-		case 8:
-			if (regno >= 256) return -EINVAL;
-			outb(0xFF, VGA_PEL_MSK);
+	case 0:
+	case 4:
+		if (regno >= 16)
+			return -EINVAL;
+
+		if ((fb->var.bits_per_pixel == 4) &&
+		    (fb->var.nonstd == 0)) {
+			outb(0xF0, VGA_PEL_MSK);
+			outb(regno*16, VGA_PEL_IW);
+		} else {
+			outb(0x0F, VGA_PEL_MSK);
 			outb(regno, VGA_PEL_IW);
-			outb(red >> 10, VGA_PEL_D);
-			outb(green >> 10, VGA_PEL_D);
-			outb(blue >> 10, VGA_PEL_D);
+		}
+		outb(red >> 10, VGA_PEL_D);
+		outb(green >> 10, VGA_PEL_D);
+		outb(blue >> 10, VGA_PEL_D);
 		break;
-		case 16:
-			if (regno >= 16) return -EINVAL;
-			if (fb->var.green.length == 5)
-				((u32*)fb->pseudo_palette)[regno] = ((red & 0xF800) >> 1) | ((green & 0xF800) >> 6) | ((blue & 0xF800) >> 11);
-			else if (fb->var.green.length == 6)
-				((u32*)fb->pseudo_palette)[regno] = (red & 0xF800) | ((green & 0xFC00) >> 5) | ((blue & 0xF800) >> 11);
-			else return -EINVAL;
+	case 8:
+		if (regno >= 256)
+			return -EINVAL;
+
+		outb(0xFF, VGA_PEL_MSK);
+		outb(regno, VGA_PEL_IW);
+		outb(red >> 10, VGA_PEL_D);
+		outb(green >> 10, VGA_PEL_D);
+		outb(blue >> 10, VGA_PEL_D);
 		break;
+	case 16:
+		if (regno >= 16)
+			return -EINVAL;
 
-		case 24:
-		case 32:
-			if (regno >= 16) return -EINVAL;
-			((u32*)fb->pseudo_palette)[regno] = ((transp & 0xFF00) >> 16 ) | ((blue & 0xFF00) >> 8) |
-				(green & 0xFF00) | ((red & 0xFF00) << 8);
+		if (fb->var.green.length == 5)
+			((u32*)fb->pseudo_palette)[regno] = ((red & 0xF800) >> 1) |
+				((green & 0xF800) >> 6) | ((blue & 0xF800) >> 11);
+		else if (fb->var.green.length == 6)
+			((u32*)fb->pseudo_palette)[regno] = (red & 0xF800) |
+				((green & 0xFC00) >> 5) | ((blue & 0xF800) >> 11);
+		else return -EINVAL;
 		break;
-		default:
+	case 24:
+	case 32:
+		if (regno >= 16)
 			return -EINVAL;
+
+		((u32*)fb->pseudo_palette)[regno] = ((transp & 0xFF00) << 16) | ((red & 0xFF00) << 8) |
+			(green & 0xFF00) | ((blue & 0xFF00) >> 8);
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	return 0;
@@ -724,30 +730,30 @@ static int s3fb_setcolreg(u_int regno, u
 static int s3fb_blank(int blank_mode, struct fb_info *info)
 {
 	switch (blank_mode) {
-		case FB_BLANK_UNBLANK:
-			pr_debug("fb%d: unblank\n", info->node);
-			svga_wcrt_mask(0x56, 0x00, 0x06);
-			svga_wseq_mask(0x01, 0x00, 0x20);
+	case FB_BLANK_UNBLANK:
+		pr_debug("fb%d: unblank\n", info->node);
+		svga_wcrt_mask(0x56, 0x00, 0x06);
+		svga_wseq_mask(0x01, 0x00, 0x20);
 		break;
-		case FB_BLANK_NORMAL:
-			pr_debug("fb%d: blank\n", info->node);
-			svga_wcrt_mask(0x56, 0x00, 0x06);
-			svga_wseq_mask(0x01, 0x20, 0x20);
+	case FB_BLANK_NORMAL:
+		pr_debug("fb%d: blank\n", info->node);
+		svga_wcrt_mask(0x56, 0x00, 0x06);
+		svga_wseq_mask(0x01, 0x20, 0x20);
 		break;
-		case FB_BLANK_HSYNC_SUSPEND:
-			pr_debug("fb%d: hsync\n", info->node);
-			svga_wcrt_mask(0x56, 0x02, 0x06);
-			svga_wseq_mask(0x01, 0x20, 0x20);
+	case FB_BLANK_HSYNC_SUSPEND:
+		pr_debug("fb%d: hsync\n", info->node);
+		svga_wcrt_mask(0x56, 0x02, 0x06);
+		svga_wseq_mask(0x01, 0x20, 0x20);
 		break;
-		case FB_BLANK_VSYNC_SUSPEND:
-			pr_debug("fb%d: vsync\n", info->node);
-			svga_wcrt_mask(0x56, 0x04, 0x06);
-			svga_wseq_mask(0x01, 0x20, 0x20);
+	case FB_BLANK_VSYNC_SUSPEND:
+		pr_debug("fb%d: vsync\n", info->node);
+		svga_wcrt_mask(0x56, 0x04, 0x06);
+		svga_wseq_mask(0x01, 0x20, 0x20);
 		break;
-		case FB_BLANK_POWERDOWN:
-			pr_debug("fb%d: sync down\n", info->node);
-			svga_wcrt_mask(0x56, 0x06, 0x06);
-			svga_wseq_mask(0x01, 0x20, 0x20);
+	case FB_BLANK_POWERDOWN:
+		pr_debug("fb%d: sync down\n", info->node);
+		svga_wcrt_mask(0x56, 0x06, 0x06);
+		svga_wseq_mask(0x01, 0x20, 0x20);
 		break;
 	}
 
@@ -762,8 +768,10 @@ static int s3fb_pan_display(struct fb_va
 	unsigned int offset;
 
 	/* Validate the offsets */
-	if ((var->xoffset + var->xres) > var->xres_virtual) return -EINVAL;
-	if ((var->yoffset + var->yres) > var->yres_virtual) return -EINVAL;
+	if ((var->xoffset + var->xres) > var->xres_virtual)
+		return -EINVAL;
+	if ((var->yoffset + var->yres) > var->yres_virtual)
+		return -EINVAL;
 
 	/* Calculate the offset */
 	if (var->bits_per_pixel == 0) {
@@ -853,43 +861,46 @@ static int __devinit s3_pci_probe(struct
 
 	/* Ignore secondary VGA device because there is no VGA arbitration */
 	if (! svga_primary_device(dev)) {
-		printk(KERN_INFO "s3fb: ignoring secondary device %s\n",  pci_name(dev));
+		dev_info(&(dev->dev), "ignoring secondary device\n");
 		return -ENODEV;
 	}
 
 	/* Allocate and fill driver data structure */
-
 	info = framebuffer_alloc(sizeof(struct s3fb_info), NULL);
-	if (!info) return -ENOMEM;
-	par = (struct s3fb_info*) info;
+	if (!info) {
+		dev_err(&(dev->dev), "cannot allocate memory\n");
+		return -ENOMEM;
+	}
+
+	par = info->par;
+	mutex_init(&par->open_lock);
 
 	info->flags = FBINFO_PARTIAL_PAN_OK | FBINFO_HWACCEL_YPAN;
 	info->fbops = &s3fb_ops;
 
 	/* Prepare PCI device */
-
 	rc = pci_enable_device(dev);
 	if (rc < 0) {
-		printk(KERN_ERR "s3fb: cannot enable PCI device\n");
+		dev_err(&(dev->dev), "cannot enable PCI device\n");
 		goto err_enable_device;
 	}
 
 	rc = pci_request_regions(dev, "s3fb");
 	if (rc < 0) {
-		printk(KERN_ERR "s3fb: cannot reserve framebuffer region\n");
+		dev_err(&(dev->dev), "cannot reserve framebuffer region\n");
 		goto err_request_regions;
 	}
 
-	/* Map physical IO memory address into kernel space */
 
 	info->fix.smem_start = pci_resource_start(dev, 0);
 	info->fix.smem_len = pci_resource_len(dev, 0);
 
-	info->screen_base = ioremap_nocache(info->fix.smem_start, info->fix.smem_len);
+	/* Map physical IO memory address into kernel space */
+	info->screen_base = pci_iomap(dev, 0, 0);
 	if (! info->screen_base) {
 		rc = -ENOMEM;
-		printk(KERN_ERR "s3fb: ioremap for framebuffer failed\n");
-		goto err_ioremap;
+		dev_err(&(dev->dev), "iomap for framebuffer failed\n");
+		goto err_iomap;
 	}
 
 	/* Unlock regs */
@@ -929,19 +940,24 @@ static int __devinit s3_pci_probe(struct
 	info->pseudo_palette = (void*) (par->pseudo_palette);
 
 	/* Prepare startup mode */
-
 	rc = fb_find_mode(&(info->var), info, mode, NULL, 0, NULL, 8);
 	if (! ((rc == 1) || (rc == 2))) {
 		rc = -EINVAL;
-		printk(KERN_ERR "s3fb: mode %s not found\n", mode);
+		dev_err(&(dev->dev), "mode %s not found\n", mode);
 		goto err_find_mode;
 	}
 
 	rc = fb_alloc_cmap(&info->cmap, 256, 0);
-	if (rc < 0) goto err_alloc_cmap;
+	if (rc < 0) {
+		dev_err(&(dev->dev), "cannot allocate colormap\n");
+		goto err_alloc_cmap;
+	}
 
 	rc = register_framebuffer(info);
-	if (rc < 0) goto err_reg_fb;
+	if (rc < 0) {
+		dev_err(&(dev->dev), "cannot register framebugger\n");
+		goto err_reg_fb;
+	}
 
 	printk(KERN_INFO "fb%d: %s on %s, %d MB RAM, %d MHz MCLK\n", info->node, info->fix.id,
 		 pci_name(dev), info->fix.smem_len >> 20, (par->mclk_freq + 500) / 1000);
@@ -968,8 +984,8 @@ err_reg_fb:
 	fb_dealloc_cmap(&info->cmap);
 err_alloc_cmap:
 err_find_mode:
-	iounmap(info->screen_base);
-err_ioremap:
+	pci_iounmap(dev, info->screen_base);
+err_iomap:
 	pci_release_regions(dev);
 err_request_regions:
 /*	pci_disable_device(dev); */
@@ -984,7 +1000,7 @@ err_enable_device:
 static void __devexit s3_pci_remove(struct pci_dev *dev)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
-	struct s3fb_info *par = (struct s3fb_info *) info;
+	struct s3fb_info *par = info->par;
 
 	if (info) {
 
@@ -998,7 +1014,7 @@ static void __devexit s3_pci_remove(stru
 		unregister_framebuffer(info);
 		fb_dealloc_cmap(&info->cmap);
 
-		iounmap(info->screen_base);
+		pci_iounmap(dev, info->screen_base);
 		pci_release_regions(dev);
 /*		pci_disable_device(dev); */
 
@@ -1012,20 +1028,26 @@ static void __devexit s3_pci_remove(stru
 static int s3_pci_suspend(struct pci_dev* dev, pm_message_t state)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
-	unsigned int count = atomic_read(&(((struct s3fb_info *) info)->ref_count));
+	struct s3fb_info *par = info->par;
 
-	printk(KERN_INFO "fb%d: suspend\n", info->node);
+	dev_info(&(dev->dev), "suspend\n");
+
+	acquire_console_sem();
+	mutex_lock(&(par->open_lock));
 
-	if ((state.event == PM_EVENT_FREEZE) || (!count)) {
+	if ((state.event == PM_EVENT_FREEZE) || (par->ref_count == 0)) {
+		mutex_unlock(&(par->open_lock));
+		release_console_sem();
 		return 0;
 	}
 
-	acquire_console_sem();
 	fb_set_suspend(info, 1);
 
 	pci_save_state(dev);
 	pci_disable_device(dev);
 	pci_set_power_state(dev, pci_choose_state(dev, state));
+
+	mutex_unlock(&(par->open_lock));
 	release_console_sem();
 
 	return 0;
@@ -1037,15 +1059,19 @@ static int s3_pci_suspend(struct pci_dev
 static int s3_pci_resume(struct pci_dev* dev)
 {
 	struct fb_info *info = pci_get_drvdata(dev);
-	unsigned int count = atomic_read(&(((struct s3fb_info *) info)->ref_count));
+	struct s3fb_info *par = info->par;
 
-	printk(KERN_INFO "fb%d: resume\n", info->node);
+	dev_info(&(dev->dev), "resume\n");
+
+	acquire_console_sem();
+	mutex_lock(&(par->open_lock));
 
-	if (!count) {
+	if (par->ref_count == 0) {
+		mutex_unlock(&(par->open_lock));
+		release_console_sem();
 		return 0;
 	}
 
-	acquire_console_sem();
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
 	pci_enable_device(dev);
@@ -1053,6 +1079,8 @@ static int s3_pci_resume(struct pci_dev*
 
 	s3fb_set_par(info);
 	fb_set_suspend(info, 0);
+
+	mutex_unlock(&(par->open_lock));
 	release_console_sem();
 
 	return 0;
@@ -1062,19 +1090,19 @@ static int s3_pci_resume(struct pci_dev*
 /* List of boards that we are trying to support */
 
 static struct pci_device_id s3_devices[] __devinitdata = {
-	{PCI_VENDOR_ID_S3,	0x8810,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_TRIO},
-	{PCI_VENDOR_ID_S3,	0x8811,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_TRIO},
-	{PCI_VENDOR_ID_S3,	0x8812,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_M65_AURORA64VP},
-	{PCI_VENDOR_ID_S3,	0x8814,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_767_TRIO64UVP},
-	{PCI_VENDOR_ID_S3,	0x8901,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_TRIO64V2_DXGX},
-	{PCI_VENDOR_ID_S3,	0x8902,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_551_PLATO_PX},
-
-	{PCI_VENDOR_ID_S3,	0x5631,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_325_VIRGE},
-	{PCI_VENDOR_ID_S3,	0x883D,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_988_VIRGE_VX},
-	{PCI_VENDOR_ID_S3,	0x8A01,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_VIRGE_DXGX},
-	{PCI_VENDOR_ID_S3,	0x8A10,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_356_VIRGE_GX2},
-	{PCI_VENDOR_ID_S3,	0x8A11,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_357_VIRGE_GX2P},
-	{PCI_VENDOR_ID_S3,	0x8A12,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_359_VIRGE_GX2P},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8810), .driver_data = CHIP_XXX_TRIO},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8811), .driver_data = CHIP_XXX_TRIO},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8812), .driver_data = CHIP_M65_AURORA64VP},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8814), .driver_data = CHIP_767_TRIO64UVP},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8901), .driver_data = CHIP_XXX_TRIO64V2_DXGX},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8902), .driver_data = CHIP_551_PLATO_PX},
+
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x5631), .driver_data = CHIP_325_VIRGE},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x883D), .driver_data = CHIP_988_VIRGE_VX},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A01), .driver_data = CHIP_XXX_VIRGE_DXGX},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A10), .driver_data = CHIP_356_VIRGE_GX2},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A11), .driver_data = CHIP_357_VIRGE_GX2P},
+	{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8A12), .driver_data = CHIP_359_VIRGE_GX2P},
 
 	{0, 0, 0, 0, 0, 0, 0}
 };
@@ -1123,7 +1151,6 @@ static int  __init s3fb_setup(char *opti
 
 static void __exit s3fb_cleanup(void)
 {
-
 	pr_debug("s3fb: cleaning up\n");
 	pci_unregister_driver(&s3fb_pci_driver);
 }
@@ -1134,11 +1161,11 @@ static int __init s3fb_init(void)
 {
 
 #ifndef MODULE
-        char *option = NULL;
+	char *option = NULL;
 
-        if (fb_get_options("s3fb", &option))
-                return -ENODEV;
-        s3fb_setup(option);
+	if (fb_get_options("s3fb", &option))
+		return -ENODEV;
+	s3fb_setup(option);
 #endif
 
 	pr_debug("s3fb: initializing\n");
diff -puN drivers/video/svgalib.c~fbdev-driver-for-s3-trio-virge-update-2 drivers/video/svgalib.c
--- a/drivers/video/svgalib.c~fbdev-driver-for-s3-trio-virge-update-2
+++ a/drivers/video/svgalib.c
@@ -1,7 +1,7 @@
 /*
  * Common utility functions for VGA-based graphics cards.
  *
- * Copyright (c) 2006 Ondrej Zajicek <santiago@crfreenet.org>
+ * Copyright (c) 2006-2007 Ondrej Zajicek <santiago@crfreenet.org>
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive for
@@ -40,7 +40,7 @@ void svga_wcrt_multi(const struct vga_re
 	}
 }
 
-/* Write a sequence register value spread across multiple registers */
+/* Write a sequencer register value spread across multiple registers */
 void svga_wseq_multi(const struct vga_regset *regset, u32 value) {
 
 	u8 regval, bitval, bitnum;
@@ -313,23 +313,22 @@ void svga_tilecursor(struct fb_info *inf
 	if (cursor -> shape == FB_TILE_CURSOR_NONE)
 		return;
 
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
+	switch (cursor -> shape) {
+	case FB_TILE_CURSOR_UNDERLINE:
+		cs = 0x0d;
+		break;
+	case FB_TILE_CURSOR_LOWER_THIRD:
+		cs = 0x09;
+		break;
+	case FB_TILE_CURSOR_LOWER_HALF:
+		cs = 0x07;
+		break;
+	case FB_TILE_CURSOR_TWO_THIRDS:
+		cs = 0x05;
+		break;
+	case FB_TILE_CURSOR_BLOCK:
+		cs = 0x01;
+		break;
 	}
 
 	/* set cursor position */
@@ -345,12 +344,15 @@ void svga_tilecursor(struct fb_info *inf
 
 
 /*
-   Compute PLL settings (M, N, R)
-   F_VCO = (F_BASE * M) / N
-   F_OUT = F_VCO / (2^R)
-*/
+ *  Compute PLL settings (M, N, R)
+ *  F_VCO = (F_BASE * M) / N
+ *  F_OUT = F_VCO / (2^R)
+ */
 
-static inline u32 abs_diff(u32 a, u32 b) {return (a > b) ? (a - b) : (b - a);}
+static inline u32 abs_diff(u32 a, u32 b)
+{
+	return (a > b) ? (a - b) : (b - a);
+}
 
 int svga_compute_pll(const struct svga_pll *pll, u32 f_wanted, u16 *m, u16 *n, u16 *r, int node)
 {
@@ -425,45 +427,57 @@ int svga_check_timings(const struct svga
 
 	/* Check horizontal total */
 	value = var->xres + var->left_margin + var->right_margin + var->hsync_len;
-	if (((value / 8) - 5) >= svga_regset_size (tm->h_total_regs)) return -EINVAL;
+	if (((value / 8) - 5) >= svga_regset_size (tm->h_total_regs))
+		return -EINVAL;
 
 	/* Check horizontal display and blank start */
 	value = var->xres;
-	if (((value / 8) - 1) >= svga_regset_size (tm->h_display_regs)) return -EINVAL;
-	if (((value / 8) - 1) >= svga_regset_size (tm->h_blank_start_regs)) return -EINVAL;
+	if (((value / 8) - 1) >= svga_regset_size (tm->h_display_regs))
+		return -EINVAL;
+	if (((value / 8) - 1) >= svga_regset_size (tm->h_blank_start_regs))
+		return -EINVAL;
 
 	/* Check horizontal sync start */
 	value = var->xres + var->right_margin;
-	if (((value / 8) - 1) >= svga_regset_size (tm->h_sync_start_regs)) return -EINVAL;
+	if (((value / 8) - 1) >= svga_regset_size (tm->h_sync_start_regs))
+		return -EINVAL;
 
 	/* Check horizontal blank end (or length) */
 	value = var->left_margin + var->right_margin + var->hsync_len;
-	if ((value == 0) || ((value / 8) >= svga_regset_size (tm->h_blank_end_regs))) return -EINVAL;
+	if ((value == 0) || ((value / 8) >= svga_regset_size (tm->h_blank_end_regs)))
+		return -EINVAL;
 
 	/* Check horizontal sync end (or length) */
 	value = var->hsync_len;
-	if ((value == 0) || ((value / 8) >= svga_regset_size (tm->h_sync_end_regs))) return -EINVAL;
+	if ((value == 0) || ((value / 8) >= svga_regset_size (tm->h_sync_end_regs)))
+		return -EINVAL;
 
 	/* Check vertical total */
 	value = var->yres + var->upper_margin + var->lower_margin + var->vsync_len;
-	if ((value - 1) >= svga_regset_size(tm->v_total_regs)) return -EINVAL;
+	if ((value - 1) >= svga_regset_size(tm->v_total_regs))
+		return -EINVAL;
 
 	/* Check vertical display and blank start */
 	value = var->yres;
-	if ((value - 1) >= svga_regset_size(tm->v_display_regs)) return -EINVAL;
-	if ((value - 1) >= svga_regset_size(tm->v_blank_start_regs)) return -EINVAL;
+	if ((value - 1) >= svga_regset_size(tm->v_display_regs))
+		return -EINVAL;
+	if ((value - 1) >= svga_regset_size(tm->v_blank_start_regs))
+		return -EINVAL;
 
 	/* Check vertical sync start */
 	value = var->yres + var->lower_margin;
-	if ((value - 1) >= svga_regset_size(tm->v_sync_start_regs)) return -EINVAL;
+	if ((value - 1) >= svga_regset_size(tm->v_sync_start_regs))
+		return -EINVAL;
 
 	/* Check vertical blank end (or length) */
 	value = var->upper_margin + var->lower_margin + var->vsync_len;
-	if ((value == 0) || (value >= svga_regset_size (tm->v_blank_end_regs))) return -EINVAL;
+	if ((value == 0) || (value >= svga_regset_size (tm->v_blank_end_regs)))
+		return -EINVAL;
 
 	/* Check vertical sync end  (or length) */
 	value = var->vsync_len;
-	if ((value == 0) || (value >= svga_regset_size (tm->v_sync_end_regs))) return -EINVAL;
+	if ((value == 0) || (value >= svga_regset_size (tm->v_sync_end_regs)))
+		return -EINVAL;
 
 	return 0;
 }
diff -puN include/linux/svga.h~fbdev-driver-for-s3-trio-virge-update-2 include/linux/svga.h
--- a/include/linux/svga.h~fbdev-driver-for-s3-trio-virge-update-2
+++ a/include/linux/svga.h
@@ -12,9 +12,9 @@
 #define VGA_REGSET_END		{VGA_REGSET_END_VAL, 0, 0}
 
 struct vga_regset {
-	__u8 regnum;
-	__u8 lowbit;
-	__u8 highbit;
+	u8 regnum;
+	u8 lowbit;
+	u8 highbit;
 };
 
 /* ------------------------------------------------------------------------- */
_

Patches currently in -mm which might be from santiago@crfreenet.org are

fbdev-driver-for-s3-trio-virge.patch
fbdev-driver-for-s3-trio-virge-update.patch
fbdev-driver-for-s3-trio-virge-update-2.patch
