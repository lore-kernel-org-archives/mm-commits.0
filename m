From: akpm@linux-foundation.org
Subject: +
 khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch added to -mm tree
Date: Thu, 16 Jun 2016 15:22:56 -0700
Message-ID: <576326c0.ypmbkIv+OyplhEcQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbcFPWW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 18:22:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: khugepaged: move up_read(mmap_sem) out of khugepaged_alloc_page()
has been added to the -mm tree.  Its filename is
     khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch

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
Subject: khugepaged: move up_read(mmap_sem) out of khugepaged_alloc_page()

Both variants of khugepaged_alloc_page() do up_read(&mm->mmap_sem)
first: no point keep it inside the function.

Link: http://lkml.kernel.org/r/1466021202-61880-33-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff -puN mm/khugepaged.c~khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page mm/khugepaged.c
--- a/mm/khugepaged.c~khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page
+++ a/mm/khugepaged.c
@@ -739,19 +739,10 @@ static bool khugepaged_prealloc_page(str
 }
 
 static struct page *
-khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
-		       unsigned long address, int node)
+khugepaged_alloc_page(struct page **hpage, gfp_t gfp, int node)
 {
 	VM_BUG_ON_PAGE(*hpage, *hpage);
 
-	/*
-	 * Before allocating the hugepage, release the mmap_sem read lock.
-	 * The allocation can take potentially a long time if it involves
-	 * sync compaction, and we do not need to hold the mmap_sem during
-	 * that. We will recheck the vma after taking it again in write mode.
-	 */
-	up_read(&mm->mmap_sem);
-
 	*hpage = __alloc_pages_node(node, gfp, HPAGE_PMD_ORDER);
 	if (unlikely(!*hpage)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
@@ -812,10 +803,8 @@ static bool khugepaged_prealloc_page(str
 }
 
 static struct page *
-khugepaged_alloc_page(struct page **hpage, gfp_t gfp, struct mm_struct *mm,
-		       unsigned long address, int node)
+khugepaged_alloc_page(struct page **hpage, gfp_t gfp, int node)
 {
-	up_read(&mm->mmap_sem);
 	VM_BUG_ON(!*hpage);
 
 	return  *hpage;
@@ -936,8 +925,14 @@ static void collapse_huge_page(struct mm
 	/* Only allocate from the target node */
 	gfp = alloc_hugepage_khugepaged_gfpmask() | __GFP_OTHER_NODE | __GFP_THISNODE;
 
-	/* release the mmap_sem read lock. */
-	new_page = khugepaged_alloc_page(hpage, gfp, mm, address, node);
+	/*
+	 * Before allocating the hugepage, release the mmap_sem read lock.
+	 * The allocation can take potentially a long time if it involves
+	 * sync compaction, and we do not need to hold the mmap_sem during
+	 * that. We will recheck the vma after taking it again in write mode.
+	 */
+	up_read(&mm->mmap_sem);
+	new_page = khugepaged_alloc_page(hpage, gfp, node);
 	if (!new_page) {
 		result = SCAN_ALLOC_HUGE_PAGE_FAIL;
 		goto out_nolock;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

revert-mm-make-faultaround-produce-old-ptes.patch
revert-mm-disable-fault-around-on-emulated-access-bit-architecture.patch
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

