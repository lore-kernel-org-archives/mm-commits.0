From: akpm@linux-foundation.org
Subject: + forcedeth-power-down-phy-when-interface-is-down.patch added to -mm tree
Date: Thu, 04 Oct 2007 12:34:47 -0700
Message-ID: <200710041934.l94JYlFe025319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154AbXJDTe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 15:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eswierk@arastra.com, aabdulla@nvidia.com, jeff@garzik.org


The patch titled
     forcedeth: power down phy when interface is down
has been added to the -mm tree.  Its filename is
     forcedeth-power-down-phy-when-interface-is-down.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth: power down phy when interface is down
From: "Ed Swierk" <eswierk@arastra.com>

Bring the physical link down when the interface is down by placing the PHY
in power-down state, unless WOL is enabled.  This mirrors the behavior of
other drivers including e1000 and tg3.

Signed-off-by: Ed Swierk <eswierk@arastra.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/net/forcedeth.c~forcedeth-power-down-phy-when-interface-is-down drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-power-down-phy-when-interface-is-down
+++ a/drivers/net/forcedeth.c
@@ -1313,9 +1313,9 @@ static int phy_init(struct net_device *d
 	/* some phys clear out pause advertisment on reset, set it back */
 	mii_rw(dev, np->phyaddr, MII_ADVERTISE, reg);
 
-	/* restart auto negotiation */
+	/* restart auto negotiation, power down phy */
 	mii_control = mii_rw(dev, np->phyaddr, MII_BMCR, MII_READ);
-	mii_control |= (BMCR_ANRESTART | BMCR_ANENABLE);
+	mii_control |= (BMCR_ANRESTART | BMCR_ANENABLE | BMCR_PDOWN);
 	if (mii_rw(dev, np->phyaddr, MII_BMCR, mii_control)) {
 		return PHY_ERROR;
 	}
@@ -4791,6 +4791,10 @@ static int nv_open(struct net_device *de
 
 	dprintk(KERN_DEBUG "nv_open: begin\n");
 
+	/* power up phy */
+	mii_rw(dev, np->phyaddr, MII_BMCR,
+	       mii_rw(dev, np->phyaddr, MII_BMCR, MII_READ) & ~BMCR_PDOWN);
+
 	/* erase previous misconfiguration */
 	if (np->driver_data & DEV_HAS_POWER_CNTRL)
 		nv_mac_reset(dev);
@@ -4973,6 +4977,10 @@ static int nv_close(struct net_device *d
 	if (np->wolenabled) {
 		writel(NVREG_PFF_ALWAYS|NVREG_PFF_MYADDR, base + NvRegPacketFilterFlags);
 		nv_start_rx(dev);
+	} else {
+		/* power down phy */
+		mii_rw(dev, np->phyaddr, MII_BMCR,
+		       mii_rw(dev, np->phyaddr, MII_BMCR, MII_READ) | BMCR_PDOWN);
 	}
 
 	/* FIXME: power down nic */
_

Patches currently in -mm which might be from eswierk@arastra.com are

git-net.patch
forcedeth-power-down-phy-when-interface-is-down.patch
