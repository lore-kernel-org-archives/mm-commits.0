From: akpm@linux-foundation.org
Subject: [merged] cpuset-rewrite-update_tasks_nodemask.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:00 -0700
Message-ID: <200904061935.n36JZ0t6011843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbZDFUbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:31:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cpuset: rewrite update_tasks_nodemask()
has been removed from the -mm tree.  Its filename was
     cpuset-rewrite-update_tasks_nodemask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: rewrite update_tasks_nodemask()
From: Li Zefan <lizf@cn.fujitsu.com>

This patch uses cgroup_scan_tasks() to rebind tasks' vmas to new cpuset's
mems_allowed.

Not only simplify the code largely, but also avoid allocating an array to
hold mm pointers of all the tasks in the cpuset.  This array can be big
(size > PAGESIZE) if we have lots of tasks in that cpuset, thus has a
chance to fail the allocation when under memory stress.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |  109 ++++++++++++++++------------------------------
 1 file changed, 39 insertions(+), 70 deletions(-)

diff -puN kernel/cpuset.c~cpuset-rewrite-update_tasks_nodemask kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-rewrite-update_tasks_nodemask
+++ a/kernel/cpuset.c
@@ -1026,6 +1026,31 @@ static void cpuset_migrate_mm(struct mm_
 	mutex_unlock(&callback_mutex);
 }
 
+/*
+ * Rebind task's vmas to cpuset's new mems_allowed, and migrate pages to new
+ * nodes if memory_migrate flag is set. Called with cgroup_mutex held.
+ */
+static void cpuset_change_nodemask(struct task_struct *p,
+				   struct cgroup_scanner *scan)
+{
+	struct mm_struct *mm;
+	struct cpuset *cs;
+	int migrate;
+	const nodemask_t *oldmem = scan->data;
+
+	mm = get_task_mm(p);
+	if (!mm)
+		return;
+
+	cs = cgroup_cs(scan->cg);
+	migrate = is_memory_migrate(cs);
+
+	mpol_rebind_mm(mm, &cs->mems_allowed);
+	if (migrate)
+		cpuset_migrate_mm(mm, oldmem, &cs->mems_allowed);
+	mmput(mm);
+}
+
 static void *cpuset_being_rebound;
 
 /**
@@ -1038,88 +1063,32 @@ static void *cpuset_being_rebound;
  */
 static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 {
-	struct task_struct *p;
-	struct mm_struct **mmarray;
-	int i, n, ntasks;
-	int migrate;
-	int fudge;
-	struct cgroup_iter it;
 	int retval;
+	struct cgroup_scanner scan;
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
-	fudge = 10;				/* spare mmarray[] slots */
-	fudge += cpumask_weight(cs->cpus_allowed);/* imagine 1 fork-bomb/cpu */
-	retval = -ENOMEM;
+	scan.cg = cs->css.cgroup;
+	scan.test_task = NULL;
+	scan.process_task = cpuset_change_nodemask;
+	scan.heap = NULL;
+	scan.data = (nodemask_t *)oldmem;
 
 	/*
-	 * Allocate mmarray[] to hold mm reference for each task
-	 * in cpuset cs.  Can't kmalloc GFP_KERNEL while holding
-	 * tasklist_lock.  We could use GFP_ATOMIC, but with a
-	 * few more lines of code, we can retry until we get a big
-	 * enough mmarray[] w/o using GFP_ATOMIC.
-	 */
-	while (1) {
-		ntasks = cgroup_task_count(cs->css.cgroup);  /* guess */
-		ntasks += fudge;
-		mmarray = kmalloc(ntasks * sizeof(*mmarray), GFP_KERNEL);
-		if (!mmarray)
-			goto done;
-		read_lock(&tasklist_lock);		/* block fork */
-		if (cgroup_task_count(cs->css.cgroup) <= ntasks)
-			break;				/* got enough */
-		read_unlock(&tasklist_lock);		/* try again */
-		kfree(mmarray);
-	}
-
-	n = 0;
-
-	/* Load up mmarray[] with mm reference for each task in cpuset. */
-	cgroup_iter_start(cs->css.cgroup, &it);
-	while ((p = cgroup_iter_next(cs->css.cgroup, &it))) {
-		struct mm_struct *mm;
-
-		if (n >= ntasks) {
-			printk(KERN_WARNING
-				"Cpuset mempolicy rebind incomplete.\n");
-			break;
-		}
-		mm = get_task_mm(p);
-		if (!mm)
-			continue;
-		mmarray[n++] = mm;
-	}
-	cgroup_iter_end(cs->css.cgroup, &it);
-	read_unlock(&tasklist_lock);
-
-	/*
-	 * Now that we've dropped the tasklist spinlock, we can
-	 * rebind the vma mempolicies of each mm in mmarray[] to their
-	 * new cpuset, and release that mm.  The mpol_rebind_mm()
-	 * call takes mmap_sem, which we couldn't take while holding
-	 * tasklist_lock.  Forks can happen again now - the mpol_dup()
-	 * cpuset_being_rebound check will catch such forks, and rebind
-	 * their vma mempolicies too.  Because we still hold the global
-	 * cgroup_mutex, we know that no other rebind effort will
-	 * be contending for the global variable cpuset_being_rebound.
+	 * The mpol_rebind_mm() call takes mmap_sem, which we couldn't
+	 * take while holding tasklist_lock.  Forks can happen - the
+	 * mpol_dup() cpuset_being_rebound check will catch such forks,
+	 * and rebind their vma mempolicies too.  Because we still hold
+	 * the global cgroup_mutex, we know that no other rebind effort
+	 * will be contending for the global variable cpuset_being_rebound.
 	 * It's ok if we rebind the same mm twice; mpol_rebind_mm()
 	 * is idempotent.  Also migrate pages in each mm to new nodes.
 	 */
-	migrate = is_memory_migrate(cs);
-	for (i = 0; i < n; i++) {
-		struct mm_struct *mm = mmarray[i];
