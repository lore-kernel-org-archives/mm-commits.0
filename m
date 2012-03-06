From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-gpf-when-cgroup-removal-races-with-last-exit.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:35:16 -0800
Message-ID: <20120306193516.8DC3BA02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:50858 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965176Ab2CFTfS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:35:18 -0500
Received: by ggnd2 with SMTP id d2so678844ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 11:35:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix GPF when cgroup removal races with last exit
has been removed from the -mm tree.  Its filename was
     memcg-fix-gpf-when-cgroup-removal-races-with-last-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: fix GPF when cgroup removal races with last exit

When moving tasks from old memcg (with move_charge_at_immigrate on new
memcg), followed by removal of old memcg, hit General Protection Fault in
mem_cgroup_lru_del_list() (called from release_pages called from
free_pages_and_swap_cache from tlb_flush_mmu from tlb_finish_mmu from
exit_mmap from mmput from exit_mm from do_exit).

Somewhat reproducible, takes a few hours: the old struct mem_cgroup has
been freed and poisoned by SLAB_DEBUG, but mem_cgroup_lru_del_list() is
still trying to update its stats, and take page off lru before freeing.

A task, or a charge, or a page on lru: each secures a memcg against
removal.  In this case, the last task has been moved out of the old memcg,
and it is exiting: anonymous pages are uncharged one by one from the
memcg, as they are zapped from its pagetables, so the charge gets down to
0; but the pages themselves are queued in an mmu_gather for freeing.

Most of those pages will be on lru (and force_empty is careful to
lru_add_drain_all, to add pages from pagevec to lru first), but not
necessarily all: perhaps some have been isolated for page reclaim, perhaps
some isolated for other reasons.  So, force_empty may find no task, no
charge and no page on lru, and let the removal proceed.

There would still be no problem if these pages were immediately freed; but
typically (and the put_page_testzero protocol demands it) they have to be
added back to lru before they are found freeable, then removed from lru
and freed.  We don't see the issue when adding, because the
mem_cgroup_iter() loops keep their own reference to the memcg being
scanned; but when it comes to mem_cgroup_lru_del_list().

I believe this was not an issue in v3.2: there, PageCgroupAcctLRU and
PageCgroupUsed flags were used (like a trick with mirrors) to deflect view
of pc->mem_cgroup to the stable root_mem_cgroup when neither set. 
38c5d72f3ebe ("memcg: simplify LRU handling by new rule") mercifully
removed those convolutions, but left this General Protection Fault.

But it's surprisingly easy to restore the old behaviour: just check
PageCgroupUsed in mem_cgroup_lru_add_list() (which decides on which lruvec
to add), and reset pc to root_mem_cgroup if page is uncharged.  A risky
change?  just going back to how it worked before; testing, and an audit of
uses of pc->mem_cgroup, show no problem.

And there's a nice bonus: with mem_cgroup_lru_add_list() itself making
sure that an uncharged page goes to root lru, mem_cgroup_reset_owner() no
longer has any purpose, and we can safely revert 4e5f01c2b9b9 ("memcg:
clear pc->mem_cgroup if necessary").

Calling update_page_reclaim_stat() after add_page_to_lru_list() in swap.c
is not strictly necessary: the lru_lock there, with RCU before memcg
structures are freed, makes mem_cgroup_get_reclaim_stat_from_page safe
without that; but it seems cleaner to rely on one dependency less.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 -----
 mm/ksm.c                   |   11 -----------
 mm/memcontrol.c            |   30 +++++++++++++-----------------
 mm/migrate.c               |    2 --
 mm/swap.c                  |    8 +++++---
 mm/swap_state.c            |   10 ----------
 6 files changed, 18 insertions(+), 48 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit
+++ a/include/linux/memcontrol.h
@@ -129,7 +129,6 @@ extern void mem_cgroup_print_oom_info(st
 extern void mem_cgroup_replace_page_cache(struct page *oldpage,
 					struct page *newpage);
 
-extern void mem_cgroup_reset_owner(struct page *page);
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif
@@ -392,10 +391,6 @@ static inline void mem_cgroup_replace_pa
 				struct page *newpage)
 {
 }
-
-static inline void mem_cgroup_reset_owner(struct page *page)
-{
-}
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #if !defined(CONFIG_CGROUP_MEM_RES_CTLR) || !defined(CONFIG_DEBUG_VM)
diff -puN mm/ksm.c~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit mm/ksm.c
--- a/mm/ksm.c~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit
+++ a/mm/ksm.c
@@ -28,7 +28,6 @@
 #include <linux/kthread.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
-#include <linux/memcontrol.h>
 #include <linux/rbtree.h>
 #include <linux/memory.h>
 #include <linux/mmu_notifier.h>
@@ -1572,16 +1571,6 @@ struct page *ksm_does_need_to_copy(struc
 
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 	if (new_page) {
-		/*
-		 * The memcg-specific accounting when moving
-		 * pages around the LRU lists relies on the
-		 * page's owner (memcg) to be valid.  Usually,
-		 * pages are assigned to a new owner before
-		 * being put on the LRU list, but since this
-		 * is not the case here, the stale owner from
-		 * a previous allocation cycle must be reset.
-		 */
-		mem_cgroup_reset_owner(new_page);
 		copy_user_highpage(new_page, page, address, vma);
 
 		SetPageDirty(new_page);
diff -puN mm/memcontrol.c~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit
+++ a/mm/memcontrol.c
@@ -1042,6 +1042,19 @@ struct lruvec *mem_cgroup_lru_add_list(s
 
 	pc = lookup_page_cgroup(page);
 	memcg = pc->mem_cgroup;
+
+	/*
+	 * Surreptitiously switch any uncharged page to root:
+	 * an uncharged page off lru does nothing to secure
+	 * its former mem_cgroup from sudden removal.
+	 *
+	 * Our caller holds lru_lock, and PageCgroupUsed is updated
+	 * under page_cgroup lock: between them, they make all uses
+	 * of pc->mem_cgroup safe.
+	 */
+	if (!PageCgroupUsed(pc) && memcg != root_mem_cgroup)
+		pc->mem_cgroup = memcg = root_mem_cgroup;
+
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* compound_order() is stabilized through lru_lock */
 	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
@@ -3029,23 +3042,6 @@ void mem_cgroup_uncharge_end(void)
 	batch->memcg = NULL;
 }
 
-/*
- * A function for resetting pc->mem_cgroup for newly allocated pages.
- * This function should be called if the newpage will be added to LRU
- * before start accounting.
- */
-void mem_cgroup_reset_owner(struct page *newpage)
-{
-	struct page_cgroup *pc;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	pc = lookup_page_cgroup(newpage);
-	VM_BUG_ON(PageCgroupUsed(pc));
-	pc->mem_cgroup = root_mem_cgroup;
-}
-
 #ifdef CONFIG_SWAP
 /*
  * called after __delete_from_swap_cache() and drop "page" account.
diff -puN mm/migrate.c~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit mm/migrate.c
--- a/mm/migrate.c~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit
+++ a/mm/migrate.c
@@ -839,8 +839,6 @@ static int unmap_and_move(new_page_t get
 	if (!newpage)
 		return -ENOMEM;
 
-	mem_cgroup_reset_owner(newpage);
-
 	if (page_count(page) == 1) {
 		/* page was freed from under us. So we are done. */
 		goto out;
diff -puN mm/swap.c~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit mm/swap.c
--- a/mm/swap.c~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit
+++ a/mm/swap.c
@@ -652,7 +652,7 @@ EXPORT_SYMBOL(__pagevec_release);
 void lru_add_page_tail(struct zone* zone,
 		       struct page *page, struct page *page_tail)
 {
-	int active;
+	int uninitialized_var(active);
 	enum lru_list lru;
 	const int file = 0;
 
@@ -672,7 +672,6 @@ void lru_add_page_tail(struct zone* zone
 			active = 0;
 			lru = LRU_INACTIVE_ANON;
 		}
-		update_page_reclaim_stat(zone, page_tail, file, active);
 	} else {
 		SetPageUnevictable(page_tail);
 		lru = LRU_UNEVICTABLE;
@@ -693,6 +692,9 @@ void lru_add_page_tail(struct zone* zone
 		list_head = page_tail->lru.prev;
 		list_move_tail(&page_tail->lru, list_head);
 	}
+
+	if (!PageUnevictable(page))
+		update_page_reclaim_stat(zone, page_tail, file, active);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -710,8 +712,8 @@ static void __pagevec_lru_add_fn(struct 
 	SetPageLRU(page);
 	if (active)
 		SetPageActive(page);
-	update_page_reclaim_stat(zone, page, file, active);
 	add_page_to_lru_list(zone, page, lru);
+	update_page_reclaim_stat(zone, page, file, active);
 }
 
 /*
diff -puN mm/swap_state.c~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit mm/swap_state.c
--- a/mm/swap_state.c~memcg-fix-gpf-when-cgroup-removal-races-with-last-exit
+++ a/mm/swap_state.c
@@ -300,16 +300,6 @@ struct page *read_swap_cache_async(swp_e
 			new_page = alloc_page_vma(gfp_mask, vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
-			/*
-			 * The memcg-specific accounting when moving
-			 * pages around the LRU lists relies on the
-			 * page's owner (memcg) to be valid.  Usually,
-			 * pages are assigned to a new owner before
-			 * being put on the LRU list, but since this
-			 * is not the case here, the stale owner from
-			 * a previous allocation cycle must be reset.
-			 */
-			mem_cgroup_reset_owner(new_page);
 		}
 
 		/*
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
make-swapin-readahead-skip-over-holes.patch
make-swapin-readahead-skip-over-holes-fix.patch
compact_pgdat-workaround-lockdep-warning-in-kswapd.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch
mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
tmpfs-security-xattr-setting-on-inode-creation.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
ksm-clean-up-page_trans_compound_anon_split.patch
ksm-cleanup-introduce-ksm_check_mm.patch
ksm-cleanup-introduce-ksm_check_mm-fix.patch
hugetlbfs-drop-taking-inode-i_mutex-lock-from-hugetlbfs_read.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix-2.patch
memcg-remove-pcg_file_mapped-fix-cosmetic-fix.patch
memcg-remove-pcg_file_mapped-fix-42.patch
prio_tree-debugging-patch.patch

