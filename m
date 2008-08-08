From: akpm@linux-foundation.org
Subject: - tracehook-fix-clone_ptrace.patch removed from -mm tree
Date: Fri, 08 Aug 2008 15:08:01 -0700
Message-ID: <200808082208.m78M81aZ031205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758857AbYHHWJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 18:09:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ehabkost@redhat.com, oleg@tv-sign.ru, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     tracehook: fix CLONE_PTRACE
has been removed from the -mm tree.  Its filename was
     tracehook-fix-clone_ptrace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: fix CLONE_PTRACE
From: Roland McGrath <roland@redhat.com>

In the change in commit 09a05394fe2448a4139b014936330af23fa7ec83, I
overlooked two nits in the logic and this broke using CLONE_PTRACE when
PTRACE_O_TRACE* are not being used.

A parent that is itself traced at all but not using PTRACE_O_TRACE*, using
CLONE_PTRACE would have its new child fail to be traced.

A parent that is not itself traced at all that uses CLONE_PTRACE (which
should be a no-op in this case) would confuse the bookkeeping and lead to
a crash at exit time.

This restores the missing checks and fixes both failure modes.

Reported-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h    |    2 +-
 include/linux/tracehook.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/ptrace.h~tracehook-fix-clone_ptrace include/linux/ptrace.h
--- a/include/linux/ptrace.h~tracehook-fix-clone_ptrace
+++ a/include/linux/ptrace.h
@@ -172,7 +172,7 @@ static inline void ptrace_init_task(stru
 	child->ptrace = 0;
 	if (unlikely(ptrace)) {
 		child->ptrace = current->ptrace;
-		__ptrace_link(child, current->parent);
+		ptrace_link(child, current->parent);
 	}
 }
 
diff -puN include/linux/tracehook.h~tracehook-fix-clone_ptrace include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-fix-clone_ptrace
+++ a/include/linux/tracehook.h
@@ -280,7 +280,7 @@ static inline void tracehook_report_clon
 					  unsigned long clone_flags,
 					  pid_t pid, struct task_struct *child)
 {
-	if (unlikely(trace)) {
+	if (unlikely(trace) || unlikely(clone_flags & CLONE_PTRACE)) {
 		/*
 		 * The child starts up with an immediate SIGSTOP.
 		 */
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
wait_task_inactive-fix-the-config_smp-version.patch
posix-timers-fix-posix_timer_event-vs-dequeue_signal-race.patch
posix-timers-do_schedule_next_timer-fix-the-setting-of-si_overrun.patch
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

