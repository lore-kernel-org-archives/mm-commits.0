From: akpm@linux-foundation.org
Subject: + revert-x86_64-mm-pci-mmconfig-eax.patch added to -mm tree
Date: Wed, 25 Jul 2007 00:49:19 -0700
Message-ID: <200707250749.l6P7nKr8023899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40122 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762316AbXGYHtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 03:49:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de


The patch titled
     revert x86_64-mm-pci-mmconfig-eax
has been added to the -mm tree.  Its filename is
     revert-x86_64-mm-pci-mmconfig-eax.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
rtc-stk17ta8-update-for-sysfs-api-change.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
ufs-printk-warning-fix.patch
i2c-ds1682-warning-fix.patch
edac-is-bust-on-mips.patch
kdebugh-forward-declare-struct-struct-notifier_block.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-build-fix.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
dma-arch-fix.patch
ia64-rename-partial_page.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
iforce-warning-fix.patch
git-kvm.patch
libata-arm-ioh-needs-iomaph.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
ide-bodge-things-around-to-make-arm-work.patch
mmc-build-fix.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
ax88796-printk-fixes.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
ip_auto_config-fix-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-scsi-rc-fixes.patch
git-scsi-target-fixup.patch
more-request_queue_t-removal.patch
git-unionfs.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
git-watchdog.patch
revert-x86_64-mm-pci-mmconfig-eax.patch
fix-x86_64-mm-early-quirks-unification.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
git-kgdb-fixup.patch
git-kgdb-arm-fix.patch
git-kgdb-mips-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
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
use-list_head-in-binfmt-handling-fix.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
ip2main-warning-fix.patch
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
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
