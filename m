From: akpm@linux-foundation.org
Subject: + atmel_serial-fix-flow-control-bug.patch added to -mm tree
Date: Mon, 12 Jan 2009 15:25:30 -0800
Message-ID: <200901122325.n0CNPUje012441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624AbZALX0O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 18:26:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: itai.levi.devel@gmail.com, alan@lxorguk.ukuu.org.uk, avictor.za@gmail.com, haavard.skinnemoen@atmel.com


The patch titled
     atmel_serial: fix flow control bug
has been added to the -mm tree.  Its filename is
     atmel_serial-fix-flow-control-bug.patch

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
Subject: atmel_serial: fix flow control bug
From: Itai Levi <itai.levi.devel@gmail.com>

Fix the following problem, related to hardware flow control (CTS/RTS):
Transmitting while CTS line is asserted in DMA mode, due to not checking
for tx-stopped condition.

We found these problems while testing the UARTs with hardware
flow-control.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: "Andrew Victor" <avictor.za@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/atmel_serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/serial/atmel_serial.c~atmel_serial-fix-flow-control-bug drivers/serial/atmel_serial.c
--- a/drivers/serial/atmel_serial.c~atmel_serial-fix-flow-control-bug
+++ a/drivers/serial/atmel_serial.c
@@ -579,7 +579,7 @@ static void atmel_tx_dma(struct uart_por
 	/* disable PDC transmit */
 	UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
 
-	if (!uart_circ_empty(xmit)) {
+	if (!uart_circ_empty(xmit) && !uart_tx_stopped(port)) {
 		dma_sync_single_for_device(port->dev,
 					   pdc->dma_addr,
 					   pdc->dma_size,
_

Patches currently in -mm which might be from itai.levi.devel@gmail.com are

atmel_serial-fix-flow-control-bug.patch

