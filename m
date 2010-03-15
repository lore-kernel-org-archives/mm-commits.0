From: akpm@linux-foundation.org
Subject: [to-be-updated] cpuset-alloc-nodemask_t-at-heap-not-stack.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:44:28 -0400
Message-ID: <201003150645.o2F6j2pv015532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231Ab0COGpb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:45:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, mingo@elte.hu, npiggin@suse.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: alloc nodemask_t at heap not stack
has been removed from the -mm tree.  Its filename was
     cpuset-alloc-nodemask_t-at-heap-not-stack.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: alloc nodemask_t at heap not stack
From: Miao Xie <miaox@cn.fujitsu.com>

Allocate nodemask_t from the heap instead of on the stack.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   93 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 28 deletions(-)

diff -puN kernel/cpuset.c~cpuset-alloc-nodemask_t-at-heap-not-stack kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-alloc-nodemask_t-at-heap-not-stack
+++ a/kernel/cpuset.c
@@ -984,15 +984,20 @@ static void cpuset_change_nodemask(struc
 	struct cpuset *cs;
 	int migrate;
 	const nodemask_t *oldmem = scan->data;
-	nodemask_t newmems;
+	NODEMASK_ALLOC(nodemask_t, newmems, GFP_KERNEL);
+
+	if (!newmems)
+		return;
 
 	cs = cgroup_cs(scan->cg);
-	guarantee_online_mems(cs, &newmems);
+	guarantee_online_mems(cs, newmems);
 
 	task_lock(p);
-	cpuset_change_task_nodemask(p, &newmems);
+	cpuset_change_task_nodemask(p, newmems);
 	task_unlock(p);
 
+	NODEMASK_FREE(newmems);
+
 	mm = get_task_mm(p);
 	if (!mm)
 		return;
@@ -1062,16 +1067,21 @@ static void update_tasks_nodemask(struct
 static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 			   const char *buf)
 {
-	nodemask_t oldmem;
+	NODEMASK_ALLOC(nodemask_t, oldmem, GFP_KERNEL);
 	int retval;
 	struct ptr_heap heap;
 
+	if (!oldmem)
+		return -ENOMEM;
+
 	/*
 	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
 	 * it's read-only
 	 */
-	if (cs == &top_cpuset)
-		return -EACCES;
+	if (cs == &top_cpuset) {
+		retval = -EACCES;
+		goto done;
+	}
 
 	/*
 	 * An empty mems_allowed is ok iff there are no tasks in the cpuset.
@@ -1087,11 +1097,13 @@ static int update_nodemask(struct cpuset
 			goto done;
 
 		if (!nodes_subset(trialcs->mems_allowed,
-				node_states[N_HIGH_MEMORY]))
-			return -EINVAL;
+				node_states[N_HIGH_MEMORY])) {
+			retval =  -EINVAL;
+			goto done;
+		}
 	}
-	oldmem = cs->mems_allowed;
-	if (nodes_equal(oldmem, trialcs->mems_allowed)) {
+	*oldmem = cs->mems_allowed;
+	if (nodes_equal(*oldmem, trialcs->mems_allowed)) {
 		retval = 0;		/* Too easy - nothing to do */
 		goto done;
 	}
@@ -1107,10 +1119,11 @@ static int update_nodemask(struct cpuset
 	cs->mems_allowed = trialcs->mems_allowed;
 	mutex_unlock(&callback_mutex);
 
-	update_tasks_nodemask(cs, &oldmem, &heap);
+	update_tasks_nodemask(cs, oldmem, &heap);
 
 	heap_free(&heap);
 done:
+	NODEMASK_FREE(oldmem);
 	return retval;
 }
 
@@ -1395,39 +1408,46 @@ static void cpuset_attach(struct cgroup_
 			  struct cgroup *oldcont, struct task_struct *tsk,
 			  bool threadgroup)
 {
-	nodemask_t from, to;
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
+	NODEMASK_ALLOC(nodemask_t, from, GFP_KERNEL);
+	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
+
+	if (from == NULL || to == NULL)
+		return;
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
 	} else {
 		guarantee_online_cpus(cs, cpus_attach);
 	}
-	guarantee_online_mems(cs, &to);
+	guarantee_online_mems(cs, to);
 
 	/* do per-task migration stuff possibly for each in the threadgroup */
-	cpuset_attach_task(tsk, &to, cs);
+	cpuset_attach_task(tsk, to, cs);
 	if (threadgroup) {
 		struct task_struct *c;
 		rcu_read_lock();
 		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
-			cpuset_attach_task(c, &to, cs);
+			cpuset_attach_task(c, to, cs);
 		}
 		rcu_read_unlock();
 	}
 
 	/* change mm; only needs to be done once even if threadgroup */
-	from = oldcs->mems_allowed;
-	to = cs->mems_allowed;
+	*from = oldcs->mems_allowed;
+	*to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
 	if (mm) {
-		mpol_rebind_mm(mm, &to);
+		mpol_rebind_mm(mm, to);
 		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, &from, &to);
+			cpuset_migrate_mm(mm, from, to);
 		mmput(mm);
 	}
+
+	NODEMASK_FREE(from);
+	NODEMASK_FREE(to);
 }
 
 /* The various types of files and directories in a cpuset file system */
@@ -1572,13 +1592,21 @@ static int cpuset_sprintf_cpulist(char *
 
 static int cpuset_sprintf_memlist(char *page, struct cpuset *cs)
 {
-	nodemask_t mask;
+	NODEMASK_ALLOC(nodemask_t, mask, GFP_KERNEL);
+	int retval;
+
+	if (mask == NULL)
+		return -ENOMEM;
 
 	mutex_lock(&callback_mutex);
-	mask = cs->mems_allowed;
+	*mask = cs->mems_allowed;
 	mutex_unlock(&callback_mutex);
 
-	return nodelist_scnprintf(page, PAGE_SIZE, mask);
+	retval = nodelist_scnprintf(page, PAGE_SIZE, *mask);
+
+	NODEMASK_FREE(mask);
+
+	return retval;
 }
 
 static ssize_t cpuset_common_file_read(struct cgroup *cont,
@@ -2007,7 +2035,10 @@ static void scan_for_empty_cpusets(struc
 	struct cpuset *cp;	/* scans cpusets being updated */
 	struct cpuset *child;	/* scans child cpusets of cp */
 	struct cgroup *cont;
-	nodemask_t oldmems;
+	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
+
+	if (oldmems == NULL)
+		return;
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
@@ -2024,7 +2055,7 @@ static void scan_for_empty_cpusets(struc
 		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
 			continue;
 
-		oldmems = cp->mems_allowed;
+		*oldmems = cp->mems_allowed;
 
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
@@ -2040,9 +2071,10 @@ static void scan_for_empty_cpusets(struc
 			remove_tasks_in_empty_cpuset(cp);
 		else {
 			update_tasks_cpumask(cp, NULL);
-			update_tasks_nodemask(cp, &oldmems, NULL);
+			update_tasks_nodemask(cp, oldmems, NULL);
 		}
 	}
+	NODEMASK_FREE(oldmems);
 }
 
 /*
@@ -2100,16 +2132,19 @@ static int cpuset_track_online_cpus(stru
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
-	nodemask_t oldmems;
+	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
+
+	if (oldmems == NULL)
+		return NOTIFY_DONE;
 
 	cgroup_lock();
 	switch (action) {
 	case MEM_ONLINE:
-		oldmems = top_cpuset.mems_allowed;
+		*oldmems = top_cpuset.mems_allowed;
 		mutex_lock(&callback_mutex);
 		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 		mutex_unlock(&callback_mutex);
-		update_tasks_nodemask(&top_cpuset, &oldmems, NULL);
+		update_tasks_nodemask(&top_cpuset, oldmems, NULL);
 		break;
 	case MEM_OFFLINE:
 		scan_for_empty_cpusets(&top_cpuset);
@@ -2118,6 +2153,8 @@ static int cpuset_track_online_nodes(str
 		break;
 	}
 	cgroup_unlock();
+
+	NODEMASK_FREE(oldmems);
 	return NOTIFY_OK;
 }
 #endif
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

origin.patch
cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
cpuset-alloc-nodemask_t-at-heap-not-stack.patch

