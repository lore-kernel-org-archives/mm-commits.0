From: akpm@linux-foundation.org
Subject: [merged] pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:42 -0700
Message-ID: <20120621192542.88AFFA00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:59484 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760086Ab2FUTZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:44 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so63386bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, avagin@gmail.com, efault@gmx.de, louis.rilling@kerlabs.com, oleg@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns: guarantee that the pidns init will be the last pidns process reaped
has been removed from the -mm tree.  Its filename was
     pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Eric W. Biederman <ebiederm@xmission.com>
Subject: pidns: guarantee that the pidns init will be the last pidns process reaped

Today we have a twofold bug.  Sometimes release_task on pid == 1 in a pid
namespace can run before other processes in a pid namespace have had
release task called.  With the result that pid_ns_release_proc can be
called before the last proc_flus_task() is done using upid->ns->proc_mnt,
resulting in the use of a stale pointer.  This same set of circumstances
can lead to waitpid(...) returning for a processes started with
clone(CLONE_NEWPID) before the every process in the pid namespace has
actually exited.

To fix this modify zap_pid_ns_processess wait until all other processes in
the pid namespace have exited, even EXIT_DEAD zombies.

The delay_group_leader and related tests ensure that the thread gruop
leader will be the last thread of a process group to be reaped, or to
become EXIT_DEAD and self reap.  With the change to zap_pid_ns_processes
we get the guarantee that pid == 1 in a pid namespace will be the last
task that release_task is called on.

With pid == 1 being the last task to pass through release_task
pid_ns_release_proc can no longer be called too early nor can wait return
before all of the EXIT_DEAD tasks in a pid namespace have exited.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Mike Galbraith <efault@gmx.de>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Tested-by: Andrew Wagin <avagin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c          |   14 +++++++++++++-
 kernel/pid_namespace.c |   20 ++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped kernel/exit.c
--- a/kernel/exit.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped
+++ a/kernel/exit.c
@@ -64,7 +64,6 @@ static void exit_mm(struct task_struct *
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
-	detach_pid(p, PIDTYPE_PID);
 	if (group_dead) {
 		detach_pid(p, PIDTYPE_PGID);
 		detach_pid(p, PIDTYPE_SID);
@@ -72,7 +71,20 @@ static void __unhash_process(struct task
 		list_del_rcu(&p->tasks);
 		list_del_init(&p->sibling);
 		__this_cpu_dec(process_counts);
+		/*
+		 * If we are the last child process in a pid namespace to be
+		 * reaped, notify the reaper sleeping zap_pid_ns_processes().
+		 */
+		if (IS_ENABLED(CONFIG_PID_NS)) {
+			struct task_struct *parent = p->real_parent;
+
+			if ((task_active_pid_ns(p)->child_reaper == parent) &&
+			    list_empty(&parent->children) &&
+			    (parent->flags & PF_EXITING))
+				wake_up_process(parent);
+		}
 	}
+	detach_pid(p, PIDTYPE_PID);
 	list_del_rcu(&p->thread_group);
 }
 
diff -puN kernel/pid_namespace.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped
+++ a/kernel/pid_namespace.c
@@ -184,11 +184,31 @@ void zap_pid_ns_processes(struct pid_nam
 	}
 	read_unlock(&tasklist_lock);
 
+	/* Firstly reap the EXIT_ZOMBIE children we may have. */
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
+	/*
+	 * sys_wait4() above can't reap the TASK_DEAD children.
+	 * Make sure they all go away, see __unhash_process().
+	 */
+	for (;;) {
+		bool need_wait = false;
+
+		read_lock(&tasklist_lock);
+		if (!list_empty(&current->children)) {
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+			need_wait = true;
+		}
+		read_unlock(&tasklist_lock);
+
+		if (!need_wait)
+			break;
+		schedule();
+	}
+
 	if (pid_ns->reboot)
 		current->signal->group_exit_code = pid_ns->reboot;
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
linux-next.patch
c-r-fcntl-add-f_getowner_uids-option.patch

