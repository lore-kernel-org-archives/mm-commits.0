From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init-fix.patch removed from -mm tree
Date: Wed, 26 Sep 2012 13:56:38 -0700
Message-ID: <20120926205638.D10A3100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:50391 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab2IZU4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 16:56:40 -0400
Received: by yenr11 with SMTP id r11so127661yen.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 13:56:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anilkumar@ti.com, arnd@arndb.de, broonie@opensource.wolfsonmicro.com, eric.piel@tremplin-utc.net, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init-fix
has been removed from the -mm tree.  Its filename was
     drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init-fix.patch

This patch was dropped because it was folded into drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init-fix

fix CONFIG_OF=n build

drivers/misc/lis3lv02d/lis3lv02d_i2c.c: In function 'lis3lv02d_i2c_probe':
drivers/misc/lis3lv02d/lis3lv02d_i2c.c:120: error: implicit declaration of function 'of_match_device'
drivers/misc/lis3lv02d/lis3lv02d_i2c.c:121: error: 'struct lis3lv02d' has no member named 'of_node'

Cc: AnilKumar Ch <anilkumar@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/misc/lis3lv02d/lis3lv02d_i2c.c~drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init-fix drivers/misc/lis3lv02d/lis3lv02d_i2c.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c~drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init-fix
+++ a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -33,6 +33,7 @@
 #include <linux/delay.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/of_device.h>
 
 #include "lis3lv02d.h"
 
@@ -105,11 +106,13 @@ static int lis3_i2c_init(struct lis3lv02
 static union axis_conversion lis3lv02d_axis_map =
 	{ .as_array = { LIS3_DEV_X, LIS3_DEV_Y, LIS3_DEV_Z } };
 
+#ifdef CONFIG_OF
 static struct of_device_id lis3lv02d_i2c_dt_ids[] = {
 	{ .compatible = "st,lis3lv02d" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, lis3lv02d_i2c_dt_ids);
+#endif
 
 static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
@@ -117,6 +120,7 @@ static int __devinit lis3lv02d_i2c_probe
 	int ret = 0;
 	struct lis3lv02d_platform_data *pdata = client->dev.platform_data;
 
+#ifdef CONFIG_OF
 	if (of_match_device(lis3lv02d_i2c_dt_ids, &client->dev)) {
 		lis3_dev.of_node = client->dev.of_node;
 		ret = lis3lv02d_init_dt(&lis3_dev);
@@ -124,6 +128,7 @@ static int __devinit lis3lv02d_i2c_probe
 			return ret;
 		pdata = lis3_dev.pdata;
 	}
+#endif
 
 	if (pdata) {
 		if ((pdata->driver_features & LIS3_USE_BLOCK_READ) &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
audith-replace-defines-with-c-stubs.patch
audith-replace-defines-with-c-stubs-fix.patch
prctl-use-access_ok-instead-of-task_size-in-prctl_set_mm-fix-fix.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init.patch
drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

