From: akpm@linux-foundation.org
Subject: - spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:46 -0800
Message-ID: <200901072217.n07MHkdP017333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762115AbZAGWTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:19:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: use generic gpio calls in spi_s3c24xx_gpio
has been removed from the -mm tree.  Its filename was
     spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: use generic gpio calls in spi_s3c24xx_gpio
From: Ben Dooks <ben-linux@fluff.org>

Change the spi_s3c2410 driver to use the generic gpio calls that are now
available.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2410/include/mach/spi.h |    2 -
 drivers/spi/spi_s3c24xx.c                |   38 ++++++++++++++++-----
 2 files changed, 30 insertions(+), 10 deletions(-)

diff -puN arch/arm/mach-s3c2410/include/mach/spi.h~spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio arch/arm/mach-s3c2410/include/mach/spi.h
--- a/arch/arm/mach-s3c2410/include/mach/spi.h~spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio
+++ a/arch/arm/mach-s3c2410/include/mach/spi.h
@@ -14,7 +14,7 @@
 #define __ASM_ARCH_SPI_H __FILE__
 
 struct s3c2410_spi_info {
-	unsigned long		 pin_cs;	/* simple gpio cs */
+	int			 pin_cs;	/* simple gpio cs */
 	unsigned int		 num_cs;	/* total chipselects */
 	int			 bus_num;       /* bus number to use. */
 
diff -puN drivers/spi/spi_s3c24xx.c~spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-use-generic-gpio-calls-in-spi_s3c24xx_gpio
+++ a/drivers/spi/spi_s3c24xx.c
@@ -19,6 +19,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/platform_device.h>
+#include <linux/gpio.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spi_bitbang.h>
@@ -27,7 +28,6 @@
 #include <asm/dma.h>
 #include <mach/hardware.h>
 
-#include <mach/regs-gpio.h>
 #include <plat/regs-spi.h>
 #include <mach/spi.h>
 
@@ -66,7 +66,7 @@ static inline struct s3c24xx_spi *to_hw(
 
 static void s3c24xx_spi_gpiocs(struct s3c2410_spi_info *spi, int cs, int pol)
 {
-	s3c2410_gpio_setpin(spi->pin_cs, pol);
+	gpio_set_value(spi->pin_cs, pol);
 }
 
 static void s3c24xx_spi_chipsel(struct spi_device *spi, int value)
@@ -248,8 +248,13 @@ static void s3c24xx_spi_initialsetup(str
 	writeb(SPPIN_DEFAULT, hw->regs + S3C2410_SPPIN);
 	writeb(SPCON_DEFAULT, hw->regs + S3C2410_SPCON);
 
-	if (hw->pdata && hw->pdata->gpio_setup)
-		hw->pdata->gpio_setup(hw->pdata, 1);
+	if (hw->pdata) {
+		if (hw->set_cs == s3c24xx_spi_gpiocs)
+			gpio_direction_output(hw->pdata->pin_cs, 1);
+
+		if (hw->pdata->gpio_setup)
+			hw->pdata->gpio_setup(hw->pdata, 1);
+	}
 }
 
 static int __init s3c24xx_spi_probe(struct platform_device *pdev)
@@ -343,18 +348,27 @@ static int __init s3c24xx_spi_probe(stru
 		goto err_no_clk;
 	}
 
-	s3c24xx_spi_initialsetup(hw);
-
 	/* setup any gpio we can */
 
 	if (!pdata->set_cs) {
-		hw->set_cs = s3c24xx_spi_gpiocs;
+		if (pdata->pin_cs < 0) {
+			dev_err(&pdev->dev, "No chipselect pin\n");
+			goto err_register;
+		}
+
+		err = gpio_request(pdata->pin_cs, dev_name(&pdev->dev));
+		if (err) {
+			dev_err(&pdev->dev, "Failed to get gpio for cs\n");
+			goto err_register;
+		}
 
-		s3c2410_gpio_setpin(pdata->pin_cs, 1);
-		s3c2410_gpio_cfgpin(pdata->pin_cs, S3C2410_GPIO_OUTPUT);
+		hw->set_cs = s3c24xx_spi_gpiocs;
+		gpio_direction_output(pdata->pin_cs, 1);
 	} else
 		hw->set_cs = pdata->set_cs;
 
+	s3c24xx_spi_initialsetup(hw);
+
 	/* register our spi controller */
 
 	err = spi_bitbang_start(&hw->bitbang);
@@ -366,6 +380,9 @@ static int __init s3c24xx_spi_probe(stru
 	return 0;
 
  err_register:
+	if (hw->set_cs == s3c24xx_spi_gpiocs)
+		gpio_free(pdata->pin_cs);
+
 	clk_disable(hw->clk);
 	clk_put(hw->clk);
 
@@ -401,6 +418,9 @@ static int __exit s3c24xx_spi_remove(str
 	free_irq(hw->irq, hw);
 	iounmap(hw->regs);
 
+	if (hw->set_cs == s3c24xx_spi_gpiocs)
+		gpio_free(hw->pdata->pin_cs);
+
 	release_resource(hw->ioarea);
 	kfree(hw->ioarea);
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
leds-allow-led-drivers-to-use-a-wider-than-0255-range-of-brightness-values.patch
leds-add-a-dac124s085-spi-led-driver.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
sm501-fix-section-mismatches.patch

