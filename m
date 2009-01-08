From: akpm@linux-foundation.org
Subject: - pid-generalize-task_active_pid_ns.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:21 -0800
Message-ID: <200901082250.n08MoLn7029549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763374AbZAHWvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, Nadia.Derbey@bull.net, bastian@waldi.eu.org, oleg@redhat.com, roland@redhat.com, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org, mm-commits@vger


The patch titled
     pid: generalize task_active_pid_ns
has been removed from the -mm tree.  Its filename was
     pid-generalize-task_active_pid_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pid: generalize task_active_pid_ns
From: Eric W. Biederman <ebiederm@xmission.com>

Currently task_active_pid_ns is not safe to call after a task becomes a
zombie and exit_task_namespaces is called, as nsproxy becomes NULL.  By
reading the pid namespace from the pid of the task we can trivially solve
this problem at the cost of one extra memory read in what should be the
same cacheline as we read the namespace from.

When moving things around I have made task_active_pid_ns out of line
because keeping it in pid_namespace.h would require adding includes of
pid.h and sched.h that I don't think we want.

This change does make task_active_pid_ns unsafe to call during
copy_process until we attach a pid on the task_struct which seems to be a
reasonable trade off.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Bastian Blank <bastian@waldi.eu.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    6 +-----
 kernel/fork.c                 |    4 ++--
 kernel/pid.c                  |    6 ++++++
 3 files changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/pid_namespace.h~pid-generalize-task_active_pid_ns include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid-generalize-task_active_pid_ns
+++ a/include/linux/pid_namespace.h
@@ -79,11 +79,7 @@ static inline void zap_pid_ns_processes(
 }
 #endif /* CONFIG_PID_NS */
 
-static inline struct pid_namespace *task_active_pid_ns(struct task_struct *tsk)
-{
-	return tsk->nsproxy->pid_ns;
-}
-
+extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
 void pidhash_init(void);
 void pidmap_init(void);
 
diff -puN kernel/fork.c~pid-generalize-task_active_pid_ns kernel/fork.c
--- a/kernel/fork.c~pid-generalize-task_active_pid_ns
+++ a/kernel/fork.c
@@ -1126,12 +1126,12 @@ static struct task_struct *copy_process(
 
 	if (pid != &init_struct_pid) {
 		retval = -ENOMEM;
-		pid = alloc_pid(task_active_pid_ns(p));
+		pid = alloc_pid(p->nsproxy->pid_ns);
 		if (!pid)
 			goto bad_fork_cleanup_io;
 
 		if (clone_flags & CLONE_NEWPID) {
-			retval = pid_ns_prepare_proc(task_active_pid_ns(p));
+			retval = pid_ns_prepare_proc(p->nsproxy->pid_ns);
 			if (retval < 0)
 				goto bad_fork_free_pid;
 		}
diff -puN kernel/pid.c~pid-generalize-task_active_pid_ns kernel/pid.c
--- a/kernel/pid.c~pid-generalize-task_active_pid_ns
+++ a/kernel/pid.c
@@ -474,6 +474,12 @@ pid_t task_session_nr_ns(struct task_str
 }
 EXPORT_SYMBOL(task_session_nr_ns);
 
+struct pid_namespace *task_active_pid_ns(struct task_struct *tsk)
+{
+	return ns_of_pid(task_pid(tsk));
+}
+EXPORT_SYMBOL_GPL(task_active_pid_ns);
+
 /*
  * Used by proc to find the first pid that is greater than or equal to nr.
  *
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch

