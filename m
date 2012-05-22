From: akpm@linux-foundation.org
Subject: + pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2.patch added to -mm tree
Date: Tue, 22 May 2012 12:24:15 -0700
Message-ID: <20120522192416.784E3A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39039 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab2EVTYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 May 2012 15:24:18 -0400
Received: by ggeh3 with SMTP id h3so782187gge.1
        for <mm-commits@vger.kernel.org>; Tue, 22 May 2012 12:24:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, efault@gmx.de, gorcunov@openvz.org, louis.rilling@kerlabs.com, oleg@redhat.com, xemul@parallels.com


The patch titled
     Subject: pidns: guarantee that the pidns init will be the last pidns process reaped
has been added to the -mm tree.  Its filename is
     pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric W. Biederman <ebiederm@xmission.com>
Subject: pidns: guarantee that the pidns init will be the last pidns process reaped

Today we have a two-fold bug.  Sometimes release_task on pid == 1 in a pid
namespace can run before other processes in a pid namespace have had
release task called.  With the result that pid_ns_release_proc can be
called before the last proc_flush_task() is done using upid->ns->proc_mnt,
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
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c          |   13 ++++++++++++-
 kernel/pid_namespace.c |   11 +++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2 kernel/exit.c
--- a/kernel/exit.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2
+++ a/kernel/exit.c
@@ -64,15 +64,26 @@ static void exit_mm(struct task_struct *
 static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
-	detach_pid(p, PIDTYPE_PID);
 	if (group_dead) {
+		struct task_struct *parent;
+
 		detach_pid(p, PIDTYPE_PGID);
 		detach_pid(p, PIDTYPE_SID);
 
 		list_del_rcu(&p->tasks);
 		list_del_init(&p->sibling);
 		__this_cpu_dec(process_counts);
+
+		/* If we are the last child process in a pid namespace
+		 * to be reaped notify the child_reaper.
+		 */
+		parent = p->real_parent;
+		if ((task_active_pid_ns(p)->child_reaper == parent) &&
+		    list_empty(&parent->children) &&
+		    (parent->flags & PF_EXITING))
+			wake_up_process(parent);
 	}
+	detach_pid(p, PIDTYPE_PID);
 	list_del_rcu(&p->thread_group);
 }
 
diff -puN kernel/pid_namespace.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2 kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2
+++ a/kernel/pid_namespace.c
@@ -189,6 +189,17 @@ void zap_pid_ns_processes(struct pid_nam
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
+	read_lock(&tasklist_lock);
+	for (;;) {
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+		if (list_empty(&current->children))
+			break;
+		read_unlock(&tasklist_lock);
+		schedule();
+		read_lock(&tasklist_lock);
+	}
+	read_unlock(&tasklist_lock);
+
 	if (pid_ns->reboot)
 		current->signal->group_exit_code = pid_ns->reboot;
 
_
Subject: Subject: pidns: guarantee that the pidns init will be the last pidns process reaped

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
linux-next.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-make-killed-children-autoreap.patch
pidns-make-killed-children-autoreap-checkpatch-fixes.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2.patch
pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch

