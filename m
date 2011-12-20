From: akpm@linux-foundation.org
Subject: [folded] cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2.patch removed from -mm tree
Date: Mon, 19 Dec 2011 17:07:46 -0800
Message-ID: <20111220010747.58D7210005D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:36016 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1LTBHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2011 20:07:48 -0500
Received: by yenm5 with SMTP id m5so837171yen.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Dec 2011 17:07:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, miaox@cn.fujitsu.com, paul@paulmenage.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2
has been removed from the -mm tree.  Its filename was
     cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2.patch

This patch was dropped because it was folded into cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2

Here's a cleaner way of doing it, we can extend it to mm/slab.c later.
Please fold into
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |   10 ++++++++++
 kernel/cpuset.c           |    5 +----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff -puN include/linux/mempolicy.h~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2 include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2
+++ a/include/linux/mempolicy.h
@@ -253,6 +253,11 @@ static inline int vma_migratable(struct 
 	return 1;
 }
 
+static inline bool task_has_mempolicy(struct task_struct *task)
+{
+	return task->mempolicy;
+}
+
 #else
 
 struct mempolicy {};
@@ -379,6 +384,11 @@ static inline int mpol_to_str(char *buff
 	return 0;
 }
 
+static inline bool task_has_mempolicy(struct task_struct *task)
+{
+	return false;
+}
+
 #endif /* CONFIG_NUMA */
 #endif /* __KERNEL__ */
 
diff -puN kernel/cpuset.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2 kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2
+++ a/kernel/cpuset.c
@@ -968,10 +968,7 @@ repeat:
 	 * tsk does not have a mempolicy, then an empty nodemask will not be
 	 * possible when mems_allowed is larger than a word.
 	 */
-	need_loop =
-#ifdef CONFIG_NUMA
-		tsk->mempolicy ||
-#endif
+	need_loop = task_has_mempolicy(tsk) ||
 			!nodes_intersects(*newmems, tsk->mems_allowed);
 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
 	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
_

Patches currently in -mm which might be from rientjes@google.com are

cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2.patch
cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask-fix-2-fix-2-fix.patch
memcg-keep-root-group-unchanged-if-creation-fails.patch
oom-fix-integer-overflow-of-points-in-oom_badness.patch
vmalloc-remove-static-declaration-of-va-from-__get_vm_area_node.patch
linux-next.patch
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

