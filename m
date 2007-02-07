From: akpm@linux-foundation.org
Subject: - spidernet-rework-rx-linked-list.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:53:02 -0800
Message-ID: <200702071953.l17Jr2p1025287@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33875 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422916AbXBGT4Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:56:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Spidernet: Rework RX linked list
has been removed from the -mm tree.  Its filename was
     spidernet-rework-rx-linked-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Spidernet: Rework RX linked list
From: Linas Vepstas <linas@austin.ibm.com>

Make the hardware perceive the RX descriptor ring as a null-terminated linked
list, instead of a circular ring.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/spider_net.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-rework-rx-linked-list drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-rework-rx-linked-list
+++ a/drivers/net/spider_net.c
@@ -419,9 +419,13 @@ spider_net_prepare_rx_descr(struct spide
 		card->spider_stats.rx_iommu_map_error++;
 		descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 	} else {
+		descr->next_descr_addr = 0;
 		wmb();
 		descr->dmac_cmd_status = SPIDER_NET_DESCR_CARDOWNED |
 					 SPIDER_NET_DMAC_NOINTR_COMPLETE;
+
+		wmb();
+		descr->prev->next_descr_addr = descr->bus_addr;
 	}
 
 	return 0;
@@ -1650,7 +1654,6 @@ int
 spider_net_open(struct net_device *netdev)
 {
 	struct spider_net_card *card = netdev_priv(netdev);
-	struct spider_net_descr *descr;
 	int result;
 
 	result = spider_net_init_chain(card, &card->tx_chain);
@@ -1662,13 +1665,6 @@ spider_net_open(struct net_device *netde
 	if (result)
 		goto alloc_rx_failed;
 
-	/* Make a ring of of bus addresses */
-	descr = card->rx_chain.ring;
-	do {
-		descr->next_descr_addr = descr->next->bus_addr;
-		descr = descr->next;
-	} while (descr != card->rx_chain.ring);
-
 	/* Allocate rx skbs */
 	if (spider_net_alloc_rx_skbs(card))
 		goto alloc_skbs_failed;
_

Patches currently in -mm which might be from linas@austin.ibm.com are

git-powerpc.patch
git-netdev-all.patch
