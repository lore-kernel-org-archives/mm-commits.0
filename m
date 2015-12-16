From: akpm@linux-foundation.org
Subject: + pmem-dax-clean-up-clear_pmem.patch added to -mm tree
Date: Tue, 15 Dec 2015 16:16:30 -0800
Message-ID: <5670ad5e.aQnkwmgZmBVVvyxH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbbLPAQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:16:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, aarcange@redhat.com, airlied@linux.ie, axboe@fb.com, christoffer.dall@linaro.org, dave.hansen@linux.intel.com, david@fromorbit.com, hch@lst.de, hpa@zytor.com, jack@suse.com, jdike@addtoit.com, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, logang@deltatee.com, mgorman@suse.de, mingo@redhat.com, pbonzini@redhat.com, peterz@infradead.org, richard@nod.at, ross.zwisler@linux.intel.com, tglx@linutronix.de, toshi.kani@hpe.com, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pmem, dax: clean up clear_pmem()
has been added to the -mm tree.  Its filename is
     pmem-dax-clean-up-clear_pmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pmem-dax-clean-up-clear_pmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pmem-dax-clean-up-clear_pmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: pmem, dax: clean up clear_pmem()

To date, we have implemented two I/O usage models for persistent memory,
PMEM (a persistent "ram disk") and DAX (mmap persistent memory into
userspace).  This series adds a third, DAX-GUP, that allows DAX mappings
to be the target of direct-i/o.  It allows userspace to coordinate
DMA/RDMA from/to persistent memory.

The implementation leverages the ZONE_DEVICE mm-zone that went into
4.3-rc1 (also discussed at kernel summit) to flag pages that are owned and
dynamically mapped by a device driver.  The pmem driver, after mapping a
persistent memory range into the system memmap via devm_memremap_pages(),
arranges for DAX to distinguish pfn-only versus page-backed pmem-pfns via
flags in the new pfn_t type.

The DAX code, upon seeing a PFN_DEV+PFN_MAP flagged pfn, flags the
resulting pte(s) inserted into the process page tables with a new
_PAGE_DEVMAP flag.  Later, when get_user_pages() is walking ptes it keys
off _PAGE_DEVMAP to pin the device hosting the page range active. 
Finally, get_page() and put_page() are modified to take references against
the device driver established page mapping.

Finally, this need for "struct page" for persistent memory requires memory
capacity to store the memmap array.  Given the memmap array for a large
pool of persistent may exhaust available DRAM introduce a mechanism to
allocate the memmap from persistent memory.  The new "struct vmem_altmap
*" parameter to devm_memremap_pages() enables arch_add_memory() to use
reserved pmem capacity rather than the page allocator.



This patch (of 25):

Both __dax_pmd_fault, and clear_pmem() were taking special steps to clear
memory a page at a time to take advantage of non-temporal clear_page()
implementations.  However, x86_64 does not use non-temporal instructions
for clear_page(), and arch_clear_pmem() was always incurring the cost of
__arch_wb_cache_pmem().

Clean up the assumption that doing clear_pmem() a page at a time is more
performant.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pmem.h |    7 +------
 fs/dax.c                    |    4 +---
 2 files changed, 2 insertions(+), 9 deletions(-)

diff -puN arch/x86/include/asm/pmem.h~pmem-dax-clean-up-clear_pmem arch/x86/include/asm/pmem.h
--- a/arch/x86/include/asm/pmem.h~pmem-dax-clean-up-clear_pmem
+++ a/arch/x86/include/asm/pmem.h
@@ -132,12 +132,7 @@ static inline void arch_clear_pmem(void
 {
 	void *vaddr = (void __force *)addr;
 
-	/* TODO: implement the zeroing via non-temporal writes */
-	if (size == PAGE_SIZE && ((unsigned long)vaddr & ~PAGE_MASK) == 0)
-		clear_page(vaddr);
-	else
-		memset(vaddr, 0, size);
-
+	memset(vaddr, 0, size);
 	__arch_wb_cache_pmem(vaddr, size);
 }
 
diff -puN fs/dax.c~pmem-dax-clean-up-clear_pmem fs/dax.c
--- a/fs/dax.c~pmem-dax-clean-up-clear_pmem
+++ a/fs/dax.c
@@ -641,9 +641,7 @@ int __dax_pmd_fault(struct vm_area_struc
 			goto fallback;
 
 		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-			int i;
-			for (i = 0; i < PTRS_PER_PMD; i++)
-				clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
+			clear_pmem(kaddr, PMD_SIZE);
 			wmb_pmem();
 			count_vm_event(PGMAJFAULT);
 			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

scatterlist-fix-sg_phys-masking.patch
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

