From: akpm@linux-foundation.org
Subject: - uml-signal-handling-tidying.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:03 -0800
Message-ID: <200802052237.m15MbiRV012884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33852 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762336AbYBEWlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: signal handling tidying
has been removed from the -mm tree.  Its filename was
     uml-signal-handling-tidying.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: signal handling tidying
From: Jeff Dike <jdike@addtoit.com>

This patch tidies the signal handling code slightly.

pending is renamed to signals_pending for symmetry with signals_enabled.

remove_sigstack was unused, so can be deleted.

The value of change_sig was never used, so it is now void and the
return value is not calculated any more.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/signal.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff -puN arch/um/os-Linux/signal.c~uml-signal-handling-tidying arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-signal-handling-tidying
+++ a/arch/um/os-Linux/signal.c
@@ -63,7 +63,7 @@ static void sig_handler_common(int sig, 
 #define SIGVTALRM_MASK (1 << SIGVTALRM_BIT)
 
 static int signals_enabled;
-static unsigned int pending;
+static unsigned int signals_pending;
 
 void sig_handler(int sig, struct sigcontext *sc)
 {
@@ -71,7 +71,7 @@ void sig_handler(int sig, struct sigcont
 
 	enabled = signals_enabled;
 	if (!enabled && (sig == SIGIO)) {
-		pending |= SIGIO_MASK;
+		signals_pending |= SIGIO_MASK;
 		return;
 	}
 
@@ -99,7 +99,7 @@ void alarm_handler(int sig, struct sigco
 
 	enabled = signals_enabled;
 	if (!signals_enabled) {
-		pending |= SIGVTALRM_MASK;
+		signals_pending |= SIGVTALRM_MASK;
 		return;
 	}
 
@@ -125,16 +125,6 @@ void set_sigstack(void *sig_stack, int s
 		panic("enabling signal stack failed, errno = %d\n", errno);
 }
 
-void remove_sigstack(void)
-{
-	stack_t stack = ((stack_t) { .ss_flags	= SS_DISABLE,
-				     .ss_sp	= NULL,
-				     .ss_size	= 0 });
-
-	if (sigaltstack(&stack, NULL) != 0)
-		panic("disabling signal stack failed, errno = %d\n", errno);
-}
-
 void (*handlers[_NSIG])(int sig, struct sigcontext *sc);
 
 void handle_signal(int sig, struct sigcontext *sc)
@@ -213,13 +203,14 @@ void set_handler(int sig, void (*handler
 
 int change_sig(int signal, int on)
 {
-	sigset_t sigset, old;
+	sigset_t sigset;
 
 	sigemptyset(&sigset);
 	sigaddset(&sigset, signal);
-	if (sigprocmask(on ? SIG_UNBLOCK : SIG_BLOCK, &sigset, &old) < 0)
+	if (sigprocmask(on ? SIG_UNBLOCK : SIG_BLOCK, &sigset, NULL) < 0)
 		return -errno;
-	return !sigismember(&old, signal);
+
+	return 0;
 }
 
 void block_signals(void)
@@ -244,26 +235,26 @@ void unblock_signals(void)
 	/*
 	 * We loop because the IRQ handler returns with interrupts off.  So,
 	 * interrupts may have arrived and we need to re-enable them and
-	 * recheck pending.
+	 * recheck signals_pending.
 	 */
 	while(1) {
 		/*
 		 * Save and reset save_pending after enabling signals.  This
-		 * way, pending won't be changed while we're reading it.
+		 * way, signals_pending won't be changed while we're reading it.
 		 */
 		signals_enabled = 1;
 
 		/*
-		 * Setting signals_enabled and reading pending must
+		 * Setting signals_enabled and reading signals_pending must
 		 * happen in this order.
 		 */
 		barrier();
 
-		save_pending = pending;
+		save_pending = signals_pending;
 		if (save_pending == 0)
 			return;
 
-		pending = 0;
+		signals_pending = 0;
 
 		/*
 		 * We have pending interrupts, so disable signals, as the
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
