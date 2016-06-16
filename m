From: akpm@linux-foundation.org
Subject: + thp-skip-file-huge-pmd-on-copy_huge_pmd.patch added to -mm tree
Date: Thu, 16 Jun 2016 15:22:46 -0700
Message-ID: <576326b6.fkHkPS/zUcJUrVYo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbcFPWWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 18:22:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: skip file huge pmd on copy_huge_pmd()
has been added to the -mm tree.  Its filename is
     thp-skip-file-huge-pmd-on-copy_huge_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-skip-file-huge-pmd-on-copy_huge_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-skip-file-huge-pmd-on-copy_huge_pmd.patch

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
Subject: thp: skip file huge pmd on copy_huge_pmd()

copy_page_range() has a check for "Don't copy ptes where a page fault
will fill them correctly." It works on VMA level. We still copy all page
table entries from private mappings, even if they map page cache.

We can simplify copy_huge_pmd() a bit by skipping file PMDs.

We don't map file private pages with PMDs, so they only can map page
cache. It's safe to skip them as they can be re-faulted later.

Link: http://lkml.kernel.org/r/1466021202-61880-17-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff -puN mm/huge_memory.c~thp-skip-file-huge-pmd-on-copy_huge_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~thp-skip-file-huge-pmd-on-copy_huge_pmd
+++ a/mm/huge_memory.c
@@ -1098,14 +1098,15 @@ int copy_huge_pmd(struct mm_struct *dst_
 	struct page *src_page;
 	pmd_t pmd;
 	pgtable_t pgtable = NULL;
-	int ret;
+	int ret = -ENOMEM;
 
-	if (!vma_is_dax(vma)) {
-		ret = -ENOMEM;
-		pgtable = pte_alloc_one(dst_mm, addr);
-		if (unlikely(!pgtable))
-			goto out;
-	}
+	/* Skip if can be re-fill on fault */
+	if (!vma_is_anonymous(vma))
+		return 0;
+
+	pgtable = pte_alloc_one(dst_mm, addr);
+	if (unlikely(!pgtable))
+		goto out;
 
 	dst_ptl = pmd_lock(dst_mm, dst_pmd);
 	src_ptl = pmd_lockptr(src_mm, src_pmd);
@@ -1113,7 +1114,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 
 	ret = -EAGAIN;
 	pmd = *src_pmd;
-	if (unlikely(!pmd_trans_huge(pmd) && !pmd_devmap(pmd))) {
+	if (unlikely(!pmd_trans_huge(pmd))) {
 		pte_free(dst_mm, pgtable);
 		goto out_unlock;
 	}
@@ -1136,16 +1137,13 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto out_unlock;
 	}
 
-	if (!vma_is_dax(vma)) {
-		/* thp accounting separate from pmd_devmap accounting */
-		src_page = pmd_page(pmd);
-		VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
-		get_page(src_page);
-		page_dup_rmap(src_page, true);
-		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-		atomic_long_inc(&dst_mm->nr_ptes);
-		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-	}
+	src_page = pmd_page(pmd);
+	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
+	get_page(src_page);
+	page_dup_rmap(src_page, true);
+	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	atomic_long_inc(&dst_mm->nr_ptes);
+	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
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

