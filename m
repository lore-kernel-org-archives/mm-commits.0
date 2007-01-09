From: akpm@osdl.org
Subject: + forcedeth-tx-locking.patch added to -mm tree
Date: Tue, 09 Jan 2007 13:36:36 -0800
Message-ID: <200701092136.l09LaaHj016065@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45835 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456AbXAIVgm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 16:36:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aabdulla@nvidia.com


The patch titled
     forcedeth: tx locking
has been added to the -mm tree.  Its filename is
     forcedeth-tx-locking.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth: tx locking
From: Ayaz Abdulla <aabdulla@nvidia.com>

Reduce the amount of code within the lock to only the critical sections.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/forcedeth.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-tx-locking drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-tx-locking
+++ a/drivers/net/forcedeth.c
@@ -1569,12 +1569,11 @@ static int nv_start_xmit(struct sk_buff 
 			   ((skb_shinfo(skb)->frags[i].size & (NV_TX2_TSO_MAX_SIZE-1)) ? 1 : 0);
 	}
 
-	spin_lock_irq(&np->lock);
-
 	empty_slots = nv_get_empty_tx_slots(np);
 	if ((empty_slots - np->tx_limit_stop) <= entries) {
-		spin_unlock_irq(&np->lock);
+		spin_lock_irq(&np->lock);
 		netif_stop_queue(dev);
+		spin_unlock_irq(&np->lock);
 		return NETDEV_TX_BUSY;
 	}
 
@@ -1669,6 +1668,8 @@ static int nv_start_xmit(struct sk_buff 
 		tx_flags_vlan = NV_TX3_VLAN_TAG_PRESENT | vlan_tx_tag_get(skb);
 	}
 
+	spin_lock_irq(&np->lock);
+
 	/* set tx flags */
 	if (np->desc_ver == DESC_VER_1 || np->desc_ver == DESC_VER_2) {
 		start_tx.orig->flaglen |= cpu_to_le32(tx_flags | tx_flags_extra);
@@ -1679,6 +1680,7 @@ static int nv_start_xmit(struct sk_buff 
 		np->put_tx.ex = put_tx.ex;
 	}
 
+	spin_unlock_irq(&np->lock);
 
 	dprintk(KERN_DEBUG "%s: nv_start_xmit: entries %d queued for transmission. tx_flags_extra: %x\n",
 		dev->name, entries, tx_flags_extra);
@@ -1693,7 +1695,6 @@ static int nv_start_xmit(struct sk_buff 
 	}
 
 	dev->trans_start = jiffies;
-	spin_unlock_irq(&np->lock);
 	writel(NVREG_TXRXCTL_KICK|np->txrxctl_bits, get_hwbase(dev) + NvRegTxRxControl);
 	pci_push(get_hwbase(dev));
 	return NETDEV_TX_OK;
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

origin.patch
forcedeth-dma-access.patch
forcedeth-ring-access.patch
forcedeth-tx-locking.patch
forcedeth-rx-skb-recycle.patch
forcedeth-optimized-routines.patch
forcedeth-tx-limiting.patch
forcedeth-tx-data-path-optimization.patch
forcedeth-rx-data-path-optimization.patch
forcedeth-irq-data-path-optimization.patch
forcedeth-tx-max-work.patch
forcedeth-statistics-supported.patch
forcedeth-statistics-optimization.patch
