From: akpm@linux-foundation.org
Subject: [merged] spi_imx-set-spi_masterdma_alignment-=-4.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:13 -0700
Message-ID: <200904071907.n37J7DPI011198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925AbZDGT4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, bryan.wu@analog.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi_imx: set spi_master.dma_alignment = 4
has been removed from the -mm tree.  Its filename was
     spi_imx-set-spi_masterdma_alignment-=-4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_imx: set spi_master.dma_alignment = 4
From: Mike Rapoport <mike@compulab.co.il>

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_imx.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/spi/spi_imx.c~spi_imx-set-spi_masterdma_alignment-=-4 drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi_imx-set-spi_masterdma_alignment-=-4
+++ a/drivers/spi/spi_imx.c
@@ -186,6 +186,7 @@
 #define QUEUE_STOPPED			(1)
 
 #define IS_DMA_ALIGNED(x) 		(((u32)(x) & 0x03) == 0)
+#define DMA_ALIGNMENT			4
 /*-------------------------------------------------------------------------*/
 
 
@@ -1482,6 +1483,7 @@ static int __init spi_imx_probe(struct p
 
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

