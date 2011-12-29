From: akpm@linux-foundation.org
Subject: + memcg-fix-mem_cgroup_print_bad_page.patch added to -mm tree
Date: Thu, 29 Dec 2011 14:44:40 -0800
Message-ID: <20111229224441.8ED6120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:48343 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab1L2Woo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2011 17:44:44 -0500
Received: by eekc1 with SMTP id c1so457523eek.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2011 14:44:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp


The patch titled
     Subject: memcg: fix mem_cgroup_print_bad_page
has been added to the -mm tree.  Its filename is
     memcg-fix-mem_cgroup_print_bad_page.patch

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
Subject: memcg: fix mem_cgroup_print_bad_page

If DEBUG_VM, mem_cgroup_print_bad_page() is called whenever bad_page()
shows a "Bad page state" message, removes page from circulation, adds a
taint and continues.  This is at a very low level, often when a spinlock
is held (sometimes when page table lock is held, for example).

We want to recover from this badness, not make it worse: we must not
kmalloc memory here, we must not do a cgroup path lookup via dubious
pointers.  No doubt that code was useful to debug a particular case at one
time, and may be again, but take it out of the mainline kernel.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-mem_cgroup_print_bad_page mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-mem_cgroup_print_bad_page
+++ a/mm/memcontrol.c
@@ -3355,23 +3355,8 @@ void mem_cgroup_print_bad_page(struct pa
 
 	pc = lookup_page_cgroup_used(page);
 	if (pc) {
-		int ret = -1;
-		char *path;
-
-		printk(KERN_ALERT "pc:%p pc->flags:%lx pc->mem_cgroup:%p",
+		printk(KERN_ALERT "pc:%p pc->flags:%lx pc->mem_cgroup:%p\n",
 		       pc, pc->flags, pc->mem_cgroup);
-
-		path = kmalloc(PATH_MAX, GFP_KERNEL);
-		if (path) {
-			rcu_read_lock();
-			ret = cgroup_path(pc->mem_cgroup->css.cgroup,
-							path, PATH_MAX);
-			rcu_read_unlock();
-		}
-
-		printk(KERN_CONT "(%s)\n",
-				(ret < 0) ? "cannot get the path" : path);
-		kfree(path);
 	}
 }
 #endif
_
Subject: Subject: memcg: fix mem_cgroup_print_bad_page

Patches currently in -mm which might be from hughd@google.com are

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
memcg-clear-pc-mem_cgorup-if-necessary-fix-3.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-page-migration-to-reset_owner.patch
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix-null-mem_cgroup_try_charge.patch
memcg-fix-split_huge_page_refcounts.patch
memcg-fix-mem_cgroup_print_bad_page.patch
procfs-add-hidepid=-and-gid=-mount-options-fix.patch
radix_tree-remove-radix_tree_indirect_to_ptr.patch
radix_tree-take-radix_tree_path-off-stack.patch
radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch
prio_tree-debugging-patch.patch

