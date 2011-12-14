From: akpm@linux-foundation.org
Subject: [obsolete] cgroup-fix-task-counter-common-ancestor-logic.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:06:51 -0800
Message-ID: <20111214200652.006251E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:38970 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1LNUGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:06:52 -0500
Received: by mail-gy0-f202.google.com with SMTP id f20so133516ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:06:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, bblum@andrew.cmu.edu, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, paul@paulmenage.org, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroup: Fix task counter common ancestor logic
has been removed from the -mm tree.  Its filename was
     cgroup-fix-task-counter-common-ancestor-logic.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: cgroup: Fix task counter common ancestor logic

The task counter subsystem has been written assuming that
can_attach_task/attach_task/cancel_attach_task calls are serialized per
task.  This is true when we attach only one task but not when we attach a
whole thread group, in which case the sequence is:

	for each thread
		if (can_attach_task() < 0)
			goto rollback

	for each_thread
		attach_task()

rollback:
	for each thread
		cancel_attach_task()

The common ancestor, searched on task_counter_attach_task(), can thus
change between each of these calls for a given task.  This breaks if some
tasks in the thread group are not in the same cgroup origin.  The uncharge
made in attach_task() or the rollback in cancel_attach_task() there would
have an erroneous propagation.

This can even break seriously is some scenario. For example there
with $PID beeing the pid of a multithread process:

	mkdir /dev/cgroup/cgroup0
	echo $PID > /dev/cgroup/cgroup0/cgroup.procs
	echo $PID > /dev/cgroup/tasks
	echo $PID > /dev/cgroup/cgroup0/cgroup.procs

On the last move, attach_task() is called on the thread leader with
the wrong common_ancestor, leading to a crash because we uncharge
a res_counter that doesn't exist:

	[  149.805063] BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
	[  149.806013] IP: [<ffffffff810a0172>] __lock_acquire+0x62/0x15d0
	[  149.806013] PGD 51d38067 PUD 5119e067 PMD 0
	[  149.806013] Oops: 0000 [#1] PREEMPT SMP
	[  149.806013] Dumping ftrace buffer:
	[  149.806013]    (ftrace buffer empty)
	[  149.806013] CPU 3
	[  149.806013] Modules linked in:
	[  149.806013]
	[  149.806013] Pid: 1111, comm: spread_thread_g Not tainted 3.1.0-rc3+ #165 FUJITSU SIEMENS AMD690VM-FMH/AMD690VM-FMH
	[  149.806013] RIP: 0010:[<ffffffff810a0172>]  [<ffffffff810a0172>] __lock_acquire+0x62/0x15d0
	[  149.806013] RSP: 0018:ffff880051479b38  EFLAGS: 00010046
	[  149.806013] RAX: 0000000000000046 RBX: 0000000000000040 RCX: 0000000000000000
	[  149.868002] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000040
	[  149.868002] RBP: ffff880051479c08 R08: 0000000000000002 R09: 0000000000000001
	[  149.868002] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
	[  149.868002] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880051f120a0
	[  149.868002] FS:  00007f1e01dd7700(0000) GS:ffff880057d80000(0000) knlGS:0000000000000000
	[  149.868002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	[  149.868002] CR2: 0000000000000040 CR3: 0000000051c59000 CR4: 00000000000006e0
	[  149.868002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
	[  149.868002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
	[  149.868002] Process spread_thread_g (pid: 1111, threadinfo ffff880051478000, task ffff880051f120a0)
	[  149.868002] Stack:
	[  149.868002]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	[  149.868002]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	[  149.868002]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	[  149.868002] Call Trace:
	[  149.868002]  [<ffffffff810a1d32>] lock_acquire+0xa2/0x1a0
	[  149.868002]  [<ffffffff810c373c>] ? res_counter_uncharge_until+0x4c/0xb0
	[  149.868002]  [<ffffffff8180802b>] _raw_spin_lock+0x3b/0x50
	[  149.868002]  [<ffffffff810c373c>] ? res_counter_uncharge_until+0x4c/0xb0
	[  149.868002]  [<ffffffff810c373c>] res_counter_uncharge_until+0x4c/0xb0
	[  149.868002]  [<ffffffff810c26c4>] task_counter_attach_task+0x44/0x50
	[  149.868002]  [<ffffffff810bffcd>] cgroup_attach_proc+0x5ad/0x720
	[  149.868002]  [<ffffffff810bfa99>] ? cgroup_attach_proc+0x79/0x720
	[  149.868002]  [<ffffffff810c01cf>] attach_task_by_pid+0x8f/0x220
	[  149.868002]  [<ffffffff810c0230>] ? attach_task_by_pid+0xf0/0x220
	[  149.868002]  [<ffffffff810c0230>] ? attach_task_by_pid+0xf0/0x220
	[  149.868002]  [<ffffffff810c0388>] cgroup_procs_write+0x28/0x40
	[  149.868002]  [<ffffffff810c0bd9>] cgroup_file_write+0x209/0x2f0
	[  149.868002]  [<ffffffff812b8d08>] ? apparmor_file_permission+0x18/0x20
	[  149.868002]  [<ffffffff8127ef43>] ? security_file_permission+0x23/0x90
	[  149.868002]  [<ffffffff81157038>] vfs_write+0xc8/0x190
	[  149.868002]  [<ffffffff811571f1>] sys_write+0x51/0x90
	[  149.868002]  [<ffffffff818102c2>] system_call_fastpath+0x16/0x1b

To solve this, keep the original cgroup of each thread in the thread
group cached in the flex array and pass it to can_attach_task()/attach_task()
and cancel_attach_task() so that the correct common ancestor between the old
and new cgroup can be safely retrieved for each task.

This is inspired by a previous patch from Li Zefan:
"[PATCH] cgroups: don't cache common ancestor in task counter subsys".

Reported-by: Ben Blum <bblum@andrew.cmu.edu>
Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroups.txt |    3 +
 include/linux/cgroup.h            |    2 -
 kernel/cgroup.c                   |   48 ++++++++++++++++------------
 kernel/cgroup_task_counter.c      |   26 ++++++++-------
 4 files changed, 47 insertions(+), 32 deletions(-)

diff -puN Documentation/cgroups/cgroups.txt~cgroup-fix-task-counter-common-ancestor-logic Documentation/cgroups/cgroups.txt
--- a/Documentation/cgroups/cgroups.txt~cgroup-fix-task-counter-common-ancestor-logic
+++ a/Documentation/cgroups/cgroups.txt
@@ -623,7 +623,8 @@ function, so that the subsystem can impl
 This will be called only about subsystems whose can_attach() operation have
 succeeded.
 
-void cancel_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
+void cancel_attach_task(struct cgroup *cgrp, struct cgroup *old_cgrp,
+			struct task_struct *tsk)
 (cgroup_mutex held by caller)
 
 As cancel_attach, but for operations that must be cancelled once per
diff -puN include/linux/cgroup.h~cgroup-fix-task-counter-common-ancestor-logic include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroup-fix-task-counter-common-ancestor-logic
+++ a/include/linux/cgroup.h
@@ -475,7 +475,7 @@ struct cgroup_subsys {
 			       struct task_struct *tsk);
 	void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
 			      struct task_struct *tsk);
-	void (*cancel_attach_task)(struct cgroup *cgrp,
+	void (*cancel_attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp,
 				   struct task_struct *tsk);
 	void (*pre_attach)(struct cgroup *cgrp);
 	void (*attach_task)(struct cgroup *cgrp, struct cgroup *old_cgrp,
diff -puN kernel/cgroup.c~cgroup-fix-task-counter-common-ancestor-logic kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-fix-task-counter-common-ancestor-logic
+++ a/kernel/cgroup.c
@@ -1885,7 +1885,7 @@ out:
 				break;
 
 			if (ss->cancel_attach_task)
-				ss->cancel_attach_task(cgrp, tsk);
+				ss->cancel_attach_task(cgrp, oldcgrp, tsk);
 			if (ss->cancel_attach)
 				ss->cancel_attach(ss, cgrp, tsk);
 		}
@@ -1983,6 +1983,11 @@ static int css_set_prefetch(struct cgrou
 	return 0;
 }
 
+struct task_cgroup {
+	struct task_struct *tsk;
+	struct cgroup *oldcgrp;
+};
+
 /**
  * cgroup_attach_proc - attach all threads in a threadgroup to a cgroup
  * @cgrp: the cgroup to attach to
@@ -2003,6 +2008,7 @@ int cgroup_attach_proc(struct cgroup *cg
 	/* threadgroup list cursor and array */
 	struct task_struct *tsk;
 	struct flex_array *group;
+	struct task_cgroup *tc;
 	/*
 	 * we need to make sure we have css_sets for all the tasks we're
 	 * going to move -before- we actually start moving them, so that in
@@ -2020,7 +2026,7 @@ int cgroup_attach_proc(struct cgroup *cg
 	 */
 	group_size = get_nr_threads(leader);
 	/* flex_array supports very large thread-groups better than kmalloc. */
-	group = flex_array_alloc(sizeof(struct task_struct *), group_size,
+	group = flex_array_alloc(sizeof(struct task_cgroup), group_size,
 				 GFP_KERNEL);
 	if (!group)
 		return -ENOMEM;
@@ -2047,14 +2053,18 @@ int cgroup_attach_proc(struct cgroup *cg
 	tsk = leader;
 	i = 0;
 	do {
+		struct task_cgroup tsk_cgrp;
+
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
 		get_task_struct(tsk);
+		tsk_cgrp.tsk = tsk;
+		tsk_cgrp.oldcgrp = task_cgroup_from_root(tsk, root);
 		/*
 		 * saying GFP_ATOMIC has no effect here because we did prealloc
 		 * earlier, but it's good form to communicate our expectations.
 		 */
-		retval = flex_array_put_ptr(group, i, tsk, GFP_ATOMIC);
+		retval = flex_array_put(group, i, &tsk_cgrp, GFP_ATOMIC);
 		BUG_ON(retval != 0);
 		i++;
 	} while_each_thread(leader, tsk);
@@ -2077,14 +2087,13 @@ int cgroup_attach_proc(struct cgroup *cg
 		if (ss->can_attach_task) {
 			/* run on each task in the threadgroup. */
 			for (i = 0; i < group_size; i++) {
-				tsk = flex_array_get_ptr(group, i);
-				oldcgrp = task_cgroup_from_root(tsk, root);
-
+				tc = flex_array_get(group, i);
 				retval = ss->can_attach_task(cgrp,
-							     oldcgrp, tsk);
+							     tc->oldcgrp,
+							     tc->tsk);
 				if (retval) {
 					failed_ss = ss;
-					failed_task = tsk;
+					failed_task = tc->tsk;
 					goto out_cancel_attach;
 				}
 			}
@@ -2097,10 +2106,10 @@ int cgroup_attach_proc(struct cgroup *cg
 	 */
 	INIT_LIST_HEAD(&newcg_list);
 	for (i = 0; i < group_size; i++) {
-		tsk = flex_array_get_ptr(group, i);
+		tc = flex_array_get(group, i);
+		tsk = tc->tsk;
 		/* nothing to do if this task is already in the cgroup */
-		oldcgrp = task_cgroup_from_root(tsk, root);
-		if (cgrp == oldcgrp)
+		if (cgrp == tc->oldcgrp)
 			continue;
 		/* get old css_set pointer */
 		task_lock(tsk);
@@ -2136,9 +2145,10 @@ int cgroup_attach_proc(struct cgroup *cg
 			ss->pre_attach(cgrp);
 	}
 	for (i = 0; i < group_size; i++) {
-		tsk = flex_array_get_ptr(group, i);
+		tc = flex_array_get(group, i);
+		tsk = tc->tsk;
+		oldcgrp = tc->oldcgrp;
 		/* leave current thread as it is if it's already there */
-		oldcgrp = task_cgroup_from_root(tsk, root);
 		if (cgrp == oldcgrp)
 			continue;
 		/* if the thread is PF_EXITING, it can just get skipped. */
@@ -2151,7 +2161,7 @@ int cgroup_attach_proc(struct cgroup *cg
 			}
 		} else if (retval == -ESRCH) {
 			if (ss->cancel_attach_task)
-				ss->cancel_attach_task(cgrp, tsk);
+				ss->cancel_attach_task(cgrp, oldcgrp, tsk);
 		} else {
 			BUG_ON(1);
 		}
@@ -2188,10 +2198,10 @@ out_cancel_attach:
 			if (ss->cancel_attach_task && (ss != failed_ss ||
 						       failed_task)) {
 				for (i = 0; i < group_size; i++) {
-					tsk = flex_array_get_ptr(group, i);
-					if (tsk == failed_task)
+					tc = flex_array_get(group, i);
+					if (tc->tsk == failed_task)
 						break;
-					ss->cancel_attach_task(cgrp, tsk);
+					ss->cancel_attach_task(cgrp, tc->oldcgrp, tc->tsk);
 				}
 			}
 
@@ -2206,8 +2216,8 @@ out_cancel_attach:
 	}
 	/* clean up the array of referenced threads in the group. */
 	for (i = 0; i < group_size; i++) {
-		tsk = flex_array_get_ptr(group, i);
-		put_task_struct(tsk);
+		tc = flex_array_get(group, i);
+		put_task_struct(tc->tsk);
 	}
 out_free_group_list:
 	flex_array_free(group);
diff -puN kernel/cgroup_task_counter.c~cgroup-fix-task-counter-common-ancestor-logic kernel/cgroup_task_counter.c
--- a/kernel/cgroup_task_counter.c~cgroup-fix-task-counter-common-ancestor-logic
+++ a/kernel/cgroup_task_counter.c
@@ -95,12 +95,6 @@ static void task_counter_exit(struct cgr
 }
 
 /*
- * Protected amongst can_attach_task/attach_task/cancel_attach_task by
- * cgroup mutex
- */
-static struct res_counter *common_ancestor;
-
-/*
  * This does more than just probing the ability to attach to the dest cgroup.
  * We can not just _check_ if we can attach to the destination and do the real
  * attachment later in task_counter_attach_task() because a task in the dest
@@ -111,9 +105,10 @@ static int task_counter_can_attach_task(
 					struct cgroup *old_cgrp,
 					struct task_struct *tsk)
 {
+	int err;
+	struct res_counter *common_ancestor;
 	struct res_counter *res = cgroup_task_res_counter(cgrp);
 	struct res_counter *old_res = cgroup_task_res_counter(old_cgrp);
-	int err;
 
 	/*
 	 * When moving a task from a cgroup to another, we don't want
@@ -138,10 +133,15 @@ static int task_counter_can_attach_task(
 
 /* Uncharge the dest cgroup that we charged in task_counter_can_attach_task() */
 static void task_counter_cancel_attach_task(struct cgroup *cgrp,
+					    struct cgroup *old_cgrp,
 					    struct task_struct *tsk)
 {
-	res_counter_uncharge_until(cgroup_task_res_counter(cgrp),
-				   common_ancestor, 1);
+	struct res_counter *common_ancestor;
+	struct res_counter *res = cgroup_task_res_counter(cgrp);
+	struct res_counter *old_res = cgroup_task_res_counter(old_cgrp);
+
+	common_ancestor = res_counter_common_ancestor(res, old_res);
+	res_counter_uncharge_until(res, common_ancestor, 1);
 }
 
 /*
@@ -155,8 +155,12 @@ static void task_counter_attach_task(str
 				     struct cgroup *old_cgrp,
 				     struct task_struct *tsk)
 {
-	res_counter_uncharge_until(cgroup_task_res_counter(old_cgrp),
-				   common_ancestor, 1);
+	struct res_counter *common_ancestor;
+	struct res_counter *res = cgroup_task_res_counter(cgrp);
+	struct res_counter *old_res = cgroup_task_res_counter(old_cgrp);
+
+	common_ancestor = res_counter_common_ancestor(res, old_res);
+	res_counter_uncharge_until(old_res, common_ancestor, 1);
 }
 
 static u64 task_counter_read_u64(struct cgroup *cgrp, struct cftype *cft)
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
reiserfs-delay-reiserfs-lock-until-journal-initialization.patch
reiserfs-dont-lock-journal_init.patch
reiserfs-dont-lock-root-inode-searching.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
selftests-new-x86-breakpoints-selftest.patch

