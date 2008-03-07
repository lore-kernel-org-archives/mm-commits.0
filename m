From: akpm@linux-foundation.org
Subject: + atmel_serial-avoid-stopping-pdc-during-transmission.patch added to -mm tree
Date: Thu, 06 Mar 2008 23:56:31 -0800
Message-ID: <200803070756.m277uVUd011872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755632AbYCGH4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 02:56:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trimarchimichael@yahoo.it, hskinnemoen@atmel.com, trimarchi@gandalf.sssup.it


The patch titled
     atmel_serial: Avoid stopping pdc during transmission
has been added to the -mm tree.  Its filename is
     atmel_serial-avoid-stopping-pdc-during-transmission.patch

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
Subject: atmel_serial: Avoid stopping pdc during transmission
From: Michael Trimarchi <trimarchimichael@yahoo.it>

I found a problem related to loosing data during pdc trasmission in the
atmel_serial.  For now this patch seems to work for me, but I think that is
not the better solution.  I do this test:

- connect ttyS1 with ttyS2 using a loopback cable, send 30 byte of packet from
one to the other and waiting for 30 byte.  On the other side just read and
echo the data received.

Signed-off-by: michael <trimarchi@gandalf.sssup.it>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-avoid-stopping-pdc-during-transmission drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-avoid-stopping-pdc-during-transmission
+++ a/drivers/serial/atmel_serial.c
@@ -568,11 +568,16 @@ static void atmel_tx_dma(struct uart_por
 	port->icount.tx += pdc->ofs;
 	pdc->ofs = 0;
 
-	if (!uart_circ_empty(xmit)) {
-		/* more to transmit - setup next transfer */
+	/* more to transmit - setup next transfer */
+
+	/* nothing left to transmit? */
+	while (UART_GET_TCR(port))
+		cpu_relax();
+
+	/* disable PDC transmit */
+	UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
 
-		/* disable PDC transmit */
-		UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
+	if (!uart_circ_empty(xmit)) {
 		dma_sync_single_for_device(port->dev,
 					   pdc->dma_addr,
 					   pdc->dma_size,
@@ -586,11 +591,6 @@ static void atmel_tx_dma(struct uart_por
 		/* re-enable PDC transmit and interrupts */
 		UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
 		UART_PUT_IER(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
-	} else {
-		/* nothing left to transmit - disable the transmitter */
