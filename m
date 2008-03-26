From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:56 -0700
Message-ID: <200803261840.m2QIeu71028717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757901AbYCZSlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@infradead.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate count for xfs timestamp updates
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: elevate count for xfs timestamp updates
From: Dave Hansen <haveblue@us.ibm.com>

Elevate the write count during the xfs m/ctime updates.

XFS has to do it's own timestamp updates due to an unfortunate VFS design
limitation, so it will have to track writers by itself aswell.

[hch: split out from the touch_atime patch as it's not related to it at all]

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_iops.c |    7 -------
 fs/xfs/linux-2.6/xfs_lrw.c  |    9 ++++++++-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_iops.c~r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates fs/xfs/linux-2.6/xfs_iops.c
--- a/fs/xfs/linux-2.6/xfs_iops.c~r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates
+++ a/fs/xfs/linux-2.6/xfs_iops.c
@@ -155,13 +155,6 @@ xfs_ichgtime_fast(
 	 */
 	ASSERT((flags & XFS_ICHGTIME_ACC) == 0);
 
-	/*
-	 * We're not supposed to change timestamps in readonly-mounted
-	 * filesystems.  Throw it away if anyone asks us.
-	 */
-	if (unlikely(IS_RDONLY(inode)))
-		return;
-
 	if (flags & XFS_ICHGTIME_MOD) {
 		tvp = &inode->i_mtime;
 		ip->i_d.di_mtime.t_sec = (__int32_t)tvp->tv_sec;
diff -puN fs/xfs/linux-2.6/xfs_lrw.c~r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates fs/xfs/linux-2.6/xfs_lrw.c
--- a/fs/xfs/linux-2.6/xfs_lrw.c~r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates
+++ a/fs/xfs/linux-2.6/xfs_lrw.c
@@ -51,6 +51,7 @@
 #include "xfs_vnodeops.h"
 
 #include <linux/capability.h>
+#include <linux/mount.h>
 #include <linux/writeback.h>
 
 
@@ -670,10 +671,16 @@ start:
 	if (new_size > xip->i_size)
 		xip->i_new_size = new_size;
 
-	if (likely(!(ioflags & IO_INVIS))) {
+	/*
+	 * We're not supposed to change timestamps in readonly-mounted
+	 * filesystems.  Throw it away if anyone asks us.
+	 */
+	if (likely(!(ioflags & IO_INVIS) &&
+		   !mnt_want_write(file->f_vfsmnt))) {
 		file_update_time(file);
 		xfs_ichgtime_fast(xip, inode,
 				  XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+		mnt_drop_write(file->f_vfsmnt);
 	}
 
 	/*
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

git-vfs.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

