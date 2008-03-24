From: akpm@linux-foundation.org
Subject: + signals-fix-sbin-init-protection-from-unwanted-signals.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:24:12 -0700
Message-ID: <200803242224.m2OMOCKf028412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbYCXWZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:25:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, roland@redhat.com


The patch titled
     signals: fix /sbin/init protection from unwanted signals
has been added to the -mm tree.  Its filename is
     signals-fix-sbin-init-protection-from-unwanted-signals.patch

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
Subject: signals: fix /sbin/init protection from unwanted signals
From: Oleg Nesterov <oleg@tv-sign.ru>

The global init has a lot of long standing problems with the unhandled fatal
signals.

	- The "is_global_init(current)" check in get_signal_to_deliver()
	  protects only the main thread. Sub-thread can dequee the fatal
	  signal and shutdown the whole thread group except the main thread.
	  If it dequeues SIGSTOP /sbin/init will be stopped, this is not
	  right too. Note that we can't use is_global_init(->group_leader),
	  this breaks exec and this can't solve other problems we have.

	- Even if afterwards ignored, the fatal signals sets SIGNAL_GROUP_EXIT
	  on delivery. This breaks exec, has other bad implications, and this
	  is just wrong.

Introduce the new SIGNAL_UNKILLABLE flag to fix these problems.  It also helps
to solve some other problems addressed by the subsequent patches.

Currently we use this flag for the global init only, but it could also be used
by kthreads and (perhaps) by the sub-namespace inits.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 ++
 init/main.c           |    2 ++
 kernel/signal.c       |    9 ++++++---
 3 files changed, 10 insertions(+), 3 deletions(-)

diff -puN include/linux/sched.h~signals-fix-sbin-init-protection-from-unwanted-signals include/linux/sched.h
--- a/include/linux/sched.h~signals-fix-sbin-init-protection-from-unwanted-signals
+++ a/include/linux/sched.h
@@ -561,6 +561,8 @@ struct signal_struct {
 #define SIGNAL_CLD_CONTINUED	0x00000020
 #define SIGNAL_CLD_MASK		(SIGNAL_CLD_STOPPED|SIGNAL_CLD_CONTINUED)
 
+#define SIGNAL_UNKILLABLE	0x00000040 /* for init: ignore fatal signals */
+
 /* If true, all threads except ->group_exit_task have pending SIGKILL */
 static inline int signal_group_exit(const struct signal_struct *sig)
 {
diff -puN init/main.c~signals-fix-sbin-init-protection-from-unwanted-signals init/main.c
--- a/init/main.c~signals-fix-sbin-init-protection-from-unwanted-signals
+++ a/init/main.c
@@ -781,6 +781,8 @@ static int noinline init_post(void)
 	(void) sys_dup(0);
 	(void) sys_dup(0);
 
+	current->signal->flags |= SIGNAL_UNKILLABLE;
+
 	if (ramdisk_execute_command) {
 		run_init_process(ramdisk_execute_command);
 		printk(KERN_WARNING "Failed to execute %s\n",
diff -puN kernel/signal.c~signals-fix-sbin-init-protection-from-unwanted-signals kernel/signal.c
--- a/kernel/signal.c~signals-fix-sbin-init-protection-from-unwanted-signals
+++ a/kernel/signal.c
@@ -728,7 +728,8 @@ static void complete_signal(int sig, str
 	 * Found a killable thread.  If the signal will be fatal,
 	 * then start taking the whole group down immediately.
 	 */
-	if (sig_fatal(p, sig) && !(signal->flags & SIGNAL_GROUP_EXIT) &&
+	if (sig_fatal(p, sig) &&
+	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
 	    !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL || !(t->ptrace & PT_PTRACED))) {
 		/*
@@ -1615,7 +1616,8 @@ static int do_signal_stop(int signr)
 	} else {
 		struct task_struct *t;
 
-		if (!likely(sig->flags & SIGNAL_STOP_DEQUEUED) ||
+		if (unlikely((sig->flags & (SIGNAL_STOP_DEQUEUED | SIGNAL_UNKILLABLE))
+					 != SIGNAL_STOP_DEQUEUED) ||
 		    unlikely(signal_group_exit(sig)))
 			return 0;
 		/*
@@ -1748,7 +1750,8 @@ relock:
 		/*
 		 * Global init gets no signals it doesn't want.
 		 */
-		if (is_global_init(current))
+		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
+		    !signal_group_exit(signal))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
bsd_acct-plain-current-real_parent-access-is-not-always-safe.patch
bsd_acct-using-task_struct-tgid-is-not-right-in-pid-namespaces.patch
x86-handle_vm86_trap-cleanup.patch
git-hrt.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
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
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

