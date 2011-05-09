From: akpm@linux-foundation.org
Subject: [to-be-updated] x86-signal-sys_rt_sigreturn-should-use-set_current_blocked.patch removed from -mm tree
Date: Mon, 09 May 2011 12:17:15 -0700
Message-ID: <201105091910.p49JAFTY011872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab1EITLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 15:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hpa@zytor.com, matt@console-pimps.org, mingo@elte.hu, nyoushchenko@mvista.com, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86: signal: sys_rt_sigreturn() should use set_current_blocked()
has been removed from the -mm tree.  Its filename was
     x86-signal-sys_rt_sigreturn-should-use-set_current_blocked.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: signal: sys_rt_sigreturn() should use set_current_blocked()
From: Oleg Nesterov <oleg@redhat.com>

Normally sys_rt_sigreturn() restores the old current->blocked which was
changed by handle_signal(), and unblocking is always fine.

But the debugger or application itself can change frame->uc_sigmask and
thus we need set_current_blocked()->retarget_shared_pending().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
Reviewed-by: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/signal.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/x86/kernel/signal.c~x86-signal-sys_rt_sigreturn-should-use-set_current_blocked arch/x86/kernel/signal.c
--- a/arch/x86/kernel/signal.c~x86-signal-sys_rt_sigreturn-should-use-set_current_blocked
+++ a/arch/x86/kernel/signal.c
@@ -601,10 +601,7 @@ long sys_rt_sigreturn(struct pt_regs *re
 		goto badframe;
 
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	spin_lock_irq(&current->sighand->siglock);
-	current->blocked = set;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&set);
 
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &ax))
 		goto badframe;
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
ptrace-fix-signal-wait_chldexit-usage-in-task_clear_group_stop_trapping.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
signal-cleanup-sys_rt_sigprocmask.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

