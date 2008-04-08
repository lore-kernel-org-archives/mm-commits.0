From: akpm@linux-foundation.org
Subject: + signals-s390-renumber-tif_restore_sigmask.patch added to -mm tree
Date: Mon, 07 Apr 2008 17:52:43 -0700
Message-ID: <200804080052.m380qher000858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635AbYDHAyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 20:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, heiko.carstens@de.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     signals: s390: renumber TIF_RESTORE_SIGMASK
has been added to the -mm tree.  Its filename is
     signals-s390-renumber-tif_restore_sigmask.patch

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
Subject: signals: s390: renumber TIF_RESTORE_SIGMASK
From: Roland McGrath <roland@redhat.com>

TIF_RESTORE_SIGMASK no longer needs to be in the _TIF_WORK_* masks.  Those low
bits are scarce, and are all used up now.  Renumber TIF_RESTORE_SIGMASK to
free one up.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/entry.S       |   14 +++++++-------
 arch/s390/kernel/entry64.S     |   12 ++++++------
 include/asm-s390/thread_info.h |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff -puN arch/s390/kernel/entry.S~signals-s390-renumber-tif_restore_sigmask arch/s390/kernel/entry.S
--- a/arch/s390/kernel/entry.S~signals-s390-renumber-tif_restore_sigmask
+++ a/arch/s390/kernel/entry.S
@@ -49,9 +49,9 @@ SP_ILC	     =	STACK_FRAME_OVERHEAD + __P
 SP_TRAP      =	STACK_FRAME_OVERHEAD + __PT_TRAP
 SP_SIZE      =	STACK_FRAME_OVERHEAD + __PT_SIZE
 
-_TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NEED_RESCHED | \
+_TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING | _TIF_RESTART_SVC | _TIF_SINGLE_STEP )
-_TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NEED_RESCHED | \
+_TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING)
 
 STACK_SHIFT = PAGE_SHIFT + THREAD_ORDER
@@ -316,7 +316,7 @@ sysc_work:
 	bo	BASED(sysc_mcck_pending)
 	tm	__TI_flags+3(%r9),_TIF_NEED_RESCHED
 	bo	BASED(sysc_reschedule)
-	tm	__TI_flags+3(%r9),(_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK)
+	tm	__TI_flags+3(%r9),_TIF_SIGPENDING
 	bnz	BASED(sysc_sigpending)
 	tm	__TI_flags+3(%r9),_TIF_RESTART_SVC
 	bo	BASED(sysc_restart)
@@ -342,7 +342,7 @@ sysc_mcck_pending:
 	br	%r1			# TIF bit will be cleared by handler
 
 #
-# _TIF_SIGPENDING or _TIF_RESTORE_SIGMASK is set, call do_signal
+# _TIF_SIGPENDING is set, call do_signal
 #
 sysc_sigpending:
 	ni	__TI_flags+3(%r9),255-_TIF_SINGLE_STEP # clear TIF_SINGLE_STEP
@@ -657,7 +657,7 @@ io_work:
 	lr	%r15,%r1
 #
 # One of the work bits is on. Find out which one.
-# Checked are: _TIF_SIGPENDING, _TIF_RESTORE_SIGMASK, _TIF_NEED_RESCHED
+# Checked are: _TIF_SIGPENDING, _TIF_NEED_RESCHED
 #		and _TIF_MCCK_PENDING
 #
 io_work_loop:
@@ -665,7 +665,7 @@ io_work_loop:
 	bo	BASED(io_mcck_pending)
 	tm	__TI_flags+3(%r9),_TIF_NEED_RESCHED
 	bo	BASED(io_reschedule)
-	tm	__TI_flags+3(%r9),(_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK)
+	tm	__TI_flags+3(%r9),_TIF_SIGPENDING
 	bnz	BASED(io_sigpending)
 	b	BASED(io_restore)
 io_work_done:
@@ -693,7 +693,7 @@ io_reschedule:
 	b	BASED(io_work_loop)
 
 #
-# _TIF_SIGPENDING or _TIF_RESTORE_SIGMASK is set, call do_signal
+# _TIF_SIGPENDING is set, call do_signal
 #
 io_sigpending:
 	TRACE_IRQS_ON
diff -puN arch/s390/kernel/entry64.S~signals-s390-renumber-tif_restore_sigmask arch/s390/kernel/entry64.S
--- a/arch/s390/kernel/entry64.S~signals-s390-renumber-tif_restore_sigmask
+++ a/arch/s390/kernel/entry64.S
@@ -52,9 +52,9 @@ SP_SIZE      =	STACK_FRAME_OVERHEAD + __
 STACK_SHIFT = PAGE_SHIFT + THREAD_ORDER
 STACK_SIZE  = 1 << STACK_SHIFT
 
-_TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NEED_RESCHED | \
+_TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING | _TIF_RESTART_SVC | _TIF_SINGLE_STEP )
-_TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NEED_RESCHED | \
+_TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING)
 
 #define BASED(name) name-system_call(%r13)
@@ -308,7 +308,7 @@ sysc_work:
 	jo	sysc_mcck_pending
 	tm	__TI_flags+7(%r9),_TIF_NEED_RESCHED
 	jo	sysc_reschedule
-	tm	__TI_flags+7(%r9),(_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK)
+	tm	__TI_flags+7(%r9),_TIF_SIGPENDING
 	jnz	sysc_sigpending
 	tm	__TI_flags+7(%r9),_TIF_RESTART_SVC
 	jo	sysc_restart
@@ -332,7 +332,7 @@ sysc_mcck_pending:
 	jg	s390_handle_mcck	# TIF bit will be cleared by handler
 
 #
-# _TIF_SIGPENDING or _TIF_RESTORE_SIGMASK is set, call do_signal
+# _TIF_SIGPENDING is set, call do_signal
 #
 sysc_sigpending:
 	ni	__TI_flags+7(%r9),255-_TIF_SINGLE_STEP # clear TIF_SINGLE_STEP
@@ -647,7 +647,7 @@ io_work_loop:
 	jo	io_mcck_pending
 	tm	__TI_flags+7(%r9),_TIF_NEED_RESCHED
 	jo	io_reschedule
-	tm	__TI_flags+7(%r9),(_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK)
+	tm	__TI_flags+7(%r9),_TIF_SIGPENDING
 	jnz	io_sigpending
 	j	io_restore
 io_work_done:
@@ -673,7 +673,7 @@ io_reschedule:
 	j	io_work_loop
 
 #
-# _TIF_SIGPENDING or _TIF_RESTORE_SIGMASK is set, call do_signal
+# _TIF_SIGPENDING or is set, call do_signal
 #
 io_sigpending:
 	TRACE_IRQS_ON
diff -puN include/asm-s390/thread_info.h~signals-s390-renumber-tif_restore_sigmask include/asm-s390/thread_info.h
--- a/include/asm-s390/thread_info.h~signals-s390-renumber-tif_restore_sigmask
+++ a/include/asm-s390/thread_info.h
@@ -89,7 +89,6 @@ static inline struct thread_info *curren
  * thread information flags bit numbers
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_RESTORE_SIGMASK	1	/* restore signal mask in do_signal() */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTART_SVC		4	/* restart svc with new svc number */
@@ -101,6 +100,7 @@ static inline struct thread_info *curren
 					   TIF_NEED_RESCHED */
 #define TIF_31BIT		18	/* 32bit process */ 
 #define TIF_MEMDIE		19
+#define TIF_RESTORE_SIGMASK	20	/* restore signal mask in do_signal() */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
git-x86.patch
x86-handle_vm86_trap-cleanup.patch
x86_64-ia32-ptrace-vs-enosys.patch
x86_64-ptrace-vs-enosys.patch
x86_64-ia32-ptrace-vs-enosys-sysenter-syscall.patch
git-powerpc.patch
git-selinux.patch
add-rusage_thread.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
signals-re-assign-cld_continued-notification-from-the-sender-to-reciever.patch
kill_pid_info-dont-take-now-unneeded-tasklist_lock.patch
handle_stop_signal-unify-partial-full-stop-handling.patch
handle_stop_signal-use-the-cached-p-signal-value.patch
get_signal_to_deliver-use-the-cached-signal-sighand-values.patch
signals-send_sigqueue-dont-take-rcu-lock.patch
signals-send_sigqueue-dont-forget-about-handle_stop_signal.patch
signals-__group_complete_signal-cache-the-value-of-p-signal.patch
signals-send_group_sigqueue-dont-take-tasklist_lock.patch
signals-move-handle_stop_signal-into-send_signal.patch
signals-do_tkill-dont-use-tasklist_lock.patch
signals-do_tkill-dont-use-tasklist_lock-comment.patch
signals-send_sig_info-dont-take-tasklist_lock.patch
signals-microoptimize-the-usage-of-curr_target.patch
signals-move-the-definition-of-__group_complete_signal-up.patch
signals-change-send_signal-do_send_sigqueue-to-take-boolean-group-parameter.patch
signals-use-__group_complete_signal-for-the-specific-signals-too.patch
signals-fold-complete_signal-into-send_signal-do_send_sigqueue.patch
signals-unify-send_sigqueue-send_group_sigqueue-completely.patch
signals-join-send_sigqueue-with-send_group_sigqueue.patch
signals-handle_stop_signal-dont-worry-about-sigkill.patch
signals-cleanup-the-usage-of-print_fatal_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal.patch
signals-fold-sig_ignored-into-handle_stop_signal-comment.patch
signals-document-cld_continued-notification-mechanics.patch
signals-document-cld_continued-notification-mechanics-more.patch
signals-send_signal-be-paranoid-about-signalfd_notify.patch
signals-check_kill_permission-check-session-under-tasklist_lock.patch
signals-check_kill_permission-remove-tasklist_lock.patch
signals-fix-sbin-init-protection-from-unwanted-signals.patch
signals-de_thread-simplify-the-child_reaper-switching.patch
signals-allow-the-kernel-to-actually-kill-sbin-init.patch
signals-add-set_restore_sigmask.patch
signals-set_restore_sigmask-tif_sigpending.patch
signals-s390-renumber-tif_restore_sigmask.patch
signals-ia64-renumber-tif_restore_sigmask.patch
signals-use-have_set_restore_sigmask.patch
signals-x86-ts_restore_sigmask.patch
signals-powerpc-tlf_restore_sigmask.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
ptrace-allow-to-ptrace-sbin-init.patch
procfs-mem-permission-cleanup.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch
pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

