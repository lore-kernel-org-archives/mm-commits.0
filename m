From: akpm@osdl.org
Subject: + forcedeth-irq-data-path-optimization.patch added to -mm tree
Date: Tue, 09 Jan 2007 13:36:48 -0800
Message-ID: <200701092136.l09LamcL016086@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45890 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469AbXAIVgy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 16:36:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aabdulla@nvidia.com


The patch titled
     forcedeth: irq data path optimization
has been added to the -mm tree.  Its filename is
     forcedeth-irq-data-path-optimization.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth: irq data path optimization
From: Ayaz Abdulla <aabdulla@nvidia.com>

Optimize the irq data paths and cleans up the code.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/forcedeth.c |  149 +++++++++++++++++++-------------------
 1 files changed, 77 insertions(+), 72 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-irq-data-path-optimization drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-irq-data-path-optimization
+++ a/drivers/net/forcedeth.c
@@ -2777,7 +2777,6 @@ static irqreturn_t nv_nic_irq(int foo, v
 			events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQSTAT_MASK;
 			writel(NVREG_IRQSTAT_MASK, base + NvRegMSIXIrqStatus);
 		}
-		pci_push(base);
 		dprintk(KERN_DEBUG "%s: irq: %08x\n", dev->name, events);
 		if (!(events & np->irqmask))
 			break;
@@ -2786,22 +2785,46 @@ static irqreturn_t nv_nic_irq(int foo, v
 		nv_tx_done(dev);
 		spin_unlock(&np->lock);
 
-		if (events & NVREG_IRQ_LINK) {
+#ifdef CONFIG_FORCEDETH_NAPI
+		if (events & NVREG_IRQ_RX_ALL) {
+			netif_rx_schedule(dev);
+
+			/* Disable furthur receive irq's */
+			spin_lock(&np->lock);
+			np->irqmask &= ~NVREG_IRQ_RX_ALL;
+
+			if (np->msi_flags & NV_MSI_X_ENABLED)
+				writel(NVREG_IRQ_RX_ALL, base + NvRegIrqMask);
+			else
+				writel(np->irqmask, base + NvRegIrqMask);
+			spin_unlock(&np->lock);
+		}
+#else
+		if (nv_rx_process(dev, dev->weight)) {
+			if (unlikely(nv_alloc_rx(dev))) {
+				spin_lock(&np->lock);
+				if (!np->in_shutdown)
+					mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
+				spin_unlock(&np->lock);
+			}
+		}
+#endif
+		if (unlikely(events & NVREG_IRQ_LINK)) {
 			spin_lock(&np->lock);
 			nv_link_irq(dev);
 			spin_unlock(&np->lock);
 		}
-		if (np->need_linktimer && time_after(jiffies, np->link_timeout)) {
+		if (unlikely(np->need_linktimer && time_after(jiffies, np->link_timeout))) {
 			spin_lock(&np->lock);
 			nv_linkchange(dev);
 			spin_unlock(&np->lock);
 			np->link_timeout = jiffies + LINK_TIMEOUT;
 		}
-		if (events & (NVREG_IRQ_TX_ERR)) {
+		if (unlikely(events & (NVREG_IRQ_TX_ERR))) {
 			dprintk(KERN_DEBUG "%s: received irq with events 0x%x. Probably TX fail.\n",
 						dev->name, events);
 		}
-		if (events & (NVREG_IRQ_UNKNOWN)) {
+		if (unlikely(events & (NVREG_IRQ_UNKNOWN))) {
 			printk(KERN_DEBUG "%s: received irq with unknown events 0x%x. Please report\n",
 						dev->name, events);
 		}
@@ -2822,30 +2845,7 @@ static irqreturn_t nv_nic_irq(int foo, v
 			spin_unlock(&np->lock);
 			break;
 		}
-#ifdef CONFIG_FORCEDETH_NAPI
-		if (events & NVREG_IRQ_RX_ALL) {
-			netif_rx_schedule(dev);
-
-			/* Disable furthur receive irq's */
-			spin_lock(&np->lock);
-			np->irqmask &= ~NVREG_IRQ_RX_ALL;
-
-			if (np->msi_flags & NV_MSI_X_ENABLED)
-				writel(NVREG_IRQ_RX_ALL, base + NvRegIrqMask);
-			else
-				writel(np->irqmask, base + NvRegIrqMask);
-			spin_unlock(&np->lock);
-		}
-#else
-		nv_rx_process(dev, dev->weight);
-		if (nv_alloc_rx(dev)) {
-			spin_lock(&np->lock);
-			if (!np->in_shutdown)
-				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
-			spin_unlock(&np->lock);
-		}
-#endif
-		if (i > max_interrupt_work) {
+		if (unlikely(i > max_interrupt_work)) {
 			spin_lock(&np->lock);
 			/* disable interrupts on the nic */
 			if (!(np->msi_flags & NV_MSI_X_ENABLED))
@@ -2869,6 +2869,13 @@ static irqreturn_t nv_nic_irq(int foo, v
 	return IRQ_RETVAL(i);
 }
 
+#define TX_WORK_PER_LOOP  64
+#define RX_WORK_PER_LOOP  64
+/**
+ * All _optimized functions are used to help increase performance
+ * (reduce CPU and increase throughput). They use descripter version 3,
+ * compiler directives, and reduce memory accesses.
+ */
 static irqreturn_t nv_nic_irq_optimized(int foo, void *data)
 {
 	struct net_device *dev = (struct net_device *) data;
@@ -2887,7 +2894,6 @@ static irqreturn_t nv_nic_irq_optimized(
 			events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQSTAT_MASK;
 			writel(NVREG_IRQSTAT_MASK, base + NvRegMSIXIrqStatus);
 		}
-		pci_push(base);
 		dprintk(KERN_DEBUG "%s: irq: %08x\n", dev->name, events);
 		if (!(events & np->irqmask))
 			break;
@@ -2896,22 +2902,46 @@ static irqreturn_t nv_nic_irq_optimized(
 		nv_tx_done_optimized(dev);
 		spin_unlock(&np->lock);
 
-		if (events & NVREG_IRQ_LINK) {
+#ifdef CONFIG_FORCEDETH_NAPI
+		if (events & NVREG_IRQ_RX_ALL) {
+			netif_rx_schedule(dev);
+
+			/* Disable furthur receive irq's */
+			spin_lock(&np->lock);
+			np->irqmask &= ~NVREG_IRQ_RX_ALL;
+
+			if (np->msi_flags & NV_MSI_X_ENABLED)
+				writel(NVREG_IRQ_RX_ALL, base + NvRegIrqMask);
+			else
+				writel(np->irqmask, base + NvRegIrqMask);
+			spin_unlock(&np->lock);
+		}
+#else
+		if (nv_rx_process_optimized(dev, dev->weight)) {
+			if (unlikely(nv_alloc_rx_optimized(dev))) {
+				spin_lock(&np->lock);
+				if (!np->in_shutdown)
+					mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
+				spin_unlock(&np->lock);
+			}
+		}
+#endif
+		if (unlikely(events & NVREG_IRQ_LINK)) {
 			spin_lock(&np->lock);
 			nv_link_irq(dev);
 			spin_unlock(&np->lock);
 		}
-		if (np->need_linktimer && time_after(jiffies, np->link_timeout)) {
+		if (unlikely(np->need_linktimer && time_after(jiffies, np->link_timeout))) {
 			spin_lock(&np->lock);
 			nv_linkchange(dev);
 			spin_unlock(&np->lock);
 			np->link_timeout = jiffies + LINK_TIMEOUT;
 		}
-		if (events & (NVREG_IRQ_TX_ERR)) {
+		if (unlikely(events & (NVREG_IRQ_TX_ERR))) {
 			dprintk(KERN_DEBUG "%s: received irq with events 0x%x. Probably TX fail.\n",
 						dev->name, events);
 		}
-		if (events & (NVREG_IRQ_UNKNOWN)) {
+		if (unlikely(events & (NVREG_IRQ_UNKNOWN))) {
 			printk(KERN_DEBUG "%s: received irq with unknown events 0x%x. Please report\n",
 						dev->name, events);
 		}
@@ -2933,30 +2963,7 @@ static irqreturn_t nv_nic_irq_optimized(
 			break;
 		}
 
-#ifdef CONFIG_FORCEDETH_NAPI
-		if (events & NVREG_IRQ_RX_ALL) {
-			netif_rx_schedule(dev);
-
-			/* Disable furthur receive irq's */
-			spin_lock(&np->lock);
-			np->irqmask &= ~NVREG_IRQ_RX_ALL;
-
-			if (np->msi_flags & NV_MSI_X_ENABLED)
-				writel(NVREG_IRQ_RX_ALL, base + NvRegIrqMask);
-			else
-				writel(np->irqmask, base + NvRegIrqMask);
-			spin_unlock(&np->lock);
-		}
-#else
-		nv_rx_process_optimized(dev, dev->weight);
-		if (nv_alloc_rx_optimized(dev)) {
-			spin_lock(&np->lock);
-			if (!np->in_shutdown)
-				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
-			spin_unlock(&np->lock);
-		}
-#endif
-		if (i > max_interrupt_work) {
+		if (unlikely(i > max_interrupt_work)) {
 			spin_lock(&np->lock);
 			/* disable interrupts on the nic */
 			if (!(np->msi_flags & NV_MSI_X_ENABLED))
@@ -2994,7 +3001,6 @@ static irqreturn_t nv_nic_irq_tx(int foo
 	for (i=0; ; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_TX_ALL;
 		writel(NVREG_IRQ_TX_ALL, base + NvRegMSIXIrqStatus);
-		pci_push(base);
 		dprintk(KERN_DEBUG "%s: tx irq: %08x\n", dev->name, events);
 		if (!(events & np->irqmask))
 			break;
@@ -3003,11 +3009,11 @@ static irqreturn_t nv_nic_irq_tx(int foo
 		nv_tx_done_optimized(dev);
 		spin_unlock_irqrestore(&np->lock, flags);
 
-		if (events & (NVREG_IRQ_TX_ERR)) {
+		if (unlikely(events & (NVREG_IRQ_TX_ERR))) {
 			dprintk(KERN_DEBUG "%s: received irq with events 0x%x. Probably TX fail.\n",
 						dev->name, events);
 		}
-		if (i > max_interrupt_work) {
+		if (unlikely(i > max_interrupt_work)) {
 			spin_lock_irqsave(&np->lock, flags);
 			/* disable interrupts on the nic */
 			writel(NVREG_IRQ_TX_ALL, base + NvRegIrqMask);
@@ -3105,20 +3111,20 @@ static irqreturn_t nv_nic_irq_rx(int foo
 	for (i=0; ; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_RX_ALL;
 		writel(NVREG_IRQ_RX_ALL, base + NvRegMSIXIrqStatus);
-		pci_push(base);
 		dprintk(KERN_DEBUG "%s: rx irq: %08x\n", dev->name, events);
 		if (!(events & np->irqmask))
 			break;
 
-		nv_rx_process_optimized(dev, dev->weight);
-		if (nv_alloc_rx_optimized(dev)) {
-			spin_lock_irqsave(&np->lock, flags);
-			if (!np->in_shutdown)
-				mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
-			spin_unlock_irqrestore(&np->lock, flags);
+		if (nv_rx_process_optimized(dev, dev->weight)) {
+			if (unlikely(nv_alloc_rx_optimized(dev))) {
+				spin_lock_irqsave(&np->lock, flags);
+				if (!np->in_shutdown)
+					mod_timer(&np->oom_kick, jiffies + OOM_REFILL);
+				spin_unlock_irqrestore(&np->lock, flags);
+			}
 		}
 
-		if (i > max_interrupt_work) {
+		if (unlikely(i > max_interrupt_work)) {
 			spin_lock_irqsave(&np->lock, flags);
 			/* disable interrupts on the nic */
 			writel(NVREG_IRQ_RX_ALL, base + NvRegIrqMask);
@@ -3153,7 +3159,6 @@ static irqreturn_t nv_nic_irq_other(int 
 	for (i=0; ; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_OTHER;
 		writel(NVREG_IRQ_OTHER, base + NvRegMSIXIrqStatus);
-		pci_push(base);
 		dprintk(KERN_DEBUG "%s: irq: %08x\n", dev->name, events);
 		if (!(events & np->irqmask))
 			break;
@@ -3187,7 +3192,7 @@ static irqreturn_t nv_nic_irq_other(int 
 			printk(KERN_DEBUG "%s: received irq with unknown events 0x%x. Please report\n",
 						dev->name, events);
 		}
-		if (i > max_interrupt_work) {
+		if (unlikely(i > max_interrupt_work)) {
 			spin_lock_irqsave(&np->lock, flags);
 			/* disable interrupts on the nic */
 			writel(NVREG_IRQ_OTHER, base + NvRegIrqMask);
@@ -4969,7 +4974,7 @@ static int __devinit nv_probe(struct pci
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	dev->poll_controller = nv_poll_controller;
 #endif
-	dev->weight = 64;
+	dev->weight = RX_WORK_PER_LOOP;
 #ifdef CONFIG_FORCEDETH_NAPI
 	dev->poll = nv_napi_poll;
 #endif
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
