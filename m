From: akpm@osdl.org
Subject: - spidernet-merge-error-branches.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:21:11 -0800
Message-ID: <200612140021.kBE0LBKg025971@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33090 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbWLNAWu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:22:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: merge error branches
has been removed from the -mm tree.  Its filename was
     spidernet-merge-error-branches.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: spidernet: merge error branches
From: Linas Vepstas <linas@austin.ibm.com>

Two distinct if() statements have the ame body.  Merge the clauses.  Also
clean up punctuation, capitalization, etc.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-merge-error-branches drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-merge-error-branches
+++ a/drivers/net/spider_net.c
@@ -936,15 +936,16 @@ spider_net_pass_skb_up(struct spider_net
 }
 
 /**
- * spider_net_decode_one_descr - processes an rx descriptor
+ * spider_net_decode_one_descr - Processes an RX descriptor
  * @card: card structure
  * @napi: whether caller is in NAPI context
  *
- * returns 1 if a packet has been sent to the stack, otherwise 0
+ * Returns 1 if a packet has been sent to the stack, otherwise 0.
  *
- * processes an rx descriptor by iommu-unmapping the data buffer and passing
- * the packet up to the stack. This function is called in softirq
- * context, e.g. either bottom half from interrupt or NAPI polling context
+ * Processes an RX descriptor by iommu-unmapping the data buffer
+ * and passing the packet up to the stack. This function is called
+ * in a softirq context, e.g. either bottom half from interrupt or
+ * NAPI polling context.
  */
 static int
 spider_net_decode_one_descr(struct spider_net_card *card, int napi)
@@ -959,23 +960,18 @@ spider_net_decode_one_descr(struct spide
 
 	status = spider_net_get_descr_status(descr);
 
-	if (status == SPIDER_NET_DESCR_CARDOWNED) {
-		/* nothing in the descriptor yet */
+	/* Nothing in the descriptor yet, or ring is empty */
+	if ( (status == SPIDER_NET_DESCR_CARDOWNED) ||
+	     (status == SPIDER_NET_DESCR_NOT_IN_USE) ) {
 		spin_unlock_irqrestore(&chain->lock, flags);
 		return 0;
 	}
 
-	if (status == SPIDER_NET_DESCR_NOT_IN_USE) {
-		/* not initialized yet, the ring must be empty */
-		spin_unlock_irqrestore(&chain->lock, flags);
-		return 0;
-	}
-
-	/* descriptor definitively used -- move on tail */
+	/* Descriptor definitively used -- move on tail. */
 	chain->tail = descr->next;
 	spin_unlock_irqrestore(&chain->lock, flags);
 
-	/* unmap descriptor */
+	/* Unmap descriptor. */
 	pci_unmap_single(card->pdev, descr->buf_addr,
 			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
 
@@ -998,7 +994,7 @@ spider_net_decode_one_descr(struct spide
 		goto bad_desc;
 	}
 
-	/* The cases we'll throw away the packet immediately */
+	/* The cases we'll throw away the packet immediately. */
 	if (descr->data_error & SPIDER_NET_DESTROY_RX_FLAGS) {
 		if (netif_msg_rx_err(card))
 			pr_err("%s: error in received descriptor found, "
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
spidernet-merge-error-branches.patch
spidernet-remove-unused-variable.patch
spidernet-rx-chain-tail.patch
spidernet-turn-rx-irq-back-on.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

