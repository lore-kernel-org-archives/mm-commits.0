From: akpm@linux-foundation.org
Subject: + spi-freescale-imx-spi-controller-driver.patch added to -mm tree
Date: Thu, 31 May 2007 15:01:28 -0700
Message-ID: <200705312201.l4VM1SjY029090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971AbXEaWBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 18:01:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.paterniani@swapp-eng.it, david-b@pacbell.net


The patch titled
     SPI: Freescale iMX SPI controller driver fixes
has been added to the -mm tree.  Its filename is
     spi-freescale-imx-spi-controller-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI: Freescale iMX SPI controller driver fixes
From: Andrea Paterniani <a.paterniani@swapp-eng.it>

Fix 2 bugs:

- SPI_DMA_RHDMA bad value.

- Missing return value in setup() function (lost passing from
  patch-2.6.20-rc4-spi_imx to patch-2.6.20-rc6-spi_imx).

Signed-off-by: Andrea Paterniani <a.paterniani@swapp-eng.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spi_imx.c~spi-freescale-imx-spi-controller-driver drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-freescale-imx-spi-controller-driver
+++ a/drivers/spi/spi_imx.c
@@ -121,7 +121,7 @@
 							32.768 KHz Clock */
 
 /* SPI DMA Register Bit Fields & Masks */
-#define SPI_DMA_RHDMA	(0xF << 4)	/* RXFIFO Half Status */
+#define SPI_DMA_RHDMA	(0x1 << 4)	/* RXFIFO Half Status */
 #define SPI_DMA_RFDMA	(0x1 << 5)      /* RXFIFO Full Status */
 #define SPI_DMA_TEDMA	(0x1 << 6)      /* TXFIFO Empty Status */
 #define SPI_DMA_THDMA	(0x1 << 7)      /* TXFIFO Half Status */
@@ -1355,6 +1355,7 @@ static int setup(struct spi_device *spi)
 		spi->bits_per_word,
 		spi_speed_hz(SPI_CONTROL_DATARATE_MIN),
 		spi->max_speed_hz);
+	return status;
 
 err_first_setup:
 	kfree(chip);
_

Patches currently in -mm which might be from a.paterniani@swapp-eng.it are

spi-freescale-imx-spi-controller-driver.patch
