From: akpm@linux-foundation.org
Subject: + git-vfs-cleanups-reject.patch added to -mm tree
Date: Fri, 16 May 2008 15:38:08 -0700
Message-ID: <200805162238.m4GMc8hx002525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756097AbYEPWjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ezk@cs.sunysb.edu, miklos@szeredi.hu


The patch titled
     git-vfs-cleanups vs git-unionfs
has been added to the -mm tree.  Its filename is
     git-vfs-cleanups-reject.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-vfs-cleanups vs git-unionfs
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN fs/ecryptfs/inode.c~git-vfs-cleanups-reject fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~git-vfs-cleanups-reject
+++ a/fs/ecryptfs/inode.c
@@ -555,25 +555,27 @@ ecryptfs_rename(struct inode *old_dir, s
 	int rc;
 	struct dentry *lower_old_dentry;
 	struct dentry *lower_new_dentry;
-	struct dentry *lower_old_dir_dentry;
-	struct dentry *lower_new_dir_dentry;
+	struct path lower_old_dir;
+	struct path lower_new_dir;
 
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
 	dget(lower_old_dentry);
 	dget(lower_new_dentry);
-	lower_old_dir_dentry = dget_parent(lower_old_dentry);
-	lower_new_dir_dentry = dget_parent(lower_new_dentry);
-	lock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
-	rc = vfs_rename(lower_old_dir_dentry->d_inode, lower_old_dentry,
-			lower_new_dir_dentry->d_inode, lower_new_dentry);
+	lower_old_dir.mnt = ecryptfs_dentry_to_lower_mnt(old_dentry);
+	lower_old_dir.dentry = dget_parent(lower_old_dentry);
+	lower_new_dir.mnt = ecryptfs_dentry_to_lower_mnt(new_dentry);
+	lower_new_dir.dentry = dget_parent(lower_new_dentry);
+	lock_rename(lower_old_dir.dentry, lower_new_dir.dentry);
+	rc = path_rename(&lower_old_dir, lower_old_dentry,
+			 &lower_new_dir, lower_new_dentry);
 	if (rc)
 		goto out_lock;
-	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode);
+	fsstack_copy_attr_all(new_dir, lower_new_dir.dentry->d_inode);
 	if (new_dir != old_dir)
-		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode);
+		fsstack_copy_attr_all(old_dir, lower_old_dir.dentry->d_inode);
 out_lock:
-	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
+	unlock_rename(lower_old_dir.dentry, lower_new_dir.dentry);
 	dput(lower_new_dentry->d_parent);
 	dput(lower_old_dentry->d_parent);
 	dput(lower_new_dentry);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-video-balcklist-fujitsu-lifebook-s6410.patch
git-x86-fixup.patch
arch-x86-mm-patc-use-boot_cpu_has.patch
x86-setup_force_cpu_cap-dont-do-clear_bitnon-unsigned-long.patch
lguest-use-cpu-capability-accessors.patch
x86-set_restore_sigmask-avoid-bitop-on-a-u32.patch
x86-bitops-take-an-unsigned-long.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
audit_send_reply-fix-error-path-memory-leak.patch
zoran-use-correct-type-for-cpu-flags.patch
i2c-renesas-highlander-fpga-smbus-support.patch
drivers-infiniband-hw-mlx4-qpc-fix-uninitialised-var-warning.patch
git-input.patch
git-jg-misc-git-rejects.patch
drivers-scsi-broadsasc-fix-uninitialised-var-warning.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
mmc-sd-host-driver-for-ricoh-bay1controllers.patch
git-ubifs.patch
sundance-set-carrier-status-on-link-change-events.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
pcnet32-fix-warning.patch
drivers-net-tokenring-3c359c-squish-a-warning.patch
drivers-net-tokenring-olympicc-fix-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
drivers-scsi-qla2xxx-qla_osc-suppress-uninitialized-var-warning.patch
s390-uninline-spinlock-functions-which-use-smp_processor_id.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-logfs-fixup.patch
drivers-uwb-nehc-processor-flags-have-type-unsigned-long.patch
drivers-usb-host-isp1760-hcdc-procesxor-flags-have-type-unsigned-long.patch
uwb-fix-scscanf-warning.patch
drivers-uwb-wlp-sysfsc-dead-code.patch
drivers-uwb-i1480-dfu-macc-fix-min-warning.patch
drivers-uwb-whcic-needs-dma-mappingh.patch
git-vfs-cleanups-reject.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
watchdog-fix-booke_wdtc-on-mpc85xx-smp-system.patch
wireless-fix-iwlwifi-unify-init-driver-flow.patch
wireless-airo-waitbusy-wont-delay-checkpatch-fixes.patch
git-xtensa.patch
git-orion-git-rejects.patch
ibmaem-new-driver-for-power-energy-temp-meters-in-ibm-system-x-hardware-ia64-warnings.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
colibri-fix-support-for-dm9000-ethernet-device.patch
mm-verify-the-page-links-and-memory-model.patch
mspec-convert-nopfn-to-fault-fix.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
kill-generic_file_direct_io-checkpatch-fixes.patch
spufs-use-the-new-vm_ops-access-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm-checkpatch-fixes.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
flag-parameters-inotify_init-fix.patch
flag-parameters-check-magic-constants-alpha-hack.patch
drivers-video-aty-radeon_basec-notify-user-if-sysfs_create_bin_file-failed-checkpatch-fixes.patch
reiserfs-convert-j_flush_sem-to-mutex-fix.patch
reiserfs-convert-j_commit_lock-to-mutex-checkpatch-fixes.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
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

