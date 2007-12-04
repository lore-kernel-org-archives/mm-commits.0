From: akpm@linux-foundation.org
Subject: - r6040-cleanups.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:38:38 -0800
Message-ID: <200712040738.lB47ccSU006917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840AbXLDHtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:49:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, mm-commits@vger.kernel.org


The patch titled
     r6040: cleanups
has been removed from the -mm tree.  Its filename was
     r6040-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: r6040: cleanups
From: Francois Romieu <romieu@fr.zoreil.com>

- whitespaces vs tabs
- use 80 cols
- use if_mii
- use netdev_priv
- remove useless cast to void *
- PCI device id does not need to be globally available

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r6040.c     |   33 +++++++++++++--------------------
 include/linux/pci_ids.h |    1 -
 2 files changed, 13 insertions(+), 21 deletions(-)

diff -puN drivers/net/r6040.c~r6040-cleanups drivers/net/r6040.c
--- a/drivers/net/r6040.c~r6040-cleanups
+++ a/drivers/net/r6040.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2004 Sten Wang <sten.wang@rdc.com.tw>
  * Copyright (C) 2007
- * 	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
+ *	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
  *	Florian Fainelli <florian@openwrt.org>
  *
  * This program is free software; you can redistribute it and/or
@@ -60,7 +60,7 @@
 #define PHY_CAP		0x01E1	/* PHY CHIP Register 4 */
 
 /* Time in jiffies before concluding the transmitter is hung. */
-#define TX_TIMEOUT  	(6000 * HZ / 1000)
+#define TX_TIMEOUT	(6000 * HZ / 1000)
 #define TIMER_WUT	(jiffies + HZ * 1)/* timer wakeup time : 1 second */
 
 /* RDC MAC I/O Size */
@@ -235,8 +235,7 @@ static void mdio_write(struct net_device
 	phy_write(ioaddr, lp->phy_addr, reg, val);
 }
 
-static void
-r6040_tx_timeout(struct net_device *dev)
+static void r6040_tx_timeout(struct net_device *dev)
 {
 	struct r6040_private *priv = netdev_priv(dev);
 
@@ -341,8 +340,7 @@ static void r6040_down(struct net_device
 	pci_free_consistent(pdev, TX_DESC_SIZE, lp->tx_ring, lp->tx_ring_dma);
 }
 
-static int
-r6040_close(struct net_device *dev)
+static int r6040_close(struct net_device *dev)
 {
 	struct r6040_private *lp = netdev_priv(dev);
 
@@ -405,7 +403,7 @@ static void r6040_set_carrier(struct mii
 static int r6040_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct r6040_private *lp = netdev_priv(dev);
-	struct mii_ioctl_data *data = (struct mii_ioctl_data *) &rq->ifr_data;
+	struct mii_ioctl_data *data = if_mii(rq);
 	int rc;
 
 	if (!netif_running(dev))
@@ -574,12 +572,11 @@ static irqreturn_t r6040_interrupt(int i
 static void r6040_poll_controller(struct net_device *dev)
 {
 	disable_irq(dev->irq);
-	r6040_interrupt(dev->irq, (void *)dev);
+	r6040_interrupt(dev->irq, dev);
 	enable_irq(dev->irq);
 }
 #endif
 
-
 static void r6040_init_ring_desc(struct r6040_descriptor *desc_ring,
 				 dma_addr_t desc_dma, int size)
 {
@@ -716,10 +713,9 @@ static void r6040_mac_address(struct net
 	iowrite16(adrp[2], ioaddr + MID_0H);
 }
 
-static int
-r6040_open(struct net_device *dev)
+static int r6040_open(struct net_device *dev)
 {
-	struct r6040_private *lp = dev->priv;
+	struct r6040_private *lp = netdev_priv(dev);
 	int ret;
 
 	/* Request IRQ and Register interrupt handler */
@@ -761,8 +757,7 @@ r6040_open(struct net_device *dev)
 	return 0;
 }
 
-static int
-r6040_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static int r6040_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct r6040_private *lp = netdev_priv(dev);
 	struct r6040_descriptor *descptr;
@@ -810,8 +805,7 @@ r6040_start_xmit(struct sk_buff *skb, st
 	return ret;
 }
 
-static void
-r6040_multicast_list(struct net_device *dev)
+static void r6040_multicast_list(struct net_device *dev)
 {
 	struct r6040_private *lp = netdev_priv(dev);
 	void __iomem *ioaddr = lp->base;
@@ -938,7 +932,6 @@ static struct ethtool_ops netdev_ethtool
 	.get_link		= netdev_get_link,
 };
 
-
 static int __devinit r6040_init_one(struct pci_dev *pdev,
 					 const struct pci_device_id *ent)
 {
@@ -1075,13 +1068,13 @@ static void __devexit r6040_remove_one(s
 
 
 static struct pci_device_id r6040_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6040) },
-	{0 }
+	{ PCI_DEVICE(PCI_VENDOR_ID_RDC, 0x6040) },
+	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, r6040_pci_tbl);
 
 static struct pci_driver r6040_driver = {
-	.name		= "r6040",
+	.name		= DRV_NAME,
 	.id_table	= r6040_pci_tbl,
 	.probe		= r6040_init_one,
 	.remove		= __devexit_p(r6040_remove_one),
diff -puN include/linux/pci_ids.h~r6040-cleanups include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~r6040-cleanups
+++ a/include/linux/pci_ids.h
@@ -2108,7 +2108,6 @@
 #define PCI_DEVICE_ID_HERC_UNI		0x5832
 
 #define PCI_VENDOR_ID_RDC		0x17f3
-#define PCI_DEVICE_ID_RDC_R6040		0x6040
 
 #define PCI_VENDOR_ID_SITECOM		0x182d
 #define PCI_DEVICE_ID_SITECOM_DC105V2	0x3069
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

git-netdev-all.patch
