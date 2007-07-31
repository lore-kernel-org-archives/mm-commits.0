From: akpm@linux-foundation.org
Subject: - s3c2410fb-fix-s3c2410-compilation.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:02 -0700
Message-ID: <200707312355.l6VNt24b029200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764251AbXHAARw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, adaplas@gmail.com, arnaud.patard@rtp-net.org, mm-commits@vger.kernel.org


The patch titled
     s3c2410fb: fix s3c2410 compilation
has been removed from the -mm tree.  Its filename was
     s3c2410fb-fix-s3c2410-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s3c2410fb: fix s3c2410 compilation
From: Ben Dooks <ben-linux@fluff.org>

The implicit mapping has been removed from the arch
as this should be handled in the driver, this patch
fixes the s3c2410_fb driver to ioremap() the necessary
registers.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Acked-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c |   88 +++++++++++++++++++++++-------------
 drivers/video/s3c2410fb.h |    3 +
 2 files changed, 60 insertions(+), 31 deletions(-)

diff -puN drivers/video/s3c2410fb.c~s3c2410fb-fix-s3c2410-compilation drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~s3c2410fb-fix-s3c2410-compilation
+++ a/drivers/video/s3c2410fb.c
@@ -474,6 +474,7 @@ static void schedule_palette_update(stru
 {
 	unsigned long flags;
 	unsigned long irqen;
+	void __iomem *regs = fbi->io;
 
 	local_irq_save(flags);
 
@@ -483,9 +484,9 @@ static void schedule_palette_update(stru
 		fbi->palette_ready = 1;
 
 		/* enable IRQ */
-		irqen = readl(S3C2410_LCDINTMSK);
+		irqen = readl(regs + S3C2410_LCDINTMSK);
 		irqen &= ~S3C2410_LCDINT_FRSYNC;
-		writel(irqen, S3C2410_LCDINTMSK);
+		writel(irqen, regs + S3C2410_LCDINTMSK);
 	}
 
 	local_irq_restore(flags);
@@ -680,6 +681,7 @@ static inline void modify_gpio(void __io
 static int s3c2410fb_init_registers(struct s3c2410fb_info *fbi)
 {
 	unsigned long flags;
+	void __iomem *regs = fbi->io;
 
 	/* Initialise LCD with values from haret */
 
@@ -694,25 +696,25 @@ static int s3c2410fb_init_registers(stru
 
 	local_irq_restore(flags);
 
-	writel(fbi->regs.lcdcon1, S3C2410_LCDCON1);
-	writel(fbi->regs.lcdcon2, S3C2410_LCDCON2);
-	writel(fbi->regs.lcdcon3, S3C2410_LCDCON3);
-	writel(fbi->regs.lcdcon4, S3C2410_LCDCON4);
-	writel(fbi->regs.lcdcon5, S3C2410_LCDCON5);
+	writel(fbi->regs.lcdcon1, regs + S3C2410_LCDCON1);
+	writel(fbi->regs.lcdcon2, regs + S3C2410_LCDCON2);
+	writel(fbi->regs.lcdcon3, regs + S3C2410_LCDCON3);
+	writel(fbi->regs.lcdcon4, regs + S3C2410_LCDCON4);
+	writel(fbi->regs.lcdcon5, regs + S3C2410_LCDCON5);
 
  	s3c2410fb_set_lcdaddr(fbi);
 
 	dprintk("LPCSEL    = 0x%08lx\n", mach_info->lpcsel);
-	writel(mach_info->lpcsel, S3C2410_LPCSEL);
+	writel(mach_info->lpcsel, regs + S3C2410_LPCSEL);
 
-	dprintk("replacing TPAL %08x\n", readl(S3C2410_TPAL));
+	dprintk("replacing TPAL %08x\n", readl(regs + S3C2410_TPAL));
 
 	/* ensure temporary palette disabled */
-	writel(0x00, S3C2410_TPAL);
+	writel(0x00, regs + S3C2410_TPAL);
 
 	/* Enable video by setting the ENVID bit to 1 */
 	fbi->regs.lcdcon1 |= S3C2410_LCDCON1_ENVID;
-	writel(fbi->regs.lcdcon1, S3C2410_LCDCON1);
+	writel(fbi->regs.lcdcon1, regs + S3C2410_LCDCON1);
 	return 0;
 }
 
@@ -720,6 +722,7 @@ static void s3c2410fb_write_palette(stru
 {
 	unsigned int i;
 	unsigned long ent;
+	void __iomem *regs = fbi->io;
 
 	fbi->palette_ready = 0;
 
@@ -727,14 +730,14 @@ static void s3c2410fb_write_palette(stru
 		if ((ent = fbi->palette_buffer[i]) == PALETTE_BUFF_CLEAR)
 			continue;
 
-		writel(ent, S3C2410_TFTPAL(i));
+		writel(ent, regs + S3C2410_TFTPAL(i));
 
 		/* it seems the only way to know exactly
 		 * if the palette wrote ok, is to check
 		 * to see if the value verifies ok
 		 */
 
-		if (readw(S3C2410_TFTPAL(i)) == ent)
+		if (readw(regs + S3C2410_TFTPAL(i)) == ent)
 			fbi->palette_buffer[i] = PALETTE_BUFF_CLEAR;
 		else
 			fbi->palette_ready = 1;   /* retry */
@@ -744,14 +747,15 @@ static void s3c2410fb_write_palette(stru
 static irqreturn_t s3c2410fb_irq(int irq, void *dev_id)
 {
 	struct s3c2410fb_info *fbi = dev_id;
-	unsigned long lcdirq = readl(S3C2410_LCDINTPND);
+	void __iomem *regs = fbi->io;
+	unsigned long lcdirq = readl(regs + S3C2410_LCDINTPND);
 
 	if (lcdirq & S3C2410_LCDINT_FRSYNC) {
 		if (fbi->palette_ready)
 			s3c2410fb_write_palette(fbi);
 
-		writel(S3C2410_LCDINT_FRSYNC, S3C2410_LCDINTPND);
-		writel(S3C2410_LCDINT_FRSYNC, S3C2410_LCDSRCPND);
+		writel(S3C2410_LCDINT_FRSYNC, regs + S3C2410_LCDINTPND);
+		writel(S3C2410_LCDINT_FRSYNC, regs + S3C2410_LCDSRCPND);
 	}
 
 	return IRQ_HANDLED;
@@ -764,9 +768,11 @@ static int __init s3c2410fb_probe(struct
 	struct s3c2410fb_info *info;
 	struct fb_info	   *fbinfo;
 	struct s3c2410fb_hw *mregs;
+	struct resource *res;
 	int ret;
 	int irq;
 	int i;
+	int size;
 	u32 lcdcon1;
 
 	mach_info = pdev->dev.platform_data;
@@ -788,11 +794,32 @@ static int __init s3c2410fb_probe(struct
 		return -ENOMEM;
 	}
 
-
 	info = fbinfo->par;
 	info->fb = fbinfo;
 	info->dev = &pdev->dev;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get memory registersn");
+		ret = -ENXIO;
+		goto dealloc_fb;
+	}
+
+	size = (res->end - res->start)+1;
+	info->mem = request_mem_region(res->start, size, pdev->name);
+	if (info->mem == NULL) {
+		dev_err(&pdev->dev, "failed to get memory region\n");
+		ret = -ENOENT;
+		goto dealloc_fb;
+	}
+
+	info->io = ioremap(res->start, size);
+	if (info->io == NULL) {
+		dev_err(&pdev->dev, "ioremap() of registers failed\n");
+		ret = -ENXIO;
+		goto release_mem;
+	}
+
 	platform_set_drvdata(pdev, fbinfo);
 
 	dprintk("devinit\n");
@@ -803,8 +830,8 @@ static int __init s3c2410fb_probe(struct
 
 	/* Stop the video and unset ENVID if set */
 	info->regs.lcdcon1 &= ~S3C2410_LCDCON1_ENVID;
-	lcdcon1 = readl(S3C2410_LCDCON1);
-	writel(lcdcon1 & ~S3C2410_LCDCON1_ENVID, S3C2410_LCDCON1);
+	lcdcon1 = readl(info->io + S3C2410_LCDCON1);
+	writel(lcdcon1 & ~S3C2410_LCDCON1_ENVID, info->io + S3C2410_LCDCON1);
 
 	info->mach_info		    = pdev->dev.platform_data;
 
@@ -855,19 +882,11 @@ static int __init s3c2410fb_probe(struct
 	for (i = 0; i < 256; i++)
 		info->palette_buffer[i] = PALETTE_BUFF_CLEAR;
 
-	if (!request_mem_region((unsigned long)S3C24XX_VA_LCD, SZ_1M, "s3c2410-lcd")) {
-		ret = -EBUSY;
-		goto dealloc_fb;
-	}
-
-
-	dprintk("got LCD region\n");
-
 	ret = request_irq(irq, s3c2410fb_irq, IRQF_DISABLED, pdev->name, info);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot get irq %d - err %d\n", irq, ret);
 		ret = -EBUSY;
-		goto release_mem;
+		goto release_regs;
 	}
 
 	info->clk = clk_get(NULL, "lcd");
@@ -889,6 +908,7 @@ static int __init s3c2410fb_probe(struct
 		ret = -ENOMEM;
 		goto release_clock;
 	}
+
 	dprintk("got video memory\n");
 
 	ret = s3c2410fb_init_registers(info);
@@ -916,8 +936,11 @@ release_clock:
 	clk_put(info->clk);
 release_irq:
 	free_irq(irq,info);
+release_regs:
+	iounmap(info->io);
 release_mem:
- 	release_mem_region((unsigned long)S3C24XX_VA_LCD, S3C24XX_SZ_LCD);
+	release_resource(info->mem);
+	kfree(info->mem);
 dealloc_fb:
 	framebuffer_release(fbinfo);
 	return ret;
@@ -935,7 +958,7 @@ static void s3c2410fb_stop_lcd(struct s3
 	local_irq_save(flags);
 
 	fbi->regs.lcdcon1 &= ~S3C2410_LCDCON1_ENVID;
-	writel(fbi->regs.lcdcon1, S3C2410_LCDCON1);
+	writel(fbi->regs.lcdcon1, fbi->io + S3C2410_LCDCON1);
 
 	local_irq_restore(flags);
 }
@@ -962,7 +985,10 @@ static int s3c2410fb_remove(struct platf
 
 	irq = platform_get_irq(pdev, 0);
 	free_irq(irq,info);
-	release_mem_region((unsigned long)S3C24XX_VA_LCD, S3C24XX_SZ_LCD);
+
+	release_resource(info->mem);
+	kfree(info->mem);
+	iounmap(info->io);
 	unregister_framebuffer(fbinfo);
 
 	return 0;
diff -puN drivers/video/s3c2410fb.h~s3c2410fb-fix-s3c2410-compilation drivers/video/s3c2410fb.h
--- a/drivers/video/s3c2410fb.h~s3c2410fb-fix-s3c2410-compilation
+++ a/drivers/video/s3c2410fb.h
@@ -30,6 +30,9 @@ struct s3c2410fb_info {
 	struct device		*dev;
 	struct clk		*clk;
 
+	struct resource		*mem;
+	void __iomem		*io;
+
 	struct s3c2410fb_mach_info *mach_info;
 
 	/* raw memory addresses */
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
git-mtd.patch
git-watchdog.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
