From: akpm@linux-foundation.org
Subject: + git-xfs-fix-git-conflicts.patch added to -mm tree
Date: Thu, 07 Feb 2008 23:49:44 -0800
Message-ID: <200802080749.m187nPDD013542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761AbYBHHty (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 02:49:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dgc@sgi.com, tes@sgi.com


The patch titled
     git-xfs-fix-git-conflicts
has been added to the -mm tree.  Its filename is
     git-xfs-fix-git-conflicts.patch

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
Subject: git-xfs-fix-git-conflicts
From: Andrew Morton <akpm@linux-foundation.org>

I think this is right, we'll see...

Cc: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/Makefile-linux-2.6 |  120 ------------------------------------
 1 file changed, 120 deletions(-)

diff -puN fs/xfs/Makefile-linux-2.6~git-xfs-fix-git-conflicts /dev/null
--- a/fs/xfs/Makefile-linux-2.6
+++ /dev/null
@@ -1,120 +0,0 @@
-<<<<<<< HEAD:fs/xfs/Makefile-linux-2.6
-#
-# Copyright (c) 2000-2005 Silicon Graphics, Inc.
-# All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-
-EXTRA_CFLAGS +=	 -Ifs/xfs -Ifs/xfs/linux-2.6 -funsigned-char
-
-XFS_LINUX := linux-2.6
-
-ifeq ($(CONFIG_XFS_DEBUG),y)
-	EXTRA_CFLAGS += -g
-endif
-
-obj-$(CONFIG_XFS_FS)		+= xfs.o
-
-xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix quota/, \
-				   xfs_dquot.o \
-				   xfs_dquot_item.o \
-				   xfs_trans_dquot.o \
-				   xfs_qm_syscalls.o \
-				   xfs_qm_bhv.o \
-				   xfs_qm.o)
-
-ifeq ($(CONFIG_XFS_QUOTA),y)
-xfs-$(CONFIG_PROC_FS)		+= quota/xfs_qm_stats.o
-endif
-
-xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
-xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
-xfs-$(CONFIG_PROC_FS)		+= $(XFS_LINUX)/xfs_stats.o
-xfs-$(CONFIG_SYSCTL)		+= $(XFS_LINUX)/xfs_sysctl.o
-xfs-$(CONFIG_COMPAT)		+= $(XFS_LINUX)/xfs_ioctl32.o
-
-
-xfs-y				+= xfs_alloc.o \
-				   xfs_alloc_btree.o \
-				   xfs_attr.o \
-				   xfs_attr_leaf.o \
-				   xfs_bit.o \
-				   xfs_bmap.o \
-				   xfs_bmap_btree.o \
-				   xfs_btree.o \
-				   xfs_buf_item.o \
-				   xfs_da_btree.o \
-				   xfs_dir2.o \
-				   xfs_dir2_block.o \
-				   xfs_dir2_data.o \
-				   xfs_dir2_leaf.o \
-				   xfs_dir2_node.o \
-				   xfs_dir2_sf.o \
-				   xfs_error.o \
-				   xfs_extfree_item.o \
-				   xfs_filestream.o \
-				   xfs_fsops.o \
-				   xfs_ialloc.o \
-				   xfs_ialloc_btree.o \
-				   xfs_iget.o \
-				   xfs_inode.o \
-				   xfs_inode_item.o \
-				   xfs_iomap.o \
-				   xfs_itable.o \
-				   xfs_dfrag.o \
-				   xfs_log.o \
-				   xfs_log_recover.o \
-				   xfs_mount.o \
-				   xfs_mru_cache.o \
-				   xfs_rename.o \
-				   xfs_trans.o \
-				   xfs_trans_ail.o \
-				   xfs_trans_buf.o \
-				   xfs_trans_extfree.o \
-				   xfs_trans_inode.o \
-				   xfs_trans_item.o \
-				   xfs_utils.o \
-				   xfs_vfsops.o \
-				   xfs_vnodeops.o \
-				   xfs_rw.o \
-				   xfs_dmops.o \
-				   xfs_qmops.o
-
-xfs-$(CONFIG_XFS_TRACE)		+= xfs_dir2_trace.o
-
-# Objects in linux/
-xfs-y				+= $(addprefix $(XFS_LINUX)/, \
-				   kmem.o \
-				   xfs_aops.o \
-				   xfs_buf.o \
-				   xfs_export.o \
-				   xfs_file.o \
-				   xfs_fs_subr.o \
-				   xfs_globals.o \
-				   xfs_ioctl.o \
-				   xfs_iops.o \
-				   xfs_lrw.o \
-				   xfs_super.o \
-				   xfs_vnode.o)
-
-# Objects in support/
-xfs-y				+= $(addprefix support/, \
-				   debug.o \
-				   uuid.o)
-
-xfs-$(CONFIG_XFS_TRACE)		+= support/ktrace.o
-
-=======
->>>>>>> FETCH_HEAD:fs/xfs/Makefile-linux-2.6
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-avr32-fix-git-conflicts.patch
git-cifs.patch
revert-agk-dm-dm-loop.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
revert-git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
memstick-disable-busted-code.patch
git-mmc.patch
typhoon-section-fix.patch
natsemi-section-fix.patch
bnx2x-section-fix.patch
bnx2c-section-fix.patch
via-velocity-section-fix.patch
starfire-secton-fix.patch
pppol2tp-fix-printk-warnings.patch
drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-fixup.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
x86-mmconf-enable-mcfg-early.patch
git-xfs-fix-git-conflicts.patch
git-xtensa.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
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
