From: akpm@linux-foundation.org
Subject: + pxafb-add-support-for-other-palette-formats.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:46 -0700
Message-ID: <200707261900.l6QJ0kSD015670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933104AbXGZTNH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:13:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hjk@linutronix.de, adaplas@gmail.com


The patch titled
     pxafb: Add support for other palette formats
has been added to the -mm tree.  Its filename is
     pxafb-add-support-for-other-palette-formats.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pxafb: Add support for other palette formats
From: Hans J. Koch <hjk@linutronix.de>

This patch adds support for the other three palette formats possible with
the PXA LCD controller. This is required on boards where an LCD is connected
with all its 18 bits. With this patch, it's possible to use an 8-bit mode
with 18-bit palette entries. This used to be possible in 2.4 kernels but
disappeared in 2.6. With current kernels, you can only get wrong colours
out of an LCD connected this way.

Users can choose the palette format by doing something like this
in their board definition:

static struct pxafb_mach_info my_fb_info = {
        [...]
        .lccr3          = LCCR3_OutEnH | LCCR3_PixFlEdg | LCCR3_PDFOR_3,
        .lccr4          = LCCR4_PAL_FOR_2,
        [...]
};

Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c               |   64 +++++++++++++++++++-------
 drivers/video/pxafb.h               |    2 
 include/asm-arm/arch-pxa/pxa-regs.h |   11 ++++
 include/asm-arm/arch-pxa/pxafb.h    |    7 ++
 4 files changed, 68 insertions(+), 16 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-add-support-for-other-palette-formats drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-add-support-for-other-palette-formats
+++ a/drivers/video/pxafb.c
@@ -106,20 +106,38 @@ pxafb_setpalettereg(u_int regno, u_int r
 		       u_int trans, struct fb_info *info)
 {
 	struct pxafb_info *fbi = (struct pxafb_info *)info;
-	u_int val, ret = 1;
+	u_int val;
 
-	if (regno < fbi->palette_size) {
-		if (fbi->fb.var.grayscale) {
-			val = ((blue >> 8) & 0x00ff);
-		} else {
-			val  = ((red   >>  0) & 0xf800);
-			val |= ((green >>  5) & 0x07e0);
-			val |= ((blue  >> 11) & 0x001f);
-		}
+	if (regno >= fbi->palette_size)
+		return 1;
+
+	if (fbi->fb.var.grayscale) {
+		fbi->palette_cpu[regno] = ((blue >> 8) & 0x00ff);
+		return 0;
+	}
+
+	switch (fbi->lccr4 & LCCR4_PAL_FOR_MASK) {
+	case LCCR4_PAL_FOR_0:
+		val  = ((red   >>  0) & 0xf800);
+		val |= ((green >>  5) & 0x07e0);
+		val |= ((blue  >> 11) & 0x001f);
 		fbi->palette_cpu[regno] = val;
-		ret = 0;
+		break;
+	case LCCR4_PAL_FOR_1:
+		val  = ((red   << 8) & 0x00f80000);
+		val |= ((green >> 0) & 0x0000fc00);
+		val |= ((blue  >> 8) & 0x000000f8);
+		((u32*)(fbi->palette_cpu))[regno] = val;
+		break;
+	case LCCR4_PAL_FOR_2:
+		val  = ((red   << 8) & 0x00fc0000);
+		val |= ((green >> 0) & 0x0000fc00);
+		val |= ((blue  >> 8) & 0x000000fc);
+		((u32*)(fbi->palette_cpu))[regno] = val;
+		break;
 	}
-	return ret;
+
+	return 0;
 }
 
 static int
@@ -361,7 +379,10 @@ static int pxafb_set_par(struct fb_info 
 	else
 		fbi->palette_size = var->bits_per_pixel == 1 ? 4 : 1 << var->bits_per_pixel;
 
-	palette_mem_size = fbi->palette_size * sizeof(u16);
+	if ((fbi->lccr4 & LCCR4_PAL_FOR_MASK) == LCCR4_PAL_FOR_0)
+		palette_mem_size = fbi->palette_size * sizeof(u16);
+	else
+		palette_mem_size = fbi->palette_size * sizeof(u32);
 
 	pr_debug("pxafb: palette_mem_size = 0x%08lx\n", palette_mem_size);
 
@@ -676,7 +697,13 @@ static int pxafb_activate_var(struct fb_
 
 	fbi->dmadesc_palette_cpu->fsadr = fbi->palette_dma;
 	fbi->dmadesc_palette_cpu->fidr  = 0;
-	fbi->dmadesc_palette_cpu->ldcmd = (fbi->palette_size * 2) | LDCMD_PAL;
+	if ((fbi->lccr4 & LCCR4_PAL_FOR_MASK) == LCCR4_PAL_FOR_0)
+		fbi->dmadesc_palette_cpu->ldcmd = fbi->palette_size *
+							sizeof(u16);
+	else
+		fbi->dmadesc_palette_cpu->ldcmd = fbi->palette_size *
+							sizeof(u32);
+	fbi->dmadesc_palette_cpu->ldcmd |= LDCMD_PAL;
 
 	if (var->bits_per_pixel == 16) {
 		/* palette shouldn't be loaded in true-color mode */
@@ -715,6 +742,8 @@ static int pxafb_activate_var(struct fb_
 	fbi->reg_lccr1 = new_regs.lccr1;
 	fbi->reg_lccr2 = new_regs.lccr2;
 	fbi->reg_lccr3 = new_regs.lccr3;
+	fbi->reg_lccr4 = LCCR4 & (~LCCR4_PAL_FOR_MASK);
+	fbi->reg_lccr4 |= (fbi->lccr4 & LCCR4_PAL_FOR_MASK);
 	set_hsync_time(fbi, pcd);
 	local_irq_restore(flags);
 
@@ -821,6 +850,7 @@ static void pxafb_enable_controller(stru
 	pr_debug("LCCR1 0x%08x\n", (unsigned int) LCCR1);
 	pr_debug("LCCR2 0x%08x\n", (unsigned int) LCCR2);
 	pr_debug("LCCR3 0x%08x\n", (unsigned int) LCCR3);
+	pr_debug("LCCR4 0x%08x\n", (unsigned int) LCCR4);
 }
 
 static void pxafb_disable_controller(struct pxafb_info *fbi)
@@ -1090,10 +1120,13 @@ static int __init pxafb_map_video_memory
 		 * dma_writecombine_mmap)
 		 */
 		fbi->fb.fix.smem_start = fbi->screen_dma;
-
 		fbi->palette_size = fbi->fb.var.bits_per_pixel == 8 ? 256 : 16;
 
-		palette_mem_size = fbi->palette_size * sizeof(u16);
+		if ((fbi->lccr4 & LCCR4_PAL_FOR_MASK) == LCCR4_PAL_FOR_0)
+			palette_mem_size = fbi->palette_size * sizeof(u16);
+		else
+			palette_mem_size = fbi->palette_size * sizeof(u32);
+
 		pr_debug("pxafb: palette_mem_size = 0x%08lx\n", palette_mem_size);
 
 		fbi->palette_cpu = (u16 *)(fbi->map_cpu + PAGE_SIZE - palette_mem_size);
@@ -1150,6 +1183,7 @@ static struct pxafb_info * __init pxafb_
 
 	fbi->lccr0			= inf->lccr0;
 	fbi->lccr3			= inf->lccr3;
+	fbi->lccr4			= inf->lccr4;
 	fbi->state			= C_STARTUP;
 	fbi->task_state			= (u_char)-1;
 
diff -puN drivers/video/pxafb.h~pxafb-add-support-for-other-palette-formats drivers/video/pxafb.h
--- a/drivers/video/pxafb.h~pxafb-add-support-for-other-palette-formats
+++ a/drivers/video/pxafb.h
@@ -70,6 +70,7 @@ struct pxafb_info {
 
 	u_int			lccr0;
 	u_int			lccr3;
+	u_int			lccr4;
 	u_int			cmap_inverse:1,
 				cmap_static:1,
 				unused:30;
@@ -78,6 +79,7 @@ struct pxafb_info {
 	u_int			reg_lccr1;
 	u_int			reg_lccr2;
 	u_int			reg_lccr3;
+	u_int			reg_lccr4;
 
 	unsigned long	hsync_time;
 
diff -puN include/asm-arm/arch-pxa/pxa-regs.h~pxafb-add-support-for-other-palette-formats include/asm-arm/arch-pxa/pxa-regs.h
--- a/include/asm-arm/arch-pxa/pxa-regs.h~pxafb-add-support-for-other-palette-formats
+++ a/include/asm-arm/arch-pxa/pxa-regs.h
@@ -1823,6 +1823,7 @@
 #define LCCR1		__REG(0x44000004)  /* LCD Controller Control Register 1 */
 #define LCCR2		__REG(0x44000008)  /* LCD Controller Control Register 2 */
 #define LCCR3		__REG(0x4400000C)  /* LCD Controller Control Register 3 */
+#define LCCR4		__REG(0x44000010)  /* LCD Controller Control Register 3 */
 #define DFBR0		__REG(0x44000020)  /* DMA Channel 0 Frame Branch Register */
 #define DFBR1		__REG(0x44000024)  /* DMA Channel 1 Frame Branch Register */
 #define LCSR		__REG(0x44000038)  /* LCD Controller Status Register */
@@ -1836,6 +1837,16 @@
 #define LCCR3_8BPP (3 << 24)
 #define LCCR3_16BPP (4 << 24)
 
+#define LCCR3_PDFOR_0 (0 << 30)
+#define LCCR3_PDFOR_1 (1 << 30)
+#define LCCR3_PDFOR_2 (2 << 30)
+#define LCCR3_PDFOR_3 (3 << 30)
+
+#define LCCR4_PAL_FOR_0 (0 << 15)
+#define LCCR4_PAL_FOR_1 (1 << 15)
+#define LCCR4_PAL_FOR_2 (2 << 15)
+#define LCCR4_PAL_FOR_MASK (3 << 15)
+
 #define FDADR0		__REG(0x44000200)  /* DMA Channel 0 Frame Descriptor Address Register */
 #define FSADR0		__REG(0x44000204)  /* DMA Channel 0 Frame Source Address Register */
 #define FIDR0		__REG(0x44000208)  /* DMA Channel 0 Frame ID Register */
diff -puN include/asm-arm/arch-pxa/pxafb.h~pxafb-add-support-for-other-palette-formats include/asm-arm/arch-pxa/pxafb.h
--- a/include/asm-arm/arch-pxa/pxafb.h~pxafb-add-support-for-other-palette-formats
+++ a/include/asm-arm/arch-pxa/pxafb.h
@@ -70,7 +70,12 @@ struct pxafb_mach_info {
 	 *      LCCR3_HSP, LCCR3_VSP, LCCR0_Pcd(x), LCCR3_Bpp
 	 */
 	u_int		lccr3;
-
+	/* The following should be defined in LCCR4
+	 *	LCCR4_PAL_FOR_0 or LCCR4_PAL_FOR_1 or LCCR4_PAL_FOR_2
+	 *
+	 * All other bits in LCCR4 should be left alone.
+	 */
+	u_int		lccr4;
 	void (*pxafb_backlight_power)(int);
 	void (*pxafb_lcd_power)(int, struct fb_var_screeninfo *);
 
_

Patches currently in -mm which might be from hjk@linutronix.de are

git-hwmon.patch
pxafb-add-support-for-other-palette-formats.patch
