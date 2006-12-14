From: akpm@osdl.org
Subject: + spidernet-cleanup-un-needed-api.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:26:04 -0800
Message-ID: <200612140026.kBE0Q4HF026133@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33320 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbWLNA0O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:26:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com


The patch titled
     Spidernet: cleanup un-needed API
has been added to the -mm tree.  Its filename is
     spidernet-cleanup-un-needed-api.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Spidernet: cleanup un-needed API
From: Linas Vepstas <linas@austin.ibm.com>

There is no need to pass a flag into spider_net_decode_one_descr() so remove
this, and perform some othre minor cleanup.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   35 ++++++++++++-----------------------
 1 files changed, 12 insertions(+), 23 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-cleanup-un-needed-api drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-cleanup-un-needed-api
+++ a/drivers/net/spider_net.c
@@ -910,7 +910,6 @@ spider_net_do_ioctl(struct net_device *n
  * spider_net_pass_skb_up - takes an skb from a descriptor and passes it on
  * @descr: descriptor to process
  * @card: card structure
- * @napi: whether caller is in NAPI context
  *
  * returns 1 on success, 0 if no packet was passed to the stack
  *
@@ -919,7 +918,7 @@ spider_net_do_ioctl(struct net_device *n
  */
 static int
 spider_net_pass_skb_up(struct spider_net_descr *descr,
-		       struct spider_net_card *card, int napi)
+		       struct spider_net_card *card)
 {
 	struct sk_buff *skb;
 	struct net_device *netdev;
@@ -972,10 +971,7 @@ spider_net_pass_skb_up(struct spider_net
 	}
 
 	/* pass skb up to stack */
-	if (napi)
-		netif_receive_skb(skb);
-	else
-		netif_rx_ni(skb);
+	netif_receive_skb(skb);
 
 	/* update netdevice statistics */
 	card->netdev_stats.rx_packets++;
@@ -987,16 +983,15 @@ spider_net_pass_skb_up(struct spider_net
 /**
  * spider_net_decode_one_descr - processes an rx descriptor
  * @card: card structure
- * @napi: whether caller is in NAPI context
  *
- * returns 1 if a packet has been sent to the stack, otherwise 0
+ * Returns 1 if a packet has been sent to the stack, otherwise 0
  *
- * processes an rx descriptor by iommu-unmapping the data buffer and passing
+ * Processes an rx descriptor by iommu-unmapping the data buffer and passing
  * the packet up to the stack. This function is called in softirq
  * context, e.g. either bottom half from interrupt or NAPI polling context
  */
 static int
-spider_net_decode_one_descr(struct spider_net_card *card, int napi)
+spider_net_decode_one_descr(struct spider_net_card *card)
 {
 	struct spider_net_descr_chain *chain = &card->rx_chain;
 	struct spider_net_descr *descr = chain->tail;
@@ -1005,18 +1000,15 @@ spider_net_decode_one_descr(struct spide
 
 	status = spider_net_get_descr_status(descr);
 
-	if (status == SPIDER_NET_DESCR_CARDOWNED) {
-		/* nothing in the descriptor yet */
-		result=0;
-		goto out;
-	}
+	/* nothing in the descriptor yet */
+	if (status == SPIDER_NET_DESCR_CARDOWNED)
+		return 0;
 
 	if (status == SPIDER_NET_DESCR_NOT_IN_USE) {
 		/* not initialized yet, the ring must be empty */
 		spider_net_refill_rx_chain(card);
 		spider_net_enable_rxdmac(card);
-		result=0;
-		goto out;
+		return 0;
 	}
 
 	/* descriptor definitively used -- move on tail */
@@ -1046,13 +1038,10 @@ spider_net_decode_one_descr(struct spide
 	}
 
 	/* ok, we've got a packet in descr */
-	result = spider_net_pass_skb_up(descr, card, napi);
+	result = spider_net_pass_skb_up(descr, card);
 refill:
-	descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 	/* change the descriptor state: */
-	if (!napi)
-		spider_net_refill_rx_chain(card);
-out:
+	descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 	return result;
 }
 
@@ -1079,7 +1068,7 @@ spider_net_poll(struct net_device *netde
 	packets_to_do = min(*budget, netdev->quota);
 
 	while (packets_to_do) {
-		if (spider_net_decode_one_descr(card, 1)) {
+		if (spider_net_decode_one_descr(card)) {
 			packets_done++;
 			packets_to_do--;
 		} else {
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

