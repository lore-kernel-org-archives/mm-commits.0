From: akpm@linux-foundation.org
Subject: + pnp-support-optional-irq-resources.patch added to -mm tree
Date: Wed, 04 Jun 2008 22:57:33 -0700
Message-ID: <200806050557.m555vXKp028378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbYFEGJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 02:09:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, rene.herman@keyaccess.nl, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, uwe.bugla@gmx.de


The patch titled
     pnp: support optional IRQ resources
has been added to the -mm tree.  Its filename is
     pnp-support-optional-irq-resources.patch

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

pnp-mark-resources-that-conflict-with-pci-devices-disabled.patch
acpi_pm_device_sleep_state-cleanup.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
provide-rtc_cmos-platform-device-take-2.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
pnpacpi-fix-irq-flag-decoding.patch
pnpacpi-fix-irq-flag-decoding-comment-fix.patch
pnpacpi-fix-shareable-irq-encode-decode.patch
pnpacpi-use-_crs-irq-descriptor-length-for-_srs-v2.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-merge-fix.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way.patch
pnp-whitespace-coding-style-fixes.patch
pnp-define-pnp-specific-ioresource_io_-flags-alongside-irq-dma-mem.patch
pnp-make-resource-option-structures-private-to-pnp-subsystem.patch
pnp-introduce-pnp_irq_mask_t-typedef.patch
pnp-increase-i-o-port-memory-option-address-sizes.patch
pnp-improve-resource-assignment-debug.patch
pnp-in-debug-resource-dump-make-empty-list-obvious.patch
pnp-make-resource-assignment-functions-return-0-success-or-ebusy-failure.patch
pnp-remove-redundant-pnp_can_configure-check.patch
pnp-centralize-resource-option-allocations.patch
pnpacpi-ignore-_prs-interrupt-numbers-larger-than-pnp_irq_nr.patch
pnp-rename-pnp_register__resource-local-variables.patch
pnp-support-optional-irq-resources.patch
pnp-remove-extra-0x100-bit-from-option-priority.patch
isapnp-handle-independent-options-following-dependent-ones.patch
pnp-convert-resource-options-to-single-linked-list.patch
make-pnp_add_card_id-static.patch

