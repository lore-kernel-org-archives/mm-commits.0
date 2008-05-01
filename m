From: akpm@linux-foundation.org
Subject: - pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:09 -0700
Message-ID: <200805010925.m419P9kp030172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758188AbYEAJpw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:45:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: convert fb driver to use ioremap() and __raw_{readl, writel}
has been removed from the -mm tree.  Its filename was
     pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: convert fb driver to use ioremap() and __raw_{readl, writel}
From: eric miao <eric.miao@marvell.com>

This is part of the effort moving peripheral registers outside of pxa-regs.h,
and using ioremap() make it possible the same IP can be re-used on different
processors with different registers space

As a result, the fixed mapping in pxa_map_io() is removed.

The regs-lcd.h can actually moved to where closer to pxafb.c but some of its
bit definitions are directly used by various platform code, though this is not
a good style.

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/generic.c         |    5 
 drivers/video/pxafb.c               |   94 +++++++++---
 drivers/video/pxafb.h               |    2 
 include/asm-arm/arch-pxa/pxa-regs.h |  196 --------------------------
 include/asm-arm/arch-pxa/pxafb.h    |    1 
 include/asm-arm/arch-pxa/regs-lcd.h |  139 ++++++++++++++++++
 6 files changed, 213 insertions(+), 224 deletions(-)

diff -puN arch/arm/mach-pxa/generic.c~pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel arch/arm/mach-pxa/generic.c
--- a/arch/arm/mach-pxa/generic.c~pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel
+++ a/arch/arm/mach-pxa/generic.c
@@ -90,11 +90,6 @@ static struct map_desc standard_io_desc[
 		.pfn		= __phys_to_pfn(0x40000000),
 		.length		= 0x02000000,
 		.type		= MT_DEVICE
-	}, {	/* LCD */
-		.virtual	=  0xf4000000,
-		.pfn		= __phys_to_pfn(0x44000000),
-		.length		= 0x00100000,
-		.type		= MT_DEVICE
 	}, {	/* Mem Ctl */
 		.virtual	=  0xf6000000,
 		.pfn		= __phys_to_pfn(0x48000000),
diff -puN drivers/video/pxafb.c~pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel
+++ a/drivers/video/pxafb.c
@@ -687,7 +687,8 @@ static int pxafb_activate_var(struct fb_
 	fbi->reg_lccr1 = new_regs.lccr1;
 	fbi->reg_lccr2 = new_regs.lccr2;
 	fbi->reg_lccr3 = new_regs.lccr3;
-	fbi->reg_lccr4 = LCCR4 & (~LCCR4_PAL_FOR_MASK);
+	fbi->reg_lccr4 = __raw_readl(fbi->mmio_base + LCCR4) &
+				(~LCCR4_PAL_FOR_MASK);
 	fbi->reg_lccr4 |= (fbi->lccr4 & LCCR4_PAL_FOR_MASK);
 	set_hsync_time(fbi, pcd);
 	local_irq_restore(flags);
@@ -696,9 +697,12 @@ static int pxafb_activate_var(struct fb_
 	 * Only update the registers if the controller is enabled
 	 * and something has changed.
 	 */
-	if ((LCCR0  != fbi->reg_lccr0) || (LCCR1  != fbi->reg_lccr1) ||
-	    (LCCR2  != fbi->reg_lccr2) || (LCCR3  != fbi->reg_lccr3) ||
-	    (FDADR0 != fbi->fdadr0)    || (FDADR1 != fbi->fdadr1))
+	if ((__raw_readl(fbi->mmio_base + LCCR0) != fbi->reg_lccr0) ||
+	    (__raw_readl(fbi->mmio_base + LCCR1) != fbi->reg_lccr1) ||
+	    (__raw_readl(fbi->mmio_base + LCCR2) != fbi->reg_lccr2) ||
+	    (__raw_readl(fbi->mmio_base + LCCR3) != fbi->reg_lccr3) ||
+	    (__raw_readl(fbi->mmio_base + FDADR0) != fbi->fdadr0) ||
+	    (__raw_readl(fbi->mmio_base + FDADR1) != fbi->fdadr1))
 		pxafb_schedule_work(fbi, C_REENABLE);
 
 	return 0;
@@ -784,26 +788,31 @@ static void pxafb_enable_controller(stru
 	clk_enable(fbi->clk);
 
 	/* Sequence from 11.7.10 */
-	LCCR3 = fbi->reg_lccr3;
-	LCCR2 = fbi->reg_lccr2;
-	LCCR1 = fbi->reg_lccr1;
-	LCCR0 = fbi->reg_lccr0 & ~LCCR0_ENB;
-
-	FDADR0 = fbi->fdadr0;
-	FDADR1 = fbi->fdadr1;
-	LCCR0 |= LCCR0_ENB;
+	__raw_writel(fbi->reg_lccr3, fbi->mmio_base + LCCR3);
+	__raw_writel(fbi->reg_lccr2, fbi->mmio_base + LCCR2);
+	__raw_writel(fbi->reg_lccr1, fbi->mmio_base + LCCR1);
+	__raw_writel(fbi->reg_lccr0 & ~LCCR0_ENB, fbi->mmio_base + LCCR0);
+
+	__raw_writel(fbi->fdadr0, fbi->mmio_base + FDADR0);
+	__raw_writel(fbi->fdadr1, fbi->mmio_base + FDADR1);
+	__raw_writel(fbi->reg_lccr0 | LCCR0_ENB, fbi->mmio_base + LCCR0);
 }
 
 static void pxafb_disable_controller(struct pxafb_info *fbi)
 {
+	uint32_t lccr0;
+
 	DECLARE_WAITQUEUE(wait, current);
 
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(&fbi->ctrlr_wait, &wait);
 
-	LCSR = 0xffffffff;	/* Clear LCD Status Register */
-	LCCR0 &= ~LCCR0_LDM;	/* Enable LCD Disable Done Interrupt */
-	LCCR0 |= LCCR0_DIS;	/* Disable LCD Controller */
+	/* Clear LCD Status Register */
+	__raw_writel(0xffffffff, fbi->mmio_base + LCSR);
+
+	lccr0 = __raw_readl(fbi->mmio_base + LCCR0) & ~LCCR0_LDM;
+	__raw_writel(lccr0, fbi->mmio_base + LCCR0);
+	__raw_writel(lccr0 | LCCR0_DIS, fbi->mmio_base + LCCR0);
 
 	schedule_timeout(200 * HZ / 1000);
 	remove_wait_queue(&fbi->ctrlr_wait, &wait);
@@ -818,14 +827,15 @@ static void pxafb_disable_controller(str
 static irqreturn_t pxafb_handle_irq(int irq, void *dev_id)
 {
 	struct pxafb_info *fbi = dev_id;
-	unsigned int lcsr = LCSR;
+	unsigned int lccr0, lcsr = __raw_readl(fbi->mmio_base + LCSR);
 
 	if (lcsr & LCSR_LDD) {
-		LCCR0 |= LCCR0_LDM;
+		lccr0 = __raw_readl(fbi->mmio_base + LCCR0) | LCCR0_LDM;
+		__raw_writel(lccr0, fbi->mmio_base + LCCR0);
 		wake_up(&fbi->ctrlr_wait);
 	}
 
-	LCSR = lcsr;
+	__raw_writel(lcsr, fbi->mmio_base + LCSR);
 	return IRQ_HANDLED;
 }
 
@@ -1343,7 +1353,8 @@ static int __init pxafb_probe(struct pla
 {
 	struct pxafb_info *fbi;
 	struct pxafb_mach_info *inf;
-	int ret;
+	struct resource *r;
+	int irq, ret;
 
 	dev_dbg(&dev->dev, "pxafb_probe\n");
 
@@ -1406,19 +1417,47 @@ static int __init pxafb_probe(struct pla
 		goto failed;
 	}
 
+	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		dev_err(&dev->dev, "no I/O memory resource defined\n");
+		ret = -ENODEV;
+		goto failed;
+	}
+
+	r = request_mem_region(r->start, r->end - r->start + 1, dev->name);
+	if (r == NULL) {
+		dev_err(&dev->dev, "failed to request I/O memory\n");
+		ret = -EBUSY;
+		goto failed;
+	}
+
+	fbi->mmio_base = ioremap(r->start, r->end - r->start + 1);
+	if (fbi->mmio_base == NULL) {
+		dev_err(&dev->dev, "failed to map I/O memory\n");
+		ret = -EBUSY;
+		goto failed_free_res;
+	}
+
 	/* Initialize video memory */
 	ret = pxafb_map_video_memory(fbi);
 	if (ret) {
 		dev_err(&dev->dev, "Failed to allocate video RAM: %d\n", ret);
 		ret = -ENOMEM;
-		goto failed;
+		goto failed_free_io;
 	}
 
-	ret = request_irq(IRQ_LCD, pxafb_handle_irq, IRQF_DISABLED, "LCD", fbi);
+	irq = platform_get_irq(dev, 0);
+	if (irq < 0) {
+		dev_err(&dev->dev, "no IRQ defined\n");
+		ret = -ENODEV;
+		goto failed_free_mem;
+	}
+
+	ret = request_irq(irq, pxafb_handle_irq, IRQF_DISABLED, "LCD", fbi);
 	if (ret) {
 		dev_err(&dev->dev, "request_irq failed: %d\n", ret);
 		ret = -EBUSY;
-		goto failed;
+		goto failed_free_mem;
 	}
 
 	/*
@@ -1434,7 +1473,7 @@ static int __init pxafb_probe(struct pla
 	if (ret < 0) {
 		dev_err(&dev->dev,
 			"Failed to register framebuffer device: %d\n", ret);
-		goto failed;
+		goto failed_free_irq;
 	}
 
 #ifdef CONFIG_CPU_FREQ
@@ -1453,6 +1492,15 @@ static int __init pxafb_probe(struct pla
 
 	return 0;
 
+failed_free_irq:
+	free_irq(irq, fbi);
+failed_free_res:
+	release_mem_region(r->start, r->end - r->start + 1);
+failed_free_io:
+	iounmap(fbi->mmio_base);
+failed_free_mem:
+	dma_free_writecombine(&dev->dev, fbi->map_size,
+			fbi->map_cpu, fbi->map_dma);
 failed:
 	platform_set_drvdata(dev, NULL);
 	kfree(fbi);
diff -puN drivers/video/pxafb.h~pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel drivers/video/pxafb.h
--- a/drivers/video/pxafb.h~pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel
+++ a/drivers/video/pxafb.h
@@ -42,6 +42,8 @@ struct pxafb_info {
 	struct device		*dev;
 	struct clk		*clk;
 
+	void __iomem		*mmio_base;
+
 	/*
 	 * These are the addresses we mapped
 	 * the framebuffer memory region to.
diff -puN include/asm-arm/arch-pxa/pxa-regs.h~pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel include/asm-arm/arch-pxa/pxa-regs.h
--- a/include/asm-arm/arch-pxa/pxa-regs.h~pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel
+++ a/include/asm-arm/arch-pxa/pxa-regs.h
@@ -1406,202 +1406,6 @@
 #define OSCC_OON	(1 << 1)	/* 32.768kHz OON (write-once only bit) */
 #define OSCC_OOK	(1 << 0)	/* 32.768kHz OOK (read-only bit) */
 
-
-/*
- * LCD
- */
-
-#define LCCR0		__REG(0x44000000)  /* LCD Controller Control Register 0 */
-#define LCCR1		__REG(0x44000004)  /* LCD Controller Control Register 1 */
-#define LCCR2		__REG(0x44000008)  /* LCD Controller Control Register 2 */
-#define LCCR3		__REG(0x4400000C)  /* LCD Controller Control Register 3 */
-#define LCCR4		__REG(0x44000010)  /* LCD Controller Control Register 3 */
-#define DFBR0		__REG(0x44000020)  /* DMA Channel 0 Frame Branch Register */
-#define DFBR1		__REG(0x44000024)  /* DMA Channel 1 Frame Branch Register */
-#define LCSR		__REG(0x44000038)  /* LCD Controller Status Register */
-#define LIIDR		__REG(0x4400003C)  /* LCD Controller Interrupt ID Register */
-#define TMEDRGBR	__REG(0x44000040)  /* TMED RGB Seed Register */
-#define TMEDCR		__REG(0x44000044)  /* TMED Control Register */
-
-#define LCCR3_1BPP (0 << 24)
-#define LCCR3_2BPP (1 << 24)
-#define LCCR3_4BPP (2 << 24)
-#define LCCR3_8BPP (3 << 24)
-#define LCCR3_16BPP (4 << 24)
-
-#define LCCR3_PDFOR_0 (0 << 30)
-#define LCCR3_PDFOR_1 (1 << 30)
-#define LCCR3_PDFOR_2 (2 << 30)
-#define LCCR3_PDFOR_3 (3 << 30)
-
-#define LCCR4_PAL_FOR_0 (0 << 15)
-#define LCCR4_PAL_FOR_1 (1 << 15)
-#define LCCR4_PAL_FOR_2 (2 << 15)
-#define LCCR4_PAL_FOR_MASK (3 << 15)
-
-#define FDADR0		__REG(0x44000200)  /* DMA Channel 0 Frame Descriptor Address Register */
-#define FSADR0		__REG(0x44000204)  /* DMA Channel 0 Frame Source Address Register */
-#define FIDR0		__REG(0x44000208)  /* DMA Channel 0 Frame ID Register */
-#define LDCMD0		__REG(0x4400020C)  /* DMA Channel 0 Command Register */
-#define FDADR1		__REG(0x44000210)  /* DMA Channel 1 Frame Descriptor Address Register */
-#define FSADR1		__REG(0x44000214)  /* DMA Channel 1 Frame Source Address Register */
-#define FIDR1		__REG(0x44000218)  /* DMA Channel 1 Frame ID Register */
-#define LDCMD1		__REG(0x4400021C)  /* DMA Channel 1 Command Register */
-
-#define LCCR0_ENB	(1 << 0)	/* LCD Controller enable */
-#define LCCR0_CMS	(1 << 1)	/* Color/Monochrome Display Select */
-#define LCCR0_Color     (LCCR0_CMS*0)   /*  Color display                  */
-#define LCCR0_Mono      (LCCR0_CMS*1)   /*  Monochrome display             */
-#define LCCR0_SDS	(1 << 2)	/* Single/Dual Panel Display       */
-                                        /* Select                          */
-#define LCCR0_Sngl      (LCCR0_SDS*0)   /*  Single panel display           */
-#define LCCR0_Dual      (LCCR0_SDS*1)   /*  Dual panel display             */
-
-#define LCCR0_LDM	(1 << 3)	/* LCD Disable Done Mask */
-#define LCCR0_SFM	(1 << 4)	/* Start of frame mask */
-#define LCCR0_IUM	(1 << 5)	/* Input FIFO underrun mask */
-#define LCCR0_EFM	(1 << 6)	/* End of Frame mask */
-#define LCCR0_PAS	(1 << 7)	/* Passive/Active display Select   */
-#define LCCR0_Pas       (LCCR0_PAS*0)   /*  Passive display (STN)          */
-#define LCCR0_Act       (LCCR0_PAS*1)   /*  Active display (TFT)           */
-#define LCCR0_DPD	(1 << 9)	/* Double Pixel Data (monochrome   */
-                                        /* display mode)                   */
-#define LCCR0_4PixMono  (LCCR0_DPD*0)   /*  4-Pixel/clock Monochrome       */
-                                        /*  display                        */
-#define LCCR0_8PixMono  (LCCR0_DPD*1)   /*  8-Pixel/clock Monochrome       */
-                                        /*  display                        */
-#define LCCR0_DIS	(1 << 10)	/* LCD Disable */
-#define LCCR0_QDM	(1 << 11)	/* LCD Quick Disable mask */
-#define LCCR0_PDD	(0xff << 12)	/* Palette DMA request delay */
-#define LCCR0_PDD_S	12
-#define LCCR0_BM	(1 << 20) 	/* Branch mask */
-#define LCCR0_OUM	(1 << 21)	/* Output FIFO underrun mask */
-#define LCCR0_LCDT      (1 << 22)       /* LCD panel type */
-#define LCCR0_RDSTM     (1 << 23)       /* Read status interrupt mask */
-#define LCCR0_CMDIM     (1 << 24)       /* Command interrupt mask */
-#define LCCR0_OUC       (1 << 25)       /* Overlay Underlay control bit */
-#define LCCR0_LDDALT    (1 << 26)       /* LDD alternate mapping control */
-
-#define LCCR1_PPL       Fld (10, 0)      /* Pixels Per Line - 1 */
-#define LCCR1_DisWdth(Pixel)            /* Display Width [1..800 pix.]  */ \
-                        (((Pixel) - 1) << FShft (LCCR1_PPL))
-
-#define LCCR1_HSW       Fld (6, 10)     /* Horizontal Synchronization     */
-#define LCCR1_HorSnchWdth(Tpix)         /* Horizontal Synchronization     */ \
-                                        /* pulse Width [1..64 Tpix]       */ \
-                        (((Tpix) - 1) << FShft (LCCR1_HSW))
-
-#define LCCR1_ELW       Fld (8, 16)     /* End-of-Line pixel clock Wait    */
-                                        /* count - 1 [Tpix]                */
-#define LCCR1_EndLnDel(Tpix)            /*  End-of-Line Delay              */ \
-                                        /*  [1..256 Tpix]                  */ \
-                        (((Tpix) - 1) << FShft (LCCR1_ELW))
-
-#define LCCR1_BLW       Fld (8, 24)     /* Beginning-of-Line pixel clock   */
-                                        /* Wait count - 1 [Tpix]           */
-#define LCCR1_BegLnDel(Tpix)            /*  Beginning-of-Line Delay        */ \
-                                        /*  [1..256 Tpix]                  */ \
-                        (((Tpix) - 1) << FShft (LCCR1_BLW))
-
-
-#define LCCR2_LPP       Fld (10, 0)     /* Line Per Panel - 1              */
-#define LCCR2_DisHght(Line)             /*  Display Height [1..1024 lines] */ \
-                        (((Line) - 1) << FShft (LCCR2_LPP))
-
-#define LCCR2_VSW       Fld (6, 10)     /* Vertical Synchronization pulse  */
-                                        /* Width - 1 [Tln] (L_FCLK)        */
-#define LCCR2_VrtSnchWdth(Tln)          /*  Vertical Synchronization pulse */ \
-                                        /*  Width [1..64 Tln]              */ \
-                        (((Tln) - 1) << FShft (LCCR2_VSW))
-
-#define LCCR2_EFW       Fld (8, 16)     /* End-of-Frame line clock Wait    */
-                                        /* count [Tln]                     */
-#define LCCR2_EndFrmDel(Tln)            /*  End-of-Frame Delay             */ \
-                                        /*  [0..255 Tln]                   */ \
-                        ((Tln) << FShft (LCCR2_EFW))
-
-#define LCCR2_BFW       Fld (8, 24)     /* Beginning-of-Frame line clock   */
-                                        /* Wait count [Tln]                */
-#define LCCR2_BegFrmDel(Tln)            /*  Beginning-of-Frame Delay       */ \
-                                        /*  [0..255 Tln]                   */ \
-                        ((Tln) << FShft (LCCR2_BFW))
-
-#if 0
-#define LCCR3_PCD	(0xff)		/* Pixel clock divisor */
-#define LCCR3_ACB	(0xff << 8)	/* AC Bias pin frequency */
-#define LCCR3_ACB_S	8
-#endif
-
-#define LCCR3_API	(0xf << 16)	/* AC Bias pin trasitions per interrupt */
-#define LCCR3_API_S	16
-#define LCCR3_VSP	(1 << 20)	/* vertical sync polarity */
-#define LCCR3_HSP	(1 << 21)	/* horizontal sync polarity */
-#define LCCR3_PCP	(1 << 22)	/* Pixel Clock Polarity (L_PCLK)   */
-#define LCCR3_PixRsEdg  (LCCR3_PCP*0)   /*  Pixel clock Rising-Edge        */
-#define LCCR3_PixFlEdg  (LCCR3_PCP*1)   /*  Pixel clock Falling-Edge       */
-
-#define LCCR3_OEP       (1 << 23)       /* Output Enable Polarity (L_BIAS, */
-                                        /* active display mode)            */
-#define LCCR3_OutEnH    (LCCR3_OEP*0)   /*  Output Enable active High      */
-#define LCCR3_OutEnL    (LCCR3_OEP*1)   /*  Output Enable active Low       */
-
-#if 0
-#define LCCR3_BPP	(7 << 24)	/* bits per pixel */
-#define LCCR3_BPP_S	24
-#endif
-#define LCCR3_DPC	(1 << 27)	/* double pixel clock mode */
-
-
-#define LCCR3_PCD       Fld (8, 0)      /* Pixel Clock Divisor */
-#define LCCR3_PixClkDiv(Div)            /* Pixel Clock Divisor */ \
-                        (((Div) << FShft (LCCR3_PCD)))
-
-
-#define LCCR3_BPP       Fld (3, 24)     /* Bit Per Pixel */
-#define LCCR3_Bpp(Bpp)                  /* Bit Per Pixel */ \
-                        (((Bpp) << FShft (LCCR3_BPP)))
-
-#define LCCR3_ACB       Fld (8, 8)      /* AC Bias */
-#define LCCR3_Acb(Acb)                  /* BAC Bias */ \
-                        (((Acb) << FShft (LCCR3_ACB)))
-
-#define LCCR3_HorSnchH  (LCCR3_HSP*0)   /*  Horizontal Synchronization     */
-                                        /*  pulse active High              */
-#define LCCR3_HorSnchL  (LCCR3_HSP*1)   /*  Horizontal Synchronization     */
-
-#define LCCR3_VrtSnchH  (LCCR3_VSP*0)   /*  Vertical Synchronization pulse */
-                                        /*  active High                    */
-#define LCCR3_VrtSnchL  (LCCR3_VSP*1)   /*  Vertical Synchronization pulse */
-                                        /*  active Low                     */
-
-#define LCSR_LDD	(1 << 0)	/* LCD Disable Done */
-#define LCSR_SOF	(1 << 1)	/* Start of frame */
-#define LCSR_BER	(1 << 2)	/* Bus error */
-#define LCSR_ABC	(1 << 3)	/* AC Bias count */
-#define LCSR_IUL	(1 << 4)	/* input FIFO underrun Lower panel */
-#define LCSR_IUU	(1 << 5)	/* input FIFO underrun Upper panel */
-#define LCSR_OU		(1 << 6)	/* output FIFO underrun */
-#define LCSR_QD		(1 << 7)	/* quick disable */
-#define LCSR_EOF	(1 << 8)	/* end of frame */
-#define LCSR_BS		(1 << 9)	/* branch status */
-#define LCSR_SINT	(1 << 10)	/* subsequent interrupt */
-
-#define LDCMD_PAL	(1 << 26)	/* instructs DMA to load palette buffer */
-
-#define LCSR_LDD	(1 << 0)	/* LCD Disable Done */
-#define LCSR_SOF	(1 << 1)	/* Start of frame */
-#define LCSR_BER	(1 << 2)	/* Bus error */
-#define LCSR_ABC	(1 << 3)	/* AC Bias count */
-#define LCSR_IUL	(1 << 4)	/* input FIFO underrun Lower panel */
-#define LCSR_IUU	(1 << 5)	/* input FIFO underrun Upper panel */
-#define LCSR_OU		(1 << 6)	/* output FIFO underrun */
-#define LCSR_QD		(1 << 7)	/* quick disable */
-#define LCSR_EOF	(1 << 8)	/* end of frame */
-#define LCSR_BS		(1 << 9)	/* branch status */
-#define LCSR_SINT	(1 << 10)	/* subsequent interrupt */
-
-#define LDCMD_PAL	(1 << 26)	/* instructs DMA to load palette buffer */
-
 #ifdef CONFIG_PXA27x
 
 /* Camera Interface */
diff -puN include/asm-arm/arch-pxa/pxafb.h~pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel include/asm-arm/arch-pxa/pxafb.h
--- a/include/asm-arm/arch-pxa/pxafb.h~pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel
+++ a/include/asm-arm/arch-pxa/pxafb.h
@@ -13,6 +13,7 @@
  */
 
 #include <linux/fb.h>
+#include <asm/arch/regs-lcd.h>
 
 /*
  * This structure describes the machine which we are running on.
diff -puN /dev/null include/asm-arm/arch-pxa/regs-lcd.h
--- /dev/null
+++ a/include/asm-arm/arch-pxa/regs-lcd.h
@@ -0,0 +1,139 @@
+#ifndef __ASM_ARCH_REGS_LCD_H
+#define __ASM_ARCH_REGS_LCD_H
+/*
+ * LCD Controller Registers and Bits Definitions
+ */
+#define LCCR0		(0x000)	/* LCD Controller Control Register 0 */
+#define LCCR1		(0x004)	/* LCD Controller Control Register 1 */
+#define LCCR2		(0x008)	/* LCD Controller Control Register 2 */
+#define LCCR3		(0x00C)	/* LCD Controller Control Register 3 */
+#define LCCR4		(0x010)	/* LCD Controller Control Register 3 */
+#define DFBR0		(0x020)	/* DMA Channel 0 Frame Branch Register */
+#define DFBR1		(0x024)	/* DMA Channel 1 Frame Branch Register */
+#define LCSR		(0x038)	/* LCD Controller Status Register */
+#define LIIDR		(0x03C)	/* LCD Controller Interrupt ID Register */
+#define TMEDRGBR	(0x040)	/* TMED RGB Seed Register */
+#define TMEDCR		(0x044)	/* TMED Control Register */
+
+#define LCCR3_1BPP	(0 << 24)
+#define LCCR3_2BPP	(1 << 24)
+#define LCCR3_4BPP	(2 << 24)
+#define LCCR3_8BPP	(3 << 24)
+#define LCCR3_16BPP	(4 << 24)
+
+#define LCCR3_PDFOR_0	(0 << 30)
+#define LCCR3_PDFOR_1	(1 << 30)
+#define LCCR3_PDFOR_2	(2 << 30)
+#define LCCR3_PDFOR_3	(3 << 30)
+
+#define LCCR4_PAL_FOR_0	(0 << 15)
+#define LCCR4_PAL_FOR_1	(1 << 15)
+#define LCCR4_PAL_FOR_2	(2 << 15)
+#define LCCR4_PAL_FOR_MASK	(3 << 15)
+
+#define FDADR0		(0x200)	/* DMA Channel 0 Frame Descriptor Address Register */
+#define FSADR0		(0x204)	/* DMA Channel 0 Frame Source Address Register */
+#define FIDR0		(0x208)	/* DMA Channel 0 Frame ID Register */
+#define LDCMD0		(0x20C)	/* DMA Channel 0 Command Register */
+#define FDADR1		(0x210)	/* DMA Channel 1 Frame Descriptor Address Register */
+#define FSADR1		(0x214)	/* DMA Channel 1 Frame Source Address Register */
+#define FIDR1		(0x218)	/* DMA Channel 1 Frame ID Register */
+#define LDCMD1		(0x21C)	/* DMA Channel 1 Command Register */
+
+#define LCCR0_ENB	(1 << 0)	/* LCD Controller enable */
+#define LCCR0_CMS	(1 << 1)	/* Color/Monochrome Display Select */
+#define LCCR0_Color	(LCCR0_CMS*0)	/*  Color display */
+#define LCCR0_Mono	(LCCR0_CMS*1)	/*  Monochrome display */
+#define LCCR0_SDS	(1 << 2)	/* Single/Dual Panel Display Select */
+#define LCCR0_Sngl	(LCCR0_SDS*0)	/*  Single panel display */
+#define LCCR0_Dual	(LCCR0_SDS*1)	/*  Dual panel display */
+
+#define LCCR0_LDM	(1 << 3)	/* LCD Disable Done Mask */
+#define LCCR0_SFM	(1 << 4)	/* Start of frame mask */
+#define LCCR0_IUM	(1 << 5)	/* Input FIFO underrun mask */
+#define LCCR0_EFM	(1 << 6)	/* End of Frame mask */
+#define LCCR0_PAS	(1 << 7)	/* Passive/Active display Select */
+#define LCCR0_Pas	(LCCR0_PAS*0)	/*  Passive display (STN) */
+#define LCCR0_Act	(LCCR0_PAS*1)	/*  Active display (TFT) */
+#define LCCR0_DPD	(1 << 9)	/* Double Pixel Data (monochrome) */
+#define LCCR0_4PixMono	(LCCR0_DPD*0)	/*  4-Pixel/clock Monochrome display */
+#define LCCR0_8PixMono	(LCCR0_DPD*1)	/*  8-Pixel/clock Monochrome display */
+#define LCCR0_DIS	(1 << 10)	/* LCD Disable */
+#define LCCR0_QDM	(1 << 11)	/* LCD Quick Disable mask */
+#define LCCR0_PDD	(0xff << 12)	/* Palette DMA request delay */
+#define LCCR0_PDD_S	12
+#define LCCR0_BM	(1 << 20) 	/* Branch mask */
+#define LCCR0_OUM	(1 << 21)	/* Output FIFO underrun mask */
+#define LCCR0_LCDT	(1 << 22)	/* LCD panel type */
+#define LCCR0_RDSTM	(1 << 23)	/* Read status interrupt mask */
+#define LCCR0_CMDIM	(1 << 24)	/* Command interrupt mask */
+#define LCCR0_OUC	(1 << 25)	/* Overlay Underlay control bit */
+#define LCCR0_LDDALT	(1 << 26)	/* LDD alternate mapping control */
+
+#define LCCR1_PPL	Fld (10, 0)	/* Pixels Per Line - 1 */
+#define LCCR1_DisWdth(Pixel)	(((Pixel) - 1) << FShft (LCCR1_PPL))
+
+#define LCCR1_HSW	Fld (6, 10)	/* Horizontal Synchronization */
+#define LCCR1_HorSnchWdth(Tpix)	(((Tpix) - 1) << FShft (LCCR1_HSW))
+
+#define LCCR1_ELW	Fld (8, 16)	/* End-of-Line pixel clock Wait - 1 */
+#define LCCR1_EndLnDel(Tpix)	(((Tpix) - 1) << FShft (LCCR1_ELW))
+
+#define LCCR1_BLW	Fld (8, 24)	/* Beginning-of-Line pixel clock */
+#define LCCR1_BegLnDel(Tpix)	(((Tpix) - 1) << FShft (LCCR1_BLW))
+
+#define LCCR2_LPP	Fld (10, 0)	/* Line Per Panel - 1 */
+#define LCCR2_DisHght(Line)	(((Line) - 1) << FShft (LCCR2_LPP))
+
+#define LCCR2_VSW	Fld (6, 10)	/* Vertical Synchronization pulse - 1 */
+#define LCCR2_VrtSnchWdth(Tln)	(((Tln) - 1) << FShft (LCCR2_VSW))
+
+#define LCCR2_EFW	Fld (8, 16)	/* End-of-Frame line clock Wait */
+#define LCCR2_EndFrmDel(Tln)	((Tln) << FShft (LCCR2_EFW))
+
+#define LCCR2_BFW	Fld (8, 24)	/* Beginning-of-Frame line clock */
+#define LCCR2_BegFrmDel(Tln)	((Tln) << FShft (LCCR2_BFW))
+
+#define LCCR3_API	(0xf << 16)	/* AC Bias pin trasitions per interrupt */
+#define LCCR3_API_S	16
+#define LCCR3_VSP	(1 << 20)	/* vertical sync polarity */
+#define LCCR3_HSP	(1 << 21)	/* horizontal sync polarity */
+#define LCCR3_PCP	(1 << 22)	/* Pixel Clock Polarity (L_PCLK) */
+#define LCCR3_PixRsEdg	(LCCR3_PCP*0)	/*  Pixel clock Rising-Edge */
+#define LCCR3_PixFlEdg	(LCCR3_PCP*1)	/*  Pixel clock Falling-Edge */
+
+#define LCCR3_OEP	(1 << 23)	/* Output Enable Polarity */
+#define LCCR3_OutEnH	(LCCR3_OEP*0)	/*  Output Enable active High */
+#define LCCR3_OutEnL	(LCCR3_OEP*1)	/*  Output Enable active Low */
+
+#define LCCR3_DPC	(1 << 27)	/* double pixel clock mode */
+#define LCCR3_PCD	Fld (8, 0)	/* Pixel Clock Divisor */
+#define LCCR3_PixClkDiv(Div)	(((Div) << FShft (LCCR3_PCD)))
+
+#define LCCR3_BPP	Fld (3, 24)	/* Bit Per Pixel */
+#define LCCR3_Bpp(Bpp)	(((Bpp) << FShft (LCCR3_BPP)))
+
+#define LCCR3_ACB	Fld (8, 8)	/* AC Bias */
+#define LCCR3_Acb(Acb)	(((Acb) << FShft (LCCR3_ACB)))
+
+#define LCCR3_HorSnchH	(LCCR3_HSP*0)	/*  HSP Active High */
+#define LCCR3_HorSnchL	(LCCR3_HSP*1)	/*  HSP Active Low */
+
+#define LCCR3_VrtSnchH	(LCCR3_VSP*0)	/*  VSP Active High */
+#define LCCR3_VrtSnchL	(LCCR3_VSP*1)	/*  VSP Active Low */
+
+#define LCSR_LDD	(1 << 0)	/* LCD Disable Done */
+#define LCSR_SOF	(1 << 1)	/* Start of frame */
+#define LCSR_BER	(1 << 2)	/* Bus error */
+#define LCSR_ABC	(1 << 3)	/* AC Bias count */
+#define LCSR_IUL	(1 << 4)	/* input FIFO underrun Lower panel */
+#define LCSR_IUU	(1 << 5)	/* input FIFO underrun Upper panel */
+#define LCSR_OU		(1 << 6)	/* output FIFO underrun */
+#define LCSR_QD		(1 << 7)	/* quick disable */
+#define LCSR_EOF	(1 << 8)	/* end of frame */
+#define LCSR_BS		(1 << 9)	/* branch status */
+#define LCSR_SINT	(1 << 10)	/* subsequent interrupt */
+
+#define LDCMD_PAL	(1 << 26)	/* instructs DMA to load palette buffer */
+
+#endif /* __ASM_ARCH_REGS_LCD_H */
_

Patches currently in -mm which might be from eric.miao@marvell.com are

origin.patch
git-arm.patch
gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

