From: akpm@linux-foundation.org
Subject: + use-struct-path-in-struct-svc_export-checkpatch-fixes.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:11:35 -0800
Message-ID: <200711052111.lA5LBaaM019958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbXKEVLo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:11:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bfields@citi.umich.edu, jblunck@suse.de, neilb@suse.de


The patch titled
     use-struct-path-in-struct-svc_export-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     use-struct-path-in-struct-svc_export-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 fs/nfsd/vfs.c               |   10 ++++++----
 include/linux/nfsd/export.h |    2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

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
@@ -46,7 +46,7 @@ static int nfsd_acceptable(void *expv, s
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
@@ -1877,7 +1878,8 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	 */
 	if (!(acc & MAY_LOCAL_ACCESS))
 		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
-			if (exp_rdonly(rqstp, exp) || __mnt_is_readonly(exp->ex_path.mnt))
+			if (exp_rdonly(rqstp, exp) ||
+					__mnt_is_readonly(exp->ex_path.mnt))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
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

origin.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-arm-fixup.patch
revert-gregkh-driver-block-device.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
libata-pata_it821x-improve-handling-of-poorly-compatible-emulations-checkpatch-fixes.patch
ide-arm-hack.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
git-nfsd-fixup.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int-checkpatch-fixes.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-rc-fixes.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
git-block.patch
git-block-fixup.patch
git-block-vs-agk-dm-dm-reorder-struct-io_restrictions.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-watchdog.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
x86-make-i8259_64-more-_32-like-checkpatch-fixes.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes-fix.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
mn10300-suppress-aout-library-support-in-elf-binfmt-if-fix.patch
sync_sb_inodes-propagate-errors.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
