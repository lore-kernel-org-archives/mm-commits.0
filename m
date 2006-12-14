From: akpm@osdl.org
Subject: + spidernet-remove-rxramfull-tasklet.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:26:02 -0800
Message-ID: <200612140026.kBE0Q22G026130@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33806 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbWLNAeU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:34:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com


The patch titled
     Spidernet: remove rxramfull tasklet
has been added to the -mm tree.  Its filename is
     spidernet-remove-rxramfull-tasklet.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Spidernet: remove rxramfull tasklet
From: Linas Vepstas <linas@austin.ibm.com>

Get rid of the rxramfull tasklet, and let the NAPI poll routine deal with this
situation.  (The rxramfull interrupt is simply stating that the h/w has run
out of room for incoming packets).

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   24 +-----------------------
 drivers/net/spider_net.h |    1 -
 2 files changed, 1 insertion(+), 24 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-remove-rxramfull-tasklet drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-remove-rxramfull-tasklet
+++ a/drivers/net/spider_net.c
@@ -1221,24 +1221,6 @@ spider_net_set_mac(struct net_device *ne
 }
 
 /**
- * spider_net_handle_rxram_full - cleans up RX ring upon RX RAM full interrupt
- * @card: card structure
- *
- * spider_net_handle_rxram_full empties the RX ring so that spider can put
- * more packets in it and empty its RX RAM. This is called in bottom half
- * context
- */
-static void
-spider_net_handle_rxram_full(struct spider_net_card *card)
-{
-	while (spider_net_decode_one_descr(card, 0))
-		;
-	spider_net_enable_rxchtails(card);
-	spider_net_enable_rxdmac(card);
-	netif_rx_schedule(card->netdev);
-}
-
-/**
  * spider_net_handle_error_irq - handles errors raised by an interrupt
  * @card: card structure
  * @status_reg: interrupt status register 0 (GHIINT0STS)
@@ -1363,7 +1345,7 @@ spider_net_handle_error_irq(struct spide
 			pr_err("Spider RX RAM full, incoming packets "
 			       "might be discarded!\n");
 		spider_net_rx_irq_off(card);
-		tasklet_schedule(&card->rxram_full_tl);
+		netif_rx_schedule(card->netdev);
 		show_error = 0;
 		break;
 
@@ -1895,7 +1877,6 @@ spider_net_stop(struct net_device *netde
 {
 	struct spider_net_card *card = netdev_priv(netdev);
 
-	tasklet_kill(&card->rxram_full_tl);
 	netif_poll_disable(netdev);
 	netif_carrier_off(netdev);
 	netif_stop_queue(netdev);
@@ -2038,9 +2019,6 @@ spider_net_setup_netdev(struct spider_ne
 
 	pci_set_drvdata(card->pdev, netdev);
 
-	card->rxram_full_tl.data = (unsigned long) card;
-	card->rxram_full_tl.func =
-		(void (*)(unsigned long)) spider_net_handle_rxram_full;
 	init_timer(&card->tx_timer);
 	card->tx_timer.function =
 		(void (*)(unsigned long)) spider_net_cleanup_tx_ring;
diff -puN drivers/net/spider_net.h~spidernet-remove-rxramfull-tasklet drivers/net/spider_net.h
--- a/drivers/net/spider_net.h~spidernet-remove-rxramfull-tasklet
+++ a/drivers/net/spider_net.h
@@ -442,7 +442,6 @@ struct spider_net_card {
 	struct spider_net_descr_chain rx_chain;
 	struct spider_net_descr *low_watermark;
 
-	struct tasklet_struct rxram_full_tl;
 	struct timer_list tx_timer;
 	struct work_struct tx_timeout_task;
 	atomic_t tx_timeout_task_counter;
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

