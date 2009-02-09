From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-ensure-cache-coherency-before-doing-dma.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:14:50 -0800
Message-ID: <200902092214.n19MEpQe008543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbZBIWPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:15:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vitja.makarov@gmail.com, cooloney@kernel.org, david-b@pacbell.net, vapier.adi@gmail.com


The patch titled
     Blackfin SPI Driver: ensure cache coherency before doing DMA
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-ensure-cache-coherency-before-doing-dma.patch

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

blackfin-spi-driver-ensure-cache-coherency-before-doing-dma.patch

