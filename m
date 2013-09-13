From: akpm@linux-foundation.org
Subject: [merged]
 thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch removed from -mm tree
Date: Fri, 13 Sep 2013 13:03:02 -0700
Message-ID: <52336f76.1EOyBtH63ypjz7fo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:03:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, viro@zeniv.linux.org.uk, mgorman@suse.de, jack@suse.cz, hughd@google.com, fengguang.wu@intel.com, dhillf@gmail.com, dave.hansen@linux.intel.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,dave.hansen@linux.intel.com,dhillf@gmail.com,fengguang.wu@intel.com,hughd@google.com,jack@suse.cz,mgorman@suse.de,viro@zeniv.linux.org.uk,willy@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:03:02 -0700


The patch titled
     Subject: thp: consolidate code between handle_mm_fault() and do_huge_pmd_anonymous_page()
has been removed from the -mm tree.  Its filename was
     thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: consolidate code between handle_mm_fault() and do_huge_pmd_anonymous_page()

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

do_huge_pmd_anonymous_page() has copy-pasted piece of handle_mm_fault()
to handle fallback path.

Let's consolidate code back by introducing VM_FAULT_FALLBACK return
code.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 ---
 include/linux/mm.h      |    3 ++-
 mm/huge_memory.c        |   31 +++++--------------------------
 mm/memory.c             |    9 ++++++---
 4 files changed, 13 insertions(+), 33 deletions(-)

diff -puN include/linux/huge_mm.h~thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page
+++ a/include/linux/huge_mm.h
@@ -96,9 +96,6 @@ extern int copy_pte_range(struct mm_stru
 			  pmd_t *dst_pmd, pmd_t *src_pmd,
 			  struct vm_area_struct *vma,
 			  unsigned long addr, unsigned long end);
-extern int handle_pte_fault(struct mm_struct *mm,
-			    struct vm_area_struct *vma, unsigned long address,
-			    pte_t *pte, pmd_t *pmd, unsigned int flags);
 extern int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
 {
diff -puN include/linux/mm.h~thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page include/linux/mm.h
--- a/include/linux/mm.h~thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page
+++ a/include/linux/mm.h
@@ -877,11 +877,12 @@ static inline int page_mapped(struct pag
 #define VM_FAULT_NOPAGE	0x0100	/* ->fault installed the pte, not return page */
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
 #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
+#define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
 
 #define VM_FAULT_HWPOISON_LARGE_MASK 0xf000 /* encodes hpage index for large hwpoison */
 
 #define VM_FAULT_ERROR	(VM_FAULT_OOM | VM_FAULT_SIGBUS | VM_FAULT_HWPOISON | \
-			 VM_FAULT_HWPOISON_LARGE)
+			 VM_FAULT_FALLBACK | VM_FAULT_HWPOISON_LARGE)
 
 /* Encode hstate index for a hwpoisoned large page */
 #define VM_FAULT_SET_HINDEX(x) ((x) << 12)
diff -puN mm/huge_memory.c~thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page
+++ a/mm/huge_memory.c
@@ -783,10 +783,9 @@ int do_huge_pmd_anonymous_page(struct mm
 {
 	struct page *page;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
-	pte_t *pte;
 
 	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
-		goto out;
+		return VM_FAULT_FALLBACK;
 	if (unlikely(anon_vma_prepare(vma)))
 		return VM_FAULT_OOM;
 	if (unlikely(khugepaged_enter(vma)))
@@ -803,7 +802,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		if (unlikely(!zero_page)) {
 			pte_free(mm, pgtable);
 			count_vm_event(THP_FAULT_FALLBACK);
-			goto out;
+			return VM_FAULT_FALLBACK;
 		}
 		spin_lock(&mm->page_table_lock);
 		set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
@@ -819,40 +818,20 @@ int do_huge_pmd_anonymous_page(struct mm
 			vma, haddr, numa_node_id(), 0);
 	if (unlikely(!page)) {
 		count_vm_event(THP_FAULT_FALLBACK);
-		goto out;
+		return VM_FAULT_FALLBACK;
 	}
 	count_vm_event(THP_FAULT_ALLOC);
 	if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
 		put_page(page);
-		goto out;
+		return VM_FAULT_FALLBACK;
 	}
 	if (unlikely(__do_huge_pmd_anonymous_page(mm, vma, haddr, pmd, page))) {
 		mem_cgroup_uncharge_page(page);
 		put_page(page);
-		goto out;
+		return VM_FAULT_FALLBACK;
 	}
 
 	return 0;
-out:
-	/*
-	 * Use __pte_alloc instead of pte_alloc_map, because we can't
-	 * run pte_offset_map on the pmd, if an huge pmd could
-	 * materialize from under us from a different thread.
-	 */
-	if (unlikely(pmd_none(*pmd)) &&
-	    unlikely(__pte_alloc(mm, vma, pmd, address)))
-		return VM_FAULT_OOM;
-	/* if an huge pmd materialized from under us just retry later */
-	if (unlikely(pmd_trans_huge(*pmd)))
-		return 0;
-	/*
-	 * A regular pmd is established and it can't morph into a huge pmd
-	 * from under us anymore at this point because we hold the mmap_sem
-	 * read mode and khugepaged takes it in write mode. So now it's
-	 * safe to run pte_offset_map().
-	 */
-	pte = pte_offset_map(pmd, address);
-	return handle_pte_fault(mm, vma, address, pte, pmd, flags);
 }
 
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
diff -puN mm/memory.c~thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page mm/memory.c
--- a/mm/memory.c~thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page
+++ a/mm/memory.c
@@ -3695,7 +3695,7 @@ static int do_pmd_numa_page(struct mm_st
  * but allow concurrent faults), and pte mapped but not yet locked.
  * We return with mmap_sem still held, but pte unmapped and unlocked.
  */
-int handle_pte_fault(struct mm_struct *mm,
+static int handle_pte_fault(struct mm_struct *mm,
 		     struct vm_area_struct *vma, unsigned long address,
 		     pte_t *pte, pmd_t *pmd, unsigned int flags)
 {
@@ -3774,9 +3774,12 @@ retry:
 	if (!pmd)
 		return VM_FAULT_OOM;
 	if (pmd_none(*pmd) && transparent_hugepage_enabled(vma)) {
+		int ret = VM_FAULT_FALLBACK;
 		if (!vma->vm_ops)
-			return do_huge_pmd_anonymous_page(mm, vma, address,
-							  pmd, flags);
+			ret = do_huge_pmd_anonymous_page(mm, vma, address,
+					pmd, flags);
+		if (!(ret & VM_FAULT_FALLBACK))
+			return ret;
 	} else {
 		pmd_t orig_pmd = *pmd;
 		int ret;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
thp-mm-locking-tail-page-is-a-bug.patch
thp-mm-locking-tail-page-is-a-bug-fix.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

