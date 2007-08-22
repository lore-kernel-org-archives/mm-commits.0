From: akpm@linux-foundation.org
Subject: + spi-driver-runtime-footprint-shrinkage.patch added to -mm tree
Date: Wed, 22 Aug 2007 16:09:35 -0700
Message-ID: <200708222309.l7MN9ZsD009659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50110 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760356AbXHVXKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 19:10:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     SPI driver runtime footprint shrinkage
has been added to the -mm tree.  Its filename is
     spi-driver-runtime-footprint-shrinkage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI driver runtime footprint shrinkage
From: David Brownell <david-b@pacbell.net>

Shrink the runtime footprint of various SPI drivers:

  - Move the probe() routine into the init section where practical,
    using platform_driver_probe() to make that safe.  This often saves
    around 1KB.  Using platform_driver_probe() can also be a correctness
    fix, if the probe routine is already marked __init but the driver
    struct keeps a dangling pointer to it after init section removal.

  - Likewise move remove() routines into the exit sections.

These changes would be inappropriate iff the platform devices were
actually hotpluggable (e.g. they're found on optional addon cards,
or in an FPGA that's dynamically reprogrammed).  In these cases,
that's not the situation; it's an SOC controller and the only device
is initialized before these drivers.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap_uwire.c  |    9 ++++-----
 drivers/spi/pxa2xx_spi.c  |   11 ++++-------
 drivers/spi/spi_imx.c     |   11 +++++------
 drivers/spi/spi_mpc83xx.c |    7 +++----
 drivers/spi/spi_s3c24xx.c |    9 ++++-----
 5 files changed, 20 insertions(+), 27 deletions(-)

diff -puN drivers/spi/omap_uwire.c~spi-driver-runtime-footprint-shrinkage drivers/spi/omap_uwire.c
--- a/drivers/spi/omap_uwire.c~spi-driver-runtime-footprint-shrinkage
+++ a/drivers/spi/omap_uwire.c
@@ -481,7 +481,7 @@ static void uwire_off(struct uwire_spi *
 	spi_master_put(uwire->bitbang.master);
 }
 
-static int uwire_probe(struct platform_device *pdev)
+static int __init uwire_probe(struct platform_device *pdev)
 {
 	struct spi_master	*master;
 	struct uwire_spi	*uwire;
@@ -525,7 +525,7 @@ static int uwire_probe(struct platform_d
 	return status;
 }
 
-static int uwire_remove(struct platform_device *pdev)
+static int __exit uwire_remove(struct platform_device *pdev)
 {
 	struct uwire_spi	*uwire = dev_get_drvdata(&pdev->dev);
 	int			status;
@@ -543,8 +543,7 @@ static struct platform_driver uwire_driv
 		.bus		= &platform_bus_type,
 		.owner		= THIS_MODULE,
 	},
-	.probe		= uwire_probe,
-	.remove		= uwire_remove,
+	.remove		= __exit_p(uwire_remove),
 	// suspend ... unuse ck
 	// resume ... use ck
 };
@@ -566,7 +565,7 @@ static int __init omap_uwire_init(void)
 		omap_writel(val | 0x00AAA000, OMAP730_IO_CONF_9);
 	}
 
-	return platform_driver_register(&uwire_driver);
+	return platform_driver_probe(&uwire_driver, uwire_probe);
 }
 
 static void __exit omap_uwire_exit(void)
diff -puN drivers/spi/pxa2xx_spi.c~spi-driver-runtime-footprint-shrinkage drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-driver-runtime-footprint-shrinkage
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1229,7 +1229,7 @@ static void cleanup(struct spi_device *s
 	kfree(chip);
 }
 
-static int init_queue(struct driver_data *drv_data)
+static int __init init_queue(struct driver_data *drv_data)
 {
 	INIT_LIST_HEAD(&drv_data->queue);
 	spin_lock_init(&drv_data->lock);
@@ -1317,7 +1317,7 @@ static int destroy_queue(struct driver_d
 	return 0;
 }
 
-static int pxa2xx_spi_probe(struct platform_device *pdev)
+static int __init pxa2xx_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct pxa2xx_spi_master *platform_info;
@@ -1621,8 +1621,7 @@ static struct platform_driver driver = {
 		.bus = &platform_bus_type,
 		.owner = THIS_MODULE,
 	},
-	.probe = pxa2xx_spi_probe,
-	.remove = __devexit_p(pxa2xx_spi_remove),
+	.remove = pxa2xx_spi_remove,
 	.shutdown = pxa2xx_spi_shutdown,
 	.suspend = pxa2xx_spi_suspend,
 	.resume = pxa2xx_spi_resume,
@@ -1630,9 +1629,7 @@ static struct platform_driver driver = {
 
 static int __init pxa2xx_spi_init(void)
 {
-	platform_driver_register(&driver);
-
-	return 0;
+	return platform_driver_probe(&driver, pxa2xx_spi_probe);
 }
 module_init(pxa2xx_spi_init);
 
diff -puN drivers/spi/spi_imx.c~spi-driver-runtime-footprint-shrinkage drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-driver-runtime-footprint-shrinkage
+++ a/drivers/spi/spi_imx.c
@@ -1361,7 +1361,7 @@ static void cleanup(struct spi_device *s
 	kfree(spi_get_ctldata(spi));
 }
 
-static int init_queue(struct driver_data *drv_data)
+static int __init init_queue(struct driver_data *drv_data)
 {
 	INIT_LIST_HEAD(&drv_data->queue);
 	spin_lock_init(&drv_data->lock);
@@ -1444,7 +1444,7 @@ static int destroy_queue(struct driver_d
 	return 0;
 }
 
-static int spi_imx_probe(struct platform_device *pdev)
+static int __init spi_imx_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct spi_imx_master *platform_info;
@@ -1622,7 +1622,7 @@ err_no_mem:
 	return status;
 }
 
-static int __devexit spi_imx_remove(struct platform_device *pdev)
+static int __exit spi_imx_remove(struct platform_device *pdev)
 {
 	struct driver_data *drv_data = platform_get_drvdata(pdev);
 	int irq;
@@ -1739,8 +1739,7 @@ static struct platform_driver driver = {
 		.bus = &platform_bus_type,
 		.owner = THIS_MODULE,
 	},
-	.probe = spi_imx_probe,
-	.remove = __devexit_p(spi_imx_remove),
+	.remove = __exit_p(spi_imx_remove),
 	.shutdown = spi_imx_shutdown,
 	.suspend = spi_imx_suspend,
 	.resume = spi_imx_resume,
@@ -1748,7 +1747,7 @@ static struct platform_driver driver = {
 
 static int __init spi_imx_init(void)
 {
-	return platform_driver_register(&driver);
+	return platform_driver_probe(&driver, spi_imx_probe);
 }
 module_init(spi_imx_init);
 
diff -puN drivers/spi/spi_mpc83xx.c~spi-driver-runtime-footprint-shrinkage drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi-driver-runtime-footprint-shrinkage
+++ a/drivers/spi/spi_mpc83xx.c
@@ -514,7 +514,7 @@ err:
 	return ret;
 }
 
-static int __devexit mpc83xx_spi_remove(struct platform_device *dev)
+static int __exit mpc83xx_spi_remove(struct platform_device *dev)
 {
 	struct mpc83xx_spi *mpc83xx_spi;
 	struct spi_master *master;
@@ -532,8 +532,7 @@ static int __devexit mpc83xx_spi_remove(
 
 MODULE_ALIAS("mpc83xx_spi");			/* for platform bus hotplug */
 static struct platform_driver mpc83xx_spi_driver = {
-	.probe = mpc83xx_spi_probe,
-	.remove = __devexit_p(mpc83xx_spi_remove),
+	.remove = __exit_p(mpc83xx_spi_remove),
 	.driver = {
 		   .name = "mpc83xx_spi",
 	},
@@ -541,7 +540,7 @@ static struct platform_driver mpc83xx_sp
 
 static int __init mpc83xx_spi_init(void)
 {
-	return platform_driver_register(&mpc83xx_spi_driver);
+	return platform_driver_probe(&mpc83xx_spi_driver, mpc83xx_spi_probe);
 }
 
 static void __exit mpc83xx_spi_exit(void)
diff -puN drivers/spi/spi_s3c24xx.c~spi-driver-runtime-footprint-shrinkage drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-driver-runtime-footprint-shrinkage
+++ a/drivers/spi/spi_s3c24xx.c
@@ -233,7 +233,7 @@ static irqreturn_t s3c24xx_spi_irq(int i
 	return IRQ_HANDLED;
 }
 
-static int s3c24xx_spi_probe(struct platform_device *pdev)
+static int __init s3c24xx_spi_probe(struct platform_device *pdev)
 {
 	struct s3c24xx_spi *hw;
 	struct spi_master *master;
@@ -382,7 +382,7 @@ static int s3c24xx_spi_probe(struct plat
 	return err;
 }
 
-static int s3c24xx_spi_remove(struct platform_device *dev)
+static int __exit s3c24xx_spi_remove(struct platform_device *dev)
 {
 	struct s3c24xx_spi *hw = platform_get_drvdata(dev);
 
@@ -429,8 +429,7 @@ static int s3c24xx_spi_resume(struct pla
 
 MODULE_ALIAS("s3c2410_spi");			/* for platform bus hotplug */
 static struct platform_driver s3c24xx_spidrv = {
-	.probe		= s3c24xx_spi_probe,
-	.remove		= s3c24xx_spi_remove,
+	.remove		= __exit_p(s3c24xx_spi_remove),
 	.suspend	= s3c24xx_spi_suspend,
 	.resume		= s3c24xx_spi_resume,
 	.driver		= {
@@ -441,7 +440,7 @@ static struct platform_driver s3c24xx_sp
 
 static int __init s3c24xx_spi_init(void)
 {
-        return platform_driver_register(&s3c24xx_spidrv);
+        return platform_driver_probe(&s3c24xx_spidrv, s3c24xx_spi_probe);
 }
 
 static void __exit s3c24xx_spi_exit(void)
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
correct-name-for-rtc-m41t80.patch
rtc-max6902-minor-fixes.patch
spi-driver-hotplug-coldplug-fixes.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
git-mmc.patch
git-mtd.patch
ohci-fix-oddball-gcc-warning.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
spi-driver-runtime-footprint-shrinkage.patch
rtc-periodic-irq-fix.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
