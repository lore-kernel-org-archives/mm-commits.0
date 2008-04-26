From: akpm@linux-foundation.org
Subject: - git-xfs-fixups.patch removed from -mm tree
Date: Sat, 26 Apr 2008 08:05:44 -0700
Message-ID: <200804261505.m3QF5iKW027532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbYDZPFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 11:05:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dgc@sgi.com, lachlan@sgi.com, tes@sgi.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     git-xfs-fixups
has been removed from the -mm tree.  Its filename was
     git-xfs-fixups.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-xfs-fixups
From: Andrew Morton <akpm@linux-foundation.org>

attempt to repair forthcoming git-vfs vs git-xfs smashup.

Cc: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_ioctl.c |  256 ---------------------------------
 1 file changed, 1 insertion(+), 255 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_ioctl.c~git-xfs-fixups fs/xfs/linux-2.6/xfs_ioctl.c
--- a/fs/xfs/linux-2.6/xfs_ioctl.c~git-xfs-fixups
+++ a/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -1095,260 +1095,6 @@ xfs_ioctl(
 		return xfs_ioc_fsgetxattr(ip, 0, arg);
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattr(ip, 1, arg);
-	case XFS_IOC_GETXFLAGS:
-	case XFS_IOC_SETXFLAGS:
-	case XFS_IOC_FSSETXATTR:
-		return xfs_ioc_xattr(ip, filp, cmd, arg);
-
-	case XFS_IOC_FSSETDM: {
-		struct fsdmidata	dmi;
-
-		if (copy_from_user(&dmi, arg, sizeof(dmi)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_set_dmattrs(ip, dmi.fsd_dmevmask,
-				dmi.fsd_dmstate);
-		return -error;
-	}
-
-	case XFS_IOC_GETBMAP:
-	case XFS_IOC_GETBMAPA:
-		return xfs_ioc_getbmap(ip, ioflags, cmd, arg);
-
-	case XFS_IOC_GETBMAPX:
-		return xfs_ioc_getbmapx(ip, arg);
-
-	case XFS_IOC_FD_TO_HANDLE:
-	case XFS_IOC_PATH_TO_HANDLE:
-	case XFS_IOC_PATH_TO_FSHANDLE:
-		return xfs_find_handle(cmd, arg);
-
-	case XFS_IOC_OPEN_BY_HANDLE:
-		return xfs_open_by_handle(mp, arg, filp, inode);
-
-	case XFS_IOC_FSSETDM_BY_HANDLE:
-		return xfs_fssetdm_by_handle(mp, arg, inode);
-
-	case XFS_IOC_READLINK_BY_HANDLE:
-		return xfs_readlink_by_handle(mp, arg, inode);
-
-	case XFS_IOC_ATTRLIST_BY_HANDLE:
-		return xfs_attrlist_by_handle(mp, arg, inode);
-
-	case XFS_IOC_ATTRMULTI_BY_HANDLE:
-		return xfs_attrmulti_by_handle(mp, arg, filp, inode);
-
-	case XFS_IOC_SWAPEXT: {
-		error = xfs_swapext((struct xfs_swapext __user *)arg);
-		return -error;
-	}
-
-	case XFS_IOC_FSCOUNTS: {
-		xfs_fsop_counts_t out;
-
-		error = xfs_fs_counts(mp, &out);
-		if (error)
-			return -error;
-
-		if (copy_to_user(arg, &out, sizeof(out)))
-			return -XFS_ERROR(EFAULT);
-		return 0;
-	}
-
-	case XFS_IOC_SET_RESBLKS: {
-		xfs_fsop_resblks_t inout;
-		__uint64_t	   in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&inout, arg, sizeof(inout)))
-			return -XFS_ERROR(EFAULT);
-
-		/* input parameter is passed in resblks field of structure */
-		in = inout.resblks;
-		error = xfs_reserve_blocks(mp, &in, &inout);
-		if (error)
-			return -error;
-
-		if (copy_to_user(arg, &inout, sizeof(inout)))
-			return -XFS_ERROR(EFAULT);
-		return 0;
-	}
-
-	case XFS_IOC_GET_RESBLKS: {
-		xfs_fsop_resblks_t out;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		error = xfs_reserve_blocks(mp, NULL, &out);
-		if (error)
-			return -error;
-
-		if (copy_to_user(arg, &out, sizeof(out)))
-			return -XFS_ERROR(EFAULT);
-
-		return 0;
-	}
-
-	case XFS_IOC_FSGROWFSDATA: {
-		xfs_growfs_data_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_growfs_data(mp, &in);
-		return -error;
-	}
-
-	case XFS_IOC_FSGROWFSLOG: {
-		xfs_growfs_log_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_growfs_log(mp, &in);
-		return -error;
-	}
-
-	case XFS_IOC_FSGROWFSRT: {
-		xfs_growfs_rt_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_growfs_rt(mp, &in);
-		return -error;
-	}
-
-	case XFS_IOC_FREEZE:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (inode->i_sb->s_frozen == SB_UNFROZEN)
-			freeze_bdev(inode->i_sb->s_bdev);
-		return 0;
-
-	case XFS_IOC_THAW:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-		if (inode->i_sb->s_frozen != SB_UNFROZEN)
-			thaw_bdev(inode->i_sb->s_bdev, inode->i_sb);
-		return 0;
-
-	case XFS_IOC_GOINGDOWN: {
-		__uint32_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (get_user(in, (__uint32_t __user *)arg))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_fs_goingdown(mp, in);
-		return -error;
-	}
-
-	case XFS_IOC_ERROR_INJECTION: {
-		xfs_error_injection_t in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
-
-		error = xfs_errortag_add(in.errtag, mp);
-		return -error;
-	}
-
-	case XFS_IOC_ERROR_CLEARALL:
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		error = xfs_errortag_clearall(mp, 1);
-		return -error;
-
-	default:
-		return -ENOTTY;
-	}
-}
-
-int
-xfs_ioctl(
-	xfs_inode_t		*ip,
-	struct file		*filp,
-	int			ioflags,
-	unsigned int		cmd,
-	void			__user *arg)
-{
-	struct inode		*inode = filp->f_path.dentry->d_inode;
-	xfs_mount_t		*mp = ip->i_mount;
-	int			error;
-
-	xfs_itrace_entry(XFS_I(inode));
-	switch (cmd) {
-
-	case XFS_IOC_ALLOCSP:
-	case XFS_IOC_FREESP:
-	case XFS_IOC_RESVSP:
-	case XFS_IOC_UNRESVSP:
-	case XFS_IOC_ALLOCSP64:
-	case XFS_IOC_FREESP64:
-	case XFS_IOC_RESVSP64:
-	case XFS_IOC_UNRESVSP64:
-		/*
-		 * Only allow the sys admin to reserve space unless
-		 * unwritten extents are enabled.
-		 */
-		if (!xfs_sb_version_hasextflgbit(&mp->m_sb) &&
-		    !capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, arg);
-
-	case XFS_IOC_DIOINFO: {
-		struct dioattr	da;
-		xfs_buftarg_t	*target =
-			XFS_IS_REALTIME_INODE(ip) ?
-			mp->m_rtdev_targp : mp->m_ddev_targp;
-
-		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
-		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
-
-		if (copy_to_user(arg, &da, sizeof(da)))
-			return -XFS_ERROR(EFAULT);
-		return 0;
-	}
-
-	case XFS_IOC_FSBULKSTAT_SINGLE:
-	case XFS_IOC_FSBULKSTAT:
-	case XFS_IOC_FSINUMBERS:
-		return xfs_ioc_bulkstat(mp, cmd, arg);
-
-	case XFS_IOC_FSGEOMETRY_V1:
-		return xfs_ioc_fsgeometry_v1(mp, arg);
-
-	case XFS_IOC_FSGEOMETRY:
-		return xfs_ioc_fsgeometry(mp, arg);
-
-	case XFS_IOC_GETVERSION:
-		return put_user(inode->i_generation, (int __user *)arg);
-
-	case XFS_IOC_FSGETXATTR:
-		return xfs_ioc_fsgetxattr(ip, 0, arg);
-	case XFS_IOC_FSGETXATTRA:
-		return xfs_ioc_fsgetxattr(ip, 1, arg);
 	case XFS_IOC_FSSETXATTR:
 		return xfs_ioc_fssetxattr(ip, filp, arg);
 	case XFS_IOC_GETXFLAGS:
@@ -1392,7 +1138,7 @@ xfs_ioctl(
 		return xfs_attrlist_by_handle(mp, arg, inode);
 
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
-		return xfs_attrmulti_by_handle(mp, arg, inode);
+		return xfs_attrmulti_by_handle(mp, arg, filp, inode);
 
 	case XFS_IOC_SWAPEXT: {
 		error = xfs_swapext((struct xfs_swapext __user *)arg);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hotplug-memory-make-online_page-common-fix.patch
disable-the-memory-controller-by-default-v3-fix.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
x86-ptrace-pebs-support-warning-fix.patch
git-agpgart.patch
cifs-suppress-warning.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
git-hrt.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
git-sched.patch
add-rcu_assign_index-if-ever-needed.patch
scsi-fix-platform-driver-hotplug-coldplug.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs-vs-git-kvm.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
git-xfs-fixups.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-misplaced-hunk.patch
git-cryptodev-fix-conflict.patch
git-cryptodev-fix-conflict-hack.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore-git-rejects.patch
ext4-is-busted-on-m68k.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
ecryptfs-make-key-module-subsystem-respect-namespaces-fix-refs-to-pid-and-user_ns-fix.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
drivers-video-uvesafbc-fix-error-path-memory-leak.patch
fb-convert-proc-fb-to-seq_file-interface-checkpatch-fixes.patch
drivers-video-w100fbc-avoid-a-couple-of-error-path-null-derefs.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix.patch
x86-olpc-add-one-laptop-per-child-architecture-support-fix-2.patch
drivers-md-use-time_before-time_before_eq-etc-checkpatch-fixes.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
ext2-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
ext3-retry-block-allocation-if-new-blocks-are-allocated-from-system-zone-comment-typo.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
use-vmalloc-for-mem_cgroup-allocation-v3-simplification.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipc-sysvsem-refuse-cloneclone_sysvsemclone_newipc-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
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
profile-likely-unlikely-macros-fix.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

