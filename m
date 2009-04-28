From: akpm@linux-foundation.org
Subject: [merged] forcedeth-tx-timeout-fix.patch removed from -mm tree
Date: Tue, 28 Apr 2009 12:25:34 -0700
Message-ID: <200904281925.n3SJPYC7020926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930AbZD1T0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 15:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: tx timeout fix
has been removed from the -mm tree.  Its filename was
     forcedeth-tx-timeout-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forcedeth: tx timeout fix
From: Ayaz Abdulla <aabdulla@nvidia.com>

Fix tx_timeout() to properly handle the cleanup of the tx ring.  Also set
the tx put pointer back to the correct position to be in sync with HW.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-tx-timeout-fix drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-tx-timeout-fix
+++ a/drivers/net/forcedeth.c
@@ -1880,6 +1880,7 @@ static void nv_init_tx(struct net_device
 	np->tx_pkts_in_progress = 0;
 	np->tx_change_owner = NULL;
 	np->tx_end_flip = NULL;
+	np->tx_stop = 0;
 
 	for (i = 0; i < np->tx_ring_size; i++) {
 		if (!nv_optimized(np)) {
@@ -2530,6 +2531,8 @@ static void nv_tx_timeout(struct net_dev
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
 	u32 status;
+	union ring_type put_tx;
+	int saved_tx_limit;
 
 	if (np->msi_flags & NV_MSI_X_ENABLED)
 		status = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQSTAT_MASK;
@@ -2589,24 +2592,32 @@ static void nv_tx_timeout(struct net_dev
 	/* 1) stop tx engine */
 	nv_stop_tx(dev);
 
-	/* 2) check that the packets were not sent already: */
+	/* 2) complete any outstanding tx and do not give HW any limited tx pkts */
+	saved_tx_limit = np->tx_limit;
+	np->tx_limit = 0; /* prevent giving HW any limited pkts */
+	np->tx_stop = 0;  /* prevent waking tx queue */
 	if (!nv_optimized(np))
 		nv_tx_done(dev, np->tx_ring_size);
 	else
 		nv_tx_done_optimized(dev, np->tx_ring_size);
 
-	/* 3) if there are dead entries: clear everything */
-	if (np->get_tx_ctx != np->put_tx_ctx) {
-		printk(KERN_DEBUG "%s: tx_timeout: dead entries!\n", dev->name);
-		nv_drain_tx(dev);
-		nv_init_tx(dev);
-		setup_hw_rings(dev, NV_SETUP_TX_RING);
-	}
+	/* save current HW postion */
+	if (np->tx_change_owner)
+		put_tx.ex = np->tx_change_owner->first_tx_desc;
+	else
+		put_tx = np->put_tx;
 
-	netif_wake_queue(dev);
+	/* 3) clear all tx state */
+	nv_drain_tx(dev);
+	nv_init_tx(dev);
+
+	/* 4) restore state to current HW position */
+	np->get_tx = np->put_tx = put_tx;
+	np->tx_limit = saved_tx_limit;
 
-	/* 4) restart tx engine */
+	/* 5) restart tx engine */
 	nv_start_tx(dev);
+	netif_wake_queue(dev);
 	spin_unlock_irq(&np->lock);
 }
 
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

linux-next.patch
forcedeth-add-clock-gating-feature.patch
forcedeth-add-clock-gating-feature-checkpatch-fixes.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch

