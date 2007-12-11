From: akpm@linux-foundation.org
Subject: + atmel_spi-chain-dma-transfers-update.patch added to -mm tree
Date: Tue, 11 Dec 2007 15:33:36 -0800
Message-ID: <200712112333.lBBNXamu014732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbXLKXeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 18:34:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: slipszi@gmail.com, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com


The patch titled
     atmel_spi: chain dma transfers (update)
has been added to the -mm tree.  Its filename is
     atmel_spi-chain-dma-transfers-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atmel_spi: chain dma transfers (update)
From: "Silvester Erdeg" <slipszi@gmail.com>

This patch adds support for chained transfers in the atmel_spi driver.
Almost all of the changes are in the reworked atmel_spi_next_xfer()
function.  That's called with the driver in one of these three states:

 1. It isn't transferring anything (in which case the first transfer of
    the current message is going to be sent)
 2. It has finished transfering a non-chainable transfer (in which case
    it will go to the next transfer in the message)
 3. It has finished transfering a chained transfer (in which case the
    next transfer is already queued)

After that it will queue the next transfer if it can be chained.

Signed-off-by: Szilveszter Ordog <slipszi@gmail.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-chain-dma-transfers-update drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-chain-dma-transfers-update
+++ a/drivers/spi/atmel_spi.c
@@ -191,13 +191,13 @@ static void atmel_spi_next_xfer(struct s
 		atmel_spi_next_xfer_data(master, xfer, &tx_dma, &rx_dma, &len);
 		remaining = xfer->len - len;
 
-		spi_writel(as, TPR, tx_dma);
 		spi_writel(as, RPR, rx_dma);
+		spi_writel(as, TPR, tx_dma);
 
 		if (msg->spi->bits_per_word > 8)
 			len >>= 1;
-		spi_writel(as, TCR, len);
 		spi_writel(as, RCR, len);
+		spi_writel(as, TCR, len);
 	} else {
 		xfer = as->next_transfer;
 		remaining = as->next_remaining_bytes;
@@ -223,16 +223,16 @@ static void atmel_spi_next_xfer(struct s
 		atmel_spi_next_xfer_data(master, xfer, &tx_dma, &rx_dma, &len);
 		as->next_remaining_bytes = total - len;
 
-		spi_writel(as, TNPR, tx_dma);
 		spi_writel(as, RNPR, rx_dma);
+		spi_writel(as, TNPR, tx_dma);
 
 		if (msg->spi->bits_per_word > 8)
 			len >>= 1;
-		spi_writel(as, TNCR, len);
 		spi_writel(as, RNCR, len);
+		spi_writel(as, TNCR, len);
 	} else {
-		spi_writel(as, TNCR, 0);
 		spi_writel(as, RNCR, 0);
+		spi_writel(as, TNCR, 0);
 	}
 
 	/* REVISIT: We're waiting for ENDRX before we start the next
_

Patches currently in -mm which might be from slipszi@gmail.com are

atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
