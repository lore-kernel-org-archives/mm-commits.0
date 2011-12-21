From: akpm@linux-foundation.org
Subject: + mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch added to -mm tree
Date: Wed, 21 Dec 2011 15:53:33 -0800
Message-ID: <20111221235334.2C88C1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:43241 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1LUXxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2011 18:53:35 -0500
Received: by ggnv2 with SMTP id v2so1006708ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2011 15:53:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm-memcg-lookup_page_cgroup-almost-never-returns-null fix
has been added to the -mm tree.  Its filename is
     mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm-memcg-lookup_page_cgroup-almost-never-returns-null fix

lookup_page_cgroup() returns NULL (or may return NULL) when
mem_cgroup_disabled(): stop oops in mem_cgroup_update_page_stat().  Let's
make it explicit for now, probably optimize such checks later.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix
+++ a/mm/memcontrol.c
@@ -1965,6 +1965,9 @@ void mem_cgroup_update_page_stat(struct 
 	bool need_unlock = false;
 	unsigned long uninitialized_var(flags);
 
+	if (mem_cgroup_disabled())
+		return;
+
 	rcu_read_lock();
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
@@ -3438,7 +3441,8 @@ static struct page_cgroup *lookup_page_c
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
Subject: Subject: mm-memcg-lookup_page_cgroup-almost-never-returns-null fix

Patches currently in -mm which might be from hughd@google.com are

origin.patch
vfs-__read_cache_page-should-use-gfp-argument-rather-than-gfp_kernel.patch
linux-next.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch
mm-simplify-find_vma_prev.patch
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
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch
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
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix.patch
radix_tree-remove-radix_tree_indirect_to_ptr.patch
radix_tree-take-radix_tree_path-off-stack.patch
prio_tree-debugging-patch.patch

