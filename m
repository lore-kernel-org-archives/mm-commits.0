From: akpm@linux-foundation.org
Subject: - tracehook-tracehook_consider_ignored_signal.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:53 -0700
Message-ID: <200807262116.m6QLGrKG019874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757754AbYGZVRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: tracehook_consider_ignored_signal
has been removed from the -mm tree.  Its filename was
     tracehook-tracehook_consider_ignored_signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: tracehook_consider_ignored_signal
From: Roland McGrath <roland@redhat.com>

This defines tracehook_consider_ignored_signal() has a fine-grained hook
for deciding to prevent the normal short-circuit of sending an ignored
signal, as ptrace does.  There is no change, only cleanup.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   19 +++++++++++++++++++
 kernel/signal.c           |   27 ++++++++++++++++-----------
 2 files changed, 35 insertions(+), 11 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-tracehook_consider_ignored_signal include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-tracehook_consider_ignored_signal
+++ a/include/linux/tracehook.h
@@ -312,4 +312,23 @@ static inline void tracehook_signal_hand
 		ptrace_notify(SIGTRAP);
 }
 
+/**
+ * tracehook_consider_ignored_signal - suppress short-circuit of ignored signal
+ * @task:		task receiving the signal
+ * @sig:		signal number being sent
+ * @handler:		%SIG_IGN or %SIG_DFL
+ *
+ * Return zero iff tracing doesn't care to examine this ignored signal,
+ * so it can short-circuit normal delivery and never even get queued.
+ * Either @handler is %SIG_DFL and @sig's default is ignore, or it's %SIG_IGN.
+ *
+ * Called with @task->sighand->siglock held.
+ */
+static inline int tracehook_consider_ignored_signal(struct task_struct *task,
+						    int sig,
+						    void __user *handler)
+{
+	return (task_ptrace(task) & PT_PTRACED) != 0;
+}
+
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/signal.c~tracehook-tracehook_consider_ignored_signal kernel/signal.c
--- a/kernel/signal.c~tracehook-tracehook_consider_ignored_signal
+++ a/kernel/signal.c
@@ -22,6 +22,7 @@
 #include <linux/ptrace.h>
 #include <linux/signal.h>
 #include <linux/signalfd.h>
+#include <linux/tracehook.h>
 #include <linux/capability.h>
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
@@ -39,24 +40,21 @@
 
 static struct kmem_cache *sigqueue_cachep;
 
-static int __sig_ignored(struct task_struct *t, int sig)
+static void __user *sig_handler(struct task_struct *t, int sig)
 {
-	void __user *handler;
+	return t->sighand->action[sig - 1].sa.sa_handler;
+}
 
+static int sig_handler_ignored(void __user *handler, int sig)
+{
 	/* Is it explicitly or implicitly ignored? */
-
-	handler = t->sighand->action[sig - 1].sa.sa_handler;
 	return handler == SIG_IGN ||
 		(handler == SIG_DFL && sig_kernel_ignore(sig));
 }
 
 static int sig_ignored(struct task_struct *t, int sig)
 {
-	/*
-	 * Tracers always want to know about signals..
-	 */
-	if (t->ptrace & PT_PTRACED)
-		return 0;
+	void __user *handler;
 
 	/*
 	 * Blocked signals are never ignored, since the
@@ -66,7 +64,14 @@ static int sig_ignored(struct task_struc
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	return __sig_ignored(t, sig);
+	handler = sig_handler(t, sig);
+	if (!sig_handler_ignored(handler, sig))
+		return 0;
+
+	/*
+	 * Tracers may want to know about even ignored signals.
+	 */
+	return !tracehook_consider_ignored_signal(t, sig, handler);
 }
 
 /*
@@ -2298,7 +2303,7 @@ int do_sigaction(int sig, struct k_sigac
 		 *   (for example, SIGCHLD), shall cause the pending signal to
 		 *   be discarded, whether or not it is blocked"
 		 */
-		if (__sig_ignored(t, sig)) {
+		if (sig_handler_ignored(sig_handler(t, sig), sig)) {
 			sigemptyset(&mask);
 			sigaddset(&mask, sig);
 			rm_from_queue_full(&mask, &t->signal->shared_pending);
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

