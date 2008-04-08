From: akpm@linux-foundation.org
Subject: + sundance-set-carrier-status-on-link-change-events.patch added to -mm tree
Date: Tue, 08 Apr 2008 00:09:22 -0700
Message-ID: <200804080709.m3879MRh013650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572AbYDHHJz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 03:09:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbn.lists@gmail.com


The patch titled
     sundance: set carrier status on link change events
has been added to the -mm tree.  Its filename is
     sundance-set-carrier-status-on-link-change-events.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sundance: set carrier status on link change events
From: Dan Nicholson <dbn.lists@gmail.com>

Check if the link is available when a changed interrupt has been received and
set the carrier status appropriately.  The code is copied nearly verbatim from
the dl2k module.  The link status could be used in more places in the driver,
but this is enough to get the carrier status reported to userspace.  Fixes
kernel bug #7487:

    http://bugzilla.kernel.org/show_bug.cgi?id=7487

Signed-off-by: Dan Nicholson <dbn.lists@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sundance.c |   94 +++++++++++++++++++++++++--------------
 1 file changed, 61 insertions(+), 33 deletions(-)

diff -puN drivers/net/sundance.c~sundance-set-carrier-status-on-link-change-events drivers/net/sundance.c
--- a/drivers/net/sundance.c~sundance-set-carrier-status-on-link-change-events
+++ a/drivers/net/sundance.c
@@ -409,6 +409,7 @@ static int  change_mtu(struct net_device
 static int  eeprom_read(void __iomem *ioaddr, int location);
 static int  mdio_read(struct net_device *dev, int phy_id, int location);
 static void mdio_write(struct net_device *dev, int phy_id, int location, int value);
+static int  mdio_wait_link (struct net_device *dev, int wait);
 static int  netdev_open(struct net_device *dev);
 static void check_duplex(struct net_device *dev);
 static void netdev_timer(unsigned long data);
@@ -785,6 +786,24 @@ static void mdio_write(struct net_device
 	return;
 }
 
+static int mdio_wait_link (struct net_device *dev, int wait)
+{
+	int bmsr;
+	int phy_id;
+	struct netdev_private *np;
+
+	np = netdev_priv(dev);
+	phy_id = np->phys[0];
+
+	do {
+		bmsr = mdio_read (dev, phy_id, MII_BMSR);
+		if (bmsr & 0x0004)
+			return 0;
+		mdelay (1);
+	} while (--wait > 0);
+	return -1;
+}
+
 static int netdev_open(struct net_device *dev)
 {
 	struct netdev_private *np = netdev_priv(dev);
@@ -1393,41 +1412,50 @@ static void netdev_error(struct net_devi
 	int speed;
 
 	if (intr_status & LinkChange) {
-		if (np->an_enable) {
-			mii_advertise = mdio_read (dev, np->phys[0], MII_ADVERTISE);
-			mii_lpa= mdio_read (dev, np->phys[0], MII_LPA);
-			mii_advertise &= mii_lpa;
-			printk (KERN_INFO "%s: Link changed: ", dev->name);
-			if (mii_advertise & ADVERTISE_100FULL) {
-				np->speed = 100;
-				printk ("100Mbps, full duplex\n");
-			} else if (mii_advertise & ADVERTISE_100HALF) {
-				np->speed = 100;
-				printk ("100Mbps, half duplex\n");
-			} else if (mii_advertise & ADVERTISE_10FULL) {
-				np->speed = 10;
-				printk ("10Mbps, full duplex\n");
-			} else if (mii_advertise & ADVERTISE_10HALF) {
-				np->speed = 10;
-				printk ("10Mbps, half duplex\n");
-			} else
-				printk ("\n");
+		if (mdio_wait_link (dev, 10) == 0) {
+			printk (KERN_INFO "%s: Link up\n", dev->name);
+			if (np->an_enable) {
+				mii_advertise = mdio_read (dev, np->phys[0],
+							   MII_ADVERTISE);
+				mii_lpa= mdio_read (dev, np->phys[0], MII_LPA);
+				mii_advertise &= mii_lpa;
+				printk (KERN_INFO "%s: Link changed: ",
+					dev->name);
+				if (mii_advertise & ADVERTISE_100FULL) {
+					np->speed = 100;
+					printk ("100Mbps, full duplex\n");
+				} else if (mii_advertise & ADVERTISE_100HALF) {
+					np->speed = 100;
+					printk ("100Mbps, half duplex\n");
+				} else if (mii_advertise & ADVERTISE_10FULL) {
+					np->speed = 10;
+					printk ("10Mbps, full duplex\n");
+				} else if (mii_advertise & ADVERTISE_10HALF) {
+					np->speed = 10;
+					printk ("10Mbps, half duplex\n");
+				} else
+					printk ("\n");
 
+			} else {
+				mii_ctl = mdio_read (dev, np->phys[0], MII_BMCR);
+				speed = (mii_ctl & BMCR_SPEED100) ? 100 : 10;
+				np->speed = speed;
+				printk (KERN_INFO "%s: Link changed: %dMbps ,",
+					dev->name, speed);
+				printk ("%s duplex.\n", (mii_ctl & BMCR_FULLDPLX) ?
+					"full" : "half");
+			}
+			check_duplex (dev);
+			if (np->flowctrl && np->mii_if.full_duplex) {
+				iowrite16(ioread16(ioaddr + MulticastFilter1+2) | 0x0200,
+					ioaddr + MulticastFilter1+2);
+				iowrite16(ioread16(ioaddr + MACCtrl0) | EnbFlowCtrl,
+					ioaddr + MACCtrl0);
+			}
+			netif_carrier_on(dev);
 		} else {
-			mii_ctl = mdio_read (dev, np->phys[0], MII_BMCR);
-			speed = (mii_ctl & BMCR_SPEED100) ? 100 : 10;
-			np->speed = speed;
-			printk (KERN_INFO "%s: Link changed: %dMbps ,",
-				dev->name, speed);
-			printk ("%s duplex.\n", (mii_ctl & BMCR_FULLDPLX) ?
-				"full" : "half");
-		}
-		check_duplex (dev);
-		if (np->flowctrl && np->mii_if.full_duplex) {
-			iowrite16(ioread16(ioaddr + MulticastFilter1+2) | 0x0200,
-				ioaddr + MulticastFilter1+2);
-			iowrite16(ioread16(ioaddr + MACCtrl0) | EnbFlowCtrl,
-				ioaddr + MACCtrl0);
+			printk (KERN_INFO "%s: Link down\n", dev->name);
+			netif_carrier_off(dev);
 		}
 	}
 	if (intr_status & StatsMax) {
_

Patches currently in -mm which might be from dbn.lists@gmail.com are

sundance-set-carrier-status-on-link-change-events.patch

