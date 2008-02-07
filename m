From: akpm@linux-foundation.org
Subject: - spi-omap2_mcspi-handles-omap3-too.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:57 -0800
Message-ID: <200802070025.m170PclK006733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764740AbYBGAo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: girishsg@ti.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: omap2_mcspi handles omap3 too
has been removed from the -mm tree.  Its filename was
     spi-omap2_mcspi-handles-omap3-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
