From: akpm@osdl.org
Subject: - spidernet-rx-refill.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:21:09 -0800
Message-ID: <200612140021.kBE0L9b3025968@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:32936 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbWLNAVO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:21:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: RX Refill
has been removed from the -mm tree.  Its filename was
     spidernet-rx-refill.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: spidernet: RX Refill
From: Linas Vepstas <linas@austin.ibm.com>

The invocation of the rx ring refill routine is haphazard; centralize and make
its usage consistent.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-rx-refill drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-rx-refill
+++ a/drivers/net/spider_net.c
@@ -968,8 +968,6 @@ spider_net_decode_one_descr(struct spide
 	if (status == SPIDER_NET_DESCR_NOT_IN_USE) {
 		/* not initialized yet, the ring must be empty */
 		spin_unlock_irqrestore(&chain->lock, flags);
-		spider_net_refill_rx_chain(card);
-		spider_net_enable_rxdmac(card);
 		return 0;
 	}
 
@@ -1058,6 +1056,7 @@ spider_net_poll(struct net_device *netde
 	netdev->quota -= packets_done;
 	*budget -= packets_done;
 	spider_net_refill_rx_chain(card);
+	spider_net_enable_rxdmac(card);
 
 	/* if all packets are in the stack, enable interrupts and return 0 */
 	/* if not, return 1 */
@@ -1197,11 +1196,9 @@ spider_net_set_mac(struct net_device *ne
 static void
 spider_net_handle_rxram_full(struct spider_net_card *card)
 {
-	int rc = 1;
-	while (rc) {
-		rc = spider_net_decode_one_descr(card, 0);
-		spider_net_refill_rx_chain(card);
-	}
+	while (spider_net_decode_one_descr(card, 0));
+
+	spider_net_refill_rx_chain(card);
 	spider_net_enable_rxchtails(card);
 	spider_net_enable_rxdmac(card);
 	netif_rx_schedule(card->netdev);
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
spidernet-rx-refill.patch
spidernet-merge-error-branches.patch
spidernet-remove-unused-variable.patch
spidernet-rx-chain-tail.patch
spidernet-turn-rx-irq-back-on.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

