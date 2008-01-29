From: akpm@linux-foundation.org
Subject: + spi-omap2_mcspi-handles-omap3-too.patch added to -mm tree
Date: Tue, 29 Jan 2008 12:33:27 -0800
Message-ID: <200801292033.m0TKXR19003181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59057 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048AbYA2Udq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 15:33:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: girishsg@ti.com, dbrownell@users.sourceforge.net


The patch titled
     spi: omap2_mcspi handles omap3 too
has been added to the -mm tree.  Its filename is
     spi-omap2_mcspi-handles-omap3-too.patch

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
Subject: spi: omap2_mcspi handles omap3 too
From: "Girish" <girishsg@ti.com>

This adds driver OMAP SPI specific changes to support OMAP 3430

Signed-off-by: Girish S G <girishsg@ti.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig       |    6 ++---
 drivers/spi/omap2_mcspi.c |   37 +++++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 4 deletions(-)

diff -puN drivers/spi/Kconfig~spi-omap2_mcspi-handles-omap3-too drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-omap2_mcspi-handles-omap3-too
+++ a/drivers/spi/Kconfig
@@ -144,10 +144,10 @@ config SPI_OMAP_UWIRE
 	  This hooks up to the MicroWire controller on OMAP1 chips.
 
 config SPI_OMAP24XX
-	tristate "McSPI driver for OMAP24xx"
-	depends on SPI_MASTER && ARCH_OMAP24XX
+	tristate "McSPI driver for OMAP24xx/OMAP34xx"
+	depends on SPI_MASTER && (ARCH_OMAP24XX || ARCH_OMAP34XX)
 	help
-	  SPI master controller for OMAP24xx Multichannel SPI
+	  SPI master controller for OMAP24xx/OMAP34xx Multichannel SPI
 	  (McSPI) modules.
 
 config SPI_PXA2XX
diff -puN drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-handles-omap3-too drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-handles-omap3-too
+++ a/drivers/spi/omap2_mcspi.c
@@ -915,6 +915,28 @@ static u8 __initdata spi2_txdma_id[] = {
 	OMAP24XX_DMA_SPI2_TX1,
 };
 
+#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP34XX)
+static u8 __initdata spi3_rxdma_id[] = {
+	OMAP24XX_DMA_SPI3_RX0,
+	OMAP24XX_DMA_SPI3_RX1,
+};
+
+static u8 __initdata spi3_txdma_id[] = {
+	OMAP24XX_DMA_SPI3_TX0,
+	OMAP24XX_DMA_SPI3_TX1,
+};
+#endif
+
+#ifdef CONFIG_ARCH_OMAP3
+static u8 __initdata spi4_rxdma_id[] = {
+	OMAP34XX_DMA_SPI4_RX0,
+};
+
+static u8 __initdata spi4_txdma_id[] = {
+	OMAP34XX_DMA_SPI4_TX0,
+};
+#endif
+
 static int __init omap2_mcspi_probe(struct platform_device *pdev)
 {
 	struct spi_master	*master;
@@ -935,7 +957,20 @@ static int __init omap2_mcspi_probe(stru
 		txdma_id = spi2_txdma_id;
 		num_chipselect = 2;
 		break;
-	/* REVISIT omap2430 has a third McSPI ... */
+#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3)
+	case 3:
+		rxdma_id = spi3_rxdma_id;
+		txdma_id = spi3_txdma_id;
+		num_chipselect = 2;
+		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP3
+	case 4:
+		rxdma_id = spi4_rxdma_id;
+		txdma_id = spi4_txdma_id;
+		num_chipselect = 1;
+		break;
+#endif
 	default:
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from girishsg@ti.com are

spi-omap2_mcspi-handles-omap3-too.patch
