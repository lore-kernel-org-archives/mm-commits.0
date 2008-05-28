From: akpm@linux-foundation.org
Subject: + pnpacpi-fix-irq-flag-decoding.patch added to -mm tree
Date: Tue, 27 May 2008 20:44:19 -0700
Message-ID: <200805280344.m4S3iJt2027371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbYE1Doa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 23:44:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ThJaeger@gmail.com


The patch titled
     pnpacpi: fix IRQ flag decoding
has been added to the -mm tree.  Its filename is
     pnpacpi-fix-irq-flag-decoding.patch

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

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Tom Jaeger <ThJaeger@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

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
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

acpi_pm_device_sleep_state-cleanup.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch
provide-rtc_cmos-platform-device-take-2.patch
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

