From: akpm@linux-foundation.org
Subject: + cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch added to -mm tree
Date: Tue, 06 Sep 2011 15:42:08 -0700
Message-ID: <201109062242.p86Mg8gU008280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754451Ab1IFWmb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:42:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, kay.sievers@vrfy.org, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, tj@kernel.org


The patch titled
     cgroups: add previous cgroup in can_attach_task/attach_task callbacks
has been added to the -mm tree.  Its filename is
     cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch

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
Subject: cgroups: add previous cgroup in can_attach_task/attach_task callbacks
From: Frederic Weisbecker <fweisbec@gmail.com>

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
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    6 ++++--
 block/blk-cgroup.c                |   10 ++++++----
 include/linux/cgroup.h            |    5 +++--
 kernel/cgroup.c                   |   10 ++++++----
 kernel/cgroup_freezer.c           |    3 ++-
 kernel/cpuset.c                   |    6 ++++--
 kernel/events/core.c              |    5 +++--
 kernel/sched.c                    |    6 ++++--
 8 files changed, 32 insertions(+), 19 deletions(-)

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
@@ -30,8 +30,8 @@ EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
 static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
 						  struct cgroup *);
-static int blkiocg_can_attach_task(struct cgroup *, struct task_struct *);
-static void blkiocg_attach_task(struct cgroup *, struct task_struct *);
+static int blkiocg_can_attach_task(struct cgroup *, struct cgroup *, struct task_struct *);
+static void blkiocg_attach_task(struct cgroup *, struct cgroup *, struct task_struct *);
 static void blkiocg_destroy(struct cgroup_subsys *, struct cgroup *);
 static int blkiocg_populate(struct cgroup_subsys *, struct cgroup *);
 
@@ -1614,7 +1614,8 @@ done:
  * of the main cic data structures.  For now we allow a task to change
  * its cgroup only if it's the only owner of its ioc.
  */
-static int blkiocg_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+static int blkiocg_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				   struct task_struct *tsk)
 {
 	struct io_context *ioc;
 	int ret = 0;
@@ -1629,7 +1630,8 @@ static int blkiocg_can_attach_task(struc
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
@@ -468,11 +468,12 @@ struct cgroup_subsys {
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
+	void (*attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp, struct task_struct *tsk);
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
@@ -2075,7 +2075,9 @@ int cgroup_attach_proc(struct cgroup *cg
 			/* run on each task in the threadgroup. */
 			for (i = 0; i < group_size; i++) {
 				tsk = flex_array_get_ptr(group, i);
-				retval = ss->can_attach_task(cgrp, tsk);
+				oldcgrp = task_cgroup_from_root(tsk, root);
+
+				retval = ss->can_attach_task(cgrp, oldcgrp, tsk);
 				if (retval) {
 					failed_ss = ss;
 					cancel_failed_ss = true;
@@ -2141,7 +2143,7 @@ int cgroup_attach_proc(struct cgroup *cg
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
@@ -174,7 +174,8 @@ static int freezer_can_attach(struct cgr
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
@@ -1390,7 +1390,8 @@ static int cpuset_can_attach(struct cgro
 	return 0;
 }
 
-static int cpuset_can_attach_task(struct cgroup *cgrp, struct task_struct *task)
+static int cpuset_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+				  struct task_struct *task)
 {
 	return security_task_setscheduler(task);
 }
@@ -1418,7 +1419,8 @@ static void cpuset_pre_attach(struct cgr
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
@@ -7002,7 +7002,8 @@ static int __perf_cgroup_move(void *info
 }
 
 static void
-perf_cgroup_attach_task(struct cgroup *cgrp, struct task_struct *task)
+perf_cgroup_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+			struct task_struct *task)
 {
 	task_function_call(task, __perf_cgroup_move, task);
 }
@@ -7018,7 +7019,7 @@ static void perf_cgroup_exit(struct cgro
 	if (!(task->flags & PF_EXITING))
 		return;
 
-	perf_cgroup_attach_task(cgrp, task);
+	perf_cgroup_attach_task(cgrp, old_cgrp, task);
 }
 
 struct cgroup_subsys perf_subsys = {
diff -puN kernel/sched.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks kernel/sched.c
--- a/kernel/sched.c~cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks
+++ a/kernel/sched.c
@@ -8959,7 +8959,8 @@ cpu_cgroup_destroy(struct cgroup_subsys 
 }
 
 static int
-cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+cpu_cgroup_can_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+			   struct task_struct *tsk)
 {
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (!sched_rt_can_attach(cgroup_tg(cgrp), tsk))
@@ -8973,7 +8974,8 @@ cpu_cgroup_can_attach_task(struct cgroup
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
tracex86-add-tracepoint-to-x86-timer-interrupt-handler.patch
tracex86-add-x86-irq-vector-entry-exit-tracepoints.patch
cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-new-cancel_attach_task-subsystem-callback-fix.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
cgroups-add-res-counter-common-ancestor-searching-fix.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-documentation-for-task-counter-subsystem.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-convert-task-counter-to-use-the-subsys-fork-callback.patch

