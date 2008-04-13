From: akpm@linux-foundation.org
Subject: + git-xfs-git-rejects.patch added to -mm tree
Date: Sat, 12 Apr 2008 19:35:09 -0700
Message-ID: <200804130235.m3D2Z9Df032223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbYDMCfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:35:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dgc@sgi.com, lachlan@sgi.com, tes@sgi.com


The patch titled
     git-xfs-git-rejects
has been added to the -mm tree.  Its filename is
     git-xfs-git-rejects.patch

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
Subject: git-xfs-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/quota/xfs_qm_syscalls.c |    4 ----
 fs/xfs/xfs_ialloc.c            |   11 +----------
 fs/xfs/xfs_mount.c             |   13 -------------
 3 files changed, 1 insertion(+), 27 deletions(-)

diff -puN fs/xfs/quota/xfs_qm_syscalls.c~git-xfs-git-rejects fs/xfs/quota/xfs_qm_syscalls.c
--- a/fs/xfs/quota/xfs_qm_syscalls.c~git-xfs-git-rejects
+++ a/fs/xfs/quota/xfs_qm_syscalls.c
@@ -385,10 +385,6 @@ xfs_qm_scall_trunc_qfiles(
 
 	if (!capable(CAP_SYS_ADMIN))
 		return XFS_ERROR(EPERM);
-<<<<<<< HEAD:fs/xfs/quota/xfs_qm_syscalls.c
-	error = 0;
-=======
->>>>>>> FETCH_HEAD:fs/xfs/quota/xfs_qm_syscalls.c
 	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0) {
 		qdprintk("qtrunc flags=%x m_qflags=%x\n", flags, mp->m_qflags);
 		return XFS_ERROR(EINVAL);
diff -puN fs/xfs/xfs_ialloc.c~git-xfs-git-rejects fs/xfs/xfs_ialloc.c
--- a/fs/xfs/xfs_ialloc.c~git-xfs-git-rejects
+++ a/fs/xfs/xfs_ialloc.c
@@ -215,18 +215,13 @@ xfs_ialloc_ag_alloc(
 			ASSERT(!(args.mp->m_flags & XFS_MOUNT_NOALIGN));
 			args.alignment = args.mp->m_dalign;
 			isaligned = 1;
-<<<<<<< HEAD:fs/xfs/xfs_ialloc.c
 		} else if (xfs_sb_version_hasalign(&args.mp->m_sb) &&
 			   args.mp->m_sb.sb_inoalignmt >=
 			   XFS_B_TO_FSBT(args.mp,
 			  	XFS_INODE_CLUSTER_SIZE(args.mp)))
 				args.alignment = args.mp->m_sb.sb_inoalignmt;
 		else
-			args.alignment = 1;
-=======
-		} else
 			args.alignment = xfs_ialloc_cluster_alignment(&args);
->>>>>>> FETCH_HEAD:fs/xfs/xfs_ialloc.c
 		/*
 		 * Need to figure out where to allocate the inode blocks.
 		 * Ideally they should be spaced out through the a.g.
@@ -259,16 +254,12 @@ xfs_ialloc_ag_alloc(
 		args.agbno = be32_to_cpu(agi->agi_root);
 		args.fsbno = XFS_AGB_TO_FSB(args.mp,
 				be32_to_cpu(agi->agi_seqno), args.agbno);
-<<<<<<< HEAD:fs/xfs/xfs_ialloc.c
 		if (xfs_sb_version_hasalign(&args.mp->m_sb) &&
 			args.mp->m_sb.sb_inoalignmt >=
 			XFS_B_TO_FSBT(args.mp, XFS_INODE_CLUSTER_SIZE(args.mp)))
 				args.alignment = args.mp->m_sb.sb_inoalignmt;
 		else
-			args.alignment = 1;
-=======
-		args.alignment = xfs_ialloc_cluster_alignment(&args);
->>>>>>> FETCH_HEAD:fs/xfs/xfs_ialloc.c
+			args.alignment = xfs_ialloc_cluster_alignment(&args);
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
 	}
diff -puN fs/xfs/xfs_mount.c~git-xfs-git-rejects fs/xfs/xfs_mount.c
--- a/fs/xfs/xfs_mount.c~git-xfs-git-rejects
+++ a/fs/xfs/xfs_mount.c
@@ -45,11 +45,7 @@
 #include "xfs_fsops.h"
 #include "xfs_utils.h"
 
-<<<<<<< HEAD:fs/xfs/xfs_mount.c
-STATIC void	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
-=======
 STATIC int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
->>>>>>> FETCH_HEAD:fs/xfs/xfs_mount.c
 STATIC int	xfs_uuid_mount(xfs_mount_t *);
 STATIC void	xfs_uuid_unmount(xfs_mount_t *mp);
 STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
@@ -1193,10 +1189,6 @@ xfs_mountfs(
 	/*
 	 * If fs is not mounted readonly, then update the superblock changes.
 	 */
-<<<<<<< HEAD:fs/xfs/xfs_mount.c
-	if (update_flags && !(mp->m_flags & XFS_MOUNT_RDONLY))
-		xfs_mount_log_sb(mp, update_flags);
-=======
 	if (update_flags && !(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		error = xfs_mount_log_sb(mp, update_flags);
 		if (error) {
@@ -1204,7 +1196,6 @@ xfs_mountfs(
 			goto error4;
 		}
 	}
->>>>>>> FETCH_HEAD:fs/xfs/xfs_mount.c
 
 	/*
 	 * Initialise the XFS quota management subsystem for this mount
@@ -1927,11 +1918,7 @@ xfs_uuid_unmount(
  * be altered by the mount options, as well as any potential sb_features2
  * fixup. Only the first superblock is updated.
  */
-<<<<<<< HEAD:fs/xfs/xfs_mount.c
-STATIC void
-=======
 STATIC int
->>>>>>> FETCH_HEAD:fs/xfs/xfs_mount.c
 xfs_mount_log_sb(
 	xfs_mount_t	*mp,
 	__int64_t	fields)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-set-relay-file-can-not-be-read-by-pread2.patch
git-acpi.patch
git-acpi-revert-suspend-wakeup-code-in-c.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86.patch
arch-x86-mm-ioremapc-fix-printk-warnings.patch
git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
git-kgdb-light.patch
git-x86-hack-around-to-make-git-kgdb-build.patch
git-x86-vs-git-kgdb-lite.patch
git-alsa-tiwai.patch
es1968-fix-jitter-on-some-maestro-cards-checkpatch-fixes.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
cifs-suppress-warning.patch
git-powerpc.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3-fix.patch
git-drm.patch
revert-git-drm.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-dlm-vs-git-gfs2-nwm.patch
git-hid.patch
git-hrt.patch
time-close-small-window-for-vsyscall-time-inconsistencies-checkpatch-fixes.patch
git-ia64.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
gregkh-driver-ib-convert-struct-class_device-to-struct-device-vs-git-infiniband.patch
maple-add-driver-for-sega-dreamcast-controller.patch
touch-screen-driver-for-the-superh-migor-board-checkpatch-fixes.patch
git-leds.patch
git-libata-all.patch
pata_atiixp-simplex-clear-fix.patch
git-async-tx.patch
git-mips.patch
git-net.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
ehea-fix-dlpar-memory-add-support-fix.patch
sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
pci-hotplug-introduce-pci_slot-fix.patch
pci-hotplug-introduce-pci_slot-fix-fix.patch
pci-hotplug-introduce-pci_slot-fix-2.patch
pci-hotplug-introduce-pci_slot-fix-99.patch
pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch
git-s390.patch
git-sched.patch
git-sh.patch
sh-arch-sh-kernel-traps_32c-needs-asm-fpuh.patch
sh-export-empty_zero_page.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-fix-section-mismatch-in-aic94xx.patch
aacraid-fix-unchecked-down_interruptible.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
git-xfs-git-rejects.patch
git-xfs-fixup.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-misplaced-hunk.patch
git-cryptodev-fix-conflict.patch
git-cryptodev-fix-conflict-hack.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore-git-rejects.patch
ext4-is-busted-on-m68k.patch
smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch
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
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
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
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
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
w1-build-fix.patch

