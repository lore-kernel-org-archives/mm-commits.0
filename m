From: akpm@linux-foundation.org
Subject: + cpuset-fix-unchecked-calls-to-nodemask_alloc.patch added to -mm tree
Date: Thu, 17 Feb 2011 14:47:49 -0800
Message-ID: <201102172247.p1HMlnoj020474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351Ab1BQWs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Feb 2011 17:48:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com


The patch titled
     cpuset: fix unchecked calls to NODEMASK_ALLOC()
has been added to the -mm tree.  Its filename is
     cpuset-fix-unchecked-calls-to-nodemask_alloc.patch

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
Subject: cpuset: fix unchecked calls to NODEMASK_ALLOC()
From: Li Zefan <lizf@cn.fujitsu.com>

Those functions that use NODEMASK_ALLOC() can't propagate errno
to users, but will fail silently.

Since all of them are called with cgroup_mutex held, here we use
a global nodemask_t variable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   45 +++++++++++++++------------------------------
 1 file changed, 15 insertions(+), 30 deletions(-)

diff -puN kernel/cpuset.c~cpuset-fix-unchecked-calls-to-nodemask_alloc kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-unchecked-calls-to-nodemask_alloc
+++ a/kernel/cpuset.c
@@ -79,6 +79,15 @@ int number_of_cpusets __read_mostly;
 struct cgroup_subsys cpuset_subsys;
 struct cpuset;
 
+/*
+ * In functions that can't propogate errno to users, to avoid declaring a
+ * nodemask_t variable, and avoid using NODEMASK_ALLOC that can return
+ * -ENOMEM, we use this global cpuset_mems.
+ *
+ * It should be used with cgroup_lock held.
+ */
+static nodemask_t cpuset_mems;
+
 /* See "Frequency meter" comments, below. */
 
 struct fmeter {
@@ -1015,17 +1024,11 @@ static void cpuset_change_nodemask(struc
 	struct cpuset *cs;
 	int migrate;
 	const nodemask_t *oldmem = scan->data;
-	NODEMASK_ALLOC(nodemask_t, newmems, GFP_KERNEL);
-
-	if (!newmems)
-		return;
 
 	cs = cgroup_cs(scan->cg);
-	guarantee_online_mems(cs, newmems);
-
-	cpuset_change_task_nodemask(p, newmems);
+	guarantee_online_mems(cs, &cpuset_mems);
 
-	NODEMASK_FREE(newmems);
+	cpuset_change_task_nodemask(p, &cpuset_mems);
 
 	mm = get_task_mm(p);
 	if (!mm)
@@ -1096,13 +1099,10 @@ static void update_tasks_nodemask(struct
 static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 			   const char *buf)
 {
-	NODEMASK_ALLOC(nodemask_t, oldmem, GFP_KERNEL);
+	nodemask_t *oldmem = &cpuset_mems;
 	int retval;
 	struct ptr_heap heap;
 
-	if (!oldmem)
-		return -ENOMEM;
-
 	/*
 	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
 	 * it's read-only
@@ -1152,7 +1152,6 @@ static int update_nodemask(struct cpuset
 
 	heap_free(&heap);
 done:
-	NODEMASK_FREE(oldmem);
 	return retval;
 }
 
@@ -1438,10 +1437,7 @@ static void cpuset_attach(struct cgroup_
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
-	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
-
-	if (to == NULL)
-		goto alloc_fail;
+	nodemask_t *to = &cpuset_mems;
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
@@ -1470,9 +1466,6 @@ static void cpuset_attach(struct cgroup_
 			cpuset_migrate_mm(mm, &oldcs->mems_allowed, to);
 		mmput(mm);
 	}
-
-alloc_fail:
-	NODEMASK_FREE(to);
 }
 
 /* The various types of files and directories in a cpuset file system */
@@ -2051,10 +2044,7 @@ static void scan_for_empty_cpusets(struc
 	struct cpuset *cp;	/* scans cpusets being updated */
 	struct cpuset *child;	/* scans child cpusets of cp */
 	struct cgroup *cont;
-	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
-
-	if (oldmems == NULL)
-		return;
+	nodemask_t *oldmems = &cpuset_mems;
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
@@ -2090,7 +2080,6 @@ static void scan_for_empty_cpusets(struc
 			update_tasks_nodemask(cp, oldmems, NULL);
 		}
 	}
-	NODEMASK_FREE(oldmems);
 }
 
 /*
@@ -2132,10 +2121,7 @@ void cpuset_update_active_cpus(void)
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
-	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
-
-	if (oldmems == NULL)
-		return NOTIFY_DONE;
+	nodemask_t *oldmems = &cpuset_mems;
 
 	cgroup_lock();
 	switch (action) {
@@ -2158,7 +2144,6 @@ static int cpuset_track_online_nodes(str
 	}
 	cgroup_unlock();
 
-	NODEMASK_FREE(oldmems);
 	return NOTIFY_OK;
 }
 #endif
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

mm-notifier_from_errno-cleanup.patch
cgroup-remove-the-ns_cgroup.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_sprintf_memlist.patch
cpuset-remove-unneeded-nodemask_alloc-in-cpuset_attch.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch
cpuset-hold-callback_mutex-in-cpuset_clone.patch

