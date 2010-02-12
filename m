From: akpm@linux-foundation.org
Subject: [merged] x86-agp-fix-agp_amd64_init-module-initialization-regression.patch removed from -mm tree
Date: Fri, 12 Feb 2010 11:03:32 -0800
Message-ID: <201002121903.o1CJ3Wc8021126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757052Ab0BLTEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:04:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, airlied@linux.ie, mingo@elte.hu, mitov@issp.bas.bg, mm-commits@vger.kernel.org


The patch titled
     x86/agp: fix agp_amd64_init module initialization regression
has been removed from the -mm tree.  Its filename was
     x86-agp-fix-agp_amd64_init-module-initialization-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86/agp: fix agp_amd64_init module initialization regression
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This fixes the regression introduced by commit
42590a75019a50012f25a962246498dead428433 ("x86/agp: Fix agp_amd64_init and
agp_amd64_cleanup").

The commit 61684ceaad4f65d1a9832c722f7bd5e7fc714de9 ("x86/agp: Fix
agp_amd64_init regression") fixed the above regression but there is still
a problem in the module initialization; when apg_amd64 is built as a
module, the GART IOMMU is not still initialized.

Reported-by: Marin Mitov <mitov@issp.bas.bg>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Marin Mitov <mitov@issp.bas.bg>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/amd64-agp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/char/agp/amd64-agp.c~x86-agp-fix-agp_amd64_init-module-initialization-regression drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c~x86-agp-fix-agp_amd64_init-module-initialization-regression
+++ a/drivers/char/agp/amd64-agp.c
@@ -767,16 +767,19 @@ int __init agp_amd64_init(void)
 
 static int __init agp_amd64_mod_init(void)
 {
+#ifndef MODULE
 	if (gart_iommu_aperture)
 		return agp_bridges_found ? 0 : -ENODEV;
-
+#endif
 	return agp_amd64_init();
 }
 
 static void __exit agp_amd64_cleanup(void)
 {
+#ifndef MODULE
 	if (gart_iommu_aperture)
 		return;
+#endif
 	if (aperture_resource)
 		release_resource(aperture_resource);
 	pci_unregister_driver(&agp_amd64_pci_driver);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch
documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-x86-use-include-linux-pci-dmah.patch
pci-dma-alpha-use-include-linux-pci-dmah.patch
pci-dma-arm-use-include-linux-pci-dmah.patch
pci-dma-frv-use-include-linux-pci-dmah.patch
pci-dma-ia64-use-include-linux-pci-dmah.patch
pci-dma-mips-use-include-linux-pci-dmah.patch
pci-dma-parisc-use-include-linux-pci-dmah.patch
pci-dma-powerpc-use-include-linux-pci-dmah.patch
pci-dma-sh-use-include-linux-pci-dmah.patch
pci-dma-sparc-use-include-linux-pci-dmah.patch
pci-dma-xtensa-use-include-linux-pci-dmah.patch
pci-dma-cris-use-include-linux-pci-dmah.patch
pci-dma-add-linux-pci-dmah-to-linux-pcih.patch

