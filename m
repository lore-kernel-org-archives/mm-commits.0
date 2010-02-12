From: akpm@linux-foundation.org
Subject: + mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch added to -mm tree
Date: Fri, 12 Feb 2010 11:52:12 -0800
Message-ID: <201002121952.o1CJqC0r023298@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756423Ab0BLTxE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:53:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, dhowells@redhat.com, jbarnes@virtuousgeek.org, yasutake.koichi@jp.panasonic.com


The patch titled
     dma-mapping: mn10300: remove the obsolete and unnecessary DMA API comments
has been added to the -mm tree.  Its filename is
     mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch

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
Subject: dma-mapping: mn10300: remove the obsolete and unnecessary DMA API comments
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

pci_dma_sync_single was obsoleted long ago.

All the comments are generic, not architecture specific, simply describes
some of the DMA-API (and the same comments are in other files). 
Documentation/DMA-API.txt have more detailed descriptions.

This removes the above obsolete and unnecessary DMA API
comments. Let's describe the DMA API in only
Documentation/DMA-API.txt.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/dma-mapping.h |   60 -----------------------
 1 file changed, 60 deletions(-)

diff -puN arch/mn10300/include/asm/dma-mapping.h~mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments arch/mn10300/include/asm/dma-mapping.h
--- a/arch/mn10300/include/asm/dma-mapping.h~mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments
+++ a/arch/mn10300/include/asm/dma-mapping.h
@@ -26,13 +26,6 @@ extern void dma_free_coherent(struct dev
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent((d), (s), (h), (f))
 #define dma_free_noncoherent(d, s, v, h)  dma_free_coherent((d), (s), (v), (h))
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.  The
- * 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory until
- * either pci_unmap_single or pci_dma_sync_single is performed.
- */
 static inline
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 			  enum dma_data_direction direction)
@@ -42,14 +35,6 @@ dma_addr_t dma_map_single(struct device 
 	return virt_to_bus(ptr);
 }
 
-/*
- * Unmap a single streaming mode DMA translation.  The dma_addr and size must
- * match what was provided for in a previous pci_map_single call.  All other
- * usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guarenteed to see
- * whatever the device wrote there.
- */
 static inline
 void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 		      enum dma_data_direction direction)
@@ -57,20 +42,6 @@ void dma_unmap_single(struct device *dev
 	BUG_ON(direction == DMA_NONE);
 }
 
-/*
- * Map a set of buffers described by scatterlist in streaming mode for DMA.
- * This is the scather-gather version of the above pci_map_single interface.
- * Here the scatter gather list elements are each tagged with the appropriate
- * dma address and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of DMA
- *       address/length pairs than there are SG table elements.  (for example
- *       via virtual mapping capabilities) The routine returns the number of
- *       addr/length pairs actually used, at most nents.
- *
- * Device ownership issues as mentioned above for pci_map_single are the same
- * here.
- */
 static inline
 int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	       enum dma_data_direction direction)
@@ -91,11 +62,6 @@ int dma_map_sg(struct device *dev, struc
 	return nents;
 }
 
-/*
- * Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
 static inline
 void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 		  enum dma_data_direction direction)
@@ -103,10 +69,6 @@ void dma_unmap_sg(struct device *dev, st
 	BUG_ON(!valid_dma_direction(direction));
 }
 
-/*
- * pci_{map,unmap}_single_page maps a kernel page to a dma_addr_t. identical
- * to pci_map_single, but takes a struct page instead of a virtual address
- */
 static inline
 dma_addr_t dma_map_page(struct device *dev, struct page *page,
 			unsigned long offset, size_t size,
@@ -123,15 +85,6 @@ void dma_unmap_page(struct device *dev, 
 	BUG_ON(direction == DMA_NONE);
 }
 
-/*
- * Make physical memory consistent for a single streaming mode DMA translation
- * after a transfer.
- *
- * If you perform a pci_map_single() but wish to interrogate the buffer using
- * the cpu, yet do not wish to teardown the PCI dma mapping, you must call this
- * function before doing so.  At the next point you give the PCI dma address
- * back to the card, the device again owns the buffer.
- */
 static inline
 void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
 			     size_t size, enum dma_data_direction direction)
@@ -161,13 +114,6 @@ dma_sync_single_range_for_device(struct 
 }
 
 
-/*
- * Make physical memory consistent for a set of streaming mode DMA translations
- * after a transfer.
- *
- * The same as pci_dma_sync_single but for a scatter-gather list, same rules
- * and usage.
- */
 static inline
 void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 			 int nelems, enum dma_data_direction direction)
@@ -187,12 +133,6 @@ int dma_mapping_error(struct device *dev
 	return 0;
 }
 
-/*
- * Return whether the given PCI device DMA address mask can be supported
- * properly.  For example, if your device can only drive the low 24-bits during
- * PCI bus mastering, then you would pass 0x00ffffff as the mask to this
- * function.
- */
 static inline
 int dma_supported(struct device *dev, u64 mask)
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

