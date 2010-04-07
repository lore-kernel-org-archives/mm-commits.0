From: akpm@linux-foundation.org
Subject: + mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-reject-fix.patch added to -mm tree
Date: Wed, 07 Apr 2010 13:20:55 -0700
Message-ID: <201004072020.o37KKtb9005318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab0DGUVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 16:21:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-reject-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-reject-fix.patch

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
Subject: mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-reject-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix reject, resture defer_compaction() call which appeared to get lost.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-reject-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-reject-fix
+++ a/mm/page_alloc.c
@@ -1793,6 +1793,9 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		 */
 		count_vm_event(COMPACTFAIL);
 
+		/* On failure, avoid compaction for a short time. */
+		defer_compaction(preferred_zone, jiffies + HZ/50);
+
 		cond_resched();
 	}
 
@@ -1822,39 +1825,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 
 	cond_resched();
 
-	/* Try memory compaction for high-order allocations before reclaim */
-	if (order && !compaction_deferred(preferred_zone)) {
-		*did_some_progress = try_to_compact_pages(zonelist,
-						order, gfp_mask, nodemask);
-		if (*did_some_progress != COMPACT_SKIPPED) {
-
-			/* Page migration frees to the PCP lists but we want merging */
-			drain_pages(get_cpu());
-			put_cpu();
-
-			page = get_page_from_freelist(gfp_mask, nodemask,
-					order, zonelist, high_zoneidx,
-					alloc_flags, preferred_zone,
-					migratetype);
-			if (page) {
-				__count_vm_event(COMPACTSUCCESS);
-				return page;
-			}
-
-			/*
-			 * It's bad if compaction run occurs and fails.
-			 * The most likely reason is that pages exist,
-			 * but not enough to satisfy watermarks.
-			 */
-			count_vm_event(COMPACTFAIL);
-
-			/* On failure, avoid compaction for a short time. */
-			defer_compaction(preferred_zone, jiffies + HZ/50);
-
-			cond_resched();
-		}
-	}
-
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
 	p->flags |= PF_MEMALLOC;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915-checkpatch-fixes.patch
drivers-acpi-use-kasprintf-fix.patch
acpi_pad-processor_aggregator-name-too-long-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cifs-provide-user-with-a-hint-when-name-resolution-fails-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
ipc-mqueuec-let-message-queue-timeout-use-hrtimers-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-reject-fix.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
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

