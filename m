From: akpm@linux-foundation.org
Subject: [folded] cpuset-fix-unchecked-calls-to-nodemask_alloc-v2.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:22:03 -0700
Message-ID: <201103232322.p2NNM4Aw004490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932972Ab1CWXWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:22:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpuset-fix-unchecked-calls-to-nodemask_alloc-v2
has been removed from the -mm tree.  Its filename was
     cpuset-fix-unchecked-calls-to-nodemask_alloc-v2.patch

This patch was dropped because it was folded into cpuset-fix-unchecked-calls-to-nodemask_alloc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset-fix-unchecked-calls-to-nodemask_alloc-v2
From: Li Zefan <lizf@cn.fujitsu.com>

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Paul Menage <menage@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff -puN kernel/cpuset.c~cpuset-fix-unchecked-calls-to-nodemask_alloc-v2 kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-unchecked-calls-to-nodemask_alloc-v2
+++ a/kernel/cpuset.c
@@ -79,15 +79,6 @@ int number_of_cpusets __read_mostly;
 struct cgroup_subsys cpuset_subsys;
 struct cpuset;
 
-/*
- * In functions that can't propagate errno to users, to avoid declaring a
- * nodemask_t variable, and avoid using NODEMASK_ALLOC that can return
- * -ENOMEM, we use this global cpuset_mems.
- *
- * It must called under cgroup_lock().
- */
-static nodemask_t cpuset_mems;
-
 /* See "Frequency meter" comments, below. */
 
 struct fmeter {
@@ -1024,11 +1015,12 @@ static void cpuset_change_nodemask(struc
 	struct cpuset *cs;
 	int migrate;
 	const nodemask_t *oldmem = scan->data;
+	static nodemask_t newmems;	/* protected by cgroup_mutex */
 
 	cs = cgroup_cs(scan->cg);
-	guarantee_online_mems(cs, &cpuset_mems);
+	guarantee_online_mems(cs, &newmems);
 
-	cpuset_change_task_nodemask(p, &cpuset_mems);
+	cpuset_change_task_nodemask(p, &newmems);
 
 	mm = get_task_mm(p);
 	if (!mm)
@@ -1099,10 +1091,13 @@ static void update_tasks_nodemask(struct
 static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 			   const char *buf)
 {
-	nodemask_t *oldmem = &cpuset_mems;
+	NODEMASK_ALLOC(nodemask_t, oldmem, GFP_KERNEL);
 	int retval;
 	struct ptr_heap heap;
 
+	if (!oldmem)
+		return -ENOMEM;
+
 	/*
 	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
 	 * it's read-only
@@ -1152,6 +1147,7 @@ static int update_nodemask(struct cpuset
 
 	heap_free(&heap);
 done:
+	NODEMASK_FREE(oldmem);
 	return retval;
 }
 
@@ -1437,33 +1433,33 @@ static void cpuset_attach(struct cgroup_
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
-	nodemask_t *to = &cpuset_mems;
+	static nodemask_t to;		/* protected by cgroup_mutex */
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
 	} else {
 		guarantee_online_cpus(cs, cpus_attach);
 	}
-	guarantee_online_mems(cs, to);
+	guarantee_online_mems(cs, &to);
 
 	/* do per-task migration stuff possibly for each in the threadgroup */
-	cpuset_attach_task(tsk, to, cs);
+	cpuset_attach_task(tsk, &to, cs);
 	if (threadgroup) {
 		struct task_struct *c;
 		rcu_read_lock();
 		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
-			cpuset_attach_task(c, to, cs);
+			cpuset_attach_task(c, &to, cs);
 		}
 		rcu_read_unlock();
 	}
 
 	/* change mm; only needs to be done once even if threadgroup */
-	*to = cs->mems_allowed;
+	to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
 	if (mm) {
-		mpol_rebind_mm(mm, to);
+		mpol_rebind_mm(mm, &to);
 		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, &oldcs->mems_allowed, to);
+			cpuset_migrate_mm(mm, &oldcs->mems_allowed, &to);
 		mmput(mm);
 	}
 }
@@ -2047,7 +2043,7 @@ static void scan_for_empty_cpusets(struc
 	struct cpuset *cp;	/* scans cpusets being updated */
 	struct cpuset *child;	/* scans child cpusets of cp */
 	struct cgroup *cont;
-	nodemask_t *oldmems = &cpuset_mems;
+	static nodemask_t oldmems;	/* protected by cgroup_mutex */
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
@@ -2064,7 +2060,7 @@ static void scan_for_empty_cpusets(struc
 		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
 			continue;
 
-		*oldmems = cp->mems_allowed;
+		oldmems = cp->mems_allowed;
 
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
@@ -2080,7 +2076,7 @@ static void scan_for_empty_cpusets(struc
 			remove_tasks_in_empty_cpuset(cp);
 		else {
 			update_tasks_cpumask(cp, NULL);
-			update_tasks_nodemask(cp, oldmems, NULL);
+			update_tasks_nodemask(cp, &oldmems, NULL);
 		}
 	}
 }
@@ -2124,16 +2120,16 @@ void cpuset_update_active_cpus(void)
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
-	nodemask_t *oldmems = &cpuset_mems;
+	static nodemask_t oldmems;	/* protected by cgroup_mutex */
 
 	cgroup_lock();
 	switch (action) {
 	case MEM_ONLINE:
-		*oldmems = top_cpuset.mems_allowed;
+		oldmems = top_cpuset.mems_allowed;
 		mutex_lock(&callback_mutex);
 		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 		mutex_unlock(&callback_mutex);
-		update_tasks_nodemask(&top_cpuset, oldmems, NULL);
+		update_tasks_nodemask(&top_cpuset, &oldmems, NULL);
 		break;
 	case MEM_OFFLINE:
 		/*
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch

