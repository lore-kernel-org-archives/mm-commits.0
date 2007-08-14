From: akpm@linux-foundation.org
Subject: - revert-x86_64-mm-pci-mmconfig-eax.patch removed from -mm tree
Date: Tue, 14 Aug 2007 11:59:58 -0700
Message-ID: <200708141859.l7EIxwDf015872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932355AbXHNTAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     revert x86_64-mm-pci-mmconfig-eax
has been removed from the -mm tree.  Its filename was
     revert-x86_64-mm-pci-mmconfig-eax.patch

This patch was dropped because it doesn't apply and I need to see if we fixed it

------------------------------------------------------
Subject: revert x86_64-mm-pci-mmconfig-eax
From: Andrew Morton <akpm@linux-foundation.org>

Kills the Vaio: no netconsole, fails at "mountL could not find filesystem
/dev/root" in initrd.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/mmconfig.c   |   14 ++++++-----
 arch/i386/pci/pci.h        |   43 -----------------------------------
 arch/x86_64/pci/mmconfig.c |   12 ++++-----
 3 files changed, 14 insertions(+), 55 deletions(-)

diff -puN arch/i386/pci/mmconfig.c~revert-x86_64-mm-pci-mmconfig-eax arch/i386/pci/mmconfig.c
--- a/arch/i386/pci/mmconfig.c~revert-x86_64-mm-pci-mmconfig-eax
+++ a/arch/i386/pci/mmconfig.c
@@ -82,15 +82,16 @@ static int pci_mmcfg_read(unsigned int s
 
 	switch (len) {
 	case 1:
-		*value = mmio_config_readb(mmcfg_virt_addr + reg);
+		*value = readb(mmcfg_virt_addr + reg);
 		break;
 	case 2:
-		*value = mmio_config_readw(mmcfg_virt_addr + reg);
+		*value = readw(mmcfg_virt_addr + reg);
 		break;
 	case 4:
-		*value = mmio_config_readl(mmcfg_virt_addr + reg);
+		*value = readl(mmcfg_virt_addr + reg);
 		break;
 	}
+
 	spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
@@ -115,15 +116,16 @@ static int pci_mmcfg_write(unsigned int 
 
 	switch (len) {
 	case 1:
-		mmio_config_writeb(mmcfg_virt_addr, value);
+		writeb(value, mmcfg_virt_addr + reg);
 		break;
 	case 2:
-		mmio_config_writew(mmcfg_virt_addr, value);
+		writew(value, mmcfg_virt_addr + reg);
 		break;
 	case 4:
-		mmio_config_writel(mmcfg_virt_addr, value);
+		writel(value, mmcfg_virt_addr + reg);
 		break;
 	}
+
 	spin_unlock_irqrestore(&pci_config_lock, flags);
 
 	return 0;
diff -puN arch/i386/pci/pci.h~revert-x86_64-mm-pci-mmconfig-eax arch/i386/pci/pci.h
--- a/arch/i386/pci/pci.h~revert-x86_64-mm-pci-mmconfig-eax
+++ a/arch/i386/pci/pci.h
@@ -104,46 +104,3 @@ extern DECLARE_BITMAP(pci_mmcfg_fallback
 extern int __init pci_mmcfg_arch_reachable(unsigned int seg, unsigned int bus,
 					   unsigned int devfn);
 extern int __init pci_mmcfg_arch_init(void);
-
-/*
- * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
- * on their northbrige except through the * %eax register. As such, you MUST
- * NOT use normal IOMEM accesses, you need to only use the magic mmio-config
- * accessor functions.
- * In fact just use pci_config_*, nothing else please.
- */
-static inline unsigned char mmio_config_readb(void __iomem *pos)
-{
-	u8 val;
-	asm volatile("movb (%1),%%al" : "=a" (val) : "r" (pos));
-	return val;
-}
-
-static inline unsigned short mmio_config_readw(void __iomem *pos)
-{
-	u16 val;
-	asm volatile("movw (%1),%%ax" : "=a" (val) : "r" (pos));
-	return val;
-}
-
-static inline unsigned int mmio_config_readl(void __iomem *pos)
-{
-	u32 val;
-	asm volatile("movl (%1),%%eax" : "=a" (val) : "r" (pos));
-	return val;
-}
-
-static inline void mmio_config_writeb(void __iomem *pos, u8 val)
-{
-	asm volatile("movb %%al,(%1)" :: "a" (val), "r" (pos) : "memory");
-}
-
-static inline void mmio_config_writew(void __iomem *pos, u16 val)
-{
-	asm volatile("movw %%ax,(%1)" :: "a" (val), "r" (pos) : "memory");
-}
-
-static inline void mmio_config_writel(void __iomem *pos, u32 val)
-{
-	asm volatile("movl %%eax,(%1)" :: "a" (val), "r" (pos) : "memory");
-}
diff -puN arch/x86_64/pci/mmconfig.c~revert-x86_64-mm-pci-mmconfig-eax arch/x86_64/pci/mmconfig.c
--- a/arch/x86_64/pci/mmconfig.c~revert-x86_64-mm-pci-mmconfig-eax
+++ a/arch/x86_64/pci/mmconfig.c
@@ -66,13 +66,13 @@ static int pci_mmcfg_read(unsigned int s
 
 	switch (len) {
 	case 1:
-		*value = mmio_config_readb(addr + reg);
+		*value = readb(addr + reg);
 		break;
 	case 2:
-		*value = mmio_config_readw(addr + reg);
+		*value = readw(addr + reg);
 		break;
 	case 4:
-		*value = mmio_config_readl(addr + reg);
+		*value = readl(addr + reg);
 		break;
 	}
 
@@ -94,13 +94,13 @@ static int pci_mmcfg_write(unsigned int 
 
 	switch (len) {
 	case 1:
-		mmio_config_writeb(addr + reg, value);
+		writeb(value, addr + reg);
 		break;
 	case 2:
-		mmio_config_writew(addr + reg, value);
+		writew(value, addr + reg);
 		break;
 	case 4:
-		mmio_config_writel(addr + reg, value);
+		writel(value, addr + reg);
 		break;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
free_irq-fix-debug_shirq-handling.patch
remove-bdput-from-do_open-in-fs-block_devc-fix.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
git-dma-up-fix.patch
git-dvb-fixup-2.patch
adbhid-produce-all-capslock-key-events.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
ide-arm-hack.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-ixgbe-build-fix.patch
git-net.patch
git-net-fixup.patch
introduce-strtol_check_range.patch
git-backlight.patch
git-nfsd.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
bsg-declare-request_queue.patch
aacraid-rename-check_reset.patch
scsi-ipsc-warning-fix.patch
git-unionfs.patch
git-unionfs-build-fix.patch
git-unionfs-fix-2.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
git-xfs.patch
git-kgdb-fixup.patch
fix-some-x86-x86-64-acpi-cpufreq-driver-issues.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
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
