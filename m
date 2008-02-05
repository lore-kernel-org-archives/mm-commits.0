From: akpm@linux-foundation.org
Subject: - uml-clean-up-sig_handler_common_skas.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:54 -0800
Message-ID: <200802052237.m15MbZ0S012862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762511AbYBEWlq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: clean up sig_handler_common_skas
has been removed from the -mm tree.  Its filename was
     uml-clean-up-sig_handler_common_skas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: clean up sig_handler_common_skas
From: Jeff Dike <jdike@addtoit.com>

sig_handler_common_skas needs significant modernization, starting with
its name and storage class.

There is no need to hide the true type of the sigcontext pointer, so
the void * dummy parameter can be replaced with a sigcontext *sc.

The array of uml_pt_regs structs used in the page fault case are gone,
replaced by a local variable.  This is also used in the non-segfault
case instead of the copy in the task_struct.  Since it's local, the
special handling of the is_user flag can go away.

There hasn't been any special treatment of SIGUSR1 in ages, so the
line that enables it can be deleted.

The special treatment of SIGSEGV similarly goes away, but to
compensate, SA_NODEFER is added to sa_mask when registering a signal
handler.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/signal.c |   63 ++++++++++--------------------------
 1 file changed, 18 insertions(+), 45 deletions(-)

diff -puN arch/um/os-Linux/signal.c~uml-clean-up-sig_handler_common_skas arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-clean-up-sig_handler_common_skas
+++ a/arch/um/os-Linux/signal.c
@@ -10,14 +10,15 @@
 #include <signal.h>
 #include <strings.h>
 #include "as-layout.h"
-#include "kern_constants.h"
 #include "kern_util.h"
 #include "os.h"
 #include "sysdep/barrier.h"
 #include "sysdep/sigcontext.h"
-#include "task.h"
 #include "user.h"
 
+/* Copied from linux/compiler-gcc.h since we can't include it directly */
+#define barrier() __asm__ __volatile__("": : :"memory")
+
 void (*sig_info[NSIG])(int, struct uml_pt_regs *) = {
 	[SIGTRAP]	= relay_signal,
 	[SIGFPE]	= relay_signal,
@@ -28,58 +29,27 @@ void (*sig_info[NSIG])(int, struct uml_p
 	[SIGIO]		= sigio_handler,
 	[SIGVTALRM]	= timer_handler };
 
-static struct uml_pt_regs ksig_regs[UM_NR_CPUS];
-
-void sig_handler_common_skas(int sig, void *sc_ptr)
+static void sig_handler_common(int sig, struct sigcontext *sc)
 {
-	struct sigcontext *sc = sc_ptr;
-	struct uml_pt_regs *r;
-	void (*handler)(int, struct uml_pt_regs *);
-	int save_user, save_errno = errno;
+	struct uml_pt_regs r;
+	int save_errno = errno;
 
-	/*
-	 * This is done because to allow SIGSEGV to be delivered inside a SEGV
-	 * handler.  This can happen in copy_user, and if SEGV is disabled,
-	 * the process will die.
-	 * XXX Figure out why this is better than SA_NODEFER
-	 */
+	r.is_user = 0;
 	if (sig == SIGSEGV) {
-		change_sig(SIGSEGV, 1);
-		/*
-		 * For segfaults, we want the data from the
-		 * sigcontext.  In this case, we don't want to mangle
-		 * the process registers, so use a static set of
-		 * registers.  For other signals, the process
-		 * registers are OK.
-		 */
-		r = &ksig_regs[cpu()];
-		copy_sc(r, sc_ptr);
-	} else
-		r = TASK_REGS(get_current());
-
-	save_user = r->is_user;
-	r->is_user = 0;
-	if ((sig == SIGFPE) || (sig == SIGSEGV) || (sig == SIGBUS) ||
-	    (sig == SIGILL) || (sig == SIGTRAP))
-		GET_FAULTINFO_FROM_SC(r->faultinfo, sc);
-
-	change_sig(SIGUSR1, 1);
-
-	handler = sig_info[sig];
+		/* For segfaults, we want the data from the sigcontext. */
+		copy_sc(&r, sc);
+		GET_FAULTINFO_FROM_SC(r.faultinfo, sc);
+	}
 
-	/* unblock SIGVTALRM, SIGIO if sig isn't IRQ signal */
+	/* enable signals if sig isn't IRQ signal */
 	if ((sig != SIGIO) && (sig != SIGWINCH) && (sig != SIGVTALRM))
 		unblock_signals();
 
-	handler(sig, r);
+	(*sig_info[sig])(sig, &r);
 
 	errno = save_errno;
-	r->is_user = save_user;
 }
 
-/* Copied from linux/compiler-gcc.h since we can't include it directly */
-#define barrier() __asm__ __volatile__("": : :"memory")
-
 /*
  * These are the asynchronous signals.  SIGPROF is excluded because we want to
  * be able to profile all of UML, not just the non-critical sections.  If
@@ -107,7 +77,7 @@ void sig_handler(int sig, struct sigcont
 
 	block_signals();
 
-	sig_handler_common_skas(sig, sc);
+	sig_handler_common(sig, sc);
 
 	set_signals(enabled);
 }
@@ -227,6 +197,9 @@ void set_handler(int sig, void (*handler
 		sigaddset(&action.sa_mask, mask);
 	va_end(ap);
 
+	if (sig == SIGSEGV)
+		flags |= SA_NODEFER;
+
 	action.sa_flags = flags;
 	action.sa_restorer = NULL;
 	if (sigaction(sig, &action, NULL) < 0)
@@ -306,7 +279,7 @@ void unblock_signals(void)
 		 * back here.
 		 */
 		if (save_pending & SIGIO_MASK)
-			sig_handler_common_skas(SIGIO, NULL);
+			sig_handler_common(SIGIO, NULL);
 
 		if (save_pending & SIGVTALRM_MASK)
 			real_alarm_handler(NULL);
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
