From: akpm@linux-foundation.org
Subject: + mm-fix-swapin-race-condition.patch added to -mm tree
Date: Fri, 03 Sep 2010 17:03:42 -0700
Message-ID: <201009040003.o8403gri020398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751091Ab0IDAD6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 20:03:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hughd@google.com, riel@redhat.com, stable@kernel.org


The patch titled
     mm: fix swapin race condition
has been added to the -mm tree.  Its filename is
     mm-fix-swapin-race-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix swapin race condition
From: Andrea Arcangeli <aarcange@redhat.com>

The pte_same check is reliable only if the swap entry remains pinned (by
the page lock on swapcache).  We've also to ensure the swapcache isn't
removed before we take the lock as try_to_free_swap won't care about the
page pin.

One of the possible impacts of this patch is that a KSM-shared page can
point to the anon_vma of another process, which could exit before the page
is freed.

This can leave a page with a pointer to a recycled anon_vma object, or
worse, a pointer to something that is no longer an anon_vma.

[riel@redhat.com: changelog help]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |   20 +++++++++-----------
 mm/ksm.c            |    3 ---
 mm/memory.c         |   39 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 43 insertions(+), 19 deletions(-)

diff -puN include/linux/ksm.h~mm-fix-swapin-race-condition include/linux/ksm.h
--- a/include/linux/ksm.h~mm-fix-swapin-race-condition
+++ a/include/linux/ksm.h
@@ -16,6 +16,9 @@
 struct stable_node;
 struct mem_cgroup;
 
+struct page *ksm_does_need_to_copy(struct page *page,
+			struct vm_area_struct *vma, unsigned long address);
+
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, unsigned long *vm_flags);
@@ -70,19 +73,14 @@ static inline void set_page_stable_node(
  * We'd like to make this conditional on vma->vm_flags & VM_MERGEABLE,
  * but what if the vma was unmerged while the page was swapped out?
  */
-struct page *ksm_does_need_to_copy(struct page *page,
-			struct vm_area_struct *vma, unsigned long address);
-static inline struct page *ksm_might_need_to_copy(struct page *page,
+static inline int ksm_might_need_to_copy(struct page *page,
 			struct vm_area_struct *vma, unsigned long address)
 {
 	struct anon_vma *anon_vma = page_anon_vma(page);
 
-	if (!anon_vma ||
-	    (anon_vma->root == vma->anon_vma->root &&
-	     page->index == linear_page_index(vma, address)))
-		return page;
-
-	return ksm_does_need_to_copy(page, vma, address);
+	return anon_vma &&
+		(anon_vma->root != vma->anon_vma->root ||
+		 page->index != linear_page_index(vma, address));
 }
 
 int page_referenced_ksm(struct page *page,
@@ -115,10 +113,10 @@ static inline int ksm_madvise(struct vm_
 	return 0;
 }
 
-static inline struct page *ksm_might_need_to_copy(struct page *page,
+static inline int ksm_might_need_to_copy(struct page *page,
 			struct vm_area_struct *vma, unsigned long address)
 {
-	return page;
+	return 0;
 }
 
 static inline int page_referenced_ksm(struct page *page,
diff -puN mm/ksm.c~mm-fix-swapin-race-condition mm/ksm.c
--- a/mm/ksm.c~mm-fix-swapin-race-condition
+++ a/mm/ksm.c
@@ -1504,8 +1504,6 @@ struct page *ksm_does_need_to_copy(struc
 {
 	struct page *new_page;
 
-	unlock_page(page);	/* any racers will COW it, not modify it */
-
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 	if (new_page) {
 		copy_user_highpage(new_page, page, address, vma);
@@ -1521,7 +1519,6 @@ struct page *ksm_does_need_to_copy(struc
 			add_page_to_unevictable_list(new_page);
 	}
 
-	page_cache_release(page);
 	return new_page;
 }
 
diff -puN mm/memory.c~mm-fix-swapin-race-condition mm/memory.c
--- a/mm/memory.c~mm-fix-swapin-race-condition
+++ a/mm/memory.c
@@ -2623,7 +2623,7 @@ static int do_swap_page(struct mm_struct
 		unsigned int flags, pte_t orig_pte)
 {
 	spinlock_t *ptl;
-	struct page *page;
+	struct page *page, *swapcache = NULL;
 	swp_entry_t entry;
 	pte_t pte;
 	struct mem_cgroup *ptr = NULL;
@@ -2679,10 +2679,23 @@ static int do_swap_page(struct mm_struct
 	lock_page(page);
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
-	page = ksm_might_need_to_copy(page, vma, address);
-	if (!page) {
-		ret = VM_FAULT_OOM;
-		goto out;
+	/*
+	 * Make sure try_to_free_swap didn't release the swapcache
+	 * from under us. The page pin isn't enough to prevent that.
+	 */
+	if (unlikely(!PageSwapCache(page)))
+		goto out_page;
+
+	if (ksm_might_need_to_copy(page, vma, address)) {
+		swapcache = page;
+		page = ksm_does_need_to_copy(page, vma, address);
+
+		if (unlikely(!page)) {
+			ret = VM_FAULT_OOM;
+			page = swapcache;
+			swapcache = NULL;
+			goto out_page;
+		}
 	}
 
 	if (mem_cgroup_try_charge_swapin(mm, page, GFP_KERNEL, &ptr)) {
@@ -2735,6 +2748,18 @@ static int do_swap_page(struct mm_struct
 	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
 		try_to_free_swap(page);
 	unlock_page(page);
+	if (swapcache) {
+		/*
+		 * Hold the lock to avoid the swap entry to be reused
+		 * until we take the PT lock for the pte_same() check
+		 * (to avoid false positives from pte_same). For
+		 * further safety release the lock after the swap_free
+		 * so that the swap count won't change under a
+		 * parallel locked swapcache.
+		 */
+		unlock_page(swapcache);
+		page_cache_release(swapcache);
+	}
 
 	if (flags & FAULT_FLAG_WRITE) {
 		ret |= do_wp_page(mm, vma, address, page_table, pmd, ptl, pte);
@@ -2756,6 +2781,10 @@ out_page:
 	unlock_page(page);
 out_release:
 	page_cache_release(page);
+	if (swapcache) {
+		unlock_page(swapcache);
+		page_cache_release(swapcache);
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
mm-fix-swapin-race-condition.patch
mm-avoid-warning-when-compaction-is-selected.patch
define-madv_hugepage.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch

