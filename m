From: akpm@linux-foundation.org
Subject: + prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch added to -mm tree
Date: Fri, 13 Jan 2012 16:39:50 -0800
Message-ID: <20120114003950.D08115C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62089 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab2ANAjx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 19:39:53 -0500
Received: by eaad12 with SMTP id d12so30424eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 16:39:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lennart@poettering.net, Valdis.Kletnieks@vt.edu, kay.sievers@vrfy.org, oleg@redhat.com


The patch titled
     Subject: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process supervision
has been added to the -mm tree.  Its filename is
     prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lennart Poettering <lennart@poettering.net>
Subject: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process supervision

Userspace service managers/supervisors need to track their started
services.  Many services daemonize by double-forking and get implicitly
re-parented to PID 1.  The service manager will no longer be able to
receive the SIGCHLD signals for them, and is no longer in charge of
reaping the children with wait().  All information about the children is
lost at the moment PID 1 cleans up the re-parented processes.

With this prctl, a service manager process can mark itself as a sort of
'sub-init', able to stay as the parent for all orphaned processes created
by the started services.  All SIGCHLD signals will be delivered to the
service manager.

Receiving SIGCHLD and doing wait() is in cases of a service-manager much
preferred over any possible asynchronous notification about specific PIDs,
because the service manager has full access to the child process data in
/proc and the PID can not be re-used until the wait(), the service-manager
itself is in charge of, has happened.

As a side effect, the relevant parent PID information does not get lost by
a double-fork, which results in a more elaborate process tree and 'ps'
output:

before:
  # ps afx
  253 ?        Ss     0:00 /bin/dbus-daemon --system --nofork
  294 ?        Sl     0:00 /usr/libexec/polkit-1/polkitd
  328 ?        S      0:00 /usr/sbin/modem-manager
  608 ?        Sl     0:00 /usr/libexec/colord
  658 ?        Sl     0:00 /usr/libexec/upowerd
  819 ?        Sl     0:00 /usr/libexec/imsettings-daemon
  916 ?        Sl     0:00 /usr/libexec/udisks-daemon
  917 ?        S      0:00  \_ udisks-daemon: not polling any devices

after:
  # ps afx
  294 ?        Ss     0:00 /bin/dbus-daemon --system --nofork
  426 ?        Sl     0:00  \_ /usr/libexec/polkit-1/polkitd
  449 ?        S      0:00  \_ /usr/sbin/modem-manager
  635 ?        Sl     0:00  \_ /usr/libexec/colord
  705 ?        Sl     0:00  \_ /usr/libexec/upowerd
  959 ?        Sl     0:00  \_ /usr/libexec/udisks-daemon
  960 ?        S      0:00  |   \_ udisks-daemon: not polling any devices
  977 ?        Sl     0:00  \_ /usr/libexec/packagekitd

This prctl is orthogonal to PID namespaces.  PID namespaces are isolated
from each other, while a service management process usually requires the
services to live in the same namespace, to be able to talk to each other.

Users of this will be the systemd per-user instance, which provides
init-like functionality for the user's login session and D-Bus, which
activates bus services on-demand.  Both need init-like capabilities to be
able to properly keep track of the services they start.

Many thanks to Oleg for several rounds of review and insights.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prctl.h |    3 +++
 include/linux/sched.h |   12 ++++++++++++
 kernel/exit.c         |   28 +++++++++++++++++++++++-----
 kernel/fork.c         |    3 +++
 kernel/sys.c          |    8 ++++++++
 5 files changed, 49 insertions(+), 5 deletions(-)

diff -puN include/linux/prctl.h~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision include/linux/prctl.h
--- a/include/linux/prctl.h~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision
+++ a/include/linux/prctl.h
@@ -114,4 +114,7 @@
 # define PR_SET_MM_START_BRK		6
 # define PR_SET_MM_BRK			7
 
+#define PR_SET_CHILD_SUBREAPER 35
+#define PR_GET_CHILD_SUBREAPER 36
+
 #endif /* _LINUX_PRCTL_H */
diff -puN include/linux/sched.h~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision include/linux/sched.h
--- a/include/linux/sched.h~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision
+++ a/include/linux/sched.h
@@ -552,6 +552,18 @@ struct signal_struct {
 	int			group_stop_count;
 	unsigned int		flags; /* see SIGNAL_* flags below */
 
+	/*
+	 * PR_SET_CHILD_SUBREAPER marks a process, like a service
+	 * manager, to re-parent orphan (double-forking) child processes
+	 * to this process instead of 'init'. The service manager is
+	 * able to receive SIGCHLD signals and is able to investigate
+	 * the process until it calls wait(). All children of this
+	 * process will inherit a flag if they should look for a
+	 * child_subreaper process at exit.
+	 */
+	unsigned int		is_child_subreaper:1;
+	unsigned int		has_child_subreaper:1;
+
 	/* POSIX.1b Interval Timers */
 	struct list_head posix_timers;
 
diff -puN kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision kernel/exit.c
--- a/kernel/exit.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision
+++ a/kernel/exit.c
@@ -686,11 +686,12 @@ static void exit_mm(struct task_struct *
 }
 
 /*
- * When we die, we re-parent all our children.
- * Try to give them to another thread in our thread
- * group, and if no such member exists, give it to
- * the child reaper process (ie "init") in our pid
- * space.
+ * When we die, we re-parent all our children, and try to:
+ * 1. give them to another thread in our thread group, if such a
+ *    member exists
+ * 2. give it to the first anchestor process which prctl'd itself
+ *    as a child_subreaper for its children (like a service manager)
+ * 3. give it to the init process (PID 1) in our pid namespace
  */
 static struct task_struct *find_new_reaper(struct task_struct *father)
 	__releases(&tasklist_lock)
@@ -721,6 +722,23 @@ static struct task_struct *find_new_reap
 		 * forget_original_parent() must move them somewhere.
 		 */
 		pid_ns->child_reaper = init_pid_ns.child_reaper;
+	} else if (father->signal->has_child_subreaper) {
+		struct task_struct *reaper;
+
+		/* find the first ancestor marked as child_subreaper */
+		for (reaper = father->real_parent;
+		     reaper != &init_task;
+		     reaper = reaper->real_parent) {
+			if (same_thread_group(reaper, pid_ns->child_reaper))
+				break;
+			if (!reaper->signal->is_child_subreaper)
+				continue;
+			thread = reaper;
+			do {
+				if (!(thread->flags & PF_EXITING))
+					return reaper;
+			} while_each_thread(reaper, thread);
+		}
 	}
 
 	return pid_ns->child_reaper;
diff -puN kernel/fork.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision kernel/fork.c
--- a/kernel/fork.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision
+++ a/kernel/fork.c
@@ -996,6 +996,9 @@ static int copy_signal(unsigned long clo
 	sig->oom_score_adj = current->signal->oom_score_adj;
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
 
+	sig->has_child_subreaper = current->signal->has_child_subreaper ||
+				   current->signal->is_child_subreaper;
+
 	mutex_init(&sig->cred_guard_mutex);
 
 	return 0;
diff -puN kernel/sys.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision kernel/sys.c
--- a/kernel/sys.c~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision
+++ a/kernel/sys.c
@@ -1962,6 +1962,14 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		case PR_SET_MM:
 			error = prctl_set_mm(arg2, arg3, arg4, arg5);
 			break;
+		case PR_SET_CHILD_SUBREAPER:
+			me->signal->is_child_subreaper = !!arg2;
+			error = 0;
+			break;
+		case PR_GET_CHILD_SUBREAPER:
+			error = put_user(me->signal->is_child_subreaper,
+					 (int __user *) arg2);
+			break;
 		default:
 			error = -EINVAL;
 			break;
_
Subject: Subject: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process supervision

Patches currently in -mm which might be from lennart@poettering.net are

prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch

