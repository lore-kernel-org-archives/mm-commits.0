From: akpm@linux-foundation.org
Subject: - forcedeth-fix-power-management-support.patch removed from -mm tree
Date: Thu, 24 May 2007 15:05:14 -0700
Message-ID: <200705242205.l4OM5EhA004373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbXEXWFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:05:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: fix power management support
has been removed from the -mm tree.  Its filename was
     forcedeth-fix-power-management-support.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: forcedeth: fix power management support
From: Ayaz Abdulla <aabdulla@nvidia.com>

This patch fixes the power management functions.  It includes lowering the phy
speed to conserve power.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |  123 ++++++++++++++++++++++++++++++++++----
 1 file changed, 111 insertions(+), 12 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-fix-power-management-support drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-fix-power-management-support
+++ a/drivers/net/forcedeth.c
@@ -812,6 +812,10 @@ struct fe_priv {
 
 	/* flow control */
 	u32 pause_flags;
+
+	/* power saved state */
+	u32 saved_config_space[64];
+	u32 saved_phyinterface;
 };
 
 /*
@@ -5348,42 +5352,137 @@ static void __devexit nv_remove(struct p
 }
 
 #ifdef CONFIG_PM
+static void nv_set_low_speed(struct net_device *dev)
+{
+	struct fe_priv *np = netdev_priv(dev);
+	int adv = 0;
+	int lpa = 0;
+	int adv_lpa, bmcr, tries = 0;
+	int mii_status;
+	u32 control_1000;
+
+	/* lower the speed if we are in 1000Mbps autoneg */
+	if (np->autoneg == 0 || ((np->linkspeed & 0xFFF) != NVREG_LINKSPEED_1000))
+		return;
+
+	adv = mii_rw(dev, np->phyaddr, MII_ADVERTISE, MII_READ);
+	lpa = mii_rw(dev, np->phyaddr, MII_LPA, MII_READ);
+	control_1000 = mii_rw(dev, np->phyaddr, MII_CTRL1000, MII_READ);
+
+	adv_lpa = lpa & adv;
+
+	/* lower the speed if partner has advertised other speeds */
+	if ((adv_lpa & LPA_10FULL) || (adv_lpa & LPA_10HALF)) {
+		adv &= ~(ADVERTISE_100BASE4 | ADVERTISE_100FULL | ADVERTISE_100HALF);
+		control_1000 &= ~ADVERTISE_1000FULL;
+	} else if ((adv_lpa & LPA_100FULL) || (adv_lpa & LPA_100HALF)) {
+		control_1000 &= ~ADVERTISE_1000FULL;
+	} else
+		return;
+
+	/* set new advertisements */
+	mii_rw(dev, np->phyaddr, MII_ADVERTISE, adv);
+	mii_rw(dev, np->phyaddr, MII_CTRL1000, control_1000);
+
+	bmcr = mii_rw(dev, np->phyaddr, MII_BMCR, MII_READ);
+	if (np->phy_model == PHY_MODEL_MARVELL_E3016) {
+		bmcr |= BMCR_ANENABLE;
+		/* reset the phy in order for settings to stick,
+		 * and cause autoneg to start */
+		if (phy_reset(dev, bmcr)) {
+			printk(KERN_INFO "%s: phy reset failed\n", dev->name);
+			return;
+		}
+	} else {
+		bmcr |= (BMCR_ANENABLE | BMCR_ANRESTART);
+		mii_rw(dev, np->phyaddr, MII_BMCR, bmcr);
+	}
+	mii_rw(dev, np->phyaddr, MII_BMSR, MII_READ);
+	mii_status = mii_rw(dev, np->phyaddr, MII_BMSR, MII_READ);
+	while (!(mii_status & BMSR_ANEGCOMPLETE)) {
+		msleep(100);
+		mii_status = mii_rw(dev, np->phyaddr, MII_BMSR, MII_READ);
+		if (tries++ > 50)
+			break;
+	}
+
+	nv_update_linkspeed(dev);
+
+	return;
+}
+
 static int nv_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct fe_priv *np = netdev_priv(dev);
+	u8 __iomem *base = get_hwbase(dev);
+	int i;
 
-	if (!netif_running(dev))
-		goto out;
+	dprintk(KERN_DEBUG "forcedeth: nv_suspend\n");
+
+	if (netif_running(dev)) {
+		netif_device_detach(dev);
 
-	netif_device_detach(dev);
+		/* bring down the adapter */
+		nv_close(dev);
+	}
 
-	// Gross.
-	nv_close(dev);
+	/* set phy to a lower speed to conserve power */
+	if (!np->mac_in_use)
+		nv_set_low_speed(dev);
 
 	pci_save_state(pdev);
+
+	/* save any device state */
+	np->saved_phyinterface = readl(base + NvRegPhyInterface);
+	for (i = 0; i < 64; i++) {
+		pci_read_config_dword(pdev, i*4, &np->saved_config_space[i]);
+	}
+
 	pci_enable_wake(pdev, pci_choose_state(pdev, state), np->wolenabled);
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-out:
+
 	return 0;
 }
 
 static int nv_resume(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
+	struct fe_priv *np = netdev_priv(dev);
+	u8 __iomem *base = get_hwbase(dev);
 	int rc = 0;
+	int i;
+	u32 txreg;
 
-	if (!netif_running(dev))
-		goto out;
-
-	netif_device_attach(dev);
+	dprintk(KERN_DEBUG "forcedeth: nv_resume\n");
 
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
+
+	/* restore saved config space */
+	for (i = 0; i < 64; i++) {
+		pci_write_config_dword(pdev, i*4, np->saved_config_space[i]);
+	}
+
 	pci_enable_wake(pdev, PCI_D0, 0);
 
-	rc = nv_open(dev);
-out:
+	/* restore saved driver state */
+	txreg = readl(base + NvRegTransmitPoll);
+	txreg |= NVREG_TRANSMITPOLL_MAC_ADDR_REV;
+	writel(txreg, base + NvRegTransmitPoll);
+	writel(np->saved_phyinterface, base + NvRegPhyInterface);
+	writel(np->orig_mac[0], base + NvRegMacAddrA);
+	writel(np->orig_mac[1], base + NvRegMacAddrB);
+
+	/* re-initialize the phy */
+	phy_init(dev);
+
+	if (netif_running(dev)) {
+		netif_device_attach(dev);
+
+		/* bring up the adapter */
+		rc = nv_open(dev);
+	}
 	return rc;
 }
 #else
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

forcedeth-fix-power-management-support.patch
forcedeth-fix-cpu-irq-mask.patch
forcedeth-version-bump.patch
