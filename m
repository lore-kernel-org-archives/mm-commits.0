From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5.patch removed from -mm tree
Date: Fri, 15 Jan 2016 16:32:47 -0800
Message-ID: <56998faf.Z0/GA6g9+fttlm3q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161011AbcAPAcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:32:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, aarcange@redhat.com, dave@sr71.net, kirill.shutemov@linux.intel.com, mgorman@suse.de, peterz@infradead.org, sasha.levin@oracle.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd v5
has been removed from the -mm tree.  Its filename was
     mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5.patch

This patch was dropped because it was folded into mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd v5

Add a missing pmd_devmap() check to pmd_trans_huge_lock() (Willy)

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/huge_mm.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5 include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5
+++ a/include/linux/huge_mm.h
@@ -125,7 +125,7 @@ static inline bool pmd_trans_huge_lock(p
 		spinlock_t **ptl)
 {
 	VM_BUG_ON_VMA(!rwsem_is_locked(&vma->vm_mm->mmap_sem), vma);
-	if (pmd_trans_huge(*pmd))
+	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd))
 		return __pmd_trans_huge_lock(pmd, vma, ptl);
 	else
 		return false;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-skip-memory-block-registration-for-zone_device.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5-fix.patch
mm-x86-get_user_pages-for-dax-mappings.patch
mm-x86-get_user_pages-for-dax-mappings-v5.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

