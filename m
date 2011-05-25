From: akpm@linux-foundation.org
Subject: [folded] init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch removed from -mm tree
Date: Tue, 24 May 2011 17:03:47 -0700
Message-ID: <201105250003.p4P03lS2024333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933575Ab1EYAEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amworsley@gmail.com, ext-phil.2.carmody@nokia.com, mm-commits@vger.kernel.org


The patch titled
     init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix
has been removed from the -mm tree.  Its filename was
     init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch

This patch was dropped because it was folded into init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix straggly printk mess

Cc: Andrew Worsley <amworsley@gmail.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN init/calibrate.c~init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix init/calibrate.c
--- a/init/calibrate.c~init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix
+++ a/init/calibrate.c
@@ -93,12 +93,13 @@ static unsigned long __cpuinit calibrate
 		 * If the upper limit and lower limit of the timer_rate is
 		 * >= 12.5% apart, redo calibration.
 		 */
-		printk(KERN_DEBUG
-"calibrate_delay_direct() timer_rate_max=%lu timer_rate_min=%lu pre_start=%lu pre_end=%lu\n",
+		printk(KERN_DEBUG "calibrate_delay_direct() timer_rate_max=%lu "
+			    "timer_rate_min=%lu pre_start=%lu pre_end=%lu\n",
 			  timer_rate_max, timer_rate_min, pre_start, pre_end);
 		if (start >= post_end)
-			printk(KERN_NOTICE
-				"calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap around start=%lu >=post_end=%lu\n",
+			printk(KERN_NOTICE "calibrate_delay_direct() ignoring "
+					"timer_rate as we had a TSC wrap around"
+					" start=%lu >=post_end=%lu\n",
 				start, post_end);
 		if (start < post_end && pre_start != 0 && pre_end != 0 &&
 		    (timer_rate_max - timer_rate_min) < (timer_rate_max >> 3)) {
@@ -135,14 +136,14 @@ static unsigned long __cpuinit calibrate
 		good_timer_count = 0;
 		if ((measured_times[max] - estimate) <
 				(estimate - measured_times[min])) {
-			printk(KERN_NOTICE
-	"calibrate_delay_direct() dropping min bogoMips estimate %d = %lu\n",
+			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
+					"min bogoMips estimate %d = %lu\n",
 				min, measured_times[min]);
 			measured_times[min] = 0;
 			min = max;
 		} else {
-			printk(KERN_NOTICE
-	"calibrate_delay_direct() dropping max bogoMips estimate %d = %lu\n",
+			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
+					"max bogoMips estimate %d = %lu\n",
 				max, measured_times[max]);
 			measured_times[max] = 0;
 			max = min;
@@ -162,7 +163,8 @@ static unsigned long __cpuinit calibrate
 	}
 
 	printk(KERN_NOTICE "calibrate_delay_direct() failed to get a good "
-	       "estimate for loops_per_jiffy.\nProbably due to long platform interrupts. Consider using \"lpj=\" boot option.\n");
+	       "estimate for loops_per_jiffy.\nProbably due to long platform "
+		"interrupts. Consider using \"lpj=\" boot option.\n");
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value.patch
mm-nommu-sort-mm-mmap-list-properly.patch
mm-per-node-vmstat-show-proper-vmstats.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mmu_gather-rework.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
mm-filter-unevictable-page-out-in-deactivate_page.patch
nommu-add-page-alignment-to-mmap.patch
alpha-hook-up-gpiolib-support.patch
cris-convert-old-cpumask-api-into-new-one.patch
bitmap-irq-add-smp_affinity_list-interface-to-proc-irq.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-gpio-vx855_gpioc-needs-slabh.patch
drivers-gpio-ml_ioh_gpioc-needs-slabh.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch

