From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch removed
 from -mm tree
Date: Tue, 26 Jul 2016 14:13:03 -0700
Message-ID: <5797d25f.xX8lQGnE1L4X0vKu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161003AbcGZVNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:13:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, ebru.akagunduz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: __collapse_huge_page_swapin(): drop unused 'pte' parameter
has been removed from the -mm tree.  Its filename was
     mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch

This patch was dropped because it was folded into mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: khugepaged: __collapse_huge_page_swapin(): drop unused 'pte' parameter

'pte' dereference is eliminated by compiler, since nobody uses the
pteval until it's overwritten inside the loop.

Value of 'pte' itself is overwritten by pte_offset_map() before first
real use.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2
+++ a/mm/huge_memory.c
@@ -2383,11 +2383,10 @@ static bool hugepage_vma_check(struct vm
 
 static void __collapse_huge_page_swapin(struct mm_struct *mm,
 					struct vm_area_struct *vma,
-					unsigned long address, pmd_t *pmd,
-					pte_t *pte)
+					unsigned long address, pmd_t *pmd)
 {
 	unsigned long _address;
-	pte_t pteval = *pte;
+	pte_t *pte, pteval;
 	int swapped_in = 0, ret = 0;
 
 	pte = pte_offset_map(pmd, address);
@@ -2481,7 +2480,7 @@ static void collapse_huge_page(struct mm
 
 	anon_vma_lock_write(vma->anon_vma);
 
-	__collapse_huge_page_swapin(mm, vma, address, pmd, pte);
+	__collapse_huge_page_swapin(mm, vma, address, pmd);
 
 	pte = pte_offset_map(pmd, address);
 	pte_ptl = pte_lockptr(mm, pmd);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
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

