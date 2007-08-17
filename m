From: akpm@linux-foundation.org
Subject: + __group_complete_signal-eliminate-unneeded-wakeup-of-group_exit_task.patch added to -mm tree
Date: Fri, 17 Aug 2007 14:45:02 -0700
Message-ID: <200708172145.l7HLj3vC030926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756355AbXHQVpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 17:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, roland@redhat.com


The patch titled
     __group_complete_signal: eliminate unneeded wakeup of ->group_exit_task
has been added to the -mm tree.  Its filename is
     __group_complete_signal-eliminate-unneeded-wakeup-of-group_exit_task.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: __group_complete_signal: eliminate unneeded wakeup of ->group_exit_task
From: Oleg Nesterov <oleg@tv-sign.ru>

Cleanup.  __group_complete_signal() wakes up ->group_exit_task twice.  The
second wakeup's state includes TASK_UNINTERRUPTIBLE, which is not very
appropriate.

Change the code to pass the "correct" argument to signal_wake_up() and kill
now unneeded wake_up_process().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/signal.c~__group_complete_signal-eliminate-unneeded-wakeup-of-group_exit_task kernel/signal.c
--- a/kernel/signal.c~__group_complete_signal-eliminate-unneeded-wakeup-of-group_exit_task
+++ a/kernel/signal.c
@@ -910,8 +910,7 @@ __group_complete_signal(int sig, struct 
 			do {
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
-				t = next_thread(t);
-			} while (t != p);
+			} while_each_thread(p, t);
 			return;
 		}
 
@@ -929,13 +928,11 @@ __group_complete_signal(int sig, struct 
 		rm_from_queue(SIG_KERNEL_STOP_MASK, &p->signal->shared_pending);
 		p->signal->group_stop_count = 0;
 		p->signal->group_exit_task = t;
-		t = p;
+		p = t;
 		do {
 			p->signal->group_stop_count++;
-			signal_wake_up(t, 0);
-			t = next_thread(t);
-		} while (t != p);
-		wake_up_process(p->signal->group_exit_task);
+			signal_wake_up(t, t == p);
+		} while_each_thread(p, t);
 		return;
 	}
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-fix-creation-race.patch
signalfd-fix-interaction-with-posix-timers.patch
signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch
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
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
