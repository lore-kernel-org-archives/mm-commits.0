From: akpm@linux-foundation.org
Subject: [merged] cpuset-fix-unchecked-calls-to-nodemask_alloc.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:30 -0700
Message-ID: <201103250725.p2P7PPZg026018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933822Ab1CYHZb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: fix unchecked calls to NODEMASK_ALLOC()
has been removed from the -mm tree.  Its filename was
     cpuset-fix-unchecked-calls-to-nodemask_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: fix unchecked calls to NODEMASK_ALLOC()
From: Li Zefan <lizf@cn.fujitsu.com>

Those functions that use NODEMASK_ALLOC() can't propagate errno
to users, but will fail silently.

Fix it by using a static nodemask_t variable for each function, and
those variables are protected by cgroup_mutex;

[akpm@linux-foundation.org: fix comment spelling, strengthen cgroup_lock comment]
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   51 ++++++++++++++--------------------------------
 1 file changed, 16 insertions(+), 35 deletions(-)

diff -puN kernel/cpuset.c~cpuset-fix-unchecked-calls-to-nodemask_alloc kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-unchecked-calls-to-nodemask_alloc
+++ a/kernel/cpuset.c
@@ -1015,17 +1015,12 @@ static void cpuset_change_nodemask(struc
 	struct cpuset *cs;
 	int migrate;
 	const nodemask_t *oldmem = scan->data;
-	NODEMASK_ALLOC(nodemask_t, newmems, GFP_KERNEL);
-
-	if (!newmems)
-		return;
+	static nodemask_t newmems;	/* protected by cgroup_mutex */
 
 	cs = cgroup_cs(scan->cg);
-	guarantee_online_mems(cs, newmems);
+	guarantee_online_mems(cs, &newmems);
 
-	cpuset_change_task_nodemask(p, newmems);
-
-	NODEMASK_FREE(newmems);
+	cpuset_change_task_nodemask(p, &newmems);
 
 	mm = get_task_mm(p);
 	if (!mm)
@@ -1438,41 +1433,35 @@ static void cpuset_attach(struct cgroup_
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
-	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
-
-	if (to == NULL)
-		goto alloc_fail;
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
-
-alloc_fail:
-	NODEMASK_FREE(to);
 }
 
 /* The various types of files and directories in a cpuset file system */
@@ -2055,10 +2044,7 @@ static void scan_for_empty_cpusets(struc
 	struct cpuset *cp;	/* scans cpusets being updated */
 	struct cpuset *child;	/* scans child cpusets of cp */
 	struct cgroup *cont;
-	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
-
-	if (oldmems == NULL)
-		return;
+	static nodemask_t oldmems;	/* protected by cgroup_mutex */
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
@@ -2075,7 +2061,7 @@ static void scan_for_empty_cpusets(struc
 		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
 			continue;
 
-		*oldmems = cp->mems_allowed;
+		oldmems = cp->mems_allowed;
 
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
@@ -2091,10 +2077,9 @@ static void scan_for_empty_cpusets(struc
 			remove_tasks_in_empty_cpuset(cp);
 		else {
 			update_tasks_cpumask(cp, NULL);
-			update_tasks_nodemask(cp, oldmems, NULL);
+			update_tasks_nodemask(cp, &oldmems, NULL);
 		}
 	}
-	NODEMASK_FREE(oldmems);
 }
 
 /*
@@ -2136,19 +2121,16 @@ void cpuset_update_active_cpus(void)
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
-	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
-
-	if (oldmems == NULL)
-		return NOTIFY_DONE;
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
@@ -2162,7 +2144,6 @@ static int cpuset_track_online_nodes(str
 	}
 	cgroup_unlock();
 
-	NODEMASK_FREE(oldmems);
 	return NOTIFY_OK;
 }
 #endif
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
cgroup-remove-the-ns_cgroup.patch

