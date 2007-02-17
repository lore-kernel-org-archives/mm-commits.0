From: akpm@linux-foundation.org
Subject: + spi_s3c2410_gpioc-spi-mode-2-and-3-support.patch added to -mm tree
Date: Fri, 16 Feb 2007 17:47:36 -0800
Message-ID: <200702170147.l1H1laDG016080@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44177 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632AbXBQBsU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 20:48:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laforge@openmoko.org, ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     spi_s3c2410_gpio.c spi mode 2 and 3 support
has been added to the -mm tree.  Its filename is
     spi_s3c2410_gpioc-spi-mode-2-and-3-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi_s3c2410_gpio.c spi mode 2 and 3 support
From: Harald Welte <laforge@openmoko.org>

Add transfer modes 2 and 3 to the S3C24XX gpio SPI driver

Signed-off-by: Harald Welte <laforge@openmoko.org>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx_gpio.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+)

diff -puN drivers/spi/spi_s3c24xx_gpio.c~spi_s3c2410_gpioc-spi-mode-2-and-3-support drivers/spi/spi_s3c24xx_gpio.c
--- a/drivers/spi/spi_s3c24xx_gpio.c~spi_s3c2410_gpioc-spi-mode-2-and-3-support
+++ a/drivers/spi/spi_s3c24xx_gpio.c
@@ -73,6 +73,19 @@ static u32 s3c2410_spigpio_txrx_mode1(st
 	return bitbang_txrx_be_cpha1(spi, nsecs, 0, word, bits);
 }
 
+static u32 s3c2410_spigpio_txrx_mode2(struct spi_device *spi,
+				      unsigned nsecs, u32 word, u8 bits)
+{
+	return bitbang_txrx_be_cpha0(spi, nsecs, 1, word, bits);
+}
+
+static u32 s3c2410_spigpio_txrx_mode3(struct spi_device *spi,
+				      unsigned nsecs, u32 word, u8 bits)
+{
+	return bitbang_txrx_be_cpha1(spi, nsecs, 1, word, bits);
+}
+
+
 static void s3c2410_spigpio_chipselect(struct spi_device *dev, int value)
 {
 	struct s3c2410_spigpio *sg = spidev_to_sg(dev);
@@ -108,6 +121,8 @@ static int s3c2410_spigpio_probe(struct 
 
 	sp->bitbang.txrx_word[SPI_MODE_0] = s3c2410_spigpio_txrx_mode0;
 	sp->bitbang.txrx_word[SPI_MODE_1] = s3c2410_spigpio_txrx_mode1;
+	sp->bitbang.txrx_word[SPI_MODE_2] = s3c2410_spigpio_txrx_mode2;
+	sp->bitbang.txrx_word[SPI_MODE_3] = s3c2410_spigpio_txrx_mode3;
 
 	/* set state of spi pins */
 	s3c2410_gpio_setpin(sp->info->pin_clk, 0);
_

Patches currently in -mm which might be from laforge@openmoko.org are

spi_s3c2410_gpioc-spi-mode-2-and-3-support.patch
