From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-ensure-cache-coherency-before-doing-dma.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:18 -0700
Message-ID: <200904071906.n37J6ITO010768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754782AbZDGTKt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitja.makarov@gmail.com, cooloney@kernel.org, david-b@pacbell.net, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: ensure cache coherency before doing DMA
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-ensure-cache-coherency-before-doing-dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: ensure cache coherency before doing DMA
From: Vitja Makarov <vitja.makarov@gmail.com>

Flush or invalidate caches before doing DMA transfer, if needed.

[Mike Frysinger <vapier.adi@gmail.com>: add comment to address the
issue "Full duplex only works for non-DMA transfers".]
Signed-off-by: Vitja Makarov <vitja.makarov@gmail.com>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-ensure-cache-coherency-before-doing-dma drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-ensure-cache-coherency-before-doing-dma
+++ a/drivers/spi/spi_bfin5xx.c
@@ -26,6 +26,10 @@
 #include <asm/portmux.h>
 #include <asm/bfin5xx_spi.h>
 
+/* reserved_mem_dcache_on and cache friends */
+#include <asm/cplbinit.h>
+#include <asm/cacheflush.h>
+
 #define DRV_NAME	"bfin-spi"
 #define DRV_AUTHOR	"Bryan Wu, Luke Yang"
 #define DRV_DESC	"Blackfin BF5xx on-chip SPI Controller Driver"
@@ -738,9 +742,10 @@ static void pump_transfers(unsigned long
 		width, transfer->len);
 
 	/*
-	 * Try to map dma buffer and do a dma transfer if
-	 * successful use different way to r/w according to
-	 * drv_data->cur_chip->enable_dma
+	 * Try to map dma buffer and do a dma transfer.  If successful use,
+	 * different way to r/w according to the enable_dma settings and if
+	 * we are not doing a full duplex transfer (since the hardware does
+	 * not support full duplex DMA transfers).
 	 */
 	if (!full_duplex && drv_data->cur_chip->enable_dma
 				&& drv_data->len > 6) {
@@ -795,6 +800,12 @@ static void pump_transfers(unsigned long
 			/* set transfer mode, and enable SPI */
 			dev_dbg(&drv_data->pdev->dev, "doing DMA in.\n");
 
+			/* invalidate caches, if needed */
+			if (bfin_addr_dcachable((unsigned long) drv_data->rx))
+				invalidate_dcache_range((unsigned long) drv_data->rx,
+							(unsigned long) (drv_data->rx +
+							drv_data->len));
+
 			/* clear tx reg soformer data is not shifted out */
 			write_TDBR(drv_data, 0xFFFF);
 
@@ -815,6 +826,12 @@ static void pump_transfers(unsigned long
 		} else if (drv_data->tx != NULL) {
 			dev_dbg(&drv_data->pdev->dev, "doing DMA out.\n");
 
+			/* flush caches, if needed */
+			if (bfin_addr_dcachable((unsigned long) drv_data->tx))
+				flush_dcache_range((unsigned long) drv_data->tx,
+						(unsigned long) (drv_data->tx +
+						drv_data->len));
+
 			/* start dma */
 			dma_enable_irq(drv_data->dma_channel);
 			dma_config = (RESTART | dma_width | DI_EN);
_

Patches currently in -mm which might be from vitja.makarov@gmail.com are

origin.patch

