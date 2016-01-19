From: akpm@linux-foundation.org
Subject: [merged] pmem-dax-clean-up-clear_pmem.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:04 -0800
Message-ID: <569e98d0.I6/9S4eHq6wO8ZS5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbcASUNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, aarcange@redhat.com, airlied@linux.ie, axboe@fb.com, christoffer.dall@linaro.org, dave.hansen@linux.intel.com, david@fromorbit.com, hch@lst.de, hpa@zytor.com, jack@suse.com, jdike@addtoit.com, jmoyer@redhat.com, kirill.shutemov@linux.intel.com, logang@deltatee.com, mgorman@suse.de, mingo@redhat.com, pbonzini@redhat.com, peterz@infradead.org, richard@nod.at, ross.zwisler@linux.intel.com, tglx@linutronix.de, toshi.kani@hpe.com, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pmem, dax: clean up clear_pmem()
has been removed from the -mm tree.  Its filename was
     pmem-dax-clean-up-clear_pmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
