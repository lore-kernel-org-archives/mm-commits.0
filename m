From: akpm@linux-foundation.org
Subject: - git-drm-git-rejects.patch removed from -mm tree
Date: Thu, 07 Aug 2008 13:11:05 -0700
Message-ID: <200808072011.m77KB50E003083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690AbYHGUVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 16:21:23 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m77KKocD013803
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 7 Aug 2008 13:20:51 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-drm-git-rejects
has been removed from the -mm tree.  Its filename was
     git-drm-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-drm-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/ati_pcigart.c |   15 ---------------
 drivers/char/drm/drm_fops.c    |    7 +------
 2 files changed, 1 insertion(+), 21 deletions(-)

diff -puN drivers/char/drm/ati_pcigart.c~git-drm-git-rejects drivers/char/drm/ati_pcigart.c
--- a/drivers/char/drm/ati_pcigart.c~git-drm-git-rejects
+++ a/drivers/char/drm/ati_pcigart.c
@@ -38,26 +38,11 @@
 static int drm_ati_alloc_pcigart_table(struct drm_device *dev,
 				       struct drm_ati_pcigart_info *gart_info)
 {
-<<<<<<< HEAD:drivers/char/drm/ati_pcigart.c
 	gart_info->table_handle = drm_pci_alloc(dev, gart_info->table_size,
 						PAGE_SIZE,
 						gart_info->table_mask);
 	if (gart_info->table_handle == NULL)
 		return -ENOMEM;
-=======
-	unsigned long address;
-	struct page *page;
-	int i;
-
-	DRM_DEBUG("%d order\n", order);
-
-	address = __get_free_pages(GFP_KERNEL | __GFP_COMP,
-				   order);
-	if (address == 0UL)
-		return NULL;
-
-	page = virt_to_page(address);
->>>>>>> FETCH_HEAD:drivers/char/drm/ati_pcigart.c
 
 	return 0;
 }
diff -puN drivers/char/drm/drm_fops.c~git-drm-git-rejects drivers/char/drm/drm_fops.c
--- a/drivers/char/drm/drm_fops.c~git-drm-git-rejects
+++ a/drivers/char/drm/drm_fops.c
@@ -405,14 +405,9 @@ int drm_release(struct inode *inode, str
 			 * Wait for a while.
 			 */
 
-<<<<<<< HEAD:drivers/char/drm/drm_fops.c
-			do{
+			do {
 				spin_lock_irqsave(&dev->lock.spinlock,
 						  irqflags);
-=======
-			do {
-				spin_lock(&dev->lock.spinlock);
->>>>>>> FETCH_HEAD:drivers/char/drm/drm_fops.c
 				locked = dev->lock.idle_has_lock;
 				spin_unlock_irqrestore(&dev->lock.spinlock,
 						       irqflags);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

radeonfb-fix-engine-hangs-and-cache-flushing.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-pci-irqc-attempt-to-clean-up-code-layout.patch
zero-based-percpu-use-vmlinux_symbol-in-include-asm-generic-vmlinuxldsh.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
i2c-renesas-highlander-fpga-smbus-support-update-fix.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-serio-xilinx_ps2c-fix-warning.patch
git-jg-misc.patch
git-kbuild-fixes.patch
git-ubi-git-rejects.patch
sundance-set-carrier-status-on-link-change-events.patch
cassini-use-request_firmware.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch
sched-type-fix.patch
scsi-gdthc-use-unaligned-access-helpers.patch
git-unionfs.patch
git-logfs-git-rejects.patch
git-logfs-fixup.patch
drivers-usb-class-cdc-acmc-use-correct-type-for-cpu-flags.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
git-xtensa.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
hwmon-adc124s501-generic-driver.patch
drivers-net-netxen-netxen_nic_hwc-fix-printk-warnings.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
scsi-megaraid_sas-add-the-new-controllers-support-checkpatch-fixes.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
h8300-generic_bug-support-checkpatch-fixes.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
eink_apollofb-new-driver-for-apollo-eink-controller.patch
devpts-switch-to-ida-checkpatch-fixes.patch
gcov-architecture-specific-compile-flag-adjustments-powerpc-moved-stuff.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

