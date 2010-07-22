From: akpm@linux-foundation.org
Subject: + drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch added to -mm tree
Date: Thu, 22 Jul 2010 14:24:21 -0700
Message-ID: <201007222124.o6MLOLqf013140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934Ab0GVVZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Jul 2010 17:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, gong.chen@linux.intel.com, guenter.roeck@ericsson.com, huaxu.wan@intel.com, khali@linux-fr.org, r.marek@assembler.cz


The patch titled
     drivers/hwmon/coretemp.c: remove unneeded #ifdef CONFIG_HOTPLUG_CPU
has been added to the -mm tree.  Its filename is
     drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch

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
Subject: drivers/hwmon/coretemp.c: remove unneeded #ifdef CONFIG_HOTPLUG_CPU
From: Andrew Morton <akpm@linux-foundation.org>

register_hotcpu_notifier() is designed to make these ifdefs unnecessary.

Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Rudolf Marek <r.marek@assembler.cz>
Cc: Huaxu Wan <huaxu.wan@intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/hwmon/coretemp.c~drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu
+++ a/drivers/hwmon/coretemp.c
@@ -480,7 +480,6 @@ exit:
 	return err;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
 static void coretemp_device_remove(unsigned int cpu)
 {
 	struct pdev_entry *p, *n;
@@ -518,7 +517,6 @@ static int __cpuinit coretemp_cpu_callba
 static struct notifier_block coretemp_cpu_notifier __refdata = {
 	.notifier_call = coretemp_cpu_callback,
 };
-#endif				/* !CONFIG_HOTPLUG_CPU */
 
 static int __init coretemp_init(void)
 {
@@ -552,9 +550,7 @@ static int __init coretemp_init(void)
 		goto exit_driver_unreg;
 	}
 
-#ifdef CONFIG_HOTPLUG_CPU
 	register_hotcpu_notifier(&coretemp_cpu_notifier);
-#endif
 	return 0;
 
 exit_driver_unreg:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
revert-driver-core-remove-config_sysfs_deprecated.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
mm-vmap-area-cache.patch
acpi-fix-bogus-preemption-logic.patch
compal-laptop-added-jhl90-battery-hwmon-interface.patch
acer-wmi-fix-memory-leaks-in-wmab_execute-error-path.patch
x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
dib3000mc-reduce-large-stack-usage-fix.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
fs-squashfs-xattrc-fix-warning.patch
arch-um-drivers-remove-duplicate-structure-field-initialization.patch
3x59x-fix-pci-resource-management.patch
altera_uart-simplify-altera_uart_console_putc-checkpatch-fixes.patch
serial-mcf-dont-take-spinlocks-in-already-protected-functions.patch
serial-mmio32-support-for-8250_earlyc.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
scsi-remove-private-bit-macros.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch
mm.patch
mm-track-the-root-oldest-anon_vma-fix.patch
oom-improve-commentary-in-dump_tasks.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
shmem-reduce-one-time-of-locking-in-pagefault-fix.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
writeback-avoid-unnecessary-calculation-of-bdi-dirty-thresholds-fix.patch
vmscan-shrink_slab-require-number-of-lru_pages-not-page-order-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-fix.patch
drivers-misc-support-for-the-pressure-sensor-bmp085-from-bosch-sensortec-update-checkpatch-fixes.patch
edd-fix-possible-memory-leak-in-edd_init-error-path-fix.patch
mmc-recognize-csd-structure-fix.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume.patch
mmc-fix-all-hangs-related-to-mmc-sd-card-insert-removal-during-suspend-resume-fix.patch
mmc-add-jz4740-mmc-driver.patch
hwmon-add-support-for-jedec-jc-424-compliant-temperature-sensors.patch
drivers-hwmon-coretempc-remove-unneeded-ifdef-config_hotplug_cpu.patch
fix-vc-vc_origin-on-take_over_console-checkpatch-fixes.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-add-support-for-ds3232-rtc-fix.patch
gpio-sx150x-add-semtech-i2c-sx150x-gpio-expander-driver-disable.patch
drivers-video-via-via-gpioc-fix-warning.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
kfifo-add-example-files-to-the-kernel-sample-directory-checkpatch-fixes.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

