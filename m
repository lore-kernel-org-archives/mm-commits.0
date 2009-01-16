From: akpm@linux-foundation.org
Subject: [merged] atmel_serial-fix-flow-control-bug.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:13 -0800
Message-ID: <200901161916.n0GJGDuF024661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932867AbZAPTQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:16:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: itai.levi.devel@gmail.com, alan@lxorguk.ukuu.org.uk, avictor.za@gmail.com, haavard.skinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_serial: fix flow control bug
has been removed from the -mm tree.  Its filename was
     atmel_serial-fix-flow-control-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

