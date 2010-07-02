From: akpm@linux-foundation.org
Subject: + rmap-add-exclusive-page-to-private-anon_vma-on-swapin.patch added to -mm tree
Date: Fri, 02 Jul 2010 15:06:14 -0700
Message-ID: <201007022206.o62M6EwQ029441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700Ab0GBWG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 18:06:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, aarcange@redhat.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     rmap: add exclusive page to private anon_vma on swapin
has been added to the -mm tree.  Its filename is
     rmap-add-exclusive-page-to-private-anon_vma-on-swapin.patch

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
Subject: rmap: add exclusive page to private anon_vma on swapin
From: Rik van Riel <riel@redhat.com>

On swapin it is fairly common for a page to be owned exclusively by one
process.  In that case we want to add the page to the anon_vma of that
process's VMA, instead of to the root anon_vma.

This will reduce the amount of rmap searching that the swapout code needs
to do.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    2 ++
 mm/memory.c          |    4 +++-
 mm/rmap.c            |   13 ++++++++++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff -puN include/linux/rmap.h~rmap-add-exclusive-page-to-private-anon_vma-on-swapin include/linux/rmap.h
--- a/include/linux/rmap.h~rmap-add-exclusive-page-to-private-anon_vma-on-swapin
+++ a/include/linux/rmap.h
@@ -162,6 +162,8 @@ static inline void anon_vma_merge(struct
  */
 void page_move_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
+void do_page_add_anon_rmap(struct page *, struct vm_area_struct *,
+			   unsigned long, int);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *, unsigned long);
 void page_add_file_rmap(struct page *);
 void page_remove_rmap(struct page *);
diff -puN mm/memory.c~rmap-add-exclusive-page-to-private-anon_vma-on-swapin mm/memory.c
--- a/mm/memory.c~rmap-add-exclusive-page-to-private-anon_vma-on-swapin
+++ a/mm/memory.c
@@ -2618,6 +2618,7 @@ static int do_swap_page(struct mm_struct
 	swp_entry_t entry;
 	pte_t pte;
 	struct mem_cgroup *ptr = NULL;
+	int exclusive = 0;
 	int ret = 0;
 
 	if (!pte_unmap_same(mm, pmd, page_table, orig_pte))
@@ -2712,10 +2713,11 @@ static int do_swap_page(struct mm_struct
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		flags &= ~FAULT_FLAG_WRITE;
+		exclusive = 1;
 	}
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
-	page_add_anon_rmap(page, vma, address);
+	do_page_add_anon_rmap(page, vma, address, exclusive);
 	/* It's better to call commit-charge after rmap is established */
 	mem_cgroup_commit_charge_swapin(page, ptr);
 
diff -puN mm/rmap.c~rmap-add-exclusive-page-to-private-anon_vma-on-swapin mm/rmap.c
--- a/mm/rmap.c~rmap-add-exclusive-page-to-private-anon_vma-on-swapin
+++ a/mm/rmap.c
@@ -832,6 +832,17 @@ static void __page_check_anon_rmap(struc
 void page_add_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
 {
+	do_page_add_anon_rmap(page, vma, address, 0);
+}
+
+/*
+ * Special version of the above for do_swap_page, which often runs
+ * into pages that are exclusively owned by the current process.
+ * Everybody else should continue to use page_add_anon_rmap above.
+ */
+void do_page_add_anon_rmap(struct page *page,
+	struct vm_area_struct *vma, unsigned long address, int exclusive)
+{
 	int first = atomic_inc_and_test(&page->_mapcount);
 	if (first)
 		__inc_zone_page_state(page, NR_ANON_PAGES);
@@ -841,7 +852,7 @@ void page_add_anon_rmap(struct page *pag
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	if (first)
-		__page_set_anon_rmap(page, vma, address, 0);
+		__page_set_anon_rmap(page, vma, address, exclusive);
 	else
 		__page_check_anon_rmap(page, vma, address);
 }
_

Patches currently in -mm which might be from riel@redhat.com are

mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-track-the-root-oldest-anon_vma-fix.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
mmap-remove-unnecessary-lock-from-__vma_link.patch
rmap-always-add-new-vmas-at-the-end.patch
ksm-fix-ksm-swapin-time-optimization.patch
rmap-always-use-anon_vma-root-pointer.patch
rmap-resurrect-page_address_in_vma-anon_vma-check.patch
add-anon_vma-bug-checks.patch
vmscan-zone_reclaim-dont-call-disable_swap_token.patch
vmscan-recalculate-lru_pages-on-each-priority.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
rmap-add-exclusive-page-to-private-anon_vma-on-swapin.patch

