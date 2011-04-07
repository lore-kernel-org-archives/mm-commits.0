From: akpm@linux-foundation.org
Subject: + init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch added to -mm tree
Date: Thu, 07 Apr 2011 15:17:55 -0700
Message-ID: <201104072217.p37MHtnY003469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755798Ab1DGWSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 18:18:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, amworsley@gmail.com, ext-phil.2.carmody@nokia.com


The patch titled
     init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix
has been added to the -mm tree.  Its filename is
     init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

