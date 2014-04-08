From: akpm@linux-foundation.org
Subject: [merged] exec-kill-bprm-tcomm-simplify-the-basename-logic.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:19:01 -0700
Message-ID: <534467c5.vKQg0/A6tYUpTfcj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbaDHVTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, heiko.carstens@de.ibm.com, oleg@redhat.com

Subject: [merged] exec-kill-bprm-tcomm-simplify-the-basename-logic.patch removed from -mm tree
To: oleg@redhat.com,heiko.carstens@de.ibm.com,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:19:01 -0700


The patch titled
     Subject: exec: kill bprm->tcomm[], simplify the "basename" logic
has been removed from the -mm tree.  Its filename was
     exec-kill-bprm-tcomm-simplify-the-basename-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exec: kill bprm->tcomm[], simplify the "basename" logic

Starting from c4ad8f98bef7 ("execve: use 'struct filename *' for
executable name passing") bprm->filename can not go away after
flush_old_exec(), so we do not need to save the binary name in
bprm->tcomm[] added by 96e02d158678 ("exec: fix use-after-free bug in
setup_new_exec()").

And there was never need for filename_to_taskname-like code, we can simply
do set_task_comm(kbasename(filename).

This patch has to change set_task_comm() and trace_task_rename() to accept
"const char *", but I think this change is also good.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                   |   21 ++-------------------
 include/linux/binfmts.h     |    1 -
 include/linux/sched.h       |    2 +-
 include/trace/events/task.h |    2 +-
 4 files changed, 4 insertions(+), 22 deletions(-)

diff -puN fs/exec.c~exec-kill-bprm-tcomm-simplify-the-basename-logic fs/exec.c
--- a/fs/exec.c~exec-kill-bprm-tcomm-simplify-the-basename-logic
+++ a/fs/exec.c
@@ -1046,7 +1046,7 @@ EXPORT_SYMBOL_GPL(get_task_comm);
  * so that a new one can be started
  */
 
-void set_task_comm(struct task_struct *tsk, char *buf)
+void set_task_comm(struct task_struct *tsk, const char *buf)
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
@@ -1055,21 +1055,6 @@ void set_task_comm(struct task_struct *t
 	perf_event_comm(tsk);
 }
 
-static void filename_to_taskname(char *tcomm, const char *fn, unsigned int len)
-{
-	int i, ch;
-
-	/* Copies the binary name from after last slash */
-	for (i = 0; (ch = *(fn++)) != '\0';) {
-		if (ch == '/')
-			i = 0; /* overwrite what we wrote */
-		else
-			if (i < len - 1)
-				tcomm[i++] = ch;
-	}
-	tcomm[i] = '\0';
-}
-
 int flush_old_exec(struct linux_binprm * bprm)
 {
 	int retval;
@@ -1083,8 +1068,6 @@ int flush_old_exec(struct linux_binprm *
 		goto out;
 
 	set_mm_exe_file(bprm->mm, bprm->file);
-
-	filename_to_taskname(bprm->tcomm, bprm->filename, sizeof(bprm->tcomm));
 	/*
 	 * Release all of the old mmap stuff
 	 */
@@ -1127,7 +1110,7 @@ void setup_new_exec(struct linux_binprm
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
-	set_task_comm(current, bprm->tcomm);
+	set_task_comm(current, kbasename(bprm->filename));
 
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
diff -puN include/linux/binfmts.h~exec-kill-bprm-tcomm-simplify-the-basename-logic include/linux/binfmts.h
--- a/include/linux/binfmts.h~exec-kill-bprm-tcomm-simplify-the-basename-logic
+++ a/include/linux/binfmts.h
@@ -44,7 +44,6 @@ struct linux_binprm {
 	unsigned interp_flags;
 	unsigned interp_data;
 	unsigned long loader, exec;
-	char tcomm[TASK_COMM_LEN];
 };
 
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
diff -puN include/linux/sched.h~exec-kill-bprm-tcomm-simplify-the-basename-logic include/linux/sched.h
--- a/include/linux/sched.h~exec-kill-bprm-tcomm-simplify-the-basename-logic
+++ a/include/linux/sched.h
@@ -2357,7 +2357,7 @@ extern long do_fork(unsigned long, unsig
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
-extern void set_task_comm(struct task_struct *tsk, char *from);
+extern void set_task_comm(struct task_struct *tsk, const char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
diff -puN include/trace/events/task.h~exec-kill-bprm-tcomm-simplify-the-basename-logic include/trace/events/task.h
--- a/include/trace/events/task.h~exec-kill-bprm-tcomm-simplify-the-basename-logic
+++ a/include/trace/events/task.h
@@ -32,7 +32,7 @@ TRACE_EVENT(task_newtask,
 
 TRACE_EVENT(task_rename,
 
-	TP_PROTO(struct task_struct *task, char *comm),
+	TP_PROTO(struct task_struct *task, const char *comm),
 
 	TP_ARGS(task, comm),
 
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch

