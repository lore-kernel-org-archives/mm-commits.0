From: akpm@linux-foundation.org
Subject: + memcg-clear-pc-mem_cgorup-if-necessary.patch added to -mm tree
Date: Fri, 16 Dec 2011 14:31:22 -0800
Message-ID: <20111216223123.5C56210004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40106 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760919Ab1LPWbY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 17:31:24 -0500
Received: by yenm5 with SMTP id m5so459911yen.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 14:31:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mszeredi@suse.cz, yinghan@google.com


The patch titled
     Subject: memcg: clear pc->mem_cgorup if necessary.
has been added to the -mm tree.  Its filename is
     memcg-clear-pc-mem_cgorup-if-necessary.patch

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
Subject: memcg: clear pc->mem_cgorup if necessary.

This is a preparation before removing a flag PCG_ACCT_LRU in page_cgroup
and reducing atomic ops/complexity in memcg LRU handling.

In some cases, pages are added to lru before charge to memcg and pages are
not classfied to memory cgroup at lru addtion.  Now, the lru where the
page should be added is determined a bit in page_cgroup->flags and
pc->mem_cgroup.  I'd like to remove the check of flag.

To handle the case pc->mem_cgroup may contain stale pointers if pages are
added to LRU before classification.  This patch resets pc->mem_cgroup to
root_mem_cgroup before lru additions.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ying Han <yinghan@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++++
 mm/ksm.c                   |    1 +
 mm/memcontrol.c            |   14 ++++++++++++++
 mm/swap_state.c            |    1 +
 4 files changed, 21 insertions(+)

diff -puN include/linux/memcontrol.h~memcg-clear-pc-mem_cgorup-if-necessary include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-clear-pc-mem_cgorup-if-necessary
+++ a/include/linux/memcontrol.h
@@ -129,6 +129,7 @@ extern void mem_cgroup_print_oom_info(st
 extern void mem_cgroup_replace_page_cache(struct page *oldpage,
 					struct page *newpage);
 
+extern void mem_cgroup_reset_owner(struct page *page);
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif
@@ -391,6 +392,10 @@ static inline void mem_cgroup_replace_pa
 				struct page *newpage)
 {
 }
+
+static inline void mem_cgroup_reset_owner(struct page *page);
+{
+}
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #if !defined(CONFIG_CGROUP_MEM_RES_CTLR) || !defined(CONFIG_DEBUG_VM)
diff -puN mm/ksm.c~memcg-clear-pc-mem_cgorup-if-necessary mm/ksm.c
--- a/mm/ksm.c~memcg-clear-pc-mem_cgorup-if-necessary
+++ a/mm/ksm.c
@@ -1571,6 +1571,7 @@ struct page *ksm_does_need_to_copy(struc
 
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 	if (new_page) {
+		mem_cgroup_reset_owner(new_page);
 		copy_user_highpage(new_page, page, address, vma);
 
 		SetPageDirty(new_page);
diff -puN mm/memcontrol.c~memcg-clear-pc-mem_cgorup-if-necessary mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clear-pc-mem_cgorup-if-necessary
+++ a/mm/memcontrol.c
@@ -3106,6 +3106,20 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	rcu_read_unlock();
 }
 
+/*
+ * A function for resetting pc->mem_cgroup for newly allocated pages.
+ * This function should be called if the newpage will be added to LRU
+ * before start accounting.
+ */
+void mem_cgroup_reset_owner(struct page *newpage)
+{
+	struct page_cgroup *pc;
+
+	pc = lookup_page_cgroup(newpage);
+	VM_BUG_ON(PageCgroupUsed(pc));
+	pc->mem_cgroup = root_mem_cgroup;
+}
+
 /**
  * mem_cgroup_move_swap_account - move swap charge and swap_cgroup's record.
  * @entry: swap entry to be moved
diff -puN mm/swap_state.c~memcg-clear-pc-mem_cgorup-if-necessary mm/swap_state.c
--- a/mm/swap_state.c~memcg-clear-pc-mem_cgorup-if-necessary
+++ a/mm/swap_state.c
@@ -301,6 +301,7 @@ struct page *read_swap_cache_async(swp_e
 			new_page = alloc_page_vma(gfp_mask, vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
+			mem_cgroup_reset_owner(new_page);
 		}
 
 		/*
_
Subject: Subject: memcg: clear pc->mem_cgorup if necessary.

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

