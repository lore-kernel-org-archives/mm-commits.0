From: akpm@linux-foundation.org
Subject: + atmel_spi-fix-handling-of-chipselect-after-spi-transfer.patch added to -mm tree
Date: Mon, 02 Feb 2009 16:31:00 -0800
Message-ID: <200902030031.n130V0DL019865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbZBCAbm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 19:31:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@heimpold.de, david-b@pacbell.net, hskinnemoen@atmel.com, mhei@heimpold.de


The patch titled
     atmel_spi: fix handling of chipselect after SPI transfer
has been added to the -mm tree.  Its filename is
     atmel_spi-fix-handling-of-chipselect-after-spi-transfer.patch

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
Subject: atmel_spi: fix handling of chipselect after SPI transfer
From: Michael Heimpold <michael@heimpold.de>

According to include/linux/spi/spi.h chipselect should stay active after a
SPI transfer or after a SPI message unless modified by
spi_transfer.cs_change != 0.

The current atmel driver passes this field to atmel_spi_msg_done as a
parameter with oppositional meaning: "cs_change" -> "stay" (see
atmel_spi_interrupt).

This patch fixes this behaviour by adapting the called function and its
callers.  IMHO this solution is better than an one line fix of inverting
the function's argument as the meaning of the field remains throughout the
hole stack.

Signed-off-by: Michael Heimpold <mhei@heimpold.de>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-fix-handling-of-chipselect-after-spi-transfer drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-fix-handling-of-chipselect-after-spi-transfer
+++ a/drivers/spi/atmel_spi.c
@@ -385,9 +385,9 @@ static void atmel_spi_dma_unmap_xfer(str
 
 static void
 atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
-		struct spi_message *msg, int status, int stay)
+		struct spi_message *msg, int status, int cs_change)
 {
-	if (!stay || status < 0)
+	if (cs_change || status < 0)
 		cs_deactivate(as, msg->spi);
 	else
 		as->stay = msg->spi;
@@ -482,7 +482,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 		/* Clear any overrun happening while cleaning up */
 		spi_readl(as, SR);
 
-		atmel_spi_msg_done(master, as, msg, -EIO, 0);
+		atmel_spi_msg_done(master, as, msg, -EIO, 1);
 	} else if (pending & (SPI_BIT(RXBUFF) | SPI_BIT(ENDRX))) {
 		ret = IRQ_HANDLED;
 
_

Patches currently in -mm which might be from michael@heimpold.de are

atmel_spi-fix-handling-of-chipselect-after-spi-transfer.patch

