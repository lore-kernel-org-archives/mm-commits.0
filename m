From: akpm@linux-foundation.org
Subject: + revert-8139too-clean-up-i-o-remapping.patch added to -mm tree
Date: Thu, 09 Aug 2007 11:35:53 -0700
Message-ID: <200708091835.l79IZrZ6013166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39837 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbXHISgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 14:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jeff@garzik.org, michal.k.k.piotrowski@gmail.com


The patch titled
     revert "8139too: clean up I/O remapping"
has been added to the -mm tree.  Its filename is
     revert-8139too-clean-up-i-o-remapping.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert "8139too: clean up I/O remapping"
From: Andrew Morton <akpm@linux-foundation.org>

Revert git-netdev-all's 9ee6b32a47b9abc565466a9c3b127a5246b452e5

Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/8139too.c |   50 +++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 21 deletions(-)

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

genirq-temporary-fix-for-level-triggered-irq-resend-fix.patch
fbcon-kill-compile-warning-fix.patch
fix-serial-buffer-memory-leak-fix.patch
mtdchar-build-fix.patch
remove-bdput-from-do_open-in-fs-block_devc-fix.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
git-dvb-fixup-2.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-platform-ide-driver.patch
ide-arm-hack.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
ax88796-printk-fixes.patch
natsemi-fix-netdev-error-acounting.patch
git-ixgbe-build-fix.patch
ip_auto_config-fix-fix.patch
fib_trie-cleanup-fix.patch
introduce-u16_max-and-u32_max-fix.patch
introduce-strtol_check_range-fix.patch
git-nfsd-build-fixes.patch
nfsd-warning-fix.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-wireless.patch
disable-b44-and-bcm43xx.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
x86_64-get-mp_bus_to_node-as-early-v3-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
fix-some-x86-x86-64-acpi-cpufreq-driver-issues.patch
pci-align-bar-settings-for-legacy-mode-ide-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
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
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
mm-bdi-init-hooks-fix.patch
lib-floating-proportions-_single-tidy.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
w1-build-fix.patch
