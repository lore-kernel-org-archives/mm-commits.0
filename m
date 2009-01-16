From: akpm@linux-foundation.org
Subject: + pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch added to -mm tree
Date: Fri, 16 Jan 2009 14:22:04 -0800
Message-ID: <200901162222.n0GMM5CU010674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934762AbZAPWW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 17:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, Louis.Rilling@kerlabs.com, ebiederm@xmission.com, roland@redhat.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     pids: refactor vnr/nr_ns helpers to make them safe
has been added to the -mm tree.  Its filename is
     pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch

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
Subject: pids: refactor vnr/nr_ns helpers to make them safe
From: Oleg Nesterov <oleg@redhat.com>

Inho, the safety rules for vnr/nr_ns helpers are horrible and buggy.

task_pid_nr_ns(task) needs rcu/tasklist depending on task == current.

As for "special" pids, vnr/nr_ns helpers always need rcu.  However, if
task != current, they are unsafe even under rcu lock, we can't trust
task->group_leader without the special checks.

And almost every helper has a callsite which needs a fix.

Also, it is a bit annoying that the implementations of, say,
task_pgrp_vnr() and task_pgrp_nr_ns() are not "symmetrical".

This patch introduces the new helper, __task_pid_nr_ns(), which is always
safe to use, and turns all other helpers into the trivial wrappers.

After this I'll send another patch which converts task_tgid_xxx() as well,
they're are a bit special.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   27 ++++++++++++++++++++-------
 kernel/pid.c          |   31 ++++++++++++++++---------------
 2 files changed, 36 insertions(+), 22 deletions(-)

diff -puN include/linux/sched.h~pids-refactor-vnr-nr_ns-helpers-to-make-them-safe include/linux/sched.h
--- a/include/linux/sched.h~pids-refactor-vnr-nr_ns-helpers-to-make-them-safe
+++ a/include/linux/sched.h
@@ -1479,17 +1479,23 @@ struct pid_namespace;
  *
  * see also pid_nr() etc in include/linux/pid.h
  */
+pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
+			struct pid_namespace *ns);
 
 static inline pid_t task_pid_nr(struct task_struct *tsk)
 {
 	return tsk->pid;
 }
 
-pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
+static inline pid_t task_pid_nr_ns(struct task_struct *tsk,
+					struct pid_namespace *ns)
+{
+	return __task_pid_nr_ns(tsk, PIDTYPE_PID, ns);
+}
 
 static inline pid_t task_pid_vnr(struct task_struct *tsk)
 {
-	return pid_vnr(task_pid(tsk));
+	return __task_pid_nr_ns(tsk, PIDTYPE_PID, NULL);
 }
 
 
@@ -1511,11 +1517,15 @@ static inline pid_t task_pgrp_nr(struct 
 	return tsk->signal->__pgrp;
 }
 
-pid_t task_pgrp_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
+static inline pid_t task_pgrp_nr_ns(struct task_struct *tsk,
+					struct pid_namespace *ns)
+{
+	return __task_pid_nr_ns(tsk, PIDTYPE_PGID, ns);
+}
 
 static inline pid_t task_pgrp_vnr(struct task_struct *tsk)
 {
-	return pid_vnr(task_pgrp(tsk));
+	return __task_pid_nr_ns(tsk, PIDTYPE_PGID, NULL);
 }
 
 
@@ -1524,14 +1534,17 @@ static inline pid_t task_session_nr(stru
 	return tsk->signal->__session;
 }
 
-pid_t task_session_nr_ns(struct task_struct *tsk, struct pid_namespace *ns);
+static inline pid_t task_session_nr_ns(struct task_struct *tsk,
+					struct pid_namespace *ns)
+{
+	return __task_pid_nr_ns(tsk, PIDTYPE_SID, ns);
+}
 
 static inline pid_t task_session_vnr(struct task_struct *tsk)
 {
-	return pid_vnr(task_session(tsk));
+	return __task_pid_nr_ns(tsk, PIDTYPE_SID, NULL);
 }
 
-
 /**
  * pid_alive - check that a task structure is not stale
  * @p: Task structure to be checked.
diff -puN kernel/pid.c~pids-refactor-vnr-nr_ns-helpers-to-make-them-safe kernel/pid.c
--- a/kernel/pid.c~pids-refactor-vnr-nr_ns-helpers-to-make-them-safe
+++ a/kernel/pid.c
@@ -452,11 +452,24 @@ pid_t pid_vnr(struct pid *pid)
 }
 EXPORT_SYMBOL_GPL(pid_vnr);
 
-pid_t task_pid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
+pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
+			struct pid_namespace *ns)
 {
-	return pid_nr_ns(task_pid(tsk), ns);
+	pid_t nr = 0;
+
+	rcu_read_lock();
+	if (!ns)
+		ns = current->nsproxy->pid_ns;
+	if (likely(pid_alive(task))) {
+		if (type != PIDTYPE_PID)
+			task = task->group_leader;
+		nr = pid_nr_ns(task->pids[type].pid, ns);
+	}
+	rcu_read_unlock();
+
+	return nr;
 }
-EXPORT_SYMBOL(task_pid_nr_ns);
+EXPORT_SYMBOL(__task_pid_nr_ns);
 
 pid_t task_tgid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
 {
@@ -464,18 +477,6 @@ pid_t task_tgid_nr_ns(struct task_struct
 }
 EXPORT_SYMBOL(task_tgid_nr_ns);
 
-pid_t task_pgrp_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_pgrp(tsk), ns);
-}
-EXPORT_SYMBOL(task_pgrp_nr_ns);
-
-pid_t task_session_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
-{
-	return pid_nr_ns(task_session(tsk), ns);
-}
-EXPORT_SYMBOL(task_session_nr_ns);
