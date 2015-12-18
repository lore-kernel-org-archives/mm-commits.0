From: akpm@linux-foundation.org
Subject: [alternative-merged] scatterlist-fix-sg_phys-masking.patch
 removed from -mm tree
Date: Fri, 18 Dec 2015 12:31:05 -0800
Message-ID: <56746d09.dPHS/cH/vaTxQcNb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736AbbLRUbH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Dec 2015 15:31:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, axboe@fb.com, dwmw2@infradead.org, hch@lst.de, joro@8bytes.org, linux@arm.linux.org.uk, stable@vger.kernel.org, vel21ripn@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: fix sg_phys() masking
has been removed from the -mm tree.  Its filename was
     scatterlist-fix-sg_phys-masking.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: scatterlist: fix sg_phys() masking

commit db0fa0cb0157 "scatterlist: use sg_phys()" did replacements of the
form:

    phys_addr_t phys = page_to_phys(sg_page(s));
    phys_addr_t phys = sg_phys(s) & PAGE_MASK;

However, this breaks platforms where sizeof(phys_addr_t) > sizeof(unsigned
long).  Since PAGE_MASK is an unsigned long this inadvertently masks the
high bits returned by sg_phys().  Convert to PHYSICAL_PAGE_MASK in these
cases which will do the proper sign extension.

As caught by the kbuild robot, a generic fallback definition of
PHYSICAL_PAGE_MASK is needed for several archs.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Vitaly Lavrov <vel21ripn@gmail.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c                    |    2 +-
 drivers/iommu/intel-iommu.c                  |    2 +-
 drivers/staging/android/ion/ion_chunk_heap.c |    4 ++--
 include/linux/mm.h                           |   12 ++++++++++++
 4 files changed, 16 insertions(+), 4 deletions(-)

diff -puN arch/arm/mm/dma-mapping.c~scatterlist-fix-sg_phys-masking arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~scatterlist-fix-sg_phys-masking
+++ a/arch/arm/mm/dma-mapping.c
@@ -1521,7 +1521,7 @@ static int __map_sg_chunk(struct device
 		return -ENOMEM;
 
 	for (count = 0, s = sg; count < (size >> PAGE_SHIFT); s = sg_next(s)) {
-		phys_addr_t phys = sg_phys(s) & PAGE_MASK;
+		phys_addr_t phys = sg_phys(s) & PHYSICAL_PAGE_MASK;
 		unsigned int len = PAGE_ALIGN(s->offset + s->length);
 
 		if (!is_coherent &&
diff -puN drivers/iommu/intel-iommu.c~scatterlist-fix-sg_phys-masking drivers/iommu/intel-iommu.c
--- a/drivers/iommu/intel-iommu.c~scatterlist-fix-sg_phys-masking
+++ a/drivers/iommu/intel-iommu.c
@@ -2159,7 +2159,7 @@ static int __domain_mapping(struct dmar_
 			sg_res = aligned_nrpages(sg->offset, sg->length);
 			sg->dma_address = ((dma_addr_t)iov_pfn << VTD_PAGE_SHIFT) + sg->offset;
 			sg->dma_length = sg->length;
-			pteval = (sg_phys(sg) & PAGE_MASK) | prot;
+			pteval = (sg_phys(sg) & PHYSICAL_PAGE_MASK) | prot;
 			phys_pfn = pteval >> VTD_PAGE_SHIFT;
 		}
 
diff -puN drivers/staging/android/ion/ion_chunk_heap.c~scatterlist-fix-sg_phys-masking drivers/staging/android/ion/ion_chunk_heap.c
--- a/drivers/staging/android/ion/ion_chunk_heap.c~scatterlist-fix-sg_phys-masking
+++ a/drivers/staging/android/ion/ion_chunk_heap.c
@@ -81,7 +81,7 @@ static int ion_chunk_heap_allocate(struc
 err:
 	sg = table->sgl;
 	for (i -= 1; i >= 0; i--) {
-		gen_pool_free(chunk_heap->pool, sg_phys(sg) & PAGE_MASK,
+		gen_pool_free(chunk_heap->pool, sg_phys(sg) & PHYSICAL_PAGE_MASK,
 			      sg->length);
 		sg = sg_next(sg);
 	}
@@ -109,7 +109,7 @@ static void ion_chunk_heap_free(struct i
 							DMA_BIDIRECTIONAL);
 
 	for_each_sg(table->sgl, sg, table->nents, i) {
-		gen_pool_free(chunk_heap->pool, sg_phys(sg) & PAGE_MASK,
+		gen_pool_free(chunk_heap->pool, sg_phys(sg) & PHYSICAL_PAGE_MASK,
 			      sg->length);
 	}
 	chunk_heap->allocated -= allocated_size;
diff -puN include/linux/mm.h~scatterlist-fix-sg_phys-masking include/linux/mm.h
--- a/include/linux/mm.h~scatterlist-fix-sg_phys-masking
+++ a/include/linux/mm.h
@@ -90,6 +90,18 @@ extern int overcommit_kbytes_handler(str
 /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
 #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)addr, PAGE_SIZE)
 
+#ifndef PHYSICAL_PAGE_MASK
+/*
+ * Cast *PAGE_MASK to a signed type so that it is sign-extended if
+ * virtual addresses are 32-bits but physical addresses are larger (ie,
+ * 32-bit PAE).
+ *
+ * An arch may redefine this to mask out values outside the max
+ * address-width of the cpu.
+ */
+#define PHYSICAL_PAGE_MASK ((signed long) PAGE_MASK)
+#endif
+
 /*
  * Linux kernel virtual memory manager primitives.
  * The idea being to have a "virtual" mm in the same way
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

