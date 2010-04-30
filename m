From: akpm@linux-foundation.org
Subject: + lib-introduce-common-method-to-convert-hex-digits-fix.patch added to -mm tree
Date: Fri, 30 Apr 2010 12:07:29 -0700
Message-ID: <201004301907.o3UJ7Txx006195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934271Ab0D3TIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 15:08:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ext-andriy.shevchenko@nokia.com


The patch titled
     lib-introduce-common-method-to-convert-hex-digits-fix
has been added to the -mm tree.  Its filename is
     lib-introduce-common-method-to-convert-hex-digits-fix.patch

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
Subject: lib-introduce-common-method-to-convert-hex-digits-fix
From: Andrew Morton <akpm@linux-foundation.org>

- use tolower(), saving 3 bytes!

- test the more common case first - it's quicker.

Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/hexdump.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/kernel.h~lib-introduce-common-method-to-convert-hex-digits-fix include/linux/kernel.h
diff -puN lib/hexdump.c~lib-introduce-common-method-to-convert-hex-digits-fix lib/hexdump.c
--- a/lib/hexdump.c~lib-introduce-common-method-to-convert-hex-digits-fix
+++ a/lib/hexdump.c
@@ -24,12 +24,11 @@ EXPORT_SYMBOL(hex_asc);
  */
 int hex_to_bin(char ch)
 {
-	if ((ch >= 'a') && (ch <= 'f'))
-		return ch - 'a' + 10;
+	ch = tolower(ch);
 	if ((ch >= '0') && (ch <= '9'))
 		return ch - '0';
-	if ((ch >= 'A') && (ch <= 'F'))
-		return ch - 'A' + 10;
+	if ((ch >= 'a') && (ch <= 'f'))
+		return ch - 'a' + 10;
 	return -1;
 }
 EXPORT_SYMBOL(hex_to_bin);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-fix-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
x86-fix-handling-of-the-reservetop-boot-option.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
sched-introduce-get_cpu_iowait_time_us.patch
jfs-free-sbi-memory-in-error-path.patch
dib3000mc-reduce-large-stack-usage-fix.patch
dib7000p-reduce-large-stack-usage-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed.patch
drivers-scsi-scsi_sysfsc-fix-sdev_rw_attr-macro-for-scsi-device-sysfs-entries.patch
libertastf-add-configurable-debug-messages-fix.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-debugfs.patch
mmcompaction-direct-compact-when-a-high-order-allocation-fails.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
mm-introduce-free_pages_prepare-fix.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernel-wide-replace-ushort_max-short_max-and-short_min-with-ushrt_max-shrt_max-and-shrt_min-fix.patch
dynamic_debug-fix-documentation-errors-checkpatch-fixes.patch
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
lib-introduce-common-method-to-convert-hex-digits-fix.patch

