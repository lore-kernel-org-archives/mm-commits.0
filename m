From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 04 Dec 2012 11:28:13 -0800
Message-ID: <20121204192815.8510A200325@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:32902 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2LDT2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 14:28:18 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so312331eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 11:28:17 -0800 (PST)
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

 drivers/edac/i82975x_edac.c |   26 --------------------------
 1 file changed, 26 deletions(-)

diff -puN drivers/edac/i82975x_edac.c~linux-next-git-rejects drivers/edac/i82975x_edac.c
--- a/drivers/edac/i82975x_edac.c~linux-next-git-rejects
+++ a/drivers/edac/i82975x_edac.c
@@ -439,23 +439,11 @@ static void i82975x_init_csrows(struct m
 				struct i82975x_pvt *pvt,
 				struct pci_dev *pdev)
 {
-<<<<<<< HEAD
-	struct csrow_info *csrow;
-	unsigned long last_cumul_size;
-	u8 value;
-	u32 cumul_size, nr_pages;
-	int index, chan;
-	struct dimm_info *dimm;
-	enum dev_type dtype;
-
-	last_cumul_size = 0;
-=======
 	struct dimm_info	*dimm;
 	struct mem_range	*range;
 	u8			boundary;
 	u32			initial_page = 0, last_page;
 	int			row, chan;
->>>>>>> linux-next/akpm-base
 
 	/*
 	 * This chipset provides 3 address modes:
@@ -471,19 +459,6 @@ static void i82975x_init_csrows(struct m
 		/*
 		 * On symetric mode, both channels start from address 0
 		 */
-<<<<<<< HEAD
-		dtype = i82975x_dram_type(mch_window, index);
-		for (chan = 0; chan < csrow->nr_channels; chan++) {
-			dimm = mci->csrows[index]->channels[chan]->dimm;
-
-			dimm->nr_pages = nr_pages / csrow->nr_channels;
-
-			snprintf(csrow->channels[chan]->dimm->label, EDAC_MC_LABEL_LEN, "DIMM %c%d",
-				 (chan == 0) ? 'A' : 'B',
-				 index);
-			dimm->grain = 1 << 7;	/* 128Byte cache-line resolution */
-			dimm->dtype = i82975x_dram_type(mch_window, index);
-=======
 		if (pvt->is_symetric)
 			initial_page = 0;
 
@@ -523,7 +498,6 @@ static void i82975x_init_csrows(struct m
 			snprintf(dimm->label,
 				 EDAC_MC_LABEL_LEN, "DIMM %c%d",
 				 (chan == 0) ? 'A' : 'B', row);
->>>>>>> linux-next/akpm-base
 			dimm->mtype = MEM_DDR2; /* I82975x supports only DDR2 */
 			dimm->edac_mode = EDAC_SECDED; /* only supported */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
drivers-video-add-support-for-the-solomon-ssd1307-oled-controller-checkpatch-fixes.patch
irq-tsk-comm-is-an-array.patch
block-remove-deadlock-in-disk_clear_events-fix.patch
block-prevent-race-cleanup-fix.patch
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
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
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

