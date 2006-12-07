From: akpm@osdl.org
Subject: + spidernet-cleanup-return-codes.patch added to -mm tree
Date: Wed, 06 Dec 2006 21:36:39 -0800
Message-ID: <200612070536.kB75adTG031670@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030876AbWLGFkS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:40:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com


The patch titled
     spidernet: cleanup return codes
has been added to the -mm tree.  Its filename is
     spidernet-cleanup-return-codes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spidernet: cleanup return codes
From: Linas Vepstas <linas@austin.ibm.com>

Simplify the somewhat convoluted use of return codes in the rx buffre
handling.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-cleanup-return-codes drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-cleanup-return-codes
+++ a/drivers/net/spider_net.c
@@ -882,12 +882,10 @@ spider_net_do_ioctl(struct net_device *n
  * @card: card structure
  * @napi: whether caller is in NAPI context
  *
- * returns 1 on success, 0 if no packet was passed to the stack
- *
  * Fills out skb structure and passes the data to the stack.
  * The descriptor state is not changed.
  */
-static int
+static void
 spider_net_pass_skb_up(struct spider_net_descr *descr,
 		       struct spider_net_card *card, int napi)
 {
@@ -935,8 +933,6 @@ spider_net_pass_skb_up(struct spider_net
 	/* update netdevice statistics */
 	card->netdev_stats.rx_packets++;
 	card->netdev_stats.rx_bytes += skb->len;
-
-	return 1;
 }
 
 /**
@@ -956,7 +952,6 @@ spider_net_decode_one_descr(struct spide
 	struct spider_net_descr_chain *chain = &card->rx_chain;
 	struct spider_net_descr *descr;
 	int status;
-	int result;
 	unsigned long flags;
 
 	spin_lock_irqsave(&chain->lock, flags);
@@ -982,8 +977,6 @@ spider_net_decode_one_descr(struct spide
 	chain->tail = descr->next;
 	spin_unlock_irqrestore(&chain->lock, flags);
 
-	result = 0;
-
 	/* unmap descriptor */
 	pci_unmap_single(card->pdev, descr->buf_addr,
 			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
@@ -995,8 +988,7 @@ spider_net_decode_one_descr(struct spide
 			pr_err("%s: dropping RX descriptor with state %d\n",
 			       card->netdev->name, status);
 		card->netdev_stats.rx_dropped++;
-		dev_kfree_skb_irq(descr->skb);
-		goto refill;
+		goto bad_desc;
 	}
 
 	if ( (status != SPIDER_NET_DESCR_COMPLETE) &&
@@ -1005,8 +997,7 @@ spider_net_decode_one_descr(struct spide
 			pr_err("%s: RX descriptor with unkown state %d\n",
 			       card->netdev->name, status);
 		card->spider_stats.rx_desc_unk_state++;
-		dev_kfree_skb_irq(descr->skb);
-		goto refill;
+		goto bad_desc;
 	}
 
 	/* The cases we'll throw away the packet immediately */
@@ -1017,16 +1008,18 @@ spider_net_decode_one_descr(struct spide
 			       card->netdev->name,
 			       descr->data_status, descr->data_error);
 		card->spider_stats.rx_desc_error++;
-		dev_kfree_skb_irq(descr->skb);
-		goto refill;
+		goto bad_desc;
 	}
 
-	/* ok, we've got a packet in descr */
-	result = spider_net_pass_skb_up(descr, card, napi);
-refill:
-	/* change the descriptor state: */
+	/* Ok, we've got a packet in descr */
+	spider_net_pass_skb_up(descr, card, napi);
 	descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
-	return result;
+	return 1;
+
+bad_desc:
+	dev_kfree_skb_irq(descr->skb);
+	descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
+	return 0;
 }
 
 /**
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
hvcs-char-driver-janitoring-move-block-of-code.patch
spidernet-dma-coalescing.patch
spidernet-add-net_ratelimit-to-suppress-long-output.patch
spidernet-rx-locking.patch
spidernet-refactor-rx-refill.patch
spidernet-rx-skb-mem-leak.patch
spidernet-another-skb-mem-leak.patch
spidernet-cleanup-return-codes.patch
spidernet-rx-refill.patch
spidernet-merge-error-branches.patch
spidernet-remove-unused-variable.patch
spidernet-rx-chain-tail.patch
spidernet-turn-rx-irq-back-on.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

