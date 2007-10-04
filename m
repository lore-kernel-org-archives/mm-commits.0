From: akpm@linux-foundation.org
Subject: - forcedeth-power-down-phy-when-interface-is-down.patch removed from -mm tree
Date: Thu, 04 Oct 2007 12:33:14 -0700
Message-ID: <200710041933.l94JXFl6025284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45566 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154AbXJDTd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 15:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eswierk@arastra.com, aabdulla@nvidia.com, akpm@linux-foundation.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     forcedeth: power down phy when interface is down
has been removed from the -mm tree.  Its filename was
     forcedeth-power-down-phy-when-interface-is-down.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: forcedeth: power down phy when interface is down
From: "Ed Swierk" <eswierk@arastra.com>

Bring the physical link down when the interface is down, by placing the PHY in
power-down state.  This mirrors the behavior of other drivers including e1000
and tg3.

Signed-off-by: Ed Swierk <eswierk@arastra.com>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>

On Sat, 29 Sep 2007 01:57:04 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> akpm@linux-foundation.org wrote:
> > From: "Ed Swierk" <eswierk@arastra.com>
> > 
> > Bring the physical link down when the interface is down, by placing the PHY in
> > power-down state.  This mirrors the behavior of other drivers including e1000
> > and tg3.
> > 
> > Signed-off-by: Ed Swierk <eswierk@arastra.com>
> > Cc: Ayaz Abdulla <aabdulla@nvidia.com>
> > Cc: Jeff Garzik <jeff@garzik.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> 
> HOLD -- waiting a bit for comment from others, particularly NVIDIA.
> 
> I'm not opposed to applying it, the patch looks correct, but I would 
> also like see testing results and general "it's ok for this hardware" 
> comments.
> 

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

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
@@ -4975,6 +4979,10 @@ static int nv_close(struct net_device *d
 		nv_start_rx(dev);
 	}
 
+	/* power down phy */
+	mii_rw(dev, np->phyaddr, MII_BMCR,
+	       mii_rw(dev, np->phyaddr, MII_BMCR, MII_READ) | BMCR_PDOWN);
+
 	/* FIXME: power down nic */
 
 	return 0;
_

Patches currently in -mm which might be from eswierk@arastra.com are

git-net.patch
forcedeth-power-down-phy-when-interface-is-down.patch
