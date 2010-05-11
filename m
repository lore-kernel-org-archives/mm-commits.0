From: akpm@linux-foundation.org
Subject: + pids-increase-pid_max-based-on-num_possible_cpus-fix.patch added to -mm tree
Date: Tue, 11 May 2010 13:57:20 -0700
Message-ID: <201005112125.o4BLP504023841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751195Ab0EKV0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 17:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de, hedi@sgi.com, holt@sgi.com, john@stoffel.org, mingo@elte.hu, pavel@ucw.cz, riel@redhat.com, steiner@sgi.com, torvalds@linux-foundation.org, travis@sgi.com


The patch titled
     pids-increase-pid_max-based-on-num_possible_cpus-fix
has been added to the -mm tree.  Its filename is
     pids-increase-pid_max-based-on-num_possible_cpus-fix.patch

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
Subject: pids-increase-pid_max-based-on-num_possible_cpus-fix
From: Andrew Morton <akpm@linux-foundation.org>

kernel/pid.c: In function 'pidmap_init':
kernel/pid.c:517: warning: comparison of distinct pointer types lacks a cast
kernel/pid.c:517: warning: comparison of distinct pointer types lacks a cast
kernel/pid.c:517: warning: comparison of distinct pointer types lacks a cast
kernel/pid.c:519: warning: comparison of distinct pointer types lacks a cast

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>
Cc: Hedi Berriche <hedi@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>
Cc: John Stoffel <john@stoffel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/pid.c~pids-increase-pid_max-based-on-num_possible_cpus-fix kernel/pid.c
--- a/kernel/pid.c~pids-increase-pid_max-based-on-num_possible_cpus-fix
+++ a/kernel/pid.c
@@ -514,9 +514,9 @@ void __init pidhash_init(void)
 void __init pidmap_init(void)
 {
 	/* bump default and minimum pid_max based on number of cpus */
-	pid_max = min(pid_max_max, max(pid_max,
+	pid_max = min(pid_max_max, max_t(int, pid_max,
 				PIDS_PER_CPU_DEFAULT * num_possible_cpus()));
-	pid_max_min = max(pid_max_min,
+	pid_max_min = max_t(int, pid_max_min,
 				PIDS_PER_CPU_MIN * num_possible_cpus());
 	pr_info("pid_max: default: %u minimum: %u\n", pid_max, pid_max_min);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-gpu-drm-i915-i915_irqc-i915_error_object_create-use-correct-kmap-atomic-slot.patch
linux-next.patch
linux-next-fix-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
jfs-free-sbi-memory-in-error-path.patch
dib3000mc-reduce-large-stack-usage-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible-fix-2.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
mm-introduce-free_pages_prepare-fix.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-fix.patch
cpu-mem-hotplug-enable-cpus-online-before-local-memory-online-checkpatch-fixes.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix-fix.patch
dynamic_debug-fix-documentation-errors-checkpatch-fixes.patch
lib-introduce-common-method-to-convert-hex-digits-fix.patch
lib-introduce-common-method-to-convert-hex-digits-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
crc32-major-optimization-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
s3c-fb-add-s5pv210-support-and-some-features-checkpatch-fixes.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
ipc-semc-optimize-update_queue-for-bulk-wakeup-calls-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix-2.patch
ipmi-update-driver-to-use-dev_printk-and-its-constructs-checkpatch-fixes.patch
pids-increase-pid_max-based-on-num_possible_cpus-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch

