From: akpm@linux-foundation.org
Subject: - ibm_newemac-fix-new-mal-feature-handling.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:21:04 -0700
Message-ID: <200810182321.m9INL4NN029884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbYJRXVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:21:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jwboyer@linux.vnet.ibm.com, benh@kernel.crashing.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ibm_newemac: fix new MAL feature handling
has been removed from the -mm tree.  Its filename was
     ibm_newemac-fix-new-mal-feature-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibm_newemac: fix new MAL feature handling
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>

drivers/net/ibm_newemac/mal.c: In function 'mal_txeob':
drivers/net/ibm_newemac/mal.c:284: error: implicit declaration of function 'mtdcri'
drivers/net/ibm_newemac/mal.c:284: error: 'SDR0' undeclared (first use in this function)
drivers/net/ibm_newemac/mal.c:284: error: (Each undeclared identifier is reported only once
drivers/net/ibm_newemac/mal.c:284: error: for each function it appears in.)
drivers/net/ibm_newemac/mal.c:285: error: implicit declaration of function 'mfdcri'
drivers/net/ibm_newemac/mal.c: In function 'mal_rxeob':
drivers/net/ibm_newemac/mal.c:302: error: 'SDR0' undeclared (first use in this function)


Support for new features needed by the PPC 405EZ boards introduced some
errors in the MAL and EMAC feature handling.  This broke 'allmodconfig'
builds as CONFIG_PPC_DCR_NATIVE is not set for those.

This patch fixes these errors by wrapping the code in the appropriate
#ifdefs.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ibm_newemac/core.c |   10 +++++++++-
 drivers/net/ibm_newemac/mal.c  |   15 ++++++++++++++-
 2 files changed, 23 insertions(+), 2 deletions(-)

diff -puN drivers/net/ibm_newemac/core.c~ibm_newemac-fix-new-mal-feature-handling drivers/net/ibm_newemac/core.c
--- a/drivers/net/ibm_newemac/core.c~ibm_newemac-fix-new-mal-feature-handling
+++ a/drivers/net/ibm_newemac/core.c
@@ -2604,8 +2604,16 @@ static int __devinit emac_init_config(st
 		if (of_device_is_compatible(np, "ibm,emac-440ep") ||
 		    of_device_is_compatible(np, "ibm,emac-440gr"))
 			dev->features |= EMAC_FTR_440EP_PHY_CLK_FIX;
-		if (of_device_is_compatible(np, "ibm,emac-405ez"))
+		if (of_device_is_compatible(np, "ibm,emac-405ez")) {
+#ifdef CONFIG_IBM_NEW_EMAC_NO_FLOW_CONTROL
 			dev->features |= EMAC_FTR_NO_FLOW_CONTROL_40x;
+#else
+			printk(KERN_ERR "%s: Flow control not disabled!\n",
+					np->full_name);
+			return -ENXIO;
+#endif
+		}
+
 	}
 
 	/* Fixup some feature bits based on the device tree */
diff -puN drivers/net/ibm_newemac/mal.c~ibm_newemac-fix-new-mal-feature-handling drivers/net/ibm_newemac/mal.c
--- a/drivers/net/ibm_newemac/mal.c~ibm_newemac-fix-new-mal-feature-handling
+++ a/drivers/net/ibm_newemac/mal.c
@@ -280,9 +280,11 @@ static irqreturn_t mal_txeob(int irq, vo
 	mal_schedule_poll(mal);
 	set_mal_dcrn(mal, MAL_TXEOBISR, r);
 
+#ifdef CONFIG_PPC_DCR_NATIVE
 	if (mal_has_feature(mal, MAL_FTR_CLEAR_ICINTSTAT))
 		mtdcri(SDR0, DCRN_SDR_ICINTSTAT,
 				(mfdcri(SDR0, DCRN_SDR_ICINTSTAT) | ICINTSTAT_ICTX));
+#endif
 
 	return IRQ_HANDLED;
 }
@@ -298,9 +300,11 @@ static irqreturn_t mal_rxeob(int irq, vo
 	mal_schedule_poll(mal);
 	set_mal_dcrn(mal, MAL_RXEOBISR, r);
 
+#ifdef CONFIG_PPC_DCR_NATIVE
 	if (mal_has_feature(mal, MAL_FTR_CLEAR_ICINTSTAT))
 		mtdcri(SDR0, DCRN_SDR_ICINTSTAT,
 				(mfdcri(SDR0, DCRN_SDR_ICINTSTAT) | ICINTSTAT_ICRX));
+#endif
 
 	return IRQ_HANDLED;
 }
@@ -572,9 +576,18 @@ static int __devinit mal_probe(struct of
 		goto fail;
 	}
 
-	if (of_device_is_compatible(ofdev->node, "ibm,mcmal-405ez"))
+	if (of_device_is_compatible(ofdev->node, "ibm,mcmal-405ez")) {
+#if defined(CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT) && \
+		defined(CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR)
 		mal->features |= (MAL_FTR_CLEAR_ICINTSTAT |
 				MAL_FTR_COMMON_ERR_INT);
+#else
+		printk(KERN_ERR "%s: Support for 405EZ not enabled!\n",
+				ofdev->node->full_name);
+		err = -ENODEV;
+		goto fail;
+#endif
+	}
 
 	mal->txeob_irq = irq_of_parse_and_map(ofdev->node, 0);
 	mal->rxeob_irq = irq_of_parse_and_map(ofdev->node, 1);
_

Patches currently in -mm which might be from jwboyer@linux.vnet.ibm.com are

origin.patch

