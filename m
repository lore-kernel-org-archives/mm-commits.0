From: akpm@linux-foundation.org
Subject: - sundance-siocdevprivate-pollution.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:53:35 -0800
Message-ID: <200711060553.lA65rZLf007507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43046 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753958AbXKFF4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:56:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, jeff@garzik.org, jesse@icplus.com.tw, vsauer@dvs.tu-darmstadt.de, mm-commits@vger.kernel.org


The patch titled
     sundance: SIOCDEVPRIVATE pollution
has been removed from the -mm tree.  Its filename was
     sundance-siocdevprivate-pollution.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sundance: SIOCDEVPRIVATE pollution
From: Francois Romieu <romieu@fr.zoreil.com>

To quote one of my favorite contemporary author:
[include/linux/sockios.h]
 *      THESE IOCTLS ARE _DEPRECATED_ AND WILL DISAPPEAR IN 2.5.X -DaveM
 */

#define SIOCDEVPRIVATE  0x89F0  /* to 89FF */

[...]

Gentoo's snmpd trips up over this code when trying to figure if the driver
supports the non-SIOCDEVPRIVATE API or not.  One can argue over its choice
of heuristic but there no reason to make ioctl more ugly than needed.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jesse Huang <jesse@icplus.com.tw>
Tested-by: Volker Sauer <vsauer@dvs.tu-darmstadt.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sundance.c |   26 --------------------------
 1 file changed, 26 deletions(-)

diff -puN drivers/net/sundance.c~sundance-siocdevprivate-pollution drivers/net/sundance.c
--- a/drivers/net/sundance.c~sundance-siocdevprivate-pollution
+++ a/drivers/net/sundance.c
@@ -1596,9 +1596,7 @@ static const struct ethtool_ops ethtool_
 static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct netdev_private *np = netdev_priv(dev);
-	void __iomem *ioaddr = np->base;
 	int rc;
-	int i;
 
 	if (!netif_running(dev))
 		return -EINVAL;
@@ -1606,30 +1604,6 @@ static int netdev_ioctl(struct net_devic
 	spin_lock_irq(&np->lock);
 	rc = generic_mii_ioctl(&np->mii_if, if_mii(rq), cmd, NULL);
 	spin_unlock_irq(&np->lock);
-	switch (cmd) {
-		case SIOCDEVPRIVATE:
-		for (i=0; i<TX_RING_SIZE; i++) {
-			printk(KERN_DEBUG "%02x %08llx %08x %08x(%02x) %08x %08x\n", i,
-				(unsigned long long)(np->tx_ring_dma + i*sizeof(*np->tx_ring)),
-				le32_to_cpu(np->tx_ring[i].next_desc),
-				le32_to_cpu(np->tx_ring[i].status),
-				(le32_to_cpu(np->tx_ring[i].status) >> 2)
-					& 0xff,
-				le32_to_cpu(np->tx_ring[i].frag[0].addr),
-				le32_to_cpu(np->tx_ring[i].frag[0].length));
-		}
-		printk(KERN_DEBUG "TxListPtr=%08x netif_queue_stopped=%d\n",
-			ioread32(np->base + TxListPtr),
-			netif_queue_stopped(dev));
-		printk(KERN_DEBUG "cur_tx=%d(%02x) dirty_tx=%d(%02x)\n",
-			np->cur_tx, np->cur_tx % TX_RING_SIZE,
-			np->dirty_tx, np->dirty_tx % TX_RING_SIZE);
-		printk(KERN_DEBUG "cur_rx=%d dirty_rx=%d\n", np->cur_rx, np->dirty_rx);
-		printk(KERN_DEBUG "cur_task=%d\n", np->cur_task);
-		printk(KERN_DEBUG "TxStatus=%04x\n", ioread16(ioaddr + TxStatus));
-			return 0;
-	}
-
 
 	return rc;
 }
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

origin.patch
git-netdev-all.patch
