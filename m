From: akpm@linux-foundation.org
Subject: + fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver-v4.patch added to -mm tree
Date: Tue, 13 Oct 2009 19:15:43 -0700
Message-ID: <200910140215.n9E2FhaW032368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760677AbZJNCR0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Oct 2009 22:17:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, cooloney@kernel.org, vapier@gentoo.org


The patch titled
     fbdev: bfin-lq035q1-fb: new Blackfin Landscape LCD EZ-Extender driver v4
has been added to the -mm tree.  Its filename is
     fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver-v4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: bfin-lq035q1-fb: new Blackfin Landscape LCD EZ-Extender driver v4
From: Michael Hennerich <michael.hennerich@analog.com>

Framebuffer driver for the Landscape LCD EZ-Extender (ADZS-BFLLCD-EZEXT)
http://docs.blackfin.uclinux.org/doku.php?id=hw:cards:landscape_lcd_ez-extender

	- fix Kconfig SPI depend pointed out by akpm
	- add module info to Kconfig help text

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig           |    6 
 drivers/video/bfin-lq035q1-fb.c |  247 +++++++++++++-----------------
 2 files changed, 113 insertions(+), 140 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver-v4 drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver-v4
+++ a/drivers/video/Kconfig
@@ -613,18 +613,20 @@ config FB_BFIN_T350MCQB
 
 config FB_BFIN_LQ035Q1
 	tristate "SHARP LQ035Q1DH02 TFT LCD"
-	depends on FB && BLACKFIN
+	depends on FB && BLACKFIN && SPI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select BFIN_GPTIMERS
-	select SPI
 	help
 	  This is the framebuffer device driver for a SHARP LQ035Q1DH02 TFT display found on
 	  the Blackfin Landscape LCD EZ-Extender Card.
 	  This display is a QVGA 320x240 18-bit RGB display interfaced by an 16-bit wide PPI
 	  It uses PPI[0..15] PPI_FS1, PPI_FS2 and PPI_CLK.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called bfin-lq035q1-fb.
+
 config FB_STI
 	tristate "HP STI frame buffer device support"
 	depends on FB && PARISC
diff -puN drivers/video/bfin-lq035q1-fb.c~fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver-v4 drivers/video/bfin-lq035q1-fb.c
--- a/drivers/video/bfin-lq035q1-fb.c~fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver-v4
+++ a/drivers/video/bfin-lq035q1-fb.c
@@ -5,6 +5,7 @@
  * Licensed under the GPL-2 or later.
  */
 
+#define DRIVER_NAME "bfin-lq035q1"
 #define pr_fmt(fmt) DRIVER_NAME ": " fmt
 
 #include <linux/module.h>
@@ -127,16 +128,13 @@
 #define LQ035_SHUT			(1 << 0)	/* Shutdown */
 #define LQ035_ON			(0 << 0)	/* Shutdown */
 
-#define DRIVER_NAME "bfin-lq035q1"
-static char driver_name[] = DRIVER_NAME;
-
 struct bfin_lq035q1fb_info {
 	struct fb_info *fb;
 	struct device *dev;
+	struct spi_driver spidrv;
 	struct bfin_lq035q1fb_disp_info *disp_info;
 	unsigned char *fb_buffer;	/* RGB Buffer */
 	dma_addr_t dma_handle;
-	int lq035_mmap;
 	int lq035_open_cnt;
 	int irq;
 	spinlock_t lock;	/* lock */
@@ -147,91 +145,87 @@ static int nocursor;
 module_param(nocursor, int, 0644);
 MODULE_PARM_DESC(nocursor, "cursor enable/disable");
 
-
-static struct {
-	struct spi_device *spidev;
+struct spi_control {
 	unsigned short mode;
-	unsigned short init;
-} spi_control;
+};
 
-static int lq035q1_control(unsigned char reg, unsigned short value)
+static int lq035q1_control(struct spi_device *spi, unsigned char reg, unsigned short value)
 {
 	int ret;
-	u8 regs[3] = {LQ035_INDEX, 0, 0};
-	u8 dat[3] = {LQ035_DATA, 0, 0};
+	u8 regs[3] = { LQ035_INDEX, 0, 0 };
+	u8 dat[3] = { LQ035_DATA, 0, 0 };
 
-	if (spi_control.spidev) {
-		regs[2] = reg;
-		dat[1] = value >> 8;
-		dat[2] = value & 0xFF;
-
-		ret = spi_write(spi_control.spidev, regs, ARRAY_SIZE(regs));
-		ret |= spi_write(spi_control.spidev, dat, ARRAY_SIZE(dat));
-	} else
+	if (!spi)
 		return -ENODEV;
 
+	regs[2] = reg;
+	dat[1] = value >> 8;
+	dat[2] = value & 0xFF;
+
+	ret = spi_write(spi, regs, ARRAY_SIZE(regs));
+	ret |= spi_write(spi, dat, ARRAY_SIZE(dat));
 	return ret;
 }
 
 static int __devinit lq035q1_spidev_probe(struct spi_device *spi)
 {
 	int ret;
-	spi_control.spidev = spi;
+	struct spi_control *ctl;
+	struct bfin_lq035q1fb_info *info = container_of(spi->dev.driver,
+						struct bfin_lq035q1fb_info,
+						spidrv.driver);
 
-	ret = lq035q1_control(LQ035_SHUT_CTL, LQ035_ON);
-	ret |= lq035q1_control(LQ035_DRIVER_OUTPUT_CTL, spi_control.mode);
+	ctl = kzalloc(sizeof(*ctl), GFP_KERNEL);
 
+	if (!ctl)
+		return -ENOMEM;
+
+	ctl->mode = (info->disp_info->mode &
+		LQ035_DRIVER_OUTPUT_MASK) | LQ035_DRIVER_OUTPUT_DEFAULT;
+
+	ret = lq035q1_control(spi, LQ035_SHUT_CTL, LQ035_ON);
+	ret |= lq035q1_control(spi, LQ035_DRIVER_OUTPUT_CTL, ctl->mode);
 	if (ret)
 		return ret;
 
-	spi_control.init = 1;
+	spi_set_drvdata(spi, ctl);
 
 	return 0;
 }
 
-static int __devexit lq035q1_spidev_remove(struct spi_device *spi)
+static int lq035q1_spidev_remove(struct spi_device *spi)
 {
-	return lq035q1_control(LQ035_SHUT_CTL, LQ035_SHUT);
+	return lq035q1_control(spi, LQ035_SHUT_CTL, LQ035_SHUT);
 }
 
 #ifdef CONFIG_PM
 static int lq035q1_spidev_suspend(struct spi_device *spi, pm_message_t state)
 {
-	return lq035q1_control(LQ035_SHUT_CTL, LQ035_SHUT);
+	return lq035q1_control(spi, LQ035_SHUT_CTL, LQ035_SHUT);
 }
 
 static int lq035q1_spidev_resume(struct spi_device *spi)
 {
-	int ret = lq035q1_control(LQ035_DRIVER_OUTPUT_CTL, spi_control.mode);
+	int ret;
+	struct spi_control *ctl = spi_get_drvdata(spi);
 
+	ret = lq035q1_control(spi, LQ035_DRIVER_OUTPUT_CTL, ctl->mode);
 	if (ret)
 		return ret;
 
-	return lq035q1_control(LQ035_SHUT_CTL, LQ035_ON);
+	return lq035q1_control(spi, LQ035_SHUT_CTL, LQ035_ON);
 }
 #else
-#define lq035q1_spidev_suspend		NULL
-#define lq035q1_spidev_resume		NULL
+# define lq035q1_spidev_suspend NULL
+# define lq035q1_spidev_resume  NULL
 #endif
 
 /* Power down all displays on reboot, poweroff or halt */
 static void lq035q1_spidev_shutdown(struct spi_device *spi)
 {
-	lq035q1_control(LQ035_SHUT_CTL, LQ035_SHUT);
+	lq035q1_control(spi, LQ035_SHUT_CTL, LQ035_SHUT);
 }
 
-static struct spi_driver spidev_spi_driver = {
-	.driver = {
-		.name =		DRIVER_NAME"-spi",
-		.owner =	THIS_MODULE,
-	},
-	.probe =	lq035q1_spidev_probe,
-	.remove =	__devexit_p(lq035q1_spidev_remove),
-	.shutdown	= lq035q1_spidev_shutdown,
-	.suspend	= lq035q1_spidev_suspend,
-	.resume		= lq035q1_spidev_resume,
-};
-
 static int lq035q1_backlight(struct bfin_lq035q1fb_info *info, unsigned arg)
 {
 	if (info->disp_info->use_bl)
@@ -329,27 +323,28 @@ static const u16 ppi0_req_16[] = {P_PPI0
 			    P_PPI0_D6, P_PPI0_D7, 0};
 #endif
 
-static int bfin_lq035q1_request_ports(int action)
+static inline void bfin_lq035q1_free_ports(void)
 {
-	if (action) {
-		/* ANOMALY_05000400 - PPI Does Not Start Properly In Specific Mode:
-		 * Drive PPI_FS3 Low
-		 */
-		if (ANOMALY_05000400) {
-			int ret = gpio_request(P_IDENT(P_PPI0_FS3), "PPI_FS3");
-			if (ret)
-				return ret;
-			gpio_direction_output(P_IDENT(P_PPI0_FS3), 0);
-		}
+	peripheral_free_list(ppi0_req_16);
+	if (ANOMALY_05000400)
+		gpio_free(P_IDENT(P_PPI0_FS3));
+}
 
-		if (peripheral_request_list(ppi0_req_16, DRIVER_NAME)) {
-			pr_err("requesting peripherals failed\n");
-			return -EFAULT;
-		}
-	} else {
-		peripheral_free_list(ppi0_req_16);
-		if (ANOMALY_05000400)
-			gpio_free(P_IDENT(P_PPI0_FS3));
+static int __devinit bfin_lq035q1_request_ports(struct platform_device *pdev)
+{
+	/* ANOMALY_05000400 - PPI Does Not Start Properly In Specific Mode:
+	 * Drive PPI_FS3 Low
+	 */
+	if (ANOMALY_05000400) {
+		int ret = gpio_request(P_IDENT(P_PPI0_FS3), "PPI_FS3");
+		if (ret)
+			return ret;
+		gpio_direction_output(P_IDENT(P_PPI0_FS3), 0);
+	}
+
+	if (peripheral_request_list(ppi0_req_16, DRIVER_NAME)) {
+		dev_err(&pdev->dev, "requesting peripherals failed\n");
+		return -EFAULT;
 	}
 
 	return 0;
@@ -390,7 +385,6 @@ static int bfin_lq035q1_fb_release(struc
 	spin_lock(&fbi->lock);
 
 	fbi->lq035_open_cnt--;
-	fbi->lq035_mmap = 0;
 
 	if (fbi->lq035_open_cnt <= 0) {
 		lq035q1_backlight(fbi, 0);
@@ -406,9 +400,8 @@ static int bfin_lq035q1_fb_release(struc
 }
 
 static int bfin_lq035q1_fb_check_var(struct fb_var_screeninfo *var,
-				   struct fb_info *info)
+				     struct fb_info *info)
 {
-
 	switch (var->bits_per_pixel) {
 #if (LCD_BPP == 24)
 	case 24:/* TRUECOLOUR, 16m */
@@ -456,32 +449,6 @@ static int bfin_lq035q1_fb_check_var(str
 	return 0;
 }
 
-static int bfin_lq035q1_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
-{
-	struct bfin_lq035q1fb_info *fbi = info->par;
-
-	if (fbi->lq035_mmap)
-		return -1;
-
-	spin_lock(&fbi->lock);
-	fbi->lq035_mmap = 1;
-	spin_unlock(&fbi->lock);
-
-	vma->vm_start = (unsigned long)(fbi->fb_buffer + ACTIVE_VIDEO_MEM_OFFSET);
-
-	vma->vm_end = vma->vm_start + info->fix.smem_len;
-	/* For those who don't understand how mmap works, go read
-	 *   Documentation/nommu-mmap.txt.
-	 * For those that do, you will know that the VM_MAYSHARE flag
-	 * must be set in the vma->vm_flags structure on noMMU
-	 *   Other flags can be set, and are documented in
-	 *   include/linux/mm.h
-	 */
-	vma->vm_flags |= VM_MAYSHARE | VM_SHARED;
-
-	return 0;
-}
-
 int bfin_lq035q1_fb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
 	if (nocursor)
@@ -533,7 +500,6 @@ static struct fb_ops bfin_lq035q1_fb_ops
 	.fb_fillrect = cfb_fillrect,
 	.fb_copyarea = cfb_copyarea,
 	.fb_imageblit = cfb_imageblit,
-	.fb_mmap = bfin_lq035q1_fb_mmap,
 	.fb_cursor = bfin_lq035q1_fb_cursor,
 	.fb_setcolreg = bfin_lq035q1_fb_setcolreg,
 };
@@ -564,14 +530,13 @@ static int __devinit bfin_lq035q1_probe(
 	struct fb_info *fbinfo;
 	int ret;
 
-	ret = request_dma(CH_PPI, "CH_PPI");
+	ret = request_dma(CH_PPI, DRIVER_NAME"_CH_PPI");
 	if (ret < 0) {
-		pr_err("couldn't request CH_PPI DMA\n");
+		dev_err(&pdev->dev, "PPI DMA unavailable\n");
 		goto out1;
 	}
 
-	fbinfo =
-	    framebuffer_alloc(sizeof(struct bfin_lq035q1fb_info), &pdev->dev);
+	fbinfo = framebuffer_alloc(sizeof(*info), &pdev->dev);
 	if (!fbinfo) {
 		ret = -ENOMEM;
 		goto out2;
@@ -583,12 +548,9 @@ static int __devinit bfin_lq035q1_probe(
 
 	info->disp_info = pdev->dev.platform_data;
 
-	spi_control.mode = (info->disp_info->mode &
-		LQ035_DRIVER_OUTPUT_MASK) | LQ035_DRIVER_OUTPUT_DEFAULT;
-
 	platform_set_drvdata(pdev, fbinfo);
 
-	strcpy(fbinfo->fix.id, driver_name);
+	strcpy(fbinfo->fix.id, DRIVER_NAME);
 
 	fbinfo->fix.type = FB_TYPE_PACKED_PIXELS;
 	fbinfo->fix.type_aux = 0;
@@ -662,7 +624,7 @@ static int __devinit bfin_lq035q1_probe(
 			       GFP_KERNEL);
 
 	if (NULL == info->fb_buffer) {
-		pr_err("couldn't allocate dma buffer\n");
+		dev_err(&pdev->dev, "couldn't allocate dma buffer\n");
 		ret = -ENOMEM;
 		goto out3;
 	}
@@ -676,14 +638,14 @@ static int __devinit bfin_lq035q1_probe(
 
 	ret = fb_alloc_cmap(&fbinfo->cmap, BFIN_LCD_NBR_PALETTE_ENTRIES, 0);
 	if (ret < 0) {
-		pr_err("failed to allocate colormap (%d entries)\n",
+		dev_err(&pdev->dev, "failed to allocate colormap (%d entries)\n",
 		       BFIN_LCD_NBR_PALETTE_ENTRIES);
 		goto out4;
 	}
 
-	ret = bfin_lq035q1_request_ports(1);
+	ret = bfin_lq035q1_request_ports(pdev);
 	if (ret) {
-		pr_err("couldn't request gpio port\n");
+		dev_err(&pdev->dev, "couldn't request gpio port\n");
 		goto out6;
 	}
 
@@ -694,15 +656,22 @@ static int __devinit bfin_lq035q1_probe(
 	}
 
 	ret = request_irq(info->irq, bfin_lq035q1_irq_error, IRQF_DISABLED,
-			"PPI ERROR", info);
+			DRIVER_NAME" PPI ERROR", info);
 	if (ret < 0) {
-		pr_err("unable to request PPI ERROR IRQ\n");
+		dev_err(&pdev->dev, "unable to request PPI ERROR IRQ\n");
 		goto out7;
 	}
 
-	ret = spi_register_driver(&spidev_spi_driver);
+	info->spidrv.driver.name = DRIVER_NAME"-spi";
+	info->spidrv.probe    = lq035q1_spidev_probe;
+	info->spidrv.remove   = __devexit_p(lq035q1_spidev_remove);
+	info->spidrv.shutdown = lq035q1_spidev_shutdown;
+	info->spidrv.suspend  = lq035q1_spidev_suspend;
+	info->spidrv.resume   = lq035q1_spidev_resume;
+
+	ret = spi_register_driver(&info->spidrv);
 	if (ret < 0) {
-		pr_err("couldn't register SPI Interface\n");
+		dev_err(&pdev->dev, "couldn't register SPI Interface\n");
 		goto out8;
 	}
 
@@ -710,7 +679,7 @@ static int __devinit bfin_lq035q1_probe(
 		ret = gpio_request(info->disp_info->gpio_bl, "LQ035 Backlight");
 
 		if (ret) {
-			pr_err("failed to request GPIO %d\n",
+			dev_err(&pdev->dev, "failed to request GPIO %d\n",
 				info->disp_info->gpio_bl);
 			goto out9;
 		}
@@ -719,34 +688,34 @@ static int __devinit bfin_lq035q1_probe(
 
 	ret = register_framebuffer(fbinfo);
 	if (ret < 0) {
-		pr_err("unable to register framebuffer\n");
+		dev_err(&pdev->dev, "unable to register framebuffer\n");
 		goto out10;
 	}
 
-	pr_info("%dx%d %d-bit RGB FrameBuffer initialized\n",
+	dev_info(&pdev->dev, "%dx%d %d-bit RGB FrameBuffer initialized\n",
 		LCD_X_RES, LCD_Y_RES, LCD_BPP);
 
 	return 0;
 
-out10:
+ out10:
 	if (info->disp_info->use_bl)
 		gpio_free(info->disp_info->gpio_bl);
-out9:
-	spi_unregister_driver(&spidev_spi_driver);
-out8:
+ out9:
+	spi_unregister_driver(&info->spidrv);
+ out8:
 	free_irq(info->irq, info);
-out7:
-	bfin_lq035q1_request_ports(0);
-out6:
+ out7:
+	bfin_lq035q1_free_ports();
+ out6:
 	fb_dealloc_cmap(&fbinfo->cmap);
-out4:
+ out4:
 	dma_free_coherent(NULL, fbinfo->fix.smem_len, info->fb_buffer,
 			  info->dma_handle);
-out3:
+ out3:
 	framebuffer_release(fbinfo);
-out2:
+ out2:
 	free_dma(CH_PPI);
-out1:
+ out1:
 	platform_set_drvdata(pdev, NULL);
 
 	return ret;
@@ -760,7 +729,7 @@ static int __devexit bfin_lq035q1_remove
 	if (info->disp_info->use_bl)
 		gpio_free(info->disp_info->gpio_bl);
 
-	spi_unregister_driver(&spidev_spi_driver);
+	spi_unregister_driver(&info->spidrv);
 
 	unregister_framebuffer(fbinfo);
 
@@ -773,20 +742,20 @@ static int __devexit bfin_lq035q1_remove
 
 	fb_dealloc_cmap(&fbinfo->cmap);
 
-	bfin_lq035q1_request_ports(0);
+	bfin_lq035q1_free_ports();
 
 	platform_set_drvdata(pdev, NULL);
 	framebuffer_release(fbinfo);
 
-	pr_info("unregistered LCD driver\n");
+	dev_info(&pdev->dev, "unregistered LCD driver\n");
 
 	return 0;
 }
 
 #ifdef CONFIG_PM
-static int bfin_lq035q1_suspend(struct platform_device *pdev, pm_message_t state)
+static int bfin_lq035q1_suspend(struct device *dev)
 {
-	struct fb_info *fbinfo = platform_get_drvdata(pdev);
+	struct fb_info *fbinfo = dev_get_drvdata(dev);
 	struct bfin_lq035q1fb_info *info = fbinfo->par;
 
 	if (info->lq035_open_cnt) {
@@ -801,9 +770,9 @@ static int bfin_lq035q1_suspend(struct p
 	return 0;
 }
 
-static int bfin_lq035q1_resume(struct platform_device *pdev)
+static int bfin_lq035q1_resume(struct device *dev)
 {
-	struct fb_info *fbinfo = platform_get_drvdata(pdev);
+	struct fb_info *fbinfo = dev_get_drvdata(dev);
 	struct bfin_lq035q1fb_info *info = fbinfo->par;
 
 	if (info->lq035_open_cnt) {
@@ -823,19 +792,21 @@ static int bfin_lq035q1_resume(struct pl
 
 	return 0;
 }
-#else
-#define bfin_lq035q1_suspend	NULL
-#define bfin_lq035q1_resume	NULL
+
+static struct dev_pm_ops bfin_lq035q1_dev_pm_ops = {
+	.suspend = bfin_lq035q1_suspend,
+	.resume  = bfin_lq035q1_resume,
+};
 #endif
 
 static struct platform_driver bfin_lq035q1_driver = {
-	.probe = bfin_lq035q1_probe,
-	.remove = __devexit_p(bfin_lq035q1_remove),
-	.suspend = bfin_lq035q1_suspend,
-	.resume = bfin_lq035q1_resume,
+	.probe   = bfin_lq035q1_probe,
+	.remove  = __devexit_p(bfin_lq035q1_remove),
 	.driver = {
 		.name = DRIVER_NAME,
-		.owner = THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm   = &bfin_lq035q1_dev_pm_ops,
+#endif
 	},
 };
 
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
ad525x_dpot-new-driver-for-ad525x-digital-potentiometers.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver.patch
fbdev-bfin-lq035q1-fb-new-blackfin-landscape-lcd-ez-extender-driver-v4.patch
fbdev-bfin-t350mcqb-fb-handle-all-resources-in-suspend-resume.patch
fbdev-bfin-t350mcqb-fb-fix-lcd-dimensions.patch

