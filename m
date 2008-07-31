From: akpm@linux-foundation.org
Subject: + atmel_spi-fix-hang-due-to-missed-interrupt.patch added to -mm tree
Date: Thu, 31 Jul 2008 14:24:14 -0700
Message-ID: <200807312124.m6VLOEtP012737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753895AbYGaVYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 17:24:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerardk5@verizon.net, david-b@pacbell.net, haavard.skinnemoen@atmel.com


The patch titled
     atmel_spi: fix hang due to missed interrupt
has been added to the -mm tree.  Its filename is
     atmel_spi-fix-hang-due-to-missed-interrupt.patch

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
Subject: atmel_spi: fix hang due to missed interrupt
From: Gerard Kam <gerardk5@verizon.net>

For some time my at91sam9260 board with JFFS2 on serial flash (m25p80)
would hang when accessing the serial flash and SPI bus.  Slowing the SPI
clock down to 9 MHz reduced the occurrence of the hang from "always"
during boot to a nuisance level that allowed other SW development to
continue.  Finally had to address this issue when an application stresses
the I/O to always cause a hang.

Hang seems to be caused by a missed SPI interrupt, so that the task ends
up waiting forever after calling spi_sync().  The fix has 2 parts.  First
is to halt the DMA engine before the "current" PDC registers are loaded. 
This ensures that the "next" registers are loaded before the DMA operation
takes off.  The second part of the fix is a kludge that adds a
"completion" interrupt in case the ENDRX interrupt for the last segment of
the DMA chaining operation was missed.

The patch allows the SPI clock for the serial flash to be increased from 9
MHz to 15 MHz (or more?).  No hangs or SPI overruns were encountered.

Haavard: while this patch does indeed improve things, I still see overruns
and CRC errors on my NGW100 board when running the DataFlash at 10 MHz. 
However, I think some improvement is better than nothing, so I'm passing
this on for inclusion in 2.6.27.

Signed-off-by: Gerard Kam <gerardk5@verizon.net>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-fix-hang-due-to-missed-interrupt drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-fix-hang-due-to-missed-interrupt
+++ a/drivers/spi/atmel_spi.c
@@ -184,7 +184,8 @@ static void atmel_spi_next_xfer(struct s
 {
 	struct atmel_spi	*as = spi_master_get_devdata(master);
 	struct spi_transfer	*xfer;
-	u32			len, remaining, total;
+	u32			len, remaining;
+	u32			ieval;
 	dma_addr_t		tx_dma, rx_dma;
 
 	if (!as->current_transfer)
@@ -197,6 +198,8 @@ static void atmel_spi_next_xfer(struct s
 		xfer = NULL;
 
 	if (xfer) {
+		spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
+
 		len = xfer->len;
 		atmel_spi_next_xfer_data(master, xfer, &tx_dma, &rx_dma, &len);
 		remaining = xfer->len - len;
@@ -234,6 +237,8 @@ static void atmel_spi_next_xfer(struct s
 	as->next_transfer = xfer;
 
 	if (xfer) {
+		u32	total;
+
 		total = len;
 		atmel_spi_next_xfer_data(master, xfer, &tx_dma, &rx_dma, &len);
 		as->next_remaining_bytes = total - len;
@@ -250,9 +255,11 @@ static void atmel_spi_next_xfer(struct s
 			"  next xfer %p: len %u tx %p/%08x rx %p/%08x\n",
 			xfer, xfer->len, xfer->tx_buf, xfer->tx_dma,
 			xfer->rx_buf, xfer->rx_dma);
+		ieval = SPI_BIT(ENDRX) | SPI_BIT(OVRES);
 	} else {
 		spi_writel(as, RNCR, 0);
 		spi_writel(as, TNCR, 0);
+		ieval = SPI_BIT(RXBUFF) | SPI_BIT(ENDRX) | SPI_BIT(OVRES);
 	}
 
 	/* REVISIT: We're waiting for ENDRX before we start the next
@@ -265,7 +272,7 @@ static void atmel_spi_next_xfer(struct s
 	 *
 	 * It should be doable, though. Just not now...
 	 */
-	spi_writel(as, IER, SPI_BIT(ENDRX) | SPI_BIT(OVRES));
+	spi_writel(as, IER, ieval);
 	spi_writel(as, PTCR, SPI_BIT(TXTEN) | SPI_BIT(RXTEN));
 }
 
@@ -396,7 +403,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 
 		ret = IRQ_HANDLED;
 
-		spi_writel(as, IDR, (SPI_BIT(ENDTX) | SPI_BIT(ENDRX)
+		spi_writel(as, IDR, (SPI_BIT(RXBUFF) | SPI_BIT(ENDRX)
 				     | SPI_BIT(OVRES)));
 
 		/*
@@ -418,7 +425,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 		if (xfer->delay_usecs)
 			udelay(xfer->delay_usecs);
 
-		dev_warn(master->dev.parent, "fifo overrun (%u/%u remaining)\n",
+		dev_warn(master->dev.parent, "overrun (%u/%u remaining)\n",
 			 spi_readl(as, TCR), spi_readl(as, RCR));
 
 		/*
@@ -442,7 +449,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 		spi_readl(as, SR);
 
 		atmel_spi_msg_done(master, as, msg, -EIO, 0);
-	} else if (pending & SPI_BIT(ENDRX)) {
+	} else if (pending & (SPI_BIT(RXBUFF) | SPI_BIT(ENDRX))) {
 		ret = IRQ_HANDLED;
 
 		spi_writel(as, IDR, pending);
_

Patches currently in -mm which might be from gerardk5@verizon.net are

atmel_spi-fix-hang-due-to-missed-interrupt.patch

