From: akpm@linux-foundation.org
Subject: - pnp-support-optional-irq-resources.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:53 -0700
Message-ID: <200806232103.m5NL3r4L016224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758289AbYFWVE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.det


The patch titled
     pnp: support optional IRQ resources
has been removed from the -mm tree.  Its filename was
     pnp-support-optional-irq-resources.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: support optional IRQ resources
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

This patch adds an IORESOURCE_IRQ_OPTIONAL flag for use when assigning
resources to a device.  If the flag is set and we are unable to assign an
IRQ to the device, we can leave the IRQ disabled but allow the overall
resource allocation to succeed.

Some devices request an IRQ, but can run without an IRQ (possibly with
degraded performance).  This flag lets us run the device without the IRQ
instead of just leaving the device disabled.

This is a reimplementation of this previous change by Rene
Herman <rene.herman@gmail.com>:
    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3b73a223661ed137c5d3d2635f954382e94f5a43

I reimplemented this for two reasons:
    - to prepare for converting all resource options into a single linked
      list, as opposed to the per-resource-type lists we have now, and
    - to preserve the order and number of resource options.

In PNPBIOS and ACPI, we configure a device by giving firmware a list of
resource assignments.  It is important that this list has exactly the same
number of resources, in the same order, as the "template" list we got from
the firmware in the first place.

The problem of a sound card MPU401 being left disabled for want of an IRQ
was reported by Uwe Bugla <uwe.bugla@gmx.de>.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/interface.c |    2 +
 drivers/pnp/manager.c   |    9 ++++
 drivers/pnp/quirks.c    |   69 ++++++++++++++------------------------
 include/linux/ioport.h  |    1 
 4 files changed, 39 insertions(+), 42 deletions(-)

diff -puN drivers/pnp/interface.c~pnp-support-optional-irq-resources drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-support-optional-irq-resources
+++ a/drivers/pnp/interface.c
@@ -90,6 +90,8 @@ static void pnp_print_irq(pnp_info_buffe
 		pnp_printf(buffer, " High-Level");
 	if (irq->flags & IORESOURCE_IRQ_LOWLEVEL)
 		pnp_printf(buffer, " Low-Level");
+	if (irq->flags & IORESOURCE_IRQ_OPTIONAL)
+		pnp_printf(buffer, " (optional)");
 	pnp_printf(buffer, "\n");
 }
 
diff -puN drivers/pnp/manager.c~pnp-support-optional-irq-resources drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-support-optional-irq-resources
+++ a/drivers/pnp/manager.c
@@ -153,6 +153,15 @@ static int pnp_assign_irq(struct pnp_dev
 				goto __add;
 		}
 	}
+
+	if (rule->flags & IORESOURCE_IRQ_OPTIONAL) {
+		res->start = -1;
+		res->end = -1;
+		res->flags |= IORESOURCE_DISABLED;
+		dev_dbg(&dev->dev, "  irq %d disabled (optional)\n", idx);
+		goto __add;
+	}
+
 	dev_dbg(&dev->dev, "  couldn't assign irq %d\n", idx);
 	return -EBUSY;
 
diff -puN drivers/pnp/quirks.c~pnp-support-optional-irq-resources drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-support-optional-irq-resources
+++ a/drivers/pnp/quirks.c
@@ -118,34 +118,46 @@ static struct pnp_option *quirk_isapnp_m
 	struct pnp_option *res;
 
 	/*
-	 * Build a functional IRQ-less variant of each MPU option.
+	 * Build a functional IRQ-optional variant of each MPU option.
 	 */
 
 	for (res = dev->dependent; res; res = res->next) {
 		struct pnp_option *curr;
 		struct pnp_port *port;
-		struct pnp_port *copy;
+		struct pnp_port *copy_port;
+		struct pnp_irq *irq;
+		struct pnp_irq *copy_irq;
 
 		port = res->port;
-		if (!port || !res->irq)
+		irq = res->irq;
+		if (!port || !irq)
 			continue;
 
-		copy = pnp_alloc(sizeof *copy);
-		if (!copy)
+		copy_port = pnp_alloc(sizeof *copy_port);
+		if (!copy_port)
 			break;
 
-		copy->min = port->min;
-		copy->max = port->max;
-		copy->align = port->align;
-		copy->size = port->size;
-		copy->flags = port->flags;
+		copy_irq = pnp_alloc(sizeof *copy_irq);
+		if (!copy_irq) {
+			kfree(copy_port);
+			break;
+		}
+
+		*copy_port = *port;
+		copy_port->next = NULL;
+
+		*copy_irq = *irq;
+		copy_irq->flags |= IORESOURCE_IRQ_OPTIONAL;
+		copy_irq->next = NULL;
 
 		curr = pnp_build_option(PNP_RES_PRIORITY_FUNCTIONAL);
 		if (!curr) {
-			kfree(copy);
+			kfree(copy_port);
+			kfree(copy_irq);
 			break;
 		}
-		curr->port = copy;
+		curr->port = copy_port;
+		curr->irq = copy_irq;
 
 		if (prev)
 			prev->next = curr;
@@ -154,7 +166,7 @@ static struct pnp_option *quirk_isapnp_m
 		prev = curr;
 	}
 	if (head)
-		dev_info(&dev->dev, "adding IRQ-less MPU options\n");
+		dev_info(&dev->dev, "adding IRQ-optional MPU options\n");
 
 	return head;
 }
@@ -164,10 +176,6 @@ static void quirk_ad1815_mpu_resources(s
 	struct pnp_option *res;
 	struct pnp_irq *irq;
 
-	/*
-	 * Distribute the independent IRQ over the dependent options
-	 */
-
 	res = dev->independent;
 	if (!res)
 		return;
@@ -176,33 +184,10 @@ static void quirk_ad1815_mpu_resources(s
 	if (!irq || irq->next)
 		return;
 
-	res = dev->dependent;
-	if (!res)
-		return;
-
-	while (1) {
-		struct pnp_irq *copy;
-
-		copy = pnp_alloc(sizeof *copy);
-		if (!copy)
-			break;
-
-		bitmap_copy(copy->map.bits, irq->map.bits, PNP_IRQ_NR);
-		copy->flags = irq->flags;
-
-		copy->next = res->irq; /* Yes, this is NULL */
-		res->irq = copy;
-
-		if (!res->next)
-			break;
-		res = res->next;
-	}
-	kfree(irq);
+	irq->flags |= IORESOURCE_IRQ_OPTIONAL;
+	dev_info(&dev->dev, "made independent IRQ optional\n");
 
 	res->next = quirk_isapnp_mpu_options(dev);
-
-	res = dev->independent;
-	res->irq = NULL;
 }
 
 static void quirk_isapnp_mpu_resources(struct pnp_dev *dev)
diff -puN include/linux/ioport.h~pnp-support-optional-irq-resources include/linux/ioport.h
--- a/include/linux/ioport.h~pnp-support-optional-irq-resources
+++ a/include/linux/ioport.h
@@ -59,6 +59,7 @@ struct resource_list {
 #define IORESOURCE_IRQ_HIGHLEVEL	(1<<2)
 #define IORESOURCE_IRQ_LOWLEVEL		(1<<3)
 #define IORESOURCE_IRQ_SHAREABLE	(1<<4)
+#define IORESOURCE_IRQ_OPTIONAL		(1<<5)
 
 /* PnP DMA specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_DMA_TYPE_MASK	(3<<0)
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

