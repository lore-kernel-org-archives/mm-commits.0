From: akpm@linux-foundation.org
Subject: - git-mips-fixup.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:10:52 -0700
Message-ID: <200707191910.l6JJAqZ0017332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765243AbXGSTLA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 15:11:00 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l6JJAwPX010498
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 19 Jul 2007 12:10:59 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-mips-fixup
has been removed from the -mm tree.  Its filename was
     git-mips-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-mips-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig                     |    4 ----
 arch/mips/cobalt/setup.c              |    4 ----
 arch/mips/jmr3927/rbhma3100/kgdb_io.c |    4 ----
 arch/mips/pci/pci-ocelot.c            |    6 ------
 4 files changed, 18 deletions(-)

diff -puN arch/mips/Kconfig~git-mips-fixup arch/mips/Kconfig
--- a/arch/mips/Kconfig~git-mips-fixup
+++ a/arch/mips/Kconfig
@@ -630,12 +630,8 @@ config TOSHIBA_JMR3927
 	select SYS_SUPPORTS_32BIT_KERNEL
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_BIG_ENDIAN
-<<<<<<< HEAD/arch/mips/Kconfig
-	select GENERIC_HARDIRQS_NO__DO_IRQ
-=======
 	select TOSHIBA_BOARDS
 	select GENERIC_HARDIRQS_NO__DO_IRQ
->>>>>>> /arch/mips/Kconfig
 
 config TOSHIBA_RBTX4927
 	bool "Toshiba TBTX49[23]7 board"
diff -puN arch/mips/cobalt/setup.c~git-mips-fixup arch/mips/cobalt/setup.c
--- a/arch/mips/cobalt/setup.c~git-mips-fixup
+++ a/arch/mips/cobalt/setup.c
@@ -103,9 +103,6 @@ void __init plat_mem_setup(void)
 	/* These resources have been reserved by VIA SuperI/O chip. */
 	for (i = 0; i < ARRAY_SIZE(cobalt_reserved_resources); i++)
 		request_resource(&ioport_resource, cobalt_reserved_resources + i);
-<<<<<<< HEAD/arch/mips/cobalt/setup.c
-=======
-
         /* Read the cobalt id register out of the PCI config space */
         PCI_CFG_SET(devfn, (VIA_COBALT_BRD_ID_REG & ~0x3));
         cobalt_board_id = GT_READ(GT_PCI0_CFGDATA_OFS);
@@ -128,7 +125,6 @@ void __init plat_mem_setup(void)
 		early_serial_setup(&uart);
 #endif
 	}
->>>>>>> /arch/mips/cobalt/setup.c
 }
 
 /*
diff -puN arch/mips/jmr3927/rbhma3100/kgdb_io.c~git-mips-fixup arch/mips/jmr3927/rbhma3100/kgdb_io.c
--- a/arch/mips/jmr3927/rbhma3100/kgdb_io.c~git-mips-fixup
+++ a/arch/mips/jmr3927/rbhma3100/kgdb_io.c
@@ -36,11 +36,7 @@
 #define TIMEOUT       0xffffff
 
 static int remoteDebugInitialized = 0;
-<<<<<<< HEAD/arch/mips/jmr3927/rbhma3100/kgdb_io.c
 static void debugInit(int baud);
-=======
-static void debugInit(int baud)
->>>>>>> /arch/mips/jmr3927/rbhma3100/kgdb_io.c
 
 int putDebugChar(unsigned char c)
 {
diff -puN arch/mips/pci/pci-ocelot.c~git-mips-fixup arch/mips/pci/pci-ocelot.c
--- a/arch/mips/pci/pci-ocelot.c~git-mips-fixup
+++ a/arch/mips/pci/pci-ocelot.c
@@ -81,15 +81,9 @@ static struct resource ocelot_io_resourc
 };
 
 static struct pci_controller ocelot_pci_controller = {
-<<<<<<< HEAD/arch/mips/pci/pci-ocelot.c
 	.pci_ops	= gt64xxx_pci0_ops,
 	.mem_resource	= &ocelot_mem_resource,
 	.io_resource	= &ocelot_io_resource,
-=======
-	.pci_ops	= gt64xxx_pci0_ops;
-	.mem_resource	= &ocelot_mem_resource;
-	.io_resource	= &ocelot_io_resource;
->>>>>>> /arch/mips/pci/pci-ocelot.c
 };
 
 static int __init ocelot_pcibios_init(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
git-input.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-ubi.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
git-scsi-misc.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
usb-sierra-add-tru-install-c-support-fix.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
fix-x86_64-mm-sched-clock-share.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-fix-few-style-problems-pointed-out-by-checkpatchpl.patch
i386-do-not-restore-reserved-memory-after-hibernation.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
i386-add-cpu_relax-to-cmos_lock.patch
x86_64-flush_tlb_kernel_range-warning-fix.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
revert-x86_64-hpet-tsc-calibration-fix-broken-smi-detection-logic.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
x86_64-get-mp_bus_to_node-as-early.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
file-capabilities-clear-caps-cleanup-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
