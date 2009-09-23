From: akpm@linux-foundation.org
Subject: [merged] viafb-2d-engine-rewrite.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:07 -0700
Message-ID: <200909232002.n8NK27i6016580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211AbZIWUKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, laforge@gnumonks.org, mm-commits@vger.kernel.org


The patch titled
     viafb: 2D engine rewrite
has been removed from the -mm tree.  Its filename was
     viafb-2d-engine-rewrite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: 2D engine rewrite
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

This patch is a completly rewritten 2D engine.  The engine is no longer in
a default state but reinitialized every time to allow usage for both
framebuffers regardless of their settings.

The whole engine handling is concentrated in a big function which takes 16
parameters.  Although the number of parameters is worryingly it is good to
have a single funtion to deal with this stuff as it allows to easily
support different engines and avoids some code duplication.

On the way support for the new 2D engine in VX800 was added.  As the with
less code duplication but it is probably better to duplicate the code as
this way is easier to walk if VIA ever decides to release a new engine
which changes anything the driver touches.

The engine support for VX800 gives a notable boost in speed.  There are no
known regressions but as this patch changes paths I do neither have the
hardware nor documentation to check and has the possibility to put the
system in a critical state heavy testing is appreciated.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Harald Welte <laforge@gnumonks.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c    |  363 ++++++++++++++++++++++++++++-----
 drivers/video/via/accel.h    |    7 
 drivers/video/via/viafbdev.c |  226 +++++---------------
 drivers/video/via/viafbdev.h |    8 
 4 files changed, 385 insertions(+), 219 deletions(-)

diff -puN drivers/video/via/accel.c~viafb-2d-engine-rewrite drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-2d-engine-rewrite
+++ a/drivers/video/via/accel.c
@@ -20,8 +20,316 @@
  */
 #include "global.h"
 
-void viafb_init_accel(void)
+static int hw_bitblt_1(void __iomem *engine, u8 op, u32 width, u32 height,
+	u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
+	u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
+	u32 fg_color, u32 bg_color, u8 fill_rop)
 {
+	u32 ge_cmd = 0, tmp, i;
+
+	if (!op || op > 3) {
+		printk(KERN_WARNING "hw_bitblt_1: Invalid operation: %d\n", op);
+		return -EINVAL;
+	}
+
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
+	switch (dst_bpp) {
+	case 8:
+		tmp = 0x00000000;
+		break;
+	case 16:
+		tmp = 0x00000100;
+		break;
+	case 32:
+		tmp = 0x00000300;
+		break;
+	default:
+		printk(KERN_WARNING "hw_bitblt_1: Unsupported bpp %d\n",
+			dst_bpp);
+		return -EINVAL;
+	}
+	writel(tmp, engine + 0x04);
+
+	if (op != VIA_BITBLT_FILL) {
+		if (src_x & (op == VIA_BITBLT_MONO ? 0xFFFF8000 : 0xFFFFF000)
+			|| src_y & 0xFFFFF000) {
+			printk(KERN_WARNING "hw_bitblt_1: Unsupported source "
+				"x/y %d %d\n", src_x, src_y);
+			return -EINVAL;
+		}
+		tmp = src_x | (src_y << 16);
+		writel(tmp, engine + 0x08);
+	}
+
+	if (dst_x & 0xFFFFF000 || dst_y & 0xFFFFF000) {
+		printk(KERN_WARNING "hw_bitblt_1: Unsupported destination x/y "
+			"%d %d\n", dst_x, dst_y);
+		return -EINVAL;
+	}
+	tmp = dst_x | (dst_y << 16);
+	writel(tmp, engine + 0x0C);
+
+	if ((width - 1) & 0xFFFFF000 || (height - 1) & 0xFFFFF000) {
+		printk(KERN_WARNING "hw_bitblt_1: Unsupported width/height "
+			"%d %d\n", width, height);
+		return -EINVAL;
+	}
+	tmp = (width - 1) | ((height - 1) << 16);
+	writel(tmp, engine + 0x10);
+
+	if (op != VIA_BITBLT_COLOR)
+		writel(fg_color, engine + 0x18);
+
+	if (op == VIA_BITBLT_MONO)
+		writel(bg_color, engine + 0x1C);
+
+	if (op != VIA_BITBLT_FILL) {
+		tmp = src_mem ? 0 : src_addr;
+		if (dst_addr & 0xE0000007) {
+			printk(KERN_WARNING "hw_bitblt_1: Unsupported source "
+				"address %X\n", tmp);
+			return -EINVAL;
+		}
+		tmp >>= 3;
+		writel(tmp, engine + 0x30);
+	}
+
+	if (dst_addr & 0xE0000007) {
+		printk(KERN_WARNING "hw_bitblt_1: Unsupported destination "
+			"address %X\n", dst_addr);
+		return -EINVAL;
+	}
+	tmp = dst_addr >> 3;
+	writel(tmp, engine + 0x34);
+
+	if (op == VIA_BITBLT_FILL)
+		tmp = 0;
+	else
+		tmp = src_pitch;
+	if (tmp & 0xFFFFC007 || dst_pitch & 0xFFFFC007) {
+		printk(KERN_WARNING "hw_bitblt_1: Unsupported pitch %X %X\n",
+			tmp, dst_pitch);
+		return -EINVAL;
+	}
+	tmp = (tmp >> 3) | (dst_pitch << (16 - 3));
+	writel(tmp, engine + 0x38);
+
+	if (op == VIA_BITBLT_FILL)
+		ge_cmd |= fill_rop << 24 | 0x00002000 | 0x00000001;
+	else {
+		ge_cmd |= 0xCC000000; /* ROP=SRCCOPY */
+		if (src_mem)
+			ge_cmd |= 0x00000040;
+		if (op == VIA_BITBLT_MONO)
+			ge_cmd |= 0x00000002 | 0x00000100 | 0x00020000;
+		else
+			ge_cmd |= 0x00000001;
+	}
+	writel(ge_cmd, engine);
+
+	if (op == VIA_BITBLT_FILL || !src_mem)
+		return 0;
+
+	tmp = (width * height * (op == VIA_BITBLT_MONO ? 1 : (dst_bpp >> 3)) +
+		3) >> 2;
+
+	for (i = 0; i < tmp; i++)
+		writel(src_mem[i], engine + VIA_MMIO_BLTBASE);
+
+	return 0;
+}
+
+static int hw_bitblt_2(void __iomem *engine, u8 op, u32 width, u32 height,
+	u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
+	u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
+	u32 fg_color, u32 bg_color, u8 fill_rop)
+{
+	u32 ge_cmd = 0, tmp, i;
+
+	if (!op || op > 3) {
+		printk(KERN_WARNING "hw_bitblt_2: Invalid operation: %d\n", op);
+		return -EINVAL;
+	}
+
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
+	switch (dst_bpp) {
+	case 8:
+		tmp = 0x00000000;
+		break;
+	case 16:
+		tmp = 0x00000100;
+		break;
+	case 32:
+		tmp = 0x00000300;
+		break;
+	default:
+		printk(KERN_WARNING "hw_bitblt_2: Unsupported bpp %d\n",
+			dst_bpp);
+		return -EINVAL;
+	}
+	writel(tmp, engine + 0x04);
+
+	if (op == VIA_BITBLT_FILL)
+		tmp = 0;
+	else
+		tmp = src_pitch;
+	if (tmp & 0xFFFFC007 || dst_pitch & 0xFFFFC007) {
+		printk(KERN_WARNING "hw_bitblt_2: Unsupported pitch %X %X\n",
+			tmp, dst_pitch);
+		return -EINVAL;
+	}
+	tmp = (tmp >> 3) | (dst_pitch << (16 - 3));
+	writel(tmp, engine + 0x08);
+
+	if ((width - 1) & 0xFFFFF000 || (height - 1) & 0xFFFFF000) {
+		printk(KERN_WARNING "hw_bitblt_2: Unsupported width/height "
+			"%d %d\n", width, height);
+		return -EINVAL;
+	}
+	tmp = (width - 1) | ((height - 1) << 16);
+	writel(tmp, engine + 0x0C);
+
+	if (dst_x & 0xFFFFF000 || dst_y & 0xFFFFF000) {
+		printk(KERN_WARNING "hw_bitblt_2: Unsupported destination x/y "
+			"%d %d\n", dst_x, dst_y);
+		return -EINVAL;
+	}
+	tmp = dst_x | (dst_y << 16);
+	writel(tmp, engine + 0x10);
+
+	if (dst_addr & 0xE0000007) {
+		printk(KERN_WARNING "hw_bitblt_2: Unsupported destination "
+			"address %X\n", dst_addr);
+		return -EINVAL;
+	}
+	tmp = dst_addr >> 3;
+	writel(tmp, engine + 0x14);
+
+	if (op != VIA_BITBLT_FILL) {
+		if (src_x & (op == VIA_BITBLT_MONO ? 0xFFFF8000 : 0xFFFFF000)
+			|| src_y & 0xFFFFF000) {
+			printk(KERN_WARNING "hw_bitblt_2: Unsupported source "
+				"x/y %d %d\n", src_x, src_y);
+			return -EINVAL;
+		}
+		tmp = src_x | (src_y << 16);
+		writel(tmp, engine + 0x18);
+
+		tmp = src_mem ? 0 : src_addr;
+		if (dst_addr & 0xE0000007) {
+			printk(KERN_WARNING "hw_bitblt_2: Unsupported source "
+				"address %X\n", tmp);
+			return -EINVAL;
+		}
+		tmp >>= 3;
+		writel(tmp, engine + 0x1C);
+	}
+
+	if (op != VIA_BITBLT_COLOR)
+		writel(fg_color, engine + 0x4C);
+
+	if (op == VIA_BITBLT_MONO)
+		writel(bg_color, engine + 0x50);
+
+	if (op == VIA_BITBLT_FILL)
+		ge_cmd |= fill_rop << 24 | 0x00002000 | 0x00000001;
+	else {
+		ge_cmd |= 0xCC000000; /* ROP=SRCCOPY */
+		if (src_mem)
+			ge_cmd |= 0x00000040;
+		if (op == VIA_BITBLT_MONO)
+			ge_cmd |= 0x00000002 | 0x00000100 | 0x00020000;
+		else
+			ge_cmd |= 0x00000001;
+	}
+	writel(ge_cmd, engine);
+
+	if (op == VIA_BITBLT_FILL || !src_mem)
+		return 0;
+
+	tmp = (width * height * (op == VIA_BITBLT_MONO ? 1 : (dst_bpp >> 3)) +
+		3) >> 2;
+
+	for (i = 0; i < tmp; i++)
+		writel(src_mem[i], engine + VIA_MMIO_BLTBASE);
+
+	return 0;
+}
+
+void viafb_init_accel(struct viafb_shared *shared)
+{
+	switch (shared->chip_info.gfx_chip_name) {
+	case UNICHROME_CLE266:
+	case UNICHROME_K400:
+	case UNICHROME_K800:
+	case UNICHROME_PM800:
+	case UNICHROME_CN700:
+	case UNICHROME_CX700:
+	case UNICHROME_CN750:
+	case UNICHROME_K8M890:
+	case UNICHROME_P4M890:
+	case UNICHROME_P4M900:
+		shared->hw_bitblt = hw_bitblt_1;
+		break;
+	case UNICHROME_VX800:
+		shared->hw_bitblt = hw_bitblt_2;
+		break;
+	default:
+		shared->hw_bitblt = NULL;
+	}
+
 	viaparinfo->fbmem_free -= CURSOR_SIZE;
 	viaparinfo->cursor_start = viaparinfo->fbmem_free;
 	viaparinfo->fbmem_used += CURSOR_SIZE;
@@ -30,30 +338,14 @@ void viafb_init_accel(void)
 	viaparinfo->fbmem_free -= (CURSOR_SIZE + VQ_SIZE);
 	viaparinfo->VQ_start = viaparinfo->fbmem_free;
 	viaparinfo->VQ_end = viaparinfo->VQ_start + VQ_SIZE - 1;
-	viaparinfo->fbmem_used += (CURSOR_SIZE + VQ_SIZE); }
+	viaparinfo->fbmem_used += (CURSOR_SIZE + VQ_SIZE);
+}
 
 void viafb_init_2d_engine(void)
 {
-	u32 dwVQStartAddr, dwVQEndAddr, linesize;
+	u32 dwVQStartAddr, dwVQEndAddr;
 	u32 dwVQLen, dwVQStartL, dwVQEndL, dwVQStartEndH;
 
-	/* init 2D engine regs to reset 2D engine */
-	writel(0x0, viaparinfo->io_virt + VIA_REG_GEMODE);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCPOS);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTPOS);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_DIMENSION);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_PATADDR);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_FGCOLOR);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_BGCOLOR);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_CLIPTL);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_CLIPBR);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_OFFSET);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_KEYCONTROL);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTBASE);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_PITCH);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_MONOPAT1);
-
 	/* Init AGP and VQ regs */
 	switch (viaparinfo->chip_info->gfx_chip_name) {
 	case UNICHROME_K8M890:
@@ -190,37 +482,6 @@ void viafb_init_2d_engine(void)
 			break;
 		}
 	}
-
-	viafb_set_2d_color_depth(viafbinfo->var.bits_per_pixel);
-
-	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTBASE);
-
-	linesize = viafbinfo->var.xres * viafbinfo->var.bits_per_pixel >> 3;
-	writel(VIA_PITCH_ENABLE | (linesize >> 3) | ((linesize >> 3) << 16),
-		viaparinfo->io_virt + VIA_REG_PITCH);
-}
-
-void viafb_set_2d_color_depth(int bpp)
-{
-	u32 dwGEMode;
-
-	dwGEMode = readl(viaparinfo->io_virt + 0x04) & 0xFFFFFCFF;
-
-	switch (bpp) {
-	case 16:
-		dwGEMode |= VIA_GEM_16bpp;
-		break;
-	case 32:
-		dwGEMode |= VIA_GEM_32bpp;
-		break;
-	default:
-		dwGEMode |= VIA_GEM_8bpp;
-		break;
-	}
-
-	/* Set BPP and Pitch */
-	writel(dwGEMode, viaparinfo->io_virt + VIA_REG_GEMODE);
 }
 
 void viafb_hw_cursor_init(void)
diff -puN drivers/video/via/accel.h~viafb-2d-engine-rewrite drivers/video/via/accel.h
--- a/drivers/video/via/accel.h~viafb-2d-engine-rewrite
+++ a/drivers/video/via/accel.h
@@ -159,9 +159,12 @@
 
 #define MAXLOOP                 0xFFFFFF
 
-void viafb_init_accel(void);
+#define VIA_BITBLT_COLOR	1
+#define VIA_BITBLT_MONO		2
+#define VIA_BITBLT_FILL		3
+
+void viafb_init_accel(struct viafb_shared *shared);
 void viafb_init_2d_engine(void);
-void set_2d_color_depth(int);
 void viafb_hw_cursor_init(void);
 void viafb_show_hw_cursor(struct fb_info *info, int Status); int
 viafb_wait_engine_idle(void); void viafb_set_2d_color_depth(int bpp);
diff -puN drivers/video/via/viafbdev.c~viafb-2d-engine-rewrite drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-2d-engine-rewrite
+++ a/drivers/video/via/viafbdev.c
@@ -95,11 +95,8 @@ static int viafb_check_var(struct fb_var
 	struct fb_info *info)
 {
 	int vmode_index, htotal, vtotal;
-	struct viafb_par *ppar;
+	struct viafb_par *ppar = info->par;
 	u32 long_refresh;
-	struct viafb_par *p_viafb_par;
-	ppar = info->par;
-
 
 	DEBUG_MSG(KERN_INFO "viafb_check_var!\n");
 	/* Sanity check */
@@ -144,22 +141,17 @@ static int viafb_check_var(struct fb_var
 	/* Adjust var according to our driver's own table */
 	viafb_fill_var_timing_info(var, viafb_refresh, vmode_index);
 
-	/* This is indeed a patch for VT3353 */
-	if (!info->par)
-		return -1;
-	p_viafb_par = (struct viafb_par *)info->par;
-	if (p_viafb_par->chip_info->gfx_chip_name == UNICHROME_VX800)
-		var->accel_flags = 0;
-
 	return 0;
 }
 
 static int viafb_set_par(struct fb_info *info)
 {
+	struct viafb_par *viapar = info->par;
 	int vmode_index;
 	int vmode_index1 = 0;
 	DEBUG_MSG(KERN_INFO "viafb_set_par!\n");
 
+	viapar->depth = fb_get_color_depth(&info->var, &info->fix);
 	viafb_update_device_setting(info->var.xres, info->var.yres,
 			      info->var.bits_per_pixel, viafb_refresh, 0);
 
@@ -190,9 +182,6 @@ static int viafb_set_par(struct fb_info 
 		viafb_bpp = info->var.bits_per_pixel;
 		/* Update viafb_accel, it is necessary to our 2D accelerate */
 		viafb_accel = info->var.accel_flags;
-
-		if (viafb_accel)
-			viafb_set_2d_color_depth(info->var.bits_per_pixel);
 	}
 
 	return 0;
@@ -777,10 +766,11 @@ static int viafb_ioctl(struct fb_info *i
 static void viafb_fillrect(struct fb_info *info,
 	const struct fb_fillrect *rect)
 {
-	u32 col = 0, rop = 0;
-	int pitch;
+	struct viafb_par *viapar = info->par;
+	u32 fg_color;
+	u8 rop;
 
-	if (!viafb_accel) {
+	if (!viapar->shared->hw_bitblt) {
 		cfb_fillrect(info, rect);
 		return;
 	}
@@ -788,67 +778,30 @@ static void viafb_fillrect(struct fb_inf
 	if (!rect->width || !rect->height)
 		return;
 
-	switch (rect->rop) {
-	case ROP_XOR:
+	if (info->fix.visual == FB_VISUAL_TRUECOLOR)
+		fg_color = ((u32 *)info->pseudo_palette)[rect->color];
+	else
+		fg_color = rect->color;
+
+	if (rect->rop == ROP_XOR)
 		rop = 0x5A;
-		break;
-	case ROP_COPY:
-	default:
+	else
 		rop = 0xF0;
-		break;
-	}
-
-	switch (info->var.bits_per_pixel) {
-	case 8:
-		col = rect->color;
-		break;
-	case 16:
-		col = ((u32 *) (info->pseudo_palette))[rect->color];
-		break;
-	case 32:
-		col = ((u32 *) (info->pseudo_palette))[rect->color];
-		break;
-	}
-
-	/* BitBlt Source Address */
-	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCPOS);
-	/* Source Base Address */
-	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
-	/* Destination Base Address */
-	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
-		   viaparinfo->io_virt + VIA_REG_DSTBASE);
-	/* Pitch */
-	pitch = (info->var.xres_virtual + 7) & ~7;
-	writel(VIA_PITCH_ENABLE |
-		   (((pitch *
-		      info->var.bits_per_pixel >> 3) >> 3) |
-		      (((pitch * info->
-		      var.bits_per_pixel >> 3) >> 3) << 16)),
-		      viaparinfo->io_virt + VIA_REG_PITCH);
-	/* BitBlt Destination Address */
-	writel(((rect->dy << 16) | rect->dx),
-		viaparinfo->io_virt + VIA_REG_DSTPOS);
-	/* Dimension: width & height */
-	writel((((rect->height - 1) << 16) | (rect->width - 1)),
-		viaparinfo->io_virt + VIA_REG_DIMENSION);
-	/* Forground color or Destination color */
-	writel(col, viaparinfo->io_virt + VIA_REG_FGCOLOR);
-	/* GE Command */
-	writel((0x01 | 0x2000 | (rop << 24)),
-		viaparinfo->io_virt + VIA_REG_GECMD);
 
+	DEBUG_MSG(KERN_DEBUG "viafb 2D engine: fillrect\n");
+	if (viapar->shared->hw_bitblt(viapar->io_virt, VIA_BITBLT_FILL,
+		rect->width, rect->height, info->var.bits_per_pixel,
+		viapar->vram_addr, info->fix.line_length, rect->dx, rect->dy,
+		NULL, 0, 0, 0, 0, fg_color, 0, rop))
+		cfb_fillrect(info, rect);
 }
 
 static void viafb_copyarea(struct fb_info *info,
 	const struct fb_copyarea *area)
 {
-	u32 dy = area->dy, sy = area->sy, direction = 0x0;
-	u32 sx = area->sx, dx = area->dx, width = area->width;
-	int pitch;
-
-	DEBUG_MSG(KERN_INFO "viafb_copyarea!!\n");
+	struct viafb_par *viapar = info->par;
 
-	if (!viafb_accel) {
+	if (!viapar->shared->hw_bitblt) {
 		cfb_copyarea(info, area);
 		return;
 	}
@@ -856,113 +809,48 @@ static void viafb_copyarea(struct fb_inf
 	if (!area->width || !area->height)
 		return;
 
-	if (sy < dy) {
-		dy += area->height - 1;
-		sy += area->height - 1;
-		direction |= 0x4000;
-	}
-
-	if (sx < dx) {
-		dx += width - 1;
-		sx += width - 1;
-		direction |= 0x8000;
-	}
-
-	/* Source Base Address */
-	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
-		   viaparinfo->io_virt + VIA_REG_SRCBASE);
-	/* Destination Base Address */
-	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
-		   viaparinfo->io_virt + VIA_REG_DSTBASE);
-	/* Pitch */
-	pitch = (info->var.xres_virtual + 7) & ~7;
-	/* VIA_PITCH_ENABLE can be omitted now. */
-	writel(VIA_PITCH_ENABLE |
-		   (((pitch *
-		      info->var.bits_per_pixel >> 3) >> 3) | (((pitch *
-								info->var.
-								bits_per_pixel
-								>> 3) >> 3)
-							      << 16)),
-				viaparinfo->io_virt + VIA_REG_PITCH);
-	/* BitBlt Source Address */
-	writel(((sy << 16) | sx), viaparinfo->io_virt + VIA_REG_SRCPOS);
-	/* BitBlt Destination Address */
-	writel(((dy << 16) | dx), viaparinfo->io_virt + VIA_REG_DSTPOS);
-	/* Dimension: width & height */
-	writel((((area->height - 1) << 16) | (area->width - 1)),
-		   viaparinfo->io_virt + VIA_REG_DIMENSION);
-	/* GE Command */
-	writel((0x01 | direction | (0xCC << 24)),
-		viaparinfo->io_virt + VIA_REG_GECMD);
-
+	DEBUG_MSG(KERN_DEBUG "viafb 2D engine: copyarea\n");
+	if (viapar->shared->hw_bitblt(viapar->io_virt, VIA_BITBLT_COLOR,
+		area->width, area->height, info->var.bits_per_pixel,
+		viapar->vram_addr, info->fix.line_length, area->dx, area->dy,
+		NULL, viapar->vram_addr, info->fix.line_length,
+		area->sx, area->sy, 0, 0, 0))
+		cfb_copyarea(info, area);
 }
 
 static void viafb_imageblit(struct fb_info *info,
 	const struct fb_image *image)
 {
-	u32 size, bg_col = 0, fg_col = 0, *udata;
-	int i;
-	int pitch;
+	struct viafb_par *viapar = info->par;
+	u32 fg_color = 0, bg_color = 0;
+	u8 op;
 
-	if (!viafb_accel) {
+	if (!viapar->shared->hw_bitblt ||
+		(image->depth != 1 && image->depth != viapar->depth)) {
 		cfb_imageblit(info, image);
 		return;
 	}
 
-	udata = (u32 *) image->data;
-
-	switch (info->var.bits_per_pixel) {
-	case 8:
-		bg_col = image->bg_color;
-		fg_col = image->fg_color;
-		break;
-	case 16:
-		bg_col = ((u32 *) (info->pseudo_palette))[image->bg_color];
-		fg_col = ((u32 *) (info->pseudo_palette))[image->fg_color];
-		break;
-	case 32:
-		bg_col = ((u32 *) (info->pseudo_palette))[image->bg_color];
-		fg_col = ((u32 *) (info->pseudo_palette))[image->fg_color];
-		break;
-	}
-	size = image->width * image->height;
-
-	/* Source Base Address */
-	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
-	/* Destination Base Address */
-	writel((info->fix.smem_start - viafbinfo->fix.smem_start) >> 3,
-		   viaparinfo->io_virt + VIA_REG_DSTBASE);
-	/* Pitch */
-	pitch = (info->var.xres_virtual + 7) & ~7;
-	writel(VIA_PITCH_ENABLE |
-		   (((pitch *
-		      info->var.bits_per_pixel >> 3) >> 3) | (((pitch *
-								info->var.
-								bits_per_pixel
-								>> 3) >> 3)
-							      << 16)),
-				viaparinfo->io_virt + VIA_REG_PITCH);
-	/* BitBlt Source Address */
-	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCPOS);
-	/* BitBlt Destination Address */
-	writel(((image->dy << 16) | image->dx),
-		viaparinfo->io_virt + VIA_REG_DSTPOS);
-	/* Dimension: width & height */
-	writel((((image->height - 1) << 16) | (image->width - 1)),
-		   viaparinfo->io_virt + VIA_REG_DIMENSION);
-	/* fb color */
-	writel(fg_col, viaparinfo->io_virt + VIA_REG_FGCOLOR);
-	/* bg color */
-	writel(bg_col, viaparinfo->io_virt + VIA_REG_BGCOLOR);
-	/* GE Command */
-	writel(0xCC020142, viaparinfo->io_virt + VIA_REG_GECMD);
-
-	for (i = 0; i < size / 4; i++) {
-		writel(*udata, viaparinfo->io_virt + VIA_MMIO_BLTBASE);
-		udata++;
-	}
+	if (image->depth == 1) {
+		op = VIA_BITBLT_MONO;
+		if (info->fix.visual == FB_VISUAL_TRUECOLOR) {
+			fg_color =
+				((u32 *)info->pseudo_palette)[image->fg_color];
+			bg_color =
+				((u32 *)info->pseudo_palette)[image->bg_color];
+		} else {
+			fg_color = image->fg_color;
+			bg_color = image->bg_color;
+		}
+	} else
+		op = VIA_BITBLT_COLOR;
 
+	DEBUG_MSG(KERN_DEBUG "viafb 2D engine: imageblit\n");
+	if (viapar->shared->hw_bitblt(viapar->io_virt, op,
+		image->width, image->height, info->var.bits_per_pixel,
+		viapar->vram_addr, info->fix.line_length, image->dx, image->dy,
+		(u32 *)image->data, 0, 0, 0, 0, fg_color, bg_color, 0))
+		cfb_imageblit(info, image);
 }
 
 static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
@@ -1961,6 +1849,7 @@ static int __devinit via_pci_probe(void)
 
 	viaparinfo = (struct viafb_par *)viafbinfo->par;
 	viaparinfo->shared = viafbinfo->par + viafb_par_length;
+	viaparinfo->vram_addr = 0;
 	viaparinfo->tmds_setting_info = &viaparinfo->shared->tmds_setting_info;
 	viaparinfo->lvds_setting_info = &viaparinfo->shared->lvds_setting_info;
 	viaparinfo->lvds_setting_info2 =
@@ -2007,7 +1896,7 @@ static int __devinit via_pci_probe(void)
 
 	viafbinfo->pseudo_palette = pseudo_pal;
 	if (viafb_accel) {
-		viafb_init_accel();
+		viafb_init_accel(viaparinfo->shared);
 		viafb_init_2d_engine();
 		viafb_hw_cursor_init();
 	}
@@ -2110,6 +1999,7 @@ static int __devinit via_pci_probe(void)
 		}
 		viaparinfo1 = viafbinfo1->par;
 		memcpy(viaparinfo1, viaparinfo, viafb_par_length);
+		viaparinfo1->vram_addr = viafb_second_offset;
 		viaparinfo1->memsize = viaparinfo->memsize -
 			viafb_second_offset;
 		viaparinfo->memsize = viafb_second_offset;
@@ -2157,12 +2047,16 @@ static int __devinit via_pci_probe(void)
 		viafb_check_var(&default_var, viafbinfo1);
 		viafbinfo1->var = default_var;
 		viafb_update_fix(viafbinfo1);
+		viaparinfo1->depth = fb_get_color_depth(&viafbinfo1->var,
+			&viafbinfo1->fix);
 	}
 
 	viafb_setup_fixinfo(&viafbinfo->fix, viaparinfo);
 	viafb_check_var(&default_var, viafbinfo);
 	viafbinfo->var = default_var;
 	viafb_update_fix(viafbinfo);
+	viaparinfo->depth = fb_get_color_depth(&viafbinfo->var,
+		&viafbinfo->fix);
 	default_var.activate = FB_ACTIVATE_NOW;
 	fb_alloc_cmap(&viafbinfo->cmap, 256, 0);
 
diff -puN drivers/video/via/viafbdev.h~viafb-2d-engine-rewrite drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-2d-engine-rewrite
+++ a/drivers/video/via/viafbdev.h
@@ -49,9 +49,17 @@ struct viafb_shared {
 	struct lvds_setting_information lvds_setting_info;
 	struct lvds_setting_information lvds_setting_info2;
 	struct chip_information chip_info;
+
+	/* hardware acceleration stuff */
+	int (*hw_bitblt)(void __iomem *engine, u8 op, u32 width, u32 height,
+		u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
+		u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
+		u32 fg_color, u32 bg_color, u8 fill_rop);
 };
 
 struct viafb_par {
+	u8 depth;
+	u32 vram_addr;
 	void __iomem *io_virt;	/*iospace virtual memory address */
 	unsigned int fbmem;	/*framebuffer physical memory address */
 	unsigned int memsize;	/*size of fbmem */
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

