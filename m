From: akpm@linux-foundation.org
Subject: +
 mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
 added to -mm tree
Date: Mon, 10 Feb 2014 14:54:07 -0800
Message-ID: <52f9588f.Pa7JK/U+9G8+6FHP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaBJWyI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:54:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, matthew.r.wilcox@intel.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: + mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,matthew.r.wilcox@intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:54:07 -0800


The patch titled
     Subject: mm: do_fault(): extract to call vm_ops->do_fault() to separate function
has been added to the -mm tree.  Its filename is
     mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch

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

pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-hwpoison-release-page-on-pagehwpoison-in-__do_fault.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-setup-pte.patch

