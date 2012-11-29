From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 29 Nov 2012 14:36:45 -0800
Message-ID: <20121129223645.C076D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:46093 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2K2Wgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Nov 2012 17:36:50 -0500
Received: by mail-oa0-f74.google.com with SMTP id k14so3301164oag.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Nov 2012 14:36:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/cavium-octeon/setup.c |    8 --------
 drivers/mfd/twl-core.c          |    5 -----
 2 files changed, 13 deletions(-)

diff -puN arch/mips/cavium-octeon/setup.c~linux-next-git-rejects arch/mips/cavium-octeon/setup.c
--- a/arch/mips/cavium-octeon/setup.c~linux-next-git-rejects
+++ a/arch/mips/cavium-octeon/setup.c
@@ -914,13 +914,6 @@ void __init plat_mem_setup(void)
 	cvmx_bootmem_lock();
 	while ((boot_mem_map.nr_map < BOOT_MEM_MAP_MAX)
 		&& (total < MAX_MEMORY)) {
-		memory = cvmx_bootmem_phy_alloc(mem_alloc_size,
-						__pa_symbol(&__init_end), -1,
-						0x100000,
-						CVMX_BOOTMEM_FLAG_NO_LOCKING);
-<<<<<<< HEAD
-=======
-
 #elif defined(CONFIG_HIGHMEM)
 		memory = cvmx_bootmem_phy_alloc(mem_alloc_size, 0, 1ull << 31,
 						0x100000,
@@ -930,7 +923,6 @@ void __init plat_mem_setup(void)
 						0x100000,
 						CVMX_BOOTMEM_FLAG_NO_LOCKING);
 #endif
->>>>>>> 8571489... MIPS: Octeon: Add kexec and kdump support
 		if (memory >= 0) {
 			u64 size = mem_alloc_size;
 #ifdef CONFIG_KEXEC
diff -puN drivers/mfd/twl-core.c~linux-next-git-rejects drivers/mfd/twl-core.c
--- a/drivers/mfd/twl-core.c~linux-next-git-rejects
+++ a/drivers/mfd/twl-core.c
@@ -665,10 +665,6 @@ add_children(struct twl4030_platform_dat
 			return PTR_ERR(child);
 	}
 
-<<<<<<< HEAD
-	if (IS_ENABLED(CONFIG_PWM_TWL6030) && twl_class_is_6030()) {
-		child = add_child(SUB_CHIP_ID1, "twl6030-pwm", NULL, 0,
-=======
 	if (IS_ENABLED(CONFIG_PWM_TWL)) {
 		child = add_child(SUB_CHIP_ID1, "twl-pwm", NULL, 0,
 				  false, 0, 0);
@@ -678,7 +674,6 @@ add_children(struct twl4030_platform_dat
 
 	if (IS_ENABLED(CONFIG_PWM_TWL_LED)) {
 		child = add_child(SUB_CHIP_ID1, "twl-pwmled", NULL, 0,
->>>>>>> linux-next/akpm-base
 				  false, 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-revert-mm-remove-__gfp_no_kswapd.patch
mm-avoid-waking-kswapd-for-thp-allocations-when-compaction-is-deferred-or-contended.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
drivers-video-add-support-for-the-solomon-ssd1307-oled-controller-checkpatch-fixes.patch
irq-tsk-comm-is-an-array.patch
drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch
mm.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build-fix.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
thp-implement-splitting-pmd-for-huge-zero-page-fix.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

