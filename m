From: akpm@linux-foundation.org
Subject: - natsemi-add-support-for-using-mii-port-with-no-phy-update.patch removed from -mm tree
Date: Tue, 20 Feb 2007 12:10:39 -0800
Message-ID: <200702202010.l1KKAdIL018292@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46983 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030401AbXBTULI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 15:11:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@sirena.org.uk, jgarzik@pobox.com, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     natsemi: Add support for using MII port with no PHY (update)
has been removed from the -mm tree.  Its filename was
     natsemi-add-support-for-using-mii-port-with-no-phy-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: natsemi: Add support for using MII port with no PHY (update)
From: Mark Brown <broonie@sirena.org.uk>

Previous versions of this patch exposed the new functionality as a module
option.  This has been removed.  Any hardware that needs this should be
identifiable by a quirk since it unlikely to behave correctly with an
unmodified driver.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/natsemi.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff -puN drivers/net/natsemi.c~natsemi-add-support-for-using-mii-port-with-no-phy-update drivers/net/natsemi.c
--- a/drivers/net/natsemi.c~natsemi-add-support-for-using-mii-port-with-no-phy-update
+++ a/drivers/net/natsemi.c
@@ -146,7 +146,7 @@ MODULE_PARM_DESC(debug, "DP8381x default
 MODULE_PARM_DESC(rx_copybreak,
 	"DP8381x copy breakpoint for copy-only-tiny-frames");
 MODULE_PARM_DESC(options,
-	"DP8381x: Bits 0-3: media type, bit 17: full duplex, bit 18: ignore PHY");
+	"DP8381x: Bits 0-3: media type, bit 17: full duplex");
 MODULE_PARM_DESC(full_duplex, "DP8381x full duplex setting(s) (1)");
 
 /*
@@ -811,17 +811,7 @@ static int __devinit natsemi_probe1 (str
 	np->hands_off = 0;
 	np->intr_status = 0;
 	np->eeprom_size = natsemi_pci_info[chip_idx].eeprom_size;
-
-	option = find_cnt < MAX_UNITS ? options[find_cnt] : 0;
-	if (dev->mem_start)
-		option = dev->mem_start;
-
-	/* Ignore the PHY status? */
-	if (option & 0x400) {
-		np->ignore_phy = 1;
-	} else {
-		np->ignore_phy = 0;
-	}
+	np->ignore_phy = 0;
 
 	/* Initial port:
 	 * - If configured to ignore the PHY set up for external.
@@ -852,6 +842,10 @@ static int __devinit natsemi_probe1 (str
 		np->phy_addr_external = PHY_ADDR_INTERNAL;
 	}
 
+	option = find_cnt < MAX_UNITS ? options[find_cnt] : 0;
+	if (dev->mem_start)
+		option = dev->mem_start;
+
 	/* The lower four bits are the media type. */
 	if (option) {
 		if (option & 0x200)
@@ -1588,10 +1582,10 @@ static void check_link(struct net_device
 {
 	struct netdev_private *np = netdev_priv(dev);
 	void __iomem * ioaddr = ns_ioaddr(dev);
-	int duplex = np->full_duplex;
+	int duplex = np->duplex;
 	u16 bmsr;
 
-	/* If we're not paying attention to the PHY status then don't check. */
+	/* If we are ignoring the PHY then don't try reading it. */
 	if (!np->ignore_phy) {
 		/* The link status field is latched: it remains low
 		 * after a temporary link failure until it's read. We
@@ -1617,6 +1611,7 @@ static void check_link(struct net_device
 			do_cable_magic(dev);
 		}
 
+		duplex = np->full_duplex;
 		if (!duplex) {
 			if (bmsr & BMSR_ANEGCOMPLETE) {
 				int tmp = mii_nway_result(
_

Patches currently in -mm which might be from broonie@sirena.org.uk are

origin.patch
