From: akpm@linux-foundation.org
Subject: - pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:11 -0700
Message-ID: <200805010925.m419PBHX030178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757594AbYEAJpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: introduce "struct pxafb_dma_buff" for palette and dma descriptors
has been removed from the -mm tree.  Its filename was
     pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: introduce "struct pxafb_dma_buff" for palette and dma descriptors
From: eric miao <eric.miao@marvell.com>

Use structure and array for palette buffer and dma descriptors to:

1. better organize code for future expansion like overlays
2. separate palette and dma descriptors from frame buffer

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |  132 ++++++++++++++++++----------------------
 drivers/video/pxafb.h |   46 ++++++++++---
 2 files changed, 95 insertions(+), 83 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors
+++ a/drivers/video/pxafb.c
@@ -361,7 +361,6 @@ static int pxafb_set_par(struct fb_info 
 {
 	struct pxafb_info *fbi = (struct pxafb_info *)info;
 	struct fb_var_screeninfo *var = &info->var;
-	unsigned long palette_mem_size;
 
 	if (var->bits_per_pixel == 16)
 		fbi->fb.fix.visual = FB_VISUAL_TRUECOLOR;
@@ -384,13 +383,7 @@ static int pxafb_set_par(struct fb_info 
 		fbi->palette_size = var->bits_per_pixel == 1 ?
 					4 : 1 << var->bits_per_pixel;
 
-	if ((fbi->lccr4 & LCCR4_PAL_FOR_MASK) == LCCR4_PAL_FOR_0)
-		palette_mem_size = fbi->palette_size * sizeof(u16);
-	else
-		palette_mem_size = fbi->palette_size * sizeof(u32);
-
-	fbi->palette_cpu = (u16 *)(fbi->map_cpu + PAGE_SIZE - palette_mem_size);
-	fbi->palette_dma = fbi->map_dma + PAGE_SIZE - palette_mem_size;
+	fbi->palette_cpu = (u16 *)&fbi->dma_buff->palette[0];
 
 	/*
 	 * Set (any) board control register to handle new color depth
@@ -546,6 +539,48 @@ unsigned long pxafb_get_hsync_time(struc
 }
 EXPORT_SYMBOL(pxafb_get_hsync_time);
 
+static int setup_frame_dma(struct pxafb_info *fbi, int dma, int pal,
+		unsigned int offset, size_t size)
+{
+	struct pxafb_dma_descriptor *dma_desc, *pal_desc;
+	unsigned int dma_desc_off, pal_desc_off;
+
+	if (dma < 0 || dma >= DMA_MAX)
+		return -EINVAL;
+
+	dma_desc = &fbi->dma_buff->dma_desc[dma];
+	dma_desc_off = offsetof(struct pxafb_dma_buff, dma_desc[dma]);
+
+	dma_desc->fsadr = fbi->screen_dma + offset;
+	dma_desc->fidr  = 0;
+	dma_desc->ldcmd = size;
+
+	if (pal < 0 || pal >= PAL_MAX) {
+		dma_desc->fdadr = fbi->dma_buff_phys + dma_desc_off;
+		fbi->fdadr[dma] = fbi->dma_buff_phys + dma_desc_off;
+	} else {
+		pal_desc = &fbi->dma_buff->pal_desc[dma];
+		pal_desc_off = offsetof(struct pxafb_dma_buff, dma_desc[pal]);
+
+		pal_desc->fsadr = fbi->dma_buff_phys + pal * PALETTE_SIZE;
+		pal_desc->fidr  = 0;
+
+		if ((fbi->lccr4 & LCCR4_PAL_FOR_MASK) == LCCR4_PAL_FOR_0)
+			pal_desc->ldcmd = fbi->palette_size * sizeof(u16);
+		else
+			pal_desc->ldcmd = fbi->palette_size * sizeof(u32);
+
+		pal_desc->ldcmd |= LDCMD_PAL;
+
+		/* flip back and forth between palette and frame buffer */
+		pal_desc->fdadr = fbi->dma_buff_phys + dma_desc_off;
+		dma_desc->fdadr = fbi->dma_buff_phys + pal_desc_off;
+		fbi->fdadr[dma] = fbi->dma_buff_phys + dma_desc_off;
+	}
+
+	return 0;
+}
+
 /*
  * pxafb_activate_var():
  *	Configures LCD Controller based on entries in var parameter.
@@ -557,6 +592,7 @@ static int pxafb_activate_var(struct fb_
 	struct pxafb_lcd_reg new_regs;
 	u_long flags;
 	u_int lines_per_panel, pcd = get_pcd(fbi, var->pixclock);
+	size_t nbytes;
 
 #if DEBUG_VAR
 	if (var->xres < 16 || var->xres > 1024)
@@ -634,54 +670,15 @@ static int pxafb_activate_var(struct fb_
 	/* Update shadow copy atomically */
 	local_irq_save(flags);
 
-	/* setup dma descriptors */
-	fbi->dmadesc_fblow_cpu = (struct pxafb_dma_descriptor *)
-				((unsigned int)fbi->palette_cpu - 3*16);
-	fbi->dmadesc_fbhigh_cpu = (struct pxafb_dma_descriptor *)
-				((unsigned int)fbi->palette_cpu - 2*16);
-	fbi->dmadesc_palette_cpu = (struct pxafb_dma_descriptor *)
-				((unsigned int)fbi->palette_cpu - 1*16);
-
-	fbi->dmadesc_fblow_dma = fbi->palette_dma - 3*16;
-	fbi->dmadesc_fbhigh_dma = fbi->palette_dma - 2*16;
-	fbi->dmadesc_palette_dma = fbi->palette_dma - 1*16;
-
-#define BYTES_PER_PANEL (lines_per_panel * fbi->fb.fix.line_length)
-
-	/* populate descriptors */
-	fbi->dmadesc_fblow_cpu->fdadr = fbi->dmadesc_fblow_dma;
-	fbi->dmadesc_fblow_cpu->fsadr = fbi->screen_dma + BYTES_PER_PANEL;
-	fbi->dmadesc_fblow_cpu->fidr  = 0;
-	fbi->dmadesc_fblow_cpu->ldcmd = BYTES_PER_PANEL;
-
-	fbi->fdadr1 = fbi->dmadesc_fblow_dma; /* only used in dual-panel mode */
-
-	fbi->dmadesc_fbhigh_cpu->fsadr = fbi->screen_dma;
-	fbi->dmadesc_fbhigh_cpu->fidr = 0;
-	fbi->dmadesc_fbhigh_cpu->ldcmd = BYTES_PER_PANEL;
-
-	fbi->dmadesc_palette_cpu->fsadr = fbi->palette_dma;
-	fbi->dmadesc_palette_cpu->fidr  = 0;
-	if ((fbi->lccr4 & LCCR4_PAL_FOR_MASK) == LCCR4_PAL_FOR_0)
-		fbi->dmadesc_palette_cpu->ldcmd = fbi->palette_size *
-							sizeof(u16);
+	nbytes = lines_per_panel * fbi->fb.fix.line_length;
+
+	if ((fbi->lccr0 & LCCR0_SDS) == LCCR0_Dual)
+		setup_frame_dma(fbi, DMA_LOWER, PAL_NONE, nbytes, nbytes);
+
+	if (var->bits_per_pixel >= 16)
+		setup_frame_dma(fbi, DMA_BASE, PAL_NONE, 0, nbytes);
 	else
-		fbi->dmadesc_palette_cpu->ldcmd = fbi->palette_size *
-							sizeof(u32);
-	fbi->dmadesc_palette_cpu->ldcmd |= LDCMD_PAL;
-
-	if (var->bits_per_pixel == 16) {
-		/* palette shouldn't be loaded in true-color mode */
-		fbi->dmadesc_fbhigh_cpu->fdadr = fbi->dmadesc_fbhigh_dma;
-		fbi->fdadr0 = fbi->dmadesc_fbhigh_dma; /* no pal just fbhigh */
-		/* init it to something, even though we won't be using it */
-		fbi->dmadesc_palette_cpu->fdadr = fbi->dmadesc_palette_dma;
-	} else {
-		/* flips back and forth between pal and fbhigh */
-		fbi->dmadesc_palette_cpu->fdadr = fbi->dmadesc_fbhigh_dma;
-		fbi->dmadesc_fbhigh_cpu->fdadr = fbi->dmadesc_palette_dma;
-		fbi->fdadr0 = fbi->dmadesc_palette_dma;
-	}
+		setup_frame_dma(fbi, DMA_BASE, PAL_BASE, 0, nbytes);
 
 	fbi->reg_lccr0 = new_regs.lccr0;
 	fbi->reg_lccr1 = new_regs.lccr1;
@@ -701,8 +698,8 @@ static int pxafb_activate_var(struct fb_
 	    (__raw_readl(fbi->mmio_base + LCCR1) != fbi->reg_lccr1) ||
 	    (__raw_readl(fbi->mmio_base + LCCR2) != fbi->reg_lccr2) ||
 	    (__raw_readl(fbi->mmio_base + LCCR3) != fbi->reg_lccr3) ||
-	    (__raw_readl(fbi->mmio_base + FDADR0) != fbi->fdadr0) ||
-	    (__raw_readl(fbi->mmio_base + FDADR1) != fbi->fdadr1))
+	    (__raw_readl(fbi->mmio_base + FDADR0) != fbi->fdadr[0]) ||
+	    (__raw_readl(fbi->mmio_base + FDADR1) != fbi->fdadr[1]))
 		pxafb_schedule_work(fbi, C_REENABLE);
 
 	return 0;
@@ -777,8 +774,8 @@ static void pxafb_setup_gpio(struct pxaf
 static void pxafb_enable_controller(struct pxafb_info *fbi)
 {
 	pr_debug("pxafb: Enabling LCD controller\n");
-	pr_debug("fdadr0 0x%08x\n", (unsigned int) fbi->fdadr0);
-	pr_debug("fdadr1 0x%08x\n", (unsigned int) fbi->fdadr1);
+	pr_debug("fdadr0 0x%08x\n", (unsigned int) fbi->fdadr[0]);
+	pr_debug("fdadr1 0x%08x\n", (unsigned int) fbi->fdadr[1]);
 	pr_debug("reg_lccr0 0x%08x\n", (unsigned int) fbi->reg_lccr0);
 	pr_debug("reg_lccr1 0x%08x\n", (unsigned int) fbi->reg_lccr1);
 	pr_debug("reg_lccr2 0x%08x\n", (unsigned int) fbi->reg_lccr2);
@@ -793,8 +790,8 @@ static void pxafb_enable_controller(stru
 	__raw_writel(fbi->reg_lccr1, fbi->mmio_base + LCCR1);
 	__raw_writel(fbi->reg_lccr0 & ~LCCR0_ENB, fbi->mmio_base + LCCR0);
 
-	__raw_writel(fbi->fdadr0, fbi->mmio_base + FDADR0);
-	__raw_writel(fbi->fdadr1, fbi->mmio_base + FDADR1);
+	__raw_writel(fbi->fdadr[0], fbi->mmio_base + FDADR0);
+	__raw_writel(fbi->fdadr[1], fbi->mmio_base + FDADR1);
 	__raw_writel(fbi->reg_lccr0 | LCCR0_ENB, fbi->mmio_base + LCCR0);
 }
 
@@ -1038,8 +1035,6 @@ static int pxafb_resume(struct platform_
  */
 static int __init pxafb_map_video_memory(struct pxafb_info *fbi)
 {
-	u_long palette_mem_size;
-
 	/*
 	 * We reserve one page for the palette, plus the size
 	 * of the framebuffer.
@@ -1062,14 +1057,9 @@ static int __init pxafb_map_video_memory
 		fbi->fb.fix.smem_start = fbi->screen_dma;
 		fbi->palette_size = fbi->fb.var.bits_per_pixel == 8 ? 256 : 16;
 
-		if ((fbi->lccr4 & LCCR4_PAL_FOR_MASK) == LCCR4_PAL_FOR_0)
-			palette_mem_size = fbi->palette_size * sizeof(u16);
-		else
-			palette_mem_size = fbi->palette_size * sizeof(u32);
-
-		fbi->palette_cpu = (u16 *)(fbi->map_cpu + PAGE_SIZE
-						- palette_mem_size);
-		fbi->palette_dma = fbi->map_dma + PAGE_SIZE - palette_mem_size;
+		fbi->dma_buff = (void *)fbi->map_cpu;
+		fbi->dma_buff_phys = fbi->map_dma;
+		fbi->palette_cpu = (u16 *)&fbi->dma_buff->palette[0];
 	}
 
 	return fbi->map_cpu ? 0 : -ENOMEM;
diff -puN drivers/video/pxafb.h~pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors drivers/video/pxafb.h
--- a/drivers/video/pxafb.h~pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors
+++ a/drivers/video/pxafb.h
@@ -37,6 +37,36 @@ struct pxafb_dma_descriptor {
 	unsigned int ldcmd;
 };
 
+enum {
+	PAL_NONE	= -1,
+	PAL_BASE	= 0,
+	PAL_OV1		= 1,
+	PAL_OV2		= 2,
+	PAL_MAX,
+};
+
+enum {
+	DMA_BASE	= 0,
+	DMA_UPPER	= 0,
+	DMA_LOWER	= 1,
+	DMA_OV1		= 1,
+	DMA_OV2_Y	= 2,
+	DMA_OV2_Cb	= 3,
+	DMA_OV2_Cr	= 4,
+	DMA_CURSOR	= 5,
+	DMA_CMD		= 6,
+	DMA_MAX,
+};
+
+/* maximum palette size - 256 entries, each 4 bytes long */
+#define PALETTE_SIZE	(256 * 4)
+
+struct pxafb_dma_buff {
+	unsigned char palette[PAL_MAX * PALETTE_SIZE];
+	struct pxafb_dma_descriptor pal_desc[PAL_MAX];
+	struct pxafb_dma_descriptor dma_desc[DMA_MAX];
+};
+
 struct pxafb_info {
 	struct fb_info		fb;
 	struct device		*dev;
@@ -44,6 +74,10 @@ struct pxafb_info {
 
 	void __iomem		*mmio_base;
 
+	struct pxafb_dma_buff	*dma_buff;
+	dma_addr_t		dma_buff_phys;
+	dma_addr_t		fdadr[DMA_MAX];
+
 	/*
 	 * These are the addresses we mapped
 	 * the framebuffer memory region to.
@@ -57,20 +91,8 @@ struct pxafb_info {
 	u_char *		screen_cpu;	/* virtual address of frame buffer */
 	dma_addr_t		screen_dma;	/* physical address of frame buffer */
 	u16 *			palette_cpu;	/* virtual address of palette memory */
-	dma_addr_t		palette_dma;	/* physical address of palette memory */
 	u_int			palette_size;
 
-	/* DMA descriptors */
-	struct pxafb_dma_descriptor * 	dmadesc_fblow_cpu;
-	dma_addr_t		dmadesc_fblow_dma;
-	struct pxafb_dma_descriptor * 	dmadesc_fbhigh_cpu;
-	dma_addr_t		dmadesc_fbhigh_dma;
-	struct pxafb_dma_descriptor *	dmadesc_palette_cpu;
-	dma_addr_t		dmadesc_palette_dma;
-
-	dma_addr_t		fdadr0;
-	dma_addr_t		fdadr1;
