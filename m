From: akpm@linux-foundation.org
Subject: + x86-tracehook-tif_notify_resume.patch added to -mm tree
Date: Sat, 26 Jul 2008 00:09:15 -0700
Message-ID: <200807260709.m6Q79FXR021421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbYGZHKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 03:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: tracehook: TIF_NOTIFY_RESUME
has been added to the -mm tree.  Its filename is
     x86-tracehook-tif_notify_resume.patch

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

