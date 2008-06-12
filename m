From: akpm@linux-foundation.org
Subject: - pnpacpi-fix-irq-flag-decoding.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:57 -0700
Message-ID: <200806122037.m5CKbvNR005478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756152AbYFLUiG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:38:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ThJaeger@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pnpacpi: fix IRQ flag decoding
has been removed from the -mm tree.  Its filename was
     pnpacpi-fix-irq-flag-decoding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnpacpi: fix IRQ flag decoding
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

When decoding IRQ trigger mode and polarity, it is not enough to mask by
IORESOURCE_BITS because there are now additional bits defined.  For
example, if IORESOURCE_IRQ_SHAREABLE was set, we failed to set *triggering
and *polarity at all.

I can't point to a failure that this patch fixes, but
bugs in this area have caused problems when resuming after
suspend, for example:

    http://bugzilla.kernel.org/show_bug.cgi?id=6316
    http://bugzilla.kernel.org/show_bug.cgi?id=9487
    https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/152187

This is based on a patch by Tom Jaeger:
    http://bugzilla.kernel.org/show_bug.cgi?id=9487#c32

[rene.herman@keyaccess.nl: fix comment]
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Tom Jaeger <ThJaeger@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |   16 ++++++++++++----
 include/linux/ioport.h         |    6 +++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff -puN drivers/pnp/pnpacpi/rsparser.c~pnpacpi-fix-irq-flag-decoding drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnpacpi-fix-irq-flag-decoding
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -56,9 +56,11 @@ static int irq_flags(int triggering, int
 	return flags;
 }
 
-static void decode_irq_flags(int flag, int *triggering, int *polarity)
+static void decode_irq_flags(struct pnp_dev *dev, int flags, int *triggering,
+			     int *polarity)
 {
-	switch (flag) {
+	switch (flags & (IORESOURCE_IRQ_LOWLEVEL | IORESOURCE_IRQ_HIGHLEVEL |
+			 IORESOURCE_IRQ_LOWEDGE  | IORESOURCE_IRQ_HIGHEDGE)) {
 	case IORESOURCE_IRQ_LOWLEVEL:
 		*triggering = ACPI_LEVEL_SENSITIVE;
 		*polarity = ACPI_ACTIVE_LOW;
@@ -75,6 +77,12 @@ static void decode_irq_flags(int flag, i
 		*triggering = ACPI_EDGE_SENSITIVE;
 		*polarity = ACPI_ACTIVE_HIGH;
 		break;
+	default:
+		dev_err(&dev->dev, "can't encode invalid IRQ mode %#x\n",
+			flags);
+		*triggering = ACPI_EDGE_SENSITIVE;
+		*polarity = ACPI_ACTIVE_HIGH;
+		break;
 	}
 }
 
@@ -790,7 +798,7 @@ static void pnpacpi_encode_irq(struct pn
 	struct acpi_resource_irq *irq = &resource->data.irq;
 	int triggering, polarity;
 
-	decode_irq_flags(p->flags & IORESOURCE_BITS, &triggering, &polarity);
+	decode_irq_flags(dev, p->flags, &triggering, &polarity);
 	irq->triggering = triggering;
 	irq->polarity = polarity;
 	if (triggering == ACPI_EDGE_SENSITIVE)
@@ -813,7 +821,7 @@ static void pnpacpi_encode_ext_irq(struc
 	struct acpi_resource_extended_irq *extended_irq = &resource->data.extended_irq;
 	int triggering, polarity;
 
-	decode_irq_flags(p->flags & IORESOURCE_BITS, &triggering, &polarity);
+	decode_irq_flags(dev, p->flags, &triggering, &polarity);
 	extended_irq->producer_consumer = ACPI_CONSUMER;
 	extended_irq->triggering = triggering;
 	extended_irq->polarity = polarity;
diff -puN include/linux/ioport.h~pnpacpi-fix-irq-flag-decoding include/linux/ioport.h
--- a/include/linux/ioport.h~pnpacpi-fix-irq-flag-decoding
+++ a/include/linux/ioport.h
@@ -53,14 +53,14 @@ struct resource_list {
 #define IORESOURCE_AUTO		0x40000000
 #define IORESOURCE_BUSY		0x80000000	/* Driver has marked this resource busy */
 
-/* ISA PnP IRQ specific bits (IORESOURCE_BITS) */
+/* PnP IRQ specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_IRQ_HIGHEDGE		(1<<0)
 #define IORESOURCE_IRQ_LOWEDGE		(1<<1)
 #define IORESOURCE_IRQ_HIGHLEVEL	(1<<2)
 #define IORESOURCE_IRQ_LOWLEVEL		(1<<3)
 #define IORESOURCE_IRQ_SHAREABLE	(1<<4)
 
-/* ISA PnP DMA specific bits (IORESOURCE_BITS) */
+/* PnP DMA specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_DMA_TYPE_MASK	(3<<0)
 #define IORESOURCE_DMA_8BIT		(0<<0)
 #define IORESOURCE_DMA_8AND16BIT	(1<<0)
@@ -76,7 +76,7 @@ struct resource_list {
 #define IORESOURCE_DMA_TYPEB		(2<<6)
 #define IORESOURCE_DMA_TYPEF		(3<<6)
 
-/* ISA PnP memory I/O specific bits (IORESOURCE_BITS) */
+/* PnP memory I/O specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_MEM_WRITEABLE	(1<<0)	/* dup: IORESOURCE_READONLY */
 #define IORESOURCE_MEM_CACHEABLE	(1<<1)	/* dup: IORESOURCE_CACHEABLE */
 #define IORESOURCE_MEM_RANGELENGTH	(1<<2)	/* dup: IORESOURCE_RANGELENGTH */
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
provide-rtc_cmos-platform-device-take-2.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-fix.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way.patch
pnp-add-pnp_possible_config-can-a-device-could-be-configured-this-way-fix.patch
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
pnp-convert-resource-options-to-single-linked-list-checkpatch-fixes.patch
not-for-merging-pnp-changes-suspend-oops.patch
make-pnp_add_card_id-static.patch

