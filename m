From: akpm@linux-foundation.org
Subject: + pnp-improve-resource-assignment-debug.patch added to -mm tree
Date: Wed, 04 Jun 2008 22:57:19 -0700
Message-ID: <200806050557.m555vJLY028357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbYFEF6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 01:58:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de


The patch titled
     pnp: improve resource assignment debug
has been added to the -mm tree.  Its filename is
     pnp-improve-resource-assignment-debug.patch

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
Subject: pnp: improve resource assignment debug
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

When we fail to assign an I/O or MEM resource, include the min/max in the
debug output to help match it with the options.

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

 drivers/pnp/manager.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/manager.c~pnp-improve-resource-assignment-debug drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-improve-resource-assignment-debug
+++ a/drivers/pnp/manager.c
@@ -47,7 +47,10 @@ static int pnp_assign_port(struct pnp_de
 		res->start += rule->align;
 		res->end = res->start + rule->size - 1;
 		if (res->start > rule->max || !rule->align) {
-			dev_dbg(&dev->dev, "  couldn't assign io %d\n", idx);
+			dev_dbg(&dev->dev, "  couldn't assign io %d "
+				"(min %#llx max %#llx)\n", idx,
+				(unsigned long long) rule->min,
+				(unsigned long long) rule->max);
 			return 0;
 		}
 	}
@@ -96,7 +99,10 @@ static int pnp_assign_mem(struct pnp_dev
 		res->start += rule->align;
 		res->end = res->start + rule->size - 1;
 		if (res->start > rule->max || !rule->align) {
-			dev_dbg(&dev->dev, "  couldn't assign mem %d\n", idx);
+			dev_dbg(&dev->dev, "  couldn't assign mem %d "
+				"(min %#llx max %#llx)\n", idx,
+				(unsigned long long) rule->min,
+				(unsigned long long) rule->max);
 			return 0;
 		}
 	}
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

