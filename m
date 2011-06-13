From: akpm@linux-foundation.org
Subject: [merged] exec-delay-address-limit-change-until-point-of-no-return.patch removed from -mm tree
Date: Mon, 13 Jun 2011 11:52:57 -0700
Message-ID: <201106131852.p5DIqu2B014786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899Ab1FMSxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jun 2011 14:53:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minipli@googlemail.com, hpa@zytor.com, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     exec: delay address limit change until point of no return
has been removed from the -mm tree.  Its filename was
     exec-delay-address-limit-change-until-point-of-no-return.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: delay address limit change until point of no return
From: Mathias Krause <minipli@googlemail.com>

We use kernel_execve() to transfer control of the init procces from
kernel to userland. If the program to start as init process isn't given
on the kernel command line or fails to start we use a few hardcoded
fallbacks. This fallback mechanism does not work when we encounter a
file that is executable but fails to start, e.g. due to a missing
library dependency or by having an unsupported file format.

Unconditionally changing the address limit to USER_DS and not restoring it
to its old value in the error path is wrong because it prevents us using
kernel memory on repeated calls to this function.  This, in fact, breaks
the fallback of hard coded paths to the init program from being ever
successful if the first candidate fails to load.

With this patch applied switching to USER_DS is delayed until the point of
no return is reached which makes it possible to have a multi-arch rootfs
with one arch specific init binary for each of the (hard coded) probed
paths.

Since the address limit is already set to USER_DS when start_thread()
will be invoked, this redundancy can be safely removed.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/process_32.c |    1 -
 arch/x86/kernel/process_64.c |    1 -
 fs/exec.c                    |    5 +----
 3 files changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/x86/kernel/process_32.c~exec-delay-address-limit-change-until-point-of-no-return arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~exec-delay-address-limit-change-until-point-of-no-return
+++ a/arch/x86/kernel/process_32.c
@@ -245,7 +245,6 @@ start_thread(struct pt_regs *regs, unsig
 {
 	set_user_gs(regs, 0);
 	regs->fs		= 0;
-	set_fs(USER_DS);
 	regs->ds		= __USER_DS;
 	regs->es		= __USER_DS;
 	regs->ss		= __USER_DS;
diff -puN arch/x86/kernel/process_64.c~exec-delay-address-limit-change-until-point-of-no-return arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~exec-delay-address-limit-change-until-point-of-no-return
+++ a/arch/x86/kernel/process_64.c
@@ -338,7 +338,6 @@ start_thread_common(struct pt_regs *regs
 	regs->cs		= _cs;
 	regs->ss		= _ss;
 	regs->flags		= X86_EFLAGS_IF;
-	set_fs(USER_DS);
 	/*
 	 * Free the old FP and other extended state
 	 */
diff -puN fs/exec.c~exec-delay-address-limit-change-until-point-of-no-return fs/exec.c
--- a/fs/exec.c~exec-delay-address-limit-change-until-point-of-no-return
+++ a/fs/exec.c
@@ -1093,6 +1093,7 @@ int flush_old_exec(struct linux_binprm *
 
 	bprm->mm = NULL;		/* We're using it now */
 
+	set_fs(USER_DS);
 	current->flags &= ~(PF_RANDOMIZE | PF_KTHREAD);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
@@ -1357,10 +1358,6 @@ int search_binary_handler(struct linux_b
 	if (retval)
 		return retval;
 
-	/* kernel module loader fixup */
-	/* so we don't try to load run modprobe in kernel space. */
-	set_fs(USER_DS);
