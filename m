From: akpm@linux-foundation.org
Subject: + use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch added to -mm tree
Date: Thu, 06 Sep 2007 17:41:50 -0700
Message-ID: <200709070041.l870foTZ016002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964819AbXIGAl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie, xemul@openvz.org


The patch titled
     use-helpers-to-obtain-task-pid-in-printks-drm-fix
has been added to the -mm tree.  Its filename is
     use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use-helpers-to-obtain-task-pid-in-printks-drm-fix
From: Andrew Morton <akpm@linux-foundation.org>

git-drm went and changed lots of stuff.

I hope those git-drm changes will be going into 2.6.24?

Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_drv.c  |    2 +-
 drivers/char/drm/drm_fops.c |    5 +++--
 drivers/char/drm/drm_lock.c |    6 +++---
 drivers/char/drm/i810_dma.c |    2 +-
 drivers/char/drm/i830_dma.c |    2 +-
 5 files changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/char/drm/drm_drv.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix drivers/char/drm/drm_drv.c
--- a/drivers/char/drm/drm_drv.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix
+++ a/drivers/char/drm/drm_drv.c
@@ -463,7 +463,7 @@ int drm_ioctl(struct inode *inode, struc
 	++file_priv->ioctl_count;
 
 	DRM_DEBUG("pid=%d, cmd=0x%02x, nr=0x%02x, dev 0x%lx, auth=%d\n",
-		  current->pid, cmd, nr,
+		  task_pid_nr(current), cmd, nr,
 		  (long)old_encode_dev(file_priv->head->device),
 		  file_priv->authenticated);
 
diff -puN drivers/char/drm/drm_fops.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix drivers/char/drm/drm_fops.c
--- a/drivers/char/drm/drm_fops.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix
+++ a/drivers/char/drm/drm_fops.c
@@ -244,7 +244,7 @@ static int drm_open_helper(struct inode 
 	filp->private_data = priv;
 	priv->filp = filp;
 	priv->uid = current->euid;
-	priv->pid = current->pid;
+	priv->pid = task_pid_nr(current);
 	priv->minor = minor;
 	priv->head = drm_heads[minor];
 	priv->ioctl_count = 0;
@@ -339,7 +339,8 @@ int drm_release(struct inode *inode, str
 	 */
 
 	DRM_DEBUG("pid = %d, device = 0x%lx, open_count = %d\n",
-		  current->pid, (long)old_encode_dev(file_priv->head->device),
+		  task_pid_nr(current),
+		  (long)old_encode_dev(file_priv->head->device),
 		  dev->open_count);
 
 	if (dev->driver->reclaim_buffers_locked && dev->lock.hw_lock) {
diff -puN drivers/char/drm/drm_lock.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix drivers/char/drm/drm_lock.c
--- a/drivers/char/drm/drm_lock.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix
+++ a/drivers/char/drm/drm_lock.c
@@ -58,12 +58,12 @@ int drm_lock(struct drm_device *dev, voi
 
 	if (lock->context == DRM_KERNEL_CONTEXT) {
 		DRM_ERROR("Process %d using kernel context %d\n",
-			  current->pid, lock->context);
+			  task_pid_nr(current), lock->context);
 		return -EINVAL;
 	}
 
 	DRM_DEBUG("%d (pid %d) requests lock (0x%08x), flags = 0x%08x\n",
-		  lock->context, current->pid,
+		  lock->context, task_pid_nr(current),
 		  dev->lock.hw_lock->lock, lock->flags);
 
 	if (drm_core_check_feature(dev, DRIVER_DMA_QUEUE))
@@ -153,7 +153,7 @@ int drm_unlock(struct drm_device *dev, v
 
 	if (lock->context == DRM_KERNEL_CONTEXT) {
 		DRM_ERROR("Process %d using kernel context %d\n",
-			  current->pid, lock->context);
+			  task_pid_nr(current), lock->context);
 		return -EINVAL;
 	}
 
diff -puN drivers/char/drm/i810_dma.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix drivers/char/drm/i810_dma.c
--- a/drivers/char/drm/i810_dma.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix
+++ a/drivers/char/drm/i810_dma.c
@@ -1024,7 +1024,7 @@ static int i810_getbuf(struct drm_device
 	retcode = i810_dma_get_buffer(dev, d, file_priv);
 
 	DRM_DEBUG("i810_dma: %d returning %d, granted = %d\n",
-		  current->pid, retcode, d->granted);
+		  task_pid_nr(current), retcode, d->granted);
 
 	sarea_priv->last_dispatch = (int)hw_status[5];
 
diff -puN drivers/char/drm/i830_dma.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix drivers/char/drm/i830_dma.c
--- a/drivers/char/drm/i830_dma.c~use-helpers-to-obtain-task-pid-in-printks-drm-fix
+++ a/drivers/char/drm/i830_dma.c
@@ -1409,7 +1409,7 @@ static int i830_getbuf(struct drm_device
 	retcode = i830_dma_get_buffer(dev, d, file_priv);
 
 	DRM_DEBUG("i830_dma: %d returning %d, granted = %d\n",
-		  current->pid, retcode, d->granted);
+		  task_pid_nr(current), retcode, d->granted);
 
 	sarea_priv->last_dispatch = (int)hw_status[5];
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

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
