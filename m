From: akpm@linux-foundation.org
Subject: + spi_bfin5xx-use-pio-for-full-duplex-not-dma.patch added to -mm tree
Date: Wed, 30 Apr 2008 15:53:56 -0700
Message-ID: <200804302253.m3UMru6Y007967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764786AbYD3Wys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 18:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vitja.makarov@gmail.com, cooloney@kernel.org, dbrownell@users.sourceforge.net


The patch titled
     spi_bfin5xx: use PIO for full duplex, not DMA
has been added to the -mm tree.  Its filename is
     spi_bfin5xx-use-pio-for-full-duplex-not-dma.patch

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
spi_bfin5xx-use-pio-for-full-duplex-not-dma.patch

