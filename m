From: akpm@linux-foundation.org
Subject: - use-struct-path-in-struct-svc_export-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 14 Feb 2008 15:27:06 -0800
Message-ID: <200802142327.m1ENR6DQ008551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757933AbYBNX1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 18:27:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bfields@citi.umich.edu, jblunck@suse.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     use-struct-path-in-struct-svc_export-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     use-struct-path-in-struct-svc_export-checkpatch-fixes.patch

This patch was dropped because it was folded into use-struct-path-in-struct-svc_export.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: use-struct-path-in-struct-svc_export-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#81: FILE: fs/nfsd/export.c:630:
+ ^Ikfree(exp.ex_pathname);$

WARNING: kfree(NULL) is safe this check is probabally not required
#214: FILE: fs/nfsd/export.c:1092:
+	if (new.ex_pathname)
+		kfree(new.ex_pathname);

ERROR: no space after that '!' (ctx:WxW)
#326: FILE: fs/nfsd/nfsfh.c:49:
+	while (tdentry != exp->ex_path.dentry && ! IS_ROOT(tdentry)) {
 	                                         ^

WARNING: line over 80 characters
#370: FILE: fs/nfsd/nfsfh.c:338:
+	int root_export = (exp->ex_path.dentry == exp->ex_path.dentry->d_sb->s_root);

WARNING: line over 80 characters
#384: FILE: fs/nfsd/nfsfh.c:384:
+			if (!(exp->ex_path.dentry->d_inode->i_sb->s_type->fs_flags

WARNING: line over 80 characters
#411: FILE: fs/nfsd/nfsfh.c:564:
+		if (fhp->fh_export->ex_path.dentry->d_inode->i_sb->s_type->fs_flags

WARNING: braces {} are not necessary for single statement blocks
#474: FILE: fs/nfsd/vfs.c:159:
+		else if (dparent != exp->ex_path.dentry) {
 			dentry = dget_parent(dparent);
 		} else  if (!EX_NOHIDE(exp))

WARNING: line over 80 characters
#492: FILE: fs/nfsd/vfs.c:724:
+	*filp = dentry_open(dget(dentry), mntget(fhp->fh_export->ex_path.mnt), flags);

WARNING: line over 80 characters
#545: FILE: fs/nfsd/vfs.c:1880:
+			if (exp_rdonly(rqstp, exp) || __mnt_is_readonly(exp->ex_path.mnt))

ERROR: "foo * bar" should be "foo *bar"
#560: FILE: include/linux/nfsd/export.h:88:
+	char *			ex_pathname;

total: 3 errors, 7 warnings, 459 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Jan Blunck <jblunck@suse.de>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c            |    5 ++---
 fs/nfsd/nfsfh.c             |    2 +-
 fs/nfsd/vfs.c               |    7 ++++---
 include/linux/nfsd/export.h |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/nfsd/export.c~use-struct-path-in-struct-svc_export-checkpatch-fixes fs/nfsd/export.c
--- a/fs/nfsd/export.c~use-struct-path-in-struct-svc_export-checkpatch-fixes
+++ a/fs/nfsd/export.c
@@ -627,7 +627,7 @@ static int svc_export_parse(struct cache
  out:
 	nfsd4_fslocs_free(&exp.ex_fslocs);
 	kfree(exp.ex_uuid);
- 	kfree(exp.ex_pathname);
+	kfree(exp.ex_pathname);
 	if (nd.path.dentry)
 		path_put(&nd.path);
  out_no_path:
@@ -1088,8 +1088,7 @@ exp_export(struct nfsctl_export *nxp)
 	} else
 		err = 0;
 finish:
-	if (new.ex_pathname)
-		kfree(new.ex_pathname);
+	kfree(new.ex_pathname);
 	if (exp)
 		exp_put(exp);
 	if (fsid_key && !IS_ERR(fsid_key))
diff -puN fs/nfsd/nfsfh.c~use-struct-path-in-struct-svc_export-checkpatch-fixes fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~use-struct-path-in-struct-svc_export-checkpatch-fixes
+++ a/fs/nfsd/nfsfh.c
@@ -47,7 +47,7 @@ static int nfsd_acceptable(void *expv, s
 		return 1;
 
 	tdentry = dget(dentry);
-	while (tdentry != exp->ex_path.dentry && ! IS_ROOT(tdentry)) {
+	while (tdentry != exp->ex_path.dentry && !IS_ROOT(tdentry)) {
 		/* make sure parents give x permission to user */
 		int err;
 		parent = dget_parent(tdentry);
diff -puN fs/nfsd/vfs.c~use-struct-path-in-struct-svc_export-checkpatch-fixes fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~use-struct-path-in-struct-svc_export-checkpatch-fixes
+++ a/fs/nfsd/vfs.c
@@ -156,9 +156,9 @@ nfsd_lookup_dentry(struct svc_rqst *rqst
 	if (isdotent(name, len)) {
 		if (len==1)
 			dentry = dget(dparent);
-		else if (dparent != exp->ex_path.dentry) {
+		else if (dparent != exp->ex_path.dentry)
 			dentry = dget_parent(dparent);
-		} else  if (!EX_NOHIDE(exp))
+		else if (!EX_NOHIDE(exp))
 			dentry = dget(dparent); /* .. == . just like at / */
 		else {
 			/* checking mountpoint crossing is very different when stepping up */
@@ -721,7 +721,8 @@ nfsd_open(struct svc_rqst *rqstp, struct
 
 		DQUOT_INIT(inode);
 	}
-	*filp = dentry_open(dget(dentry), mntget(fhp->fh_export->ex_path.mnt), flags);
+	*filp = dentry_open(dget(dentry), mntget(fhp->fh_export->ex_path.mnt),
+				flags);
 	if (IS_ERR(*filp))
 		host_err = PTR_ERR(*filp);
 out_nfserr:
diff -puN include/linux/nfsd/export.h~use-struct-path-in-struct-svc_export-checkpatch-fixes include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~use-struct-path-in-struct-svc_export-checkpatch-fixes
+++ a/include/linux/nfsd/export.h
@@ -85,7 +85,7 @@ struct svc_export {
 	struct auth_domain *	ex_client;
 	int			ex_flags;
 	struct path		ex_path;
-	char *			ex_pathname;
+	char			*ex_pathname;
 	uid_t			ex_anon_uid;
 	gid_t			ex_anon_gid;
 	int			ex_fsid;
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
introduce-path_put.patch
one-less-parameter-to-__d_path.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path.patch
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
