From: akpm@linux-foundation.org
Subject: + oom-filter-unkillable-tasks-from-tasklist-dump.patch added to -mm tree
Date: Wed, 15 Sep 2010 19:16:36 -0700
Message-ID: <201009160210.o8G2A5Oi028141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800Ab0IPCKP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Sep 2010 22:10:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     oom: filter unkillable tasks from tasklist dump
has been added to the -mm tree.  Its filename is
     oom-filter-unkillable-tasks-from-tasklist-dump.patch

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
Subject: oom: filter unkillable tasks from tasklist dump
From: David Rientjes <rientjes@google.com>

/proc/sys/vm/oom_dump_tasks is enabled by default, so it's necessary to
limit as much information as possible that it should emit.

The tasklist dump should be filtered to only those tasks that are eligible
for oom kill.  This is already done for memcg ooms, but this patch extends
it to both cpuset and mempolicy ooms as well as init.

In addition to suppressing irrelevant information, this also reduces
confusion since users currently don't know which tasks in the tasklist
aren't eligible for kill (such as those attached to cpusets or bound to
mempolicies with a disjoint set of mems or nodes, respectively) since that
information is not shown.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff -puN mm/oom_kill.c~oom-filter-unkillable-tasks-from-tasklist-dump mm/oom_kill.c
--- a/mm/oom_kill.c~oom-filter-unkillable-tasks-from-tasklist-dump
+++ a/mm/oom_kill.c
@@ -121,8 +121,8 @@ struct task_struct *find_lock_task_mm(st
 }
 
 /* return true if the task is not adequate as candidate victim task. */
-static bool oom_unkillable_task(struct task_struct *p, struct mem_cgroup *mem,
-			   const nodemask_t *nodemask)
+static bool oom_unkillable_task(struct task_struct *p,
+		const struct mem_cgroup *mem, const nodemask_t *nodemask)
 {
 	if (is_global_init(p))
 		return true;
@@ -344,26 +344,24 @@ static struct task_struct *select_bad_pr
 /**
  * dump_tasks - dump current memory state of all system tasks
  * @mem: current's memory controller, if constrained
+ * @nodemask: nodemask passed to page allocator for mempolicy ooms
  *
- * Dumps the current memory state of all system tasks, excluding kernel threads.
+ * Dumps the current memory state of all eligible tasks.  Tasks not in the same
+ * memcg, not in the same cpuset, or bound to a disjoint set of mempolicy nodes
+ * are not shown.
  * State information includes task's pid, uid, tgid, vm size, rss, cpu, oom_adj
  * value, oom_score_adj value, and name.
  *
- * If the actual is non-NULL, only tasks that are a member of the mem_cgroup are
- * shown.
- *
  * Call with tasklist_lock read-locked.
  */
-static void dump_tasks(const struct mem_cgroup *mem)
+static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *nodemask)
 {
 	struct task_struct *p;
 	struct task_struct *task;
 
 	pr_info("[ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name\n");
 	for_each_process(p) {
-		if (p->flags & PF_KTHREAD)
-			continue;
-		if (mem && !task_in_mem_cgroup(p, mem))
+		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
 
 		task = find_lock_task_mm(p);
@@ -386,7 +384,7 @@ static void dump_tasks(const struct mem_
 }
 
 static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
-							struct mem_cgroup *mem)
+			struct mem_cgroup *mem, const nodemask_t *nodemask)
 {
 	task_lock(current);
 	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
@@ -399,7 +397,7 @@ static void dump_header(struct task_stru
 	mem_cgroup_print_oom_info(mem, p);
 	show_mem();
 	if (sysctl_oom_dump_tasks)
-		dump_tasks(mem);
+		dump_tasks(mem, nodemask);
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
@@ -441,7 +439,7 @@ static int oom_kill_process(struct task_
 	unsigned int victim_points = 0;
 
 	if (printk_ratelimit())
-		dump_header(p, gfp_mask, order, mem);
+		dump_header(p, gfp_mask, order, mem, nodemask);
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
@@ -487,7 +485,7 @@ static int oom_kill_process(struct task_
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
 static void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
-				int order)
+				int order, const nodemask_t *nodemask)
 {
 	if (likely(!sysctl_panic_on_oom))
 		return;
@@ -501,7 +499,7 @@ static void check_panic_on_oom(enum oom_
 			return;
 	}
 	read_lock(&tasklist_lock);
-	dump_header(NULL, gfp_mask, order, NULL);
+	dump_header(NULL, gfp_mask, order, NULL, nodemask);
 	read_unlock(&tasklist_lock);
 	panic("Out of memory: %s panic_on_oom is enabled\n",
 		sysctl_panic_on_oom == 2 ? "compulsory" : "system-wide");
@@ -514,7 +512,7 @@ void mem_cgroup_out_of_memory(struct mem
 	unsigned int points = 0;
 	struct task_struct *p;
 
-	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0);
+	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
 	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
 	read_lock(&tasklist_lock);
 retry:
@@ -646,6 +644,7 @@ static void clear_system_oom(void)
 void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *nodemask)
 {
+	const nodemask_t *mpol_mask;
 	struct task_struct *p;
 	unsigned long totalpages;
 	unsigned long freed = 0;
@@ -675,7 +674,8 @@ void out_of_memory(struct zonelist *zone
 	 */
 	constraint = constrained_alloc(zonelist, gfp_mask, nodemask,
 						&totalpages);
-	check_panic_on_oom(constraint, gfp_mask, order);
+	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
+	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
 
 	read_lock(&tasklist_lock);
 	if (sysctl_oom_kill_allocating_task &&
@@ -693,15 +693,13 @@ void out_of_memory(struct zonelist *zone
 	}
 
 retry:
-	p = select_bad_process(&points, totalpages, NULL,
-			constraint == CONSTRAINT_MEMORY_POLICY ? nodemask :
-								 NULL);
+	p = select_bad_process(&points, totalpages, NULL, mpol_mask);
 	if (PTR_ERR(p) == -1UL)
 		goto out;
 
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
-		dump_header(NULL, gfp_mask, order, NULL);
+		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
 		read_unlock(&tasklist_lock);
 		panic("Out of memory and no killable processes...\n");
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
linux-next.patch
oom-filter-unkillable-tasks-from-tasklist-dump.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-mempolicy-check-return-code-of-check_range.patch
jbd-remove-dependency-on-__gfp_nofail.patch

