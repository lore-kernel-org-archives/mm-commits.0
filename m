From: akpm@linux-foundation.org
Subject: + s3c24xx-ensure-we-only-configure-valid-gpios.patch added to -mm tree
Date: Tue, 20 Nov 2007 00:08:22 -0800
Message-ID: <200711200808.lAK88MZs026244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755638AbXKTIJG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 03:09:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     S3C24XX: ensure we only configure valid GPIOs
has been added to the -mm tree.  Its filename is
     s3c24xx-ensure-we-only-configure-valid-gpios.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: S3C24XX: ensure we only configure valid GPIOs
From: Ben Dooks <ben-linux@fluff.org>

If we specify an GPIO which cannot be used for the purpose, then assume
that the GPIO is not to be used and do not try and configure it.  This can
be the case where the SPI bus is TX only.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx_gpio.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN drivers/spi/spi_s3c24xx_gpio.c~s3c24xx-ensure-we-only-configure-valid-gpios drivers/spi/spi_s3c24xx_gpio.c
--- a/drivers/spi/spi_s3c24xx_gpio.c~s3c24xx-ensure-we-only-configure-valid-gpios
+++ a/drivers/spi/spi_s3c24xx_gpio.c
@@ -96,6 +96,7 @@ static void s3c2410_spigpio_chipselect(s
 
 static int s3c2410_spigpio_probe(struct platform_device *dev)
 {
+	struct s3c2410_spigpio_info *info;
 	struct spi_master	*master;
 	struct s3c2410_spigpio  *sp;
 	int ret;
@@ -113,7 +114,7 @@ static int s3c2410_spigpio_probe(struct 
 	platform_set_drvdata(dev, sp);
 
 	/* copy in the plkatform data */
-	sp->info = dev->dev.platform_data;
+	info = sp->info = dev->dev.platform_data;
 
 	/* setup spi bitbang adaptor */
 	sp->bitbang.master = spi_master_get(master);
@@ -124,13 +125,18 @@ static int s3c2410_spigpio_probe(struct 
 	sp->bitbang.txrx_word[SPI_MODE_2] = s3c2410_spigpio_txrx_mode2;
 	sp->bitbang.txrx_word[SPI_MODE_3] = s3c2410_spigpio_txrx_mode3;
 
-	/* set state of spi pins */
-	s3c2410_gpio_setpin(sp->info->pin_clk, 0);
-	s3c2410_gpio_setpin(sp->info->pin_mosi, 0);
-
-	s3c2410_gpio_cfgpin(sp->info->pin_clk, S3C2410_GPIO_OUTPUT);
-	s3c2410_gpio_cfgpin(sp->info->pin_mosi, S3C2410_GPIO_OUTPUT);
-	s3c2410_gpio_cfgpin(sp->info->pin_miso, S3C2410_GPIO_INPUT);
+	/* set state of spi pins, always assume that the clock is
+	 * available, but do check the MOSI and MISO. */
+	s3c2410_gpio_setpin(info->pin_clk, 0);
+	s3c2410_gpio_cfgpin(info->pin_clk, S3C2410_GPIO_OUTPUT);
+
+	if (info->pin_mosi < S3C2410_GPH10) {
+		s3c2410_gpio_setpin(info->pin_mosi, 0);
+		s3c2410_gpio_cfgpin(info->pin_mosi, S3C2410_GPIO_OUTPUT);
+	}
+
+	if (info->pin_miso != S3C2410_GPA0 && info->pin_miso < S3C2410_GPH10)
+		s3c2410_gpio_cfgpin(info->pin_miso, S3C2410_GPIO_INPUT);
 
 	ret = spi_bitbang_start(&sp->bitbang);
 	if (ret)
_

Patches currently in -mm which might be from ben-linux@fluff.org are

s3c24xx-ensure-we-only-configure-valid-gpios.patch
