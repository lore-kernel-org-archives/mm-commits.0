From: akpm@linux-foundation.org
Subject: [to-be-updated] pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped.patch removed from -mm tree
Date: Tue, 22 May 2012 12:08:08 -0700
Message-ID: <20120522190811.1A949A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:51487 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2EVTIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 May 2012 15:08:14 -0400
Received: by yhgm50 with SMTP id m50so922813yhg.1
        for <mm-commits@vger.kernel.org>; Tue, 22 May 2012 12:08:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, efault@gmx.de, gorcunov@openvz.org, louis.rilling@kerlabs.com, oleg@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns: guarantee that the pidns init will be the last pidns process reaped
has been removed from the -mm tree.  Its filename was
     pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Eric W. Biederman <ebiederm@xmission.com>
Subject: pidns: guarantee that the pidns init will be the last pidns process reaped

This change extends the thread group zombie leader logic to work for pid
namespaces.  The task with pid 1 is declared the pid namespace leader.  A
pid namespace with no more processes is detected by observing that the
init task is a zombie in an empty thread group, and the the init task has
no children.

Instead of moving lingering EXIT_DEAD tasks off of init's ->children list
we now block init from exiting until those children have self reaped and
have removed themselves.  Which guarantees that the init task is the last
task in a pid namespace to be reaped.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff -puN kernel/exit.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped kernel/exit.c
--- a/kernel/exit.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped
+++ a/kernel/exit.c
@@ -164,6 +164,16 @@ static void delayed_put_task_struct(stru
 	put_task_struct(tsk);
 }
 
+static bool pidns_leader(struct task_struct *tsk)
+{
+	return is_child_reaper(task_pid(tsk));
+}
+
+static bool delay_pidns_leader(struct task_struct *tsk)
+{
+	return pidns_leader(tsk) &&
+	       (!thread_group_empty(tsk) || !list_empty(&tsk->children));
+}
 
 void release_task(struct task_struct * p)
 {
@@ -183,15 +193,23 @@ repeat:
 	__exit_signal(p);
 
 	/*
-	 * If we are the last non-leader member of the thread
-	 * group, and the leader is zombie, then notify the
-	 * group leader's parent process. (if it wants notification.)
+	 * If we are the last non-leader member of the thread group,
+	 * or the last non-leader member of the pid namespace, and the
+	 * leader is zombie, then notify the leader's parent
+	 * process. (if it wants notification.)
 	 */
 	zap_leader = 0;
-	leader = p->group_leader;
-	if (leader != p && thread_group_empty(leader) && leader->exit_state == EXIT_ZOMBIE) {
+	leader = NULL;
+	/* Do we need to worry about our thread_group or our pidns leader? */
+	if (p != p->group_leader)
+		leader = p->group_leader;
+	else if (pidns_leader(p->real_parent))
+		leader = p->real_parent;
+
+	if (leader && thread_group_empty(leader) &&
+	    leader->exit_state == EXIT_ZOMBIE && list_empty(&leader->children)) {
 		/*
-		 * If we were the last child thread and the leader has
+		 * If we were the last task in the group and the leader has
 		 * exited already, and the leader's parent ignores SIGCHLD,
 		 * then we are the one who should release the leader.
 		 */
@@ -720,11 +738,10 @@ static struct task_struct *find_new_reap
 		zap_pid_ns_processes(pid_ns);
 		write_lock_irq(&tasklist_lock);
 		/*
-		 * We can not clear ->child_reaper or leave it alone.
-		 * There may by stealth EXIT_DEAD tasks on ->children,
-		 * forget_original_parent() must move them somewhere.
+		 * Move all lingering EXIT_DEAD tasks onto the
+		 * children list of init's thread group leader.
 		 */
-		pid_ns->child_reaper = init_pid_ns.child_reaper;
+		pid_ns->child_reaper = father->group_leader;
 	} else if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 
@@ -798,6 +815,12 @@ static void forget_original_parent(struc
 	exit_ptrace(father);
 	reaper = find_new_reaper(father);
 
+	/* Return immediately if we aren't going to reparent anything */
+	if (unlikely(reaper == father)) {
+		write_unlock_irq(&tasklist_lock);
+		return;
+	}
+
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		struct task_struct *t = p;
 		do {
@@ -853,6 +876,7 @@ static void exit_notify(struct task_stru
 		autoreap = do_notify_parent(tsk, sig);
 	} else if (thread_group_leader(tsk)) {
 		autoreap = thread_group_empty(tsk) &&
+			!delay_pidns_leader(tsk) &&
 			do_notify_parent(tsk, tsk->exit_signal);
 	} else {
 		autoreap = true;
@@ -1583,7 +1607,7 @@ static int wait_consider_task(struct wai
 		}
 
 		/* we don't reap group leaders with subthreads */
-		if (!delay_group_leader(p))
+		if (!delay_group_leader(p) && !delay_pidns_leader(p))
 			return wait_task_zombie(wo, p);
 
 		/*
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
linux-next.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-make-killed-children-autoreap.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch

