From: akpm@osdl.org
Subject: + pci-mmconfig-only-call-unreachable_devices-when-type-1-is-available.patch added to -mm tree
Date: Thu, 14 Dec 2006 15:29:16 -0800
Message-ID: <200612142329.kBENTGO5032396@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbWLNX3X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 18:29:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: galibert@pobox.com, ak@suse.de


The patch titled
     PCI MMConfig: Only call unreachable_devices() when type 1 is available.
has been added to the -mm tree.  Its filename is
     pci-mmconfig-only-call-unreachable_devices-when-type-1-is-available.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
pci-mmconfig-share-whats-shareable.patch
pci-mmconfig-only-call-unreachable_devices-when-type-1-is-available.patch

