From: akpm@osdl.org
Subject: - pci-mmconfig-only-call-unreachable_devices-when-type-1-is-available.patch removed from -mm tree
Date: Thu, 14 Dec 2006 14:57:45 -0800
Message-ID: <200612142257.kBEMvjTi031608@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39437 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbWLNW5z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 17:57:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: galibert@pobox.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     PCI MMConfig: Only call unreachable_devices() when type 1 is available.
has been removed from the -mm tree.  Its filename was
     pci-mmconfig-only-call-unreachable_devices-when-type-1-is-available.patch

This patch was dropped because upstream acpi changes trashed this patch

------------------------------------------------------
Subject: PCI MMConfig: Only call unreachable_devices() when type 1 is available.
From: Olivier Galibert <galibert@pobox.com>

unreachable_devices compares between the results of pci configuration accesses
through type1 and mmconfig, so it should be called only if type1 actually
works in the first place.

Signed-off-by: Olivier Galibert <galibert@pobox.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/mmconfig-shared.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/i386/pci/mmconfig-shared.c~pci-mmconfig-only-call-unreachable_devices-when-type-1-is-available arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~pci-mmconfig-only-call-unreachable_devices-when-type-1-is-available
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -80,7 +80,8 @@ void __init pci_mmcfg_init(int type)
 	}
 
 	if (pci_mmcfg_arch_init()) {
-		unreachable_devices();
+		if (type == 1)
+			unreachable_devices();
 		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
 	}
 }
_

Patches currently in -mm which might be from galibert@pobox.com are

bluetooth-add-support-for-another-kensington-dongle.patch
pci-mmconfig-only-call-unreachable_devices-when-type-1-is-available.patch
pci-mmconfig-only-map-whats-necessary.patch
pci-mmconfig-detect-and-support-the-e7520-and-the-945g-gz-p-pl.patch
pci-mmconfig-reserve-resources-but-only-when-were-sure-about-them.patch

