From: akpm@osdl.org
Subject: - add-process_session-helper-routine-deprecate-old-field.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:47 -0800
Message-ID: <200612082005.kB8K5lmX002335@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57577 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426330AbWLHUF7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     add process_session() helper routine: deprecate old field
has been removed from the -mm tree.  Its filename was
     add-process_session-helper-routine-deprecate-old-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add process_session() helper routine: deprecate old field
From: Cedric Le Goater <clg@fr.ibm.com>

Add an anonymous union and ((deprecated)) to catch direct usage of the
session field.

[akpm@osdl.org: fix various missed conversions]
[jdike@addtoit.com: fix UML bug]
Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_io.c     |    2 +-
 fs/proc/array.c           |    2 +-
 include/linux/init_task.h |   11 ++++++-----
 include/linux/sched.h     |   19 +++++++++++++++++--
 kernel/exit.c             |    2 +-
 kernel/fork.c             |    2 +-
 6 files changed, 27 insertions(+), 11 deletions(-)

diff -puN drivers/char/tty_io.c~add-process_session-helper-routine-deprecate-old-field drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~add-process_session-helper-routine-deprecate-old-field
+++ a/drivers/char/tty_io.c
@@ -3855,7 +3855,7 @@ EXPORT_SYMBOL(proc_clear_tty);
 void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty)
 {
 	if (tty) {
-		tty->session = tsk->signal->session;
+		tty->session = process_session(tsk);
 		tty->pgrp = process_group(tsk);
 	}
 	tsk->signal->tty = tty;
diff -puN fs/proc/array.c~add-process_session-helper-routine-deprecate-old-field fs/proc/array.c
--- a/fs/proc/array.c~add-process_session-helper-routine-deprecate-old-field
+++ a/fs/proc/array.c
@@ -381,7 +381,7 @@ static int do_task_stat(struct task_stru
 			stime = cputime_add(stime, sig->stime);
 		}
 
-		sid = sig->session;
+		sid = signal_session(sig);
 		pgid = process_group(task);
 		ppid = rcu_dereference(task->real_parent)->tgid;
 
diff -puN include/linux/init_task.h~add-process_session-helper-routine-deprecate-old-field include/linux/init_task.h
--- a/include/linux/init_task.h~add-process_session-helper-routine-deprecate-old-field
+++ a/include/linux/init_task.h
@@ -57,17 +57,18 @@
 	.cpu_vm_mask	= CPU_MASK_ALL,				\
 }
 
-#define INIT_SIGNALS(sig) {	\
-	.count		= ATOMIC_INIT(1), 		\
+#define INIT_SIGNALS(sig) {						\
+	.count		= ATOMIC_INIT(1), 				\
 	.wait_chldexit	= __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
-	.shared_pending	= { 				\
+	.shared_pending	= { 						\
 		.list = LIST_HEAD_INIT(sig.shared_pending.list),	\
-		.signal =  {{0}}}, \
+		.signal =  {{0}}},					\
 	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
 	.pgrp		= 1,						\
-	.session	= 1,						\
+	.tty_old_pgrp   = 0,						\
+	{ .__session      = 1},						\
 }
 
 extern struct nsproxy init_nsproxy;
diff -puN include/linux/sched.h~add-process_session-helper-routine-deprecate-old-field include/linux/sched.h
--- a/include/linux/sched.h~add-process_session-helper-routine-deprecate-old-field
+++ a/include/linux/sched.h
@@ -436,7 +436,12 @@ struct signal_struct {
 	/* job control IDs */
 	pid_t pgrp;
 	pid_t tty_old_pgrp;
-	pid_t session;
+
+	union {
+		pid_t session __deprecated;
+		pid_t __session;
+	};
+
 	/* boolean value for session group leader */
 	int leader;
 
@@ -1047,9 +1052,19 @@ static inline pid_t process_group(struct
 	return tsk->signal->pgrp;
 }
 
+static inline pid_t signal_session(struct signal_struct *sig)
+{
+	return sig->__session;
+}
+
 static inline pid_t process_session(struct task_struct *tsk)
 {
-	return tsk->signal->session;
+	return signal_session(tsk->signal);
+}
+
+static inline void set_signal_session(struct signal_struct *sig, pid_t session)
+{
+	sig->__session = session;
 }
 
 static inline struct pid *task_pid(struct task_struct *task)
diff -puN kernel/exit.c~add-process_session-helper-routine-deprecate-old-field kernel/exit.c
--- a/kernel/exit.c~add-process_session-helper-routine-deprecate-old-field
+++ a/kernel/exit.c
@@ -304,7 +304,7 @@ void __set_special_pids(pid_t session, p
 
 	if (process_session(curr) != session) {
 		detach_pid(curr, PIDTYPE_SID);
-		curr->signal->session = session;
+		set_signal_session(curr->signal, session);
 		attach_pid(curr, PIDTYPE_SID, session);
 	}
 	if (process_group(curr) != pgrp) {
diff -puN kernel/fork.c~add-process_session-helper-routine-deprecate-old-field kernel/fork.c
--- a/kernel/fork.c~add-process_session-helper-routine-deprecate-old-field
+++ a/kernel/fork.c
@@ -1259,7 +1259,7 @@ static struct task_struct *copy_process(
 		if (thread_group_leader(p)) {
 			p->signal->tty = current->signal->tty;
 			p->signal->pgrp = process_group(current);
-			p->signal->session = process_session(current);
+			set_signal_session(p->signal, process_session(current));
 			attach_pid(p, PIDTYPE_PGID, process_group(p));
 			attach_pid(p, PIDTYPE_SID, process_session(p));
 
_

Patches currently in -mm which might be from clg@fr.ibm.com are

add-process_session-helper-routine-deprecate-old-field.patch
rename-struct-namespace-to-struct-mnt_namespace.patch
add-an-identifier-to-nsproxy.patch
rename-struct-pspace-to-struct-pid_namespace.patch
add-pid_namespace-to-nsproxy.patch
use-current-nsproxy-pid_ns.patch
add-child-reaper-to-pid_namespace.patch
mm-fix-pagecache-write-deadlocks-xip.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch

