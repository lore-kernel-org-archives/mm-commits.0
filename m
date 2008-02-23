From: akpm@linux-foundation.org
Subject: - embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:50 -0800
Message-ID: <200802232022.m1NKMoSj013458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760897AbYBWU2e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ezk@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs
has been removed from the -mm tree.  Its filename was
     embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/inode.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/unionfs/inode.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs fs/unionfs/inode.c
--- a/fs/unionfs/inode.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs
+++ a/fs/unionfs/inode.c
@@ -255,8 +255,8 @@ static struct dentry *unionfs_lookup(str
 
 	/* save the dentry & vfsmnt from namei */
 	if (nd) {
-		path_save.dentry = nd->dentry;
-		path_save.mnt = nd->mnt;
+		path_save.dentry = nd->path.dentry;
+		path_save.mnt = nd->path.mnt;
 	}
 
 	/*
@@ -267,8 +267,8 @@ static struct dentry *unionfs_lookup(str
 
 	/* restore the dentry & vfsmnt in namei */
 	if (nd) {
-		nd->dentry = path_save.dentry;
-		nd->mnt = path_save.mnt;
+		nd->path.dentry = path_save.dentry;
+		nd->path.mnt = path_save.mnt;
 	}
 	if (!IS_ERR(ret)) {
 		if (ret)
@@ -861,7 +861,7 @@ static int unionfs_permission(struct ino
 	const int write_mask = (mask & MAY_WRITE) && !(mask & MAY_READ);
 
 	if (nd)
-		unionfs_lock_dentry(nd->dentry, UNIONFS_DMUTEX_CHILD);
+		unionfs_lock_dentry(nd->path.dentry, UNIONFS_DMUTEX_CHILD);
 
 	if (!UNIONFS_I(inode)->lower_inodes) {
 		if (is_file)	/* dirs can be unlinked but chdir'ed to */
@@ -936,7 +936,7 @@ out:
 	unionfs_check_inode(inode);
 	unionfs_check_nd(nd);
 	if (nd)
-		unionfs_unlock_dentry(nd->dentry);
+		unionfs_unlock_dentry(nd->path.dentry);
 	return err;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-dvb-someone-broke-the-gpio-includes.patch
git-hwmon.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-sched.patch
tracing-is-borked-on-powerpc.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-x86.patch
git-x86-fixup.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
procfs-task-exe-symlink-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
