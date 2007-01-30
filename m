From: akpm@osdl.org
Subject: - b44-fix-frequent-link-changes.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:47:37 -0800
Message-ID: <200701302147.l0ULlbti030188@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51967 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbXA3Vrk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:47:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mchan@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     b44: Fix frequent link changes
has been removed from the -mm tree.  Its filename was
     b44-fix-frequent-link-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: b44: Fix frequent link changes
From: "Michael Chan" <mchan@broadcom.com>

This fixes the issue of frequent link changes under heavy traffic reported
below:

http://bugzilla.kernel.org/show_bug.cgi?id=7696
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=216338

The b44 chip occasionally needs to be reset when ISTAT_ERRORS are
encountered.  The reset sequence includes a PHY reset that will take many
seconds to complete and cause the link to go down and up.  By skipping the
PHY reset, it will greatly reduce the interruption when ISTAT_ERRORS are
encountered.

Change the full_reset parameter to reset_kind parameter in b44_init_hw(). 
This will allow PHY reset to be skipped when ISTAT_ERRORS are encountered.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/b44.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff -puN drivers/net/b44.c~b44-fix-frequent-link-changes drivers/net/b44.c
--- a/drivers/net/b44.c~b44-fix-frequent-link-changes
+++ a/drivers/net/b44.c
@@ -110,6 +110,11 @@ MODULE_DEVICE_TABLE(pci, b44_pci_tbl);
 
 static void b44_halt(struct b44 *);
 static void b44_init_rings(struct b44 *);
+
+#define B44_FULL_RESET		1
+#define B44_FULL_RESET_SKIP_PHY	2
+#define B44_PARTIAL_RESET	3
+
 static void b44_init_hw(struct b44 *, int);
 
 static int dma_desc_align_mask;
@@ -884,7 +889,7 @@ static int b44_poll(struct net_device *n
 		spin_lock_irqsave(&bp->lock, flags);
 		b44_halt(bp);
 		b44_init_rings(bp);
-		b44_init_hw(bp, 1);
+		b44_init_hw(bp, B44_FULL_RESET_SKIP_PHY);
 		netif_wake_queue(bp->dev);
 		spin_unlock_irqrestore(&bp->lock, flags);
 		done = 1;
@@ -954,7 +959,7 @@ static void b44_tx_timeout(struct net_de
 
 	b44_halt(bp);
 	b44_init_rings(bp);
-	b44_init_hw(bp, 1);
+	b44_init_hw(bp, B44_FULL_RESET);
 
 	spin_unlock_irq(&bp->lock);
 
@@ -1071,7 +1076,7 @@ static int b44_change_mtu(struct net_dev
 	b44_halt(bp);
 	dev->mtu = new_mtu;
 	b44_init_rings(bp);
-	b44_init_hw(bp, 1);
+	b44_init_hw(bp, B44_FULL_RESET);
 	spin_unlock_irq(&bp->lock);
 
 	b44_enable_ints(bp);
@@ -1368,12 +1373,12 @@ static int b44_set_mac_addr(struct net_d
  * packet processing.  Invoked with bp->lock held.
  */
 static void __b44_set_rx_mode(struct net_device *);
-static void b44_init_hw(struct b44 *bp, int full_reset)
+static void b44_init_hw(struct b44 *bp, int reset_kind)
 {
 	u32 val;
 
 	b44_chip_reset(bp);
-	if (full_reset) {
+	if (reset_kind == B44_FULL_RESET) {
 		b44_phy_reset(bp);
 		b44_setup_phy(bp);
 	}
@@ -1390,7 +1395,10 @@ static void b44_init_hw(struct b44 *bp, 
 	bw32(bp, B44_TXMAXLEN, bp->dev->mtu + ETH_HLEN + 8 + RX_HEADER_LEN);
 
 	bw32(bp, B44_TX_WMARK, 56); /* XXX magic */
-	if (full_reset) {
+	if (reset_kind == B44_PARTIAL_RESET) {
+		bw32(bp, B44_DMARX_CTRL, (DMARX_CTRL_ENABLE |
+				      (bp->rx_offset << DMARX_CTRL_ROSHIFT)));
+	} else {
 		bw32(bp, B44_DMATX_CTRL, DMATX_CTRL_ENABLE);
 		bw32(bp, B44_DMATX_ADDR, bp->tx_ring_dma + bp->dma_offset);
 		bw32(bp, B44_DMARX_CTRL, (DMARX_CTRL_ENABLE |
@@ -1401,9 +1409,6 @@ static void b44_init_hw(struct b44 *bp, 
 		bp->rx_prod = bp->rx_pending;
 
 		bw32(bp, B44_MIB_CTRL, MIB_CTRL_CLR_ON_READ);
-	} else {
-		bw32(bp, B44_DMARX_CTRL, (DMARX_CTRL_ENABLE |
-				      (bp->rx_offset << DMARX_CTRL_ROSHIFT)));
 	}
 
 	val = br32(bp, B44_ENET_CTRL);
@@ -1420,7 +1425,7 @@ static int b44_open(struct net_device *d
 		goto out;
 
 	b44_init_rings(bp);
-	b44_init_hw(bp, 1);
+	b44_init_hw(bp, B44_FULL_RESET);
 
 	b44_check_phy(bp);
 
@@ -1629,7 +1634,7 @@ static int b44_close(struct net_device *
 	netif_poll_enable(dev);
 
 	if (bp->flags & B44_FLAG_WOL_ENABLE) {
-		b44_init_hw(bp, 0);
+		b44_init_hw(bp, B44_PARTIAL_RESET);
 		b44_setup_wol(bp);
 	}
 
@@ -1905,7 +1910,7 @@ static int b44_set_ringparam(struct net_
 
 	b44_halt(bp);
 	b44_init_rings(bp);
-	b44_init_hw(bp, 1);
+	b44_init_hw(bp, B44_FULL_RESET);
 	netif_wake_queue(bp->dev);
 	spin_unlock_irq(&bp->lock);
 
@@ -1948,7 +1953,7 @@ static int b44_set_pauseparam(struct net
 	if (bp->flags & B44_FLAG_PAUSE_AUTO) {
 		b44_halt(bp);
 		b44_init_rings(bp);
-		b44_init_hw(bp, 1);
+		b44_init_hw(bp, B44_FULL_RESET);
 	} else {
 		__b44_set_flow_ctrl(bp, bp->flags);
 	}
@@ -2304,7 +2309,7 @@ static int b44_suspend(struct pci_dev *p
 
 	free_irq(dev->irq, dev);
 	if (bp->flags & B44_FLAG_WOL_ENABLE) {
-		b44_init_hw(bp, 0);
+		b44_init_hw(bp, B44_PARTIAL_RESET);
 		b44_setup_wol(bp);
 	}
 	pci_disable_device(pdev);
@@ -2329,7 +2334,7 @@ static int b44_resume(struct pci_dev *pd
 	spin_lock_irq(&bp->lock);
 
 	b44_init_rings(bp);
-	b44_init_hw(bp, 1);
+	b44_init_hw(bp, B44_FULL_RESET);
 	netif_device_attach(bp->dev);
 	spin_unlock_irq(&bp->lock);
 
_

Patches currently in -mm which might be from mchan@broadcom.com are

origin.patch
tg3-use-flush_keventd_work.patch
