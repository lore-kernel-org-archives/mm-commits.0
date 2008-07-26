From: akpm@linux-foundation.org
Subject: + x86-signals-use-asm-syscallh.patch added to -mm tree
Date: Sat, 26 Jul 2008 00:09:13 -0700
Message-ID: <200807260709.m6Q79D7n021418@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbYGZHKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 03:10:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86 signals: use asm/syscall.h
has been added to the -mm tree.  Its filename is
     x86-signals-use-asm-syscallh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 signals: use asm/syscall.h
From: Roland McGrath <roland@redhat.com>

Replace local inlines with the asm/syscall.h interfaces that do the same
things.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/signal_64.c |   38 ++++------------------------------
 1 file changed, 5 insertions(+), 33 deletions(-)

diff -puN arch/x86/kernel/signal_64.c~x86-signals-use-asm-syscallh arch/x86/kernel/signal_64.c
--- a/arch/x86/kernel/signal_64.c~x86-signals-use-asm-syscallh
+++ a/arch/x86/kernel/signal_64.c
@@ -27,6 +27,7 @@
 #include <asm/proto.h>
 #include <asm/ia32_unistd.h>
 #include <asm/mce.h>
+#include <asm/syscall.h>
 #include "sigframe.h"
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
@@ -347,35 +348,6 @@ give_sigsegv:
 }
 
 /*
- * Return -1L or the syscall number that @regs is executing.
- */
-static long current_syscall(struct pt_regs *regs)
-{
-	/*
-	 * We always sign-extend a -1 value being set here,
-	 * so this is always either -1L or a syscall number.
-	 */
-	return regs->orig_ax;
-}
-
-/*
- * Return a value that is -EFOO if the system call in @regs->orig_ax
- * returned an error.  This only works for @regs from @current.
- */
-static long current_syscall_ret(struct pt_regs *regs)
-{
-#ifdef CONFIG_IA32_EMULATION
-	if (test_thread_flag(TIF_IA32))
-		/*
-		 * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
-		 * and will match correctly in comparisons.
-		 */
-		return (int) regs->ax;
-#endif
-	return regs->ax;
-}
-
-/*
  * OK, we're invoking a handler
  */	
 
@@ -386,9 +358,9 @@ handle_signal(unsigned long sig, siginfo
 	int ret;
 
 	/* Are we from a system call? */
-	if (current_syscall(regs) >= 0) {
+	if (syscall_get_nr(current, regs) >= 0) {
 		/* If so, check system call restarting.. */
-		switch (current_syscall_ret(regs)) {
+		switch (syscall_get_error(current, regs)) {
 		case -ERESTART_RESTARTBLOCK:
 		case -ERESTARTNOHAND:
 			regs->ax = -EINTR;
@@ -511,9 +483,9 @@ static void do_signal(struct pt_regs *re
 	}
 
 	/* Did we come from a system call? */
-	if (current_syscall(regs) >= 0) {
+	if (syscall_get_nr(current, regs) >= 0) {
 		/* Restart the system call - no handlers present */
-		switch (current_syscall_ret(regs)) {
+		switch (syscall_get_error(current, regs)) {
 		case -ERESTARTNOHAND:
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

