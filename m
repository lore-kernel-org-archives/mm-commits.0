From: akpm@linux-foundation.org
Subject: + pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-merge-fix.patch added to -mm tree
Date: Tue, 03 Jun 2008 12:42:57 -0700
Message-ID: <200806031942.m53Jgv16016302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754362AbYFCTnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:43:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com


The patch titled
     pnp-replace-pnp_resource_table-with-dynamically-allocated-resources fix
has been added to the -mm tree.  Its filename is
     pnp-replace-pnp_resource_table-with-dynamically-allocated-resources-merge-fix.patch

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
make-pnp_add_card_id-static.patch

