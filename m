From: akpm@linux-foundation.org
Subject: - stop-ignoring-argument-in-drivers-network-b44c.patch removed from -mm tree
Date: Fri, 04 May 2007 12:53:12 -0700
Message-ID: <200705041953.l44JrCQV012704@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161535AbXEDTxU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 15:53:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtt.martin@gmail.com, jeff@garzik.org, mchan@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     Stop ignoring argument in drivers/network/b44.c
has been removed from the -mm tree.  Its filename was
     stop-ignoring-argument-in-drivers-network-b44c.patch

This patch was dropped because of huge clashes with the wireless devel tree

------------------------------------------------------
Subject: Stop ignoring argument in drivers/network/b44.c
From: Matthew Martin <mtt.martin@gmail.com>

This patch uses the phy_id variable in b44_readphy and b44_writephy.

Signed-off-by: Matthew Martin <mtt.martin@gmail.com>
Cc: Michael Chan <mchan@broadcom.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/b44.c |   88 +++++++++++++++++++++++++-------------------
 1 files changed, 51 insertions(+), 37 deletions(-)

diff -puN drivers/net/b44.c~stop-ignoring-argument-in-drivers-network-b44c drivers/net/b44.c
--- a/drivers/net/b44.c~stop-ignoring-argument-in-drivers-network-b44c
+++ a/drivers/net/b44.c
@@ -327,45 +327,59 @@ static void b44_enable_ints(struct b44 *
 	bw32(bp, B44_IMASK, bp->imask);
 }
 
-static int b44_readphy(struct b44 *bp, int reg, u32 *val)
+static int b44_readphy(struct b44 *bp, int reg, u32 *val, int phy_addr)
 {
 	int err;
 
 	bw32(bp, B44_EMAC_ISTAT, EMAC_INT_MII);
-	bw32(bp, B44_MDIO_DATA, (MDIO_DATA_SB_START |
-			     (MDIO_OP_READ << MDIO_DATA_OP_SHIFT) |
-			     (bp->phy_addr << MDIO_DATA_PMD_SHIFT) |
-			     (reg << MDIO_DATA_RA_SHIFT) |
-			     (MDIO_TA_VALID << MDIO_DATA_TA_SHIFT)));
+
+	if (!phy_addr)
+		bw32(bp, B44_MDIO_DATA, (MDIO_DATA_SB_START |
+				     (MDIO_OP_READ << MDIO_DATA_OP_SHIFT) |
+				     (bp->phy_addr << MDIO_DATA_PMD_SHIFT) |
+				     (reg << MDIO_DATA_RA_SHIFT) |
+				     (MDIO_TA_VALID << MDIO_DATA_TA_SHIFT)));
+	else
+		bw32(bp, B44_MDIO_DATA, (MDIO_DATA_SB_START |
+				     (MDIO_OP_READ << MDIO_DATA_OP_SHIFT) |
+				     (phy_addr << MDIO_DATA_PMD_SHIFT) |
+				     (reg << MDIO_DATA_RA_SHIFT) |
+				     (MDIO_TA_VALID << MDIO_DATA_TA_SHIFT)));
+
 	err = b44_wait_bit(bp, B44_EMAC_ISTAT, EMAC_INT_MII, 100, 0);
 	*val = br32(bp, B44_MDIO_DATA) & MDIO_DATA_DATA;
 
 	return err;
 }
 
-static int b44_writephy(struct b44 *bp, int reg, u32 val)
+static int b44_writephy(struct b44 *bp, int reg, u32 val, int phy_addr)
 {
 	bw32(bp, B44_EMAC_ISTAT, EMAC_INT_MII);
-	bw32(bp, B44_MDIO_DATA, (MDIO_DATA_SB_START |
-			     (MDIO_OP_WRITE << MDIO_DATA_OP_SHIFT) |
-			     (bp->phy_addr << MDIO_DATA_PMD_SHIFT) |
-			     (reg << MDIO_DATA_RA_SHIFT) |
-			     (MDIO_TA_VALID << MDIO_DATA_TA_SHIFT) |
-			     (val & MDIO_DATA_DATA)));
+
+	if (!phy_addr)
+		bw32(bp, B44_MDIO_DATA, (MDIO_DATA_SB_START |
+				     (MDIO_OP_WRITE << MDIO_DATA_OP_SHIFT) |
+				     (bp->phy_addr << MDIO_DATA_PMD_SHIFT) |
+				     (reg << MDIO_DATA_RA_SHIFT) |
+				     (MDIO_TA_VALID << MDIO_DATA_TA_SHIFT) |
+				     (val & MDIO_DATA_DATA)));
+	else
+		bw32(bp, B44_MDIO_DATA, (MDIO_DATA_SB_START |
+				     (MDIO_OP_WRITE << MDIO_DATA_OP_SHIFT) |
+				     (phy_addr << MDIO_DATA_PMD_SHIFT) |
+				     (reg << MDIO_DATA_RA_SHIFT) |
+				     (MDIO_TA_VALID << MDIO_DATA_TA_SHIFT) |
+				     (val & MDIO_DATA_DATA)));
+
 	return b44_wait_bit(bp, B44_EMAC_ISTAT, EMAC_INT_MII, 100, 0);
 }
 
 /* miilib interface */
-/* FIXME FIXME: phy_id is ignored, bp->phy_addr use is unconditional
- * due to code existing before miilib use was added to this driver.
- * Someone should remove this artificial driver limitation in
- * b44_{read,write}phy.  bp->phy_addr itself is fine (and needed).
- */
 static int b44_mii_read(struct net_device *dev, int phy_id, int location)
 {
 	u32 val;
 	struct b44 *bp = netdev_priv(dev);
-	int rc = b44_readphy(bp, location, &val);
+	int rc = b44_readphy(bp, location, &val, phy_id);
 	if (rc)
 		return 0xffffffff;
 	return val;
@@ -375,7 +389,7 @@ static void b44_mii_write(struct net_dev
 			 int val)
 {
 	struct b44 *bp = netdev_priv(dev);
-	b44_writephy(bp, location, val);
+	b44_writephy(bp, location, val, phy_id);
 }
 
 static int b44_phy_reset(struct b44 *bp)
@@ -383,11 +397,11 @@ static int b44_phy_reset(struct b44 *bp)
 	u32 val;
 	int err;
 
-	err = b44_writephy(bp, MII_BMCR, BMCR_RESET);
+	err = b44_writephy(bp, MII_BMCR, BMCR_RESET, 0);
 	if (err)
 		return err;
 	udelay(100);
-	err = b44_readphy(bp, MII_BMCR, &val);
+	err = b44_readphy(bp, MII_BMCR, &val, 0);
 	if (!err) {
 		if (val & BMCR_RESET) {
 			printk(KERN_ERR PFX "%s: PHY Reset would not complete.\n",
@@ -446,15 +460,15 @@ static int b44_setup_phy(struct b44 *bp)
 	u32 val;
 	int err;
 
-	if ((err = b44_readphy(bp, B44_MII_ALEDCTRL, &val)) != 0)
+	if ((err = b44_readphy(bp, B44_MII_ALEDCTRL, &val, 0)) != 0)
 		goto out;
 	if ((err = b44_writephy(bp, B44_MII_ALEDCTRL,
-				val & MII_ALEDCTRL_ALLMSK)) != 0)
+				val & MII_ALEDCTRL_ALLMSK, 0)) != 0)
 		goto out;
-	if ((err = b44_readphy(bp, B44_MII_TLEDCTRL, &val)) != 0)
+	if ((err = b44_readphy(bp, B44_MII_TLEDCTRL, &val, 0)) != 0)
 		goto out;
 	if ((err = b44_writephy(bp, B44_MII_TLEDCTRL,
-				val | MII_TLEDCTRL_ENABLE)) != 0)
+				val | MII_TLEDCTRL_ENABLE, 0)) != 0)
 		goto out;
 
 	if (!(bp->flags & B44_FLAG_FORCE_LINK)) {
@@ -472,22 +486,22 @@ static int b44_setup_phy(struct b44 *bp)
 		if (bp->flags & B44_FLAG_PAUSE_AUTO)
 			adv |= ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM;
 
-		if ((err = b44_writephy(bp, MII_ADVERTISE, adv)) != 0)
+		if ((err = b44_writephy(bp, MII_ADVERTISE, adv, 0)) != 0)
 			goto out;
 		if ((err = b44_writephy(bp, MII_BMCR, (BMCR_ANENABLE |
-						       BMCR_ANRESTART))) != 0)
+						       BMCR_ANRESTART), 0)) != 0)
 			goto out;
 	} else {
 		u32 bmcr;
 
-		if ((err = b44_readphy(bp, MII_BMCR, &bmcr)) != 0)
+		if ((err = b44_readphy(bp, MII_BMCR, &bmcr, 0)) != 0)
 			goto out;
 		bmcr &= ~(BMCR_FULLDPLX | BMCR_ANENABLE | BMCR_SPEED100);
 		if (bp->flags & B44_FLAG_100_BASE_T)
 			bmcr |= BMCR_SPEED100;
 		if (bp->flags & B44_FLAG_FULL_DUPLEX)
 			bmcr |= BMCR_FULLDPLX;
-		if ((err = b44_writephy(bp, MII_BMCR, bmcr)) != 0)
+		if ((err = b44_writephy(bp, MII_BMCR, bmcr, 0)) != 0)
 			goto out;
 
 		/* Since we will not be negotiating there is no safe way
@@ -541,8 +555,8 @@ static void b44_check_phy(struct b44 *bp
 {
 	u32 bmsr, aux;
 
-	if (!b44_readphy(bp, MII_BMSR, &bmsr) &&
-	    !b44_readphy(bp, B44_MII_AUXCTRL, &aux) &&
+	if (!b44_readphy(bp, MII_BMSR, &bmsr, 0) &&
+	    !b44_readphy(bp, B44_MII_AUXCTRL, &aux, 0) &&
 	    (bmsr != 0xffff)) {
 		if (aux & MII_AUXCTRL_SPEED)
 			bp->flags |= B44_FLAG_100_BASE_T;
@@ -565,8 +579,8 @@ static void b44_check_phy(struct b44 *bp
 			bw32(bp, B44_TX_CTRL, val);
 
 			if (!(bp->flags & B44_FLAG_FORCE_LINK) &&
-			    !b44_readphy(bp, MII_ADVERTISE, &local_adv) &&
-			    !b44_readphy(bp, MII_LPA, &remote_adv))
+			    !b44_readphy(bp, MII_ADVERTISE, &local_adv, 0) &&
+			    !b44_readphy(bp, MII_LPA, &remote_adv, 0))
 				b44_set_flow_ctrl(bp, local_adv, remote_adv);
 
 			/* Link now up */
@@ -1766,12 +1780,12 @@ static int b44_nway_reset(struct net_dev
 	int r;
 
 	spin_lock_irq(&bp->lock);
-	b44_readphy(bp, MII_BMCR, &bmcr);
-	b44_readphy(bp, MII_BMCR, &bmcr);
+	b44_readphy(bp, MII_BMCR, &bmcr, 0);
+	b44_readphy(bp, MII_BMCR, &bmcr, 0);
 	r = -EINVAL;
 	if (bmcr & BMCR_ANENABLE) {
 		b44_writephy(bp, MII_BMCR,
-			     bmcr | BMCR_ANRESTART);
+			     bmcr | BMCR_ANRESTART, 0);
 		r = 0;
 	}
 	spin_unlock_irq(&bp->lock);
_

Patches currently in -mm which might be from mtt.martin@gmail.com are

stop-ignoring-argument-in-drivers-network-b44c.patch
