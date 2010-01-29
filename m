From: akpm@linux-foundation.org
Subject: [merged] serial-bfin_5xx-need-to-disable-dma-tx-interrupt-too.patch removed from -mm tree
Date: Fri, 29 Jan 2010 12:16:50 -0800
Message-ID: <201001292016.o0TKGo85003264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754861Ab0A2USE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 15:18:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: graf.yang@analog.com, alan@lxorguk.ukuu.org.uk, stable@kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     serial: bfin_5xx: need to disable DMA TX interrupt too
has been removed from the -mm tree.  Its filename was
     serial-bfin_5xx-need-to-disable-dma-tx-interrupt-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

