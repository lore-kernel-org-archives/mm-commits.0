From: akpm@linux-foundation.org
Subject: - git-xfs-fix-git-conflicts.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:10:27 -0800
Message-ID: <200802132010.m1DKARfc011149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48429 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756567AbYBMUKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:10:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dgc@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     git-xfs-fix-git-conflicts
has been removed from the -mm tree.  Its filename was
     git-xfs-fix-git-conflicts.patch

This patch was dropped because it is obsolete

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

softlockup-workaround.patch
include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes.patch
fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch
smack-check-for-struct-socket-with-null-sk-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-net.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-sparc64.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xfs-fix-git-conflicts.patch
git-xtensa.patch
mempolicy-silently-restrict-nodemask-to-allowed-nodes-v3.patch
sunprc-fix-printk-format-warning-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
rename-open_namei-to-open_pathname-vs-git-acpi.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
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
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
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
