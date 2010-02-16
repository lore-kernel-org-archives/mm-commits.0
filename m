From: akpm@linux-foundation.org
Subject: + ssb-remove-the-ssb-dma-api.patch added to -mm tree
Date: Tue, 16 Feb 2010 13:40:41 -0800
Message-ID: <201002162140.o1GLefmP006618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933316Ab0BPVlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 16:41:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, Larry.Finger@lwfinger.net, davem@davemloft.net, linville@tuxdriver.com, mb@bu3sch.de, stefano.brivio@polimi.it, zambrano@broadcom.com


The patch titled
     ssb: remove the ssb DMA API
has been added to the -mm tree.  Its filename is
     ssb-remove-the-ssb-dma-api.patch

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
Subject: ssb: remove the ssb DMA API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Now they are unnecessary.  We can use the generic DMA API with any bus.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Gary Zambrano <zambrano@broadcom.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/main.c      |   74 -----------------
 include/linux/ssb/ssb.h |  157 --------------------------------------
 2 files changed, 231 deletions(-)

diff -puN drivers/ssb/main.c~ssb-remove-the-ssb-dma-api drivers/ssb/main.c
--- a/drivers/ssb/main.c~ssb-remove-the-ssb-dma-api
+++ a/drivers/ssb/main.c
@@ -1224,80 +1224,6 @@ u32 ssb_dma_translation(struct ssb_devic
 }
 EXPORT_SYMBOL(ssb_dma_translation);
 
-int ssb_dma_set_mask(struct ssb_device *dev, u64 mask)
-{
-#ifdef CONFIG_SSB_PCIHOST
-	int err;
-#endif
-
-	switch (dev->bus->bustype) {
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		err = pci_set_dma_mask(dev->bus->host_pci, mask);
-		if (err)
-			return err;
-		err = pci_set_consistent_dma_mask(dev->bus->host_pci, mask);
-		return err;
-#endif
-	case SSB_BUSTYPE_SSB:
-		return dma_set_mask(dev->dev, mask);
-	default:
-		__ssb_dma_not_implemented(dev);
-	}
-	return -ENOSYS;
-}
-EXPORT_SYMBOL(ssb_dma_set_mask);
-
-void * ssb_dma_alloc_consistent(struct ssb_device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t gfp_flags)
-{
-	switch (dev->bus->bustype) {
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		if (gfp_flags & GFP_DMA) {
-			/* Workaround: The PCI API does not support passing
-			 * a GFP flag. */
-			return dma_alloc_coherent(&dev->bus->host_pci->dev,
-						  size, dma_handle, gfp_flags);
-		}
-		return pci_alloc_consistent(dev->bus->host_pci, size, dma_handle);
-#endif
-	case SSB_BUSTYPE_SSB:
-		return dma_alloc_coherent(dev->dev, size, dma_handle, gfp_flags);
-	default:
-		__ssb_dma_not_implemented(dev);
-	}
-	return NULL;
-}
-EXPORT_SYMBOL(ssb_dma_alloc_consistent);
-
-void ssb_dma_free_consistent(struct ssb_device *dev, size_t size,
-			     void *vaddr, dma_addr_t dma_handle,
-			     gfp_t gfp_flags)
-{
-	switch (dev->bus->bustype) {
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		if (gfp_flags & GFP_DMA) {
-			/* Workaround: The PCI API does not support passing
-			 * a GFP flag. */
-			dma_free_coherent(&dev->bus->host_pci->dev,
-					  size, vaddr, dma_handle);
-			return;
-		}
-		pci_free_consistent(dev->bus->host_pci, size,
-				    vaddr, dma_handle);
-		return;
-#endif
-	case SSB_BUSTYPE_SSB:
-		dma_free_coherent(dev->dev, size, vaddr, dma_handle);
-		return;
-	default:
-		__ssb_dma_not_implemented(dev);
-	}
-}
-EXPORT_SYMBOL(ssb_dma_free_consistent);
-
 int ssb_bus_may_powerdown(struct ssb_bus *bus)
 {
 	struct ssb_chipcommon *cc;
diff -puN include/linux/ssb/ssb.h~ssb-remove-the-ssb-dma-api include/linux/ssb/ssb.h
--- a/include/linux/ssb/ssb.h~ssb-remove-the-ssb-dma-api
+++ a/include/linux/ssb/ssb.h
@@ -466,14 +466,6 @@ extern u32 ssb_dma_translation(struct ss
 #define SSB_DMA_TRANSLATION_MASK	0xC0000000
 #define SSB_DMA_TRANSLATION_SHIFT	30
 
-extern int ssb_dma_set_mask(struct ssb_device *dev, u64 mask);
-
-extern void * ssb_dma_alloc_consistent(struct ssb_device *dev, size_t size,
-				       dma_addr_t *dma_handle, gfp_t gfp_flags);
-extern void ssb_dma_free_consistent(struct ssb_device *dev, size_t size,
-				    void *vaddr, dma_addr_t dma_handle,
-				    gfp_t gfp_flags);
-
 static inline void __cold __ssb_dma_not_implemented(struct ssb_device *dev)
 {
 #ifdef CONFIG_SSB_DEBUG
@@ -482,155 +474,6 @@ static inline void __cold __ssb_dma_not_
 #endif /* DEBUG */
 }
 
-static inline int ssb_dma_mapping_error(struct ssb_device *dev, dma_addr_t addr)
-{
-	switch (dev->bus->bustype) {
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		return pci_dma_mapping_error(dev->bus->host_pci, addr);
-#endif
-		break;
-	case SSB_BUSTYPE_SSB:
-		return dma_mapping_error(dev->dev, addr);
-	default:
-		break;
-	}
-	__ssb_dma_not_implemented(dev);
-	return -ENOSYS;
-}
-
-static inline dma_addr_t ssb_dma_map_single(struct ssb_device *dev, void *p,
-					    size_t size, enum dma_data_direction dir)
-{
-	switch (dev->bus->bustype) {
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		return pci_map_single(dev->bus->host_pci, p, size, dir);
-#endif
-		break;
-	case SSB_BUSTYPE_SSB:
-		return dma_map_single(dev->dev, p, size, dir);
-	default:
-		break;
-	}
-	__ssb_dma_not_implemented(dev);
-	return 0;
-}
-
-static inline void ssb_dma_unmap_single(struct ssb_device *dev, dma_addr_t dma_addr,
-					size_t size, enum dma_data_direction dir)
-{
-	switch (dev->bus->bustype) {
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		pci_unmap_single(dev->bus->host_pci, dma_addr, size, dir);
-		return;
-#endif
-		break;
-	case SSB_BUSTYPE_SSB:
-		dma_unmap_single(dev->dev, dma_addr, size, dir);
-		return;
-	default:
-		break;
-	}
-	__ssb_dma_not_implemented(dev);
-}
-
-static inline void ssb_dma_sync_single_for_cpu(struct ssb_device *dev,
-					       dma_addr_t dma_addr,
-					       size_t size,
-					       enum dma_data_direction dir)
-{
-	switch (dev->bus->bustype) {
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		pci_dma_sync_single_for_cpu(dev->bus->host_pci, dma_addr,
-					    size, dir);
-		return;
-#endif
-		break;
-	case SSB_BUSTYPE_SSB:
-		dma_sync_single_for_cpu(dev->dev, dma_addr, size, dir);
-		return;
-	default:
-		break;
-	}
-	__ssb_dma_not_implemented(dev);
-}
-
-static inline void ssb_dma_sync_single_for_device(struct ssb_device *dev,
-						  dma_addr_t dma_addr,
-						  size_t size,
-						  enum dma_data_direction dir)
-{
-	switch (dev->bus->bustype) {
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		pci_dma_sync_single_for_device(dev->bus->host_pci, dma_addr,
-					       size, dir);
-		return;
-#endif
-		break;
-	case SSB_BUSTYPE_SSB:
-		dma_sync_single_for_device(dev->dev, dma_addr, size, dir);
-		return;
-	default:
-		break;
-	}
-	__ssb_dma_not_implemented(dev);
-}
-
-static inline void ssb_dma_sync_single_range_for_cpu(struct ssb_device *dev,
-						     dma_addr_t dma_addr,
-						     unsigned long offset,
-						     size_t size,
-						     enum dma_data_direction dir)
-{
-	switch (dev->bus->bustype) {
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		/* Just sync everything. That's all the PCI API can do. */
-		pci_dma_sync_single_for_cpu(dev->bus->host_pci, dma_addr,
-					    offset + size, dir);
-		return;
-#endif
-		break;
-	case SSB_BUSTYPE_SSB:
-		dma_sync_single_range_for_cpu(dev->dev, dma_addr, offset,
-					      size, dir);
-		return;
-	default:
-		break;
-	}
-	__ssb_dma_not_implemented(dev);
-}
-
-static inline void ssb_dma_sync_single_range_for_device(struct ssb_device *dev,
-							dma_addr_t dma_addr,
-							unsigned long offset,
-							size_t size,
-							enum dma_data_direction dir)
-{
-	switch (dev->bus->bustype) {
-	case SSB_BUSTYPE_PCI:
-#ifdef CONFIG_SSB_PCIHOST
-		/* Just sync everything. That's all the PCI API can do. */
-		pci_dma_sync_single_for_device(dev->bus->host_pci, dma_addr,
-					       offset + size, dir);
-		return;
-#endif
-		break;
-	case SSB_BUSTYPE_SSB:
-		dma_sync_single_range_for_device(dev->dev, dma_addr, offset,
-						 size, dir);
-		return;
-	default:
-		break;
-	}
-	__ssb_dma_not_implemented(dev);
-}
-
-
 #ifdef CONFIG_SSB_PCIHOST
 /* PCI-host wrapper driver */
 extern int ssb_pcihost_register(struct pci_driver *driver);
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

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
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

