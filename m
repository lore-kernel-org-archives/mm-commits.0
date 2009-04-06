From: akpm@linux-foundation.org
Subject: [merged] pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:30 -0700
Message-ID: <200904061936.n36JaU5s012493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757737AbZDFTn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, clg@fr.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com, number6@the-village.bc.nu, roland@redhat.com, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, xemul@openvz.or


The patch titled
     pids: kill signal_struct-> __pgrp/__session and friends
has been removed from the -mm tree.  Its filename was
     pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pids: kill signal_struct-> __pgrp/__session and friends
From: Oleg Nesterov <oleg@redhat.com>

We are wasting 2 words in signal_struct without any reason to implement
task_pgrp_nr() and task_session_nr().

task_session_nr() has no callers since
2e2ba22ea4fd4bb85f0fa37c521066db6775cbef, we can remove it.

task_pgrp_nr() is still (I believe wrongly) used in fs/autofsX and
fs/coda.

This patch reimplements task_pgrp_nr() via task_pgrp_nr_ns(), and kills
__pgrp/__session and the related helpers.

The change in drivers/char/tty_io.c is cosmetic, but hopefully makes sense
anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Alan Cox <number6@the-village.bc.nu>		[tty parts]
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |    4 +--
 include/linux/sched.h |   43 +++++-----------------------------------
 kernel/exit.c         |   10 ++-------
 kernel/fork.c         |    2 -
 kernel/sys.c          |    4 ---
 5 files changed, 12 insertions(+), 51 deletions(-)

diff -puN drivers/char/tty_io.c~pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends
+++ a/drivers/char/tty_io.c
@@ -2681,7 +2681,7 @@ void __do_SAK(struct tty_struct *tty)
 	/* Kill the entire session */
 	do_each_pid_task(session, PIDTYPE_SID, p) {
 		printk(KERN_NOTICE "SAK: killed process %d"
-			" (%s): task_session_nr(p)==tty->session\n",
+			" (%s): task_session(p)==tty->session\n",
 			task_pid_nr(p), p->comm);
 		send_sig(SIGKILL, p, 1);
 	} while_each_pid_task(session, PIDTYPE_SID, p);
@@ -2691,7 +2691,7 @@ void __do_SAK(struct tty_struct *tty)
 	do_each_thread(g, p) {
 		if (p->signal->tty == tty) {
 			printk(KERN_NOTICE "SAK: killed process %d"
-			    " (%s): task_session_nr(p)==tty->session\n",
+			    " (%s): task_session(p)==tty->session\n",
 			    task_pid_nr(p), p->comm);
 			send_sig(SIGKILL, p, 1);
 			continue;
diff -puN include/linux/sched.h~pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends include/linux/sched.h
--- a/include/linux/sched.h~pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends
+++ a/include/linux/sched.h
@@ -547,25 +547,8 @@ struct signal_struct {
 
 	struct list_head cpu_timers[3];
 
-	/* job control IDs */
-
-	/*
-	 * pgrp and session fields are deprecated.
-	 * use the task_session_Xnr and task_pgrp_Xnr routines below
-	 */
-
-	union {
-		pid_t pgrp __deprecated;
-		pid_t __pgrp;
-	};
-
 	struct pid *tty_old_pgrp;
 
-	union {
-		pid_t session __deprecated;
-		pid_t __session;
-	};
-
 	/* boolean value for session group leader */
 	int leader;
 
@@ -1469,16 +1452,6 @@ static inline int rt_task(struct task_st
 	return rt_prio(p->prio);
 }
 
-static inline void set_task_session(struct task_struct *tsk, pid_t session)
-{
-	tsk->signal->__session = session;
-}
-
-static inline void set_task_pgrp(struct task_struct *tsk, pid_t pgrp)
-{
-	tsk->signal->__pgrp = pgrp;
-}
-
 static inline struct pid *task_pid(struct task_struct *task)
 {
 	return task->pids[PIDTYPE_PID].pid;
@@ -1552,11 +1525,6 @@ static inline pid_t task_tgid_vnr(struct
 }
 
 
-static inline pid_t task_pgrp_nr(struct task_struct *tsk)
-{
-	return tsk->signal->__pgrp;
-}
-
 static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
@@ -1569,11 +1537,6 @@ static inline pid_t task_pgrp_vnr(struct
 }
 
 
-static inline pid_t task_session_nr(struct task_struct *tsk)
-{
-	return tsk->signal->__session;
-}
-
 static inline pid_t task_session_nr_ns(struct task_struct *tsk,
 					struct pid_namespace *ns)
 {
@@ -1585,6 +1548,12 @@ static inline pid_t task_session_vnr(str
 	return __task_pid_nr_ns(tsk, PIDTYPE_SID, NULL);
 }
 
+/* obsolete, do not use */
+static inline pid_t task_pgrp_nr(struct task_struct *tsk)
+{
+	return task_pgrp_nr_ns(tsk, &init_pid_ns);
+}
+
 /**
  * pid_alive - check that a task structure is not stale
  * @p: Task structure to be checked.
diff -puN kernel/exit.c~pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends kernel/exit.c
--- a/kernel/exit.c~pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends
+++ a/kernel/exit.c
@@ -357,16 +357,12 @@ static void reparent_to_kthreadd(void)
 void __set_special_pids(struct pid *pid)
 {
 	struct task_struct *curr = current->group_leader;
-	pid_t nr = pid_nr(pid);
 
-	if (task_session(curr) != pid) {
+	if (task_session(curr) != pid)
 		change_pid(curr, PIDTYPE_SID, pid);
-		set_task_session(curr, nr);
-	}
-	if (task_pgrp(curr) != pid) {
+
+	if (task_pgrp(curr) != pid)
 		change_pid(curr, PIDTYPE_PGID, pid);
-		set_task_pgrp(curr, nr);
-	}
 }
 
 static void set_special_pids(struct pid *pid)
diff -puN kernel/fork.c~pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends kernel/fork.c
--- a/kernel/fork.c~pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends
+++ a/kernel/fork.c
@@ -1265,8 +1265,6 @@ static struct task_struct *copy_process(
 			p->signal->leader_pid = pid;
 			tty_kref_put(p->signal->tty);
 			p->signal->tty = tty_kref_get(current->signal->tty);
-			set_task_pgrp(p, task_pgrp_nr(current));
-			set_task_session(p, task_session_nr(current));
 			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
 			attach_pid(p, PIDTYPE_SID, task_session(current));
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
diff -puN kernel/sys.c~pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends kernel/sys.c
--- a/kernel/sys.c~pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends
+++ a/kernel/sys.c
@@ -1013,10 +1013,8 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid
 	if (err)
 		goto out;
 
-	if (task_pgrp(p) != pgrp) {
+	if (task_pgrp(p) != pgrp)
 		change_pid(p, PIDTYPE_PGID, pgrp);
-		set_task_pgrp(p, pid_nr(pgrp));
-	}
 
 	err = 0;
 out:
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

