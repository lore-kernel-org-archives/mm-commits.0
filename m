From: akpm@linux-foundation.org
Subject: - frv-provide-dma_map_page-for-nommu-and-fix-comments.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:21:14 -0700
Message-ID: <200810182321.m9INLE6I029913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbYJRXV2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:21:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: provide dma_map_page() for NOMMU and fix comments
has been removed from the -mm tree.  Its filename was
     frv-provide-dma_map_page-for-nommu-and-fix-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: provide dma_map_page() for NOMMU and fix comments
From: David Howells <dhowells@redhat.com>

Provide dma_map_page() for the NOMMU-mode FRV arch.

Also do some fixing on the comments attached to the various DMA functions
for both MMU and NOMMU mode FRV code.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mb93090-mb00/pci-dma-nommu.c |   23 ++++++++++++++++++++---
 arch/frv/mb93090-mb00/pci-dma.c       |   11 +++++++++--
 2 files changed, 29 insertions(+), 5 deletions(-)

diff -puN arch/frv/mb93090-mb00/pci-dma-nommu.c~frv-provide-dma_map_page-for-nommu-and-fix-comments arch/frv/mb93090-mb00/pci-dma-nommu.c
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c~frv-provide-dma_map_page-for-nommu-and-fix-comments
+++ a/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -111,7 +111,7 @@ EXPORT_SYMBOL(dma_free_coherent);
  * The 32-bit bus address to use is returned.
  *
  * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single is performed.
+ * until either dma_unmap_single or pci_dma_sync_single is performed.
  */
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 			  enum dma_data_direction direction)
@@ -129,7 +129,7 @@ EXPORT_SYMBOL(dma_map_single);
 /*
  * Map a set of buffers described by scatterlist in streaming
  * mode for DMA.  This is the scather-gather version of the
- * above pci_map_single interface.  Here the scatter gather list
+ * above dma_map_single interface.  Here the scatter gather list
  * elements are each tagged with the appropriate dma address
  * and length.  They are obtained via sg_dma_{address,length}(SG).
  *
@@ -139,7 +139,7 @@ EXPORT_SYMBOL(dma_map_single);
  *       The routine returns the number of addr/length pairs actually
  *       used, at most nents.
  *
- * Device ownership issues as mentioned above for pci_map_single are
+ * Device ownership issues as mentioned above for dma_map_single are
  * the same here.
  */
 int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
@@ -158,3 +158,20 @@ int dma_map_sg(struct device *dev, struc
 }
 
 EXPORT_SYMBOL(dma_map_sg);
+
+/*
+ * Map a single page of the indicated size for DMA in streaming mode.
+ * The 32-bit bus address to use is returned.
+ *
+ * Device ownership issues as mentioned above for dma_map_single are
+ * the same here.
+ */
+dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
+			size_t size, enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+	flush_dcache_page(page);
+	return (dma_addr_t) page_to_phys(page) + offset;
+}
+
+EXPORT_SYMBOL(dma_map_page);
diff -puN arch/frv/mb93090-mb00/pci-dma.c~frv-provide-dma_map_page-for-nommu-and-fix-comments arch/frv/mb93090-mb00/pci-dma.c
--- a/arch/frv/mb93090-mb00/pci-dma.c~frv-provide-dma_map_page-for-nommu-and-fix-comments
+++ a/arch/frv/mb93090-mb00/pci-dma.c
@@ -61,7 +61,7 @@ EXPORT_SYMBOL(dma_map_single);
 /*
  * Map a set of buffers described by scatterlist in streaming
  * mode for DMA.  This is the scather-gather version of the
- * above pci_map_single interface.  Here the scatter gather list
+ * above dma_map_single interface.  Here the scatter gather list
  * elements are each tagged with the appropriate dma address
  * and length.  They are obtained via sg_dma_{address,length}(SG).
  *
@@ -71,7 +71,7 @@ EXPORT_SYMBOL(dma_map_single);
  *       The routine returns the number of addr/length pairs actually
  *       used, at most nents.
  *
- * Device ownership issues as mentioned above for pci_map_single are
+ * Device ownership issues as mentioned above for dma_map_single are
  * the same here.
  */
 int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
@@ -105,6 +105,13 @@ int dma_map_sg(struct device *dev, struc
 
 EXPORT_SYMBOL(dma_map_sg);
 
+/*
+ * Map a single page of the indicated size for DMA in streaming mode.
+ * The 32-bit bus address to use is returned.
+ *
+ * Device ownership issues as mentioned above for dma_map_single are
+ * the same here.
+ */
 dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
 			size_t size, enum dma_data_direction direction)
 {
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
mn10300-use-bcd2bin-bin2bcd.patch

