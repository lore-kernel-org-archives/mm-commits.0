From: akpm@linux-foundation.org
Subject: - signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:03 -0700
Message-ID: <200805010926.m419Q3Um030270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757360AbYEAJ1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     signals: consolidate checks for whether or not to ignore a signal
has been removed from the -mm tree.  Its filename was
     signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: consolidate checks for whether or not to ignore a signal
From: Pavel Emelyanov <xemul@openvz.org>

Both sig_ignored() and do_sigactoin() check for signr to be explicitly or
implicitly ignored.  Introduce a helper for them.

This patch is aimed to help handling signals by pid namespace's init, and was
derived from one of Oleg's patches
https://lists.linux-foundation.org/pipermail/containers/2007-December/009308.html
so, if he doesn't mind, he should be considered as an author.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff -puN kernel/signal.c~signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal kernel/signal.c
--- a/kernel/signal.c~signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal
+++ a/kernel/signal.c
@@ -39,11 +39,19 @@
 
 static struct kmem_cache *sigqueue_cachep;
 
+static int __sig_ignored(struct task_struct *t, int sig)
+{
+	void __user *handler;
+
+	/* Is it explicitly or implicitly ignored? */
+
+	handler = t->sighand->action[sig - 1].sa.sa_handler;
+	return handler == SIG_IGN ||
+		(handler == SIG_DFL && sig_kernel_ignore(sig));
+}
 
 static int sig_ignored(struct task_struct *t, int sig)
 {
-	void __user * handler;
-
 	/*
 	 * Tracers always want to know about signals..
 	 */
@@ -58,10 +66,7 @@ static int sig_ignored(struct task_struc
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	/* Is it explicitly or implicitly ignored? */
-	handler = t->sighand->action[sig-1].sa.sa_handler;
-	return   handler == SIG_IGN ||
-		(handler == SIG_DFL && sig_kernel_ignore(sig));
+	return __sig_ignored(t, sig);
 }
 
 /*
@@ -2331,13 +2336,14 @@ sys_rt_sigqueueinfo(int pid, int sig, si
 
 int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 {
+	struct task_struct *t = current;
 	struct k_sigaction *k;
 	sigset_t mask;
 
 	if (!valid_signal(sig) || sig < 1 || (act && sig_kernel_only(sig)))
 		return -EINVAL;
 
-	k = &current->sighand->action[sig-1];
+	k = &t->sighand->action[sig-1];
 
 	spin_lock_irq(&current->sighand->siglock);
 	if (oact)
@@ -2358,9 +2364,7 @@ int do_sigaction(int sig, struct k_sigac
 		 *   (for example, SIGCHLD), shall cause the pending signal to
 		 *   be discarded, whether or not it is blocked"
 		 */
-		if (act->sa.sa_handler == SIG_IGN ||
-		   (act->sa.sa_handler == SIG_DFL && sig_kernel_ignore(sig))) {
-			struct task_struct *t = current;
+		if (__sig_ignored(t, sig)) {
 			sigemptyset(&mask);
 			sigaddset(&mask, sig);
 			rm_from_queue_full(&mask, &t->signal->shared_pending);
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
disable-the-memory-controller-by-default-v3.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

