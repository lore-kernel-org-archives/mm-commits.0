From: akpm@linux-foundation.org
Subject: - tracehook-tracehook_consider_fatal_signal.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:55 -0700
Message-ID: <200807262116.m6QLGtGX019877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757783AbYGZVR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: tracehook_consider_fatal_signal
has been removed from the -mm tree.  Its filename was
     tracehook-tracehook_consider_fatal_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: tracehook_consider_fatal_signal
From: Roland McGrath <roland@redhat.com>

This defines tracehook_consider_fatal_signal() has a fine-grained hook for
deciding to skip the special cases for a fatal signal, as ptrace does. 
There is no change, only cleanup.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   21 +++++++++++++++++++++
 kernel/signal.c           |    9 +++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-tracehook_consider_fatal_signal include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-tracehook_consider_fatal_signal
+++ a/include/linux/tracehook.h
@@ -331,4 +331,25 @@ static inline int tracehook_consider_ign
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
 
+/**
+ * tracehook_consider_fatal_signal - suppress special handling of fatal signal
+ * @task:		task receiving the signal
+ * @sig:		signal number being sent
+ * @handler:		%SIG_DFL or %SIG_IGN
+ *
+ * Return nonzero to prevent special handling of this termination signal.
+ * Normally @handler is %SIG_DFL.  It can be %SIG_IGN if @sig is ignored,
+ * in which case force_sig() is about to reset it to %SIG_DFL.
+ * When this returns zero, this signal might cause a quick termination
+ * that does not give the debugger a chance to intercept the signal.
+ *
+ * Called with or without @task->sighand->siglock held.
+ */
+static inline int tracehook_consider_fatal_signal(struct task_struct *task,
+						  int sig,
+						  void __user *handler)
+{
+	return (task_ptrace(task) & PT_PTRACED) != 0;
+}
+
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/signal.c~tracehook-tracehook_consider_fatal_signal kernel/signal.c
--- a/kernel/signal.c~tracehook-tracehook_consider_fatal_signal
+++ a/kernel/signal.c
@@ -300,12 +300,12 @@ flush_signal_handlers(struct task_struct
 
 int unhandled_signal(struct task_struct *tsk, int sig)
 {
+	void __user *handler = tsk->sighand->action[sig-1].sa.sa_handler;
 	if (is_global_init(tsk))
 		return 1;
-	if (tsk->ptrace & PT_PTRACED)
+	if (handler != SIG_IGN && handler != SIG_DFL)
 		return 0;
-	return (tsk->sighand->action[sig-1].sa.sa_handler == SIG_IGN) ||
-		(tsk->sighand->action[sig-1].sa.sa_handler == SIG_DFL);
+	return !tracehook_consider_fatal_signal(tsk, sig, handler);
 }
 
 
@@ -761,7 +761,8 @@ static void complete_signal(int sig, str
 	if (sig_fatal(p, sig) &&
 	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
 	    !sigismember(&t->real_blocked, sig) &&
-	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
+	    (sig == SIGKILL ||
+	     !tracehook_consider_fatal_signal(t, sig, SIG_DFL))) {
 		/*
 		 * This signal will be fatal to the whole group.
 		 */
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tracehook-syscall.patch
tracehook-config_have_arch_tracehook.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

