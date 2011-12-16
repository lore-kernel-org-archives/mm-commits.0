From: akpm@linux-foundation.org
Subject: + memcg-clear-pc-mem_cgorup-if-necessary-fix-2.patch added to -mm tree
Date: Fri, 16 Dec 2011 15:54:05 -0800
Message-ID: <20111216235405.A4CC110004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:47771 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1LPXyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 18:54:07 -0500
Received: by ghrr15 with SMTP id r15so178140ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 15:54:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mszeredi@suse.cz, yinghan@google.com


The patch titled
     Subject: memcg-clear-pc-mem_cgorup-if-necessary-fix-2
has been added to the -mm tree.  Its filename is
     memcg-clear-pc-mem_cgorup-if-necessary-fix-2.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: memcg-clear-pc-mem_cgorup-if-necessary-fix-2

Fix CONFIG_CGROUP_MEM_RES_CTLR=y CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n build:
move mem_cgroup_reset_owner() up from CONFIG_CGROUP_MEM_RES_CTLR_SWAP block.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~memcg-clear-pc-mem_cgorup-if-necessary-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clear-pc-mem_cgorup-if-necessary-fix-2
+++ a/mm/memcontrol.c
@@ -3052,6 +3052,20 @@ void mem_cgroup_uncharge_end(void)
 	batch->memcg = NULL;
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
 #ifdef CONFIG_SWAP
 /*
  * called after __delete_from_swap_cache() and drop "page" account.
@@ -3106,20 +3120,6 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	rcu_read_unlock();
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
-	pc = lookup_page_cgroup(newpage);
-	VM_BUG_ON(PageCgroupUsed(pc));
-	pc->mem_cgroup = root_mem_cgroup;
-}
-
 /**
  * mem_cgroup_move_swap_account - move swap charge and swap_cgroup's record.
  * @entry: swap entry to be moved
_
Subject: Subject: memcg-clear-pc-mem_cgorup-if-necessary-fix-2

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
memcg-keep-root-group-unchanged-if-creation-fails.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch
mm-simplify-find_vma_prev.patch
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
memcg-simplify-lru-handling-by-new-rule.patch
procfs-add-hidepid=-and-gid=-mount-options-fix.patch
radix_tree-remove-radix_tree_indirect_to_ptr.patch
prio_tree-debugging-patch.patch

