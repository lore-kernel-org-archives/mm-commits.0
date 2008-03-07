From: akpm@linux-foundation.org
Subject: + signals-move-handle_stop_signal-into-send_signal.patch added to -mm tree
Date: Fri, 07 Mar 2008 01:03:18 -0800
Message-ID: <200803070903.m2793IV6014445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755044AbYCGJEo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 04:04:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: move handle_stop_signal() into send_signal()
has been added to the -mm tree.  Its filename is
     signals-move-handle_stop_signal-into-send_signal.patch

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
Subject: signals: move handle_stop_signal() into send_signal()
From: Oleg Nesterov <oleg@tv-sign.ru>

Move handle_stop_signal() into send_signal().  This factors out a couple of
callsites and allows us to do further unifications.

Also, with this change specific_send_sig_info() does handle_stop_signal(). 
Not that this is really important, we never send STOP/CONT via send_sig() and
friends, but still this looks more consistent.

The only (afaics) special case is get_signal_to_deliver().  If the traced task
dequeues SIGCONT, it can re-send it to itself after ptrace_stop() if the
signal was blocked by debugger.  In that case handle_stop_signal() is
unnecessary, but hopefully not a problem.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN kernel/signal.c~signals-move-handle_stop_signal-into-send_signal kernel/signal.c
--- a/kernel/signal.c~signals-move-handle_stop_signal-into-send_signal
+++ a/kernel/signal.c
@@ -660,8 +660,10 @@ static inline int legacy_queue(struct si
 static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			struct sigpending *signals)
 {
-	struct sigqueue * q = NULL;
+	struct sigqueue *q;
 
+	assert_spin_locked(&t->sighand->siglock);
+	handle_stop_signal(sig, t);
 	/*
 	 * Short-circuit ignored signals and support queuing
 	 * exactly one non-rt signal, so that we can get more
@@ -766,9 +768,6 @@ specific_send_sig_info(int sig, struct s
 {
 	int ret;
 
-	BUG_ON(!irqs_disabled());
-	assert_spin_locked(&t->sighand->siglock);
-
 	ret = send_signal(sig, info, t, &t->pending);
 	if (ret <= 0)
 		return ret;
@@ -923,9 +922,6 @@ __group_send_sig_info(int sig, struct si
 {
 	int ret;
 
-	assert_spin_locked(&p->sighand->siglock);
-	handle_stop_signal(sig, p);
-
 	/*
 	 * Put this signal on the shared-pending queue, or fail with EAGAIN.
 	 * We always use the shared queue for process-wide signals,
@@ -2228,7 +2224,6 @@ static int do_tkill(int tgid, int pid, i
 		 */
 		if (!error && sig && p->sighand) {
 			spin_lock_irq(&p->sighand->siglock);
-			handle_stop_signal(sig, p);
 			error = specific_send_sig_info(sig, &info, p);
 			spin_unlock_irq(&p->sighand->siglock);
 		}
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
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
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
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
put_pid-make-sure-we-dont-free-the-live-pid.patch

