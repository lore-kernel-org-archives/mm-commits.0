From: akpm@osdl.org
Subject: - spidernet-turn-rx-irq-back-on.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:21:18 -0800
Message-ID: <200612140021.kBE0LIEl025982@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33094 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbWLNAWy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:22:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: turn RX irq back on
has been removed from the -mm tree.  Its filename was
     spidernet-turn-rx-irq-back-on.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: spidernet: turn RX irq back on
From: Linas Vepstas <linas@austin.ibm.com>

Re-enable irq's after emptying the RX ring; these had been previously turned
off on reception of the rxram_full interrupt.  More punctuation cleanup.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-turn-rx-irq-back-on drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-turn-rx-irq-back-on
+++ a/drivers/net/spider_net.c
@@ -1182,12 +1182,11 @@ spider_net_set_mac(struct net_device *ne
 }
 
 /**
- * spider_net_handle_rxram_full - cleans up RX ring upon RX RAM full interrupt
+ * spider_net_handle_rxram_full - Clean RX ring on RX RAM full interrupt
  * @card: card structure
  *
- * spider_net_handle_rxram_full empties the RX ring so that spider can put
- * more packets in it and empty its RX RAM. This is called in bottom half
- * context
+ * Empty the RX ring so that the hardware can put more packets
+ * in it and empty its RX RAM. This is called in bottom half context.
  */
 static void
 spider_net_handle_rxram_full(struct spider_net_card *card)
@@ -1198,6 +1197,7 @@ spider_net_handle_rxram_full(struct spid
 	spider_net_enable_rxchtails(card);
 	spider_net_enable_rxdmac(card);
 	netif_rx_schedule(card->netdev);
+	spider_net_rx_irq_on(card);
 }
 
 /**
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
spidernet-turn-rx-irq-back-on.patch
spidernet-memory-barrier.patch
spidernet-avoid-possible-rx-chain-corruption.patch
spidernet-rx-debugging-printout.patch
spidernet-rework-rx-linked-list.patch

