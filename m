From: akpm@linux-foundation.org
Subject: + wait_task_stopped-continued-remove-unneeded-p-signal-=-null-check.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:49:23 -0700
Message-ID: <200708311849.l7VInNA8021537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965977AbXHaStt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:49:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     wait_task_stopped/continued: remove unneeded p->signal != NULL check
has been added to the -mm tree.  Its filename is
     wait_task_stopped-continued-remove-unneeded-p-signal-=-null-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wait_task_stopped/continued: remove unneeded p->signal != NULL check
From: Oleg Nesterov <oleg@tv-sign.ru>

The child was found on ->children list under tasklist_lock, it must have a
valid ->signal. __exit_signal() both removes the task from parent->children
and clears ->signal "atomically" under write_lock(tasklist).

Remove unneeded checks.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/exit.c~wait_task_stopped-continued-remove-unneeded-p-signal-=-null-check kernel/exit.c
--- a/kernel/exit.c~wait_task_stopped-continued-remove-unneeded-p-signal-=-null-check
+++ a/kernel/exit.c
@@ -1325,7 +1325,7 @@ static int wait_task_stopped(struct task
 	if (!p->exit_code)
 		return 0;
 	if (delayed_group_leader && !(p->ptrace & PT_PTRACED) &&
-	    p->signal && p->signal->group_stop_count > 0)
+	    p->signal->group_stop_count > 0)
 		/*
 		 * A group stop is in progress and this is the group leader.
 		 * We won't report until all threads have stopped.
@@ -1439,9 +1439,6 @@ static int wait_task_continued(struct ta
 	pid_t pid;
 	uid_t uid;
 
-	if (unlikely(!p->signal))
-		return 0;
-
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
 		return 0;
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
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
wait_task_stopped-continued-remove-unneeded-p-signal-=-null-check.patch
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
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
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
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
