From: akpm@linux-foundation.org
Subject: + prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision.patch added to -mm tree
Date: Tue, 16 Aug 2011 13:11:38 -0700
Message-ID: <201108162011.p7GKBcY0023134__26527.8410086923$1313525548$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844Ab1HPUMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 16:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lennart@poettering.net, kay.sievers@vrfy.org, linux-man@vger.kernel.org, oleg@redhat.com, roland@hack.frob.com, torvalds@linux-foundation.org


The patch titled
     prctl: add PR_{SET,GET}_CHILD_REAPER to allow simple process supervision
has been added to the -mm tree.  Its filename is
     prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision.patch

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
Subject: prctl: add PR_{SET,GET}_CHILD_REAPER to allow simple process supervision
From: Lennart Poettering <lennart@poettering.net>

Userspace service managers/supervisors need to track their started
services.  Many services daemonize by double-forking and get implicitely
re-parented to PID 1.  The process manager will no longer be able to
receive the SIGCHLD signals for them.

With this prctl, a service manager can mark itself as a sort of 'sub-init'
process, able to stay as the parent process for all processes created by
the started services.  All SIGCHLD signals will be delivered to the
service manager.

As a side effect, the relevant parent PID information does not get lost by
a double-fork, which results in a more elaborate process tree and 'ps'
output.

This is orthogonal to PID namespaces.  PID namespaces are isolated from
each other, while a service management process usually requires the
serices to live in the same namespace, to be able to talk to each other.

Users of this will be the systemd per-user instance, which provides
init-like functionality for the user's login session and D-Bus, which
activates bus services on on-demand.  Both will need init-like
capabilities to be able to properly keep track of the services they start.

Signed-off-by: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-man@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prctl.h |    3 +++
 include/linux/sched.h |    2 ++
 kernel/exit.c         |    9 ++++++++-
 kernel/fork.c         |    2 ++
 kernel/sys.c          |    7 +++++++
 5 files changed, 22 insertions(+), 1 deletion(-)

diff -puN include/linux/prctl.h~prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision include/linux/prctl.h
--- a/include/linux/prctl.h~prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
+++ a/include/linux/prctl.h
@@ -102,4 +102,7 @@
 
 #define PR_MCE_KILL_GET 34
 
+#define PR_SET_CHILD_REAPER 35
+#define PR_GET_CHILD_REAPER 36
+
 #endif /* _LINUX_PRCTL_H */
diff -puN include/linux/sched.h~prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision include/linux/sched.h
--- a/include/linux/sched.h~prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
+++ a/include/linux/sched.h
@@ -1296,6 +1296,8 @@ struct task_struct {
 				 * execve */
 	unsigned in_iowait:1;
 
+	/* Reparent child processes to this process instead of pid 1. */
+	unsigned child_reaper:1;
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
diff -puN kernel/exit.c~prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision kernel/exit.c
--- a/kernel/exit.c~prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
+++ a/kernel/exit.c
@@ -701,7 +701,7 @@ static struct task_struct *find_new_reap
 	__acquires(&tasklist_lock)
 {
 	struct pid_namespace *pid_ns = task_active_pid_ns(father);
-	struct task_struct *thread;
+	struct task_struct *thread, *reaper;
 
 	thread = father;
 	while_each_thread(father, thread) {
@@ -712,6 +712,13 @@ static struct task_struct *find_new_reap
 		return thread;
 	}
 
+	/* find the first ancestor which is marked as child_reaper */
+	for (reaper = father->parent;
+	     reaper != &init_task && reaper != pid_ns->child_reaper;
+	     reaper = reaper->parent)
+		if (reaper->child_reaper)
+			return reaper;
+
 	if (unlikely(pid_ns->child_reaper == father)) {
 		write_unlock_irq(&tasklist_lock);
 		if (unlikely(pid_ns == &init_pid_ns))
diff -puN kernel/fork.c~prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision kernel/fork.c
--- a/kernel/fork.c~prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
+++ a/kernel/fork.c
@@ -1328,6 +1328,8 @@ static struct task_struct *copy_process(
 		p->parent_exec_id = current->self_exec_id;
 	}
 
+	p->child_reaper = 0;
+
 	spin_lock(&current->sighand->siglock);
 
 	/*
diff -puN kernel/sys.c~prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision kernel/sys.c
--- a/kernel/sys.c~prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
+++ a/kernel/sys.c
@@ -1800,6 +1800,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SET_CHILD_REAPER:
+			me->child_reaper = !!arg2;
+			error = 0;
+			break;
+		case PR_GET_CHILD_REAPER:
+			error = put_user(me->child_reaper, (int __user *) arg2);
+			break;
 		default:
 			error = -EINVAL;
 			break;
_

Patches currently in -mm which might be from lennart@poettering.net are

prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision.patch

