From: akpm@linux-foundation.org
Subject: +
 mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch added to -mm tree
Date: Thu, 16 Jun 2016 15:22:37 -0700
Message-ID: <576326ad.+Gin/e5BZMhPbnBz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbcFPWWi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2016 18:22:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, ebru.akagunduz@gmail.com, hughd@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject:  mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix
has been added to the -mm tree.  Its filename is
     mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch

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
Subject:  mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix

Passing 'vma' to hugepage_vma_revlidate() is useless.  It doesn't make use
of it anyway.

Link: http://lkml.kernel.org/r/20160530095058.GA53044@black.fi.intel.com

Link: http://lkml.kernel.org/r/1466021202-61880-3-git-send-email-kirill.shutemov@linux.intel.com
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix
+++ a/mm/huge_memory.c
@@ -2385,10 +2385,9 @@ static bool hugepage_vma_check(struct vm
  * value (scan code).
  */
 
-static int hugepage_vma_revalidate(struct mm_struct *mm,
-				   struct vm_area_struct *vma,
-				   unsigned long address)
+static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address)
 {
+	struct vm_area_struct *vma;
 	unsigned long hstart, hend;
 
 	if (unlikely(khugepaged_test_exit(mm)))
@@ -2437,7 +2436,7 @@ static bool __collapse_huge_page_swapin(
 		if (ret & VM_FAULT_RETRY) {
 			down_read(&mm->mmap_sem);
 			/* vma is no longer available, don't continue to swapin */
-			if (hugepage_vma_revalidate(mm, vma, address))
+			if (hugepage_vma_revalidate(mm, address))
 				return false;
 		}
 		if (ret & VM_FAULT_ERROR) {
@@ -2488,7 +2487,7 @@ static void collapse_huge_page(struct mm
 	}
 
 	down_read(&mm->mmap_sem);
-	result = hugepage_vma_revalidate(mm, vma, address);
+	result = hugepage_vma_revalidate(mm, address);
 	if (result)
 		goto out;
 
@@ -2515,7 +2514,7 @@ static void collapse_huge_page(struct mm
 	 * handled by the anon_vma lock + PG_lock.
 	 */
 	down_write(&mm->mmap_sem);
-	result = hugepage_vma_revalidate(mm, vma, address);
+	result = hugepage_vma_revalidate(mm, address);
 	if (result)
 		goto out;
 
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

