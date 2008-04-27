From: akpm@linux-foundation.org
Subject: + posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch added to -mm tree
Date: Sun, 27 Apr 2008 13:47:32 -0700
Message-ID: <200804272047.m3RKlWtN024125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbYD0Utl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 16:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, amdragon+kernelbugzilla@mit.edu, johnstul@us.ibm.com, mingo@elte.hu, mtk.manpages@googlemail.com, roland@redhat.com, tglx@linutronix.de


The patch titled
     posix timers: discard the pending signal when the timer is destroyed
has been added to the -mm tree.  Its filename is
     posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch

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
Subject: posix timers: discard the pending signal when the timer is destroyed
From: Oleg Nesterov <oleg@tv-sign.ru>

Currently sigqueue_free() removes sigqueue from list, but doesn't cancel the
pending signal.  This is indeed strange, the task should either receive the
"full" signal along with siginfo_t, or it shouldn't see the signal at all.

Change sigqueue_free(q) to do sigdelset() if q is queued.  There is a little
complication.  Looking at "struct sigqueue*" we can't figure out where it is
pending, in ->pending or ->shared_pending.  So this patch adds a new flag,
SIGQUEUE_SHARED_PENDING, which is set/cleared by send_sigqueue().

Alternatively, we can add a new parameter to sigqueue_free(), and the caller
can check SIGEV_THREAD_ID.  But I think this is not as robust as a flag which
is "automatically" correct.

This patch should also fix the problem pointed out by Austin Clements, see

	http://bugzilla.kernel.org/show_bug.cgi?id=10460

Currently, when the task execs it could be killed by the fatal signal sent by
the posix timer, because exec flushes the signal handlers.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Austin Clements <amdragon+kernelbugzilla@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    1 +
 kernel/signal.c        |   32 ++++++++++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff -puN include/linux/signal.h~posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed include/linux/signal.h
--- a/include/linux/signal.h~posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed
+++ a/include/linux/signal.h
@@ -20,6 +20,7 @@ struct sigqueue {
 
 /* flags values. */
 #define SIGQUEUE_PREALLOC	1
+#define SIGQUEUE_SHARED_PENDING	2	/* meaningful only if queued */
 
 struct sigpending {
 	struct list_head list;
diff -puN kernel/signal.c~posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed kernel/signal.c
--- a/kernel/signal.c~posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed
+++ a/kernel/signal.c
@@ -1233,6 +1233,28 @@ struct sigqueue *sigqueue_alloc(void)
 	return(q);
 }
 
+static void sigqueue_cancel(struct sigqueue *q)
+{
+	struct sigpending *pending;
+	int sig;
+
+	list_del_init(&q->list);
+
+	pending = (q->flags & SIGQUEUE_SHARED_PENDING)
+		? &current->signal->shared_pending
+		: &current->pending;
+
+	sig = q->info.si_signo;
+	if (sig >= SIGRTMIN) {
+		list_for_each_entry(q, &pending->list, list)
+			if (q->info.si_signo == sig)
+				return;
+	}
+
+	sigdelset(&pending->signal, sig);
+	recalc_sigpending();
+}
+
 void sigqueue_free(struct sigqueue *q)
 {
 	unsigned long flags;
@@ -1246,7 +1268,7 @@ void sigqueue_free(struct sigqueue *q)
 	 */
 	spin_lock_irqsave(lock, flags);
 	if (!list_empty(&q->list))
-		list_del_init(&q->list);
+		sigqueue_cancel(q);
 	spin_unlock_irqrestore(lock, flags);
 
 	q->flags &= ~SIGQUEUE_PREALLOC;
@@ -1282,7 +1304,13 @@ int send_sigqueue(struct sigqueue *q, st
 	}
 
 	signalfd_notify(t, sig);
-	pending = group ? &t->signal->shared_pending : &t->pending;
+	if (group) {
+		q->flags |=  SIGQUEUE_SHARED_PENDING;
+		pending = &t->signal->shared_pending;
+	} else {
+		q->flags &= ~SIGQUEUE_SHARED_PENDING;
+		pending = &t->pending;
+	}
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
cgroups-add-an-owner-to-the-mm_struct.patch
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
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
ptrace-introduce-task_detached-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
ptrace-introduce-ptrace_reparented-helper.patch
ptrace-__ptrace_unlink-use-the-ptrace_reparented-helper.patch
ptrace-ptrace_attach-use-send_sig_info-instead-force_sig_specific.patch
ptrace-allow-to-ptrace-sbin-init.patch
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
procfs-mem-permission-cleanup.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
pids-de_thread-dont-clear-session-pgrp-pids-for-the-old-leader.patch
pids-introduce-change_pid-helper.patch
pids-sys_setpgid-use-change_pid-helper.patch
pids-__set_special_pids-use-change_pid-helper.patch
pids-sys_getsid-fix-unsafe-pid-usage-fix-possible-0-instead-of-esrch.patch
pids-sys_getpgid-fix-unsafe-pid-usage-s-tasklist-rcu.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

