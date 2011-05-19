From: akpm@linux-foundation.org
Subject: + w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch added to -mm tree
Date: Thu, 19 May 2011 12:03:47 -0700
Message-ID: <201105191903.p4JJ3lkd020883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934360Ab1ESTEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 May 2011 15:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cabarnes@indesign-llc.com, haojian.zhuang@gmail.com, johnpol@2ka.mipt.ru, ryan@bluewatersys.com


The patch titled
     w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix
has been added to the -mm tree.  Its filename is
     w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch

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
Subject: w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix
From: Andrew Morton <akpm@linux-foundation.org>

use min_t()

Cc: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/ds2780_battery.c |    8 ++++----
 drivers/w1/slaves/w1_ds2780.c  |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/power/ds2780_battery.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix drivers/power/ds2780_battery.c
--- a/drivers/power/ds2780_battery.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix
+++ a/drivers/power/ds2780_battery.c
@@ -628,7 +628,7 @@ static ssize_t ds2780_read_param_eeprom_
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK1_END -
 		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
@@ -646,7 +646,7 @@ static ssize_t ds2780_write_param_eeprom
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 	int ret;
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK1_END -
 		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
@@ -681,7 +681,7 @@ static ssize_t ds2780_read_user_eeprom_b
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK0_END -
 		DS2780_EEPROM_BLOCK0_START + 1 - off);
 
@@ -700,7 +700,7 @@ static ssize_t ds2780_write_user_eeprom_
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 	int ret;
 
-	count = min((loff_t)count,
+	count = min_t(loff_t, count,
 		DS2780_EEPROM_BLOCK0_END -
 		DS2780_EEPROM_BLOCK0_START + 1 - off);
 
diff -puN drivers/w1/slaves/w1_ds2780.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix drivers/w1/slaves/w1_ds2780.c
--- a/drivers/w1/slaves/w1_ds2780.c~w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix
+++ a/drivers/w1/slaves/w1_ds2780.c
@@ -40,7 +40,7 @@ int w1_ds2780_io(struct device *dev, cha
 		count = 0;
 		goto out;
 	}
-	count = min((int)count, DS2780_DATA_SIZE - addr);
+	count = min_t(int, count, DS2780_DATA_SIZE - addr);
 
 	if (w1_reset_select_slave(sl) == 0) {
 		if (io) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
drivers-leds-leds-lm3530c-add-regulator-checkpatch-fixes.patch
leds-provide-helper-to-register-leds-gpio-devices.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mtd-convert-to-seq_file-interface-checkpatch-fixes.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-tty-serial-pch_uartc-needs-slabh.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
drivers-bcma-host_pcic-needs-slabh.patch
slab-use-numa_no_node.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix.patch
mm-filter-unevictable-page-out-in-deactivate_page-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
nommu-add-page-alignment-to-mmap-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
cris-convert-old-cpumask-api-into-new-one-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
compat-fixes-to-allow-working-with-tile-arch-checkpatch-fixes.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix-2.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

