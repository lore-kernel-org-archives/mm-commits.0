From: akpm@linux-foundation.org
Subject: - pci-skeleton-misc-fixes-to-build-neatly.patch removed from -mm tree
Date: Sun, 03 Feb 2008 12:22:22 -0800
Message-ID: <200802032022.m13KM3lK029982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49848 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbYBCUWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:22:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albcamus@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pci-skeleton: Misc fixes to build neatly
has been removed from the -mm tree.  Its filename was
     pci-skeleton-misc-fixes-to-build-neatly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-skeleton: Misc fixes to build neatly
From: Jike Song <albcamus@gmail.com>

The pci-skeleton.c has several problems with compilation, such as missing
args when calling synchronize_irq().  Fix it.

Signed-off-by: Jike Song <albcamus@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pci-skeleton.c |   49 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff -puN drivers/net/pci-skeleton.c~pci-skeleton-misc-fixes-to-build-neatly drivers/net/pci-skeleton.c
--- a/drivers/net/pci-skeleton.c~pci-skeleton-misc-fixes-to-build-neatly
+++ a/drivers/net/pci-skeleton.c
@@ -541,7 +541,7 @@ static void netdrv_hw_start (struct net_
 #define NETDRV_W32_F(reg, val32)	do { writel ((val32), ioaddr + (reg)); readl (ioaddr + (reg)); } while (0)
 
 
-#if MMIO_FLUSH_AUDIT_COMPLETE
+#ifdef MMIO_FLUSH_AUDIT_COMPLETE
 
 /* write MMIO register */
 #define NETDRV_W8(reg, val8)	writeb ((val8), ioaddr + (reg))
@@ -603,7 +603,7 @@ static int __devinit netdrv_init_board (
 		return -ENOMEM;
 	}
 	SET_NETDEV_DEV(dev, &pdev->dev);
-	tp = dev->priv;
+	tp = netdev_priv(dev);
 
 	/* enable device (incl. PCI PM wakeup), and bus-mastering */
 	rc = pci_enable_device (pdev);
@@ -759,7 +759,7 @@ static int __devinit netdrv_init_one (st
 		return i;
 	}
 
-	tp = dev->priv;
+	tp = netdev_priv(dev);
 
 	assert (ioaddr != NULL);
 	assert (dev != NULL);
@@ -783,7 +783,7 @@ static int __devinit netdrv_init_one (st
 	dev->base_addr = (unsigned long) ioaddr;
 
 	/* dev->priv/tp zeroed and aligned in alloc_etherdev */
-	tp = dev->priv;
+	tp = netdev_priv(dev);
 
 	/* note: tp->chipset set in netdrv_init_board */
 	tp->drv_flags = PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
@@ -841,7 +841,7 @@ static void __devexit netdrv_remove_one 
 
 	assert (dev != NULL);
 
-	np = dev->priv;
+	np = netdev_priv(dev);
 	assert (np != NULL);
 
 	unregister_netdev (dev);
@@ -974,7 +974,7 @@ static void mdio_sync (void *mdio_addr)
 
 static int mdio_read (struct net_device *dev, int phy_id, int location)
 {
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	void *mdio_addr = tp->mmio_addr + Config4;
 	int mii_cmd = (0xf6 << 10) | (phy_id << 5) | location;
 	int retval = 0;
@@ -1017,7 +1017,7 @@ static int mdio_read (struct net_device 
 static void mdio_write (struct net_device *dev, int phy_id, int location,
 			int value)
 {
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	void *mdio_addr = tp->mmio_addr + Config4;
 	int mii_cmd =
 	    (0x5002 << 16) | (phy_id << 23) | (location << 18) | value;
@@ -1060,7 +1060,7 @@ static void mdio_write (struct net_devic
 
 static int netdrv_open (struct net_device *dev)
 {
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	int retval;
 #ifdef NETDRV_DEBUG
 	void *ioaddr = tp->mmio_addr;
@@ -1121,7 +1121,7 @@ static int netdrv_open (struct net_devic
 /* Start the hardware at open or resume. */
 static void netdrv_hw_start (struct net_device *dev)
 {
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	void *ioaddr = tp->mmio_addr;
 	u32 i;
 
@@ -1191,7 +1191,7 @@ static void netdrv_hw_start (struct net_
 /* Initialize the Rx and Tx rings, along with various 'dev' bits. */
 static void netdrv_init_ring (struct net_device *dev)
 {
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	int i;
 
 	DPRINTK ("ENTER\n");
@@ -1213,7 +1213,7 @@ static void netdrv_init_ring (struct net
 static void netdrv_timer (unsigned long data)
 {
 	struct net_device *dev = (struct net_device *) data;
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	void *ioaddr = tp->mmio_addr;
 	int next_tick = 60 * HZ;
 	int mii_lpa;
@@ -1252,9 +1252,10 @@ static void netdrv_timer (unsigned long 
 }
 
 
-static void netdrv_tx_clear (struct netdrv_private *tp)
+static void netdrv_tx_clear (struct net_device *dev)
 {
 	int i;
+	struct netdrv_private *tp = netdev_priv(dev);
 
 	atomic_set (&tp->cur_tx, 0);
 	atomic_set (&tp->dirty_tx, 0);
@@ -1278,7 +1279,7 @@ static void netdrv_tx_clear (struct netd
 
 static void netdrv_tx_timeout (struct net_device *dev)
 {
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	void *ioaddr = tp->mmio_addr;
 	int i;
 	u8 tmp8;
@@ -1311,7 +1312,7 @@ static void netdrv_tx_timeout (struct ne
 	/* Stop a shared interrupt from scavenging while we are. */
 	spin_lock_irqsave (&tp->lock, flags);
 
-	netdrv_tx_clear (tp);
+	netdrv_tx_clear (dev);
 
 	spin_unlock_irqrestore (&tp->lock, flags);
 
@@ -1325,7 +1326,7 @@ static void netdrv_tx_timeout (struct ne
 
 static int netdrv_start_xmit (struct sk_buff *skb, struct net_device *dev)
 {
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	void *ioaddr = tp->mmio_addr;
 	int entry;
 
@@ -1525,7 +1526,7 @@ static void netdrv_rx_interrupt (struct 
 		DPRINTK ("%s:  netdrv_rx() status %4.4x, size %4.4x,"
 			 " cur %4.4x.\n", dev->name, rx_status,
 			 rx_size, cur_rx);
-#if NETDRV_DEBUG > 2
+#if defined(NETDRV_DEBUG) && (NETDRV_DEBUG > 2)
 		{
 			int i;
 			DPRINTK ("%s: Frame contents ", dev->name);
@@ -1648,7 +1649,7 @@ static void netdrv_weird_interrupt (stru
 static irqreturn_t netdrv_interrupt (int irq, void *dev_instance)
 {
 	struct net_device *dev = (struct net_device *) dev_instance;
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	int boguscnt = max_interrupt_work;
 	void *ioaddr = tp->mmio_addr;
 	int status = 0, link_changed = 0; /* avoid bogus "uninit" warning */
@@ -1711,7 +1712,7 @@ static irqreturn_t netdrv_interrupt (int
 
 static int netdrv_close (struct net_device *dev)
 {
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	void *ioaddr = tp->mmio_addr;
 	unsigned long flags;
 
@@ -1738,10 +1739,10 @@ static int netdrv_close (struct net_devi
 
 	spin_unlock_irqrestore (&tp->lock, flags);
 
-	synchronize_irq ();
+	synchronize_irq (dev->irq);
 	free_irq (dev->irq, dev);
 
-	netdrv_tx_clear (tp);
+	netdrv_tx_clear (dev);
 
 	pci_free_consistent(tp->pci_dev, RX_BUF_TOT_LEN,
 			    tp->rx_ring, tp->rx_ring_dma);
@@ -1762,7 +1763,7 @@ static int netdrv_close (struct net_devi
 
 static int netdrv_ioctl (struct net_device *dev, struct ifreq *rq, int cmd)
 {
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	struct mii_ioctl_data *data = if_mii(rq);
 	unsigned long flags;
 	int rc = 0;
@@ -1805,7 +1806,7 @@ static int netdrv_ioctl (struct net_devi
 
 static void netdrv_set_rx_mode (struct net_device *dev)
 {
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	void *ioaddr = tp->mmio_addr;
 	u32 mc_filter[2];	/* Multicast hash filter */
 	int i, rx_mode;
@@ -1862,7 +1863,7 @@ static void netdrv_set_rx_mode (struct n
 static int netdrv_suspend (struct pci_dev *pdev, pm_message_t state)
 {
 	struct net_device *dev = pci_get_drvdata (pdev);
-	struct netdrv_private *tp = dev->priv;
+	struct netdrv_private *tp = netdev_priv(dev);
 	void *ioaddr = tp->mmio_addr;
 	unsigned long flags;
 
@@ -1892,7 +1893,7 @@ static int netdrv_suspend (struct pci_de
 static int netdrv_resume (struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata (pdev);
-	struct netdrv_private *tp = dev->priv;
+	/*struct netdrv_private *tp = netdev_priv(dev);*/
 
 	if (!netif_running(dev))
 		return 0;
_

Patches currently in -mm which might be from albcamus@gmail.com are

git-net.patch
