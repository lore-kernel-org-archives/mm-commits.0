From: akpm@linux-foundation.org
Subject: [merged] ptrace-powerpc-implement-user_single_step_siginfo.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:03 -0800
Message-ID: <200912162038.nBGKc30B013393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964832AbZLPUi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ptrace: powerpc: implement user_single_step_siginfo()
has been removed from the -mm tree.  Its filename was
     ptrace-powerpc-implement-user_single_step_siginfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: powerpc: implement user_single_step_siginfo()
From: Oleg Nesterov <oleg@redhat.com>

Suggested by Roland.

Implement user_single_step_siginfo() for powerpc.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/ptrace.h |    2 ++
 arch/powerpc/kernel/traps.c       |    9 +++++++++
 2 files changed, 11 insertions(+)

diff -puN arch/powerpc/include/asm/ptrace.h~ptrace-powerpc-implement-user_single_step_siginfo arch/powerpc/include/asm/ptrace.h
--- a/arch/powerpc/include/asm/ptrace.h~ptrace-powerpc-implement-user_single_step_siginfo
+++ a/arch/powerpc/include/asm/ptrace.h
@@ -140,6 +140,8 @@ extern void user_enable_single_step(stru
 extern void user_enable_block_step(struct task_struct *);
 extern void user_disable_single_step(struct task_struct *);
 
+#define ARCH_HAS_USER_SINGLE_STEP_INFO
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff -puN arch/powerpc/kernel/traps.c~ptrace-powerpc-implement-user_single_step_siginfo arch/powerpc/kernel/traps.c
--- a/arch/powerpc/kernel/traps.c~ptrace-powerpc-implement-user_single_step_siginfo
+++ a/arch/powerpc/kernel/traps.c
@@ -174,6 +174,15 @@ int die(const char *str, struct pt_regs 
 	return 0;
 }
 
+void user_single_step_siginfo(struct task_struct *tsk,
+				struct pt_regs *regs, siginfo_t *info)
+{
+	memset(info, 0, sizeof(*info));
+	info->si_signo = SIGTRAP;
+	info->si_code = TRAP_TRACE;
+	info->si_addr = (void __user *)regs->nip;
+}
+
 void _exception(int signr, struct pt_regs *regs, int code, unsigned long addr)
 {
 	siginfo_t info;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
mm-introduce-coredump-parameter-structure.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch

