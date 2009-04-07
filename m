From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:51 -0700
Message-ID: <200904071906.n37J6pC1011030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760016AbZDGTLk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yi.li@analog.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: fix bug - correct usage of struct spi_transfer.cs_change
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: fix bug - correct usage of struct spi_transfer.cs_change
From: Yi Li <yi.li@analog.com>

According to comments in linux/spi/spi.h:

 * All SPI transfers start with the relevant chipselect active.  Normally
 * it stays selected until after the last transfer in a message. Drivers
 * can affect the chipselect signal using cs_change.
 *
 * (i) If the transfer isn't the last one in the message, this flag is
 * used to make the chipselect briefly go inactive in the middle of the
 * message.  Toggling chipselect in this way may be needed to terminate
 * a chip command, letting a single spi_message perform all of group of
 * chip transactions together.
 *
 * (ii) When the transfer is the last one in the message, the chip may
 * stay selected until the next transfer.  On multi-device SPI busses
 * with nothing blocking messages going to other devices, this is just
 * a performance hint; starting a message to another device deselects
 * this one.  But in other cases, this can be used to ensure correctness.
 * Some devices need protocol transactions to be built from a series of
 * spi_message submissions, where the content of one message is determined
 * by the results of previous messages and where the whole transaction
 * ends when the chipselect goes intactive.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change
+++ a/drivers/spi/spi_bfin5xx.c
@@ -540,15 +540,13 @@ static void giveback(struct driver_data 
 
 	msg->state = NULL;
 
-	/* disable chip select signal. And not stop spi in autobuffer mode */
-	if (drv_data->tx_dma != 0xFFFF) {
-		cs_deactive(drv_data, chip);
-		bfin_spi_disable(drv_data);
-	}
-
 	if (!drv_data->cs_change)
 		cs_deactive(drv_data, chip);
 
+	/* Not stop spi in autobuffer mode */
+	if (drv_data->tx_dma != 0xFFFF)
+		bfin_spi_disable(drv_data);
+
 	if (msg->complete)
 		msg->complete(msg->context);
 }
@@ -757,7 +755,8 @@ static void pump_transfers(unsigned long
 
 	write_STAT(drv_data, BIT_STAT_CLR);
 	cr = (read_CTRL(drv_data) & (~BIT_CTL_TIMOD));
-	cs_active(drv_data, chip);
+	if (drv_data->cs_change)
+		cs_active(drv_data, chip);
 
 	dev_dbg(&drv_data->pdev->dev,
 		"now pumping a transfer: width is %d, len is %d\n",
@@ -919,11 +918,11 @@ static void pump_transfers(unsigned long
 		} else {
 			/* Update total byte transfered */
 			message->actual_length += drv_data->len_in_bytes;
-
 			/* Move to next transfer of this msg */
 			message->state = next_transfer(drv_data);
+			if (drv_data->cs_change)
+				cs_deactive(drv_data, chip);
 		}
