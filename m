From: akpm@linux-foundation.org
Subject: + ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch added to -mm tree
Date: Mon, 13 May 2013 16:06:56 -0700
Message-ID: <20130513230657.0F7C931C1D4@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:44870 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3EMXG6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 19:06:58 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so50259qeb.5
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 16:06:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, benh@kernel.crashing.org, fweisbec@gmail.com, jan.kratochvil@redhat.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mikey@neuling.org, mingo@kernel.org, paulus@samba.org, prasad@linux.vnet.ibm.com, will.deacon@arm.com


The patch titled
     Subject: ptrace: revert "Prepare to fix racy accesses on task breakpoints"
has been added to the -mm tree.  Its filename is
     ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: revert "Prepare to fix racy accesses on task breakpoints"

This reverts commit bf26c018490c2fce ("Prepare to fix racy accesses on
task breakpoints").

The patch was fine but we can no longer race with SIGKILL after 9899d11f
("ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL"),
the __TASK_TRACED tracee can't be woken up and ->ptrace_bps[] can't go
away.

Now that ptrace_get_breakpoints/ptrace_put_breakpoints have no callers, we
can kill them and remove task->ptrace_bp_refcnt.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |   10 ----------
 include/linux/sched.h  |    3 ---
 kernel/exit.c          |    2 +-
 kernel/ptrace.c        |   16 ----------------
 4 files changed, 1 insertion(+), 30 deletions(-)

diff -puN include/linux/ptrace.h~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints
+++ a/include/linux/ptrace.h
@@ -142,9 +142,6 @@ static inline void ptrace_init_task(stru
 {
 	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-	atomic_set(&child->ptrace_bp_refcnt, 1);
-#endif
 	child->jobctl = 0;
 	child->ptrace = 0;
 	child->parent = child->real_parent;
@@ -351,11 +348,4 @@ extern int task_current_syscall(struct t
 				unsigned long args[6], unsigned int maxargs,
 				unsigned long *sp, unsigned long *pc);
 
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-extern int ptrace_get_breakpoints(struct task_struct *tsk);
-extern void ptrace_put_breakpoints(struct task_struct *tsk);
-#else
-static inline void ptrace_put_breakpoints(struct task_struct *tsk) { }
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
-
 #endif
diff -puN include/linux/sched.h~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints include/linux/sched.h
--- a/include/linux/sched.h~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints
+++ a/include/linux/sched.h
@@ -1404,9 +1404,6 @@ struct task_struct {
 	} memcg_batch;
 	unsigned int memcg_kmem_skip_account;
 #endif
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-	atomic_t ptrace_bp_refcnt;
-#endif
 #ifdef CONFIG_UPROBES
 	struct uprobe_task *utask;
 #endif
diff -puN kernel/exit.c~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints kernel/exit.c
--- a/kernel/exit.c~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints
+++ a/kernel/exit.c
@@ -819,7 +819,7 @@ void do_exit(long code)
 	/*
 	 * FIXME: do that only when needed, using sched_exit tracepoint
 	 */
-	ptrace_put_breakpoints(tsk);
+	flush_ptrace_hw_breakpoint(tsk);
 
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
diff -puN kernel/ptrace.c~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints
+++ a/kernel/ptrace.c
@@ -1179,19 +1179,3 @@ asmlinkage long compat_sys_ptrace(compat
 	return ret;
 }
 #endif	/* CONFIG_COMPAT */
-
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-int ptrace_get_breakpoints(struct task_struct *tsk)
-{
-	if (atomic_inc_not_zero(&tsk->ptrace_bp_refcnt))
-		return 0;
-
-	return -1;
-}
-
-void ptrace_put_breakpoints(struct task_struct *tsk)
-{
-	if (atomic_dec_and_test(&tsk->ptrace_bp_refcnt))
-		flush_ptrace_hw_breakpoint(tsk);
-}
-#endif /* CONFIG_HAVE_HW_BREAKPOINT */
_

Patches currently in -mm which might be from oleg@redhat.com are

posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-sh-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch
ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
ptrace-x86-introduce-ptrace_register_breakpoint.patch
ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch
ptrace-x86-cleanup-ptrace_set_debugreg.patch
ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch
x86-kill-tif_debug.patch

