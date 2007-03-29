From: akpm@linux-foundation.org
Subject: - forcedeth-fix-tx-timeout.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:43:11 -0700
Message-ID: <200703290743.l2T7hBZB030364@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46199 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965030AbXC2HnW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:43:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: fix tx timeout
has been removed from the -mm tree.  Its filename was
     forcedeth-fix-tx-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: forcedeth: fix tx timeout
From: Ayaz Abdulla <aabdulla@nvidia.com>

The tx timeout routine was waking the tx queue conditionally.  However, it
must call it unconditionally since the dev_watchdog has halted the tx queue
before calling the timeout function.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/forcedeth.c~forcedeth-fix-tx-timeout drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-fix-tx-timeout
+++ a/drivers/net/forcedeth.c
@@ -2050,9 +2050,10 @@ static void nv_tx_timeout(struct net_dev
 		nv_drain_tx(dev);
 		nv_init_tx(dev);
 		setup_hw_rings(dev, NV_SETUP_TX_RING);
-		netif_wake_queue(dev);
 	}
 
+	netif_wake_queue(dev);
+
 	/* 4) restart tx engine */
 	nv_start_tx(dev);
 	spin_unlock_irq(&np->lock);
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

origin.patch
forcedeth-work-around-null-skb-dereference-crash.patch
