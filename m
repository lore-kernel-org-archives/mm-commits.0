From: akpm@linux-foundation.org
Subject: - revert-8139too-clean-up-i-o-remapping.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:27:06 -0700
Message-ID: <200709160927.l8G9R6cq009235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811AbXIPJiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeff@garzik.org, michal.k.k.piotrowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     revert "8139too: clean up I/O remapping"
has been removed from the -mm tree.  Its filename was
     revert-8139too-clean-up-i-o-remapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: revert "8139too: clean up I/O remapping"
From: Andrew Morton <akpm@linux-foundation.org>

Revert git-netdev-all's 9ee6b32a47b9abc565466a9c3b127a5246b452e5.  Michal was
getting oopses.

Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/8139too.c |   50 +++++++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 21 deletions(-)

diff -puN drivers/net/8139too.c~revert-8139too-clean-up-i-o-remapping drivers/net/8139too.c
--- a/drivers/net/8139too.c~revert-8139too-clean-up-i-o-remapping
+++ a/drivers/net/8139too.c
@@ -121,15 +121,8 @@
 
 
 /* enable PIO instead of MMIO, if CONFIG_8139TOO_PIO is selected */
-enum rtl_bar_map_info {
-	rtl_pio_bar	= 0,	/* PCI BAR #0: PIO */
-	rtl_mmio_bar	= 1,	/* PCI BAR #1: MMIO */
-};
-
 #ifdef CONFIG_8139TOO_PIO
-static int use_pio	= 1;
-#else
-static int use_pio;
+#define USE_IO_OPS 1
 #endif
 
 /* define to 1, 2 or 3 to enable copious debugging info */
@@ -620,17 +613,14 @@ MODULE_DESCRIPTION ("RealTek RTL-8139 Fa
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
-module_param(multicast_filter_limit, int, 0444);
+module_param(multicast_filter_limit, int, 0);
 module_param_array(media, int, NULL, 0);
 module_param_array(full_duplex, int, NULL, 0);
-module_param(debug, int, 0444);
-module_param(use_pio, int, 0444);
-
+module_param(debug, int, 0);
+MODULE_PARM_DESC (debug, "8139too bitmapped message enable number");
 MODULE_PARM_DESC (multicast_filter_limit, "8139too maximum number of filtered multicast addresses");
 MODULE_PARM_DESC (media, "8139too: Bits 4+9: force full duplex, bit 5: 100Mbps");
 MODULE_PARM_DESC (full_duplex, "8139too: Force full duplex for board(s) (1)");
-MODULE_PARM_DESC (debug, "8139too bitmapped message enable number");
-MODULE_PARM_DESC (use_pio, "Non-zero to enable PIO (rather than MMIO) register mapping");
 
 static int read_eeprom (void __iomem *ioaddr, int location, int addr_len);
 static int rtl8139_open (struct net_device *dev);
@@ -718,7 +708,13 @@ static void __rtl8139_cleanup_dev (struc
 	assert (tp->pci_dev != NULL);
 	pdev = tp->pci_dev;
 
-	pci_iounmap (pdev, tp->mmio_addr);
+#ifdef USE_IO_OPS
+	if (tp->mmio_addr)
+		ioport_unmap (tp->mmio_addr);
+#else
+	if (tp->mmio_addr)
+		pci_iounmap (pdev, tp->mmio_addr);
+#endif /* USE_IO_OPS */
 
 	/* it's ok to call this even if we have no regions to free */
 	pci_release_regions (pdev);
@@ -794,32 +790,32 @@ static int __devinit rtl8139_init_board 
 	DPRINTK("PIO region size == 0x%02X\n", pio_len);
 	DPRINTK("MMIO region size == 0x%02lX\n", mmio_len);
 
+#ifdef USE_IO_OPS
 	/* make sure PCI base addr 0 is PIO */
 	if (!(pio_flags & IORESOURCE_IO)) {
 		dev_err(&pdev->dev, "region #0 not a PIO resource, aborting\n");
 		rc = -ENODEV;
 		goto err_out;
 	}
-
 	/* check for weird/broken PCI region reporting */
 	if (pio_len < RTL_MIN_IO_SIZE) {
 		dev_err(&pdev->dev, "Invalid PCI I/O region size(s), aborting\n");
 		rc = -ENODEV;
 		goto err_out;
 	}
-
+#else
 	/* make sure PCI base addr 1 is MMIO */
 	if (!(mmio_flags & IORESOURCE_MEM)) {
 		dev_err(&pdev->dev, "region #1 not an MMIO resource, aborting\n");
 		rc = -ENODEV;
 		goto err_out;
 	}
-
 	if (mmio_len < RTL_MIN_IO_SIZE) {
 		dev_err(&pdev->dev, "Invalid PCI mem region size(s), aborting\n");
 		rc = -ENODEV;
 		goto err_out;
 	}
+#endif
 
 	rc = pci_request_regions (pdev, DRV_NAME);
 	if (rc)
@@ -829,16 +825,28 @@ static int __devinit rtl8139_init_board 
 	/* enable PCI bus-mastering */
 	pci_set_master (pdev);
 
-	/* iomap MMIO region */
-	ioaddr = pci_iomap(pdev, use_pio ? rtl_pio_bar : rtl_mmio_bar, 0);
+#ifdef USE_IO_OPS
+	ioaddr = ioport_map(pio_start, pio_len);
+	if (!ioaddr) {
+		dev_err(&pdev->dev, "cannot map PIO, aborting\n");
+		rc = -EIO;
+		goto err_out;
+	}
+	dev->base_addr = pio_start;
+	tp->mmio_addr = ioaddr;
+	tp->regs_len = pio_len;
+#else
+	/* ioremap MMIO region */
+	ioaddr = pci_iomap(pdev, 1, 0);
 	if (ioaddr == NULL) {
-		dev_err(&pdev->dev, "cannot map I/O regions, aborting\n");
+		dev_err(&pdev->dev, "cannot remap MMIO, aborting\n");
 		rc = -EIO;
 		goto err_out;
 	}
 	dev->base_addr = (long) ioaddr;
 	tp->mmio_addr = ioaddr;
 	tp->regs_len = mmio_len;
+#endif /* USE_IO_OPS */
 
 	/* Bring old chips out of low-power mode. */
 	RTL_W8 (HltClk, 'R');
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-dac960-driver-on-machines-which-dont-support-64-bit-dma-fix.patch
atyfb-force-29mhz-xtal-on-g3-powerbooks.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
alsa-procfs-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
git-dvb.patch
git-dvb-fixup-2.patch
git-dvb-build-fix.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
git-infiniband.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-jg-misc-revert-scsi-diff.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform-update.patch
git-mmc.patch
git-mmc-fixup2.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-net.patch
git-net-fixup.patch
net-atm-lecc-printk-warning-fix.patch
git-backlight.patch
git-backlight-build-fix.patch
git-backlight-dependency-fix.patch
git-net-vs-git-nfs.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-nfsd-fixup.patch
git-ocfs2.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
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
intel_cacheinfo-misc-section-annotation-fixes.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
git-kgdb-fixup.patch
i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
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
mm-bdi-init-hooks.patch
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
i386-and-x86_64-randomize-brk-fix.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs.patch
modpost-detect-unterminated-device-id-lists-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
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
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
