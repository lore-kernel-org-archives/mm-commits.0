From: akpm@linux-foundation.org
Subject: - revert-gregkh-pci-pci-disable-decode-of-io-memory-during-bar-sizing.patch removed from -mm tree
Date: Tue, 11 Sep 2007 13:20:51 -0700
Message-ID: <200709112020.l8BKKpA5027738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45581 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934164AbXIKUVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 16:21:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, grundler@parisc-linux.org, hancockr@shaw.ca, ink@jurassic.park.msu.ru, jesse.barnes@intel.com, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     revert gregkh-pci-pci-disable-decode-of-io-memory-during-bar-sizing
has been removed from the -mm tree.  Its filename was
     revert-gregkh-pci-pci-disable-decode-of-io-memory-during-bar-sizing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: revert gregkh-pci-pci-disable-decode-of-io-memory-during-bar-sizing
From: Andrew Morton <akpm@linux-foundation.org>

Make way for fix-boot-time-hang-on-g31-g33-pc.patch

Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Robert Hancock <hancockr@shaw.ca>
Cc: Jesse Barnes <jesse.barnes@intel.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/probe.c |   63 +++++-------------------------------------
 1 file changed, 8 insertions(+), 55 deletions(-)

diff -puN drivers/pci/probe.c~revert-gregkh-pci-pci-disable-decode-of-io-memory-during-bar-sizing drivers/pci/probe.c
--- a/drivers/pci/probe.c~revert-gregkh-pci-pci-disable-decode-of-io-memory-during-bar-sizing
+++ a/drivers/pci/probe.c
@@ -180,58 +180,6 @@ static inline int is_64bit_memory(u32 ma
 	return 0;
 }
 
-#define BAR_IS_MEMORY(bar) (((bar) & PCI_BASE_ADDRESS_SPACE) ==	\
-			    PCI_BASE_ADDRESS_SPACE_MEMORY)
-
-/**
- * pci_bar_size - get raw PCI BAR size
- * @dev: PCI device
- * @reg: BAR to probe
- *
- * Use basic PCI probing:
- *   - save original BAR value
- *   - disable MEM or IO decode in PCI_COMMAND reg if appropriate
- *   - write all 1s to the BAR
- *   - read back value
- *   - reenble MEM or IO decode as necessary
- *   - write original value back
- *
- * Returns raw BAR size to caller.
- */
-static u32 pci_bar_size(struct pci_dev *dev, unsigned int reg)
-{
-	u32 orig_reg, sz;
-	u16 orig_cmd;
-
-	pci_read_config_dword(dev, reg, &orig_reg);
-	pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
-
-	/*
-	 * Disable memory or IO decode on the device while writing the test
-	 * value to the BAR. This prevents possible spurious decoding
-	 * of random addresses by the device. Don't do this for host bridges,
-	 * however, since some of them do silly things like disable CPU to RAM
-	 * access if this is done.
-	 */
-	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST) {
-		if (BAR_IS_MEMORY(orig_reg))
-			pci_write_config_word(dev, PCI_COMMAND,
-					      orig_cmd & ~PCI_COMMAND_MEMORY);
-		else
-			pci_write_config_word(dev, PCI_COMMAND,
-					      orig_cmd & ~PCI_COMMAND_IO);
-	}
-
-	pci_write_config_dword(dev, reg, 0xffffffff);
-	pci_read_config_dword(dev, reg, &sz);
-	pci_write_config_dword(dev, reg, orig_reg);
-
-	if ((dev->class >> 8) != PCI_CLASS_BRIDGE_HOST)
-		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
-
-	return sz;
-}
-
 static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 {
 	unsigned int pos, reg, next;
@@ -248,13 +196,16 @@ static void pci_read_bases(struct pci_de
 		res->name = pci_name(dev);
 		reg = PCI_BASE_ADDRESS_0 + (pos << 2);
 		pci_read_config_dword(dev, reg, &l);
-		sz = pci_bar_size(dev, reg);
+		pci_write_config_dword(dev, reg, ~0);
+		pci_read_config_dword(dev, reg, &sz);
+		pci_write_config_dword(dev, reg, l);
 		if (!sz || sz == 0xffffffff)
 			continue;
 		if (l == 0xffffffff)
 			l = 0;
 		raw_sz = sz;
-		if (BAR_IS_MEMORY(l)) {
+		if ((l & PCI_BASE_ADDRESS_SPACE) ==
+				PCI_BASE_ADDRESS_SPACE_MEMORY) {
 			sz = pci_size(l, sz, (u32)PCI_BASE_ADDRESS_MEM_MASK);
 			/*
 			 * For 64bit prefetchable memory sz could be 0, if the
@@ -278,7 +229,9 @@ static void pci_read_bases(struct pci_de
 			u32 szhi, lhi;
 
 			pci_read_config_dword(dev, reg+4, &lhi);
-			szhi = pci_bar_size(dev, reg+4);
+			pci_write_config_dword(dev, reg+4, ~0);
+			pci_read_config_dword(dev, reg+4, &szhi);
+			pci_write_config_dword(dev, reg+4, lhi);
 			sz64 = ((u64)szhi << 32) | raw_sz;
 			l64 = ((u64)lhi << 32) | l;
 			sz64 = pci_size64(l64, sz64, PCI_BASE_ADDRESS_MEM_MASK);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

irq-irq-and-pci_ids-patch-for-intel-tolapai-fix.patch
bug-in-at91-mci-suspend-routines.patch
leases-can-be-hidden-by-flocks.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-powerpc-fixup.patch
revert-gregkh-driver-block-device.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
git-dvb.patch
git-dvb-fixup-2.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mips.patch
git-mmc.patch
git-mmc-fixup2.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-net.patch
git-net-fixup.patch
net-atm-lecc-printk-warning-fix.patch
git-backlight.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-ocfs2.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
net-add-ath5k-wireless-driver-fix.patch
revert-x86_64-mm-intel_cacheinfo-adjustments.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
intel_cacheinfo-misc-section-annotation-fixes-fix.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
hpet-force-enable-on-vt8235-37-chipsets-fix.patch
x86-convert-cpu_sibling_map-to-be-a-per-cpu-variable-broke-ia64.patch
git-xfs.patch
git-xtensa.patch
i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
atyfb-force-29mhz-xtal-on-g3-powerbooks.patch
revert-highmem-catch-illegal-nesting.patch
slub-accurately-compare-debug-flags-during-slab-cache-merge-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
isolate-some-explicit-usage-of-task-tgid-fix-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
