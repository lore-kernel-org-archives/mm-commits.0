From: akpm@linux-foundation.org
Subject: [merged] cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch removed from -mm tree
Date: Wed, 28 Dec 2011 14:04:25 -0800
Message-ID: <20111228220426.14C73200083@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51712 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1L1WE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2011 17:04:28 -0500
Received: by eaak10 with SMTP id k10so176839eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2011 14:04:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, miaox@cn.fujitsu.com, paul@paulmenage.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: cpusets: stall when updating mems_allowed for mempolicy or disjoint nodemask
has been removed from the -mm tree.  Its filename was
     cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: cpusets: stall when updating mems_allowed for mempolicy or disjoint nodemask

Kernels where MAX_NUMNODES > BITS_PER_LONG may temporarily see an empty
nodemask in a tsk's mempolicy if its previous nodemask is remapped onto a
new set of allowed cpuset nodes where the two nodemasks, as a result of
the remap, are now disjoint.

c0ff7453bb5c ("cpuset,mm: fix no node to alloc memory when changing
cpuset's mems") adds get_mems_allowed() to prevent the set of allowed
nodes from changing for a thread.  This causes any update to a set of
allowed nodes to stall until put_mems_allowed() is called.

This stall is unncessary, however, if at least one node remains unchanged
in the update to the set of allowed nodes.  This was addressed by
89e8a244b97e ("cpusets: avoid looping when storing to mems_allowed if one
node remains set"), but it's still possible that an empty nodemask may be
read from a mempolicy because the old nodemask may be remapped to the new
nodemask during rebind.  To prevent this, only avoid the stall if there is
no mempolicy for the thread being changed.

This is a temporary solution until all reads from mempolicy nodemasks can
be guaranteed to not be empty without the get_mems_allowed()
synchronization.

Also moves the check for nodemask intersection inside task_lock() so that
tsk->mems_allowed cannot change.  This ensures that nothing can set this
tsk's mems_allowed out from under us and also protects tsk->mempolicy.

Reported-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff -puN kernel/cpuset.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-stall-when-updating-mems_allowed-for-mempolicy-or-disjoint-nodemask
+++ a/kernel/cpuset.c
@@ -123,6 +123,19 @@ static inline struct cpuset *task_cs(str
 			    struct cpuset, css);
 }
 
+#ifdef CONFIG_NUMA
+static inline bool task_has_mempolicy(struct task_struct *task)
+{
+	return task->mempolicy;
+}
+#else
+static inline bool task_has_mempolicy(struct task_struct *task)
+{
+	return false;
+}
+#endif
+
+
 /* bits in struct cpuset flags field */
 typedef enum {
 	CS_CPU_EXCLUSIVE,
@@ -949,7 +962,7 @@ static void cpuset_migrate_mm(struct mm_
 static void cpuset_change_task_nodemask(struct task_struct *tsk,
 					nodemask_t *newmems)
 {
-	bool masks_disjoint = !nodes_intersects(*newmems, tsk->mems_allowed);
+	bool need_loop;
 
 repeat:
 	/*
@@ -962,6 +975,14 @@ repeat:
 		return;
 
 	task_lock(tsk);
+	/*
+	 * Determine if a loop is necessary if another thread is doing
+	 * get_mems_allowed().  If at least one node remains unchanged and
+	 * tsk does not have a mempolicy, then an empty nodemask will not be
+	 * possible when mems_allowed is larger than a word.
+	 */
+	need_loop = task_has_mempolicy(tsk) ||
+			!nodes_intersects(*newmems, tsk->mems_allowed);
 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
 	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
 
@@ -981,11 +1002,9 @@ repeat:
 
 	/*
 	 * Allocation of memory is very fast, we needn't sleep when waiting
-	 * for the read-side.  No wait is necessary, however, if at least one
-	 * node remains unchanged.
+	 * for the read-side.
 	 */
-	while (masks_disjoint &&
-			ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
+	while (need_loop && ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
 		task_unlock(tsk);
 		if (!task_curr(tsk))
 			yield();
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0.patch
slub-document-setting-min-order-with-debug_guardpage_minorder-0-checkpatch-fixes.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
kernelh-add-build_bug-macro.patch
kernelh-add-build_bug-macro-v3.patch
mm-debug-test-for-online-nid-when-allocating-on-single-node.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
tracepoint-add-tracepoints-for-debugging-oom_score_adj.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mm-mempolicyc-mpol_equal-use-bool.patch
cpusets-cgroups-disallow-attaching-kthreadd.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch

