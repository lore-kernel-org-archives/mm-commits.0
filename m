From: akpm@linux-foundation.org
Subject: + memcg-simplify-lru-handling-by-new-rule.patch added to -mm tree
Date: Fri, 16 Dec 2011 14:31:28 -0800
Message-ID: <20111216223129.6953310004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:50979 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760907Ab1LPWba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 17:31:30 -0500
Received: by ghrr15 with SMTP id r15so169231ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 14:31:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mszeredi@suse.cz, yinghan@google.com


The patch titled
     Subject: memcg: simplify LRU handling by new rule
has been added to the -mm tree.  Its filename is
     memcg-simplify-lru-handling-by-new-rule.patch

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
Subject: memcg: simplify LRU handling by new rule

Now, at LRU handling, memory cgroup needs to do complicated works to see
valid pc->mem_cgroup, which may be overwritten.

This patch is for relaxing the protocol. This patch guarantees
   - when pc->mem_cgroup is overwritten, page must not be on LRU.

By this, LRU routine can believe pc->mem_cgroup and don't need to check
bits on pc->flags.  This new rule may adds small overheads to swapin.  But
in most case, lru handling gets faster.

After this patch, PCG_ACCT_LRU bit is obsolete and removed.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ying Han <yinghan@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    8 ---
 mm/memcontrol.c             |   72 ++++++++--------------------------
 2 files changed, 17 insertions(+), 63 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-simplify-lru-handling-by-new-rule include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-simplify-lru-handling-by-new-rule
+++ a/include/linux/page_cgroup.h
@@ -10,8 +10,6 @@ enum {
 	/* flags for mem_cgroup and file and I/O status */
 	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
 	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
-	/* No lock in page_cgroup */
-	PCG_ACCT_LRU, /* page has been accounted for (under lru_lock) */
 	__NR_PCG_FLAGS,
 };
 
@@ -75,12 +73,6 @@ TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
 SETPCGFLAG(Used, USED)
 
-SETPCGFLAG(AcctLRU, ACCT_LRU)
-CLEARPCGFLAG(AcctLRU, ACCT_LRU)
-TESTPCGFLAG(AcctLRU, ACCT_LRU)
-TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
-
-
 SETPCGFLAG(FileMapped, FILE_MAPPED)
 CLEARPCGFLAG(FileMapped, FILE_MAPPED)
 TESTPCGFLAG(FileMapped, FILE_MAPPED)
diff -puN mm/memcontrol.c~memcg-simplify-lru-handling-by-new-rule mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-lru-handling-by-new-rule
+++ a/mm/memcontrol.c
@@ -1045,30 +1045,8 @@ struct lruvec *mem_cgroup_lru_add_list(s
 		return &zone->lruvec;
 
 	pc = lookup_page_cgroup(page);
-	VM_BUG_ON(PageCgroupAcctLRU(pc));
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
-	/*
-	 * If the page is uncharged, it may be freed soon, but it
-	 * could also be swap cache (readahead, swapoff) that needs to
-	 * be reclaimable in the future.  root_mem_cgroup will babysit
-	 * it for the time being.
-	 */
-	if (PageCgroupUsed(pc)) {
-		/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
-		smp_rmb();
-		memcg = pc->mem_cgroup;
-		SetPageCgroupAcctLRU(pc);
-	} else
-		memcg = root_mem_cgroup;
+	memcg = pc->mem_cgroup;
+	VM_BUG_ON(!memcg);
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* compound_order() is stabilized through lru_lock */
 	MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
@@ -1095,18 +1073,8 @@ void mem_cgroup_lru_del_list(struct page
 		return;
 
 	pc = lookup_page_cgroup(page);
-	/*
-	 * root_mem_cgroup babysits uncharged LRU pages, but
-	 * PageCgroupUsed is cleared when the page is about to get
-	 * freed.  PageCgroupAcctLRU remembers whether the
-	 * LRU-accounting happened against pc->mem_cgroup or
-	 * root_mem_cgroup.
-	 */
-	if (TestClearPageCgroupAcctLRU(pc)) {
-		VM_BUG_ON(!pc->mem_cgroup);
-		memcg = pc->mem_cgroup;
-	} else
-		memcg = root_mem_cgroup;
+	memcg = pc->mem_cgroup;
+	VM_BUG_ON(!memcg);
 	mz = page_cgroup_zoneinfo(memcg, page);
 	/* huge page split is done under lru_lock. so, we have no races. */
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
@@ -2459,6 +2427,7 @@ static void __mem_cgroup_commit_charge(s
 
 	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), nr_pages);
 	unlock_page_cgroup(pc);
+	WARN_ON_ONCE(PageLRU(page));
 	/*
 	 * "charge_statistics" updated event counter. Then, check it.
 	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
@@ -2470,7 +2439,7 @@ static void __mem_cgroup_commit_charge(s
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 #define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MOVE_LOCK) |\
-			(1 << PCG_ACCT_LRU) | (1 << PCG_MIGRATION))
+			(1 << PCG_MIGRATION))
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compound_lock.
@@ -2481,6 +2450,8 @@ void mem_cgroup_split_huge_fixup(struct 
 {
 	struct page_cgroup *head_pc = lookup_page_cgroup(head);
 	struct page_cgroup *pc;
+	struct mem_cgroup_per_zone *mz;
+	enum lru_list lru;
 	int i;
 
 	if (mem_cgroup_disabled())
@@ -2489,23 +2460,15 @@ void mem_cgroup_split_huge_fixup(struct 
 		pc = head_pc + i;
 		pc->mem_cgroup = head_pc->mem_cgroup;
 		smp_wmb();/* see __commit_charge() */
-		/*
-		 * LRU flags cannot be copied because we need to add tail
-		 * page to LRU by generic call and our hooks will be called.
-		 */
 		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
 	}
-
-	if (PageCgroupAcctLRU(head_pc)) {
-		enum lru_list lru;
-		struct mem_cgroup_per_zone *mz;
-		/*
-		 * We hold lru_lock, then, reduce counter directly.
-		 */
-		lru = page_lru(head);
-		mz = page_cgroup_zoneinfo(head_pc->mem_cgroup, head);
-		MEM_CGROUP_ZSTAT(mz, lru) -= HPAGE_PMD_NR - 1;
-	}
+	/*
+	 * Tail pages will be added to LRU.
+	 * We hold lru_lock,then,reduce counter directly.
+	 */
+	lru = page_lru(head);
+	mz = page_cgroup_zoneinfo(head_pc->mem_cgroup, head);
+	MEM_CGROUP_ZSTAT(mz, lru) -= HPAGE_PMD_NR - 1;
 }
 #endif
 
@@ -2738,10 +2701,9 @@ int mem_cgroup_cache_charge(struct page 
 	if (!page_is_file_cache(page))
 		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 
-	if (!PageSwapCache(page)) {
+	if (!PageSwapCache(page))
 		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
-		WARN_ON_ONCE(PageLRU(page));
-	} else { /* page is swapcache/shmem */
+	else { /* page is swapcache/shmem */
 		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &memcg);
 		if (!ret)
 			__mem_cgroup_commit_charge_swapin(page, memcg, type);
_
Subject: Subject: memcg: simplify LRU handling by new rule

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

