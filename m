From: akpm@linux-foundation.org
Subject: - pnpacpi-fix-shareable-irq-encode-decode.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:37:59 -0700
Message-ID: <200806122037.m5CKbxGI005484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756263AbYFLUiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:38:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ThJaeger@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pnpacpi: fix shareable IRQ encode/decode
has been removed from the -mm tree.  Its filename was
     pnpacpi-fix-shareable-irq-encode-decode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnpacpi: fix shareable IRQ encode/decode
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

When we encode IRQ resources, we should use the "shareable" flag we got
from _PRS rather than guessing based on the IRQ trigger mode.

This is based on a patch by Tom Jaeger:
    http://bugzilla.kernel.org/show_bug.cgi?id=9487#c32

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Tom Jaeger <ThJaeger@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff -puN drivers/pnp/pnpacpi/rsparser.c~pnpacpi-fix-shareable-irq-encode-decode drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnpacpi-fix-shareable-irq-encode-decode
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -50,14 +50,14 @@ static int irq_flags(int triggering, int
 			flags = IORESOURCE_IRQ_HIGHEDGE;
 	}
 
-	if (shareable)
+	if (shareable == ACPI_SHARED)
 		flags |= IORESOURCE_IRQ_SHAREABLE;
 
 	return flags;
 }
 
 static void decode_irq_flags(struct pnp_dev *dev, int flags, int *triggering,
-			     int *polarity)
+			     int *polarity, int *shareable)
 {
 	switch (flags & (IORESOURCE_IRQ_LOWLEVEL | IORESOURCE_IRQ_HIGHLEVEL |
 			 IORESOURCE_IRQ_LOWEDGE  | IORESOURCE_IRQ_HIGHEDGE)) {
@@ -84,6 +84,11 @@ static void decode_irq_flags(struct pnp_
 		*polarity = ACPI_ACTIVE_HIGH;
 		break;
 	}
+
+	if (flags & IORESOURCE_IRQ_SHAREABLE)
+		*shareable = ACPI_SHARED;
+	else
+		*shareable = ACPI_EXCLUSIVE;
 }
 
 static void pnpacpi_parse_allocated_irqresource(struct pnp_dev *dev,
@@ -796,15 +801,12 @@ static void pnpacpi_encode_irq(struct pn
 			       struct resource *p)
 {
 	struct acpi_resource_irq *irq = &resource->data.irq;
-	int triggering, polarity;
+	int triggering, polarity, shareable;
 
-	decode_irq_flags(dev, p->flags, &triggering, &polarity);
+	decode_irq_flags(dev, p->flags, &triggering, &polarity, &shareable);
 	irq->triggering = triggering;
 	irq->polarity = polarity;
-	if (triggering == ACPI_EDGE_SENSITIVE)
-		irq->sharable = ACPI_EXCLUSIVE;
-	else
-		irq->sharable = ACPI_SHARED;
+	irq->sharable = shareable;
 	irq->interrupt_count = 1;
 	irq->interrupts[0] = p->start;
 
@@ -819,16 +821,13 @@ static void pnpacpi_encode_ext_irq(struc
 				   struct resource *p)
 {
 	struct acpi_resource_extended_irq *extended_irq = &resource->data.extended_irq;
-	int triggering, polarity;
+	int triggering, polarity, shareable;
 
-	decode_irq_flags(dev, p->flags, &triggering, &polarity);
+	decode_irq_flags(dev, p->flags, &triggering, &polarity, &shareable);
 	extended_irq->producer_consumer = ACPI_CONSUMER;
 	extended_irq->triggering = triggering;
 	extended_irq->polarity = polarity;
-	if (triggering == ACPI_EDGE_SENSITIVE)
-		extended_irq->sharable = ACPI_EXCLUSIVE;
-	else
-		extended_irq->sharable = ACPI_SHARED;
+	extended_irq->sharable = shareable;
 	extended_irq->interrupt_count = 1;
 	extended_irq->interrupts[0] = p->start;
 
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

