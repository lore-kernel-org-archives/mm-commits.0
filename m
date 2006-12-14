From: akpm@osdl.org
Subject: + spidernet-another-skb-mem-leak.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:26:08 -0800
Message-ID: <200612140026.kBE0Q8N6026139@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33525 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbWLNA3Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:29:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com


The patch titled
     Spidernet: another skb mem leak
has been added to the -mm tree.  Its filename is
     spidernet-another-skb-mem-leak.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Spidernet: another skb mem leak
From: Linas Vepstas <linas@austin.ibm.com>

Another skb leak in an error branch.  Fix this by adding call to
dev_kfree_skb_irq() after moving to a more appropriate spot.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-another-skb-mem-leak drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-another-skb-mem-leak
+++ a/drivers/net/spider_net.c
@@ -926,19 +926,8 @@ spider_net_pass_skb_up(struct spider_net
 
 	data_status = descr->data_status;
 	data_error = descr->data_error;
-
 	netdev = card->netdev;
 
-	/* the cases we'll throw away the packet immediately */
-	if (data_error & SPIDER_NET_DESTROY_RX_FLAGS) {
-		if (netif_msg_rx_err(card))
-			pr_err("error in received descriptor found, "
-			       "data_status=x%08x, data_error=x%08x\n",
-			       data_status, data_error);
-		card->spider_stats.rx_desc_error++;
-		return 0;
-	}
-
 	skb = descr->skb;
 	skb->dev = netdev;
 	skb_put(skb, descr->valid_size);
@@ -1037,6 +1026,18 @@ spider_net_decode_one_descr(struct spide
 		goto refill;
 	}
 
+	/* The cases we'll throw away the packet immediately */
+	if (descr->data_error & SPIDER_NET_DESTROY_RX_FLAGS) {
+		if (netif_msg_rx_err(card))
+			pr_err("%s: error in received descriptor found, "
+			       "data_status=x%08x, data_error=x%08x\n",
+			       card->netdev->name,
+			       descr->data_status, descr->data_error);
+		card->spider_stats.rx_desc_error++;
+		dev_kfree_skb_irq(descr->skb);
+		goto refill;
+	}
+
 	/* ok, we've got a packet in descr */
 	result = spider_net_pass_skb_up(descr, card);
 refill:
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

