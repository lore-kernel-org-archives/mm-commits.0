From: akpm@linux-foundation.org
Subject: [merged] prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:25 -0700
Message-ID: <20120326192825.9F6CCA0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:46715 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2CZT21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:27 -0400
Received: by mail-fa0-f74.google.com with SMTP id a19so298392faa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lennart@poettering.net, Valdis.Kletnieks@vt.edu, kay.sievers@vrfy.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl: add PR_{SET,GET}_CHILD_SUBREAPER to allow simple process supervision
has been removed from the -mm tree.  Its filename was
     prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

[akpm@linux-foundation.org: fix comment layout and spelling]
[akpm@linux-foundation.org: add lengthy code comment from Oleg]
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prctl.h |    3 +++
 include/linux/sched.h |   12 ++++++++++++
 kernel/exit.c         |   33 ++++++++++++++++++++++++++++-----
 kernel/fork.c         |    3 +++
 kernel/sys.c          |    8 ++++++++
 5 files changed, 54 insertions(+), 5 deletions(-)

diff -puN include/linux/prctl.h~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision include/linux/prctl.h
--- a/include/linux/prctl.h~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision
+++ a/include/linux/prctl.h
@@ -121,4 +121,7 @@
 #define PR_SET_PTRACER 0x59616d61
 # define PR_SET_PTRACER_ANY ((unsigned long)-1)
 
+#define PR_SET_CHILD_SUBREAPER 36
+#define PR_GET_CHILD_SUBREAPER 37
+
 #endif /* _LINUX_PRCTL_H */
diff -puN include/linux/sched.h~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision include/linux/sched.h
--- a/include/linux/sched.h~prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision
+++ a/include/linux/sched.h
@@ -553,6 +553,18 @@ struct signal_struct {
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
@@ -687,11 +687,11 @@ static void exit_mm(struct task_struct *
 }
 
 /*
- * When we die, we re-parent all our children.
- * Try to give them to another thread in our thread
- * group, and if no such member exists, give it to
- * the child reaper process (ie "init") in our pid
- * space.
+ * When we die, we re-parent all our children, and try to:
+ * 1. give them to another thread in our thread group, if such a member exists
+ * 2. give it to the first ancestor process which prctl'd itself as a
+ *    child_subreaper for its children (like a service manager)
+ * 3. give it to the init process (PID 1) in our pid namespace
  */
 static struct task_struct *find_new_reaper(struct task_struct *father)
 	__releases(&tasklist_lock)
@@ -722,6 +722,29 @@ static struct task_struct *find_new_reap
 		 * forget_original_parent() must move them somewhere.
 		 */
 		pid_ns->child_reaper = init_pid_ns.child_reaper;
+	} else if (father->signal->has_child_subreaper) {
+		struct task_struct *reaper;
+
+		/*
+		 * Find the first ancestor marked as child_subreaper.
+		 * Note that the code below checks same_thread_group(reaper,
+		 * pid_ns->child_reaper).  This is what we need to DTRT in a
+		 * PID namespace. However we still need the check above, see
+		 * http://marc.info/?l=linux-kernel&m=131385460420380
+		 */
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
@@ -1051,6 +1051,9 @@ static int copy_signal(unsigned long clo
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

Patches currently in -mm which might be from lennart@poettering.net are

origin.patch

