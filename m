From: akpm@linux-foundation.org
Subject: - sfc-add-and-remove-braces-to-comply-with-kernel-style.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:11 -0700
Message-ID: <200805231859.m4NIxBW3004212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327AbYEWS7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sfc: add and remove braces to comply with kernel style
has been removed from the -mm tree.  Its filename was
     sfc-add-and-remove-braces-to-comply-with-kernel-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sfc: add and remove braces to comply with kernel style
From: Ben Hutchings <bhutchings@solarflare.com>

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/efx.c    |    6 +++---
 drivers/net/sfc/falcon.c |    3 ++-
 drivers/net/sfc/rx.c     |    3 ++-
 drivers/net/sfc/tx.c     |    9 ++++++---
 4 files changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/net/sfc/efx.c~sfc-add-and-remove-braces-to-comply-with-kernel-style drivers/net/sfc/efx.c
--- a/drivers/net/sfc/efx.c~sfc-add-and-remove-braces-to-comply-with-kernel-style
+++ a/drivers/net/sfc/efx.c
@@ -1060,9 +1060,8 @@ static void efx_flush_all(struct efx_nic
 	cancel_delayed_work_sync(&efx->monitor_work);
 
 	/* Ensure that all RX slow refills are complete. */
-	efx_for_each_rx_queue(rx_queue, efx) {
+	efx_for_each_rx_queue(rx_queue, efx)
 		cancel_delayed_work_sync(&rx_queue->work);
-	}
 
 	/* Stop scheduled port reconfigurations */
 	cancel_work_sync(&efx->reconfigure_work);
@@ -1088,9 +1087,10 @@ static void efx_stop_all(struct efx_nic 
 	falcon_disable_interrupts(efx);
 	if (efx->legacy_irq)
 		synchronize_irq(efx->legacy_irq);
-	efx_for_each_channel_with_interrupt(channel, efx)
+	efx_for_each_channel_with_interrupt(channel, efx) {
 		if (channel->irq)
 			synchronize_irq(channel->irq);
+	}
 
 	/* Stop all NAPI processing and synchronous rx refills */
 	efx_for_each_channel(channel, efx)
diff -puN drivers/net/sfc/falcon.c~sfc-add-and-remove-braces-to-comply-with-kernel-style drivers/net/sfc/falcon.c
--- a/drivers/net/sfc/falcon.c~sfc-add-and-remove-braces-to-comply-with-kernel-style
+++ a/drivers/net/sfc/falcon.c
@@ -1636,9 +1636,10 @@ void falcon_fini_interrupt(struct efx_ni
 	efx_oword_t reg;
 
 	/* Disable MSI/MSI-X interrupts */
-	efx_for_each_channel_with_interrupt(channel, efx)
+	efx_for_each_channel_with_interrupt(channel, efx) {
 		if (channel->irq)
 			free_irq(channel->irq, channel);
+	}
 
 	/* ACK legacy interrupt */
 	if (FALCON_REV(efx) >= FALCON_REV_B0)
diff -puN drivers/net/sfc/rx.c~sfc-add-and-remove-braces-to-comply-with-kernel-style drivers/net/sfc/rx.c
--- a/drivers/net/sfc/rx.c~sfc-add-and-remove-braces-to-comply-with-kernel-style
+++ a/drivers/net/sfc/rx.c
@@ -400,9 +400,10 @@ static int __efx_fast_push_rx_descriptor
 		return 0;
 
 	/* Record minimum fill level */
-	if (unlikely(fill_level < rx_queue->min_fill))
+	if (unlikely(fill_level < rx_queue->min_fill)) {
 		if (fill_level)
 			rx_queue->min_fill = fill_level;
+	}
 
 	/* Acquire RX add lock.  If this lock is contended, then a fast
 	 * fill must already be in progress (e.g. in the refill
diff -puN drivers/net/sfc/tx.c~sfc-add-and-remove-braces-to-comply-with-kernel-style drivers/net/sfc/tx.c
--- a/drivers/net/sfc/tx.c~sfc-add-and-remove-braces-to-comply-with-kernel-style
+++ a/drivers/net/sfc/tx.c
@@ -639,11 +639,12 @@ static void efx_tsoh_block_free(struct e
 	base_dma = tsoh->dma_addr & PAGE_MASK;
 
 	p = &tx_queue->tso_headers_free;
-	while (*p != NULL)
+	while (*p != NULL) {
 		if (((unsigned long)*p & PAGE_MASK) == base_kva)
 			*p = (*p)->next;
 		else
 			p = &(*p)->next;
+	}
 
 	pci_free_consistent(pci_dev, PAGE_SIZE, (void *)base_kva, base_dma);
 }
@@ -939,9 +940,10 @@ static inline int tso_start_new_packet(s
 
 	/* Allocate a DMA-mapped header buffer. */
 	if (likely(TSOH_SIZE(st->p.header_length) <= TSOH_STD_SIZE)) {
-		if (tx_queue->tso_headers_free == NULL)
+		if (tx_queue->tso_headers_free == NULL) {
 			if (efx_tsoh_block_alloc(tx_queue))
 				return -1;
+		}
 		EFX_BUG_ON_PARANOID(!tx_queue->tso_headers_free);
 		tsoh = tx_queue->tso_headers_free;
 		tx_queue->tso_headers_free = tsoh->next;
@@ -1106,9 +1108,10 @@ static void efx_fini_tso(struct efx_tx_q
 {
 	unsigned i;
 
-	if (tx_queue->buffer)
+	if (tx_queue->buffer) {
 		for (i = 0; i <= tx_queue->efx->type->txd_ring_mask; ++i)
 			efx_tsoh_free(tx_queue, &tx_queue->buffer[i]);
+	}
 
 	while (tx_queue->tso_headers_free != NULL)
 		efx_tsoh_block_free(tx_queue, tx_queue->tso_headers_free,
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

git-net.patch

