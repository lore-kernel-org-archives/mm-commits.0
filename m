From: akpm@linux-foundation.org
Subject: + drivers-md-raid5c-fix-i386-build.patch added to -mm tree
Date: Thu, 22 Apr 2010 16:23:00 -0700
Message-ID: <201004222350.o3MNoI7v018678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753864Ab0DVXua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 19:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, neilb@suse.de


The patch titled
     drivers/md/raid5.c: fix i386 build
has been added to the -mm tree.  Its filename is
     drivers-md-raid5c-fix-i386-build.patch

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
Subject: drivers/md/raid5.c: fix i386 build
From: Andrew Morton <akpm@linux-foundation.org>

Prevent lots of calls to __umoddi with i386, CONFIG_LBDAF=y.

Needs checking.  Probably isn't implemented very nicely.  Probaby should move
sector_div() into blkdev.h or something.

Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |   65 ++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff -puN drivers/md/raid5.c~drivers-md-raid5c-fix-i386-build drivers/md/raid5.c
--- a/drivers/md/raid5.c~drivers-md-raid5c-fix-i386-build
+++ a/drivers/md/raid5.c
@@ -1643,6 +1643,14 @@ static void error(mddev_t *mddev, mdk_rd
 }
 
 /*
+ * Do it this way to prevent calls to __umoddi3 on 32-bit
+ */
+static int sector_mod(sector_t sector, int divisor)
+{
+	return do_div(sector, divisor);
+}
+
+/*
  * Input: a 'big' sector number,
  * Output: index of the data and parity disk, and the sector # in them.
  */
@@ -1689,22 +1697,22 @@ static sector_t raid5_compute_sector(rai
 	case 5:
 		switch (algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
-			pd_idx = data_disks - stripe % raid_disks;
+			pd_idx = data_disks - sector_mod(stripe, raid_disks);
 			if (*dd_idx >= pd_idx)
 				(*dd_idx)++;
 			break;
 		case ALGORITHM_RIGHT_ASYMMETRIC:
-			pd_idx = stripe % raid_disks;
+			pd_idx = sector_mod(stripe, raid_disks);
 			if (*dd_idx >= pd_idx)
 				(*dd_idx)++;
 			break;
 		case ALGORITHM_LEFT_SYMMETRIC:
-			pd_idx = data_disks - stripe % raid_disks;
-			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
+			pd_idx = data_disks - sector_mod(stripe, raid_disks);
+			*dd_idx = sector_mod(pd_idx + 1 + *dd_idx, raid_disks);
 			break;
 		case ALGORITHM_RIGHT_SYMMETRIC:
-			pd_idx = stripe % raid_disks;
-			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
+			pd_idx = sector_mod(stripe, raid_disks);
+			*dd_idx = sector_mod(pd_idx + 1 + *dd_idx, raid_disks);
 			break;
 		case ALGORITHM_PARITY_0:
 			pd_idx = 0;
@@ -1723,7 +1731,7 @@ static sector_t raid5_compute_sector(rai
 
 		switch (algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
-			pd_idx = raid_disks - 1 - (stripe % raid_disks);
+			pd_idx = raid_disks - 1 - sector_mod(stripe, raid_disks);
 			qd_idx = pd_idx + 1;
 			if (pd_idx == raid_disks-1) {
 				(*dd_idx)++;	/* Q D D D P */
@@ -1732,7 +1740,7 @@ static sector_t raid5_compute_sector(rai
 				(*dd_idx) += 2; /* D D P Q D */
 			break;
 		case ALGORITHM_RIGHT_ASYMMETRIC:
-			pd_idx = stripe % raid_disks;
+			pd_idx = sector_mod(stripe, raid_disks);
 			qd_idx = pd_idx + 1;
 			if (pd_idx == raid_disks-1) {
 				(*dd_idx)++;	/* Q D D D P */
@@ -1741,14 +1749,14 @@ static sector_t raid5_compute_sector(rai
 				(*dd_idx) += 2; /* D D P Q D */
 			break;
 		case ALGORITHM_LEFT_SYMMETRIC:
-			pd_idx = raid_disks - 1 - (stripe % raid_disks);
-			qd_idx = (pd_idx + 1) % raid_disks;
-			*dd_idx = (pd_idx + 2 + *dd_idx) % raid_disks;
+			pd_idx = raid_disks - 1 - sector_mod(stripe, raid_disks);
+			qd_idx = sector_mod(pd_idx + 1, raid_disks);
+			*dd_idx = sector_mod(pd_idx + 2 + *dd_idx, raid_disks);
 			break;
 		case ALGORITHM_RIGHT_SYMMETRIC:
-			pd_idx = stripe % raid_disks;
-			qd_idx = (pd_idx + 1) % raid_disks;
-			*dd_idx = (pd_idx + 2 + *dd_idx) % raid_disks;
+			pd_idx = sector_mod(stripe, raid_disks);
+			qd_idx = sector_mod(pd_idx + 1, raid_disks);
+			*dd_idx = sector_mod(pd_idx + 2 + *dd_idx, raid_disks);
 			break;
 
 		case ALGORITHM_PARITY_0:
@@ -1765,7 +1773,7 @@ static sector_t raid5_compute_sector(rai
 			/* Exactly the same as RIGHT_ASYMMETRIC, but or
 			 * of blocks for computing Q is different.
 			 */
-			pd_idx = stripe % raid_disks;
+			pd_idx = sector_mod(stripe, raid_disks);
 			qd_idx = pd_idx + 1;
 			if (pd_idx == raid_disks-1) {
 				(*dd_idx)++;	/* Q D D D P */
@@ -1780,7 +1788,8 @@ static sector_t raid5_compute_sector(rai
 			 * D D D P Q  rather than
 			 * Q D D D P
 			 */
-			pd_idx = raid_disks - 1 - ((stripe + 1) % raid_disks);
+			pd_idx = raid_disks - 1 -
+					sector_mod(stripe + 1, raid_disks);
 			qd_idx = pd_idx + 1;
 			if (pd_idx == raid_disks-1) {
 				(*dd_idx)++;	/* Q D D D P */
@@ -1792,36 +1801,42 @@ static sector_t raid5_compute_sector(rai
 
 		case ALGORITHM_ROTATING_N_CONTINUE:
 			/* Same as left_symmetric but Q is before P */
-			pd_idx = raid_disks - 1 - (stripe % raid_disks);
-			qd_idx = (pd_idx + raid_disks - 1) % raid_disks;
-			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
+			pd_idx = raid_disks - 1 -
+					sector_mod(stripe, raid_disks);
+			qd_idx = sector_mod(pd_idx + raid_disks - 1,
+					    raid_disks);
+			*dd_idx = sector_mod(pd_idx + 1 + *dd_idx, raid_disks);
 			ddf_layout = 1;
 			break;
 
 		case ALGORITHM_LEFT_ASYMMETRIC_6:
 			/* RAID5 left_asymmetric, with Q on last device */
-			pd_idx = data_disks - stripe % (raid_disks-1);
+			pd_idx = data_disks -
+					sector_mod(stripe, raid_disks - 1);
 			if (*dd_idx >= pd_idx)
 				(*dd_idx)++;
 			qd_idx = raid_disks - 1;
 			break;
 
 		case ALGORITHM_RIGHT_ASYMMETRIC_6:
-			pd_idx = stripe % (raid_disks-1);
+			pd_idx = sector_mod(stripe, raid_disks - 1);
 			if (*dd_idx >= pd_idx)
 				(*dd_idx)++;
 			qd_idx = raid_disks - 1;
 			break;
 
 		case ALGORITHM_LEFT_SYMMETRIC_6:
-			pd_idx = data_disks - stripe % (raid_disks-1);
-			*dd_idx = (pd_idx + 1 + *dd_idx) % (raid_disks-1);
+			pd_idx = data_disks -
+					sector_mod(stripe, raid_disks - 1);
+			*dd_idx = sector_mod(pd_idx + 1 + *dd_idx,
+					     raid_disks - 1);
 			qd_idx = raid_disks - 1;
 			break;
 
 		case ALGORITHM_RIGHT_SYMMETRIC_6:
-			pd_idx = stripe % (raid_disks-1);
-			*dd_idx = (pd_idx + 1 + *dd_idx) % (raid_disks-1);
+			pd_idx = sector_mod(stripe, raid_disks - 1);
+			*dd_idx = sector_mod(pd_idx + 1 + *dd_idx,
+					     raid_disks - 1);
 			qd_idx = raid_disks - 1;
 			break;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
drivers-video-efifbc-framebuffer-for-nvidia-9400m-in-macbook-pro-51-fix.patch
hugetlb-fix-infinite-loop-in-get_futex_key-when-backed-by-huge-pages-fix.patch
intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915-checkpatch-fixes.patch
drivers-md-raid5c-fix-i386-build.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
drivers-acpi-use-kasprintf-fix.patch
acpi_pad-processor_aggregator-name-too-long-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cifs-provide-user-with-a-hint-when-name-resolution-fails-fix.patch
sched-introduce-get_cpu_iowait_time_us-fix.patch
jfs-free-sbi-memory-in-error-path.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
hpet-factor-timer-allocate-from-open-fix.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries-checkpatch-fixes.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
mm-introduce-free_pages_prepare-fix.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
crc32-major-optimization-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

