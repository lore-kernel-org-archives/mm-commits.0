From: akpm@osdl.org
Subject: - driver-for-silan-sc92031-netdev-fixes.patch removed from -mm tree
Date: Tue, 19 Dec 2006 13:06:55 -0800
Message-ID: <200612192106.kBJL6tkY010436@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35246 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932970AbWLSVHI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 16:07:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, mm-commits@vger.kernel.org


The patch titled
     driver-for-silan-sc92031-netdev fixes
has been removed from the -mm tree.  Its filename was
     driver-for-silan-sc92031-netdev-fixes.patch

This patch was dropped because it was folded into driver-for-silan-sc92031-netdev.patch

------------------------------------------------------
Subject: driver-for-silan-sc92031-netdev fixes
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Andrew Morton escreveu:
> On Fri, 08 Dec 2006 18:17:06 -0200
> Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
>
>> From: Cesar Eduardo Barros <cesarb@cesarb.net>
>>
>> +	} while(unlikely(cmpxchg(&priv->intr_status,
>
> You'll have the arm maintainer after you with a pointy stick.
>
> cmpxchg is only available on certain architectures.  It would be acceptable
> to make this driver depend on X86 (or something).  Better to rewrite this
> code so it doesn't use cmpxchg.

Fixed.  As long as I make sure the interrupt and the tasklet never run at
the same time, I do not need to protect intr_status against concurrent
modification.

Also fixed a potential bug where the tasklet could end up permanently
disabled.

It has received the same testing as the previous one, only for less time (I'm
using it right now).

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/sc92031.c |   74 +++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 20 deletions(-)

diff -puN drivers/net/sc92031.c~driver-for-silan-sc92031-netdev-fixes drivers/net/sc92031.c
--- a/drivers/net/sc92031.c~driver-for-silan-sc92031-netdev-fixes
+++ a/drivers/net/sc92031.c
@@ -34,7 +34,7 @@
 
 #define SC92031_NAME "sc92031"
 #define SC92031_DESCRIPTION "Silan SC92031 PCI Fast Ethernet Adapter driver"
-#define SC92031_VERSION "2.0b"
+#define SC92031_VERSION "2.0c"
 
 /* BAR 0 is MMIO, BAR 1 is PIO */
 #ifndef SC92031_USE_BAR
@@ -261,6 +261,12 @@ enum PMConfigBits {
  * Use mmiowb() before unlocking if the hardware was written to.
  */
 
+/* Locking rules for the interrupt:
+ * - the interrupt and the tasklet never run at the same time
+ * - neither run between sc92031_disable_interrupts and
+ *   sc92031_enable_interrupt
+ */
+
 struct sc92031_priv {
 	spinlock_t		lock;
 	/* iomap.h cookie */
@@ -288,6 +294,7 @@ struct sc92031_priv {
 
 	/* copies of some hardware registers */
 	u32			intr_status;
+	atomic_t		intr_mask;
 	u32			rx_config;
 	u32			tx_config;
 	u32			pm_config;
@@ -304,6 +311,13 @@ struct sc92031_priv {
 	struct net_device_stats	stats;
 };
 
+/* I don't know which registers can be safely read; however, I can guess
+ * MAC0 is one of them. */
+static inline void _sc92031_dummy_read(void __iomem *port_base)
+{
+	ioread32(port_base + MAC0);
+}
+
 static u32 _sc92031_mii_wait(void __iomem *port_base)
 {
 	u32 mii_status;
@@ -348,12 +362,18 @@ static void sc92031_disable_interrupts(s
 	struct sc92031_priv *priv = netdev_priv(dev);
 	void __iomem *port_base = priv->port_base;
 
-	tasklet_disable(&priv->tasklet);
+	/* tell the tasklet/interrupt not to enable interrupts */
+	atomic_set(&priv->intr_mask, 0);
+	wmb();
 
+	/* stop interrupts */
 	iowrite32(0, port_base + IntrMask);
+	_sc92031_dummy_read(port_base);
 	mmiowb();
 
+	/* wait for any concurrent interrupt/tasklet to finish */
 	synchronize_irq(dev->irq);
+	tasklet_disable(&priv->tasklet);
 }
 
 static void sc92031_enable_interrupts(struct net_device *dev)
@@ -363,6 +383,9 @@ static void sc92031_enable_interrupts(st
 
 	tasklet_enable(&priv->tasklet);
 
+	atomic_set(&priv->intr_mask, IntrBits);
+	wmb();
+
 	iowrite32(IntrBits, port_base + IntrMask);
 	mmiowb();
 }
@@ -608,6 +631,7 @@ static void _sc92031_reset(struct net_de
 
 	/* clear old register values */
 	priv->intr_status = 0;
+	atomic_set(&priv->intr_mask, 0);
 	priv->rx_config = 0;
 	priv->tx_config = 0;
 	priv->mc_flags = 0;
@@ -824,9 +848,9 @@ static void sc92031_tasklet(unsigned lon
 	struct net_device *dev = (struct net_device *)data;
 	struct sc92031_priv *priv = netdev_priv(dev);
 	void __iomem *port_base = priv->port_base;
-	u32 intr_status;
+	u32 intr_status, intr_mask;
 
-	intr_status = xchg(&priv->intr_status, 0);
+	intr_status = priv->intr_status;
 
 	spin_lock(&priv->lock);
 
@@ -851,7 +875,10 @@ static void sc92031_tasklet(unsigned lon
 		_sc92031_link_tasklet(dev);
 
 out:
-	iowrite32(IntrBits, port_base + IntrMask);
+	intr_mask = atomic_read(&priv->intr_mask);
+	rmb();
+
+	iowrite32(intr_mask, port_base + IntrMask);
 	mmiowb();
 
 	spin_unlock(&priv->lock);
@@ -862,29 +889,33 @@ static irqreturn_t sc92031_interrupt(int
 	struct net_device *dev = dev_id;
 	struct sc92031_priv *priv = netdev_priv(dev);
 	void __iomem *port_base = priv->port_base;
-	u32 intr_status, old_intr_status, new_intr_status;
+	u32 intr_status, intr_mask;
+
+	/* mask interrupts before clearing IntrStatus */
+	iowrite32(0, port_base + IntrMask);
+	_sc92031_dummy_read(port_base);
 
 	intr_status = ioread32(port_base + IntrStatus);
 	if (unlikely(intr_status == 0xffffffff))
-		return IRQ_NONE;
+		return IRQ_NONE;	// hardware has gone missing
 
 	intr_status &= IntrBits;
 	if (!intr_status)
-		return IRQ_NONE;
-
-	do {
-		old_intr_status = priv->intr_status;
-		new_intr_status = old_intr_status | intr_status;
-	} while(unlikely(cmpxchg(&priv->intr_status,
-					old_intr_status, new_intr_status)
-			!= old_intr_status));
-
-	iowrite32(0, port_base + IntrMask);
-	mmiowb();
+		goto out_none;
 
+	priv->intr_status = intr_status;
 	tasklet_schedule(&priv->tasklet);
 
 	return IRQ_HANDLED;
+
+out_none:
+	intr_mask = atomic_read(&priv->intr_mask);
+	rmb();
+
+	iowrite32(intr_mask, port_base + IntrMask);
+	mmiowb();
+
+	return IRQ_NONE;
 }
 
 static struct net_device_stats *sc92031_get_stats(struct net_device *dev)
@@ -1007,7 +1038,7 @@ static int sc92031_open(struct net_devic
 
 	priv->pm_config = 0;
 
-	sc92031_disable_interrupts(dev);
+	/* Interrupts already disabled by sc92031_stop or sc92031_probe */
 	spin_lock(&priv->lock);
 
 	_sc92031_reset(dev);
@@ -1442,6 +1473,9 @@ static int __devinit sc92031_probe(struc
 	priv->port_base = port_base;
 	priv->pdev = pdev;
 	tasklet_init(&priv->tasklet, sc92031_tasklet, (unsigned long)dev);
+	/* Fudge tasklet count so the call to sc92031_enable_interrupts at
+	 * sc92031_open will work correctly */
+	tasklet_disable_nosync(&priv->tasklet);
 
 	/* PCI PM Wakeup */
 	iowrite32((~PM_LongWF & ~PM_LWPTN) | PM_Enable, port_base + PMConfig);
@@ -1527,7 +1561,7 @@ static int sc92031_resume(struct pci_dev
 	if (!netif_running(dev))
 		goto out;
 
-	sc92031_disable_interrupts(dev);
+	/* Interrupts already disabled by sc92031_suspend */
 	spin_lock(&priv->lock);
 
 	_sc92031_reset(dev);
_

Patches currently in -mm which might be from cesarb@cesarb.net are

driver-for-silan-sc92031-netdev.patch
driver-for-silan-sc92031-netdev-fixes.patch
driver-for-silan-sc92031-netdev-include-fix.patch
driver-for-silan-sc92031-netdev-fix-more.patch

