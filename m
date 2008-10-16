From: akpm@linux-foundation.org
Subject: + frv-provide-dma_map_page-for-nommu-and-fix-comments.patch added to -mm tree
Date: Thu, 16 Oct 2008 14:02:54 -0700
Message-ID: <200810162102.m9GL2s9b019610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384AbYJPVDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 17:03:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     frv: provide dma_map_page() for NOMMU and fix comments
has been added to the -mm tree.  Its filename is
     frv-provide-dma_map_page-for-nommu-and-fix-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
uclinux-fix-gzip-header-parsing-in-binfmt_flatc.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
sysctl-simplify-strategy.patch
afs-convert-to-new-aops.patch
frv-provide-dma_map_page-for-nommu-and-fix-comments.patch
frv-switch-unaligned-access-to-the-packed-struct-implementation.patch
mn10300-use-bcd2bin-bin2bcd.patch
mutex-subsystem-synchro-test-module.patch

