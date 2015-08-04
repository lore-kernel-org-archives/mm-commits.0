From: akpm@linux-foundation.org
Subject: + dax-dont-use-set_huge_zero_page.patch added to -mm tree
Date: Tue, 04 Aug 2015 14:34:41 -0700
Message-ID: <55c12ff1.epjlz8usY6YGhpx2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbbHDVem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 17:34:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: don't use set_huge_zero_page()
has been added to the -mm tree.  Its filename is
     dax-dont-use-set_huge_zero_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-dont-use-set_huge_zero_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-dont-use-set_huge_zero_page.patch

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
Subject: dax: don't use set_huge_zero_page()

This is another place where DAX assumed that pgtable_t was a pointer. 
Open code the important parts of set_huge_zero_page() in DAX and make
set_huge_zero_page() static again.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c                |   18 ++++++++++++------
 include/linux/huge_mm.h |    3 ---
 mm/huge_memory.c        |    2 +-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff -puN fs/dax.c~dax-dont-use-set_huge_zero_page fs/dax.c
--- a/fs/dax.c~dax-dont-use-set_huge_zero_page
+++ a/fs/dax.c
@@ -572,18 +572,24 @@ int __dax_pmd_fault(struct vm_area_struc
 		unmap_mapping_range(mapping, pgoff << PAGE_SHIFT, PMD_SIZE, 0);
 
 	if (!write && !buffer_mapped(&bh) && buffer_uptodate(&bh)) {
-		bool set;
 		spinlock_t *ptl;
-		struct mm_struct *mm = vma->vm_mm;
+		pmd_t entry;
 		struct page *zero_page = get_huge_zero_page();
+
 		if (unlikely(!zero_page))
 			goto fallback;
 
-		ptl = pmd_lock(mm, pmd);
-		set = set_huge_zero_page(NULL, mm, vma, pmd_addr, pmd,
-								zero_page);
-		spin_unlock(ptl);
+		ptl = pmd_lock(vma->vm_mm, pmd);
+		if (!pmd_none(*pmd)) {
+			spin_unlock(ptl);
+			goto fallback;
+		}
+
+		entry = mk_pmd(zero_page, vma->vm_page_prot);
+		entry = pmd_mkhuge(entry);
+		set_pmd_at(vma->vm_mm, pmd_addr, pmd, entry);
 		result = VM_FAULT_NOPAGE;
+		spin_unlock(ptl);
 	} else {
 		sector = bh.b_blocknr << (blkbits - 9);
 		length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
diff -puN include/linux/huge_mm.h~dax-dont-use-set_huge_zero_page include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~dax-dont-use-set_huge_zero_page
+++ a/include/linux/huge_mm.h
@@ -163,9 +163,6 @@ static inline bool is_huge_zero_pmd(pmd_
 }
 
 struct page *get_huge_zero_page(void);
-bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long haddr,
-		pmd_t *pmd, struct page *zero_page);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
diff -puN mm/huge_memory.c~dax-dont-use-set_huge_zero_page mm/huge_memory.c
--- a/mm/huge_memory.c~dax-dont-use-set_huge_zero_page
+++ a/mm/huge_memory.c
@@ -790,7 +790,7 @@ static inline gfp_t alloc_hugepage_gfpma
 }
 
 /* Caller must hold page table lock. */
-bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
 		struct page *zero_page)
 {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

user_ns-use-correct-check-for-single-threadedness.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch
mm-fix-status-code-move_pages-returns-for-zero-page.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
mremap-dont-leak-new_vma-if-f_op-mremap-fails.patch
mm-move-mremap-from-file_operations-to-vm_operations_struct.patch
mremap-dont-do-mm_populatenew_addr-on-failure.patch
mremap-dont-do-uneccesary-checks-if-new_len-==-old_len.patch
mremap-simplify-the-overlap-check-in-mremap_to.patch
mm-introduce-vma_is_anonymousvma-helper.patch
mmap-fix-the-usage-of-vm_pgoff-in-special_mapping-paths.patch
mremap-fix-the-wrong-vma-vm_file-check-in-copy_vma.patch
thp-vma_adjust_trans_huge-adjust-file-backed-vma-too.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch
thp-decrement-refcount-on-huge-zero-page-if-it-is-split.patch
thp-fix-zap_huge_pmd-for-dax.patch
dax-dont-use-set_huge_zero_page.patch
dax-ensure-that-zero-pages-are-removed-from-other-processes.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mempolicy-get-rid-of-duplicated-check-for-vmavm_pfnmap-in-queue_pages_range.patch
vm_flags-vm_flags_t-and-__nocast.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
fix-list_poison12-offset.patch
use-poison_pointer_delta-for-poison-pointers.patch
remove-not-used-poison-pointer-macros.patch
mm-mark-most-vm_operations_struct-const.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff.patch
mm-make-sure-all-file-vmas-have-vm_ops-set.patch
mm-use-vma_is_anonymous-in-create_huge_pmd-and-wp_huge_pmd.patch
mm-madvise-use-vma_is_anonymous-to-check-for-anon-vma.patch

