From: akpm@osdl.org
Subject: - spidernet-remove-unused-variable.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:21:13 -0800
Message-ID: <200612140021.kBE0LDWs025976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33695 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbWLNAbn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:31:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: remove unused variable
has been removed from the -mm tree.  Its filename was
     spidernet-remove-unused-variable.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: spidernet: remove unused variable
From: Linas Vepstas <linas@austin.ibm.com>

Remove unused variable; this makes code easier to read.  Tweak commentary.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-remove-unused-variable drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-remove-unused-variable
+++ a/drivers/net/spider_net.c
@@ -341,17 +341,16 @@ spider_net_free_rx_chain_contents(struct
  * @card: card structure
  * @descr: descriptor to re-init
  *
- * return 0 on succes, <0 on failure
+ * Return 0 on succes, <0 on failure.
  *
- * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
- * Activate the descriptor state-wise
+ * Allocates a new rx skb, iommu-maps it and attaches it to the
+ * descriptor. Mark the descriptor as activated, ready-to-use.
  */
 static int
 spider_net_prepare_rx_descr(struct spider_net_card *card,
 			    struct spider_net_descr *descr)
 {
 	dma_addr_t buf;
-	int error = 0;
 	int offset;
 	int bufsize;
 
@@ -379,7 +378,7 @@ spider_net_prepare_rx_descr(struct spide
 		(SPIDER_NET_RXBUF_ALIGN - 1);
 	if (offset)
 		skb_reserve(descr->skb, SPIDER_NET_RXBUF_ALIGN - offset);
-	/* io-mmu-map the skb */
+	/* iommu-map the skb */
 	buf = pci_map_single(card->pdev, descr->skb->data,
 			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
 	descr->buf_addr = buf;
@@ -394,7 +393,7 @@ spider_net_prepare_rx_descr(struct spide
 					 SPIDER_NET_DMAC_NOINTR_COMPLETE;
 	}
 
-	return error;
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
spidernet-remove-unused-variable.patch
spidernet-rx-chain-tail.patch
spidernet-turn-rx-irq-back-on.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

