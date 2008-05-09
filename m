From: akpm@linux-foundation.org
Subject: - git-vfs-cleanups-unbork.patch removed from -mm tree
Date: Fri, 09 May 2008 14:47:30 -0700
Message-ID: <200805092147.m49LlUBa027240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751675AbYEIV4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     git-vfs-cleanups: unbork
has been removed from the -mm tree.  Its filename was
     git-vfs-cleanups-unbork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-vfs-cleanups: unbork
From: Andrew Morton <akpm@linux-foundation.org>

fs/namespace.c: In function 'clone_mnt':
fs/namespace.c:614: warning: 'err' may be used uninitialized in this function

Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/namespace.c~git-vfs-cleanups-unbork fs/namespace.c
--- a/fs/namespace.c~git-vfs-cleanups-unbork
+++ a/fs/namespace.c
@@ -619,8 +619,10 @@ static struct vfsmount *clone_mnt(struct
 			goto out_error;
 	}
 	mnt = alloc_vfsmnt(old->mnt_devname);
-	if (!mnt)
+	if (!mnt) {
+		err = -ENOMEM;
 		goto alloc_failed;
+	}
 
 	if (flag & (CL_SLAVE | CL_PRIVATE))
 		mnt->mnt_group_id = 0; /* not a peer of original */
@@ -628,7 +630,7 @@ static struct vfsmount *clone_mnt(struct
 		mnt->mnt_group_id = old->mnt_group_id;
 
 	if ((flag & CL_MAKE_SHARED) && !mnt->mnt_group_id) {
-		int err = mnt_alloc_group_id(mnt);
+		err = mnt_alloc_group_id(mnt);
 		if (err)
 			goto out_free;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
quota-dont-call-sync_fs-from-vfs_quota_off-when-theres-no-quota-turn-off-fix.patch
fix-hfsplus-oops-on-image-without-extents-fix.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic-fix.patch
atmel_lcdfb-fix-pixclok-divider-calculation-checkpatch-fixes.patch
memcg-fix-possible-panic-when-config_mm_owner=y-checkpatch-fixes.patch
linux-next.patch
revert-9p-convert-from-semaphore-to-spinlock.patch
revert-vt-fix-background-color-on-line-feed.patch
revert-lxfb-extend-pll-table-to-support-dotclocks-below-25-mhz.patch
revert-acpica-fixes-for-unload-and-ddbhandles.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-kernel-setupc-printk-warning-fix.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
dlm-convert-connections_lock-in-a-mutex-fix.patch
git-input.patch
git-jg-misc-git-rejects.patch
revert-git-kbuild.patch
git-mmc.patch
git-ubifs.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-unionfs.patch
git-unionfs-fixup.patch
unionfs-broke.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
git-v9fs.patch
revert-git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
ext4-is-busted-on-m68k.patch
common-implementation-of-iterative-div-mod-fix.patch
common-implementation-of-iterative-div-mod-checkpatch-fixes.patch
common-implementation-of-iterative-div-mod-fix-2.patch
mm-define-default-cpu_to_node-checkpatch-fixes.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch
mm-verify-the-page-links-and-memory-model-fix.patch
mm-verify-the-page-links-and-memory-model-fix-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-checkpatch-fixes.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-inotify_init-fix.patch
hysdn-no-longer-broken-on-smp.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
reiser4.patch
reiser4-semaphore-fix.patch
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

