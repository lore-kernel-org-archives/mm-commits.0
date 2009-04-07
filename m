From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-do-not-check-for-spi-errors-if-dma-itself-did-not-flag-any.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:34 -0700
Message-ID: <200904071906.n37J6YXF010876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760388AbZDGTKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: do not check for SPI errors if DMA itself did not flag any
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-do-not-check-for-spi-errors-if-dma-itself-did-not-flag-any.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: do not check for SPI errors if DMA itself did not flag any
From: Mike Frysinger <vapier.adi@gmail.com>

We only need to check SPI error when DMA failes, cause that is the DMA IRQ
handling routine.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-do-not-check-for-spi-errors-if-dma-itself-did-not-flag-any drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-do-not-check-for-spi-errors-if-dma-itself-did-not-flag-any
+++ a/drivers/spi/spi_bfin5xx.c
@@ -587,7 +587,7 @@ static irqreturn_t dma_irq_handler(int i
 	while (!(read_STAT(drv_data) & SPIF))
 		cpu_relax();
 
-	if (spistat & RBSY) {
+	if ((dmastat & DMA_ERR) && (spistat & RBSY)) {
 		msg->state = ERROR_STATE;
 		dev_err(&drv_data->pdev->dev, "dma receive: fifo/buffer overflow\n");
 	} else {
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

