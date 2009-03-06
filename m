From: akpm@linux-foundation.org
Subject: + blackfin-serial-driver-fix-bug-serial-port-transfer-big-file-from-host-to-target-would-have-more-lines.patch added to -mm tree
Date: Fri, 06 Mar 2009 14:37:11 -0800
Message-ID: <200903062237.n26MbCBP007022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024AbZCFWh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 17:37:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sonic.zhang@analog.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org


The patch titled
     blackfin serial driver: fix bug - serial port transfer big file from host to target would have more lines
has been added to the -mm tree.  Its filename is
     blackfin-serial-driver-fix-bug-serial-port-transfer-big-file-from-host-to-target-would-have-more-lines.patch

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
Subject: blackfin serial driver: fix bug - serial port transfer big file from host to target would have more lines
From: Sonic Zhang <sonic.zhang@analog.com>

Ignore receiving data if new position is in the same line of current
buffer tail and small.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff -puN drivers/serial/bfin_5xx.c~blackfin-serial-driver-fix-bug-serial-port-transfer-big-file-from-host-to-target-would-have-more-lines drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~blackfin-serial-driver-fix-bug-serial-port-transfer-big-file-from-host-to-target-would-have-more-lines
+++ a/drivers/serial/bfin_5xx.c
@@ -407,6 +407,15 @@ void bfin_serial_rx_dma_timeout(struct b
 
 	spin_lock_irqsave(&uart->port.lock, flags);
 
+	/* 2D DMA RX buffer ring is used. Because curr_y_count and
+	 * curr_x_count can't be read as an atomic operation,
+	 * curr_y_count should be read before curr_x_count. When
+	 * curr_x_count is read, curr_y_count may already indicate
+	 * next buffer line. But, the position calculated here is
+	 * still indicate the old line. The wrong position data may
+	 * be smaller than current buffer tail, which cause garbages
+	 * are received if it is not prohibit.
+	 */
 	uart->rx_dma_nrows = get_dma_curr_ycount(uart->rx_dma_channel);
 	x_pos = get_dma_curr_xcount(uart->rx_dma_channel);
 	uart->rx_dma_nrows = DMA_RX_YCOUNT - uart->rx_dma_nrows;
@@ -417,7 +426,11 @@ void bfin_serial_rx_dma_timeout(struct b
 		x_pos = 0;
 
 	pos = uart->rx_dma_nrows * DMA_RX_XCOUNT + x_pos;
-	if (pos != uart->rx_dma_buf.tail) {
+	/* Ignore receiving data if new position is in the same line of
+	 * current buffer tail and small.
+	 */
+	if (pos > uart->rx_dma_buf.tail ||
+		uart->rx_dma_nrows < (uart->rx_dma_buf.tail/DMA_RX_XCOUNT)) {
 		uart->rx_dma_buf.head = pos;
 		bfin_serial_dma_rx_chars(uart);
 		uart->rx_dma_buf.tail = uart->rx_dma_buf.head;
@@ -455,11 +468,25 @@ static irqreturn_t bfin_serial_dma_rx_in
 {
 	struct bfin_serial_port *uart = dev_id;
 	unsigned short irqstat;
+	int pos;
 
 	spin_lock(&uart->port.lock);
 	irqstat = get_dma_curr_irqstat(uart->rx_dma_channel);
 	clear_dma_irqstat(uart->rx_dma_channel);
-	bfin_serial_dma_rx_chars(uart);
+
+	uart->rx_dma_nrows = get_dma_curr_ycount(uart->rx_dma_channel);
+	uart->rx_dma_nrows = DMA_RX_YCOUNT - uart->rx_dma_nrows;
+	if (uart->rx_dma_nrows == DMA_RX_YCOUNT)
+		uart->rx_dma_nrows = 0;
+
+	pos = uart->rx_dma_nrows * DMA_RX_XCOUNT;
+	if (pos > uart->rx_dma_buf.tail ||
+		uart->rx_dma_nrows < (uart->rx_dma_buf.tail/DMA_RX_XCOUNT)) {
+		uart->rx_dma_buf.head = pos;
+		bfin_serial_dma_rx_chars(uart);
+		uart->rx_dma_buf.tail = uart->rx_dma_buf.head;
+	}
+
 	spin_unlock(&uart->port.lock);
 
 	return IRQ_HANDLED;
_

Patches currently in -mm which might be from sonic.zhang@analog.com are

linux-next.patch
blackfin-serial-driver-fix-a-bug-in-dma-circle-rx-buffer-handling.patch
blackfin-serial-driver-change-hardware-flowcontrol-from-poll-to-interrupt-driven.patch
blackfin-serial-driver-fix-bug-serial-port-transfer-big-file-from-host-to-target-would-have-more-lines.patch
blackfin-serial-driver-fix-compile-error-in-pio-mode.patch
blackfin-serial-driver-fix-bug-enable-hardware-based-cts-and-rts-for-bf548.patch

