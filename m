From: akpm@linux-foundation.org
Subject: + memcg-simplify-corner-case-handling-of-lru.patch added to -mm tree
Date: Fri, 16 Dec 2011 14:31:19 -0800
Message-ID: <20111216223120.5AA8910004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:39329 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760919Ab1LPWbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 17:31:21 -0500
Received: by ggnv2 with SMTP id v2so426685ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 14:31:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mszeredi@suse.cz, yinghan@google.com


The patch titled
     Subject: memcg: simplify corner case handling of LRU.
has been added to the -mm tree.  Its filename is
     memcg-simplify-corner-case-handling-of-lru.patch

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
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: simplify corner case handling of LRU.

This patch simplifies LRU handling of racy case (memcg+SwapCache).  At
charging, SwapCache tend to be on LRU already.  So, before overwriting
pc->mem_cgroup, the page must be removed from LRU and added to LRU later.

This patch does
        spin_lock(zone->lru_lock);
        if (PageLRU(page))
                remove from LRU
        overwrite pc->mem_cgroup
        if (PageLRU(page))
                add to new LRU.
        spin_unlock(zone->lru_lock);

And guarantee all pages are not on LRU at modifying pc->mem_cgroup.
This patch also unfies lru handling of replace_page_cache() and
swapin.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ying Han <yinghan@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  109 ++++++----------------------------------------
 1 file changed, 16 insertions(+), 93 deletions(-)

diff -puN mm/memcontrol.c~memcg-simplify-corner-case-handling-of-lru mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-corner-case-handling-of-lru
+++ a/mm/memcontrol.c
@@ -1142,86 +1142,6 @@ struct lruvec *mem_cgroup_lru_move_lists
 }
 
 /*
- * At handling SwapCache and other FUSE stuff, pc->mem_cgroup may be changed
- * while it's linked to lru because the page may be reused after it's fully
- * uncharged. To handle that, unlink page_cgroup from LRU when charge it again.
- * It's done under lock_page and expected that zone->lru_lock isnever held.
- */
-static void mem_cgroup_lru_del_before_commit(struct page *page)
-{
-	enum lru_list lru;
-	unsigned long flags;
-	struct zone *zone = page_zone(page);
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-
-	/*
-	 * Doing this check without taking ->lru_lock seems wrong but this
-	 * is safe. Because if page_cgroup's USED bit is unset, the page
-	 * will not be added to any memcg's LRU. If page_cgroup's USED bit is
-	 * set, the commit after this will fail, anyway.
-	 * This all charge/uncharge is done under some mutual execustion.
-	 * So, we don't need to taking care of changes in USED bit.
-	 */
-	if (likely(!PageLRU(page)))
-		return;
-
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	lru = page_lru(page);
-	/*
-	 * The uncharged page could still be registered to the LRU of
-	 * the stale pc->mem_cgroup.
-	 *
-	 * As pc->mem_cgroup is about to get overwritten, the old LRU
-	 * accounting needs to be taken care of.  Let root_mem_cgroup
-	 * babysit the page until the new memcg is responsible for it.
-	 *
-	 * The PCG_USED bit is guarded by lock_page() as the page is
-	 * swapcache/pagecache.
-	 */
-	if (PageLRU(page) && PageCgroupAcctLRU(pc) && !PageCgroupUsed(pc)) {
-		del_page_from_lru_list(zone, page, lru);
-		add_page_to_lru_list(zone, page, lru);
-	}
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
-}
-
-static void mem_cgroup_lru_add_after_commit(struct page *page)
-{
-	enum lru_list lru;
-	unsigned long flags;
-	struct zone *zone = page_zone(page);
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-	/*
-	 * putback:				charge:
-	 * SetPageLRU				SetPageCgroupUsed
-	 * smp_mb				smp_mb
-	 * PageCgroupUsed && add to memcg LRU	PageLRU && add to memcg LRU
-	 *
-	 * Ensure that one of the two sides adds the page to the memcg
-	 * LRU during a race.
-	 */
-	smp_mb();
-	/* taking care of that the page is added to LRU while we commit it */
-	if (likely(!PageLRU(page)))
-		return;
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	lru = page_lru(page);
-	/*
-	 * If the page is not on the LRU, someone will soon put it
-	 * there.  If it is, and also already accounted for on the
-	 * memcg-side, it must be on the right lruvec as setting
-	 * pc->mem_cgroup and PageCgroupUsed is properly ordered.
-	 * Otherwise, root_mem_cgroup has been babysitting the page
-	 * during the charge.  Move it to the new memcg now.
-	 */
-	if (PageLRU(page) && !PageCgroupAcctLRU(pc)) {
-		del_page_from_lru_list(zone, page, lru);
-		add_page_to_lru_list(zone, page, lru);
-	}
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
-}
-
-/*
  * Checks whether given mem is same or in the root_mem_cgroup's
  * hierarchy subtree
  */
@@ -2777,14 +2697,27 @@ __mem_cgroup_commit_charge_lrucare(struc
 					enum charge_type ctype)
 {
 	struct page_cgroup *pc = lookup_page_cgroup(page);
+	struct zone *zone = page_zone(page);
+	unsigned long flags;
+	bool removed = false;
+
 	/*
 	 * In some case, SwapCache, FUSE(splice_buf->radixtree), the page
 	 * is already on LRU. It means the page may on some other page_cgroup's
 	 * LRU. Take care of it.
 	 */
-	mem_cgroup_lru_del_before_commit(page);
+	spin_lock_irqsave(&zone->lru_lock, flags);
+	if (PageLRU(page)) {
+		del_page_from_lru_list(zone, page, page_lru(page));
+		ClearPageLRU(page);
+		removed = true;
+	}
 	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype);
-	mem_cgroup_lru_add_after_commit(page);
+	if (removed) {
+		add_page_to_lru_list(zone, page, page_lru(page));
+		SetPageLRU(page);
+	}
+	spin_unlock_irqrestore(&zone->lru_lock, flags);
 	return;
 }
 
@@ -3385,9 +3318,7 @@ void mem_cgroup_replace_page_cache(struc
 {
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
-	struct zone *zone;
 	enum charge_type type = MEM_CGROUP_CHARGE_TYPE_CACHE;
-	unsigned long flags;
 
 	if (mem_cgroup_disabled())
 		return;
@@ -3403,20 +3334,12 @@ void mem_cgroup_replace_page_cache(struc
 	if (PageSwapBacked(oldpage))
 		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 
-	zone = page_zone(newpage);
-	pc = lookup_page_cgroup(newpage);
 	/*
 	 * Even if newpage->mapping was NULL before starting replacement,
 	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
 	 * LRU while we overwrite pc->mem_cgroup.
 	 */
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	if (PageLRU(newpage))
-		del_page_from_lru_list(zone, newpage, page_lru(newpage));
-	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, type);
-	if (PageLRU(newpage))
-		add_page_to_lru_list(zone, newpage, page_lru(newpage));
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
+	__mem_cgroup_commit_charge_lrucare(newpage, memcg, type);
 }
 
 #ifdef CONFIG_DEBUG_VM
_
Subject: Subject: memcg: simplify corner case handling of LRU.

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
memcg-keep-root-group-unchanged-if-creation-fails.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault-fix.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-simplify-find_vma_prev.patch
tracepoint-add-tracepoints-for-debugging-oom_score_adj.patch
mm-add-missing-mutex-lock-arround-notify_change.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch
documentation-cgroups-memorytxt-fix-typo.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-simplify-lru-handling-by-new-rule.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

