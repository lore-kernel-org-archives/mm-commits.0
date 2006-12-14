From: akpm@osdl.org
Subject: - lockdep-improve-verbose-messages.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:09:13 -0800
Message-ID: <200612140609.kBE69DST001971@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52132 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbWLNGJ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:09:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: improve verbose messages
has been removed from the -mm tree.  Its filename was
     lockdep-improve-verbose-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: improve verbose messages
From: Ingo Molnar <mingo@elte.hu>

Make verbose lockdep messages (off by default) more informative by printing
out the hash chain key.  (this patch was what helped me catch the earlier
lockdep hash-collision bug)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/lockdep.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/lockdep.c~lockdep-improve-verbose-messages kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-improve-verbose-messages
+++ a/kernel/lockdep.c
@@ -1264,7 +1264,7 @@ out_unlock_set:
  * add it and return 0 - in this case the new dependency chain is
  * validated. If the key is already hashed, return 1.
  */
-static inline int lookup_chain_cache(u64 chain_key)
+static inline int lookup_chain_cache(u64 chain_key, struct lock_class *class)
 {
 	struct list_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
@@ -1286,9 +1286,13 @@ cache_hit:
 			__raw_spin_lock(&hash_lock);
 			return 1;
 #endif
+			if (very_verbose(class))
+				printk("\nhash chain already cached, key: %016Lx tail class: [%p] %s\n", chain_key, class->key, class->name);
 			return 0;
 		}
 	}
+	if (very_verbose(class))
+		printk("\nnew hash chain, key: %016Lx tail class: [%p] %s\n", chain_key, class->key, class->name);
 	/*
 	 * Allocate a new chain entry from the static array, and add
 	 * it to the hash:
@@ -2139,7 +2143,7 @@ out_calc_hash:
 	 * (If lookup_chain_cache() returns with 1 it acquires
 	 * hash_lock for us)
 	 */
-	if (!trylock && (check == 2) && lookup_chain_cache(chain_key)) {
+	if (!trylock && (check == 2) && lookup_chain_cache(chain_key, class)) {
 		/*
 		 * Check whether last held lock:
 		 *
_

Patches currently in -mm which might be from mingo@elte.hu are

conditionally-check-expected_preempt_count-in-__resched_legal.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
introduce-time_data-a-new-structure-to-hold-jiffies-xtime.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
debugging-feature-proc-timer_list.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
detect-atomic-counter-underflows.patch
debug-shared-irqs.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch

