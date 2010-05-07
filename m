From: akpm@linux-foundation.org
Subject: + scsi-remove-private-bit-macros.patch added to -mm tree
Date: Fri, 07 May 2010 14:05:10 -0700
Message-ID: <201005072105.o47L5A20011723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410Ab0EGVFO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 May 2010 17:05:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, huangj@brocade.com, robert.w.love@intel.com


The patch titled
     scsi: remove private BIT macros
has been added to the -mm tree.  Its filename is
     scsi-remove-private-bit-macros.patch

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
Subject: scsi: remove private BIT macros
From: Andrew Morton <akpm@linux-foundation.org>

A couple of scsi drivers define a BIT() macro, duplicating the one in
bitops.h.  

Cc: Jing Huang <huangj@brocade.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ./drivers/scsi/bfa/include/protocol/fcp.h |    4 +---
 ./drivers/scsi/fnic/fnic.h                |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN ./drivers/scsi/fnic/fnic.h~scsi-remove-private-bit-macros ./drivers/scsi/fnic/fnic.h
--- a/./drivers/scsi/fnic/fnic.h~scsi-remove-private-bit-macros
+++ a/./drivers/scsi/fnic/fnic.h
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
 #include <linux/workqueue.h>
+#include <linux/bitops.h>
 #include <scsi/libfc.h>
 #include <scsi/libfcoe.h>
 #include "fnic_io.h"
@@ -49,7 +50,6 @@
 /*
  * Tag bits used for special requests.
  */
-#define BIT(nr)			(1UL << (nr))
 #define FNIC_TAG_ABORT		BIT(30)		/* tag bit indicating abort */
 #define FNIC_TAG_DEV_RST	BIT(29)		/* indicates device reset */
 #define FNIC_TAG_MASK		(BIT(24) - 1)	/* mask for lookup */
diff -puN ./drivers/scsi/bfa/include/protocol/fcp.h~scsi-remove-private-bit-macros ./drivers/scsi/bfa/include/protocol/fcp.h
--- a/./drivers/scsi/bfa/include/protocol/fcp.h~scsi-remove-private-bit-macros
+++ a/./drivers/scsi/bfa/include/protocol/fcp.h
@@ -18,6 +18,7 @@
 #ifndef __FCPPROTO_H__
 #define __FCPPROTO_H__
 
+#include <linux/bitops.h>
 #include <protocol/scsi.h>
 
 #pragma pack(1)
@@ -102,9 +103,6 @@ enum {
 /*
  * Task management flags field - only one bit shall be set
  */
-#ifndef BIT
-#define BIT(_x)	(1 << (_x))
-#endif
 enum fcp_tm_cmnd{
 	FCP_TM_ABORT_TASK_SET	= BIT(1),
 	FCP_TM_CLEAR_TASK_SET	= BIT(2),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-fix-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
sched-introduce-get_cpu_iowait_time_us.patch
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
ipmi-update-driver-to-use-dev_printk-and-its-constructs-checkpatch-fixes.patch
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

