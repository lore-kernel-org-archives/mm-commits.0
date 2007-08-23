From: akpm@linux-foundation.org
Subject: + sigqueue_free-fix-the-race-with-collect_signal.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:57:13 -0700
Message-ID: <200708232357.l7NNvD15001039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43292 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759835AbXHWX7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, adobriyan@sw.ru, jeremy.katz@windriver.com, mingo@elte.hu, roland@redhat.com, stable@kernel.org, sukadev@us.ibm.com, tglx@linutronix.de, yue.tao@windriver.com


The patch titled
     sigqueue_free: fix the race with collect_signal()
has been added to the -mm tree.  Its filename is
     sigqueue_free-fix-the-race-with-collect_signal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sigqueue_free: fix the race with collect_signal()
From: Oleg Nesterov <oleg@tv-sign.ru>

Spotted by taoyue <yue.tao@windriver.com> and Jeremy Katz <jeremy.katz@windriver.com>.

collect_signal:				sigqueue_free:

	list_del_init(&first->list);
						if (!list_empty(&q->list)) {
							// not taken
						}
						q->flags &= ~SIGQUEUE_PREALLOC;

	__sigqueue_free(first);			__sigqueue_free(q);

Now, __sigqueue_free() is called twice on the same "struct sigqueue" with the
obviously bad implications.

In particular, this double free breaks the array_cache->avail logic, so the
same sigqueue could be "allocated" twice, and the bug can manifest itself via
the "impossible" BUG_ON(!SIGQUEUE_PREALLOC) in sigqueue_free/send_sigqueue.

Hopefully this can explain these mysterious bug-reports, see

	http://marc.info/?t=118766926500003
	http://marc.info/?t=118466273000005

Alexey Dobriyan reports this patch makes the difference for the testcase, but
nobody has an access to the application which opened the problems originally.

Also, this patch removes tasklist lock/unlock, ->siglock is enough.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: taoyue <yue.tao@windriver.com>
Cc: Jeremy Katz <jeremy.katz@windriver.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff -puN kernel/signal.c~sigqueue_free-fix-the-race-with-collect_signal kernel/signal.c
--- a/kernel/signal.c~sigqueue_free-fix-the-race-with-collect_signal
+++ a/kernel/signal.c
@@ -1300,20 +1300,19 @@ struct sigqueue *sigqueue_alloc(void)
 void sigqueue_free(struct sigqueue *q)
 {
 	unsigned long flags;
+	spinlock_t *lock = &current->sighand->siglock;
+
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 	/*
 	 * If the signal is still pending remove it from the
-	 * pending queue.
+	 * pending queue. We must hold ->siglock while testing
+	 * q->list to serialize with collect_signal().
 	 */
-	if (unlikely(!list_empty(&q->list))) {
-		spinlock_t *lock = &current->sighand->siglock;
-		read_lock(&tasklist_lock);
-		spin_lock_irqsave(lock, flags);
-		if (!list_empty(&q->list))
-			list_del_init(&q->list);
-		spin_unlock_irqrestore(lock, flags);
-		read_unlock(&tasklist_lock);
-	}
+	spin_lock_irqsave(lock, flags);
+	if (!list_empty(&q->list))
+		list_del_init(&q->list);
+	spin_unlock_irqrestore(lock, flags);
+
 	q->flags &= ~SIGQUEUE_PREALLOC;
 	__sigqueue_free(q);
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-fix-creation-race.patch
signalfd-fix-interaction-with-posix-timers.patch
signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch
exec-kill-unsafe-bug_onsig-count-checks.patch
setpgidchild-fails-if-the-child-was-forked-by-sub-thread.patch
sigqueue_free-fix-the-race-with-collect_signal.patch
git-dvb.patch
rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
wait_task_zombie-remove-unneeded-child-signal-check.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch
zap_other_threads-dont-optimize-thread_group_empty-case.patch
wait_task_zombie-dont-fight-with-non-existing-race-with-a-dying-ptracee.patch
__group_complete_signal-eliminate-unneeded-wakeup-of-group_exit_task.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
exec-simplify-sighand-switching.patch
exec-simplify-the-new-sighand-allocation.patch
exec-consolidate-2-fast-paths.patch
exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec.patch
do_sigaction-dont-worry-about-signal_pending.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
make-access-to-tasks-nsproxy-lighter.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
proc-export-a-processes-resource-limits-via-proc-pid.patch
fix-tsk-exit_state-usage-resend.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
