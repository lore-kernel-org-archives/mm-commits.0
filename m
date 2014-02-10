From: akpm@linux-foundation.org
Subject: + mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch added to
 -mm tree
Date: Mon, 10 Feb 2014 14:54:11 -0800
Message-ID: <52f95893.PNHL6uRJHIMpoOM0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBJWyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 17:54:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, matthew.r.wilcox@intel.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: + mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,matthew.r.wilcox@intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 14:54:11 -0800


The patch titled
     Subject: mm: consolidate code to call vm_ops->page_mkwrite()
has been added to the -mm tree.  Its filename is
     mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch

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
Subject: mm: consolidate code to call vm_ops->page_mkwrite()

There are two functions which need to call vm_ops->page_mkwrite():
do_shared_fault() and do_wp_page().  We can consolidate preparation code.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |  104 +++++++++++++++++++++-----------------------------
 1 file changed, 44 insertions(+), 60 deletions(-)

diff -puN mm/memory.c~mm-consolidate-code-to-call-vm_ops-page_mkwrite mm/memory.c
--- a/mm/memory.c~mm-consolidate-code-to-call-vm_ops-page_mkwrite
+++ a/mm/memory.c
@@ -2587,6 +2587,37 @@ static inline void cow_user_page(struct
 }
 
 /*
+ * Notify the address space that the page is about to become writable so that
+ * it can prohibit this or wait for the page to get into an appropriate state.
+ *
+ * We do this without the lock held, so that it can sleep if it needs to.
+ */
+static int do_page_mkwrite(struct vm_area_struct *vma, struct page *page,
+	       unsigned long address)
+{
+	struct vm_fault vmf;
+	int ret;
+
+	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
+	vmf.pgoff = page->index;
+	vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
+	vmf.page = page;
+
+	ret = vma->vm_ops->page_mkwrite(vma, &vmf);
+	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
+		return ret;
+	if (unlikely(!(ret & VM_FAULT_LOCKED))) {
+		lock_page(page);
+		if (!page->mapping) {
+			unlock_page(page);
+			return 0; /* retry */
+		}
+	} else
+		VM_BUG_ON_PAGE(!PageLocked(page), page);
+	return ret;
+}
+
+/*
  * This routine handles present pages, when users try to write
  * to a shared page. It is done by copying the page to a new address
  * and decrementing the shared-page counter for the old page.
@@ -2668,42 +2699,15 @@ static int do_wp_page(struct mm_struct *
 		 * get_user_pages(.write=1, .force=1).
 		 */
 		if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
-			struct vm_fault vmf;
 			int tmp;
-
-			vmf.virtual_address = (void __user *)(address &
-								PAGE_MASK);
-			vmf.pgoff = old_page->index;
-			vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
-			vmf.page = old_page;
-
-			/*
-			 * Notify the address space that the page is about to
-			 * become writable so that it can prohibit this or wait
-			 * for the page to get into an appropriate state.
-			 *
-			 * We do this without the lock held, so that it can
-			 * sleep if it needs to.
-			 */
 			page_cache_get(old_page);
 			pte_unmap_unlock(page_table, ptl);
-
-			tmp = vma->vm_ops->page_mkwrite(vma, &vmf);
-			if (unlikely(tmp &
-					(VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
-				ret = tmp;
-				goto unwritable_page;
+			tmp = do_page_mkwrite(vma, old_page, address);
+			if (unlikely(!tmp || (tmp &
+					(VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
+				page_cache_release(old_page);
+				return tmp;
 			}
-			if (unlikely(!(tmp & VM_FAULT_LOCKED))) {
-				lock_page(old_page);
-				if (!old_page->mapping) {
-					ret = 0; /* retry the fault */
-					unlock_page(old_page);
-					goto unwritable_page;
-				}
-			} else
-				VM_BUG_ON_PAGE(!PageLocked(old_page), old_page);
-
 			/*
 			 * Since we dropped the lock we need to revalidate
 			 * the PTE as someone else may have changed it.  If
@@ -2892,10 +2896,6 @@ oom:
 	if (old_page)
 		page_cache_release(old_page);
 	return VM_FAULT_OOM;
-
-unwritable_page:
-	page_cache_release(old_page);
-	return ret;
 }
 
 static void unmap_mapping_range_vma(struct vm_area_struct *vma,
@@ -3418,7 +3418,6 @@ static int do_shared_fault(struct mm_str
 	spinlock_t *ptl;
 	pte_t entry, *pte;
 	int dirtied = 0;
-	struct vm_fault vmf;
 	int ret, tmp;
 
 	ret = __do_fault(vma, address, pgoff, flags, &fault_page);
@@ -3429,31 +3428,16 @@ static int do_shared_fault(struct mm_str
 	 * Check if the backing address space wants to know that the page is
 	 * about to become writable
 	 */
-	if (!vma->vm_ops->page_mkwrite)
-		goto set_pte;
-
-	unlock_page(fault_page);
-	vmf.virtual_address = (void __user *)(address & PAGE_MASK);
-	vmf.pgoff = pgoff;
-	vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
-	vmf.page = fault_page;
-
-	tmp = vma->vm_ops->page_mkwrite(vma, &vmf);
-	if (unlikely(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
-		page_cache_release(fault_page);
-		return tmp;
-	}
-
-	if (unlikely(!(tmp & VM_FAULT_LOCKED))) {
-		lock_page(fault_page);
-		if (!fault_page->mapping) {
-			unlock_page(fault_page);
+	if (vma->vm_ops->page_mkwrite) {
+		unlock_page(fault_page);
+		tmp = do_page_mkwrite(vma, fault_page, address);
+		if (unlikely(!tmp ||
+				(tmp & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))) {
 			page_cache_release(fault_page);
-			return 0; /* retry */
+			return tmp;
 		}
-	} else
-		VM_BUG_ON_PAGE(!PageLocked(fault_page), fault_page);
-set_pte:
+	}
+
 	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (unlikely(!pte_same(*pte, orig_pte))) {
 		pte_unmap_unlock(pte, ptl);
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

