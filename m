From: akpm@linux-foundation.org
Subject: - pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-merge-fix.patch removed from -mm tree
Date: Thu, 05 Jun 2008 15:12:56 -0700
Message-ID: <200806052212.m55MCuNj032337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbYFEWNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 18:13:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     pnp-replace-pnp_resource_table-with-dynamically-allocated-resources fix
has been removed from the -mm tree.  Its filename was
     pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-merge-fix.patch

This patch was dropped because it was folded into pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp-replace-pnp_resource_table-with-dynamically-allocated-resources fix
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Not quite.  We need this instead:

        for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
                if (res->flags & IORESOURCE_DISABLED)
                        continue;

                reserve_range(dev, res->start, res->end, 0);
        }

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/system.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/pnp/system.c~pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-merge-fix drivers/pnp/system.c
--- a/drivers/pnp/system.c~pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-merge-fix
+++ a/drivers/pnp/system.c
@@ -78,8 +78,12 @@ static void reserve_resources_of_dev(str
 		reserve_range(dev, res->start, res->end, 1);
 	}
 
-	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++)
+	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
+		if (res->flags & IORESOURCE_DISABLED)
+			continue;
+
 		reserve_range(dev, res->start, res->end, 0);
+	}
 }
 
 static int system_pnp_probe(struct pnp_dev *dev,
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

pnp-skip-unset-mem-resources-as-well-as-disabled-ones.patch
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
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-fix.patch
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
pnp-convert-resource-options-to-single-linked-list-checkpatch-fixes.patch
make-pnp_add_card_id-static.patch

