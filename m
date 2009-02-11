From: akpm@linux-foundation.org
Subject: + mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch added to -mm tree
Date: Wed, 11 Feb 2009 15:18:20 -0800
Message-ID: <200902112318.n1BNIL7o024388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756377AbZBKXTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 18:19:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hugh@veritas.com, npiggin@suse.de, riel@redhat.com


The patch titled
     mm: update_page_reclaim_stat() is called from page fault path
has been added to the -mm tree.  Its filename is
     mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch

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
Subject: mm: update_page_reclaim_stat() is called from page fault path
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Unfortunately, the following two patches had conflicting concepts.

  1. commit 9ff473b9a72942c5ac0ad35607cae28d8d59ed7a
     (vmscan: evict streaming IO first)

  2. commit bf3f3bc5e734706730c12a323f9b2068052aa1f0
     (mm: don't mark_page_accessed in fault path)

(1) requires that a page fault update reclaim stat via
    mark_page_accessed(), but

(2) removed mark_page_accessed().

However, (1) actually only needed to update reclaim stat, but not activate
the page.  Then, the fault-path can call update_page_reclaim_stat() to
solve this conflict.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/filemap.c         |    1 +
 mm/memory.c          |    2 ++
 mm/swap.c            |   24 +++++++++++++++++++-----
 4 files changed, 23 insertions(+), 5 deletions(-)

diff -puN include/linux/swap.h~mm-update_page_reclaim_stat-is-called-from-page-fault-path include/linux/swap.h
--- a/include/linux/swap.h~mm-update_page_reclaim_stat-is-called-from-page-fault-path
+++ a/include/linux/swap.h
@@ -179,6 +179,7 @@ extern void __lru_cache_add(struct page 
 extern void lru_cache_add_lru(struct page *, enum lru_list lru);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
+extern void update_page_reclaim_stat(struct page *page);
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
diff -puN mm/filemap.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path mm/filemap.c
--- a/mm/filemap.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path
+++ a/mm/filemap.c
@@ -1642,6 +1642,7 @@ retry_page_update:
 	/*
 	 * Found the page and have a reference on it.
 	 */
+	update_page_reclaim_stat(page);
 	ra->prev_pos = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
diff -puN mm/memory.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path mm/memory.c
--- a/mm/memory.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path
+++ a/mm/memory.c
@@ -2485,6 +2485,8 @@ static int do_swap_page(struct mm_struct
 		try_to_free_swap(page);
 	unlock_page(page);
 
+	update_page_reclaim_stat(page);
+
 	if (write_access) {
 		ret |= do_wp_page(mm, vma, address, page_table, pmd, ptl, pte);
 		if (ret & VM_FAULT_ERROR)
diff -puN mm/swap.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path mm/swap.c
--- a/mm/swap.c~mm-update_page_reclaim_stat-is-called-from-page-fault-path
+++ a/mm/swap.c
@@ -151,8 +151,9 @@ void  rotate_reclaimable_page(struct pag
 	}
 }
 
-static void update_page_reclaim_stat(struct zone *zone, struct page *page,
-				     int file, int rotated)
+static void update_page_reclaim_stat_locked(struct zone *zone,
+					    struct page *page,
+					    int file, int rotated)
 {
 	struct zone_reclaim_stat *reclaim_stat = &zone->reclaim_stat;
 	struct zone_reclaim_stat *memcg_reclaim_stat;
@@ -171,6 +172,19 @@ static void update_page_reclaim_stat(str
 		memcg_reclaim_stat->recent_rotated[file]++;
 }
 
+void update_page_reclaim_stat(struct page *page)
+{
+	struct zone *zone = page_zone(page);
+
+	spin_lock_irq(&zone->lru_lock);
+	/* if the page isn't reclaimable, it doesn't update reclaim stat */
+	if (PageLRU(page) && !PageUnevictable(page)) {
+		update_page_reclaim_stat_locked(zone, page,
+					 !!page_is_file_cache(page), 1);
+	}
+	spin_unlock_irq(&zone->lru_lock);
+}
+
 /*
  * FIXME: speed this up?
  */
@@ -182,14 +196,14 @@ void activate_page(struct page *page)
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int file = page_is_file_cache(page);
 		int lru = LRU_BASE + file;
-		del_page_from_lru_list(zone, page, lru);
 
+		del_page_from_lru_list(zone, page, lru);
 		SetPageActive(page);
 		lru += LRU_ACTIVE;
 		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
 
-		update_page_reclaim_stat(zone, page, !!file, 1);
+		update_page_reclaim_stat_locked(zone, page, !!file, 1);
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
@@ -427,7 +441,7 @@ void ____pagevec_lru_add(struct pagevec 
 		file = is_file_lru(lru);
 		if (active)
 			SetPageActive(page);
-		update_page_reclaim_stat(zone, page, file, active);
+		update_page_reclaim_stat_locked(zone, page, file, active);
 		add_page_to_lru_list(zone, page, lru);
 	}
 	if (zone)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-fix-mlocked-page-counter-mismatch.patch
cgroups-add-li-zefan-as-a-maintainer.patch
vmalloc-add-__get_vm_area_caller.patch
vmalloc-add-__get_vm_area_caller-checkpatch-fixes.patch
linux-next.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

