From: akpm@linux-foundation.org
Subject: - atmel_serial-avoid-stopping-pdc-during-transmission.patch removed from -mm tree
Date: Fri, 04 Apr 2008 11:59:43 -0700
Message-ID: <200804041859.m34IxhGo004124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752065AbYDDTAB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:00:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trimarchimichael@yahoo.it, hskinnemoen@atmel.com, trimarchi@gandalf.sssup.it, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: avoid stopping pdc during transmission
has been removed from the -mm tree.  Its filename was
     atmel_serial-avoid-stopping-pdc-during-transmission.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial: avoid stopping pdc during transmission
From: Michael Trimarchi <trimarchimichael@yahoo.it>

I found a problem related to loosing data during pdc transmission in
atmel_serial: connect ttyS1 with ttyS2 using a loopback cable, send 30 byte of
packet from one to the other and waiting for 30 byte.  On the other side just
read and echo the data received.

We always call atmel_tx_dma() from the tasklet regardless of what interrupt
triggered it.

Signed-off-by: michael <trimarchi@gandalf.sssup.it>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-avoid-stopping-pdc-during-transmission drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-avoid-stopping-pdc-during-transmission
+++ a/drivers/serial/atmel_serial.c
@@ -96,6 +96,7 @@
 
  /* PDC registers */
 #define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
+#define UART_GET_TCR(port)      __raw_readl((port)->membase + ATMEL_PDC_TCR)
 #define UART_GET_PTSR(port)	__raw_readl((port)->membase + ATMEL_PDC_PTSR)
 
 #define UART_PUT_RPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RPR)
@@ -562,17 +563,22 @@ static void atmel_tx_dma(struct uart_por
 	struct atmel_dma_buffer *pdc = &atmel_port->pdc_tx;
 	int count;
 
+	/* nothing left to transmit? */
+	if (UART_GET_TCR(port))
+		return;
+
 	xmit->tail += pdc->ofs;
 	xmit->tail &= UART_XMIT_SIZE - 1;
 
 	port->icount.tx += pdc->ofs;
 	pdc->ofs = 0;
 
-	if (!uart_circ_empty(xmit)) {
-		/* more to transmit - setup next transfer */
+	/* more to transmit - setup next transfer */
 
-		/* disable PDC transmit */
-		UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
+	/* disable PDC transmit */
+	UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
+
+	if (!uart_circ_empty(xmit)) {
 		dma_sync_single_for_device(port->dev,
 					   pdc->dma_addr,
 					   pdc->dma_size,
@@ -586,11 +592,6 @@ static void atmel_tx_dma(struct uart_por
 		/* re-enable PDC transmit and interrupts */
 		UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
 		UART_PUT_IER(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
-	} else {
-		/* nothing left to transmit - disable the transmitter */
