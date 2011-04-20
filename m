From: akpm@linux-foundation.org
Subject: [to-be-updated] x86-signal-handle_signal-should-use-sigprocmask.patch removed from -mm tree
Date: Wed, 20 Apr 2011 14:13:59 -0700
Message-ID: <201104202113.p3KLDxWd027436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135Ab1DTVOS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:14:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hpa@zytor.com, matt@console-pimps.org, mingo@elte.hu, nyoushchenko@mvista.com, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86: signal: handle_signal() should use sigprocmask()
has been removed from the -mm tree.  Its filename was
     x86-signal-handle_signal-should-use-sigprocmask.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: signal: handle_signal() should use sigprocmask()
From: Oleg Nesterov <oleg@redhat.com>

This is ugly, but if sigprocmask() needs retarget_shared_pending() then
handle signal should follow this logic.  In theory it is newer correct to
add the new signals to current->blocked, the signal handler can sleep/etc
so we should notify other threads in case we block the pending signal and
nobody else has TIF_SIGPENDING.

Of course, this change doesn't make signals faster :/

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/signal.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/signal.c~x86-signal-handle_signal-should-use-sigprocmask arch/x86/kernel/signal.c
--- a/arch/x86/kernel/signal.c~x86-signal-handle_signal-should-use-sigprocmask
+++ a/arch/x86/kernel/signal.c
@@ -682,6 +682,7 @@ static int
 handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	      sigset_t *oldset, struct pt_regs *regs)
 {
+	sigset_t blocked;
 	int ret;
 
 	/* Are we from a system call? */
@@ -741,12 +742,10 @@ handle_signal(unsigned long sig, siginfo
 	 */
 	regs->flags &= ~X86_EFLAGS_TF;
 
-	spin_lock_irq(&current->sighand->siglock);
-	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
+	blocked = ka->sa.sa_mask;
 	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked, sig);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+		sigaddset(&blocked, sig);
+	sigprocmask(SIG_BLOCK, &blocked, NULL);
 
 	tracehook_signal_handler(sig, info, ka, regs,
 				 test_thread_flag(TIF_SINGLESTEP));
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
x86-signal-sys_rt_sigreturn-should-use-sigprocmask.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

