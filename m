From: akpm@linux-foundation.org
Subject: + mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5.patch added to
 -mm tree
Date: Mon, 28 Dec 2015 15:52:10 -0800
Message-ID: <5681cb2a.UQziO966PW6c5IZp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbbL1XwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Dec 2015 18:52:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, aarcange@redhat.com, dave@sr71.net, kirill.shutemov@linux.intel.com, mgorman@suse.de, peterz@infradead.org, sasha.levin@oracle.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: dax-pmd vs thp-pmd vs hugetlbfs-pmd v5
has been added to the -mm tree.  Its filename is
     mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5.patch

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
diff -puN mm/huge_memory.c~mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5 mm/huge_memory.c
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
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-v5.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

