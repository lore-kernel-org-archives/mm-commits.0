From: akpm@linux-foundation.org
Subject: + revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch added to -mm tree
Date: Tue, 08 May 2007 20:08:33 -0700
Message-ID: <200705090308.l4938XqU011263@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092AbXEIDJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:09:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dmitry.adamushko@gmail.com, kernel@kolivas.org, mingo@elte.hu


The patch titled
     revert 'sched: redundant reschedule when set_user_nice() boosts a prio of a task from the "expired" array'
has been added to the -mm tree.  Its filename is
     revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert 'sched: redundant reschedule when set_user_nice() boosts a prio of a task from the "expired" array'
From: Andrew Morton <akpm@linux-foundation.org>

Con says:

This is no good, sorry. The one I saw originally was with the staircase
deadline cpu scheduler in situ and was different.

  #define TASK_PREEMPTS_CURR(p, rq) \
     ((p)->prio < (rq)->curr->prio)
     (((p)->prio < (rq)->curr->prio) && ((p)->array == (rq)->active))

This will fail to wake up a runqueue for a task that has been migrated to the
expired array of a runqueue which is otherwise idle which can happen with smp
balancing,

Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff -puN kernel/sched.c~revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array kernel/sched.c
--- a/kernel/sched.c~revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array
+++ a/kernel/sched.c
@@ -169,7 +169,7 @@ unsigned long long __attribute__((weak))
 		(MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
 
 #define TASK_PREEMPTS_CURR(p, rq) \
-	(((p)->prio < (rq)->curr->prio) && ((p)->array == (rq)->active))
+	((p)->prio < (rq)->curr->prio)
 
 #define SCALE_PRIO(x, prio) \
 	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_TIMESLICE)
@@ -4076,13 +4076,13 @@ void rt_mutex_setprio(struct task_struct
 	struct prio_array *array;
 	unsigned long flags;
 	struct rq *rq;
-	int delta;
+	int oldprio;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
 	rq = task_rq_lock(p, &flags);
 
-	delta = prio - p->prio;
+	oldprio = p->prio;
 	array = p->array;
 	if (array)
 		dequeue_task(p, array);
@@ -4098,11 +4098,13 @@ void rt_mutex_setprio(struct task_struct
 		enqueue_task(p, array);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
-		 * our priority decreased, or if our priority became higher
-		 * than the current's.
+		 * our priority decreased, or if we are not currently running on
+		 * this runqueue and our priority is higher than the current's
 		 */
-		if (TASK_PREEMPTS_CURR(p, rq) ||
-				(delta > 0 && task_running(rq, p)))
+		if (task_running(rq, p)) {
+			if (p->prio > oldprio)
+				resched_task(rq->curr);
+		} else if (TASK_PREEMPTS_CURR(p, rq))
 			resched_task(rq->curr);
 	}
 	task_rq_unlock(rq, &flags);
@@ -4150,12 +4152,10 @@ void set_user_nice(struct task_struct *p
 		enqueue_task(p, array);
 		inc_raw_weighted_load(rq, p);
 		/*
-		 * Reschedule if we are currently running on this runqueue and
-		 * our priority decreased, or if our priority became higher
-		 * than the current's.
+		 * If the task increased its priority or is running and
+		 * lowered its priority, then reschedule its CPU:
 		 */
-		if (TASK_PREEMPTS_CURR(p, rq) ||
-				(delta > 0 && task_running(rq, p)))
+		if (delta < 0 || (delta > 0 && task_running(rq, p)))
 			resched_task(rq->curr);
 	}
 out_unlock:
@@ -4382,11 +4382,13 @@ recheck:
 		__activate_task(p, rq);
 		/*
 		 * Reschedule if we are currently running on this runqueue and
-		 * our priority decreased, or our priority became higher
-		 * than the current's.
+		 * our priority decreased, or if we are not currently running on
+		 * this runqueue and our priority is higher than the current's
 		 */
-		if (TASK_PREEMPTS_CURR(p, rq) ||
-				(task_running(rq, p) && p->prio > oldprio))
+		if (task_running(rq, p)) {
+			if (p->prio > oldprio)
+				resched_task(rq->curr);
+		} else if (TASK_PREEMPTS_CURR(p, rq))
 			resched_task(rq->curr);
 	}
 	__task_rq_unlock(rq);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
git-acpi.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip-tidy.patch
git-avr32.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
cinergyt2-fix-file-release-handler.patch
git-hid-fixup.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix.patch
sn-validate-smp_affinity-mask-on-intr-redirect-fix-2.patch
git-ieee1394.patch
sbp2-include-fixes.patch
ieee1394-iso-needs-schedh.patch
git-kvm.patch
pata_acpi-restore-driver-vs-libata-clean-up-sff-init-mess-fix.patch
git-mtd.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-battery-fix.patch
git-parisc.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
auerswald-fix-file-release-handler.patch
git-watchdog.patch
git-wireless.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-add-support-for-picopower-irq-router-fix.patch
xfs-clean-up-shrinker-games.patch
lazy-freeing-of-memory-through-madv_free.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
swsusp-clean-up-print.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
upper-32-bits.patch
lib-hexdump-fix.patch
pasemi-hardware-rng-driver-tidy.patch
nbd-check-the-return-value-of-sysfs_create_file-fix.patch
mutex_lock_interruptible-add-__must_check.patch
mutex_lock_interruptible-add-__must_check-must-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
rename-thread_info-to-stack-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
