From: akpm@osdl.org
Subject: + spidernet-remove-unused-variable.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:26:14 -0800
Message-ID: <200612140026.kBE0QETe026150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33383 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbWLNA11 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:27:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com


The patch titled
     Spidernet: Remove unused variable
has been added to the -mm tree.  Its filename is
     spidernet-remove-unused-variable.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Spidernet: Remove unused variable
From: Linas Vepstas <linas@austin.ibm.com>

Remove unused variable; this makes code easier to read.  Tweak commentary.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-remove-unused-variable drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-remove-unused-variable
+++ a/drivers/net/spider_net.c
@@ -367,21 +367,20 @@ spider_net_free_rx_chain_contents(struct
 }
 
 /**
- * spider_net_prepare_rx_descr - reinitializes a rx descriptor
+ * spider_net_prepare_rx_descr - Reinitialize RX descriptor
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
 
@@ -409,7 +408,7 @@ spider_net_prepare_rx_descr(struct spide
 		(SPIDER_NET_RXBUF_ALIGN - 1);
 	if (offset)
 		skb_reserve(descr->skb, SPIDER_NET_RXBUF_ALIGN - offset);
-	/* io-mmu-map the skb */
+	/* iommu-map the skb */
 	buf = pci_map_single(card->pdev, descr->skb->data,
 			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
 	descr->buf_addr = buf;
@@ -424,7 +423,7 @@ spider_net_prepare_rx_descr(struct spide
 					 SPIDER_NET_DMAC_NOINTR_COMPLETE;
 	}
 
-	return error;
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
spidernet-dma-coalescing.patch
spidernet-add-net_ratelimit-to-suppress-long-output.patch
spidernet-remove-rxramfull-tasklet.patch
spidernet-cleanup-un-needed-api.patch
spidernet-rx-skb-mem-leak.patch
spidernet-another-skb-mem-leak.patch
spidernet-cleanup-return-codes.patch
spidernet-rx-refill.patch
spidernet-remove-unused-variable.patch
spidernet-rx-chain-tail.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

