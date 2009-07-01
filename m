From: akpm@linux-foundation.org
Subject: + ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch added to -mm tree
Date: Wed, 01 Jul 2009 13:40:26 -0700
Message-ID: <200907012040.n61KeQFu021072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579AbZGAUkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 16:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, vmayatsk@redhat.com


The patch titled
     ptrace: __ptrace_detach: do __wake_up_parent() if we reap the tracee
has been added to the -mm tree.  Its filename is
     ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch

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
Subject: ptrace: __ptrace_detach: do __wake_up_parent() if we reap the tracee
From: Oleg Nesterov <oleg@redhat.com>

The bug is old, it wasn't cause by recent changes.

Test case:

	static void *tfunc(void *arg)
	{
		int pid = (long)arg;

		assert(ptrace(PTRACE_ATTACH, pid, NULL, NULL) == 0);
		kill(pid, SIGKILL);

		sleep(1);
		return NULL;
	}

	int main(void)
	{
		pthread_t th;
		long pid = fork();

		if (!pid)
			pause();

		signal(SIGCHLD, SIG_IGN);
		assert(pthread_create(&th, NULL, tfunc, (void*)pid) == 0);

		int r = waitpid(-1, NULL, __WNOTHREAD);
		printf("waitpid: %d %m\n", r);

		return 0;
	}

Before the patch this program hangs, after this patch waitpid() correctly
fails with errno == -ECHILD.

The problem is, __ptrace_detach() reaps the EXIT_ZOMBIE tracee if its
->real_parent is our sub-thread and we ignore SIGCHLD.  But in this case
we should wake up other threads which can sleep in do_wait().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 +
 kernel/exit.c         |    5 +++++
 kernel/ptrace.c       |   11 +++++++----
 kernel/signal.c       |    9 ---------
 4 files changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/sched.h~ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee include/linux/sched.h
--- a/include/linux/sched.h~ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee
+++ a/include/linux/sched.h
@@ -1983,6 +1983,7 @@ extern int kill_pgrp(struct pid *pid, in
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
 extern int do_notify_parent(struct task_struct *, int);
+extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
diff -puN kernel/exit.c~ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee kernel/exit.c
--- a/kernel/exit.c~ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee
+++ a/kernel/exit.c
@@ -1571,6 +1571,11 @@ static int ptrace_do_wait(struct wait_op
 	return 0;
 }
 
+void __wake_up_parent(struct task_struct *p, struct task_struct *parent)
+{
+	wake_up_interruptible_sync(&parent->signal->wait_chldexit);
+}
+
 static long do_wait(struct wait_opts *wo)
 {
 	DECLARE_WAITQUEUE(wait, current);
diff -puN kernel/ptrace.c~ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee
+++ a/kernel/ptrace.c
@@ -266,9 +266,10 @@ static int ignoring_children(struct sigh
  * or self-reaping.  Do notification now if it would have happened earlier.
  * If it should reap itself, return true.
  *
- * If it's our own child, there is no notification to do.
- * But if our normal children self-reap, then this child
- * was prevented by ptrace and we must reap it now.
+ * If it's our own child, there is no notification to do. But if our normal
+ * children self-reap, then this child was prevented by ptrace and we must
+ * reap it now, in that case we must also wake up sub-threads sleeping in
+ * do_wait().
  */
 static bool __ptrace_detach(struct task_struct *tracer, struct task_struct *p)
 {
@@ -278,8 +279,10 @@ static bool __ptrace_detach(struct task_
 		if (!task_detached(p) && thread_group_empty(p)) {
 			if (!same_thread_group(p->real_parent, tracer))
 				do_notify_parent(p, p->exit_signal);
-			else if (ignoring_children(tracer->sighand))
+			else if (ignoring_children(tracer->sighand)) {
+				__wake_up_parent(p, tracer);
 				p->exit_signal = -1;
+			}
 		}
 		if (task_detached(p)) {
 			/* Mark it as in the process of being reaped. */
diff -puN kernel/signal.c~ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee kernel/signal.c
--- a/kernel/signal.c~ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee
+++ a/kernel/signal.c
@@ -1383,15 +1383,6 @@ ret:
 }
 
 /*
- * Wake up any threads in the parent blocked in wait* syscalls.
- */
-static inline void __wake_up_parent(struct task_struct *p,
-				    struct task_struct *parent)
-{
-	wake_up_interruptible_sync(&parent->signal->wait_chldexit);
-}
