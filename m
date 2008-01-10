From: akpm@linux-foundation.org
Subject: + uml-signal-handling-tidying.patch added to -mm tree
Date: Wed, 09 Jan 2008 23:59:45 -0800
Message-ID: <200801100759.m0A7xPwZ011864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857AbYAJH7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 02:59:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: signal handling tidying
has been added to the -mm tree.  Its filename is
     uml-signal-handling-tidying.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-kvm.patch
git-x86.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-header-untangling-fix.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-miscellaneous-code-cleanups.patch
uml-style-fixes-in-filec.patch
uml-64-bit-tlb-fixes.patch
uml-customize-tlbh.patch
uml-eliminate-setjmp_wrapper.patch
uml-install-panic-notifier-earlier.patch
uml-use-barrier-instead-of-mb.patch
uml-tidy-helper-code.patch
uml-dont-kill-pid-0.patch
uml-get-rid-of-syscall-counters.patch
uml-dont-allow-processes-to-call-into-stub.patch
uml-move-sig_handler_common_skas.patch
uml-clean-up-sig_handler_common_skas.patch
uml-style-fixes-in-arch-um-kernel.patch
uml-signal-handling-tidying.patch
uml-remove-init_irq_signals.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
uml-re-remove-accidentally-restored-code.patch
