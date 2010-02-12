From: akpm@linux-foundation.org
Subject: + blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch added to -mm tree
Date: Fri, 12 Feb 2010 11:52:10 -0800
Message-ID: <201002121952.o1CJqAVu023295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756421Ab0BLTwm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:52:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, jbarnes@virtuousgeek.org, vapier@gentoo.org


The patch titled
     dma-mapping: blackfin: remove the obsolete and unnecessary DMA API comments
has been added to the -mm tree.  Its filename is
     blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch

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
Subject: dma-mapping: blackfin: remove the obsolete and unnecessary DMA API comments
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

pci_dma_sync_single was obsoleted long ago.

All the comments are generic, not architecture specific, simply describes
some of the DMA-API (and the same comments are in other files). 
Documentation/DMA-API.txt have more detailed descriptions.

This removes the above obsolete and unnecessary DMA API comments.  Let's
describe the DMA API in only Documentation/DMA-API.txt.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/dma-mapping.h |   36 ----------------------
 1 file changed, 36 deletions(-)

diff -puN arch/blackfin/include/asm/dma-mapping.h~blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments arch/blackfin/include/asm/dma-mapping.h
--- a/arch/blackfin/include/asm/dma-mapping.h~blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments
+++ a/arch/blackfin/include/asm/dma-mapping.h
@@ -65,13 +65,6 @@ _dma_sync(dma_addr_t addr, size_t size, 
 	}
 }
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single is performed.
- */
 static inline dma_addr_t
 dma_map_single(struct device *dev, void *ptr, size_t size,
 	       enum dma_data_direction dir)
@@ -88,14 +81,6 @@ dma_map_page(struct device *dev, struct 
 	return dma_map_single(dev, page_address(page) + offset, size, dir);
 }
 
-/*
- * Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guarenteed to see
- * whatever the device wrote there.
- */
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 		 enum dma_data_direction dir)
@@ -110,30 +95,9 @@ dma_unmap_page(struct device *dev, dma_a
 	dma_unmap_single(dev, dma_addr, size, dir);
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
 		      enum dma_data_direction dir);
 
-/*
- * Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
 static inline void
 dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 	     int nhwentries, enum dma_data_direction dir)
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

