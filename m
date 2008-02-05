From: akpm@linux-foundation.org
Subject: - revert-capabilities-clean-up-file-capability-reading.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:32:55 -0800
Message-ID: <200802052232.m15MWaRK012345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760639AbYBEWnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, casey@schaufler-ca.com, chrisw@sous-sol.org, jmorris@namei.org, morgan@kernel.org, sds@tycho.nsa.gov, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     revert "capabilities: clean up file capability reading"
has been removed from the -mm tree.  Its filename was
     revert-capabilities-clean-up-file-capability-reading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "capabilities: clean up file capability reading"
From: Andrew Morton <akpm@linux-foundation.org>

Revert b68680e4731abbd78863063aaa0dca2a6d8cc723 to make way for "capabilities:
clean up file capability reading".

We want to keep the vfs_cap_data.data[] structure, using two 'data's for
64-bit caps (and later three for 96-bit caps), whereas
b68680e4731abbd78863063aaa0dca2a6d8cc723 had gotten rid of the 'data' struct
made its members inline.

The 64-bit caps patch keeps the stack abuse fix at get_file_caps(), which was
the more important part of that patch.

[akpm@linux-foundation.org: coding-style fixes]
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andrew Morgan <morgan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/capability.h |    6 ++++--
 security/commoncap.c       |   23 ++++++++---------------
 2 files changed, 12 insertions(+), 17 deletions(-)

diff -puN include/linux/capability.h~revert-capabilities-clean-up-file-capability-reading include/linux/capability.h
--- a/include/linux/capability.h~revert-capabilities-clean-up-file-capability-reading
+++ a/include/linux/capability.h
@@ -56,8 +56,10 @@ typedef struct __user_cap_data_struct {
 
 struct vfs_cap_data {
 	__u32 magic_etc;  /* Little endian */
-	__u32 permitted;    /* Little endian */
-	__u32 inheritable;  /* Little endian */
+	struct {
+		__u32 permitted;    /* Little endian */
+		__u32 inheritable;  /* Little endian */
+	} data[1];
 };
 
 #ifdef __KERNEL__
diff -puN security/commoncap.c~revert-capabilities-clean-up-file-capability-reading security/commoncap.c
--- a/security/commoncap.c~revert-capabilities-clean-up-file-capability-reading
+++ a/security/commoncap.c
@@ -197,8 +197,7 @@ int cap_inode_killpriv(struct dentry *de
 	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
 }
 
-static inline int cap_from_disk(struct vfs_cap_data *caps,
-				struct linux_binprm *bprm,
+static inline int cap_from_disk(__le32 *caps, struct linux_binprm *bprm,
 				int size)
 {
 	__u32 magic_etc;
@@ -206,7 +205,7 @@ static inline int cap_from_disk(struct v
 	if (size != XATTR_CAPS_SZ)
 		return -EINVAL;
 
-	magic_etc = le32_to_cpu(caps->magic_etc);
+	magic_etc = le32_to_cpu(caps[0]);
 
 	switch ((magic_etc & VFS_CAP_REVISION_MASK)) {
 	case VFS_CAP_REVISION:
@@ -214,8 +213,8 @@ static inline int cap_from_disk(struct v
 			bprm->cap_effective = true;
 		else
 			bprm->cap_effective = false;
-		bprm->cap_permitted = to_cap_t(le32_to_cpu(caps->permitted));
-		bprm->cap_inheritable = to_cap_t(le32_to_cpu(caps->inheritable));
+		bprm->cap_permitted = to_cap_t(le32_to_cpu(caps[1]));
+		bprm->cap_inheritable = to_cap_t(le32_to_cpu(caps[2]));
 		return 0;
 	default:
 		return -EINVAL;
@@ -227,7 +226,7 @@ static int get_file_caps(struct linux_bi
 {
 	struct dentry *dentry;
 	int rc = 0;
-	struct vfs_cap_data incaps;
+	__le32 v1caps[XATTR_CAPS_SZ];
 	struct inode *inode;
 
 	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
@@ -240,14 +239,8 @@ static int get_file_caps(struct linux_bi
 	if (!inode->i_op || !inode->i_op->getxattr)
 		goto out;
 
-	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, NULL, 0);
-	if (rc > 0) {
-		if (rc == XATTR_CAPS_SZ)
-			rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS,
-						&incaps, XATTR_CAPS_SZ);
-		else
-			rc = -EINVAL;
-	}
+	rc = inode->i_op->getxattr(dentry, XATTR_NAME_CAPS, &v1caps,
+							XATTR_CAPS_SZ);
 	if (rc == -ENODATA || rc == -EOPNOTSUPP) {
 		/* no data, that's ok */
 		rc = 0;
@@ -256,7 +249,7 @@ static int get_file_caps(struct linux_bi
 	if (rc < 0)
 		goto out;
 
-	rc = cap_from_disk(&incaps, bprm, rc);
+	rc = cap_from_disk(v1caps, bprm, rc);
 	if (rc)
 		printk(KERN_NOTICE "%s: cap_from_disk returned %d for %s\n",
 			__FUNCTION__, rc, bprm->filename);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
timerfd-fix-remaining-architectures.patch
deprecate-smbfs-in-favour-of-cifs.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
acpi-backlight-reset-brightness-on-resume.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-cpufreq.patch
revert-agk-dm-dm-loop.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-drm-fix.patch
drm-convert-from-nopage-to-fault.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
revert-git-hrt.patch
i8042-non-x86-build-fix.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
ata-drivers-ata-sata_mvc-needs-dmapoolh.patch
drivers-ide-ide-acpic-fix-uninitialized-var-warning.patch
drivers-ide-legacy-hdc-fix-uninitialized-var-warning.patch
git-md-accel.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
memstick-disable-busted-code.patch
git-mmc.patch
git-mtd.patch
drivers-mtd-maps-physmapc-fix-compile-remove-ifdef.patch
drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-v9fs-fix-git-conflicts.patch
9p-fix-p9_printfcall-export.patch
git-watchdog.patch
git-watchdog-fixup.patch
b43-fix-build-with-config_ssb_pcihost=n.patch
git-ipwireless_cs.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
x86-mmconf-enable-mcfg-early.patch
git-xtensa.patch
git-slub.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
md-change-interate_mddev-to-for_each_mddev-fix.patch
md-change-iterate_rdev-to-rdev_for_each-fix.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext3-fix-lock-inversion-in-direct-io-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
keep-track-of-mnt_writer-state-of-struct-file-fix-warn_on-fix.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file-fix.patch
memcontrol-move-mm_cgroup-to-header-file-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-powerpc-fix.patch
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
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
page-owner-tracking-leak-detector-broken-on-s390.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
