From: akpm@osdl.org
Subject: + spidernet-turn-rx-irq-back-on.patch added to -mm tree
Date: Wed, 06 Dec 2006 21:36:58 -0800
Message-ID: <200612070536.kB75awU7031692@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51146 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031335AbWLGFrb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:47:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com


The patch titled
     spidernet: turn RX irq back on
has been added to the -mm tree.  Its filename is
     spidernet-turn-rx-irq-back-on.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

