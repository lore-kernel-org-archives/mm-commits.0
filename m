From: akpm@osdl.org
Subject: + forcedeth-sideband-management-fix.patch added to -mm tree
Date: Wed, 03 Jan 2007 14:17:23 -0800
Message-ID: <200701032217.l03MHNxQ000646@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55346 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163AbXACWR2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 17:17:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aabdulla@nvidia.com


The patch titled
     forcedeth: sideband management fix
has been added to the -mm tree.  Its filename is
     forcedeth-sideband-management-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth: sideband management fix
From: Ayaz Abdulla <aabdulla@nvidia.com>

A fix that implements proper communication with the sideband management
unit.  Also, it makes sure that the speed is correctly set for gigabit phys
in the case where sideband mgmt unit initialized the phy.  Refer to bug
#7684 for more details.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/forcedeth.c |  111 +++++++++++++++++++-------------------
 1 files changed, 56 insertions(+), 55 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-sideband-management-fix drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-sideband-management-fix
+++ a/drivers/net/forcedeth.c
@@ -234,6 +234,7 @@ enum {
 #define NVREG_XMITCTL_HOST_SEMA_MASK	0x0000f000
 #define NVREG_XMITCTL_HOST_SEMA_ACQ	0x0000f000
 #define NVREG_XMITCTL_HOST_LOADED	0x00004000
+#define NVREG_XMITCTL_TX_PATH_EN	0x01000000
 	NvRegTransmitterStatus = 0x088,
 #define NVREG_XMITSTAT_BUSY	0x01
 
@@ -249,6 +250,7 @@ enum {
 #define NVREG_OFFLOAD_NORMAL	RX_NIC_BUFSIZE
 	NvRegReceiverControl = 0x094,
 #define NVREG_RCVCTL_START	0x01
+#define NVREG_RCVCTL_RX_PATH_EN	0x01000000
 	NvRegReceiverStatus = 0x98,
 #define NVREG_RCVSTAT_BUSY	0x01
 
@@ -1169,16 +1171,21 @@ static void nv_start_rx(struct net_devic
 {
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
+	u32 rx_ctrl = readl(base + NvRegReceiverControl);
 
 	dprintk(KERN_DEBUG "%s: nv_start_rx\n", dev->name);
 	/* Already running? Stop it. */
-	if (readl(base + NvRegReceiverControl) & NVREG_RCVCTL_START) {
-		writel(0, base + NvRegReceiverControl);
+	if ((readl(base + NvRegReceiverControl) & NVREG_RCVCTL_START) && !np->mac_in_use) {
+		rx_ctrl &= ~NVREG_RCVCTL_START;
+		writel(rx_ctrl, base + NvRegReceiverControl);
 		pci_push(base);
 	}
 	writel(np->linkspeed, base + NvRegLinkSpeed);
 	pci_push(base);
-	writel(NVREG_RCVCTL_START, base + NvRegReceiverControl);
+        rx_ctrl |= NVREG_RCVCTL_START;
+        if (np->mac_in_use)
+		rx_ctrl &= ~NVREG_RCVCTL_RX_PATH_EN;
+	writel(rx_ctrl, base + NvRegReceiverControl);
 	dprintk(KERN_DEBUG "%s: nv_start_rx to duplex %d, speed 0x%08x.\n",
 				dev->name, np->duplex, np->linkspeed);
 	pci_push(base);
@@ -1186,39 +1193,59 @@ static void nv_start_rx(struct net_devic
 
 static void nv_stop_rx(struct net_device *dev)
 {
+	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
+	u32 rx_ctrl = readl(base + NvRegReceiverControl);
 
 	dprintk(KERN_DEBUG "%s: nv_stop_rx\n", dev->name);
-	writel(0, base + NvRegReceiverControl);
+	if (!np->mac_in_use)
+		rx_ctrl &= ~NVREG_RCVCTL_START;
+	else
+		rx_ctrl |= NVREG_RCVCTL_RX_PATH_EN;
+	writel(rx_ctrl, base + NvRegReceiverControl);
 	reg_delay(dev, NvRegReceiverStatus, NVREG_RCVSTAT_BUSY, 0,
 			NV_RXSTOP_DELAY1, NV_RXSTOP_DELAY1MAX,
 			KERN_INFO "nv_stop_rx: ReceiverStatus remained busy");
 
 	udelay(NV_RXSTOP_DELAY2);
-	writel(0, base + NvRegLinkSpeed);
+	if (!np->mac_in_use)
+		writel(0, base + NvRegLinkSpeed);
 }
 
 static void nv_start_tx(struct net_device *dev)
 {
+	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
+	u32 tx_ctrl = readl(base + NvRegTransmitterControl);
 
 	dprintk(KERN_DEBUG "%s: nv_start_tx\n", dev->name);
-	writel(NVREG_XMITCTL_START, base + NvRegTransmitterControl);
+	tx_ctrl |= NVREG_XMITCTL_START;
+	if (np->mac_in_use)
+		tx_ctrl &= ~NVREG_XMITCTL_TX_PATH_EN;
+	writel(tx_ctrl, base + NvRegTransmitterControl);
 	pci_push(base);
 }
 
 static void nv_stop_tx(struct net_device *dev)
 {
+	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
+	u32 tx_ctrl = readl(base + NvRegTransmitterControl);
 
 	dprintk(KERN_DEBUG "%s: nv_stop_tx\n", dev->name);
-	writel(0, base + NvRegTransmitterControl);
+	if (!np->mac_in_use)
+		tx_ctrl &= ~NVREG_XMITCTL_START;
+	else
+		tx_ctrl |= NVREG_XMITCTL_TX_PATH_EN;
+	writel(tx_ctrl, base + NvRegTransmitterControl);
 	reg_delay(dev, NvRegTransmitterStatus, NVREG_XMITSTAT_BUSY, 0,
 			NV_TXSTOP_DELAY1, NV_TXSTOP_DELAY1MAX,
 			KERN_INFO "nv_stop_tx: TransmitterStatus remained busy");
 
 	udelay(NV_TXSTOP_DELAY2);
-	writel(readl(base + NvRegTransmitPoll) & NVREG_TRANSMITPOLL_MAC_ADDR_REV, base + NvRegTransmitPoll);
+	if (!np->mac_in_use)
+		writel(readl(base + NvRegTransmitPoll) & NVREG_TRANSMITPOLL_MAC_ADDR_REV,
+		       base + NvRegTransmitPoll);
 }
 
 static void nv_txrx_reset(struct net_device *dev)
@@ -4146,20 +4173,6 @@ static int nv_mgmt_acquire_sema(struct n
 	return 0;
 }
 
-/* Indicate to mgmt unit whether driver is loaded or not */
-static void nv_mgmt_driver_loaded(struct net_device *dev, int loaded)
-{
-	u8 __iomem *base = get_hwbase(dev);
-	u32 tx_ctrl;
-
-	tx_ctrl = readl(base + NvRegTransmitterControl);
-	if (loaded)
-		tx_ctrl |= NVREG_XMITCTL_HOST_LOADED;
-	else
-		tx_ctrl &= ~NVREG_XMITCTL_HOST_LOADED;
-	writel(tx_ctrl, base + NvRegTransmitterControl);
-}
-
 static int nv_open(struct net_device *dev)
 {
 	struct fe_priv *np = netdev_priv(dev);
@@ -4655,33 +4668,24 @@ static int __devinit nv_probe(struct pci
 	writel(NVREG_MIISTAT_MASK, base + NvRegMIIStatus);
 
 	if (id->driver_data & DEV_HAS_MGMT_UNIT) {
-		writel(0x1, base + 0x204); pci_push(base);
-		msleep(500);
 		/* management unit running on the mac? */
-		np->mac_in_use = readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_MGMT_ST;
-		if (np->mac_in_use) {
-			u32 mgmt_sync;
-			/* management unit setup the phy already? */
-			mgmt_sync = readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_MASK;
-			if (mgmt_sync == NVREG_XMITCTL_SYNC_NOT_READY) {
-				if (!nv_mgmt_acquire_sema(dev)) {
-					for (i = 0; i < 5000; i++) {
-						msleep(1);
-						mgmt_sync = readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_MASK;
-						if (mgmt_sync == NVREG_XMITCTL_SYNC_NOT_READY)
-							continue;
-						if (mgmt_sync == NVREG_XMITCTL_SYNC_PHY_INIT)
-							phyinitialized = 1;
-						break;
+		if (readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_PHY_INIT) {
+			np->mac_in_use = readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_MGMT_ST;
+			dprintk(KERN_INFO "%s: mgmt unit is running. mac in use %x.\n", pci_name(pci_dev), np->mac_in_use);
+			for (i = 0; i < 5000; i++) {
+				msleep(1);
+				if (nv_mgmt_acquire_sema(dev)) {
+					/* management unit setup the phy already? */
+					if ((readl(base + NvRegTransmitterControl) & NVREG_XMITCTL_SYNC_MASK) ==
+					    NVREG_XMITCTL_SYNC_PHY_INIT) {
+						/* phy is inited by mgmt unit */
+						phyinitialized = 1;
+						dprintk(KERN_INFO "%s: Phy already initialized by mgmt unit.\n", pci_name(pci_dev));
+					} else {
+						/* we need to init the phy */
 					}
-				} else {
-					/* we need to init the phy */
+					break;
 				}
-			} else if (mgmt_sync == NVREG_XMITCTL_SYNC_PHY_INIT) {
-				/* phy is inited by SMU */
-				phyinitialized = 1;
-			} else {
-				/* we need to init the phy */
 			}
 		}
 	}
@@ -4720,10 +4724,12 @@ static int __devinit nv_probe(struct pci
 	if (!phyinitialized) {
 		/* reset it */
 		phy_init(dev);
-	}
-
-	if (id->driver_data & DEV_HAS_MGMT_UNIT) {
-		nv_mgmt_driver_loaded(dev, 1);
+	} else {
+		/* see if it is a gigabit phy */
+		u32 mii_status = mii_rw(dev, np->phyaddr, MII_BMSR, MII_READ);
+		if (mii_status & PHY_GIGABIT) {
+			np->gigabit = PHY_GIGABIT;
+		}
 	}
 
 	/* set default link speed settings */
@@ -4745,8 +4751,6 @@ static int __devinit nv_probe(struct pci
 out_error:
 	if (phystate_orig)
 		writel(phystate|NVREG_ADAPTCTL_RUNNING, base + NvRegAdapterControl);
-	if (np->mac_in_use)
-		nv_mgmt_driver_loaded(dev, 0);
 	pci_set_drvdata(pci_dev, NULL);
 out_freering:
 	free_rings(dev);
@@ -4776,9 +4780,6 @@ static void __devexit nv_remove(struct p
 	writel(np->orig_mac[0], base + NvRegMacAddrA);
 	writel(np->orig_mac[1], base + NvRegMacAddrB);
 
-	if (np->mac_in_use)
-		nv_mgmt_driver_loaded(dev, 0);
-
 	/* free all structures */
 	free_rings(dev);
 	iounmap(get_hwbase(dev));
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

forcedeth-sideband-management-fix.patch
