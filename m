From: akpm@linux-foundation.org
Subject: [folded] mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:47:17 -0800
Message-ID: <20120113004718.1AC661E005A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58814 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab2AMArT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:47:19 -0500
Received: by ghrr18 with SMTP id r18so123345ghr.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:47:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-lookup_page_cgroup-almost-never-returns-null fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch

This patch was dropped because it was folded into mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm-memcg-lookup_page_cgroup-almost-never-returns-null fix

lookup_page_cgroup() returns NULL (or may return NULL) when
mem_cgroup_disabled(): stop oops in mem_cgroup_update_page_stat().  Let's
make it explicit for now, probably optimize such checks later.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix
+++ a/mm/memcontrol.c
@@ -1960,6 +1960,9 @@ void mem_cgroup_update_page_stat(struct 
 	bool need_unlock = false;
 	unsigned long uninitialized_var(flags);
 
+	if (mem_cgroup_disabled())
+		return;
+
 	rcu_read_lock();
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
@@ -3433,7 +3436,8 @@ static struct page_cgroup *lookup_page_c
 	pc = lookup_page_cgroup(page);
 	/*
 	 * Can be NULL while feeding pages into the page allocator for
-	 * the first time, i.e. during boot or memory hotplug.
+	 * the first time, i.e. during boot or memory hotplug;
+	 * or when mem_cgroup_disabled().
 	 */
 	if (likely(pc) && PageCgroupUsed(pc))
 		return pc;
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
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
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-3.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-page-migration-to-reset_owner.patch
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix-null-mem_cgroup_try_charge.patch
memcg-fix-split_huge_page_refcounts.patch
memcg-fix-mem_cgroup_print_bad_page.patch
mm-take-pagevecs-off-reclaim-stack.patch
mm-fewer-underscores-in-____pagevec_lru_add.patch
mm-no-blank-line-after-export_symbol-in-swapc.patch
mm-enum-lru_list-lru.patch
mm-remove-del_page_from_lru-add-page_off_lru.patch
mm-remove-isolate_pages.patch
mm-rearrange-putback_inactive_pages.patch
radix_tree-remove-radix_tree_indirect_to_ptr.patch
radix_tree-take-radix_tree_path-off-stack.patch
radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch

