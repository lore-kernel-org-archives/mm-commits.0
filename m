From: akpm@linux-foundation.org
Subject: + ptrace-powerpc-implement-user_single_step_siginfo.patch added to -mm tree
Date: Thu, 12 Nov 2009 15:17:40 -0800
Message-ID: <200911122317.nACNHeSP030690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754696AbZKLXS1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 18:18:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de


The patch titled
     ptrace: powerpc: implement user_single_step_siginfo()
has been added to the -mm tree.  Its filename is
     ptrace-powerpc-implement-user_single_step_siginfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch
ptrace-cleanup-ptrace_init_task-ptrace_link-path.patch
ptrace-copy_process-should-disable-stepping.patch
ptrace-introduce-user_single_step_siginfo-helper.patch
ptrace-powerpc-implement-user_single_step_siginfo.patch
ptrace-change-tracehook_report_syscall_exit-to-handle-stepping.patch
ptrace-x86-implement-user_single_step_siginfo.patch
ptrace-x86-change-syscall_trace_leave-to-rely-on-tracehook-when-stepping.patch
signals-send_sig_noinfo-should-be-considered-as-si_fromuser.patch
signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns.patch
signals-cosmetic-collect_signal-use-si_user.patch
signals-kill-force_sig_specific.patch
signals-check-group_stop_count-after-tracehook_get_signal.patch
utrace-core.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

