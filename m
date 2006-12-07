From: akpm@osdl.org
Subject: - suspend-dont-change-cpus_allowed-for-task-initiating-the-suspend.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:35 -0800
Message-ID: <200612072259.kB7MxZtC029534@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51048 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163681AbWLGW7p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, nigel@suspend2.net, pavel@ucw.cz, rjw@sisk.pl, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     suspend: don't change cpus_allowed for task initiating the suspend
has been removed from the -mm tree.  Its filename was
     suspend-dont-change-cpus_allowed-for-task-initiating-the-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: suspend: don't change cpus_allowed for task initiating the suspend
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Don't modify the cpus_allowed of the task initiating the suspend. 
_cpu_down() already makes sure that the task doing the suspend doesn't run
on dying cpu.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@suspend2.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/cpu.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN kernel/cpu.c~suspend-dont-change-cpus_allowed-for-task-initiating-the-suspend kernel/cpu.c
--- a/kernel/cpu.c~suspend-dont-change-cpus_allowed-for-task-initiating-the-suspend
+++ a/kernel/cpu.c
@@ -270,11 +270,7 @@ int disable_nonboot_cpus(void)
 			goto out;
 		}
 	}
-	error = set_cpus_allowed(current, cpumask_of_cpu(first_cpu));
-	if (error) {
-		printk(KERN_ERR "Could not run on CPU%d\n", first_cpu);
-		goto out;
-	}
+
 	/* We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

origin.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
sched-domain-move-sched-group-allocations-to-percpu-area.patch
sched-domain-increase-the-smt-busy-rebalance-interval.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
sched-decrease-number-of-load-balances.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch

