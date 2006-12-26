From: akpm@osdl.org
Subject: - spidernet-rx-refill.patch removed from -mm tree
Date: Tue, 26 Dec 2006 15:19:14 -0800
Message-ID: <200612262319.kBQNJEc7027799@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37471 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854AbWLZXTX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Dec 2006 18:19:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Spidernet: RX Refill
has been removed from the -mm tree.  Its filename was
     spidernet-rx-refill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Spidernet: RX Refill
From: Linas Vepstas <linas@austin.ibm.com>

The invocation of the rx ring refill routine is haphazard, it can be called
from a central location.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-rx-refill drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-rx-refill
+++ a/drivers/net/spider_net.c
@@ -980,17 +980,11 @@ spider_net_decode_one_descr(struct spide
 
 	status = spider_net_get_descr_status(descr);
 
-	/* nothing in the descriptor yet */
-	if (status == SPIDER_NET_DESCR_CARDOWNED)
+	/* Nothing in the descriptor, or ring must be empty */
+	if ((status == SPIDER_NET_DESCR_CARDOWNED) ||
+	    (status == SPIDER_NET_DESCR_NOT_IN_USE))
 		return 0;
 
-	if (status == SPIDER_NET_DESCR_NOT_IN_USE) {
-		/* not initialized yet, the ring must be empty */
-		spider_net_refill_rx_chain(card);
-		spider_net_enable_rxdmac(card);
-		return 0;
-	}
-
 	/* descriptor definitively used -- move on tail */
 	chain->tail = descr->next;
 
@@ -1074,6 +1068,7 @@ spider_net_poll(struct net_device *netde
 	netdev->quota -= packets_done;
 	*budget -= packets_done;
 	spider_net_refill_rx_chain(card);
+	spider_net_enable_rxdmac(card);
 
 	/* if all packets are in the stack, enable interrupts and return 0 */
 	/* if not, return 1 */
_

Patches currently in -mm which might be from linas@austin.ibm.com are

git-netdev-all.patch
spidernet-rework-rx-linked-list.patch

