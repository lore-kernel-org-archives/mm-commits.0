From: akpm@linux-foundation.org
Subject: - signals-simplify-sig_ignored-pathes.patch removed from -mm tree
Date: Fri, 21 Nov 2008 14:41:49 -0800
Message-ID: <200811212241.mALMfnYn032200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754198AbYKUWmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 17:42:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: simplify sig_ignored() pathes
has been removed from the -mm tree.  Its filename was
     signals-simplify-sig_ignored-pathes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: simplify sig_ignored() pathes
From: Oleg Nesterov <oleg@redhat.com>

The code which checks for ignored signals is a bit overcomplicated because
tracehook_consider_ignored_signal() wants the "handler" arg.  Can't we
kill it?  It is not used even with utrace, and even if it will be used
later it is OK to read ->sighand again in the slow path.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |    5 +----
 kernel/signal.c           |   35 ++++++++++++-----------------------
 2 files changed, 13 insertions(+), 27 deletions(-)

diff -puN include/linux/tracehook.h~signals-simplify-sig_ignored-pathes include/linux/tracehook.h
--- a/include/linux/tracehook.h~signals-simplify-sig_ignored-pathes
+++ a/include/linux/tracehook.h
@@ -388,17 +388,14 @@ static inline void tracehook_signal_hand
  * tracehook_consider_ignored_signal - suppress short-circuit of ignored signal
  * @task:		task receiving the signal
  * @sig:		signal number being sent
- * @handler:		%SIG_IGN or %SIG_DFL
  *
  * Return zero iff tracing doesn't care to examine this ignored signal,
  * so it can short-circuit normal delivery and never even get queued.
- * Either @handler is %SIG_DFL and @sig's default is ignore, or it's %SIG_IGN.
  *
  * Called with @task->sighand->siglock held.
  */
 static inline int tracehook_consider_ignored_signal(struct task_struct *task,
-						    int sig,
-						    void __user *handler)
+						    int sig)
 {
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
diff -puN kernel/signal.c~signals-simplify-sig_ignored-pathes kernel/signal.c
--- a/kernel/signal.c~signals-simplify-sig_ignored-pathes
+++ a/kernel/signal.c
@@ -41,44 +41,33 @@
 
 static struct kmem_cache *sigqueue_cachep;
 
-static void __user *sig_handler(struct task_struct *t, int sig)
+static int sig_task_ignored(struct task_struct *t, int sig)
 {
 	void __user *h = t->sighand->action[sig - 1].sa.sa_handler;
 
-	/* drop SIGKILL early to not confuse wait_xxx_killable/etc */
-	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) && h == SIG_DFL)
-		h = SIG_IGN;
-
-	return h;
-}
-
-static int sig_handler_ignored(void __user *handler, int sig)
-{
-	/* Is it explicitly or implicitly ignored? */
-	return handler == SIG_IGN ||
-		(handler == SIG_DFL && sig_kernel_ignore(sig));
+	if (h == SIG_DFL) {
+		/* init drops SIGKILL early to not confuse xxx_killable/etc */
+		return sig_kernel_ignore(sig) ||
+			unlikely(t->signal->flags & SIGNAL_UNKILLABLE);
+	}
+	return h == SIG_IGN;
 }
 
 static int sig_ignored(struct task_struct *t, int sig)
 {
-	void __user *handler;
-
 	/*
 	 * Blocked signals are never ignored, since the
 	 * signal handler may change by the time it is
 	 * unblocked.
 	 */
-	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
-		return 0;
-
-	handler = sig_handler(t, sig);
-	if (!sig_handler_ignored(handler, sig))
+	if (sigismember(&t->blocked, sig) ||
+	    sigismember(&t->real_blocked, sig) ||
+	    !sig_task_ignored(t, sig))
 		return 0;
-
 	/*
 	 * Tracers may want to know about even ignored signals.
 	 */
-	return !tracehook_consider_ignored_signal(t, sig, handler);
+	return !tracehook_consider_ignored_signal(t, sig);
 }
 
 /*
@@ -2356,7 +2345,7 @@ int do_sigaction(int sig, struct k_sigac
 		 *   (for example, SIGCHLD), shall cause the pending signal to
 		 *   be discarded, whether or not it is blocked"
 		 */
-		if (sig_handler_ignored(sig_handler(t, sig), sig)) {
+		if (sig_task_ignored(t, sig)) {
 			sigemptyset(&mask);
 			sigaddset(&mask, sig);
 			rm_from_queue_full(&mask, &t->signal->shared_pending);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
forkc-cleanup-for-copy_sighand.patch
do_wait-wakeup-optimization.patch
signals-simplify-sig_ignored-pathes.patch
workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead.patch

