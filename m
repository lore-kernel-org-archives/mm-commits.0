From: akpm@linux-foundation.org
Subject: - x86-tracehook-tif_notify_resume.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:48 -0700
Message-ID: <200808181940.m7IJemLm008488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760745AbYHRTvH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:51:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: tracehook: TIF_NOTIFY_RESUME
has been removed from the -mm tree.  Its filename was
     x86-tracehook-tif_notify_resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: tracehook: TIF_NOTIFY_RESUME
From: Roland McGrath <roland@redhat.com>

This adds TIF_NOTIFY_RESUME support for x86, both 64-bit and 32-bit.  When
set, we call tracehook_notify_resume() on the way to user mode.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/signal_32.c   |    5 +++++
 arch/x86/kernel/signal_64.c   |    5 +++++
 include/asm-x86/thread_info.h |    4 +++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/signal_32.c~x86-tracehook-tif_notify_resume arch/x86/kernel/signal_32.c
--- a/arch/x86/kernel/signal_32.c~x86-tracehook-tif_notify_resume
+++ a/arch/x86/kernel/signal_32.c
@@ -663,5 +663,10 @@ do_notify_resume(struct pt_regs *regs, v
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
+	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
+	}
+
 	clear_thread_flag(TIF_IRET);
 }
diff -puN arch/x86/kernel/signal_64.c~x86-tracehook-tif_notify_resume arch/x86/kernel/signal_64.c
--- a/arch/x86/kernel/signal_64.c~x86-tracehook-tif_notify_resume
+++ a/arch/x86/kernel/signal_64.c
@@ -523,6 +523,11 @@ void do_notify_resume(struct pt_regs *re
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
+
+	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
+	}
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
diff -puN include/asm-x86/thread_info.h~x86-tracehook-tif_notify_resume include/asm-x86/thread_info.h
--- a/include/asm-x86/thread_info.h~x86-tracehook-tif_notify_resume
+++ a/include/asm-x86/thread_info.h
@@ -71,6 +71,7 @@ struct thread_info {
  * Warning: layout of LSW is hardcoded in entry.S
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_NOTIFY_RESUME	1	/* callback before returning to user */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
@@ -93,6 +94,7 @@ struct thread_info {
 #define TIF_BTS_TRACE_TS	27      /* record scheduling event timestamps */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
@@ -133,7 +135,7 @@ struct thread_info {
 
 /* Only used for 64 bit */
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY)
+	(_TIF_SIGPENDING|_TIF_MCE_NOTIFY|_TIF_NOTIFY_RESUME)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
_

Patches currently in -mm which might be from roland@redhat.com are

linux-next.patch
x86-tracehook-config_have_arch_tracehook.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
wait_task_inactive-fix-the-config_smp-version.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

