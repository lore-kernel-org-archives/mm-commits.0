From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:26 -0700
Message-ID: <200904071906.n37J6QOL010798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756870AbZDGTLV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: pass DMA overflow error to the higher level
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: pass DMA overflow error to the higher level
From: Mike Frysinger <vapier.adi@gmail.com>

If the SPI bus registers a receive overflow error, pass the result back up
to the higher levels.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-pass-dma-overflow-error-to-the-higher-level
+++ a/drivers/spi/spi_bfin5xx.c
@@ -559,6 +559,7 @@ static irqreturn_t dma_irq_handler(int i
 	struct driver_data *drv_data = dev_id;
 	struct chip_data *chip = drv_data->cur_chip;
 	struct spi_message *msg = drv_data->cur_msg;
+	u16 spistat = read_STAT(drv_data);
 
 	dev_dbg(&drv_data->pdev->dev, "in dma_irq_handler\n");
 	clear_dma_irqstat(drv_data->dma_channel);
@@ -582,13 +583,18 @@ static irqreturn_t dma_irq_handler(int i
 	while (!(read_STAT(drv_data) & SPIF))
 		cpu_relax();
 
-	msg->actual_length += drv_data->len_in_bytes;
+	if (spistat & RBSY) {
+		msg->state = ERROR_STATE;
+		dev_err(&drv_data->pdev->dev, "dma receive: fifo/buffer overflow\n");
+	} else {
+		msg->actual_length += drv_data->len_in_bytes;
 
-	if (drv_data->cs_change)
-		cs_deactive(drv_data, chip);
+		if (drv_data->cs_change)
+			cs_deactive(drv_data, chip);
 
-	/* Move to next transfer */
-	msg->state = next_transfer(drv_data);
+		/* Move to next transfer */
+		msg->state = next_transfer(drv_data);
+	}
 
 	/* Schedule transfer tasklet */
 	tasklet_schedule(&drv_data->pump_transfers);
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

