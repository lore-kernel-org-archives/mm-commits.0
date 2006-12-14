From: akpm@osdl.org
Subject: - spidernet-rework-rx-linked-list.patch removed from -mm tree
Date: Wed, 13 Dec 2006 16:21:29 -0800
Message-ID: <200612140021.kBE0LTTo026001@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33642 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbWLNAbI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:31:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: rework RX linked list
has been removed from the -mm tree.  Its filename was
     spidernet-rework-rx-linked-list.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: spidernet: rework RX linked list
From: Linas Vepstas <linas@austin.ibm.com>

Make the hardware perceive the RX descriptor ring as a null-terminated linked
list, instead of a circular ring.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-rework-rx-linked-list drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-rework-rx-linked-list
+++ a/drivers/net/spider_net.c
@@ -389,9 +389,13 @@ spider_net_prepare_rx_descr(struct spide
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
@@ -1676,12 +1680,6 @@ spider_net_open(struct net_device *netde
 					+ card->num_tx_desc * sizeof(struct spider_net_descr),
 	                          card->num_rx_desc);
 
-	descr = card->rx_chain.head;
-	do {
-		descr->next_descr_addr = descr->next->bus_addr;
-		descr = descr->next;
-	} while (descr != card->rx_chain.head);
-
 	/* allocate rx skbs */
 	if (spider_net_alloc_rx_skbs(card))
 		goto alloc_skbs_failed;
_

Patches currently in -mm which might be from linas@austin.ibm.com are

origin.patch
spidernet-rework-rx-linked-list.patch

