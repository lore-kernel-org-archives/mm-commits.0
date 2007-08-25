From: akpm@linux-foundation.org
Subject: - git-chelsio.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:26:21 -0700
Message-ID: <200708250326.l7P3QL3i028098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbXHYD0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:26:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, mm-commits@vger.kernel.org


The patch titled
     git-chelsio.patch
has been removed from the -mm tree.  Its filename was
     git-chelsio.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: git-chelsio.patch

GIT 6822b9d59faceb62a7044849cff012d6cf20ad7a git://electric-eye.fr.zoreil.com/home/romieu/linux-2.6.git#chelsio

commit 
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Tue Dec 12 00:13:48 2006 +0100

    chelsio: tabulate the update of the statistic counters
    
    Let's try to avoid some code duplication.
    
    - cxgb2
      The data are contiguous. Use plain memcpy.
    
    - ixf1010/pm3393/vsc7326
      The cast of &mac->stats to (u64 *) is not wonderful but it is not clear
      if it is worth to add an ad-hoc union under the struct cmac_statistics.
    
    vsc7326_reg.h suggests that more statistics could be available.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 1f3d073359a4f78731fabc1ef2d9b8cc8dcff16b
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Tue Dec 5 23:57:41 2006 +0100

    chelsio: misc cleanups in sge
    
    - duplicated code in sge::free_cmdQ_buffers ;
    - NET_IP_ALIGN is already defined in (included) <linux/skbuff.h> ;
    - pci_alloc_consistent() returns void * ;
    - pci_alloc_consistent() returns a zeroed chunk of memory ;
    - early return in restart_tx_queues.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit e4b382e3b6df583f53bd56285ab32d25924fe653
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Tue Dec 5 23:19:06 2006 +0100

    chelsio: useless test in cxgb2::remove_one
    
    pci_get_drvadata() is necessarily distinct from NULL if
    cxgb2::init_one succeeded. cxgb2::remove_one is solely
    issued through the PCI device callback.
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 1699093b113c327f0b8e79aeae73eba5c6b30910
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Mon Dec 11 23:49:13 2006 +0100

    chelsio: useless curly braces
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit e284e11a7ede38ed441c52aa51c7bf48a6623e0d
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Mon Dec 11 23:47:00 2006 +0100

    chelsio: spaces, tabs and friends
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 18f6e5536f6c00fe27b19745eb8577432bb6bc95
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Mon Dec 11 23:41:36 2006 +0100

    chelsio: the return statement is not a function
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

commit 36959faf64235eb0509420b91d950279f797f58e
Author: Francois Romieu <romieu@fr.zoreil.com>
Date:   Tue Dec 5 22:38:00 2006 +0100

    chelsio: move return, break and continue statements on their own line
    
    Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
 drivers/net/chelsio/common.h  |    6 +++
 drivers/net/chelsio/ixf1010.c |  Unmerged
 drivers/net/chelsio/sge.c     |   77 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/chelsio/vsc8244.c |  Unmerged
 4 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/drivers/net/chelsio/common.h b/drivers/net/chelsio/common.h
index 8ba702c..9eb8c92 100644
--- a/drivers/net/chelsio/common.h
+++ b/drivers/net/chelsio/common.h
@@ -322,9 +322,15 @@ struct board_info {
 	unsigned char           mdio_mdiinv;
 	unsigned char           mdio_mdc;
 	unsigned char           mdio_phybaseaddr;
+<<<<<<< HEAD/drivers/net/chelsio/common.h
 	const struct gmac      *gmac;
 	const struct gphy      *gphy;
 	const struct mdio_ops  *mdio_ops;
+=======
+	struct gmac            *gmac;
+	struct gphy            *gphy;
+	struct mdio_ops        *mdio_ops;
+>>>>>>> /drivers/net/chelsio/common.h
 	const char             *desc;
 };
 
* Unmerged path drivers/net/chelsio/ixf1010.c
diff --git a/drivers/net/chelsio/sge.c b/drivers/net/chelsio/sge.c
index e4f874a..7b3f55b 100644
--- a/drivers/net/chelsio/sge.c
+++ b/drivers/net/chelsio/sge.c
@@ -1056,9 +1056,23 @@ static inline struct sk_buff *get_packet
 		if (!skb)
 			goto use_orig_buf;
 
+<<<<<<< HEAD/drivers/net/chelsio/sge.c
 		skb_reserve(skb, 2);	/* align IP header */
 		skb_put(skb, len);
 		pci_dma_sync_single_for_cpu(pdev,
+=======
+	if (len < copy_thres) {
+		skb = alloc_skb(len + skb_pad, GFP_ATOMIC);
+		if (likely(skb != NULL)) {
+			skb_reserve(skb, skb_pad);
+			skb_put(skb, len);
+			pci_dma_sync_single_for_cpu(pdev,
+					    pci_unmap_addr(ce, dma_addr),
+					    pci_unmap_len(ce, dma_len),
+					    PCI_DMA_FROMDEVICE);
+			memcpy(skb->data, ce->skb->data + dma_pad, len);
+			pci_dma_sync_single_for_device(pdev,
+>>>>>>> /drivers/net/chelsio/sge.c
 					    pci_unmap_addr(ce, dma_addr),
 					    pci_unmap_len(ce, dma_len),
 					    PCI_DMA_FROMDEVICE);
@@ -1492,6 +1506,10 @@ static int process_responses(struct adap
 	int done = 0;
 	unsigned int flags = 0;
 	unsigned int cmdq_processed[SGE_CMDQ_N] = {0, 0};
+<<<<<<< HEAD/drivers/net/chelsio/sge.c
+=======
+
+>>>>>>> /drivers/net/chelsio/sge.c
 
 	while (done < budget && e->GenerationBit == q->genbit) {
 		flags |= e->Qsleeping;
@@ -1632,8 +1650,19 @@ int t1_poll(struct net_device *dev, int 
 	if (unlikely(responses_pending(adapter)))
 		return 1;
 
+<<<<<<< HEAD/drivers/net/chelsio/sge.c
 	netif_rx_complete(dev);
+=======
+	spin_lock_irq(&adapter->async_lock);
+	__netif_rx_complete(dev);
+>>>>>>> /drivers/net/chelsio/sge.c
 	writel(adapter->sge->respQ.cidx, adapter->regs + A_SG_SLEEPING);
+<<<<<<< HEAD/drivers/net/chelsio/sge.c
+=======
+	writel(adapter->slow_intr_mask | F_PL_INTR_SGE_DATA,
+	       adapter->regs + A_PL_ENABLE);
+	spin_unlock_irq(&adapter->async_lock);
+>>>>>>> /drivers/net/chelsio/sge.c
 
 	return 0;
 
@@ -1645,12 +1674,22 @@ int t1_poll(struct net_device *dev, int 
 irqreturn_t t1_interrupt(int irq, void *data)
 {
 	struct adapter *adapter = data;
+<<<<<<< HEAD/drivers/net/chelsio/sge.c
+=======
+	struct net_device *dev = adapter->sge->netdev;
+>>>>>>> /drivers/net/chelsio/sge.c
 	struct sge *sge = adapter->sge;
+<<<<<<< HEAD/drivers/net/chelsio/sge.c
 	int handled;
+=======
+	u32 cause;
+	int handled = 0;
+>>>>>>> /drivers/net/chelsio/sge.c
 
 	if (likely(responses_pending(adapter))) {
 		struct net_device *dev = sge->netdev;
 
+<<<<<<< HEAD/drivers/net/chelsio/sge.c
 		writel(F_PL_INTR_SGE_DATA, adapter->regs + A_PL_CAUSE);
 
 		if (__netif_rx_schedule_prep(dev)) {
@@ -1660,6 +1699,24 @@ irqreturn_t t1_interrupt(int irq, void *
 				/* no data, no NAPI needed */
 				writel(sge->respQ.cidx, adapter->regs + A_SG_SLEEPING);
 				netif_poll_enable(dev);	/* undo schedule_prep */
+=======
+	spin_lock(&adapter->async_lock);
+	if (cause & F_PL_INTR_SGE_DATA) {
+		struct respQ *q = &adapter->sge->respQ;
+		struct respQ_e *e = &q->entries[q->cidx];
+
+		handled = 1;
+		writel(F_PL_INTR_SGE_DATA, adapter->regs + A_PL_CAUSE);
+
+		if (e->GenerationBit == q->genbit &&
+		    __netif_rx_schedule_prep(dev)) {
+			if (e->DataValid || process_pure_responses(adapter, e)) {
+				/* mask off data IRQ */
+				writel(adapter->slow_intr_mask,
+				       adapter->regs + A_PL_ENABLE);
+				__netif_rx_schedule(sge->netdev);
+				goto unlock;
+>>>>>>> /drivers/net/chelsio/sge.c
 			}
 		}
 		return IRQ_HANDLED;
@@ -2083,6 +2140,7 @@ static void espibug_workaround_t204(unsi
 			return;
 
 		for (i = 0; i < nports; i++) {
+<<<<<<< HEAD/drivers/net/chelsio/sge.c
 			struct sk_buff *skb = sge->espibug_skb[i];
 
 			if (!netif_running(adapter->port[i].dev) ||
@@ -2104,6 +2162,25 @@ static void espibug_workaround_t204(unsi
 							       ch_mac_addr,
 							       ETH_ALEN);
 				skb->cb[0] = 0xff;
+=======
+			struct sk_buff *skb = sge->espibug_skb[i];
+
+			if (!netif_running(adapter->port[i].dev) ||
+			    netif_queue_stopped(adapter->port[i].dev) ||
+			    !seop[i] || ((seop[i] & 0xfff) != 0) || !skb)
+				continue;
+
+			if (!skb->cb[0]) {
+				u8 ch_mac_addr[ETH_ALEN] = {
+					0x0, 0x7, 0x43, 0x0, 0x0, 0x0
+				};
+
+				memcpy(skb->data + sizeof(struct cpl_tx_pkt),
+					ch_mac_addr, ETH_ALEN);
+				memcpy(skb->data + skb->len - 10,
+					ch_mac_addr, ETH_ALEN);
+				skb->cb[0] = 0xff;
+>>>>>>> /drivers/net/chelsio/sge.c
 			}
 
 			/* bump the reference count to avoid freeing of
* Unmerged path drivers/net/chelsio/vsc8244.c

Patches currently in -mm which might be from romieu@fr.zoreil.com are

origin.patch
git-r8169.patch
