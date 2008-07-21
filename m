From: akpm@linux-foundation.org
Subject: + coredump-format_corename-fix-the-core_uses_pid-logic.patch added to -mm tree
Date: Sun, 20 Jul 2008 18:37:23 -0700
Message-ID: <200807210137.m6L1bN0H011138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754238AbYGUBiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jul 2008 21:38:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, alan@lxorguk.ukuu.org.uk, andi@firstfloor.org, roland@redhat.com


The patch titled
     coredump: format_corename: fix the "core_uses_pid" logic
has been added to the -mm tree.  Its filename is
     coredump-format_corename-fix-the-core_uses_pid-logic.patch

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
Subject: coredump: format_corename: fix the "core_uses_pid" logic
From: Oleg Nesterov <oleg@tv-sign.ru>

I don't understand why the multi-thread coredump implies the core_uses_pid
behaviour, but we shouldn't use mm->mm_users for that.  This counter can
be incremented by get_task_mm().  Use the valued returned by
coredump_wait() instead.

Also, remove the "const char *pattern" argument, format_corename() can use
core_pattern directly.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN fs/exec.c~coredump-format_corename-fix-the-core_uses_pid-logic fs/exec.c
--- a/fs/exec.c~coredump-format_corename-fix-the-core_uses_pid-logic
+++ a/fs/exec.c
@@ -1379,17 +1379,14 @@ EXPORT_SYMBOL(set_binfmt);
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
  */
-static int format_corename(char *corename, const char *pattern, long signr)
+static int format_corename(char *corename, int nr_threads, long signr)
 {
-	const char *pat_ptr = pattern;
+	const char *pat_ptr = core_pattern;
+	int ispipe = (*pat_ptr == '|');
 	char *out_ptr = corename;
 	char *const out_end = corename + CORENAME_MAX_SIZE;
 	int rc;
 	int pid_in_pattern = 0;
-	int ispipe = 0;
-
-	if (*pattern == '|')
-		ispipe = 1;
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
@@ -1490,7 +1487,7 @@ static int format_corename(char *corenam
 	 * and core_uses_pid is set, then .%pid will be appended to
 	 * the filename. Do not do this for piped commands. */
 	if (!ispipe && !pid_in_pattern
-            && (core_uses_pid || atomic_read(&current->mm->mm_users) != 1)) {
+            && (core_uses_pid || nr_threads)) {
 		rc = snprintf(out_ptr, out_end - out_ptr,
 			      ".%d", task_tgid_vnr(current));
 		if (rc > out_end - out_ptr)
@@ -1753,7 +1750,7 @@ int do_coredump(long signr, int exit_cod
 	 * uses lock_kernel()
 	 */
  	lock_kernel();
-	ispipe = format_corename(corename, core_pattern, signr);
+	ispipe = format_corename(corename, retval, signr);
 	unlock_kernel();
 	/*
 	 * Don't bother to check the RLIMIT_CORE value if core_pattern points
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
linux-next.patch
migrate_timers-add-comment-use-spinlock_irq.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on.patch
pm-introduce-new-interfaces-schedule_work_on-and-queue_work_on-cleanup.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
coredump-make-mm-core_state-visible-to-core_dump.patch
coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
coredump-elf_core_dump-use-core_state-dumper-list.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-kill-mm-core_done.patch
coredump-format_corename-fix-the-core_uses_pid-logic.patch
workqueues-insert_work-use-list_head-instead-of-int-tail.patch
workqueues-implement-flush_work.patch
workqueues-schedule_on_each_cpu-use-flush_work.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
workqueues-lockdep-annotations-for-flush_work.patch
workqueues-queue_work-can-use-queue_work_on.patch
workqueues-schedule_on_each_cpu-can-use-schedule_work_on.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch
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

