From: akpm@linux-foundation.org
Subject: + fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver.patch added to -mm tree
Date: Tue, 29 Jan 2008 17:46:04 -0800
Message-ID: <200801300145.m0U1jj9Y014957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbYA3Bq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 20:46:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, adaplas@pol.net, vince@simtec.co.uk


The patch titled
     FB/S3C2412: add S3C2412 support to S3C2410 fb driver
has been added to the -mm tree.  Its filename is
     fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: FB/S3C2412: add S3C2412 support to S3C2410 fb driver
From: Ben Dooks <ben-linux@fluff.org>

Add support for the S3C2412 to the S3C2410 frame buffer driver
by ensuring that any moved registers can be dealt with.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Vincent Sanders <vince@simtec.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c2410fb.c               |   78 +++++++++++++++++-----
 drivers/video/s3c2410fb.h               |    7 +
 include/asm-arm/arch-s3c2410/regs-lcd.h |   11 ++-
 3 files changed, 80 insertions(+), 16 deletions(-)

diff -puN drivers/video/s3c2410fb.c~fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver
+++ a/drivers/video/s3c2410fb.c
@@ -110,6 +110,11 @@ static int debug	= 0;
 
 /* useful functions */
 
+static int is_s3c2412(struct s3c2410fb_info *fbi)
+{
+	return (fbi->drv_type == DRV_S3C2412);
+}
+
 /* s3c2410fb_set_lcdaddr
  *
  * initialise lcd controller address pointers
@@ -501,7 +506,7 @@ static void schedule_palette_update(stru
 {
 	unsigned long flags;
 	unsigned long irqen;
-	void __iomem *regs = fbi->io;
+	void __iomem *irq_base = fbi->irq_base;
 
 	local_irq_save(flags);
 
@@ -511,9 +516,9 @@ static void schedule_palette_update(stru
 		fbi->palette_ready = 1;
 
 		/* enable IRQ */
-		irqen = readl(regs + S3C2410_LCDINTMSK);
+		irqen = readl(irq_base + S3C24XX_LCDINTMSK);
 		irqen &= ~S3C2410_LCDINT_FRSYNC;
-		writel(irqen, regs + S3C2410_LCDINTMSK);
+		writel(irqen, irq_base + S3C24XX_LCDINTMSK);
 	}
 
 	local_irq_restore(flags);
@@ -594,15 +599,17 @@ static int s3c2410fb_setcolreg(unsigned 
 static int s3c2410fb_blank(int blank_mode, struct fb_info *info)
 {
 	struct s3c2410fb_info *fbi = info->par;
-	void __iomem *regs = fbi->io;
+	void __iomem *tpal_reg = fbi->io;
 
 	dprintk("blank(mode=%d, info=%p)\n", blank_mode, info);
 
+	tpal_reg += is_s3c2412(fbi) ? S3C2412_TPAL : S3C2410_TPAL;
+
 	if (blank_mode == FB_BLANK_UNBLANK)
-		writel(0x0, regs + S3C2410_TPAL);
+		writel(0x0, tpal_reg);
 	else {
 		dprintk("setting TPAL to output 0x000000\n");
-		writel(S3C2410_TPAL_EN, regs + S3C2410_TPAL);
+		writel(S3C2410_TPAL_EN, tpal_reg);
 	}
 
 	return 0;
@@ -709,6 +716,16 @@ static int s3c2410fb_init_registers(stru
 	struct s3c2410fb_mach_info *mach_info = fbi->dev->platform_data;
 	unsigned long flags;
 	void __iomem *regs = fbi->io;
+	void __iomem *tpal;
+	void __iomem *lpcsel;
+
+	if (is_s3c2412(fbi)) {
+		tpal = regs + S3C2412_TPAL;
+		lpcsel = regs + S3C2412_TCONSEL;
+	} else {
+		tpal = regs + S3C2410_TPAL;
+		lpcsel = regs + S3C2410_LPCSEL;
+	}
 
 	/* Initialise LCD with values from haret */
 
@@ -724,12 +741,12 @@ static int s3c2410fb_init_registers(stru
 	local_irq_restore(flags);
 
 	dprintk("LPCSEL    = 0x%08lx\n", mach_info->lpcsel);
-	writel(mach_info->lpcsel, regs + S3C2410_LPCSEL);
+	writel(mach_info->lpcsel, lpcsel);
 
-	dprintk("replacing TPAL %08x\n", readl(regs + S3C2410_TPAL));
+	dprintk("replacing TPAL %08x\n", readl(tpal));
 
 	/* ensure temporary palette disabled */
-	writel(0x00, regs + S3C2410_TPAL);
+	writel(0x00, tpal);
 
 	return 0;
 }
@@ -763,15 +780,15 @@ static void s3c2410fb_write_palette(stru
 static irqreturn_t s3c2410fb_irq(int irq, void *dev_id)
 {
 	struct s3c2410fb_info *fbi = dev_id;
-	void __iomem *regs = fbi->io;
-	unsigned long lcdirq = readl(regs + S3C2410_LCDINTPND);
+	void __iomem *irq_base = fbi->irq_base;
+	unsigned long lcdirq = readl(irq_base + S3C24XX_LCDINTPND);
 
 	if (lcdirq & S3C2410_LCDINT_FRSYNC) {
 		if (fbi->palette_ready)
 			s3c2410fb_write_palette(fbi);
 
-		writel(S3C2410_LCDINT_FRSYNC, regs + S3C2410_LCDINTPND);
-		writel(S3C2410_LCDINT_FRSYNC, regs + S3C2410_LCDSRCPND);
+		writel(S3C2410_LCDINT_FRSYNC, irq_base + S3C24XX_LCDINTPND);
+		writel(S3C2410_LCDINT_FRSYNC, irq_base + S3C24XX_LCDSRCPND);
 	}
 
 	return IRQ_HANDLED;
@@ -779,7 +796,8 @@ static irqreturn_t s3c2410fb_irq(int irq
 
 static char driver_name[] = "s3c2410fb";
 
-static int __init s3c2410fb_probe(struct platform_device *pdev)
+static int __init s3c24xxfb_probe(struct platform_device *pdev,
+				  enum s3c_drv_type drv_type)
 {
 	struct s3c2410fb_info *info;
 	struct s3c2410fb_display *display;
@@ -815,6 +833,7 @@ static int __init s3c2410fb_probe(struct
 
 	info = fbinfo->par;
 	info->dev = &pdev->dev;
+	info->drv_type = drv_type;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
@@ -838,6 +857,8 @@ static int __init s3c2410fb_probe(struct
 		goto release_mem;
 	}
 
+	info->irq_base = info->io + ((drv_type == DRV_S3C2412) ? S3C2412_LCDINTBASE : S3C2410_LCDINTBASE);
+
 	dprintk("devinit\n");
 
 	strcpy(fbinfo->fix.id, driver_name);
@@ -946,6 +967,16 @@ dealloc_fb:
 	return ret;
 }
 
+static int __init s3c2410fb_probe(struct platform_device *pdev)
+{
+	return s3c24xxfb_probe(pdev, DRV_S3C2410);
+}
+
+static int __init s3c2412fb_probe(struct platform_device *pdev)
+{
+	return s3c24xxfb_probe(pdev, DRV_S3C2412);
+}
+
 /* s3c2410fb_stop_lcd
  *
  * shutdown the lcd controller
@@ -1047,14 +1078,31 @@ static struct platform_driver s3c2410fb_
 	},
 };
 
+static struct platform_driver s3c2412fb_driver = {
+	.probe		= s3c2412fb_probe,
+	.remove		= s3c2410fb_remove,
+	.suspend	= s3c2410fb_suspend,
+	.resume		= s3c2410fb_resume,
+	.driver		= {
+		.name	= "s3c2412-lcd",
+		.owner	= THIS_MODULE,
+	},
+};
+
 int __init s3c2410fb_init(void)
 {
-	return platform_driver_register(&s3c2410fb_driver);
+	int ret = platform_driver_register(&s3c2410fb_driver);
+
+	if (ret == 0)
+		ret = platform_driver_register(&s3c2412fb_driver);;
+
+	return ret;
 }
 
 static void __exit s3c2410fb_cleanup(void)
 {
 	platform_driver_unregister(&s3c2410fb_driver);
+	platform_driver_unregister(&s3c2412fb_driver);
 }
 
 module_init(s3c2410fb_init);
diff -puN drivers/video/s3c2410fb.h~fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver drivers/video/s3c2410fb.h
--- a/drivers/video/s3c2410fb.h~fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver
+++ a/drivers/video/s3c2410fb.h
@@ -25,13 +25,20 @@
 #ifndef __S3C2410FB_H
 #define __S3C2410FB_H
 
+enum s3c_drv_type {
+	DRV_S3C2410,
+	DRV_S3C2412,
+};
+
 struct s3c2410fb_info {
 	struct device		*dev;
 	struct clk		*clk;
 
 	struct resource		*mem;
 	void __iomem		*io;
+	void __iomem		*irq_base;
 
+	enum s3c_drv_type	drv_type;
 	struct s3c2410fb_hw	regs;
 
 	unsigned int		palette_ready;
diff -puN include/asm-arm/arch-s3c2410/regs-lcd.h~fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver include/asm-arm/arch-s3c2410/regs-lcd.h
--- a/include/asm-arm/arch-s3c2410/regs-lcd.h~fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver
+++ a/include/asm-arm/arch-s3c2410/regs-lcd.h
@@ -147,7 +147,16 @@
 
 #define S3C2412_FRCPAT(x)	S3C2410_LCDREG(0xB4 + ((x)*4))
 
-#endif /* ___ASM_ARCH_REGS_LCD_H */
+/* general registers */
+
+/* base of the LCD registers, where INTPND, INTSRC and then INTMSK
+ * are available. */
 
+#define S3C2410_LCDINTBASE	S3C2410_LCDREG(0x54)
+#define S3C2412_LCDINTBASE	S3C2410_LCDREG(0x24)
 
+#define S3C24XX_LCDINTPND	(0x00)
+#define S3C24XX_LCDSRCPND	(0x04)
+#define S3C24XX_LCDINTMSK	(0x08)
 
+#endif /* ___ASM_ARCH_REGS_LCD_H */
_

Patches currently in -mm which might be from ben-linux@fluff.org are

git-alsa.patch
git-arm.patch
git-mtd.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
fb-sm501-ensure-console-suspended-before-saving-state.patch
fb-s3c2412-add-s3c2412-support-to-s3c2410-fb-driver.patch
fb-s3c2410-update-debugging-in-s3c2410-framebuffer-driver.patch
fb-s3c2410-ensure-s3c2410-framebuffer-clears-initial-memory-to-black.patch
fb-s3c2410-check-default_display-parameter-passed-in-platform-data.patch
