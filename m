From: akpm@linux-foundation.org
Subject: +
 thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch added to -mm tree
Date: Wed, 17 Jul 2013 14:12:40 -0700
Message-ID: <51e708c8.1y/RRFAAqO/9/Qs4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3GQVMl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 17:12:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, viro@zeniv.linux.org.uk, mgorman@suse.de, jack@suse.cz, hughd@google.com, fengguang.wu@intel.com, dhillf@gmail.com, dave.hansen@linux.intel.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,dave.hansen@linux.intel.com,dhillf@gmail.com,fengguang.wu@intel.com,hughd@google.com,jack@suse.cz,mgorman@suse.de,viro@zeniv.linux.org.uk,willy@linux.intel.com
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 14:12:40 -0700


The patch titled
     Subject: thp: consolidate code between handle_mm_fault() and do_huge_pmd_anonymous_page()
has been added to the -mm tree.  Its filename is
     thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch

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
Subject: thp: consolidate code between handle_mm_fault() and do_huge_pmd_anonymous_page()


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
@@ -884,11 +884,12 @@ static inline int page_mapped(struct pag
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
@@ -788,10 +788,9 @@ int do_huge_pmd_anonymous_page(struct mm
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
@@ -808,7 +807,7 @@ int do_huge_pmd_anonymous_page(struct mm
 		if (unlikely(!zero_page)) {
 			pte_free(mm, pgtable);
 			count_vm_event(THP_FAULT_FALLBACK);
-			goto out;
+			return VM_FAULT_FALLBACK;
 		}
 		spin_lock(&mm->page_table_lock);
 		set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
@@ -824,40 +823,20 @@ int do_huge_pmd_anonymous_page(struct mm
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
@@ -3693,7 +3693,7 @@ static int do_pmd_numa_page(struct mm_st
  * but allow concurrent faults), and pte mapped but not yet locked.
  * We return with mmap_sem still held, but pte unmapped and unlocked.
  */
-int handle_pte_fault(struct mm_struct *mm,
+static int handle_pte_fault(struct mm_struct *mm,
 		     struct vm_area_struct *vma, unsigned long address,
 		     pte_t *pte, pmd_t *pmd, unsigned int flags)
 {
@@ -3780,9 +3780,12 @@ retry:
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

mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list.patch
thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
thp-mm-locking-tail-page-is-a-bug.patch

