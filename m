From: akpm@osdl.org
Subject: - forcedeth-tx-max-work.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:52:16 -0800
Message-ID: <200701260752.l0Q7qG29010821@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030829AbXAZHwU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:52:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: tx max work
has been removed from the -mm tree.  Its filename was
     forcedeth-tx-max-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: forcedeth: tx max work
From: Ayaz Abdulla <aabdulla@nvidia.com>

Add a limit to how much tx work can be done in each iteration of tx
processing.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/forcedeth.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-tx-max-work drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-tx-max-work
+++ a/drivers/net/forcedeth.c
@@ -1859,14 +1859,15 @@ static void nv_tx_done(struct net_device
 	}
 }
 
-static void nv_tx_done_optimized(struct net_device *dev)
+static void nv_tx_done_optimized(struct net_device *dev, int limit)
 {
 	struct fe_priv *np = netdev_priv(dev);
 	u32 flags;
 	struct ring_desc_ex* orig_get_tx = np->get_tx.ex;
 
 	while ((np->get_tx.ex != np->put_tx.ex) &&
-	       !((flags = le32_to_cpu(np->get_tx.ex->flaglen)) & NV_TX_VALID)) {
+	       !((flags = le32_to_cpu(np->get_tx.ex->flaglen)) & NV_TX_VALID) &&
+	       (limit-- > 0)) {
 
 		dprintk(KERN_DEBUG "%s: nv_tx_done_optimized: flags 0x%x.\n",
 					dev->name, flags);
@@ -1973,7 +1974,7 @@ static void nv_tx_timeout(struct net_dev
 	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2)
 		nv_tx_done(dev);
 	else
-		nv_tx_done_optimized(dev);
+		nv_tx_done_optimized(dev, np->tx_ring_size);
 
 	/* 3) if there are dead entries: clear everything */
 	if (np->get_tx_ctx != np->put_tx_ctx) {
@@ -2899,7 +2900,7 @@ static irqreturn_t nv_nic_irq_optimized(
 			break;
 
 		spin_lock(&np->lock);
-		nv_tx_done_optimized(dev);
+		nv_tx_done_optimized(dev, TX_WORK_PER_LOOP);
 		spin_unlock(&np->lock);
 
 #ifdef CONFIG_FORCEDETH_NAPI
@@ -3006,7 +3007,7 @@ static irqreturn_t nv_nic_irq_tx(int foo
 			break;
 
 		spin_lock_irqsave(&np->lock, flags);
-		nv_tx_done_optimized(dev);
+		nv_tx_done_optimized(dev, TX_WORK_PER_LOOP);
 		spin_unlock_irqrestore(&np->lock, flags);
 
 		if (unlikely(events & (NVREG_IRQ_TX_ERR))) {
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

git-netdev-all.patch
