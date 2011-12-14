From: akpm@linux-foundation.org
Subject: [obsolete] cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:06:22 -0800
Message-ID: <20111214200623.11A4210004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:54510 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1LNUGY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:06:24 -0500
Received: by mail-yx0-f202.google.com with SMTP id m5so135066yen.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:06:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, kirill@shutemov.name, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: add previous cgroup in can_attach_task/attach_task callbacks
has been removed from the -mm tree.  Its filename was
     cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: cgroups: add previous cgroup in can_attach_task/attach_task callbacks

This is to prepare the integration of a new max number of proc cgroup
subsystem.  We'll need to release some resources from the previous cgroup.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    6 ++++--
 block/blk-cgroup.c                |   12 ++++++++----
 include/linux/cgroup.h            |    6 ++++--
 kernel/cgroup.c                   |   11 +++++++----
 kernel/cgroup_freezer.c           |    3 ++-
 kernel/cpuset.c                   |    6 ++++--
 kernel/events/core.c              |    5 +++--
 kernel/sched/core.c               |    6 ++++--
 8 files changed, 36 insertions(+), 19 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks
+++ a/Documentation/cgroups/cgroups.txt
@@ -605,7 +605,8 @@ called on a fork. If this method returns
 remain valid while the caller holds cgroup_mutex and it is ensured that either
 attach() or cancel_attach() will be called in future.
 
-int can_attach_task(struct cgroup *cgrp, struct task_struct *tsk);
+int can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+		    struct task_struct *tsk);
 (cgroup_mutex held by caller)
 
 As can_attach, but for operations that must be run once per task to be
@@ -635,7 +636,8 @@ void attach(struct cgroup_subsys *ss, st
 Called after the task has been attached to the cgroup, to allow any
 post-attachment activity that requires memory allocations or blocking.
 
-void attach_task(struct cgroup *cgrp, struct task_struct *tsk);
+void attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+		 struct task_struct *tsk);
 (cgroup_mutex held by caller)
 
 As attach, but for operations that must be run once per task to be attached,
diff -puN block/blk-cgroup.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks block/blk-cgroup.c
--- a/block/blk-cgroup.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks
+++ a/block/blk-cgroup.c
@@ -30,8 +30,10 @@ EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
 static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
 						  struct cgroup *);
-static int blkiocg_can_attach_task(struct cgroup *, struct task_struct *);
-static void blkiocg_attach_task(struct cgroup *, struct task_struct *);
+static int blkiocg_can_attach_task(struct cgroup *, struct cgroup *,
+				   struct task_struct *);
+static void blkiocg_attach_task(struct cgroup *, struct cgroup *,
+				struct task_struct *);
 static void blkiocg_destroy(struct cgroup_subsys *, struct cgroup *);
 static int blkiocg_populate(struct cgroup_subsys *, struct cgroup *);
 
@@ -1626,7 +1628,8 @@ done:
  * of the main cic data structures.  For now we allow a task to change
  * its cgroup only if it's the only owner of its ioc.
  */
-static int blkiocg_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+static int blkiocg_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				   struct task_struct *tsk)
 {
 	struct io_context *ioc;
 	int ret = 0;
@@ -1641,7 +1644,8 @@ static int blkiocg_can_attach_task(struc
 	return ret;
 }
 
-static void blkiocg_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+static void blkiocg_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				struct task_struct *tsk)
 {
 	struct io_context *ioc;
 
diff -puN include/linux/cgroup.h~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks
+++ a/include/linux/cgroup.h
@@ -468,11 +468,13 @@ struct cgroup_subsys {
 	void (*destroy)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	int (*can_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			  struct task_struct *tsk);
-	int (*can_attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
+	int (*can_attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp,
+			       struct task_struct *tsk);
 	void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			      struct task_struct *tsk);
 	void (*pre_attach)(struct cgroup *cgrp);
-	void (*attach_task)(struct cgroup *cgrp, struct task_struct *tsk);
+	void (*attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp,
+			    struct task_struct *tsk);
 	void (*attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		       struct cgroup *old_cgrp, struct task_struct *tsk);
 	void (*fork)(struct cgroup_subsys *ss, struct task_struct *task);
diff -puN kernel/cgroup.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks
+++ a/kernel/cgroup.c
@@ -1844,7 +1844,7 @@ int cgroup_attach_task(struct cgroup *cg
 			}
 		}
 		if (ss->can_attach_task) {
-			retval = ss->can_attach_task(cgrp, tsk);
+			retval = ss->can_attach_task(cgrp, oldcgrp, tsk);
 			if (retval) {
 				failed_ss = ss;
 				goto out;
@@ -1860,7 +1860,7 @@ int cgroup_attach_task(struct cgroup *cg
 		if (ss->pre_attach)
 			ss->pre_attach(cgrp);
 		if (ss->attach_task)
-			ss->attach_task(cgrp, tsk);
+			ss->attach_task(cgrp, oldcgrp, tsk);
 		if (ss->attach)
 			ss->attach(ss, cgrp, oldcgrp, tsk);
 	}
@@ -2075,7 +2075,10 @@ int cgroup_attach_proc(struct cgroup *cg
 			/* run on each task in the threadgroup. */
 			for (i = 0; i < group_size; i++) {
 				tsk = flex_array_get_ptr(group, i);
-				retval = ss->can_attach_task(cgrp, tsk);
+				oldcgrp = task_cgroup_from_root(tsk, root);
+
+				retval = ss->can_attach_task(cgrp,
+							     oldcgrp, tsk);
 				if (retval) {
 					failed_ss = ss;
 					cancel_failed_ss = true;
@@ -2141,7 +2144,7 @@ int cgroup_attach_proc(struct cgroup *cg
 			/* attach each task to each subsystem */
 			for_each_subsys(root, ss) {
 				if (ss->attach_task)
-					ss->attach_task(cgrp, tsk);
+					ss->attach_task(cgrp, oldcgrp, tsk);
 			}
 		} else {
 			BUG_ON(retval != -ESRCH);
diff -puN kernel/cgroup_freezer.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks
+++ a/kernel/cgroup_freezer.c
@@ -181,7 +181,8 @@ static int freezer_can_attach(struct cgr
 	return 0;
 }
 
-static int freezer_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+static int freezer_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				   struct task_struct *tsk)
 {
 	return cgroup_freezing(tsk) ? -EBUSY : 0;
 }
diff -puN kernel/cpuset.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks kernel/cpuset.c
--- a/kernel/cpuset.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks
+++ a/kernel/cpuset.c
@@ -1404,7 +1404,8 @@ static int cpuset_can_attach(struct cgro
 	return 0;
 }
 
-static int cpuset_can_attach_task(struct cgroup *cgrp, struct task_struct *task)
+static int cpuset_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				  struct task_struct *task)
 {
 	return security_task_setscheduler(task);
 }
@@ -1432,7 +1433,8 @@ static void cpuset_pre_attach(struct cgr
 }
 
 /* Per-thread attachment work. */
-static void cpuset_attach_task(struct cgroup *cont, struct task_struct *tsk)
+static void cpuset_attach_task(struct cgroup *cont, struct cgroup *old,
+			       struct task_struct *tsk)
 {
 	int err;
 	struct cpuset *cs = cgroup_cs(cont);
diff -puN kernel/events/core.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks kernel/events/core.c
--- a/kernel/events/core.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks
+++ a/kernel/events/core.c
@@ -6938,7 +6938,8 @@ static int __perf_cgroup_move(void *info
 }
 
 static void
-perf_cgroup_attach_task(struct cgroup *cgrp, struct task_struct *task)
+perf_cgroup_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+			struct task_struct *task)
 {
 	task_function_call(task, __perf_cgroup_move, task);
 }
@@ -6954,7 +6955,7 @@ static void perf_cgroup_exit(struct cgro
 	if (!(task->flags & PF_EXITING))
 		return;
 
-	perf_cgroup_attach_task(cgrp, task);
+	perf_cgroup_attach_task(cgrp, old_cgrp, task);
 }
 
 struct cgroup_subsys perf_subsys = {
diff -puN /dev/null /dev/null
diff -puN kernel/sched/sched.h~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks kernel/sched/sched.h
diff -puN kernel/sched/core.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks kernel/sched/core.c
--- a/kernel/sched/core.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks
+++ a/kernel/sched/core.c
@@ -7531,7 +7531,8 @@ cpu_cgroup_destroy(struct cgroup_subsys 
 }
 
 static int
-cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+			   struct task_struct *tsk)
 {
 	/*
 	 * kthreadd can fork workers for an RT workqueue in a cgroup
@@ -7554,7 +7555,8 @@ cpu_cgroup_can_attach_task(struct cgroup
 }
 
 static void
-cpu_cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+cpu_cgroup_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+		       struct task_struct *tsk)
 {
 	sched_move_task(tsk);
 }
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
reiserfs-delay-reiserfs-lock-until-journal-initialization.patch
reiserfs-dont-lock-journal_init.patch
reiserfs-dont-lock-root-inode-searching.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-a-task-counter-subsystem-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
selftests-new-x86-breakpoints-selftest.patch

