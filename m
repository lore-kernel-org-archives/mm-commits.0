From: akpm@linux-foundation.org
Subject: + spidernet-move-medium-variable-into-card-struct.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:01:18 -0800
Message-ID: <200702251301.l1PD1L5a029813@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35715 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964921AbXBYNFP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jens@de.ibm.com, linas@austin.ibm.com


The patch titled
     spidernet: move medium variable into card struct
has been added to the -mm tree.  Its filename is
     spidernet-move-medium-variable-into-card-struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spidernet: move medium variable into card struct
From: Jens Osterkamp <jens@de.ibm.com>

This moves the medium variable into the spidernet card structure.  It renames
the GMII_ variables to BCM54XX specific ones.

Signed-off-by: Jens Osterkamp <jens@de.ibm.com>
Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/spider_net.c |   14 +++++++-------
 drivers/net/spider_net.h |    2 ++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-move-medium-variable-into-card-struct drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-move-medium-variable-into-card-struct
+++ a/drivers/net/spider_net.c
@@ -1909,26 +1909,26 @@ static void spider_net_link_phy(unsigned
 
 		pr_info("%s: link is down trying to bring it up\n", card->netdev->name);
 
-		switch (phy->medium) {
-		case GMII_COPPER:
+		switch (card->medium) {
+		case BCM54XX_COPPER:
 			/* enable fiber with autonegotiation first */
 			if (phy->def->ops->enable_fiber)
 				phy->def->ops->enable_fiber(phy, 1);
-			phy->medium = GMII_FIBER;
+			card->medium = BCM54XX_FIBER;
 			break;
 
-		case GMII_FIBER:
+		case BCM54XX_FIBER:
 			/* fiber didn't come up, try to disable fiber autoneg */
 			if (phy->def->ops->enable_fiber)
 				phy->def->ops->enable_fiber(phy, 0);
-			phy->medium = GMII_UNKNOWN;
+			card->medium = BCM54XX_UNKNOWN;
 			break;
 
-		case GMII_UNKNOWN:
+		case BCM54XX_UNKNOWN:
 			/* copper, fiber with and without failed,
 			 * retry from beginning */
 			spider_net_setup_aneg(card);
-			phy->medium = GMII_COPPER;
+			card->medium = BCM54XX_COPPER;
 			break;
 		}
 
diff -puN drivers/net/spider_net.h~spidernet-move-medium-variable-into-card-struct drivers/net/spider_net.h
--- a/drivers/net/spider_net.h~spidernet-move-medium-variable-into-card-struct
+++ a/drivers/net/spider_net.h
@@ -444,6 +444,8 @@ struct spider_net_card {
 	struct pci_dev *pdev;
 	struct mii_phy phy;
 
+	int medium;
+
 	void __iomem *regs;
 
 	struct spider_net_descr_chain tx_chain;
_

Patches currently in -mm which might be from jens@de.ibm.com are

sungem_phy-support-bcm5461-phy-autoneg.patch
spidernet-move-medium-variable-into-card-struct.patch
