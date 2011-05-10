From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 10 May 2011 12:51:42 -0700
Message-ID: <201105101944.p4AJiXgk017458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792Ab1EJTpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 May 2011 15:45:23 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p4AJiXWe005141
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 10 May 2011 12:44:33 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/eeepc-laptop.c |   13 -------------
 drivers/platform/x86/sony-laptop.c  |   11 -----------
 2 files changed, 24 deletions(-)

diff -puN drivers/platform/x86/eeepc-laptop.c~linux-next-git-rejects drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~linux-next-git-rejects
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -609,11 +609,7 @@ static void eeepc_rfkill_hotplug(struct 
 		bus = port->subordinate;
 
 		if (!bus) {
-<<<<<<< HEAD
-			pr_warning("Unable to find PCI bus?\n");
-=======
 			pr_warn("Unable to find PCI bus 1?\n");
->>>>>>> FETCH_HEAD
 			goto out_unlock;
 		}
 
@@ -695,16 +691,7 @@ static int eeepc_register_rfkill_notifie
 						     eeepc_rfkill_notify,
 						     eeepc);
 		if (ACPI_FAILURE(status))
-<<<<<<< HEAD
-			pr_warning("Failed to register notify on %s\n", node);
-		/*
-		 * Refresh pci hotplug in case the rfkill state was
-		 * changed during setup.
-		 */
-		eeepc_rfkill_hotplug(eeepc, handle);
-=======
 			pr_warn("Failed to register notify on %s\n", node);
->>>>>>> FETCH_HEAD
 	} else
 		return -ENODEV;
 
diff -puN drivers/platform/x86/sony-laptop.c~linux-next-git-rejects drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~linux-next-git-rejects
+++ a/drivers/platform/x86/sony-laptop.c
@@ -978,13 +978,8 @@ static int sony_nc_update_status_ng(stru
 	struct sony_backlight_props *sdev =
 		(struct sony_backlight_props *)bl_get_data(bd);
 
-<<<<<<< HEAD
-	value = bd->props.brightness + sdev->offset;
-	if (sony_call_snc_handle(sdev->handle, 0x0100 | (value << 16), &result))
-=======
 	value = bd->props.brightness;
 	if (sony_call_snc_handle(*handle, 0x0100 | (value << 16), &result))
->>>>>>> FETCH_HEAD
 		return -EIO;
 
 	return value;
@@ -1665,15 +1660,9 @@ static void sony_nc_backlight_setup(void
 						      &sony_bl_props,
 						      ops, &props);
 
-<<<<<<< HEAD
-	if (IS_ERR(sony_bl_props.dev)) {
-		pr_warn(DRV_PFX "unable to register backlight device\n");
-		sony_bl_props.dev = NULL;
-=======
 	if (IS_ERR(sony_backlight_device)) {
 		pr_warn("unable to register backlight device\n");
 		sony_backlight_device = NULL;
->>>>>>> FETCH_HEAD
 	} else
 		sony_bl_props.dev->props.brightness =
 			ops->get_brightness(sony_bl_props.dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-use-alloc_bootmem_node_nopanic-on-really-needed-path-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
mm-add-alloc_pages_exact_nid-checkpatch-fixes.patch
mm-add-alloc_pages_exact_nid-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-provide-helper-to-register-leds-gpio-devices-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
drivers-usb-misc-usbtestc-fix-warning.patch
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
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
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
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

