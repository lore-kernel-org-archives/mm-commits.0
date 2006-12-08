From: akpm@osdl.org
Subject: - add-process_session-helper-routine.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:44 -0800
Message-ID: <200612082005.kB8K5ibe002326@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57579 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426328AbWLHUF7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, dev@openvz.org, ebiederm@xmission.com, herbert@13thfloor.at, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     add process_session() helper routine
has been removed from the -mm tree.  Its filename was
     add-process_session-helper-routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add process_session() helper routine
From: Cedric Le Goater <clg@fr.ibm.com>

Replace occurences of task->signal->session by a new process_session() helper
routine.

It will be useful for pid namespaces to abstract the session pid number.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/mips/kernel/irixelf.c |    2 +-
 drivers/char/mxser.c       |    2 +-
 drivers/char/rocket.c      |    2 +-
 drivers/char/tty_io.c      |   12 ++++++------
 fs/binfmt_elf.c            |    4 ++--
 fs/binfmt_elf_fdpic.c      |    4 ++--
 include/linux/sched.h      |    5 +++++
 kernel/exit.c              |   19 ++++++++++---------
 kernel/fork.c              |    4 ++--
 kernel/signal.c            |    2 +-
 kernel/sys.c               |    8 ++++----
 11 files changed, 35 insertions(+), 29 deletions(-)

diff -puN arch/mips/kernel/irixelf.c~add-process_session-helper-routine arch/mips/kernel/irixelf.c
--- a/arch/mips/kernel/irixelf.c~add-process_session-helper-routine
+++ a/arch/mips/kernel/irixelf.c
@@ -1145,7 +1145,7 @@ static int irix_core_dump(long signr, st
 	psinfo.pr_pid = prstatus.pr_pid = current->pid;
 	psinfo.pr_ppid = prstatus.pr_ppid = current->parent->pid;
 	psinfo.pr_pgrp = prstatus.pr_pgrp = process_group(current);
-	psinfo.pr_sid = prstatus.pr_sid = current->signal->session;
+	psinfo.pr_sid = prstatus.pr_sid = process_session(current);
 	if (current->pid == current->tgid) {
 		/*
 		 * This is the record for the group leader.  Add in the
diff -puN drivers/char/mxser.c~add-process_session-helper-routine drivers/char/mxser.c
--- a/drivers/char/mxser.c~add-process_session-helper-routine
+++ a/drivers/char/mxser.c
@@ -994,7 +994,7 @@ static int mxser_open(struct tty_struct 
 		mxser_change_speed(info, NULL);
 	}
 
-	info->session = current->signal->session;
+	info->session = process_session(current);
 	info->pgrp = process_group(current);
 
 	/*
diff -puN drivers/char/rocket.c~add-process_session-helper-routine drivers/char/rocket.c
--- a/drivers/char/rocket.c~add-process_session-helper-routine
+++ a/drivers/char/rocket.c
@@ -1017,7 +1017,7 @@ static int rp_open(struct tty_struct *tt
 	/*
 	 * Info->count is now 1; so it's safe to sleep now.
 	 */
-	info->session = current->signal->session;
+	info->session = process_session(current);
 	info->pgrp = process_group(current);
 
 	if ((info->flags & ROCKET_INITIALIZED) == 0) {
diff -puN drivers/char/tty_io.c~add-process_session-helper-routine drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~add-process_session-helper-routine
+++ a/drivers/char/tty_io.c
@@ -1511,7 +1511,7 @@ void disassociate_ctty(int on_exit)
 
 	spin_lock_irq(&current->sighand->siglock);
 	current->signal->tty_old_pgrp = 0;
-	session = current->signal->session;
+	session = process_session(current);
 	spin_unlock_irq(&current->sighand->siglock);
 
 	mutex_lock(&tty_mutex);
@@ -2897,7 +2897,7 @@ static int tiocsctty(struct tty_struct *
 {
 	int ret = 0;
 	if (current->signal->leader &&
-	    (current->signal->session == tty->session))
+			(process_session(current) == tty->session))
 		return ret;
 
 	mutex_lock(&tty_mutex);
@@ -2979,13 +2979,13 @@ static int tiocspgrp(struct tty_struct *
 		return retval;
 	if (!current->signal->tty ||
 	    (current->signal->tty != real_tty) ||
-	    (real_tty->session != current->signal->session))
+	    (real_tty->session != process_session(current)))
 		return -ENOTTY;
 	if (get_user(pgrp, p))
 		return -EFAULT;
 	if (pgrp < 0)
 		return -EINVAL;
-	if (session_of_pgrp(pgrp) != current->signal->session)
+	if (session_of_pgrp(pgrp) != process_session(current))
 		return -EPERM;
 	real_tty->pgrp = pgrp;
 	return 0;
@@ -3338,7 +3338,7 @@ static void __do_SAK(struct work_struct 
 	/* Kill the entire session */
 	do_each_task_pid(session, PIDTYPE_SID, p) {
 		printk(KERN_NOTICE "SAK: killed process %d"
-			" (%s): p->signal->session==tty->session\n",
+			" (%s): process_session(p)==tty->session\n",
 			p->pid, p->comm);
 		send_sig(SIGKILL, p, 1);
 	} while_each_task_pid(session, PIDTYPE_SID, p);
@@ -3348,7 +3348,7 @@ static void __do_SAK(struct work_struct 
 	do_each_thread(g, p) {
 		if (p->signal->tty == tty) {
 			printk(KERN_NOTICE "SAK: killed process %d"
-			    " (%s): p->signal->session==tty->session\n",
+			    " (%s): process_session(p)==tty->session\n",
 			    p->pid, p->comm);
 			send_sig(SIGKILL, p, 1);
 			continue;
diff -puN fs/binfmt_elf.c~add-process_session-helper-routine fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~add-process_session-helper-routine
+++ a/fs/binfmt_elf.c
@@ -1317,7 +1317,7 @@ static void fill_prstatus(struct elf_prs
 	prstatus->pr_pid = p->pid;
 	prstatus->pr_ppid = p->parent->pid;
 	prstatus->pr_pgrp = process_group(p);
-	prstatus->pr_sid = p->signal->session;
+	prstatus->pr_sid = process_session(p);
 	if (thread_group_leader(p)) {
 		/*
 		 * This is the record for the group leader.  Add in the
@@ -1363,7 +1363,7 @@ static int fill_psinfo(struct elf_prpsin
 	psinfo->pr_pid = p->pid;
 	psinfo->pr_ppid = p->parent->pid;
 	psinfo->pr_pgrp = process_group(p);
-	psinfo->pr_sid = p->signal->session;
+	psinfo->pr_sid = process_session(p);
 
 	i = p->state ? ffz(~p->state) + 1 : 0;
 	psinfo->pr_state = i;
diff -puN fs/binfmt_elf_fdpic.c~add-process_session-helper-routine fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~add-process_session-helper-routine
+++ a/fs/binfmt_elf_fdpic.c
@@ -1322,7 +1322,7 @@ static void fill_prstatus(struct elf_prs
 	prstatus->pr_pid = p->pid;
 	prstatus->pr_ppid = p->parent->pid;
 	prstatus->pr_pgrp = process_group(p);
-	prstatus->pr_sid = p->signal->session;
+	prstatus->pr_sid = process_session(p);
 	if (thread_group_leader(p)) {
 		/*
 		 * This is the record for the group leader.  Add in the
@@ -1371,7 +1371,7 @@ static int fill_psinfo(struct elf_prpsin
 	psinfo->pr_pid = p->pid;
 	psinfo->pr_ppid = p->parent->pid;
 	psinfo->pr_pgrp = process_group(p);
-	psinfo->pr_sid = p->signal->session;
+	psinfo->pr_sid = process_session(p);
 
 	i = p->state ? ffz(~p->state) + 1 : 0;
 	psinfo->pr_state = i;
diff -puN include/linux/sched.h~add-process_session-helper-routine include/linux/sched.h
--- a/include/linux/sched.h~add-process_session-helper-routine
+++ a/include/linux/sched.h
@@ -1047,6 +1047,11 @@ static inline pid_t process_group(struct
 	return tsk->signal->pgrp;
 }
 
+static inline pid_t process_session(struct task_struct *tsk)
+{
+	return tsk->signal->session;
+}
+
 static inline struct pid *task_pid(struct task_struct *task)
 {
 	return task->pids[PIDTYPE_PID].pid;
diff -puN kernel/exit.c~add-process_session-helper-routine kernel/exit.c
--- a/kernel/exit.c~add-process_session-helper-routine
+++ a/kernel/exit.c
@@ -193,14 +193,14 @@ int session_of_pgrp(int pgrp)
 
 	read_lock(&tasklist_lock);
 	do_each_task_pid(pgrp, PIDTYPE_PGID, p) {
-		if (p->signal->session > 0) {
-			sid = p->signal->session;
+		if (process_session(p) > 0) {
+			sid = process_session(p);
 			goto out;
 		}
 	} while_each_task_pid(pgrp, PIDTYPE_PGID, p);
 	p = find_task_by_pid(pgrp);
 	if (p)
-		sid = p->signal->session;
+		sid = process_session(p);
 out:
 	read_unlock(&tasklist_lock);
 	
@@ -225,8 +225,8 @@ static int will_become_orphaned_pgrp(int
 				|| p->exit_state
 				|| is_init(p->real_parent))
 			continue;
-		if (process_group(p->real_parent) != pgrp
-			    && p->real_parent->signal->session == p->signal->session) {
+		if (process_group(p->real_parent) != pgrp &&
+		    process_session(p->real_parent) == process_session(p)) {
 			ret = 0;
 			break;
 		}
@@ -302,7 +302,7 @@ void __set_special_pids(pid_t session, p
 {
 	struct task_struct *curr = current->group_leader;
 
-	if (curr->signal->session != session) {
+	if (process_session(curr) != session) {
 		detach_pid(curr, PIDTYPE_SID);
 		curr->signal->session = session;
 		attach_pid(curr, PIDTYPE_SID, session);
@@ -647,10 +647,11 @@ reparent_thread(struct task_struct *p, s
 	 * outside, so the child pgrp is now orphaned.
 	 */
 	if ((process_group(p) != process_group(father)) &&
-	    (p->signal->session == father->signal->session)) {
+	    (process_session(p) == process_session(father))) {
 		int pgrp = process_group(p);
 
-		if (will_become_orphaned_pgrp(pgrp, NULL) && has_stopped_jobs(pgrp)) {
+		if (will_become_orphaned_pgrp(pgrp, NULL) &&
+		    has_stopped_jobs(pgrp)) {
 			__kill_pg_info(SIGHUP, SEND_SIG_PRIV, pgrp);
 			__kill_pg_info(SIGCONT, SEND_SIG_PRIV, pgrp);
 		}
@@ -784,7 +785,7 @@ static void exit_notify(struct task_stru
 	t = tsk->real_parent;
 	
 	if ((process_group(t) != process_group(tsk)) &&
-	    (t->signal->session == tsk->signal->session) &&
+	    (process_session(t) == process_session(tsk)) &&
 	    will_become_orphaned_pgrp(process_group(tsk), tsk) &&
 	    has_stopped_jobs(process_group(tsk))) {
 		__kill_pg_info(SIGHUP, SEND_SIG_PRIV, process_group(tsk));
diff -puN kernel/fork.c~add-process_session-helper-routine kernel/fork.c
--- a/kernel/fork.c~add-process_session-helper-routine
+++ a/kernel/fork.c
@@ -1259,9 +1259,9 @@ static struct task_struct *copy_process(
 		if (thread_group_leader(p)) {
 			p->signal->tty = current->signal->tty;
 			p->signal->pgrp = process_group(current);
-			p->signal->session = current->signal->session;
+			p->signal->session = process_session(current);
 			attach_pid(p, PIDTYPE_PGID, process_group(p));
-			attach_pid(p, PIDTYPE_SID, p->signal->session);
+			attach_pid(p, PIDTYPE_SID, process_session(p));
 
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
 			__get_cpu_var(process_counts)++;
diff -puN kernel/signal.c~add-process_session-helper-routine kernel/signal.c
--- a/kernel/signal.c~add-process_session-helper-routine
+++ a/kernel/signal.c
@@ -583,7 +583,7 @@ static int check_kill_permission(int sig
 	error = -EPERM;
 	if ((info == SEND_SIG_NOINFO || (!is_si_special(info) && SI_FROMUSER(info)))
 	    && ((sig != SIGCONT) ||
-		(current->signal->session != t->signal->session))
+		(process_session(current) != process_session(t)))
 	    && (current->euid ^ t->suid) && (current->euid ^ t->uid)
 	    && (current->uid ^ t->suid) && (current->uid ^ t->uid)
 	    && !capable(CAP_KILL))
diff -puN kernel/sys.c~add-process_session-helper-routine kernel/sys.c
--- a/kernel/sys.c~add-process_session-helper-routine
+++ a/kernel/sys.c
@@ -1381,7 +1381,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 
 	if (p->real_parent == group_leader) {
 		err = -EPERM;
-		if (p->signal->session != group_leader->signal->session)
+		if (process_session(p) != process_session(group_leader))
 			goto out;
 		err = -EACCES;
 		if (p->did_exec)
@@ -1400,7 +1400,7 @@ asmlinkage long sys_setpgid(pid_t pid, p
 		struct task_struct *p;
 
 		do_each_task_pid(pgid, PIDTYPE_PGID, p) {
-			if (p->signal->session == group_leader->signal->session)
+			if (process_session(p) == process_session(group_leader))
 				goto ok_pgid;
 		} while_each_task_pid(pgid, PIDTYPE_PGID, p);
 		goto out;
@@ -1459,7 +1459,7 @@ asmlinkage long sys_getpgrp(void)
 asmlinkage long sys_getsid(pid_t pid)
 {
 	if (!pid)
-		return current->signal->session;
+		return process_session(current);
 	else {
 		int retval;
 		struct task_struct *p;
@@ -1471,7 +1471,7 @@ asmlinkage long sys_getsid(pid_t pid)
 		if (p) {
 			retval = security_task_getsid(p);
 			if (!retval)
-				retval = p->signal->session;
+				retval = process_session(p);
 		}
 		read_unlock(&tasklist_lock);
 		return retval;
_

Patches currently in -mm which might be from clg@fr.ibm.com are

add-process_session-helper-routine.patch
add-process_session-helper-routine-deprecate-old-field.patch
rename-struct-namespace-to-struct-mnt_namespace.patch
add-an-identifier-to-nsproxy.patch
rename-struct-pspace-to-struct-pid_namespace.patch
add-pid_namespace-to-nsproxy.patch
use-current-nsproxy-pid_ns.patch
add-child-reaper-to-pid_namespace.patch
mm-fix-pagecache-write-deadlocks-xip.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch

