From: akpm@linux-foundation.org
Subject: [merged] mm-rename-__do_fault-do_fault.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:31:52 -0700
Message-ID: <533f08a8.w20G/8kWy2lN8j7s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaDDTbx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, matthew.r.wilcox@intel.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-rename-__do_fault-do_fault.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,matthew.r.wilcox@intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:52 -0700


The patch titled
     Subject: mm: rename __do_fault() -> do_fault()
has been removed from the -mm tree.  Its filename was
     mm-rename-__do_fault-do_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: rename __do_fault() -> do_fault()

Current __do_fault() is awful and unmaintainable.  These patches try to
sort it out by split __do_fault() into three destinct codepaths:

 - to handle read page fault;
 - to handle write page fault to private mappings;
 - to handle write page fault to shared mappings;

I also found page refcount leak in PageHWPoison() path of __do_fault().


This patch (of 7):

do_fault() is unused: no reason for underscores.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~mm-rename-__do_fault-do_fault mm/memory.c
--- a/mm/memory.c~mm-rename-__do_fault-do_fault
+++ a/mm/memory.c
@@ -2748,7 +2748,7 @@ reuse:
 		 * bit after it clear all dirty ptes, but before a racing
 		 * do_wp_page installs a dirty pte.
 		 *
-		 * __do_fault is protected similarly.
+		 * do_fault is protected similarly.
 		 */
 		if (!page_mkwrite) {
 			wait_on_page_locked(dirty_page);
@@ -3287,7 +3287,7 @@ oom:
 }
 
 /*
- * __do_fault() tries to create a new page mapping. It aggressively
+ * do_fault() tries to create a new page mapping. It aggressively
  * tries to share with existing pages, but makes a separate copy if
  * the FAULT_FLAG_WRITE is set in the flags parameter in order to avoid
  * the next page fault.
@@ -3299,7 +3299,7 @@ oom:
  * but allow concurrent faults), and pte neither mapped nor locked.
  * We return with mmap_sem still held, but pte unmapped and unlocked.
  */
-static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
+static int do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmd,
 		pgoff_t pgoff, unsigned int flags, pte_t orig_pte)
 {
@@ -3496,7 +3496,7 @@ static int do_linear_fault(struct mm_str
 			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
 	pte_unmap(page_table);
-	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
+	return do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
 /*
@@ -3528,7 +3528,7 @@ static int do_nonlinear_fault(struct mm_
 	}
 
 	pgoff = pte_to_pgoff(orig_pte);
-	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
+	return do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
 static int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-disable-split-page-table-lock-for-mmu.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-introduce-vm_ops-map_pages.patch
mm-introduce-vm_ops-map_pages-fix.patch
mm-implement-map_pages-for-page-cache.patch
mm-implement-map_pages-for-page-cache-fix.patch
mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-use-const-char-insted-of-char-for-reason-in-dump_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

