From: akpm@linux-foundation.org
Subject: + pnp-dont-fail-device-init-if-no-dma-channel.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:42:52 -0700
Message-ID: <200708242242.l7OMgqaP018497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47715 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760858AbXHXWn2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:43:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, ambx1@neo.rr.com, bjorn.helgaas@hp.com


The patch titled
     PNP: don't fail device init if no DMA channel available
has been added to the -mm tree.  Its filename is
     pnp-dont-fail-device-init-if-no-dma-channel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: don't fail device init if no DMA channel available
From: "Jan Beulich" <jbeulich@novell.com>

Most drivers for devices supporting ISA DMA can operate without DMA as well
(falling back zo PIO).  Thus it seems inappropriate for PNP to fail device
initialization in case none of the possible DMA channels are available. 
Instead, it should be left to the driver to decide what to do if
request_dma() fails.

The patch at once adjusts the code to account for the fact that
pnp_assign_dma() now doesn't need to report failure anymore.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/manager.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff -puN drivers/pnp/manager.c~pnp-dont-fail-device-init-if-no-dma-channel drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-dont-fail-device-init-if-no-dma-channel
+++ a/drivers/pnp/manager.c
@@ -161,7 +161,7 @@ static int pnp_assign_irq(struct pnp_dev
 	return 0;
 }
 
-static int pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
+static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
 	resource_size_t *start, *end;
 	unsigned long *flags;
@@ -173,15 +173,14 @@ static int pnp_assign_dma(struct pnp_dev
 	};
 
 	if (idx >= PNP_MAX_DMA) {
-		pnp_err
-		    ("More than 2 dmas is incompatible with pnp specifications.");
-		/* pretend we were successful so at least the manager won't try again */
-		return 1;
+		pnp_err("More than 2 dmas is incompatible with pnp "
+			"specifications.");
+		return;
 	}
 
 	/* check if this resource has been manually set, if so skip */
 	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
-		return 1;
+		return;
 
 	start = &dev->res.dma_resource[idx].start;
 	end = &dev->res.dma_resource[idx].end;
@@ -191,19 +190,17 @@ static int pnp_assign_dma(struct pnp_dev
 	*flags |= rule->flags | IORESOURCE_DMA;
 	*flags &= ~IORESOURCE_UNSET;
 
-	if (!rule->map) {
-		*flags |= IORESOURCE_DISABLED;
-		return 1;	/* skip disabled resource requests */
-	}
-
 	for (i = 0; i < 8; i++) {
 		if (rule->map & (1 << xtab[i])) {
 			*start = *end = xtab[i];
 			if (pnp_check_dma(dev, idx))
-				return 1;
+				return;
 		}
 	}
-	return 0;
+#ifdef MAX_DMA_CHANNELS
+	*start = *end = MAX_DMA_CHANNELS;
+#endif
+	*flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
 }
 
 /**
@@ -330,8 +327,7 @@ static int pnp_assign_resources(struct p
 			irq = irq->next;
 		}
 		while (dma) {
-			if (!pnp_assign_dma(dev, dma, ndma))
-				goto fail;
+			pnp_assign_dma(dev, dma, ndma);
 			ndma++;
 			dma = dma->next;
 		}
@@ -367,8 +363,7 @@ static int pnp_assign_resources(struct p
 			irq = irq->next;
 		}
 		while (dma) {
-			if (!pnp_assign_dma(dev, dma, ndma))
-				goto fail;
+			pnp_assign_dma(dev, dma, ndma);
 			ndma++;
 			dma = dma->next;
 		}
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
floppy-tolerate-dma-channel-unavailability.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
