From: akpm@linux-foundation.org
Subject: - ext2-reservations-fix-for-r-o-bind-mounts-take-writer-count-v2.patch removed from -mm tree
Date: Mon, 05 Nov 2007 15:06:51 -0800
Message-ID: <200711052306.lA5N6p9R024300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324AbXKEXHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:07:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ext2 reservations: fix for r/o bind mounts: take-writer-count (v2)
has been removed from the -mm tree.  Its filename was
     ext2-reservations-fix-for-r-o-bind-mounts-take-writer-count-v2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ext2 reservations: fix for r/o bind mounts: take-writer-count (v2)
From: Dave Hansen <haveblue@us.ibm.com>

This is on top of the ext2-reservations.patch in -mm.

The original r/o bind mount set didn't address the new
ext2 ioctl: EXT2_IOC_SETRSVSZ, because it doesn't exist
in mainline.  This fixes that up for -mm.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ioctl.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff -puN fs/ext2/ioctl.c~ext2-reservations-fix-for-r-o-bind-mounts-take-writer-count-v2 fs/ext2/ioctl.c
--- a/fs/ext2/ioctl.c~ext2-reservations-fix-for-r-o-bind-mounts-take-writer-count-v2
+++ a/fs/ext2/ioctl.c
@@ -111,14 +111,18 @@ setflags_out:
 		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
 			return -ENOTTY;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
-			return -EACCES;
-
-		if (get_user(rsv_window_size, (int __user *)arg))
-			return -EFAULT;
+		ret = mnt_want_write(filp->f_vfsmnt);
+		if (ret)
+			return ret;
+
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
+			ret = -EACCES;
+			goto setrsvsz_out;
+		}
+		if (get_user(rsv_window_size, (int __user *)arg)) {
+			ret = -EFAULT;
+			goto setrsvsz_out;
+		}
 
 		if (rsv_window_size > EXT2_MAX_RESERVE_BLOCKS)
 			rsv_window_size = EXT2_MAX_RESERVE_BLOCKS;
@@ -140,7 +144,9 @@ setflags_out:
 			rsv->rsv_goal_size = rsv_window_size;
 		}
 		mutex_unlock(&ei->truncate_mutex);
-		return 0;
+	setrsvsz_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return ret;
 	}
 	default:
 		return -ENOTTY;
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

markers-fix-warnings.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpageflags-interface.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
hugetlb-fix-quota-management-for-private-mappings.patch
hugetlb-debit-quota-in-alloc_huge_page.patch
hugetlb-allow-bulk-updating-in-hugetlb__quota.patch
hugetlb-enforce-quotas-during-reservation-for-shared-mappings.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
ext2-reservations-fix-for-r-o-bind-mounts-take-writer-count-v2.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
