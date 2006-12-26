From: akpm@osdl.org
Subject: - spidernet-memory-barrier.patch removed from -mm tree
Date: Tue, 26 Dec 2006 15:19:19 -0800
Message-ID: <200612262319.kBQNJJ6X027808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37483 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932851AbWLZXT3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Dec 2006 18:19:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linas@austin.ibm.com, arnd@arndb.de, jklewis@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Spidernet: Memory barrier
has been removed from the -mm tree.  Its filename was
     spidernet-memory-barrier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Spidernet: Memory barrier
From: Linas Vepstas <linas@austin.ibm.com>

Add memory barrier to make sure that the rest of the RX descriptor state is
flushed to memory before we tell the hardware that its ready to go.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Cc: James K Lewis <jklewis@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/net/spider_net.c~spidernet-memory-barrier drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-memory-barrier
+++ a/drivers/net/spider_net.c
@@ -419,6 +419,7 @@ spider_net_prepare_rx_descr(struct spide
 		card->spider_stats.rx_iommu_map_error++;
 		descr->dmac_cmd_status = SPIDER_NET_DESCR_NOT_IN_USE;
 	} else {
+		wmb();
 		descr->dmac_cmd_status = SPIDER_NET_DESCR_CARDOWNED |
 					 SPIDER_NET_DMAC_NOINTR_COMPLETE;
 	}
_

Patches currently in -mm which might be from linas@austin.ibm.com are

git-netdev-all.patch
spidernet-rework-rx-linked-list.patch

