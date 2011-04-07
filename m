From: akpm@linux-foundation.org
Subject: + init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch added to -mm tree
Date: Thu, 07 Apr 2011 15:17:54 -0700
Message-ID: <201104072217.p37MHsnX003466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949Ab1DGWSA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 18:18:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, amworsley@gmail.com, ext-phil.2.carmody@nokia.com


The patch titled
     init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch

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

