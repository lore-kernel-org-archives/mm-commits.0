From: akpm@linux-foundation.org
Subject: [merged] forcedeth-add-clock-gating-feature.patch removed from -mm tree
Date: Mon, 04 May 2009 13:13:58 -0700
Message-ID: <200905042013.n44KDwxN022843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753649AbZEDUQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, florian@openwrt.org, mm-commits@vger.kernel.org


The patch titled
     forcedeth: add clock gating feature
has been removed from the -mm tree.  Its filename was
     forcedeth-add-clock-gating-feature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: forcedeth: add clock gating feature
From: Ayaz Abdulla <aabdulla@nvidia.com>

Add support for clock gating the tx/rx engines which is available on
certain chipsets.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN drivers/net/forcedeth.c~forcedeth-add-clock-gating-feature drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-add-clock-gating-feature
+++ a/drivers/net/forcedeth.c
@@ -343,6 +343,7 @@ enum {
 #define NVREG_POWERSTATE2_POWERUP_MASK		0x0F15
 #define NVREG_POWERSTATE2_POWERUP_REV_A3	0x0001
 #define NVREG_POWERSTATE2_PHY_RESET		0x0004
+#define NVREG_POWERSTATE2_GATE_CLOCKS		0x0F00
 };
 
 /* Big endian: should work, but is untested */
@@ -1017,6 +1018,23 @@ static int using_multi_irqs(struct net_d
 		return 1;
 }
 
+static void nv_txrx_gate(struct net_device *dev, bool gate)
+{
+	struct fe_priv *np = get_nvpriv(dev);
+	u8 __iomem *base = get_hwbase(dev);
+	u32 powerstate;
+
+	if (!np->mac_in_use &&
+	    (np->driver_data & DEV_HAS_POWER_CNTRL)) {
+		powerstate = readl(base + NvRegPowerState2);
+		if (gate)
+			powerstate |= NVREG_POWERSTATE2_GATE_CLOCKS;
+		else
+			powerstate &= ~NVREG_POWERSTATE2_GATE_CLOCKS;
+		writel(powerstate,base + NvRegPowerState2);
+	}
+}
+
 static void nv_enable_irq(struct net_device *dev)
 {
 	struct fe_priv *np = get_nvpriv(dev);
@@ -3394,12 +3412,14 @@ static void nv_linkchange(struct net_dev
 		if (!netif_carrier_ok(dev)) {
 			netif_carrier_on(dev);
 			printk(KERN_INFO "%s: link up.\n", dev->name);
+			nv_txrx_gate(dev, false);
 			nv_start_rx(dev);
 		}
 	} else {
 		if (netif_carrier_ok(dev)) {
 			netif_carrier_off(dev);
 			printk(KERN_INFO "%s: link down.\n", dev->name);
+			nv_txrx_gate(dev, true);
 			nv_stop_rx(dev);
 		}
 	}
@@ -5327,6 +5347,7 @@ static int nv_open(struct net_device *de
 	mii_rw(dev, np->phyaddr, MII_BMCR,
 	       mii_rw(dev, np->phyaddr, MII_BMCR, MII_READ) & ~BMCR_PDOWN);
 
+	nv_txrx_gate(dev, false);
 	/* erase previous misconfiguration */
 	if (np->driver_data & DEV_HAS_POWER_CNTRL)
 		nv_mac_reset(dev);
@@ -5514,12 +5535,14 @@ static int nv_close(struct net_device *d
 	nv_drain_rxtx(dev);
 
 	if (np->wolenabled) {
+		nv_txrx_gate(dev, false);
 		writel(NVREG_PFF_ALWAYS|NVREG_PFF_MYADDR, base + NvRegPacketFilterFlags);
 		nv_start_rx(dev);
 	} else {
 		/* power down phy */
 		mii_rw(dev, np->phyaddr, MII_BMCR,
 		       mii_rw(dev, np->phyaddr, MII_BMCR, MII_READ)|BMCR_PDOWN);
+		nv_txrx_gate(dev, true);
 	}
 
 	/* FIXME: power down nic */
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

linux-next.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch

