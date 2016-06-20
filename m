From: akpm@linux-foundation.org
Subject: + hugetlb-fix-nr_pmds-accounting-with-shared-page-tables.patch
 added to -mm tree
Date: Mon, 20 Jun 2016 15:31:19 -0700
Message-ID: <57686eb7.R7Vt+d+U4vFNFWD7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbcFTWky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jun 2016 18:40:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix nr_pmds accounting with shared page tables
has been added to the -mm tree.  Its filename is
     hugetlb-fix-nr_pmds-accounting-with-shared-page-tables.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-fix-nr_pmds-accounting-with-shared-page-tables.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-fix-nr_pmds-accounting-with-shared-page-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: hugetlb: fix nr_pmds accounting with shared page tables

We account HugeTLB's shared page table to all processes who share it.
The accounting happens during huge_pmd_share().

If somebody populates pud entry under us, we should decrease pagetable's
refcount and decrease nr_pmds of the process.

By mistake, I increase nr_pmds again in this case. :-/
It will lead to "BUG: non-zero nr_pmds on freeing mm: 2" on process'
exit.

Let's fix this by increasing nr_pmds only when we're sure that the page
table will be used.

Link: http://lkml.kernel.org/r/20160617122506.GC6534@node.shutemov.name
Fixes: dc6c9a35b66b ("mm: account pmd page tables to the process")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: zhongjiang <zhongjiang@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-nr_pmds-accounting-with-shared-page-tables mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-nr_pmds-accounting-with-shared-page-tables
+++ a/mm/hugetlb.c
@@ -4228,7 +4228,6 @@ pte_t *huge_pmd_share(struct mm_struct *
 		if (saddr) {
 			spte = huge_pte_offset(svma->vm_mm, saddr);
 			if (spte) {
-				mm_inc_nr_pmds(mm);
 				get_page(virt_to_page(spte));
 				break;
 			}
@@ -4243,9 +4242,9 @@ pte_t *huge_pmd_share(struct mm_struct *
 	if (pud_none(*pud)) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
+		mm_inc_nr_pmds(mm);
 	} else {
 		put_page(virt_to_page(spte));
-		mm_inc_nr_pmds(mm);
 	}
 	spin_unlock(ptl);
 out:
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

revert-mm-make-faultaround-produce-old-ptes.patch
revert-mm-disable-fault-around-on-emulated-access-bit-architecture.patch
hugetlb-fix-nr_pmds-accounting-with-shared-page-tables.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch
khugepaged-recheck-pmd-after-mmap_sem-re-acquired.patch
thp-mlock-update-unevictable-lrutxt.patch
mm-do-not-pass-mm_struct-into-handle_mm_fault.patch
mm-introduce-fault_env.patch
mm-postpone-page-table-allocation-until-we-have-page-to-map.patch
rmap-support-file-thp.patch
mm-introduce-do_set_pmd.patch
thp-vmstats-add-counters-for-huge-file-pages.patch
thp-support-file-pages-in-zap_huge_pmd.patch
thp-handle-file-pages-in-split_huge_pmd.patch
thp-handle-file-cow-faults.patch
thp-skip-file-huge-pmd-on-copy_huge_pmd.patch
thp-prepare-change_huge_pmd-for-file-thp.patch
thp-run-vma_adjust_trans_huge-outside-i_mmap_rwsem.patch
thp-file-pages-support-for-split_huge_page.patch
thp-mlock-do-not-mlock-pte-mapped-file-huge-pages.patch
vmscan-split-file-huge-pages-before-paging-them-out.patch
page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch
radix-tree-implement-radix_tree_maybe_preload_order.patch
filemap-prepare-find-and-delete-operations-for-huge-pages.patch
truncate-handle-file-thp.patch
mm-rmap-account-shmem-thp-pages.patch
shmem-prepare-huge=-mount-option-and-sysfs-knob.patch
shmem-add-huge-pages-support.patch
shmem-thp-respect-madv_nohugepage-for-file-mappings.patch
thp-extract-khugepaged-from-mm-huge_memoryc.patch
khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch
shmem-make-shmem_inode_info-lock-irq-safe.patch
khugepaged-add-support-of-collapse-for-tmpfs-shmem-pages.patch
thp-introduce-config_transparent_huge_pagecache.patch
shmem-split-huge-pages-beyond-i_size-under-memory-pressure.patch
thp-update-documentation-vm-transhugefilesystems-proctxt.patch

