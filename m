From: akpm@linux-foundation.org
Subject: + x86-tracehook_signal_handler.patch added to -mm tree
Date: Sat, 26 Jul 2008 00:09:07 -0700
Message-ID: <200807260709.m6Q7972S021409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086AbYGZHKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 03:10:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: tracehook_signal_handler
has been added to the -mm tree.  Its filename is
     x86-tracehook_signal_handler.patch

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
Subject: x86: tracehook_signal_handler
From: Roland McGrath <roland@redhat.com>

This makes the x86 signal handling code use tracehook_signal_handler() in
place of calling into ptrace guts.  The call is moved after the sa_mask
processing, but there is no other change.  This cleanup doesn't matter to
existing debuggers, but is the sensible thing: have all facets of the
handler setup complete before the debugger inspects the task again.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/signal_32.c |    6 ++++--
 arch/x86/kernel/signal_64.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/signal_32.c~x86-tracehook_signal_handler arch/x86/kernel/signal_32.c
--- a/arch/x86/kernel/signal_32.c~x86-tracehook_signal_handler
+++ a/arch/x86/kernel/signal_32.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
+#include <linux/tracehook.h>
 #include <linux/elf.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
@@ -558,8 +559,6 @@ handle_signal(unsigned long sig, siginfo
 	 * handler too.
 	 */
 	regs->flags &= ~X86_EFLAGS_TF;
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
 
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
@@ -568,6 +567,9 @@ handle_signal(unsigned long sig, siginfo
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
+	tracehook_signal_handler(sig, info, ka, regs,
+				 test_thread_flag(TIF_SINGLESTEP));
+
 	return 0;
 }
 
diff -puN arch/x86/kernel/signal_64.c~x86-tracehook_signal_handler arch/x86/kernel/signal_64.c
--- a/arch/x86/kernel/signal_64.c~x86-tracehook_signal_handler
+++ a/arch/x86/kernel/signal_64.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/personality.h>
@@ -444,8 +445,6 @@ handle_signal(unsigned long sig, siginfo
 		 * handler too.
 		 */
 		regs->flags &= ~X86_EFLAGS_TF;
-		if (test_thread_flag(TIF_SINGLESTEP))
-			ptrace_notify(SIGTRAP);
 
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
@@ -453,6 +452,9 @@ handle_signal(unsigned long sig, siginfo
 			sigaddset(&current->blocked,sig);
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
+
+		tracehook_signal_handler(sig, info, ka, regs,
+					 test_thread_flag(TIF_SINGLESTEP));
 	}
 
 	return ret;
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

