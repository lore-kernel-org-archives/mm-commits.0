From: akpm@linux-foundation.org
Subject: + cgroups-convert-task-counter-to-use-the-subsys-fork-callback.patch added to -mm tree
Date: Tue, 06 Sep 2011 15:42:42 -0700
Message-ID: <201109062242.p86MghGD008343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755290Ab1IFWnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:43:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, kay.sievers@vrfy.org, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, tj@kernel.org


The patch titled
     cgroups: convert task counter to use the subsys fork callback
has been added to the -mm tree.  Its filename is
     cgroups-convert-task-counter-to-use-the-subsys-fork-callback.patch

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
Subject: cgroups: convert task counter to use the subsys fork callback
From: Frederic Weisbecker <fweisbec@gmail.com>

Instead of using an ad hoc hook on the fork path for the task counter, use
the subsystem fork callback that we can now use to cancel the fork.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h       |    9 ---------
 kernel/cgroup_task_counter.c |    3 ++-
 kernel/fork.c                |    4 ----
 3 files changed, 2 insertions(+), 14 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-convert-task-counter-to-use-the-subsys-fork-callback include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-convert-task-counter-to-use-the-subsys-fork-callback
+++ a/include/linux/cgroup.h
@@ -663,13 +663,4 @@ static inline int cgroup_attach_task_cur
 
 #endif /* !CONFIG_CGROUPS */
 
-#ifdef CONFIG_CGROUP_TASK_COUNTER
-int cgroup_task_counter_fork(struct task_struct *child);
-#else
-static inline int cgroup_task_counter_fork(struct task_struct *child)
-{
-	return 0;
-}
-#endif /* CONFIG_CGROUP_TASK_COUNTER */
-
 #endif /* _LINUX_CGROUP_H */
diff -puN kernel/cgroup_task_counter.c~cgroups-convert-task-counter-to-use-the-subsys-fork-callback kernel/cgroup_task_counter.c
--- a/kernel/cgroup_task_counter.c~cgroups-convert-task-counter-to-use-the-subsys-fork-callback
+++ a/kernel/cgroup_task_counter.c
@@ -168,7 +168,7 @@ static int task_counter_populate(struct 
 	return cgroup_add_files(cgrp, ss, files, ARRAY_SIZE(files));
 }
 
-int cgroup_task_counter_fork(struct task_struct *child)
+static int task_counter_fork(struct cgroup_subsys *ss, struct task_struct *child)
 {
 	struct cgroup_subsys_state *css = child->cgroups->subsys[tasks_subsys_id];
 	struct cgroup *cgrp = css->cgroup;
@@ -195,5 +195,6 @@ struct cgroup_subsys tasks_subsys = {
 	.can_attach_task	= task_counter_can_attach_task,
 	.cancel_attach_task	= task_counter_cancel_attach_task,
 	.attach_task		= task_counter_attach_task,
+	.fork			= task_counter_fork,
 	.populate		= task_counter_populate,
 };
diff -puN kernel/fork.c~cgroups-convert-task-counter-to-use-the-subsys-fork-callback kernel/fork.c
--- a/kernel/fork.c~cgroups-convert-task-counter-to-use-the-subsys-fork-callback
+++ a/kernel/fork.c
@@ -1335,10 +1335,6 @@ static struct task_struct *copy_process(
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
 
-	retval = cgroup_task_counter_fork(p);
-	if (retval)
-		goto bad_fork_free_pid;
-
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
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

