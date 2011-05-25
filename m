From: akpm@linux-foundation.org
Subject: [folded] init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 24 May 2011 17:03:44 -0700
Message-ID: <201105250003.p4P03ijM024330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933126Ab1EYAEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 May 2011 20:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amworsley@gmail.com, ext-phil.2.carmody@nokia.com, mm-commits@vger.kernel.org


The patch titled
     init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch

This patch was dropped because it was folded into init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#112: FILE: init/calibrate.c:42:
+	int max = -1; /* index of measured_times with max/min values or not set */

WARNING: line over 80 characters
#147: FILE: init/calibrate.c:118:
+	 * Find the maximum & minimum - if they differ too much throw out the one with

ERROR: return is not a function, parentheses are not required
#160: FILE: init/calibrate.c:131:
+			return (estimate);

WARNING: line over 80 characters
#165: FILE: init/calibrate.c:136:
+		if ((measured_times[max] - estimate) < (estimate - measured_times[min])) {

total: 1 errors, 3 warnings, 88 lines checked

./patches/init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrew Worsley <amworsley@gmail.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN init/calibrate.c~init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes init/calibrate.c
--- a/init/calibrate.c~init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes
+++ a/init/calibrate.c
@@ -115,8 +115,8 @@ static unsigned long __cpuinit calibrate
 	}
 
 	/*
-	 * Find the maximum & minimum - if they differ too much throw out the one with
-	 * the largest difference from the mean and try again...
+	 * Find the maximum & minimum - if they differ too much throw out the
+	 * one with the largest difference from the mean and try again...
 	 */
 	while (good_timer_count > 1) {
 		unsigned long estimate;
@@ -128,12 +128,13 @@ static unsigned long __cpuinit calibrate
 
 		/* if range is within 12% let's take it */
 		if ((measured_times[max] - measured_times[min]) < maxdiff)
-			return (estimate);
+			return estimate;
 
 		/* ok - drop the worse value and try again... */
 		good_timer_sum = 0;
 		good_timer_count = 0;
-		if ((measured_times[max] - estimate) < (estimate - measured_times[min])) {
+		if ((measured_times[max] - estimate) <
+				(estimate - measured_times[min])) {
 			printk(KERN_NOTICE
 	"calibrate_delay_direct() dropping min bogoMips estimate %d = %lu\n",
 				min, measured_times[min]);
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
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
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

