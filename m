From: akpm@linux-foundation.org
Subject: - kill-pt_ptraced.patch removed from -mm tree
Date: Tue, 20 Nov 2007 14:14:20 -0800
Message-ID: <200711202214.lAKMEKIV026206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbXKTWPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 17:15:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kill PT_PTRACED
has been removed from the -mm tree.  Its filename was
     kill-pt_ptraced.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: kill PT_PTRACED
From: Oleg Nesterov <oleg@tv-sign.ru>

Since the patch

	"Fix ptrace_attach()/ptrace_traceme()/de_thread() race"
	commit f5b40e363ad6041a96e3da32281d8faa191597b9

we set PT_ATTACHED and change child->parent "atomically" wrt task_list lock.

This means we can remove the checks like "PT_ATTACHED && ->parent != ptracer"
which were needed to catch the "ptrace attach is in progress" case. We can also
remove the flag itself since nobody else uses it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |    1 -
 kernel/exit.c          |   13 +------------
 kernel/ptrace.c        |    6 ++----
 kernel/signal.c        |    5 -----
 4 files changed, 3 insertions(+), 22 deletions(-)

diff -puN include/linux/ptrace.h~kill-pt_ptraced include/linux/ptrace.h
--- a/include/linux/ptrace.h~kill-pt_ptraced
+++ a/include/linux/ptrace.h
@@ -67,7 +67,6 @@
 #define PT_TRACE_EXEC	0x00000080
 #define PT_TRACE_VFORK_DONE	0x00000100
 #define PT_TRACE_EXIT	0x00000200
-#define PT_ATTACHED	0x00000400	/* parent != real_parent */
 
 #define PT_TRACE_MASK	0x000003f4
 
diff -puN kernel/exit.c~kill-pt_ptraced kernel/exit.c
--- a/kernel/exit.c~kill-pt_ptraced
+++ a/kernel/exit.c
@@ -1515,18 +1515,7 @@ static int wait_task_continued(struct ta
 
 static inline int my_ptrace_child(struct task_struct *p)
 {
-	if (!(p->ptrace & PT_PTRACED))
-		return 0;
-	if (!(p->ptrace & PT_ATTACHED))
-		return 1;
-	/*
-	 * This child was PTRACE_ATTACH'd.  We should be seeing it only if
-	 * we are the attacher.  If we are the real parent, this is a race
-	 * inside ptrace_attach.  It is waiting for the tasklist_lock,
-	 * which we have to switch the parent links, but has already set
-	 * the flags in p->ptrace.
-	 */
-	return (p->parent != p->real_parent);
+	return p->ptrace & PT_PTRACED;
 }
 
 static long do_wait(pid_t pid, int options, struct siginfo __user *infop,
diff -puN kernel/ptrace.c~kill-pt_ptraced kernel/ptrace.c
--- a/kernel/ptrace.c~kill-pt_ptraced
+++ a/kernel/ptrace.c
@@ -100,8 +100,7 @@ int ptrace_check_attach(struct task_stru
 	 */
 	read_lock(&tasklist_lock);
 	if ((child->ptrace & PT_PTRACED) && child->parent == current &&
-	    (!(child->ptrace & PT_ATTACHED) || child->real_parent != current)
-	    && child->signal != NULL) {
+	     child->sighand != NULL) {
 		ret = 0;
 		spin_lock_irq(&child->sighand->siglock);
 		if (is_task_stopped(child))
@@ -200,8 +199,7 @@ repeat:
 		goto bad;
 
 	/* Go */
-	task->ptrace |= PT_PTRACED | ((task->real_parent != current)
-				      ? PT_ATTACHED : 0);
+	task->ptrace |= PT_PTRACED;
 	if (capable(CAP_SYS_PTRACE))
 		task->ptrace |= PT_PTRACE_CAP;
 
diff -puN kernel/signal.c~kill-pt_ptraced kernel/signal.c
--- a/kernel/signal.c~kill-pt_ptraced
+++ a/kernel/signal.c
@@ -1577,11 +1577,6 @@ static inline int may_ptrace_stop(void)
 {
 	if (!likely(current->ptrace & PT_PTRACED))
 		return 0;
-
-	if (unlikely(current->parent == current->real_parent &&
-		    (current->ptrace & PT_ATTACHED)))
-		return 0;
-
 	/*
 	 * Are we in the middle of do_coredump?
 	 * If so and our tracer is also part of the coredump stopping
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
proc-remove-races-from-proc_id_readdir.patch
wait_task_stopped-pass-correct-exit_code-to.patch
use-__set_task_state-for-traced-stopped-tasks.patch
add-task_wakekill.patch
kill-pt_ptraced.patch
kill-my_ptrace_child.patch
do_wait-remove-one-else-if-branch.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
