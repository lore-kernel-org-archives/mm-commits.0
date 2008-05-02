From: akpm@linux-foundation.org
Subject: - spi_bfin5xx-use-pio-for-full-duplex-not-dma.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:01 -0700
Message-ID: <200805021943.m42Jh1qs011247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932429AbYEBTnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitja.makarov@gmail.com, cooloney@kernel.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_bfin5xx: use PIO for full duplex, not DMA
has been removed from the -mm tree.  Its filename was
     spi_bfin5xx-use-pio-for-full-duplex-not-dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_bfin5xx: use PIO for full duplex, not DMA
From: Vitja Makarov <vitja.makarov@gmail.com>

Use PIO for full-duplex transfers, instead of DMA.

Signed-off-by: Vitja Makarov <vitja.makarov@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi_bfin5xx-use-pio-for-full-duplex-not-dma drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi_bfin5xx-use-pio-for-full-duplex-not-dma
+++ a/drivers/spi/spi_bfin5xx.c
@@ -608,6 +608,7 @@ static void pump_transfers(unsigned long
 	u8 width;
 	u16 cr, dma_width, dma_config;
 	u32 tranf_success = 1;
+	u8 full_duplex = 0;
 
 	/* Get current state information */
 	message = drv_data->cur_msg;
@@ -658,6 +659,7 @@ static void pump_transfers(unsigned long
 	}
 
 	if (transfer->rx_buf != NULL) {
+		full_duplex = transfer->tx_buf != NULL;
 		drv_data->rx = transfer->rx_buf;
 		drv_data->rx_end = drv_data->rx + transfer->len;
 		dev_dbg(&drv_data->pdev->dev, "rx_buf is %p, rx_end is %p\n",
@@ -740,7 +742,8 @@ static void pump_transfers(unsigned long
 	 * successful use different way to r/w according to
 	 * drv_data->cur_chip->enable_dma
 	 */
-	if (drv_data->cur_chip->enable_dma && drv_data->len > 6) {
+	if (!full_duplex && drv_data->cur_chip->enable_dma
+				&& drv_data->len > 6) {
 
 		disable_dma(drv_data->dma_channel);
 		clear_dma_irqstat(drv_data->dma_channel);
@@ -828,7 +831,7 @@ static void pump_transfers(unsigned long
 		/* IO mode write then read */
 		dev_dbg(&drv_data->pdev->dev, "doing IO transfer\n");
 
-		if (drv_data->tx != NULL && drv_data->rx != NULL) {
+		if (full_duplex) {
 			/* full duplex mode */
 			BUG_ON((drv_data->tx_end - drv_data->tx) !=
 			       (drv_data->rx_end - drv_data->rx));
_

Patches currently in -mm which might be from vitja.makarov@gmail.com are

origin.patch

