From: akpm@linux-foundation.org
Subject: + natsemi-fix-napi-for-interrupt-sharing.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:50:17 -0800
Message-ID: <200703151850.l2FIoJca023299@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35534 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbXCOSuu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@sirena.org.uk, mhuth@mvista.com, simon@citylink.co.nz, sshtylyov@ru.mvista.com


The patch titled
     natsemi: fix NAPI for interrupt sharing
has been added to the -mm tree.  Its filename is
     natsemi-fix-napi-for-interrupt-sharing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: natsemi: fix NAPI for interrupt sharing
From: Mark Brown <broonie@sirena.org.uk>

The interrupt status register for the natsemi chips is clear on read and was
read unconditionally from both the interrupt and from the NAPI poll routine,
meaning that if the interrupt service routine was called (for example, due to
a shared interrupt) while a NAPI poll was scheduled interrupts could be
missed.  This patch fixes that by ensuring that the interrupt status register
is only read by the interrupt handler when interrupts are enabled from the
chip.

It also reverts a workaround for this problem from the netpoll hook and
improves the trace for interrupt events.

Thanks to Sergei Shtylyov <sshtylyov@ru.mvista.com> for spotting the issue,
Mark Huth <mhuth@mvista.com> for a simpler method and Simon Blake
<simon@citylink.co.nz> for testing resources.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/natsemi.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff -puN drivers/net/natsemi.c~natsemi-fix-napi-for-interrupt-sharing drivers/net/natsemi.c
--- a/drivers/net/natsemi.c~natsemi-fix-napi-for-interrupt-sharing
+++ a/drivers/net/natsemi.c
@@ -2119,28 +2119,35 @@ static irqreturn_t intr_handler(int irq,
 	struct netdev_private *np = netdev_priv(dev);
 	void __iomem * ioaddr = ns_ioaddr(dev);
 
-	if (np->hands_off)
+	/* Reading IntrStatus automatically acknowledges so don't do
+	 * that while interrupts are disabled, (for example, while a
+	 * poll is scheduled).  */
+	if (np->hands_off || !readl(ioaddr + IntrEnable))
 		return IRQ_NONE;
 
-	/* Reading automatically acknowledges. */
 	np->intr_status = readl(ioaddr + IntrStatus);
 
+	if (!np->intr_status)
+		return IRQ_NONE;
+
 	if (netif_msg_intr(np))
 		printk(KERN_DEBUG
 		       "%s: Interrupt, status %#08x, mask %#08x.\n",
 		       dev->name, np->intr_status,
 		       readl(ioaddr + IntrMask));
 
-	if (!np->intr_status)
-		return IRQ_NONE;
-
 	prefetch(&np->rx_skbuff[np->cur_rx % RX_RING_SIZE]);
 
 	if (netif_rx_schedule_prep(dev)) {
 		/* Disable interrupts and register for poll */
 		natsemi_irq_disable(dev);
 		__netif_rx_schedule(dev);
-	}
+	} else
+		printk(KERN_WARNING
+	       	       "%s: Ignoring interrupt, status %#08x, mask %#08x.\n",
+		       dev->name, np->intr_status,
+		       readl(ioaddr + IntrMask));
+
 	return IRQ_HANDLED;
 }
 
@@ -2156,6 +2163,12 @@ static int natsemi_poll(struct net_devic
 	int work_done = 0;
 
 	do {
+		if (netif_msg_intr(np))
+			printk(KERN_DEBUG
+			       "%s: Poll, status %#08x, mask %#08x.\n",
+			       dev->name, np->intr_status,
+			       readl(ioaddr + IntrMask));
+
 		if (np->intr_status &
 		    (IntrTxDone | IntrTxIntr | IntrTxIdle | IntrTxErr)) {
 			spin_lock(&np->lock);
@@ -2399,19 +2412,8 @@ static struct net_device_stats *get_stat
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void natsemi_poll_controller(struct net_device *dev)
 {
-	struct netdev_private *np = netdev_priv(dev);
-
 	disable_irq(dev->irq);
-
-	/*
-	 * A real interrupt might have already reached us at this point
-	 * but NAPI might still haven't called us back.  As the interrupt
-	 * status register is cleared by reading, we should prevent an
-	 * interrupt loss in this case...
-	 */
-	if (!np->intr_status)
-		intr_handler(dev->irq, dev);
-
+	intr_handler(dev->irq, dev);
 	enable_irq(dev->irq);
 }
 #endif
_

Patches currently in -mm which might be from broonie@sirena.org.uk are

natsemi-consistently-use-interrupt-enable-disable-functions.patch
natsemi-fix-napi-for-interrupt-sharing.patch
natsemi-avoid-intrstatus-lossage-if-rx-state-machine-resets.patch
