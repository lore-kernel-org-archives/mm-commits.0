From: akpm@osdl.org
Subject: - spidernet-rx-chain-tail.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:21:16 -0800
Message-ID: <200612140021.kBE0LGpt025979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33561 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbWLNA3y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:29:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: RX Chain tail
has been removed from the -mm tree.  Its filename was
     spidernet-rx-chain-tail.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: spidernet: RX Chain tail
From: Linas Vepstas <linas@austin.ibm.com>

Tell the hardware the location of the rx ring tail.  More punctuation cleanup.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-rx-chain-tail drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-rx-chain-tail
+++ a/drivers/net/spider_net.c
@@ -457,10 +457,10 @@ spider_net_refill_rx_chain(struct spider
 }
 
 /**
- * spider_net_alloc_rx_skbs - allocates rx skbs in rx descriptor chains
+ * spider_net_alloc_rx_skbs - Allocates rx skbs in rx descriptor chains
  * @card: card structure
  *
- * returns 0 on success, <0 on failure
+ * Returns 0 on success, <0 on failure.
  */
 static int
 spider_net_alloc_rx_skbs(struct spider_net_card *card)
@@ -471,17 +471,18 @@ spider_net_alloc_rx_skbs(struct spider_n
 	result = -ENOMEM;
 
 	chain = &card->rx_chain;
-	/* put at least one buffer into the chain. if this fails,
-	 * we've got a problem. if not, spider_net_refill_rx_chain
-	 * will do the rest at the end of this function */
+	/* Put at least one buffer into the chain. if this fails,
+	 * we've got a problem. If not, spider_net_refill_rx_chain
+	 * will do the rest at the end of this function. */
 	if (spider_net_prepare_rx_descr(card, chain->head))
 		goto error;
 	else
 		chain->head = chain->head->next;
 
-	/* this will allocate the rest of the rx buffers; if not, it's
-	 * business as usual later on */
+	/* This will allocate the rest of the rx buffers;
+	 * if not, it's business as usual later on. */
 	spider_net_refill_rx_chain(card);
+	spider_net_enable_rxchtails(card);
 	spider_net_enable_rxdmac(card);
 	return 0;
 
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
spidernet-rx-chain-tail.patch
spidernet-turn-rx-irq-back-on.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

