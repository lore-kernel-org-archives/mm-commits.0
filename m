From: akpm@osdl.org
Subject: + spidernet-rx-locking.patch added to -mm tree
Date: Wed, 06 Dec 2006 21:36:31 -0800
Message-ID: <200612070536.kB75aVQr031650@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50741 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030645AbWLGFgp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:36:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com


The patch titled
     spidernet: RX Locking
has been added to the -mm tree.  Its filename is
     spidernet-rx-locking.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spidernet: RX Locking
From: Linas Vepstas <linas@austin.ibm.com>

The RX packet handling can be called from several places, yet does not protect
the rx ring structure.  This patch places the ring buffer pointers under a
lock.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-rx-locking drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-rx-locking
+++ a/drivers/net/spider_net.c
@@ -969,28 +969,33 @@ static int
 spider_net_decode_one_descr(struct spider_net_card *card, int napi)
 {
 	struct spider_net_descr_chain *chain = &card->rx_chain;
-	struct spider_net_descr *descr = chain->tail;
+	struct spider_net_descr *descr;
 	int status;
 	int result;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chain->lock, flags);
+	descr = chain->tail;
 
 	status = spider_net_get_descr_status(descr);
 
 	if (status == SPIDER_NET_DESCR_CARDOWNED) {
 		/* nothing in the descriptor yet */
-		result=0;
-		goto out;
+		spin_unlock_irqrestore(&chain->lock, flags);
+		return 0;
 	}
 
 	if (status == SPIDER_NET_DESCR_NOT_IN_USE) {
 		/* not initialized yet, the ring must be empty */
+		spin_unlock_irqrestore(&chain->lock, flags);
 		spider_net_refill_rx_chain(card);
 		spider_net_enable_rxdmac(card);
-		result=0;
-		goto out;
+		return 0;
 	}
 
 	/* descriptor definitively used -- move on tail */
 	chain->tail = descr->next;
+	spin_unlock_irqrestore(&chain->lock, flags);
 
 	result = 0;
 	if ( (status == SPIDER_NET_DESCR_RESPONSE_ERROR) ||
@@ -1022,7 +1027,6 @@ refill:
 	/* change the descriptor state: */
 	if (!napi)
 		spider_net_refill_rx_chain(card);
-out:
 	return result;
 }
 
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

