From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch added to -mm tree
Date: Mon, 09 Feb 2009 14:15:24 -0800
Message-ID: <200902092215.n19MFOgl009292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254AbZBIWQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 17:16:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yi.li@analog.com, cooloney@kernel.org, david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     Blackfin SPI Driver: fix bug - correct usage of struct spi_transfer.cs_change
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-fix-bug-correct-usage-of-struct-spi_transfercs_change.patch

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
