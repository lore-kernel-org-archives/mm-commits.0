From: akpm@linux-foundation.org
Subject: - embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch removed from -mm tree
Date: Thu, 14 Feb 2008 15:22:32 -0800
Message-ID: <200802142322.m1ENMWxr008347__28307.3255712681$1203031480$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36460 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757044AbYBNXXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 18:23:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agruen@suse.de, hch@lst.de, jblunck@suse.de, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix
has been removed from the -mm tree.  Its filename was
     embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch

This patch was dropped because it was folded into embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: <linux-fsdevel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Blunck <jblunck@suse.de>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifs_dfs_ref.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN fs/cifs/cifs_dfs_ref.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix fs/cifs/cifs_dfs_ref.c
--- a/fs/cifs/cifs_dfs_ref.c~embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix
+++ a/fs/cifs/cifs_dfs_ref.c
@@ -259,18 +259,18 @@ static int add_mount_helper(struct vfsmo
 	int err;
 
 	mntget(newmnt);
-	err = do_add_mount(newmnt, nd, nd->mnt->mnt_flags, mntlist);
+	err = do_add_mount(newmnt, nd, nd->path.mnt->mnt_flags, mntlist);
 	switch (err) {
 	case 0:
-		dput(nd->dentry);
-		mntput(nd->mnt);
-		nd->mnt = newmnt;
-		nd->dentry = dget(newmnt->mnt_root);
+		dput(nd->path.dentry);
+		mntput(nd->path.mnt);
+		nd->path.mnt = newmnt;
+		nd->path.dentry = dget(newmnt->mnt_root);
 		break;
 	case -EBUSY:
 		/* someone else made a mount here whilst we were busy */
-		while (d_mountpoint(nd->dentry) &&
-		       follow_down(&nd->mnt, &nd->dentry))
+		while (d_mountpoint(nd->path.dentry) &&
+		       follow_down(&nd->path.mnt, &nd->path.dentry))
 			;
 		err = 0;
 	default:
@@ -307,8 +307,8 @@ cifs_dfs_follow_mountpoint(struct dentry
 
 	xid = GetXid();
 
-	dput(nd->dentry);
-	nd->dentry = dget(dentry);
+	dput(nd->path.dentry);
+	nd->path.dentry = dget(dentry);
 
 	cifs_sb = CIFS_SB(dentry->d_inode->i_sb);
 	ses = cifs_sb->tcon->ses;
@@ -340,7 +340,8 @@ cifs_dfs_follow_mountpoint(struct dentry
 				rc = -EINVAL;
 				goto out_err;
 			}
-			mnt = cifs_dfs_do_refmount(nd->mnt, nd->dentry,
+			mnt = cifs_dfs_do_refmount(nd->path.mnt,
+						nd->path.dentry,
 						referrals[i].node_name);
 			cFYI(1, ("%s: cifs_dfs_do_refmount:%s , mnt:%p",
 					 __FUNCTION__,
@@ -357,7 +358,7 @@ cifs_dfs_follow_mountpoint(struct dentry
 	if (IS_ERR(mnt))
 		goto out_err;
 
-	nd->mnt->mnt_flags |= MNT_SHRINKABLE;
+	nd->path.mnt->mnt_flags |= MNT_SHRINKABLE;
 	rc = add_mount_helper(mnt, nd, &cifs_dfs_automount_list);
 
 out:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

softlockup-workaround.patch
include-linux-remove-all-users-of-fastcall-macro.patch
fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch
smack-check-for-struct-socket-with-null-sk.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-dvb.patch
git-dvb-someone-broke-the-gpio-includes.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
fix-ide-mm-ide-remove-broken-dangerous-ide-unregister-scan-hwif-ioctls.patch
git-net.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-rc-fixes.patch
scsi-fix-data-corruption-caused-by-ses-checkpatch-fixes.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-conflicts.patch
git-sparc64.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-git-conflicts.patch
git-x86.patch
git-x86-vs-git-kvm.patch
git-x86-cpa-build-fix.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xfs-git-conflicts.patch
git-xtensa.patch
add-rcu_assign_index-if-ever-needed-fix.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
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
