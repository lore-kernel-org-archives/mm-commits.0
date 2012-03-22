From: akpm@linux-foundation.org
Subject: [merged] mm-fix-move-migrate_pages-race-on-task-struct.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:35 -0700
Message-ID: <20120322201835.B33FAA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:55377 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759036Ab2CVUSi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2012 16:18:38 -0400
Received: by laai8 with SMTP id i8so133924laa.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, dave@linux.vnet.ibm.com, ebiederm@xmission.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix move/migrate_pages() race on task struct
has been removed from the -mm tree.  Its filename was
     mm-fix-move-migrate_pages-race-on-task-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: mm: fix move/migrate_pages() race on task struct

Migration functions perform the rcu_read_unlock too early.  As a result
the task pointed to may change from under us.  This can result in an oops,
as reported by Dave Hansen in https://lkml.org/lkml/2012/2/23/302.

The following patch extend the period of the rcu_read_lock until after the
permissions checks are done.  We also take a refcount so that the task
reference is stable when calling security check functions and performing
cpuset node validation (which takes a mutex).

The refcount is dropped before actual page migration occurs so there is no
change to the refcounts held during page migration.

Also move the determination of the mm of the task struct to immediately
before the do_migrate*() calls so that it is clear that we switch from
handling the task during permission checks to the mm for the actual
migration.  Since the determination is only done once and we then no
longer use the task_struct we can be sure that we operate on a specific
address space that will not change from under us.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Reported-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   32 +++++++++++++++++++-------------
 mm/migrate.c   |   36 +++++++++++++++++++-----------------
 2 files changed, 38 insertions(+), 30 deletions(-)

diff -puN mm/mempolicy.c~mm-fix-move-migrate_pages-race-on-task-struct mm/mempolicy.c
--- a/mm/mempolicy.c~mm-fix-move-migrate_pages-race-on-task-struct
+++ a/mm/mempolicy.c
@@ -1323,12 +1323,9 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 		err = -ESRCH;
 		goto out;
 	}
-	mm = get_task_mm(task);
-	rcu_read_unlock();
+	get_task_struct(task);
 
 	err = -EINVAL;
-	if (!mm)
-		goto out;
 
 	/*
 	 * Check if this process has the right to modify the specified
@@ -1336,14 +1333,13 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	rcu_read_lock();
 	tcred = __task_cred(task);
 	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
 	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
 	    !capable(CAP_SYS_NICE)) {
 		rcu_read_unlock();
 		err = -EPERM;
-		goto out;
+		goto out_put;
 	}
 	rcu_read_unlock();
 
@@ -1351,26 +1347,36 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 	/* Is the user allowed to access the target nodes? */
 	if (!nodes_subset(*new, task_nodes) && !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
-		goto out;
+		goto out_put;
 	}
 
 	if (!nodes_subset(*new, node_states[N_HIGH_MEMORY])) {
 		err = -EINVAL;
-		goto out;
+		goto out_put;
 	}
 
 	err = security_task_movememory(task);
 	if (err)
-		goto out;
+		goto out_put;
 
-	err = do_migrate_pages(mm, old, new,
-		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
-out:
+	mm = get_task_mm(task);
+	put_task_struct(task);
 	if (mm)
-		mmput(mm);
+		err = do_migrate_pages(mm, old, new,
+			capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
+	else
+		err = -EINVAL;
+
+	mmput(mm);
+out:
 	NODEMASK_SCRATCH_FREE(scratch);
 
 	return err;
+
+out_put:
+	put_task_struct(task);
+	goto out;
+
 }
 
 
diff -puN mm/migrate.c~mm-fix-move-migrate_pages-race-on-task-struct mm/migrate.c
--- a/mm/migrate.c~mm-fix-move-migrate_pages-race-on-task-struct
+++ a/mm/migrate.c
@@ -1174,20 +1174,17 @@ set_status:
  * Migrate an array of page address onto an array of nodes and fill
  * the corresponding array of status.
  */
-static int do_pages_move(struct mm_struct *mm, struct task_struct *task,
+static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 			 unsigned long nr_pages,
 			 const void __user * __user *pages,
 			 const int __user *nodes,
 			 int __user *status, int flags)
 {
 	struct page_to_node *pm;
-	nodemask_t task_nodes;
 	unsigned long chunk_nr_pages;
 	unsigned long chunk_start;
 	int err;
 
-	task_nodes = cpuset_mems_allowed(task);
-
 	err = -ENOMEM;
 	pm = (struct page_to_node *)__get_free_page(GFP_KERNEL);
 	if (!pm)
@@ -1349,6 +1346,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, 
 	struct task_struct *task;
 	struct mm_struct *mm;
 	int err;
+	nodemask_t task_nodes;
 
 	/* Check flags */
 	if (flags & ~(MPOL_MF_MOVE|MPOL_MF_MOVE_ALL))
@@ -1364,11 +1362,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, 
 		rcu_read_unlock();
 		return -ESRCH;
 	}
-	mm = get_task_mm(task);
-	rcu_read_unlock();
-
-	if (!mm)
-		return -EINVAL;
+	get_task_struct(task);
 
 	/*
 	 * Check if this process has the right to modify the specified
@@ -1376,7 +1370,6 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, 
 	 * capabilities, superuser privileges or the same
 	 * userid as the target process.
 	 */
-	rcu_read_lock();
 	tcred = __task_cred(task);
 	if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
 	    cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
@@ -1391,16 +1384,25 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, 
  	if (err)
 		goto out;
 
-	if (nodes) {
-		err = do_pages_move(mm, task, nr_pages, pages, nodes, status,
-				    flags);
-	} else {
-		err = do_pages_stat(mm, nr_pages, pages, status);
-	}
+	task_nodes = cpuset_mems_allowed(task);
+	mm = get_task_mm(task);
+	put_task_struct(task);
+
+	if (mm) {
+		if (nodes)
+			err = do_pages_move(mm, task_nodes, nr_pages, pages,
+					    nodes, status, flags);
+		else
+			err = do_pages_stat(mm, nr_pages, pages, status);
+	} else
+		err = -EINVAL;
 
-out:
 	mmput(mm);
 	return err;
+
+out:
+	put_task_struct(task);
+	return err;
 }
 
 /*
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
linux-next.patch
smp-introduce-a-generic-on_each_cpu_mask-function.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch
selftests-launch-individual-selftests-from-the-main-makefile.patch
move-page-typesc-from-documentation-to-tools-vm.patch
move-slabinfoc-to-tools-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix-fix.patch

