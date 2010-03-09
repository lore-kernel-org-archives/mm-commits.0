From: akpm@linux-foundation.org
Subject: + documentation-remove-the-pci-dma-api-description-in-dma-apitxt.patch added to -mm tree
Date: Tue, 09 Mar 2010 12:00:13 -0800
Message-ID: <201003092000.o29K0DN8001809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841Ab0CIUAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 15:00:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, davem@davemloft.net, randy.dunlap@oracle.com


The patch titled
     Documentation: remove the PCI DMA API description in DMA-API.txt
has been added to the -mm tree.  Its filename is
     documentation-remove-the-pci-dma-api-description-in-dma-apitxt.patch

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
Subject: Documentation: remove the PCI DMA API description in DMA-API.txt
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

- remove the PCI DMA API description in DMA-API.txt
- remove the descriptions of dma_unmap macros since
  PCI-DMA-mapping.txt has the same description.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |  152 +++---------------------------------
 1 file changed, 15 insertions(+), 137 deletions(-)

diff -puN Documentation/DMA-API.txt~documentation-remove-the-pci-dma-api-description-in-dma-apitxt Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~documentation-remove-the-pci-dma-api-description-in-dma-apitxt
+++ a/Documentation/DMA-API.txt
@@ -4,20 +4,18 @@
         James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
 
 This document describes the DMA API.  For a more gentle introduction
-phrased in terms of the pci_ equivalents (and actual examples) see
+of the API (and actual examples) see
 Documentation/PCI/PCI-DMA-mapping.txt.
 
-This API is split into two pieces.  Part I describes the API and the
-corresponding pci_ API.  Part II describes the extensions to the API
-for supporting non-consistent memory machines.  Unless you know that
-your driver absolutely has to support non-consistent platforms (this
-is usually only legacy platforms) you should only use the API
-described in part I.
+This API is split into two pieces.  Part I describes the API.  Part II
+describes the extensions to the API for supporting non-consistent
+memory machines.  Unless you know that your driver absolutely has to
+support non-consistent platforms (this is usually only legacy
+platforms) you should only use the API described in part I.
 
-Part I - pci_ and dma_ Equivalent API 
+Part I - dma_ API
 -------------------------------------
 
-To get the pci_ API, you must #include <linux/pci.h>
 To get the dma_ API, you must #include <linux/dma-mapping.h>
 
 
@@ -27,9 +25,6 @@ Part Ia - Using large dma-coherent buffe
 void *
 dma_alloc_coherent(struct device *dev, size_t size,
 			     dma_addr_t *dma_handle, gfp_t flag)
-void *
-pci_alloc_consistent(struct pci_dev *dev, size_t size,
-			     dma_addr_t *dma_handle)
 
 Consistent memory is memory for which a write by either the device or
 the processor can immediately be read by the processor or device
@@ -53,15 +48,11 @@ The simplest way to do that is to use th
 The flag parameter (dma_alloc_coherent only) allows the caller to
 specify the GFP_ flags (see kmalloc) for the allocation (the
 implementation may choose to ignore flags that affect the location of
-the returned memory, like GFP_DMA).  For pci_alloc_consistent, you
-must assume GFP_ATOMIC behaviour.
+the returned memory, like GFP_DMA).
 
 void
 dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
 			   dma_addr_t dma_handle)
-void
-pci_free_consistent(struct pci_dev *dev, size_t size, void *cpu_addr,
-			   dma_addr_t dma_handle)
 
 Free the region of consistent memory you previously allocated.  dev,
 size and dma_handle must all be the same as those passed into the
@@ -89,10 +80,6 @@ for alignment, like queue heads needing 
 	dma_pool_create(const char *name, struct device *dev,
 			size_t size, size_t align, size_t alloc);
 
-	struct pci_pool *
-	pci_pool_create(const char *name, struct pci_device *dev,
-			size_t size, size_t align, size_t alloc);
-
 The pool create() routines initialize a pool of dma-coherent buffers
 for use with a given device.  It must be called in a context which
 can sleep.
@@ -108,9 +95,6 @@ from this pool must not cross 4KByte bou
 	void *dma_pool_alloc(struct dma_pool *pool, gfp_t gfp_flags,
 			dma_addr_t *dma_handle);
 
-	void *pci_pool_alloc(struct pci_pool *pool, gfp_t gfp_flags,
-			dma_addr_t *dma_handle);
-
 This allocates memory from the pool; the returned memory will meet the size
 and alignment requirements specified at creation time.  Pass GFP_ATOMIC to
 prevent blocking, or if it's permitted (not in_interrupt, not holding SMP locks),
@@ -122,9 +106,6 @@ pool's device.
 	void dma_pool_free(struct dma_pool *pool, void *vaddr,
 			dma_addr_t addr);
 
-	void pci_pool_free(struct pci_pool *pool, void *vaddr,
-			dma_addr_t addr);
-
 This puts memory back into the pool.  The pool is what was passed to
 the pool allocation routine; the cpu (vaddr) and dma addresses are what
 were returned when that routine allocated the memory being freed.
@@ -132,8 +113,6 @@ were returned when that routine allocate
 
 	void dma_pool_destroy(struct dma_pool *pool);
 
-	void pci_pool_destroy(struct pci_pool *pool);
-
 The pool destroy() routines free the resources of the pool.  They must be
 called in a context which can sleep.  Make sure you've freed all allocated
 memory back to the pool before you destroy it.
@@ -144,8 +123,6 @@ Part Ic - DMA addressing limitations
 
 int
 dma_supported(struct device *dev, u64 mask)
-int
-pci_dma_supported(struct pci_dev *hwdev, u64 mask)
 
 Checks to see if the device can support DMA to the memory described by
 mask.
@@ -159,8 +136,6 @@ driver writers.
 
 int
 dma_set_mask(struct device *dev, u64 mask)
-int
-pci_set_dma_mask(struct pci_device *dev, u64 mask)
 
 Checks to see if the mask is possible and updates the device
 parameters if it is.
@@ -169,8 +144,6 @@ Returns: 0 if successful and a negative 
 
 int
 dma_set_coherent_mask(struct device *dev, u64 mask)
-int
-pci_set_consistent_dma_mask(struct pci_device *dev, u64 mask)
 
 Checks to see if the mask is possible and updates the device
 parameters if it is.
@@ -197,9 +170,6 @@ Part Id - Streaming DMA mappings
 dma_addr_t
 dma_map_single(struct device *dev, void *cpu_addr, size_t size,
 		      enum dma_data_direction direction)
-dma_addr_t
-pci_map_single(struct pci_dev *hwdev, void *cpu_addr, size_t size,
-		      int direction)
 
 Maps a piece of processor virtual memory so it can be accessed by the
 device and returns the physical handle of the memory.
@@ -208,14 +178,10 @@ The direction for both api's may be conv
 However the dma_ API uses a strongly typed enumerator for its
 direction:
 
-DMA_NONE		= PCI_DMA_NONE		no direction (used for
-						debugging)
-DMA_TO_DEVICE		= PCI_DMA_TODEVICE	data is going from the
-						memory to the device
-DMA_FROM_DEVICE		= PCI_DMA_FROMDEVICE	data is coming from
-						the device to the
-						memory
-DMA_BIDIRECTIONAL	= PCI_DMA_BIDIRECTIONAL	direction isn't known
+DMA_NONE		no direction (used for debugging)
+DMA_TO_DEVICE		data is going from the memory to the device
+DMA_FROM_DEVICE		data is coming from the device to the memory
+DMA_BIDIRECTIONAL	direction isn't known
 
 Notes:  Not all memory regions in a machine can be mapped by this
 API.  Further, regions that appear to be physically contiguous in
@@ -278,9 +244,6 @@ cache lines are updated with data that t
 void
 dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 		 enum dma_data_direction direction)
-void
-pci_unmap_single(struct pci_dev *hwdev, dma_addr_t dma_addr,
-		 size_t size, int direction)
 
 Unmaps the region previously mapped.  All the parameters passed in
 must be identical to those passed in (and returned) by the mapping
@@ -290,15 +253,9 @@ dma_addr_t
 dma_map_page(struct device *dev, struct page *page,
 		    unsigned long offset, size_t size,
 		    enum dma_data_direction direction)
-dma_addr_t
-pci_map_page(struct pci_dev *hwdev, struct page *page,
-		    unsigned long offset, size_t size, int direction)
 void
 dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
 	       enum dma_data_direction direction)
-void
-pci_unmap_page(struct pci_dev *hwdev, dma_addr_t dma_address,
-	       size_t size, int direction)
 
 API for mapping and unmapping for pages.  All the notes and warnings
 for the other mapping APIs apply here.  Also, although the <offset>
@@ -309,9 +266,6 @@ cache width is.
 int
 dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
-int
-pci_dma_mapping_error(struct pci_dev *hwdev, dma_addr_t dma_addr)
-
 In some circumstances dma_map_single and dma_map_page will fail to create
 a mapping. A driver can check for these errors by testing the returned
 dma address with dma_mapping_error(). A non-zero return value means the mapping
@@ -321,9 +275,6 @@ reduce current DMA mapping usage or dela
 	int
 	dma_map_sg(struct device *dev, struct scatterlist *sg,
 		int nents, enum dma_data_direction direction)
-	int
-	pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sg,
-		int nents, int direction)
 
 Returns: the number of physical segments mapped (this may be shorter
 than <nents> passed in if some elements of the scatter/gather list are
@@ -363,9 +314,6 @@ accessed sg->address and sg->length as s
 	void
 	dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 		int nhwentries, enum dma_data_direction direction)
-	void
-	pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sg,
-		int nents, int direction)
 
 Unmap the previously mapped scatter/gather list.  All the parameters
 must be the same as those and passed in to the scatter/gather mapping
@@ -378,26 +326,14 @@ void
 dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
 			enum dma_data_direction direction)
 void
-pci_dma_sync_single_for_cpu(struct pci_dev *hwdev, dma_addr_t dma_handle,
-			    size_t size, int direction)
-void
 dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
 			   enum dma_data_direction direction)
 void
-pci_dma_sync_single_for_device(struct pci_dev *hwdev, dma_addr_t dma_handle,
-			       size_t size, int direction)
-void
 dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 		    enum dma_data_direction direction)
 void
-pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sg,
-		        int nelems, int direction)
-void
 dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
 		       enum dma_data_direction direction)
-void
-pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sg,
-		           int nelems, int direction)
 
 Synchronise a single contiguous or scatter/gather mapping for the cpu
 and device. With the sync_sg API, all the parameters must be the same
@@ -482,70 +418,12 @@ void whizco_dma_map_sg_attrs(struct devi
 	....
 
 
-Part Ie - Optimizing Unmap State Space Consumption
---------------------------------
-
-On some platforms, dma_unmap_{single,page}() is simply a nop.
-Therefore, keeping track of the mapping address and length is a waste
-of space. Instead of filling your drivers up with ifdefs and the like
-to "work around" this (which would defeat the whole purpose of a
-portable API) the following facilities are provided.
-
-Actually, instead of describing the macros one by one, we'll
-transform some example code.
-
-1) Use DEFINE_DMA_UNMAP_{ADDR,LEN} in state saving structures.
-   Example, before:
-
-	struct ring_state {
-		struct sk_buff *skb;
-		dma_addr_t mapping;
-		__u32 len;
-	};
-
-   after:
-
-	struct ring_state {
-		struct sk_buff *skb;
-		DEFINE_DMA_UNMAP_ADDR(mapping);
-		DEFINE_DMA_UNMAP_LEN(len);
-	};
-
-2) Use dma_unmap_{addr,len}_set to set these values.
-   Example, before:
-
-	ringp->mapping = FOO;
-	ringp->len = BAR;
-
-   after:
-
-	dma_unmap_addr_set(ringp, mapping, FOO);
-	dma_unmap_len_set(ringp, len, BAR);
-
-3) Use dma_unmap_{addr,len} to access these values.
-   Example, before:
-
-	dma_unmap_single(dev, ringp->mapping, ringp->len,
-			 DMA_FROM_DEVICE);
-
-   after:
-
-	dma_unmap_single(dev,
-			 dma_unmap_addr(ringp, mapping),
-			 dma_unmap_len(ringp, len),
-			 DMA_FROM_DEVICE);
-
-It really should be self-explanatory.  We treat the ADDR and LEN
-separately, because it is possible for an implementation to only
-need the address in order to perform the unmap operation.
-
-
 Part II - Advanced dma_ usage
 -----------------------------
 
-Warning: These pieces of the DMA API have no PCI equivalent.  They
-should also not be used in the majority of cases, since they cater for
-unlikely corner cases that don't belong in usual drivers.
+Warning: These pieces of the DMA API should not be used in the
+majority of cases, since they cater for unlikely corner cases that
+don't belong in usual drivers.
 
 If you don't understand how cache line coherency works between a
 processor and an I/O device, you should not be using this part of the
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
documentation-fix-block-biodoctxt-dma-mapping-description.patch
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
dma-mappingh-add-the-dma_unmap-state-api-fix.patch
dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-alpha-use-include-linux-pci-dma-compath.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath-fix.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api.patch
documentation-remove-the-pci-dma-api-description-in-dma-apitxt.patch
documentation-rename-pci-dma-mappingtxt-to-dma-api-howtotxt.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

