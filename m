From: akpm@linux-foundation.org
Subject: [merged] intel_idle-open-broadcast-clock-event-resend.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:47 -0800
Message-ID: <201101132013.p0DKDSSm030459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933755Ab1AMUUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, zheng.z.yan@intel.com, mm-commits@vger.kernel.org


The patch titled
     intel_idle: open broadcast clock event - resend
has been removed from the -mm tree.  Its filename was
     intel_idle-open-broadcast-clock-event-resend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel_idle: open broadcast clock event - resend
From: Shaohua Li <shaohua.li@intel.com>

The Intel_idle driver uses
CLOCK_EVT_NOTIFY_BROADCAST_ENTER/CLOCK_EVT_NOTIFY_BROADCAST_EXIT for
broadcast clock events.  The _ENTER/_EXIT doesn't really open broadcast
clock events, please see processor_idle.c for an example.  In some
situation, this will cause boot hang, because some CPUs enters idle but
local APIC timer stalls.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reported-and-tested-by: Yan Zheng <zheng.z.yan@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/idle/intel_idle.c |   47 +++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff -puN drivers/idle/intel_idle.c~intel_idle-open-broadcast-clock-event-resend drivers/idle/intel_idle.c
--- a/drivers/idle/intel_idle.c~intel_idle-open-broadcast-clock-event-resend
+++ a/drivers/idle/intel_idle.c
@@ -59,6 +59,8 @@
 #include <linux/hrtimer.h>	/* ktime_get_real() */
 #include <trace/events/power.h>
 #include <linux/sched.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
 #include <asm/mwait.h>
 
 #define INTEL_IDLE_VERSION "0.4"
@@ -73,6 +75,7 @@ static int max_cstate = MWAIT_MAX_NUM_CS
 
 static unsigned int mwait_substates;
 
+#define LAPIC_TIMER_ALWAYS_RELIABLE 0xFFFFFFFF
 /* Reliable LAPIC Timer States, bit 1 for C1 etc.  */
 static unsigned int lapic_timer_reliable_states = (1 << 1);	 /* Default to only C1 */
 
@@ -243,6 +246,39 @@ static int intel_idle(struct cpuidle_dev
 	return usec_delta;
 }
 
+static void __setup_broadcast_timer(void *arg)
+{
+	unsigned long reason = (unsigned long)arg;
+	int cpu = smp_processor_id();
+
+	reason = reason ?
+		CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;
+
+	clockevents_notify(reason, &cpu);
+}
+
+static int __cpuinit setup_broadcast_cpuhp_notify(struct notifier_block *n,
+		unsigned long action, void *hcpu)
+{
+	int hotcpu = (unsigned long)hcpu;
+
+	switch (action & 0xf) {
+	case CPU_ONLINE:
+		smp_call_function_single(hotcpu, __setup_broadcast_timer,
+			(void *)true, 1);
+		break;
+	case CPU_DOWN_PREPARE:
+		smp_call_function_single(hotcpu, __setup_broadcast_timer,
+			(void *)false, 1);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata setup_broadcast_notifier = {
+	.notifier_call = setup_broadcast_cpuhp_notify,
+};
+
 /*
  * intel_idle_probe()
  */
@@ -305,7 +341,11 @@ static int intel_idle_probe(void)
 	}
 
 	if (boot_cpu_has(X86_FEATURE_ARAT))	/* Always Reliable APIC Timer */
-		lapic_timer_reliable_states = 0xFFFFFFFF;
+		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
+	else {
+		smp_call_function(__setup_broadcast_timer, (void *)true, 1);
+		register_cpu_notifier(&setup_broadcast_notifier);
+	}
 
 	pr_debug(PREFIX "v" INTEL_IDLE_VERSION
 		" model 0x%X\n", boot_cpu_data.x86_model);
@@ -428,6 +468,11 @@ static void __exit intel_idle_exit(void)
 	intel_idle_cpuidle_devices_uninit();
 	cpuidle_unregister_driver(&intel_idle_driver);
 
+	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE) {
+		smp_call_function(__setup_broadcast_timer, (void *)false, 1);
+		unregister_cpu_notifier(&setup_broadcast_notifier);
+	}
+
 	return;
 }
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
mm-simplify-code-of-swapc.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch

