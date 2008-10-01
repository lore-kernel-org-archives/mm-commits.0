From: akpm@linux-foundation.org
Subject: - spi-pxa2xx_spi-buildfix.patch removed from -mm tree
Date: Wed, 01 Oct 2008 12:40:02 -0700
Message-ID: <200810011940.m91Je3Ba000608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053AbYJATky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 15:40:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, dbrownell@users.sourceforge.net, eric.miao@marvell.com, mm-commits@vger.kernel.org


The patch titled
     spi: pxa2xx_spi buildfix
has been removed from the -mm tree.  Its filename was
     spi-pxa2xx_spi-buildfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: pxa2xx_spi buildfix
From: Mike Rapoport <mike@compulab.co.il>

Fix a build error in the pxa2xx-spi driver, introduced by commit
7e96445533ac3f4f7964646a202ff3620602fab4 ("pxa2xx_spi: dma bugfixes").


[dbrownell@users.sourceforge.net: fix sparse warning too]
Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Eric Miao <eric.miao@marvell.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-buildfix drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-buildfix
+++ a/drivers/spi/pxa2xx_spi.c
@@ -49,7 +49,7 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 
 #define DMA_INT_MASK		(DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
 #define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
-#define IS_DMA_ALIGNED(x)	(((x) & 0x07) == 0)
+#define IS_DMA_ALIGNED(x)	((((u32)(x)) & 0x07) == 0)
 #define MAX_DMA_LEN		8191
 
 /*
@@ -896,7 +896,7 @@ static void pump_transfers(unsigned long
 				|| transfer->rx_dma || transfer->tx_dma) {
 			dev_err(&drv_data->pdev->dev,
 				"pump_transfers: mapped transfer length "
-				"of %lu is greater than %d\n",
+				"of %u is greater than %d\n",
 				transfer->len, MAX_DMA_LEN);
 			message->status = -EINVAL;
 			giveback(drv_data);
_

Patches currently in -mm which might be from mike@compulab.co.il are

spi-pxa2xx_spi-buildfix.patch

