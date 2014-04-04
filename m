From: akpm@linux-foundation.org
Subject: [merged]
 mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:31:54 -0700
Message-ID: <533f08aa.uIkdBaK3sWIjFRw1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbaDDTbz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, matthew.r.wilcox@intel.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,matthew.r.wilcox@intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:54 -0700


The patch titled
     Subject: mm: do_fault(): extract to call vm_ops->do_fault() to separate function
has been removed from the -mm tree.  Its filename was
     mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: do_fault(): extract to call vm_ops->do_fault() to separate function

Extract code to vm_ops->do_fault() and basic error handling to separate
function.  The code will be reused.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   76 +++++++++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 31 deletions(-)

diff -puN mm/memory.c~mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function mm/memory.c
--- a/mm/memory.c~mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function
+++ a/mm/memory.c
@@ -3286,6 +3286,37 @@ oom:
 	return VM_FAULT_OOM;
 }
 
+static int __do_fault(struct vm_area_struct *vma, unsigned long address,
+		pgoff_t pgoff, unsigned int flags, struct page **page)
+{
+	struct vm_fault vmf;
+	int ret;
+
+	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
+	vmf.pgoff = pgoff;
+	vmf.flags = flags;
+	vmf.page = NULL;
+
+	ret = vma->vm_ops->fault(vma, &vmf);
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
+		return ret;
+
+	if (unlikely(PageHWPoison(vmf.page))) {
+		if (ret & VM_FAULT_LOCKED)
+			unlock_page(vmf.page);
+		page_cache_release(vmf.page);
+		return VM_FAULT_HWPOISON;
+	}
+
+	if (unlikely(!(ret & VM_FAULT_LOCKED)))
+		lock_page(vmf.page);
+	else
+		VM_BUG_ON_PAGE(!PageLocked(vmf.page), vmf.page);
+
+	*page = vmf.page;
+	return ret;
+}
+
 /*
  * do_fault() tries to create a new page mapping. It aggressively
  * tries to share with existing pages, but makes a separate copy if
@@ -3305,12 +3336,11 @@ static int do_fault(struct mm_struct *mm
 {
 	pte_t *page_table;
 	spinlock_t *ptl;
-	struct page *page;
+	struct page *page, *fault_page;
 	struct page *cow_page;
 	pte_t entry;
 	int anon = 0;
 	struct page *dirty_page = NULL;
-	struct vm_fault vmf;
 	int ret;
 	int page_mkwrite = 0;
 
@@ -3334,42 +3364,19 @@ static int do_fault(struct mm_struct *mm
 	} else
 		cow_page = NULL;
 
-	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
-	vmf.pgoff = pgoff;
-	vmf.flags = flags;
-	vmf.page = NULL;
-
-	ret = vma->vm_ops->fault(vma, &vmf);
-	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
-			    VM_FAULT_RETRY)))
+	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
 		goto uncharge_out;
 
-	if (unlikely(PageHWPoison(vmf.page))) {
-		if (ret & VM_FAULT_LOCKED)
-			unlock_page(vmf.page);
-		ret = VM_FAULT_HWPOISON;
-		page_cache_release(vmf.page);
-		goto uncharge_out;
-	}
-
-	/*
-	 * For consistency in subsequent calls, make the faulted page always
-	 * locked.
-	 */
-	if (unlikely(!(ret & VM_FAULT_LOCKED)))
-		lock_page(vmf.page);
-	else
-		VM_BUG_ON_PAGE(!PageLocked(vmf.page), vmf.page);
-
 	/*
 	 * Should we do an early C-O-W break?
 	 */
-	page = vmf.page;
+	page = fault_page;
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!(vma->vm_flags & VM_SHARED)) {
 			page = cow_page;
 			anon = 1;
-			copy_user_highpage(page, vmf.page, address, vma);
+			copy_user_highpage(page, fault_page, address, vma);
 			__SetPageUptodate(page);
 		} else {
 			/*
@@ -3378,8 +3385,15 @@ static int do_fault(struct mm_struct *mm
 			 * to become writable
 			 */
 			if (vma->vm_ops->page_mkwrite) {
+				struct vm_fault vmf;
 				int tmp;
 
+				vmf.virtual_address =
+					(void __user *)(address & PAGE_MASK);
+				vmf.pgoff = pgoff;
+				vmf.flags = flags;
+				vmf.page = fault_page;
+
 				unlock_page(page);
 				vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 				tmp = vma->vm_ops->page_mkwrite(vma, &vmf);
@@ -3469,9 +3483,9 @@ static int do_fault(struct mm_struct *mm
 		if (vma->vm_file && !page_mkwrite)
 			file_update_time(vma->vm_file);
 	} else {
-		unlock_page(vmf.page);
+		unlock_page(fault_page);
 		if (anon)
-			page_cache_release(vmf.page);
+			page_cache_release(fault_page);
 	}
 
 	return ret;
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

