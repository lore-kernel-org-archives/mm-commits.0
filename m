From: akpm@linux-foundation.org
Subject: + oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch added to -mm tree
Date: Fri, 21 Sep 2007 02:11:11 -0700
Message-ID: <200709210911.l8L9BBZa028216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953AbXIUJLU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 05:11:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com


The patch titled
     oom: compare cpuset mems_allowed instead of exclusive  ancestors
has been added to the -mm tree.  Its filename is
     oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oom: compare cpuset mems_allowed instead of exclusive  ancestors
From: David Rientjes <rientjes@google.com>

Instead of testing for overlap in the memory nodes of the the nearest
exclusive ancestor of both current and the candidate task, it is better to
simply test for intersection between the task's mems_allowed in their task
descriptors.  This does not require taking callback_mutex since it is only
used as a hint in the badness scoring.

Tasks that do not have an intersection in their mems_allowed with the current
task are not explicitly restricted from being OOM killed because it is quite
possible that the candidate task has allocated memory there before and has
since changed its mems_allowed.

Cc: Andrea Arcangeli <andrea@suse.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    6 +++--
 kernel/cpuset.c        |   41 +++++++++------------------------------
 mm/oom_kill.c          |    2 -
 3 files changed, 15 insertions(+), 34 deletions(-)

diff -puN include/linux/cpuset.h~oom-compare-cpuset-mems_allowed-instead-of-exclusive include/linux/cpuset.h
--- a/include/linux/cpuset.h~oom-compare-cpuset-mems_allowed-instead-of-exclusive
+++ a/include/linux/cpuset.h
@@ -45,7 +45,8 @@ static int inline cpuset_zone_allowed_ha
 		__cpuset_zone_allowed_hardwall(z, gfp_mask);
 }
 
-extern int cpuset_excl_nodes_overlap(const struct task_struct *p);
+extern int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
+					  const struct task_struct *tsk2);
 
 #define cpuset_memory_pressure_bump() 				\
 	do {							\
@@ -113,7 +114,8 @@ static inline int cpuset_zone_allowed_ha
 	return 1;
 }
 
-static inline int cpuset_excl_nodes_overlap(const struct task_struct *p)
+static inline int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
+						 const struct task_struct *tsk2)
 {
 	return 1;
 }
diff -puN kernel/cpuset.c~oom-compare-cpuset-mems_allowed-instead-of-exclusive kernel/cpuset.c
--- a/kernel/cpuset.c~oom-compare-cpuset-mems_allowed-instead-of-exclusive
+++ a/kernel/cpuset.c
@@ -2586,41 +2586,20 @@ int cpuset_mem_spread_node(void)
 EXPORT_SYMBOL_GPL(cpuset_mem_spread_node);
 
 /**
- * cpuset_excl_nodes_overlap - Do we overlap @p's mem_exclusive ancestors?
- * @p: pointer to task_struct of some other task.
+ * cpuset_mems_allowed_intersects - Does @tsk1's mems_allowed intersect @tsk2's?
+ * @tsk1: pointer to task_struct of some task.
+ * @tsk2: pointer to task_struct of some other task.
  *
- * Description: Return true if the nearest mem_exclusive ancestor
- * cpusets of tasks @p and current overlap.  Used by oom killer to
- * determine if task @p's memory usage might impact the memory
- * available to the current task.
- *
- * Call while holding callback_mutex.
+ * Description: Return true if @tsk1's mems_allowed intersects the
+ * mems_allowed of @tsk2.  Used by the OOM killer to determine if
+ * one of the task's memory usage might impact the memory available
+ * to the other.
  **/
 
-int cpuset_excl_nodes_overlap(const struct task_struct *p)
+int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
+				   const struct task_struct *tsk2)
 {
-	const struct cpuset *cs1, *cs2;	/* my and p's cpuset ancestors */
-	int overlap = 1;		/* do cpusets overlap? */
-
-	task_lock(current);
-	if (current->flags & PF_EXITING) {
-		task_unlock(current);
-		goto done;
-	}
-	cs1 = nearest_exclusive_ancestor(current->cpuset);
-	task_unlock(current);
-
-	task_lock((struct task_struct *)p);
-	if (p->flags & PF_EXITING) {
-		task_unlock((struct task_struct *)p);
-		goto done;
-	}
-	cs2 = nearest_exclusive_ancestor(p->cpuset);
-	task_unlock((struct task_struct *)p);
-
-	overlap = nodes_intersects(cs1->mems_allowed, cs2->mems_allowed);
-done:
-	return overlap;
+	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
 }
 
 /*
diff -puN mm/oom_kill.c~oom-compare-cpuset-mems_allowed-instead-of-exclusive mm/oom_kill.c
--- a/mm/oom_kill.c~oom-compare-cpuset-mems_allowed-instead-of-exclusive
+++ a/mm/oom_kill.c
@@ -143,7 +143,7 @@ unsigned long badness(struct task_struct
 	 * because p may have allocated or otherwise mapped memory on
 	 * this node before. However it will be less likely.
 	 */
-	if (!cpuset_excl_nodes_overlap(p))
+	if (!cpuset_mems_allowed_intersects(current, p))
 		points /= 8;
 
 	/*
_

Patches currently in -mm which might be from rientjes@google.com are

maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
