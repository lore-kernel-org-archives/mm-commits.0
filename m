From: akpm@linux-foundation.org
Subject: + pnpacpi-use-_crs-irq-descriptor-length-for-_srs-v2.patch added to -mm tree
Date: Tue, 27 May 2008 22:43:52 -0700
Message-ID: <200805280543.m4S5hqeT031424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbYE1FoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 01:44:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, Robert.Moore@intel.com, ThJaeger@gmail.com, ambx1@neo.rr.com, castet.matthieu@free.fr, lenb@kernel.org, shaohua.li@intel.com


The patch titled
     PNPACPI: use _CRS IRQ descriptor length for _SRS
has been added to the -mm tree.  Its filename is
     pnpacpi-use-_crs-irq-descriptor-length-for-_srs-v2.patch

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
Subject: PNPACPI: use _CRS IRQ descriptor length for _SRS
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

When configuring the resources of an ACPI device, we first evaluate _CRS
to get a template of resource descriptors, then fill in the specific
resource values we want, and finally evaluate _SRS to actually configure
the device.

Some resources have optional fields, so the size of encoded descriptors
varies depending on the specific values.  For example, IRQ descriptors can
be either two or three bytes long.  The third byte contains triggering
information and can be omitted if the IRQ is edge-triggered and active
high.

The BIOS often assumes that IRQ descriptors in the _SRS buffer use the
same format as those in the _CRS buffer, so this patch enforces that
constraint.

The "Start Dependent Function" descriptor also has an optional byte, but
we don't currently encode those descriptors, so I didn't do anything for
those.

I have tested this patch on a Toshiba Portege 4000.  Without the patch,
parport_pc claims the parallel port only if I use "pnpacpi=off".  This
patch makes it work with PNPACPI.

This is an extension of a patch by Tom Jaeger:
    http://bugzilla.kernel.org/show_bug.cgi?id=9487#c42

References:
    http://bugzilla.kernel.org/show_bug.cgi?id=5832 Enabling ACPI Plug and Play in kernels >2.6.9 kills Parallel support
    http://bugzilla.kernel.org/show_bug.cgi?id=9487 buggy firmware expects four-byte IRQ resource descriptor (was: Serial port disappears after Suspend on Toshiba R25)
    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1d5b285da1893b90507b081664ac27f1a8a3dc5b related ACPICA fix

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Tom Jaeger <ThJaeger@gmail.com>
Cc: Robert Moore <Robert.Moore@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/pnpacpi/rsparser.c~pnpacpi-use-_crs-irq-descriptor-length-for-_srs-v2 drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnpacpi-use-_crs-irq-descriptor-length-for-_srs-v2
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -755,6 +755,9 @@ static acpi_status pnpacpi_type_resource
 	if (pnpacpi_supported_resource(res)) {
 		(*resource)->type = res->type;
 		(*resource)->length = sizeof(struct acpi_resource);
+		if (res->type == ACPI_RESOURCE_TYPE_IRQ)
+			(*resource)->data.irq.descriptor_length =
+					res->data.irq.descriptor_length;
 		(*resource)++;
 	}
 
@@ -810,10 +813,12 @@ static void pnpacpi_encode_irq(struct pn
 	irq->interrupt_count = 1;
 	irq->interrupts[0] = p->start;
 
-	dev_dbg(&dev->dev, "  encode irq %d %s %s %s\n", (int) p->start,
+	dev_dbg(&dev->dev, "  encode irq %d %s %s %s (%d-byte descriptor)\n",
+		(int) p->start,
 		triggering == ACPI_LEVEL_SENSITIVE ? "level" : "edge",
 		polarity == ACPI_ACTIVE_LOW ? "low" : "high",
-		irq->sharable == ACPI_SHARED ? "shared" : "exclusive");
+		irq->sharable == ACPI_SHARED ? "shared" : "exclusive",
+		irq->descriptor_length);
 }
 
 static void pnpacpi_encode_ext_irq(struct pnp_dev *dev,
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

acpi_pm_device_sleep_state-cleanup.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch
provide-rtc_cmos-platform-device-take-2.patch
pnpacpi-fix-irq-flag-decoding.patch
pnpacpi-fix-shareable-irq-encode-decode.patch
pnpacpi-use-_crs-irq-descriptor-length-for-_srs-v2.patch
pnp-add-detail-to-debug-resource-dump.patch
pnp-remove-pnp_resourceindex.patch
pnp-add-pnp_resource_type-internal-interface.patch
pnp-add-pnp_resource_type_name-helper-function.patch
pnp-make-pnp_portmemetc_start-et-al-work-for-invalid-resources.patch
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
make-pnp_add_card_id-static.patch

