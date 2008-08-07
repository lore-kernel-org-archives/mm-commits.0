From: akpm@linux-foundation.org
Subject: + introduce-generic-header-file-for-the-software-io-tlb.patch added to -mm tree
Date: Thu, 07 Aug 2008 13:19:57 -0700
Message-ID: <200808072019.m77KJviD003480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970AbYHGUU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 16:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     introduce generic header file for the software IO/TLB
has been added to the -mm tree.  Its filename is
     introduce-generic-header-file-for-the-software-io-tlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce generic header file for the software IO/TLB
From: Joerg Roedel <joerg.roedel@amd.com>

Create include/linux/swiotlb.h file which contains all function prototypes
for the lib/swiotlb.c file.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swiotlb.h |   83 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff -puN /dev/null include/linux/swiotlb.h
--- /dev/null
+++ a/include/linux/swiotlb.h
@@ -0,0 +1,83 @@
+#ifndef __LINUX_SWIOTLB_H
+#define __LINUX_SWIOTLB_H
+
+#include <linux/types.h>
+
+struct device;
+struct dma_attrs;
+struct scatterlist;
+
+extern void
+swiotlb_init(void);
+
+extern void
+*swiotlb_alloc_coherent(struct device *hwdev, size_t size,
+			dma_addr_t *dma_handle, gfp_t flags);
+
+extern void
+swiotlb_free_coherent(struct device *hwdev, size_t size,
+		      void *vaddr, dma_addr_t dma_handle);
+
+extern dma_addr_t
+swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir);
+
+extern void
+swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
+		     size_t size, int dir);
+
+extern dma_addr_t
+swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
+			 int dir, struct dma_attrs *attrs);
+
+extern void
+swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
+			   size_t size, int dir, struct dma_attrs *attrs);
+
+extern int
+swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
+	       int direction);
+
+extern void
+swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
+		 int direction);
+
+extern int
+swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
+		     int dir, struct dma_attrs *attrs);
+
+extern void
+swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
+		       int nelems, int dir, struct dma_attrs *attrs);
+
+extern void
+swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
+			    size_t size, int dir);
+
+extern void
+swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
+			int nelems, int dir);
+
+extern void
+swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
+			       size_t size, int dir);
+
+extern void
+swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
+			   int nelems, int dir);
+
+extern void
+swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
+				  unsigned long offset, size_t size, int dir);
+
+extern void
+swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
+				     unsigned long offset, size_t size,
+				     int dir);
+
+extern int
+swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
+
+extern int
+swiotlb_dma_supported(struct device *hwdev, u64 mask);
+
+#endif /* __LINUX_SWIOTLB_H */
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

linux-next.patch
introduce-generic-header-file-for-the-software-io-tlb.patch
x86-use-common-header-for-software-io-tlb.patch
ia64-use-common-header-for-software-io-tlb.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
powerpc-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
x86-convert-gart-driver-to-generic-iommu_num_pages-function.patch
x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function.patch
x86-convert-calgary-iommu-driver-to-generic-iommu_num_pages-function.patch
powerpc-use-iommu_num_pages-function-in-iommu-code.patch
alpha-use-iommu_num_pages-function-in-iommu-code.patch
sparc64-use-iommu_num_pages-function-in-iommu-code.patch

