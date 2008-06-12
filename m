From: akpm@linux-foundation.org
Subject: - pnpacpi-use-_crs-irq-descriptor-length-for-_srs-v2.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:38:01 -0700
Message-ID: <200806122038.m5CKc1Jp005487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756644AbYFLUi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:38:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, Robert.Moore@intel.com, ThJaeger@gmail.com, ambx1@neo.rr.com, castet.matthieu@free.fr, lenb@kernel.org, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     PNPACPI: use _CRS IRQ descriptor length for _SRS
has been removed from the -mm tree.  Its filename was
     pnpacpi-use-_crs-irq-descriptor-length-for-_srs-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

