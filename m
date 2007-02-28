From: akpm@linux-foundation.org
Subject: - spidernet-move-medium-variable-into-card-struct.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:52:58 -0800
Message-ID: <200702282352.l1SNqwdd031044@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48373 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932688AbXB1Xxa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:53:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jens@de.ibm.com, linas@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spidernet: move medium variable into card struct
has been removed from the -mm tree.  Its filename was
     spidernet-move-medium-variable-into-card-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
