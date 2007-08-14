From: akpm@linux-foundation.org
Subject: - disable-b44-and-bcm43xx.patch removed from -mm tree
Date: Tue, 14 Aug 2007 11:59:00 -0700
Message-ID: <200708141859.l7EIx0Ks015847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933477AbXHNTAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:00:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linville@tuxdriver.com, mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     disable b44 and bcm43xx
has been removed from the -mm tree.  Its filename was
     disable-b44-and-bcm43xx.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: disable b44 and bcm43xx
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/Kconfig                           |    1 +
 drivers/net/wireless/bcm43xx-mac80211/Kconfig |    1 +
 drivers/net/wireless/bcm43xx/Kconfig          |    1 +
 3 files changed, 3 insertions(+)

diff -puN drivers/net/Kconfig~disable-b44-and-bcm43xx drivers/net/Kconfig
--- a/drivers/net/Kconfig~disable-b44-and-bcm43xx
+++ a/drivers/net/Kconfig
@@ -1435,6 +1435,7 @@ config APRICOT
 config B44
 	tristate "Broadcom 440x/47xx ethernet support"
 	depends on HAS_IOMEM
+	depends on BROKEN
 	select SSB
 	select MII
 	help
diff -puN drivers/net/wireless/bcm43xx-mac80211/Kconfig~disable-b44-and-bcm43xx drivers/net/wireless/bcm43xx-mac80211/Kconfig
--- a/drivers/net/wireless/bcm43xx-mac80211/Kconfig~disable-b44-and-bcm43xx
+++ a/drivers/net/wireless/bcm43xx-mac80211/Kconfig
@@ -1,6 +1,7 @@
 config BCM43XX_MAC80211
 	tristate "Broadcom BCM43xx wireless support (mac80211 stack)"
 	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on BROKEN
 	select FW_LOADER
 	select SSB
 	select HW_RANDOM
diff -puN drivers/net/wireless/bcm43xx/Kconfig~disable-b44-and-bcm43xx drivers/net/wireless/bcm43xx/Kconfig
--- a/drivers/net/wireless/bcm43xx/Kconfig~disable-b44-and-bcm43xx
+++ a/drivers/net/wireless/bcm43xx/Kconfig
@@ -2,6 +2,7 @@ config BCM43XX
 	tristate "Broadcom BCM43xx wireless support"
 	depends on PCI && IEEE80211 && IEEE80211_SOFTMAC && WLAN_80211 && EXPERIMENTAL
 	depends on BCM43XX_MAC80211 != 'y'
+	depends on BROKEN
 	select WIRELESS_EXT
 	select FW_LOADER
 	select HW_RANDOM
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
disable-b44-and-bcm43xx.patch
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
