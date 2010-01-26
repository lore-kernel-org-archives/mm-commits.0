From: akpm@linux-foundation.org
Subject: + serial-bfin_5xx-need-to-disable-dma-tx-interrupt-too.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:11:30 -0800
Message-ID: <201001260011.o0Q0BUhU019458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441Ab0AZALk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:11:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: graf.yang@analog.com, alan@lxorguk.ukuu.org.uk, vapier@gentoo.org


The patch titled
     serial: bfin_5xx: need to disable DMA TX interrupt too
has been added to the -mm tree.  Its filename is
     serial-bfin_5xx-need-to-disable-dma-tx-interrupt-too.patch

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
Subject: serial: bfin_5xx: need to disable DMA TX interrupt too
From: Graf Yang <graf.yang@analog.com>

If we don't disable the DMA TX channel, an inopportune timeout will
trigger the interrupt handler and may cause a dead lock with the
spin_lock.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/bfin_5xx.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/serial/bfin_5xx.c~serial-bfin_5xx-need-to-disable-dma-tx-interrupt-too drivers/serial/bfin_5xx.c
--- a/drivers/serial/bfin_5xx.c~serial-bfin_5xx-need-to-disable-dma-tx-interrupt-too
+++ a/drivers/serial/bfin_5xx.c
@@ -488,6 +488,7 @@ void bfin_serial_rx_dma_timeout(struct b
 {
 	int x_pos, pos;
 
+	dma_disable_irq(uart->tx_dma_channel);
 	dma_disable_irq(uart->rx_dma_channel);
 	spin_lock_bh(&uart->port.lock);
 
@@ -521,6 +522,7 @@ void bfin_serial_rx_dma_timeout(struct b
 	}
 
 	spin_unlock_bh(&uart->port.lock);
+	dma_enable_irq(uart->tx_dma_channel);
 	dma_enable_irq(uart->rx_dma_channel);
 
 	mod_timer(&(uart->rx_dma_timer), jiffies + DMA_RX_FLUSH_JIFFIES);
_

Patches currently in -mm which might be from graf.yang@analog.com are

serial-bfin_5xx-need-to-disable-dma-tx-interrupt-too.patch

