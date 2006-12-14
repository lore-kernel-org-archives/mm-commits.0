From: akpm@osdl.org
Subject: - spidernet-refactor-rx-refill.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:20:54 -0800
Message-ID: <200612140020.kBE0KsbP025954@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbWLNA0S (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:26:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: refactor RX refill
has been removed from the -mm tree.  Its filename was
     spidernet-refactor-rx-refill.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: spidernet: refactor RX refill
From: Linas Vepstas <linas@austin.ibm.com>

Refactor how spider_net_refill_rx_chain() is called.  No functional change;
this just simplifies the code by moving the subroutine call to a more
appropriate spot.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-refactor-rx-refill drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-refactor-rx-refill
+++ a/drivers/net/spider_net.c
@@ -1023,10 +1023,8 @@ spider_net_decode_one_descr(struct spide
 	/* ok, we've got a packet in descr */
 	result = spider_net_pass_skb_up(descr, card, napi);
 refill:
-	descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 	/* change the descriptor state: */
-	if (!napi)
-		spider_net_refill_rx_chain(card);
+	descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 	return result;
 }
 
@@ -1205,8 +1203,11 @@ spider_net_set_mac(struct net_device *ne
 static void
 spider_net_handle_rxram_full(struct spider_net_card *card)
 {
-	while (spider_net_decode_one_descr(card, 0))
-		;
+	int rc = 1;
+	while (rc) {
+		rc = spider_net_decode_one_descr(card, 0);
+		spider_net_refill_rx_chain(card);
+	}
 	spider_net_enable_rxchtails(card);
 	spider_net_enable_rxdmac(card);
 	netif_rx_schedule(card->netdev);
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
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

