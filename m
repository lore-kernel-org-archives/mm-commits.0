From: akpm@linux-foundation.org
Subject: + forcedeth-fix-tx-timeout.patch added to -mm tree
Date: Sat, 24 Mar 2007 23:45:39 -0800
Message-ID: <200703250745.l2P7jdMd023098@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35286 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbXCYHpl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 03:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aabdulla@nvidia.com


The patch titled
     forcedeth: fix tx timeout
has been added to the -mm tree.  Its filename is
     forcedeth-fix-tx-timeout.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2053,9 +2053,10 @@ static void nv_tx_timeout(struct net_dev
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

forcedeth-fix-nic-poll.patch
forcedeth-fix-tx-timeout.patch
