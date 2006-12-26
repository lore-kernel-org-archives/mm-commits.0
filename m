From: akpm@osdl.org
Subject: - spidernet-cleanup-return-codes.patch removed from -mm tree
Date: Tue, 26 Dec 2006 15:19:12 -0800
Message-ID: <200612262319.kBQNJCBS027796@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37693 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839AbWLZXWw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Dec 2006 18:22:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Spidernet: Cleanup return codes
has been removed from the -mm tree.  Its filename was
     spidernet-cleanup-return-codes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Spidernet: Cleanup return codes
From: Linas Vepstas <linas@austin.ibm.com>

Simplify the somewhat convoluted use of return codes in the rx buffer
handling.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-cleanup-return-codes drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-cleanup-return-codes
+++ a/drivers/net/spider_net.c
@@ -911,12 +911,10 @@ spider_net_do_ioctl(struct net_device *n
  * @descr: descriptor to process
  * @card: card structure
  *
- * returns 1 on success, 0 if no packet was passed to the stack
- *
  * Fills out skb structure and passes the data to the stack.
  * The descriptor state is not changed.
  */
-static int
+static void
 spider_net_pass_skb_up(struct spider_net_descr *descr,
 		       struct spider_net_card *card)
 {
@@ -961,8 +959,6 @@ spider_net_pass_skb_up(struct spider_net
 	/* update netdevice statistics */
 	card->netdev_stats.rx_packets++;
 	card->netdev_stats.rx_bytes += skb->len;
-
-	return 1;
 }
 
 /**
@@ -981,7 +977,6 @@ spider_net_decode_one_descr(struct spide
 	struct spider_net_descr_chain *chain = &card->rx_chain;
 	struct spider_net_descr *descr = chain->tail;
 	int status;
-	int result;
 
 	status = spider_net_get_descr_status(descr);
 
@@ -999,8 +994,6 @@ spider_net_decode_one_descr(struct spide
 	/* descriptor definitively used -- move on tail */
 	chain->tail = descr->next;
 
-	result = 0;
-
 	/* unmap descriptor */
 	pci_unmap_single(card->pdev, descr->buf_addr,
 			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
@@ -1012,8 +1005,7 @@ spider_net_decode_one_descr(struct spide
 			pr_err("%s: dropping RX descriptor with state %d\n",
 			       card->netdev->name, status);
 		card->netdev_stats.rx_dropped++;
-		dev_kfree_skb_irq(descr->skb);
-		goto refill;
+		goto bad_desc;
 	}
 
 	if ( (status != SPIDER_NET_DESCR_COMPLETE) &&
@@ -1022,8 +1014,7 @@ spider_net_decode_one_descr(struct spide
 			pr_err("%s: RX descriptor with unkown state %d\n",
 			       card->netdev->name, status);
 		card->spider_stats.rx_desc_unk_state++;
-		dev_kfree_skb_irq(descr->skb);
-		goto refill;
+		goto bad_desc;
 	}
 
 	/* The cases we'll throw away the packet immediately */
@@ -1033,17 +1024,18 @@ spider_net_decode_one_descr(struct spide
 			       "data_status=x%08x, data_error=x%08x\n",
 			       card->netdev->name,
 			       descr->data_status, descr->data_error);
-		card->spider_stats.rx_desc_error++;
-		dev_kfree_skb_irq(descr->skb);
-		goto refill;
+		goto bad_desc;
 	}
 
-	/* ok, we've got a packet in descr */
-	result = spider_net_pass_skb_up(descr, card);
-refill:
-	/* change the descriptor state: */
+	/* Ok, we've got a packet in descr */
+	spider_net_pass_skb_up(descr, card);
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

git-netdev-all.patch
spidernet-rework-rx-linked-list.patch

