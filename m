From: akpm@linux-foundation.org
Subject: + mm-oom-introduce-memoryoom_group.patch added to -mm tree
Date: Thu, 30 Nov 2017 12:39:52 -0800
Message-ID: <5a206c98./9FEeBAmoC1jfLDk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdK3Ujx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:39:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: introduce memory.oom_group
has been added to the -mm tree.  Its filename is
     mm-oom-introduce-memoryoom_group.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-introduce-memoryoom_group.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-introduce-memoryoom_group.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm, oom: introduce memory.oom_group

The cgroup-aware OOM killer treats leaf memory cgroups as memory
consumption entities and performs the victim selection by comparing them
based on their memory footprint.  Then it kills the biggest task inside
the selected memory cgroup.

But there are workloads, which are not tolerant to a such behavior. 
Killing a random task may leave the workload in a broken state.

To solve this problem, memory.oom_group knob is introduced.  It will
define, whether a memory group should be treated as an indivisible memory
consumer, compared by total memory consumption with other memory consumers
(leaf memory cgroups and other memory cgroups with memory.oom_group set),
and whether all belonging tasks should be killed if the cgroup is
selected.

If set on memcg A, it means that in case of system-wide OOM or memcg-wide
OOM scoped to A or any ancestor cgroup, all tasks, belonging to the
sub-tree of A will be killed.  If OOM event is scoped to a descendant
cgroup (A/B, for example), only tasks in that cgroup can be affected.  OOM
killer will never touch any tasks outside of the scope of the OOM event.

Also, tasks with oom_score_adj set to -1000 will not be killed because
this has been a long established way to protect a particular process from
seeing an unexpected SIGKILL from the OOM killer.  Ignoring this user
defined configuration might lead to data corruptions or other misbehavior.

The default value is 0.

Link: http://lkml.kernel.org/r/20171130152824.1591-5-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 +++++++
 mm/memcontrol.c            |   75 +++++++++++++++++++++++++++++++++--
 mm/oom_kill.c              |   47 +++++++++++++++++----
 3 files changed, 126 insertions(+), 13 deletions(-)

diff -puN include/linux/memcontrol.h~mm-oom-introduce-memoryoom_group include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-oom-introduce-memoryoom_group
+++ a/include/linux/memcontrol.h
@@ -203,6 +203,13 @@ struct mem_cgroup {
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
+	/*
+	 * Treat the sub-tree as an indivisible memory consumer,
+	 * kill all belonging tasks if the memory cgroup selected
+	 * as OOM victim.
+	 */
+	bool oom_group;
+
 	/* handle for "memory.events" */
 	struct cgroup_file events_file;
 
@@ -490,6 +497,11 @@ bool mem_cgroup_oom_synchronize(bool wai
 
 bool mem_cgroup_select_oom_victim(struct oom_control *oc);
 
+static inline bool mem_cgroup_oom_group(struct mem_cgroup *memcg)
+{
+	return memcg->oom_group;
+}
+
 #ifdef CONFIG_MEMCG_SWAP
 extern int do_swap_account;
 #endif
@@ -990,6 +1002,11 @@ static inline bool mem_cgroup_select_oom
 {
 	return false;
 }
+
+static inline bool mem_cgroup_oom_group(struct mem_cgroup *memcg)
+{
+	return false;
+}
 #endif /* CONFIG_MEMCG */
 
 /* idx can be of type enum memcg_stat_item or node_stat_item */
diff -puN mm/memcontrol.c~mm-oom-introduce-memoryoom_group mm/memcontrol.c
--- a/mm/memcontrol.c~mm-oom-introduce-memoryoom_group
+++ a/mm/memcontrol.c
@@ -2779,19 +2779,51 @@ static long oom_evaluate_memcg(struct me
 
 static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
 {
-	struct mem_cgroup *iter;
+	struct mem_cgroup *iter, *group = NULL;
+	long group_score = 0;
 
 	oc->chosen_memcg = NULL;
 	oc->chosen_points = 0;
 
 	/*
+	 * If OOM is memcg-wide, and the memcg has the oom_group flag set,
+	 * all tasks belonging to the memcg should be killed.
+	 * So, we mark the memcg as a victim.
+	 */
+	if (oc->memcg && mem_cgroup_oom_group(oc->memcg)) {
+		oc->chosen_memcg = oc->memcg;
+		css_get(&oc->chosen_memcg->css);
+		return;
+	}
+
+	/*
 	 * The oom_score is calculated for leaf memory cgroups (including
 	 * the root memcg).
+	 * Non-leaf oom_group cgroups accumulating score of descendant
+	 * leaf memory cgroups.
 	 */
 	rcu_read_lock();
 	for_each_mem_cgroup_tree(iter, root) {
 		long score;
 
+		/*
+		 * We don't consider non-leaf non-oom_group memory cgroups
+		 * as OOM victims.
+		 */
+		if (memcg_has_children(iter) && iter != root_mem_cgroup &&
+		    !mem_cgroup_oom_group(iter))
+			continue;
+
+		/*
+		 * If group is not set or we've ran out of the group's sub-tree,
+		 * we should set group and reset group_score.
+		 */
+		if (!group || group == root_mem_cgroup ||
+		    !mem_cgroup_is_descendant(iter, group)) {
+			group = iter;
+			group_score = 0;
+		}
+
 		if (memcg_has_children(iter) && iter != root_mem_cgroup)
 			continue;
 
@@ -2813,9 +2845,11 @@ static void select_victim_memcg(struct m
 			break;
 		}
 
-		if (score > oc->chosen_points) {
-			oc->chosen_points = score;
-			oc->chosen_memcg = iter;
+		group_score += score;
+
+		if (group_score > oc->chosen_points) {
+			oc->chosen_points = group_score;
+			oc->chosen_memcg = group;
 		}
 	}
 
@@ -5440,6 +5474,33 @@ static ssize_t memory_max_write(struct k
 	return nbytes;
 }
 
+static int memory_oom_group_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	bool oom_group = memcg->oom_group;
+
+	seq_printf(m, "%d\n", oom_group);
+
+	return 0;
+}
+
+static ssize_t memory_oom_group_write(struct kernfs_open_file *of,
+				      char *buf, size_t nbytes,
+				      loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	int oom_group;
+	int err;
+
+	err = kstrtoint(strstrip(buf), 0, &oom_group);
+	if (err)
+		return err;
+
+	memcg->oom_group = oom_group;
+
+	return nbytes;
+}
+
 static int memory_events_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
@@ -5560,6 +5621,12 @@ static struct cftype memory_files[] = {
 		.write = memory_max_write,
 	},
 	{
+		.name = "oom_group",
+		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
+		.seq_show = memory_oom_group_show,
+		.write = memory_oom_group_write,
+	},
+	{
 		.name = "events",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.file_offset = offsetof(struct mem_cgroup, events_file),
diff -puN mm/oom_kill.c~mm-oom-introduce-memoryoom_group mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-introduce-memoryoom_group
+++ a/mm/oom_kill.c
@@ -820,6 +820,17 @@ static void __oom_kill_process(struct ta
 	struct mm_struct *mm;
 	bool can_oom_reap = true;
 
+	/*
+	 * __oom_kill_process() is used to kill all tasks belonging to
+	 * the selected memory cgroup, so we should check that we're not
+	 * trying to kill an unkillable task.
+	 */
+	if (is_global_init(victim) || (victim->flags & PF_KTHREAD) ||
+	    victim->signal->oom_score_adj == OOM_SCORE_ADJ_MIN) {
+		put_task_struct(victim);
+		return;
+	}
+
 	p = find_lock_task_mm(victim);
 	if (!p) {
 		put_task_struct(victim);
@@ -956,21 +967,39 @@ static void oom_kill_process(struct oom_
 	__oom_kill_process(victim);
 }
 
-static bool oom_kill_memcg_victim(struct oom_control *oc)
+static int oom_kill_memcg_member(struct task_struct *task, void *unused)
 {
+	get_task_struct(task);
+	__oom_kill_process(task);
+	return 0;
+}
 
+static bool oom_kill_memcg_victim(struct oom_control *oc)
+{
 	if (oc->chosen_memcg == NULL || oc->chosen_memcg == INFLIGHT_VICTIM)
 		return oc->chosen_memcg;
 
-	/* Kill a task in the chosen memcg with the biggest memory footprint */
-	oc->chosen_points = 0;
-	oc->chosen_task = NULL;
-	mem_cgroup_scan_tasks(oc->chosen_memcg, oom_evaluate_task, oc);
-
-	if (oc->chosen_task == NULL || oc->chosen_task == INFLIGHT_VICTIM)
-		goto out;
+	/*
+	 * If memory.oom_group is set, kill all tasks belonging to the sub-tree
+	 * of the chosen memory cgroup, otherwise kill the task with the biggest
+	 * memory footprint.
+	 */
+	if (mem_cgroup_oom_group(oc->chosen_memcg)) {
+		mem_cgroup_scan_tasks(oc->chosen_memcg, oom_kill_memcg_member,
+				      NULL);
+		/* We have one or more terminating processes at this point. */
+		oc->chosen_task = INFLIGHT_VICTIM;
+	} else {
+		oc->chosen_points = 0;
+		oc->chosen_task = NULL;
+		mem_cgroup_scan_tasks(oc->chosen_memcg, oom_evaluate_task, oc);
+
+		if (oc->chosen_task == NULL ||
+		    oc->chosen_task == INFLIGHT_VICTIM)
+			goto out;
 
-	__oom_kill_process(oc->chosen_task);
+		__oom_kill_process(oc->chosen_task);
+	}
 
 out:
 	mem_cgroup_put(oc->chosen_memcg);
_

Patches currently in -mm which might be from guro@fb.com are

mm-show-total-hugetlb-memory-consumption-in-proc-meminfo.patch
mm-oom-refactor-the-oom_kill_process-function.patch
mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup.patch
mm-oom-cgroup-aware-oom-killer.patch
mm-oom-introduce-memoryoom_group.patch
mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer.patch
cgroup-list-groupoom-in-cgroup-features.patch

