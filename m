From: akpm@linux-foundation.org
Subject: - git-alsa-fix.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:25:05 -0700
Message-ID: <200707242325.l6ONP5qL006334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56374 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757880AbXGXXZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:25:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     git-alsa fix
has been removed from the -mm tree.  Its filename was
     git-alsa-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-alsa fix
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "snd_ice1712_gpio_info" [sound/pci/ice1712/snd-ice1712.ko] undefined!

Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/ice1712/ice1712.c |    2 --
 sound/pci/ice1712/ice1712.h |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN sound/pci/ice1712/ice1712.c~git-alsa-fix sound/pci/ice1712/ice1712.c
--- a/sound/pci/ice1712/ice1712.c~git-alsa-fix
+++ a/sound/pci/ice1712/ice1712.c
@@ -1745,8 +1745,6 @@ static struct snd_kcontrol_new snd_ice17
 	.put =		snd_ice1712_spdif_stream_put
 };
 
-#define snd_ice1712_gpio_info		snd_ctl_boolean_mono_info
-
 int snd_ice1712_gpio_get(struct snd_kcontrol *kcontrol,
 			 struct snd_ctl_elem_value *ucontrol)
 {
diff -puN sound/pci/ice1712/ice1712.h~git-alsa-fix sound/pci/ice1712/ice1712.h
--- a/sound/pci/ice1712/ice1712.h~git-alsa-fix
+++ a/sound/pci/ice1712/ice1712.h
@@ -451,11 +451,11 @@ static inline void snd_ice1712_restore_g
 
 /* for bit controls */
 #define ICE1712_GPIO(xiface, xname, xindex, mask, invert, xaccess) \
-{ .iface = xiface, .name = xname, .access = xaccess, .info = snd_ice1712_gpio_info, \
+{ .iface = xiface, .name = xname, .access = xaccess, .info = snd_ctl_boolean_mono_info, \
   .get = snd_ice1712_gpio_get, .put = snd_ice1712_gpio_put, \
   .private_value = mask | (invert << 24) }
 
-int snd_ice1712_gpio_info(struct snd_kcontrol *kcontrol, struct snd_ctl_elem_info *uinfo);
+int snd_ctl_boolean_mono_info(struct snd_kcontrol *kcontrol, struct snd_ctl_elem_info *uinfo);
 int snd_ice1712_gpio_get(struct snd_kcontrol *kcontrol, struct snd_ctl_elem_value *ucontrol);
 int snd_ice1712_gpio_put(struct snd_kcontrol *kcontrol, struct snd_ctl_elem_value *ucontrol);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-stk17ta8-update-for-sysfs-api-change.patch
x86_powernow_k8_acpi-must-depend-on-acpi.patch
revert-x86-serial-convert-legacy-com-ports-to-platform-devices.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
adbhid-produce-all-capslock-key-events-fix.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
git-kvm.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
fix-ide-ide-add-ide-set-pio-take3.patch
mmc-build-fix.patch
git-mtd.patch
git-mtd-fix-printk-warning-in-jffs2_block_check_erase.patch
mtdoops-printk-warning-fixes.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
git-net.patch
ip_auto_config-fix-fix.patch
git-ocfs2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
aacraid-rename-check_reset.patch
git-scsi-target-fixup.patch
git-unionfs.patch
git-watchdog.patch
x86_64-clean-up-apicid_to_node-declaration.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-newsetup-fixup.patch
git-kgdb-fixup.patch
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
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
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
