From: akpm@linux-foundation.org
Subject: - posix-timers-fix-creation-race.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:26 -0700
Message-ID: <200708242056.l7OKuQYr014061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44185 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764248AbXHXVJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:09:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-timers: fix creation race
has been removed from the -mm tree.  Its filename was
     posix-timers-fix-creation-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: posix-timers: fix creation race
From: Oleg Nesterov <oleg@tv-sign.ru>

sys_timer_create() sets ->it_process and unlocks ->siglock, then checks
tmr->it_sigev_notify to define if get_task_struct() is needed.

We already passed ->it_id to the caller, another thread can delete this timer
and free its memory in between.

As a minimal fix, move this code under ->siglock, sys_timer_delete() takes it
too before calling release_posix_timer().  A proper serialization would be to
take ->it_lock, we add a partly initialized timer on posix_timers_id, not
good.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/posix-timers.c~posix-timers-fix-creation-race kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-fix-creation-race
+++ a/kernel/posix-timers.c
@@ -547,9 +547,9 @@ sys_timer_create(const clockid_t which_c
 				new_timer->it_process = process;
 				list_add(&new_timer->list,
 					 &process->signal->posix_timers);
-				spin_unlock_irqrestore(&process->sighand->siglock, flags);
 				if (new_timer->it_sigev_notify == (SIGEV_SIGNAL|SIGEV_THREAD_ID))
 					get_task_struct(process);
+				spin_unlock_irqrestore(&process->sighand->siglock, flags);
 			} else {
 				spin_unlock_irqrestore(&process->sighand->siglock, flags);
 				process = NULL;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
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
