From: akpm@linux-foundation.org
Subject: + dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch added to -mm tree
Date: Fri, 12 Feb 2010 12:08:07 -0800
Message-ID: <201002122008.o1CK87Fj024062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757468Ab0BLUIs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 15:08:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, benh@kernel.crashing.org, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org


The patch titled
     dma-mapping: powerpc: use generic pci_set_dma_mask and pci_set_consistent_dma_mask
has been added to the -mm tree.  Its filename is
     dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: powerpc: use generic pci_set_dma_mask and pci_set_consistent_dma_mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This converts powerpc to use the generic pci_set_dma_mask and
pci_set_consistent_dma_mask (drivers/pci/pci.c).

The generic pci_set_dma_mask does what powerpc's pci_set_dma_mask does.

Unlike powerpc's pci_set_consistent_dma_mask, the gneric
pci_set_consistent_dma_mask sets only coherent_dma_mask.  It doesn't work
for powerpc?  pci_set_consistent_dma_mask API should set only
coherent_dma_mask?

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/dma-mapping.h |    3 ---
 arch/powerpc/kernel/pci-common.c       |   15 ---------------
 2 files changed, 18 deletions(-)

diff -puN arch/powerpc/include/asm/dma-mapping.h~dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask arch/powerpc/include/asm/dma-mapping.h
--- a/arch/powerpc/include/asm/dma-mapping.h~dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask
+++ a/arch/powerpc/include/asm/dma-mapping.h
@@ -127,9 +127,6 @@ static inline int dma_supported(struct d
 	return dma_ops->dma_supported(dev, mask);
 }
 
-/* We have our own implementation of pci_set_dma_mask() */
-#define HAVE_ARCH_PCI_SET_DMA_MASK
-
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
diff -puN arch/powerpc/kernel/pci-common.c~dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask arch/powerpc/kernel/pci-common.c
--- a/arch/powerpc/kernel/pci-common.c~dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask
+++ a/arch/powerpc/kernel/pci-common.c
@@ -63,21 +63,6 @@ struct dma_map_ops *get_pci_dma_ops(void
 }
 EXPORT_SYMBOL(get_pci_dma_ops);
 
-int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	return dma_set_mask(&dev->dev, mask);
-}
-
-int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	int rc;
-
-	rc = dma_set_mask(&dev->dev, mask);
-	dev->dev.coherent_dma_mask = dev->dma_mask;
-
-	return rc;
-}
-
 struct pci_controller *pcibios_alloc_controller(struct device_node *dev)
 {
 	struct pci_controller *phb;
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
dma-mappingh-add-the-dma_unmap-state-api.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-alpha-use-include-linux-pci-dma-compath.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch

