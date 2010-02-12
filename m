From: akpm@linux-foundation.org
Subject: + frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch added to -mm tree
Date: Fri, 12 Feb 2010 11:52:09 -0800
Message-ID: <201002121952.o1CJq9jj023291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756421Ab0BLTw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:52:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, dhowells@redhat.com, jbarnes@virtuousgeek.org


The patch titled
     dma-mapping: frv: remove the obsolete and unnecessary DMA API comments
has been added to the -mm tree.  Its filename is
     frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch

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
Subject: dma-mapping: frv: remove the obsolete and unnecessary DMA API comments
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

pci_dma_sync_single was obsoleted long ago.

All the comments are generic, not architecture specific, simply describes
some of the DMA-API (and frv has the same comments in three files). 
Documentation/DMA-API.txt have more detailed descriptions.

This removes the above obsolete and unnecessary DMA API comments.  Let's
describe the DMA API in only Documentation/DMA-API.txt.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Howells <dhowells@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/dma-mapping.h    |   36 ------------------------
 arch/frv/mb93090-mb00/pci-dma-nommu.c |   30 --------------------
 arch/frv/mb93090-mb00/pci-dma.c       |   30 --------------------
 3 files changed, 96 deletions(-)

diff -puN arch/frv/include/asm/dma-mapping.h~frv-remove-the-obsolete-and-unnecessary-dma-api-comments arch/frv/include/asm/dma-mapping.h
--- a/arch/frv/include/asm/dma-mapping.h~frv-remove-the-obsolete-and-unnecessary-dma-api-comments
+++ a/arch/frv/include/asm/dma-mapping.h
@@ -16,24 +16,9 @@ extern unsigned long __nongprelbss dma_c
 void *dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t gfp);
 void dma_free_coherent(struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle);
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single is performed.
- */
 extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 				 enum dma_data_direction direction);
 
-/*
- * Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guarenteed to see
- * whatever the device wrote there.
- */
 static inline
 void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 		      enum dma_data_direction direction)
@@ -41,30 +26,9 @@ void dma_unmap_single(struct device *dev
 	BUG_ON(direction == DMA_NONE);
 }
 
-/*
- * Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scather-gather version of the
- * above pci_map_single interface.  Here the scatter gather list
- * elements are each tagged with the appropriate dma address
- * and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of
- *       DMA address/length pairs than there are SG table elements.
- *       (for example via virtual mapping capabilities)
- *       The routine returns the number of addr/length pairs actually
- *       used, at most nents.
- *
- * Device ownership issues as mentioned above for pci_map_single are
- * the same here.
- */
 extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 		      enum dma_data_direction direction);
 
-/*
- * Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
 static inline
 void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 	     enum dma_data_direction direction)
diff -puN arch/frv/mb93090-mb00/pci-dma-nommu.c~frv-remove-the-obsolete-and-unnecessary-dma-api-comments arch/frv/mb93090-mb00/pci-dma-nommu.c
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c~frv-remove-the-obsolete-and-unnecessary-dma-api-comments
+++ a/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -106,13 +106,6 @@ void dma_free_coherent(struct device *hw
 
 EXPORT_SYMBOL(dma_free_coherent);
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either dma_unmap_single or pci_dma_sync_single is performed.
- */
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 			  enum dma_data_direction direction)
 {
@@ -125,22 +118,6 @@ dma_addr_t dma_map_single(struct device 
 
 EXPORT_SYMBOL(dma_map_single);
 
-/*
- * Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scather-gather version of the
- * above dma_map_single interface.  Here the scatter gather list
- * elements are each tagged with the appropriate dma address
- * and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of
- *       DMA address/length pairs than there are SG table elements.
- *       (for example via virtual mapping capabilities)
- *       The routine returns the number of addr/length pairs actually
- *       used, at most nents.
- *
- * Device ownership issues as mentioned above for dma_map_single are
- * the same here.
- */
 int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	       enum dma_data_direction direction)
 {
@@ -157,13 +134,6 @@ int dma_map_sg(struct device *dev, struc
 
 EXPORT_SYMBOL(dma_map_sg);
 
-/*
- * Map a single page of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Device ownership issues as mentioned above for dma_map_single are
- * the same here.
- */
 dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
 			size_t size, enum dma_data_direction direction)
 {
diff -puN arch/frv/mb93090-mb00/pci-dma.c~frv-remove-the-obsolete-and-unnecessary-dma-api-comments arch/frv/mb93090-mb00/pci-dma.c
--- a/arch/frv/mb93090-mb00/pci-dma.c~frv-remove-the-obsolete-and-unnecessary-dma-api-comments
+++ a/arch/frv/mb93090-mb00/pci-dma.c
@@ -38,13 +38,6 @@ void dma_free_coherent(struct device *hw
 
 EXPORT_SYMBOL(dma_free_coherent);
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single is performed.
- */
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 			  enum dma_data_direction direction)
 {
@@ -57,22 +50,6 @@ dma_addr_t dma_map_single(struct device 
 
 EXPORT_SYMBOL(dma_map_single);
 
-/*
- * Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scather-gather version of the
- * above dma_map_single interface.  Here the scatter gather list
- * elements are each tagged with the appropriate dma address
- * and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of
- *       DMA address/length pairs than there are SG table elements.
- *       (for example via virtual mapping capabilities)
- *       The routine returns the number of addr/length pairs actually
- *       used, at most nents.
- *
- * Device ownership issues as mentioned above for dma_map_single are
- * the same here.
- */
 int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	       enum dma_data_direction direction)
 {
@@ -103,13 +80,6 @@ int dma_map_sg(struct device *dev, struc
 
 EXPORT_SYMBOL(dma_map_sg);
 
-/*
- * Map a single page of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Device ownership issues as mentioned above for dma_map_single are
- * the same here.
- */
 dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
 			size_t size, enum dma_data_direction direction)
 {
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

