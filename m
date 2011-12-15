From: akpm@linux-foundation.org
Subject: + oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch added to -mm tree
Date: Thu, 15 Dec 2011 14:12:55 -0800
Message-ID: <20111215221256.313665C0070@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:33081 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1LOWM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2011 17:12:59 -0500
Received: by eaad1 with SMTP id d1so73049eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2011 14:12:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, bsingharora@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: oom, memcg: fix exclusion of memcg threads after they have detached their mm
has been added to the -mm tree.  Its filename is
     oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch

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
From: David Rientjes <rientjes@google.com>
Subject: oom, memcg: fix exclusion of memcg threads after they have detached their mm

The oom killer relies on logic that identifies threads that have already
been oom killed when scanning the tasklist and, if found, deferring until
such threads have exited.  This is done by checking for any candidate
threads that have the TIF_MEMDIE bit set.

For memcg ooms, candidate threads are first found by calling
task_in_mem_cgroup() since the oom killer should not defer if there's an
oom killed thread in another memcg.

Unfortunately, task_in_mem_cgroup() excludes threads if they have detached
their mm in the process of exiting so TIF_MEMDIE is never detected for
such conditions.  This is different for global, mempolicy, and cpuset oom
conditions where a detached mm is only excluded after checking for
TIF_MEMDIE and deferring, if necessary, in select_bad_process().

The fix is to return true if a task has a detached mm but is still in the
memcg or its hierarchy that is currently oom.  This will allow the oom
killer to appropriately defer rather than kill unnecessarily or, in the
worst case, panic the machine if nothing else is available to kill.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm mm/memcontrol.c
--- a/mm/memcontrol.c~oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm
+++ a/mm/memcontrol.c
@@ -1243,10 +1243,21 @@ int task_in_mem_cgroup(struct task_struc
 	struct task_struct *p;
 
 	p = find_lock_task_mm(task);
-	if (!p)
-		return 0;
-	curr = try_get_mem_cgroup_from_mm(p->mm);
-	task_unlock(p);
+	if (p) {
+		curr = try_get_mem_cgroup_from_mm(p->mm);
+		task_unlock(p);
+	} else {
+		/*
+		 * All threads may have already detached their mm's, but the oom
+		 * killer still needs to detect if they have already been oom
+		 * killed to prevent needlessly killing additional tasks.
+		 */
+		task_lock(task);
+		curr = mem_cgroup_from_task(task);
+		if (curr)
+			css_get(&curr->css);
+		task_unlock(task);
+	}
 	if (!curr)
 		return 0;
 	/*
_
Subject: Subject: oom, memcg: fix exclusion of memcg threads after they have detached their mm

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix.patch
memcg-keep-root-group-unchanged-if-creation-fails.patch
oom-fix-integer-overflow-of-points-in-oom_badness.patch
vmalloc-remove-static-declaration-of-va-from-__get_vm_area_node.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
kernelh-add-build_bug-macro.patch
kernelh-add-build_bug-macro-v3.patch
hugetlb-replace-bug-with-build_bug-for-dummy-definitions.patch
mm-debug-test-for-online-nid-when-allocating-on-single-node.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
tracepoint-add-tracepoints-for-debugging-oom_score_adj.patch
cpusets-cgroups-disallow-attaching-kthreadd.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch

