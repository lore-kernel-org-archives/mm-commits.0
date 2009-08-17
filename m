From: akpm@linux-foundation.org
Subject: [merged] korina-add-error-handling-to-korina_alloc_ring.patch removed from -mm tree
Date: Mon, 17 Aug 2009 13:04:54 -0700
Message-ID: <200908172004.n7HK4sXI017440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755239AbZHQUF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 16:05:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n0-1@freewrt.org, roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     korina: add error-handling to korina_alloc_ring
has been removed from the -mm tree.  Its filename was
     korina-add-error-handling-to-korina_alloc_ring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: korina: add error-handling to korina_alloc_ring
From: Phil Sutter <n0-1@freewrt.org>

This also avoids a potential buffer overflow in case the very first
receive descriptor fails to allocate, as an index of -1 would be used
afterwards. Kudos to Roel Kluin for pointing this out and providing an
initial patch.

Signed-off-by: Phil Sutter <n0-1@freewrt.org>
Cc: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/korina.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/net/korina.c~korina-add-error-handling-to-korina_alloc_ring drivers/net/korina.c
--- a/drivers/net/korina.c~korina-add-error-handling-to-korina_alloc_ring
+++ a/drivers/net/korina.c
@@ -750,7 +750,7 @@ static struct ethtool_ops netdev_ethtool
 	.get_link               = netdev_get_link,
 };
 
-static void korina_alloc_ring(struct net_device *dev)
+static int korina_alloc_ring(struct net_device *dev)
 {
 	struct korina_private *lp = netdev_priv(dev);
 	struct sk_buff *skb;
@@ -771,7 +771,7 @@ static void korina_alloc_ring(struct net
 	for (i = 0; i < KORINA_NUM_RDS; i++) {
 		skb = dev_alloc_skb(KORINA_RBSIZE + 2);
 		if (!skb)
-			break;
+			return -ENOMEM;
 		skb_reserve(skb, 2);
 		lp->rx_skb[i] = skb;
 		lp->rd_ring[i].control = DMA_DESC_IOD |
@@ -790,6 +790,8 @@ static void korina_alloc_ring(struct net
 	lp->rx_chain_head = 0;
 	lp->rx_chain_tail = 0;
 	lp->rx_chain_status = desc_empty;
+
+	return 0;
 }
 
 static void korina_free_ring(struct net_device *dev)
@@ -832,7 +834,11 @@ static int korina_init(struct net_device
 	writel(ETH_INT_FC_EN, &lp->eth_regs->ethintfc);
 
 	/* Allocate rings */
-	korina_alloc_ring(dev);
+	if (korina_alloc_ring(dev)) {
+		printk(KERN_ERR "%s: descriptor allocation failed\n", dev->name);
+		korina_free_ring(dev);
+		return -ENOMEM;
+	}
 
 	writel(0, &lp->rx_dma_regs->dmas);
 	/* Start Rx DMA */
_

Patches currently in -mm which might be from n0-1@freewrt.org are

linux-next.patch

