From: akpm@linux-foundation.org
Subject: - pnp-make-resource-assignment-functions-return-0-success-or-ebusy-failure.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:37 -0700
Message-ID: <200806232103.m5NL3bYa016198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758264AbYFWVE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commits@v


The patch titled
     pnp: make resource assignment functions return 0 (success) or -EBUSY (failure)
has been removed from the -mm tree.  Its filename was
     pnp-make-resource-assignment-functions-return-0-success-or-ebusy-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: make resource assignment functions return 0 (success) or -EBUSY (failure)
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

This patch doesn't change any behavior; it just makes the return values
more conventional.

This changes pnp_assign_dma() from a void function to one that returns an
int, just like the other assignment functions.  For now, at least,
pnp_assign_dma() always returns 0 (success), so it appears to never fail,
just like before.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/manager.c |   41 +++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff -puN drivers/pnp/manager.c~pnp-make-resource-assignment-functions-return-0-success-or-ebusy-failure drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-make-resource-assignment-functions-return-0-success-or-ebusy-failure
+++ a/drivers/pnp/manager.c
@@ -26,7 +26,7 @@ static int pnp_assign_port(struct pnp_de
 		dev_dbg(&dev->dev, "  io %d already set to %#llx-%#llx "
 			"flags %#lx\n", idx, (unsigned long long) res->start,
 			(unsigned long long) res->end, res->flags);
-		return 1;
+		return 0;
 	}
 
 	res = &local_res;
@@ -51,13 +51,13 @@ static int pnp_assign_port(struct pnp_de
 				"(min %#llx max %#llx)\n", idx,
 				(unsigned long long) rule->min,
 				(unsigned long long) rule->max);
-			return 0;
+			return -EBUSY;
 		}
 	}
 
 __add:
 	pnp_add_io_resource(dev, res->start, res->end, res->flags);
-	return 1;
+	return 0;
 }
 
 static int pnp_assign_mem(struct pnp_dev *dev, struct pnp_mem *rule, int idx)
@@ -69,7 +69,7 @@ static int pnp_assign_mem(struct pnp_dev
 		dev_dbg(&dev->dev, "  mem %d already set to %#llx-%#llx "
 			"flags %#lx\n", idx, (unsigned long long) res->start,
 			(unsigned long long) res->end, res->flags);
-		return 1;
+		return 0;
 	}
 
 	res = &local_res;
@@ -103,13 +103,13 @@ static int pnp_assign_mem(struct pnp_dev
 				"(min %#llx max %#llx)\n", idx,
 				(unsigned long long) rule->min,
 				(unsigned long long) rule->max);
-			return 0;
+			return -EBUSY;
 		}
 	}
 
 __add:
 	pnp_add_mem_resource(dev, res->start, res->end, res->flags);
-	return 1;
+	return 0;
 }
 
 static int pnp_assign_irq(struct pnp_dev *dev, struct pnp_irq *rule, int idx)
@@ -126,7 +126,7 @@ static int pnp_assign_irq(struct pnp_dev
 	if (res) {
 		dev_dbg(&dev->dev, "  irq %d already set to %d flags %#lx\n",
 			idx, (int) res->start, res->flags);
-		return 1;
+		return 0;
 	}
 
 	res = &local_res;
@@ -154,14 +154,14 @@ static int pnp_assign_irq(struct pnp_dev
 		}
 	}
 	dev_dbg(&dev->dev, "  couldn't assign irq %d\n", idx);
-	return 0;
+	return -EBUSY;
 
 __add:
 	pnp_add_irq_resource(dev, res->start, res->flags);
-	return 1;
+	return 0;
 }
 
-static void pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
+static int pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
 	struct resource *res, local_res;
 	int i;
@@ -175,7 +175,7 @@ static void pnp_assign_dma(struct pnp_de
 	if (res) {
 		dev_dbg(&dev->dev, "  dma %d already set to %d flags %#lx\n",
 			idx, (int) res->start, res->flags);
-		return;
+		return 0;
 	}
 
 	res = &local_res;
@@ -198,6 +198,7 @@ static void pnp_assign_dma(struct pnp_de
 
 __add:
 	pnp_add_dma_resource(dev, res->start, res->flags);
+	return 0;
 }
 
 void pnp_init_resources(struct pnp_dev *dev)
@@ -243,25 +244,26 @@ static int pnp_assign_resources(struct p
 		irq = dev->independent->irq;
 		dma = dev->independent->dma;
 		while (port) {
-			if (!pnp_assign_port(dev, port, nport))
+			if (pnp_assign_port(dev, port, nport) < 0)
 				goto fail;
 			nport++;
 			port = port->next;
 		}
 		while (mem) {
-			if (!pnp_assign_mem(dev, mem, nmem))
+			if (pnp_assign_mem(dev, mem, nmem) < 0)
 				goto fail;
 			nmem++;
 			mem = mem->next;
 		}
 		while (irq) {
-			if (!pnp_assign_irq(dev, irq, nirq))
+			if (pnp_assign_irq(dev, irq, nirq) < 0)
 				goto fail;
 			nirq++;
 			irq = irq->next;
 		}
 		while (dma) {
-			pnp_assign_dma(dev, dma, ndma);
+			if (pnp_assign_dma(dev, dma, ndma) < 0)
+				goto fail;
 			ndma++;
 			dma = dma->next;
 		}
@@ -281,25 +283,26 @@ static int pnp_assign_resources(struct p
 		irq = dep->irq;
 		dma = dep->dma;
 		while (port) {
-			if (!pnp_assign_port(dev, port, nport))
+			if (pnp_assign_port(dev, port, nport) < 0)
 				goto fail;
 			nport++;
 			port = port->next;
 		}
 		while (mem) {
-			if (!pnp_assign_mem(dev, mem, nmem))
+			if (pnp_assign_mem(dev, mem, nmem) < 0)
 				goto fail;
 			nmem++;
 			mem = mem->next;
 		}
 		while (irq) {
-			if (!pnp_assign_irq(dev, irq, nirq))
+			if (pnp_assign_irq(dev, irq, nirq) < 0)
 				goto fail;
 			nirq++;
 			irq = irq->next;
 		}
 		while (dma) {
-			pnp_assign_dma(dev, dma, ndma);
+			if (pnp_assign_dma(dev, dma, ndma) < 0)
+				goto fail;
 			ndma++;
 			dma = dma->next;
 		}
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

