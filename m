From: akpm@linux-foundation.org
Subject: - atmel_serial-avoid-stopping-pdc-during-transmission-update.patch removed from -mm tree
Date: Fri, 28 Mar 2008 14:18:46 -0700
Message-ID: <200803282118.m2SLIkH6010540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55712 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbYC1VTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 17:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trimarchimichael@yahoo.it, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_serial-avoid-stopping-pdc-during-transmission update
has been removed from the -mm tree.  Its filename was
     atmel_serial-avoid-stopping-pdc-during-transmission-update.patch

This patch was dropped because it was folded into atmel_serial-avoid-stopping-pdc-during-transmission.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_serial-avoid-stopping-pdc-during-transmission update
From: Michael Trimarchi <trimarchimichael@yahoo.it>

I try to do more tests to the serial driver and I adjust my patch, because it has problem when the pending dma
transfer contain a lot of bytes ( I can't wait a lot ).
When we have pending trasmission and we are in the tasklet, we wait for long time (9600 bps
and and xmit size equal to a XMIT_SIZE for example ) but the wakeup event of the tasklet happen for a "receive event" 
so we first receive the bytes in the pdc buffer. The driver wiil receive an interrupt later at the end of pdc transmission.
The same things happen when we are in interrupt mode. So I suppose that with the latest patch we have:

- tx_dma & rx_dma works on heavy load, slow rate and high rate
- interrupt tx & rx_dma does't work on heavy load because it spend a lot of time for trasmission
- interrupt tx & interrupt tx does't work on heavy load

Possible solutions when using interrupt tx can be:
- increase the buffering ( I don't like it )
- avoid long transmit phase

Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-avoid-stopping-pdc-during-transmission-update drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-avoid-stopping-pdc-during-transmission-update
+++ a/drivers/serial/atmel_serial.c
@@ -563,6 +563,10 @@ static void atmel_tx_dma(struct uart_por
 	struct atmel_dma_buffer *pdc = &atmel_port->pdc_tx;
 	int count;
 
+	/* nothing left to transmit? */
+	if (UART_GET_TCR(port))
+		return;
+
 	xmit->tail += pdc->ofs;
 	xmit->tail &= UART_XMIT_SIZE - 1;
 
@@ -571,10 +575,6 @@ static void atmel_tx_dma(struct uart_por
 
 	/* more to transmit - setup next transfer */
 
-	/* nothing left to transmit? */
-	while (UART_GET_TCR(port))
-		cpu_relax();
