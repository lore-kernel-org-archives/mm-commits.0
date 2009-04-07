From: akpm@linux-foundation.org
Subject: [merged] pxa2xx_spi-set-spi_masterdma_alignment-=-8.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:11 -0700
Message-ID: <200904071907.n37J7BMD011193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbZDGTKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, bryan.wu@analog.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     pxa2xx_spi: set spi_master.dma_alignment = 8
has been removed from the -mm tree.  Its filename was
     pxa2xx_spi-set-spi_masterdma_alignment-=-8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxa2xx_spi: set spi_master.dma_alignment = 8
From: Mike Rapoport <mike@compulab.co.il>

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/spi/pxa2xx_spi.c~pxa2xx_spi-set-spi_masterdma_alignment-=-8 drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~pxa2xx_spi-set-spi_masterdma_alignment-=-8
+++ a/drivers/spi/pxa2xx_spi.c
@@ -54,6 +54,7 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 #define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
 #define IS_DMA_ALIGNED(x)	((((u32)(x)) & 0x07) == 0)
 #define MAX_DMA_LEN		8191
+#define DMA_ALIGNMENT		8
 
 /*
  * for testing SSCR1 changes that require SSP restart, basically
@@ -1498,6 +1499,7 @@ static int __init pxa2xx_spi_probe(struc
 
 	master->bus_num = pdev->id;
 	master->num_chipselect = platform_info->num_chipselect;
+	master->dma_alignment = DMA_ALIGNMENT;
 	master->cleanup = cleanup;
 	master->setup = setup;
 	master->transfer = transfer;
_

Patches currently in -mm which might be from mike@compulab.co.il are

origin.patch
linux-next.patch

