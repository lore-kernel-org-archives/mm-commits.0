From: akpm@linux-foundation.org
Subject: + intel_menlow-fix-memory-leaks-in-error-path-fix.patch added to -mm tree
Date: Tue, 25 May 2010 13:38:37 -0700
Message-ID: <201005252038.o4PKcbZq013695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934155Ab0EYUiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 May 2010 16:38:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, axel.lin@gmail.com, len.brown@intel.com, mjg@redhat.com, rui.zhang@intel.com, sujith.thomas@intel.com


The patch titled
     intel_menlow-fix-memory-leaks-in-error-path-fix
has been added to the -mm tree.  Its filename is
     intel_menlow-fix-memory-leaks-in-error-path-fix.patch

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
Subject: intel_menlow-fix-memory-leaks-in-error-path-fix
From: Andrew Morton <akpm@linux-foundation.org>

avoid the forward-declaration

Cc: Axel Lin <axel.lin@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_menlow.c |   32 ++++++++++++--------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff -puN drivers/platform/x86/intel_menlow.c~intel_menlow-fix-memory-leaks-in-error-path-fix drivers/platform/x86/intel_menlow.c
--- a/drivers/platform/x86/intel_menlow.c~intel_menlow-fix-memory-leaks-in-error-path-fix
+++ a/drivers/platform/x86/intel_menlow.c
@@ -53,8 +53,6 @@ MODULE_LICENSE("GPL");
 #define MEMORY_ARG_CUR_BANDWIDTH 1
 #define MEMORY_ARG_MAX_BANDWIDTH 0
 
-static void intel_menlow_unregister_sensor(void);
-
 /*
  * GTHS returning 'n' would mean that [0,n-1] states are supported
  * In that case max_cstate would be n-1
@@ -420,6 +418,21 @@ static int intel_menlow_add_one_attribut
 	return 0;
 }
 
+static void intel_menlow_unregister_sensor(void)
+{
+	struct intel_menlow_attribute *pos, *next;
+
+	mutex_lock(&intel_menlow_attr_lock);
+	list_for_each_entry_safe(pos, next, &intel_menlow_attr_list, node) {
+		list_del(&pos->node);
+		device_remove_file(pos->device, &pos->attr);
+		kfree(pos);
+	}
+	mutex_unlock(&intel_menlow_attr_lock);
+
+	return;
+}
+
 static acpi_status intel_menlow_register_sensor(acpi_handle handle, u32 lvl,
 						void *context, void **rv)
 {
@@ -484,21 +497,6 @@ static acpi_status intel_menlow_register
 	return status;
 }
 
-static void intel_menlow_unregister_sensor(void)
-{
-	struct intel_menlow_attribute *pos, *next;
-
-	mutex_lock(&intel_menlow_attr_lock);
-	list_for_each_entry_safe(pos, next, &intel_menlow_attr_list, node) {
-		list_del(&pos->node);
-		device_remove_file(pos->device, &pos->attr);
-		kfree(pos);
-	}
-	mutex_unlock(&intel_menlow_attr_lock);
-
-	return;
-}
-
 static int __init intel_menlow_module_init(void)
 {
 	int result = -ENODEV;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
intel_menlow-fix-memory-leaks-in-error-path-fix.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
lib-kobject_ueventc-fix-conig_net=n-warning.patch
dib3000mc-reduce-large-stack-usage-fix.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
hpet-factor-timer-allocate-from-open.patch
led-driver-for-the-soekris-net5501-board.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver.patch
fix-stop_machine-reimplement-using-cpu_stop.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
s3fb-add-support-for-s3-trio3d-1x-2x-checkpatch-fixes.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
memcg-move-charge-of-file-pages-fix-4.patch
memcg-clean-up-memory-thresholds-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
ipc-semc-optimize-update_queue-for-bulk-wakeup-calls-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix-2.patch
ipmi-update-driver-to-use-dev_printk-and-its-constructs-checkpatch-fixes.patch
pids-increase-pid_max-based-on-num_possible_cpus-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-checkpatch-fixes.patch
aio-fix-the-compat-vectored-operations-fix.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
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

