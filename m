From: akpm@linux-foundation.org
Subject: + pnp-mark-resources-that-conflict-with-pci-devices-disabled.patch added to -mm tree
Date: Mon, 02 Jun 2008 15:55:23 -0700
Message-ID: <200806022255.m52MtOse004085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbYFBW4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2008 18:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, avuton@gmail.com, lenb@kernel.org, rene.herman@keyaccess.nl, rjw@sisk.pl


The patch titled
     PNP: mark resources that conflict with PCI devices "disabled"
has been added to the -mm tree.  Its filename is
     pnp-mark-resources-that-conflict-with-pci-devices-disabled.patch

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
Subject: PNP: mark resources that conflict with PCI devices "disabled"
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Both the PNP/PCI conflict detection quirk and the PNP system driver
must use the same mechanism to mark resources as disabled.

I think it's best to keep the resource and to keep the type bit
(IORESOURCE_MEM, etc), so that we match the list from firmware as
closely as possible.

Fixes this regression from 2.6.25: http://lkml.org/lkml/2008/6/1/82

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Tested-by: Avuton Olrich <avuton@gmail.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |    2 +-
 drivers/pnp/system.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/quirks.c~pnp-mark-resources-that-conflict-with-pci-devices-disabled drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-mark-resources-that-conflict-with-pci-devices-disabled
+++ a/drivers/pnp/quirks.c
@@ -286,7 +286,7 @@ static void quirk_system_pci_resources(s
 					pci_name(pdev), i,
 					(unsigned long long) pci_start,
 					(unsigned long long) pci_end);
-				res->flags = 0;
+				res->flags |= IORESOURCE_DISABLED;
 			}
 		}
 	}
diff -puN drivers/pnp/system.c~pnp-mark-resources-that-conflict-with-pci-devices-disabled drivers/pnp/system.c
--- a/drivers/pnp/system.c~pnp-mark-resources-that-conflict-with-pci-devices-disabled
+++ a/drivers/pnp/system.c
@@ -81,7 +81,7 @@ static void reserve_resources_of_dev(str
 	}
 
 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
-		if (res->flags & IORESOURCE_UNSET)
+		if (res->flags & IORESOURCE_DISABLED)
 			continue;
 
 		reserve_range(dev, res->start, res->end, 0);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

pnp-mark-resources-that-conflict-with-pci-devices-disabled.patch
acpi_pm_device_sleep_state-cleanup.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
provide-rtc_cmos-platform-device-take-2.patch
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
pnp-remove-ratelimit-on-add-resource-failures.patch
pnp-dont-sort-by-type-in-sys-resources.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

