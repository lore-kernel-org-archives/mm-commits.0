From: akpm@linux-foundation.org
Subject: [merged] ptrace-x86-implement-user_single_step_siginfo.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:09 -0800
Message-ID: <200912162038.nBGKc97h013404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964950AbZLPUir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ptrace: x86: implement user_single_step_siginfo()
has been removed from the -mm tree.  Its filename was
     ptrace-x86-implement-user_single_step_siginfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: x86: implement user_single_step_siginfo()
From: Oleg Nesterov <oleg@redhat.com>

Suggested by Roland.

Implement user_single_step_siginfo() for x86.  Extract this code from
send_sigtrap().

Since x86 calls tracehook_report_syscall_exit(step => 0) the new helper is
not used yet.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/ptrace.h |    2 ++
 arch/x86/kernel/ptrace.c      |   30 +++++++++++++++++++++---------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff -puN arch/x86/include/asm/ptrace.h~ptrace-x86-implement-user_single_step_siginfo arch/x86/include/asm/ptrace.h
--- a/arch/x86/include/asm/ptrace.h~ptrace-x86-implement-user_single_step_siginfo
+++ a/arch/x86/include/asm/ptrace.h
@@ -292,6 +292,8 @@ extern void user_enable_block_step(struc
 #define arch_has_block_step()	(boot_cpu_data.x86 >= 6)
 #endif
 
+#define ARCH_HAS_USER_SINGLE_STEP_INFO
+
 struct user_desc;
 extern int do_get_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info);
diff -puN arch/x86/kernel/ptrace.c~ptrace-x86-implement-user_single_step_siginfo arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~ptrace-x86-implement-user_single_step_siginfo
+++ a/arch/x86/kernel/ptrace.c
@@ -1676,21 +1676,33 @@ const struct user_regset_view *task_user
 #endif
 }
 
-void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
-					 int error_code, int si_code)
+static void fill_sigtrap_info(struct task_struct *tsk,
+				struct pt_regs *regs,
+				int error_code, int si_code,
+				struct siginfo *info)
 {
-	struct siginfo info;
-
 	tsk->thread.trap_no = 1;
 	tsk->thread.error_code = error_code;
 
-	memset(&info, 0, sizeof(info));
-	info.si_signo = SIGTRAP;
-	info.si_code = si_code;
+	memset(info, 0, sizeof(*info));
+	info->si_signo = SIGTRAP;
+	info->si_code = si_code;
+	info->si_addr = user_mode_vm(regs) ? (void __user *)regs->ip : NULL;
+}
+
+void user_single_step_siginfo(struct task_struct *tsk,
+				struct pt_regs *regs,
+				struct siginfo *info)
+{
+	fill_sigtrap_info(tsk, regs, 0, TRAP_BRKPT, info);
+}
 
-	/* User-mode ip? */
-	info.si_addr = user_mode_vm(regs) ? (void __user *) regs->ip : NULL;
+void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
+					 int error_code, int si_code)
+{
+	struct siginfo info;
 
+	fill_sigtrap_info(tsk, regs, error_code, si_code, &info);
 	/* Send us the fake SIGTRAP */
 	force_sig_info(SIGTRAP, &info, tsk);
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
mm-introduce-coredump-parameter-structure.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch

