From: akpm@linux-foundation.org
Subject: + pnpacpi-fix-shareable-irq-encode-decode.patch added to -mm tree
Date: Tue, 27 May 2008 15:57:58 -0700
Message-ID: <200805272257.m4RMvwN0017351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757397AbYE0W6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 18:58:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ThJaeger@gmail.com


The patch titled
     pnpacpi: fix shareable IRQ encode/decode
has been added to the -mm tree.  Its filename is
     pnpacpi-fix-shareable-irq-encode-decode.patch

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

acpi_pm_device_sleep_state-cleanup.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch
pnpacpi-fix-irq-flag-decoding.patch
pnpacpi-fix-shareable-irq-encode-decode.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
make-pnp_add_card_id-static.patch

