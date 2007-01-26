From: akpm@osdl.org
Subject: - forcedeth-tx-limiting.patch removed from -mm tree
Date: Thu, 25 Jan 2007 23:52:08 -0800
Message-ID: <200701260752.l0Q7q8JM010809@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50540 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030826AbXAZHwQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 02:52:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: tx limiting
has been removed from the -mm tree.  Its filename was
     forcedeth-tx-limiting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: forcedeth: tx limiting
From: Ayaz Abdulla <aabdulla@nvidia.com>

Optimize the logic for tx limiting.  It adds a flag to check on the completion
side instead of recalculating the number of empty slots.  Also, it removes the
fields that were previous used for limiting since they have no value.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/forcedeth.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-tx-limiting drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-tx-limiting
+++ a/drivers/net/forcedeth.c
@@ -518,12 +518,6 @@ union ring_type {
 #define TX_RING_MIN		64
 #define RING_MAX_DESC_VER_1	1024
 #define RING_MAX_DESC_VER_2_3	16384
-/*
- * Difference between the get and put pointers for the tx ring.
- * This is used to throttle the amount of data outstanding in the
- * tx ring.
- */
-#define TX_LIMIT_DIFFERENCE	1
 
 /* rx/tx mac addr + type + vlan + align + slack*/
 #define NV_RX_HEADERS		(64)
@@ -777,8 +771,7 @@ struct fe_priv {
 	union ring_type tx_ring;
 	u32 tx_flags;
 	int tx_ring_size;
-	int tx_limit_start;
-	int tx_limit_stop;
+	int tx_stop;
 
 	/* vlan fields */
 	struct vlan_group *vlangrp;
@@ -1583,9 +1576,10 @@ static int nv_start_xmit(struct sk_buff 
 	}
 
 	empty_slots = nv_get_empty_tx_slots(np);
-	if ((empty_slots - np->tx_limit_stop) <= entries) {
+	if (empty_slots <= entries) {
 		spin_lock_irq(&np->lock);
 		netif_stop_queue(dev);
+		np->tx_stop = 1;
 		spin_unlock_irq(&np->lock);
 		return NETDEV_TX_BUSY;
 	}
@@ -1704,9 +1698,10 @@ static int nv_start_xmit_optimized(struc
 	}
 
 	empty_slots = nv_get_empty_tx_slots(np);
-	if ((empty_slots - np->tx_limit_stop) <= entries) {
+	if (empty_slots <= entries) {
 		spin_lock_irq(&np->lock);
 		netif_stop_queue(dev);
+		np->tx_stop = 1;
 		spin_unlock_irq(&np->lock);
 		return NETDEV_TX_BUSY;
 	}
@@ -1813,6 +1808,7 @@ static void nv_tx_done(struct net_device
 	struct fe_priv *np = netdev_priv(dev);
 	u32 flags;
 	struct sk_buff *skb;
+	struct ring_desc* orig_get_tx = np->get_tx.orig;
 
  	while (np->get_tx.orig != np->put_tx.orig) {
 		flags = le32_to_cpu(np->get_tx.orig->flaglen);
@@ -1858,8 +1854,10 @@ static void nv_tx_done(struct net_device
 		if (np->get_tx_ctx++ == np->last_tx_ctx)
 			np->get_tx_ctx = np->first_tx_ctx;
 	}
-	if (nv_get_empty_tx_slots(np) > np->tx_limit_start)
+	if ((np->tx_stop == 1) && (np->get_tx.orig != orig_get_tx)) {
+		np->tx_stop = 0;
 		netif_wake_queue(dev);
+	}
 }
 
 static void nv_tx_done_optimized(struct net_device *dev)
@@ -1867,6 +1865,7 @@ static void nv_tx_done_optimized(struct 
 	struct fe_priv *np = netdev_priv(dev);
 	u32 flags;
 	struct sk_buff *skb;
+	struct ring_desc_ex* orig_get_tx = np->get_tx.ex;
 
  	while (np->get_tx.ex == np->put_tx.ex) {
 		flags = le32_to_cpu(np->get_tx.ex->flaglen);
@@ -1895,8 +1894,10 @@ static void nv_tx_done_optimized(struct 
 		if (np->get_tx_ctx++ == np->last_tx_ctx)
 			np->get_tx_ctx = np->first_tx_ctx;
 	}
-	if (nv_get_empty_tx_slots(np) > np->tx_limit_start)
+	if ((np->tx_stop == 1) && (np->get_tx.ex != orig_get_tx)) {
+		np->tx_stop = 0;
 		netif_wake_queue(dev);
+	}
 }
 
 /*
@@ -4001,8 +4002,6 @@ static int nv_set_ringparam(struct net_d
 	/* set new values */
 	np->rx_ring_size = ring->rx_pending;
 	np->tx_ring_size = ring->tx_pending;
-	np->tx_limit_stop = TX_LIMIT_DIFFERENCE;
-	np->tx_limit_start = TX_LIMIT_DIFFERENCE;
 	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
 		np->rx_ring.orig = (struct ring_desc*)rxtx_ring;
 		np->tx_ring.orig = &np->rx_ring.orig[np->rx_ring_size];
@@ -4967,8 +4966,6 @@ static int __devinit nv_probe(struct pci
 
 	np->rx_ring_size = RX_RING_DEFAULT;
 	np->tx_ring_size = TX_RING_DEFAULT;
-	np->tx_limit_stop = TX_LIMIT_DIFFERENCE;
-	np->tx_limit_start = TX_LIMIT_DIFFERENCE;
 
 	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
 		np->rx_ring.orig = pci_alloc_consistent(pci_dev,
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

git-netdev-all.patch
