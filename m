From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:05 -0700
Message-ID: <200710180704.l9I745GQ031500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759327AbXJRHbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:31:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: rearrange may_open() to be r/o friendly
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: r/o bind mounts: rearrange may_open() to be r/o friendly
From: Dave Hansen <haveblue@us.ibm.com>

may_open() calls vfs_permission() before it does checks for IS_RDONLY(inode). 
It checks _again_ inside of vfs_permission().

The check inside of vfs_permission() is going away eventually.  With the
mnt_want/drop_write() functions, all of the r/o checks (except for this one)
are consistently done before calling permission().  Because of this, I'd like
to use permission() to hold a debugging check to make sure that the
mnt_want/drop_write() calls are actually being made.

So, to do this:
1. remove the IS_RDONLY() check from permission()
2. enforce that you must mnt_want_write() before
   even calling permission()
3. actually add the debugging check to permission()

We need to rearrange may_open() to do r/o checks before calling permission(). 
Here's the patch.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly
+++ a/fs/namei.c
@@ -1604,10 +1604,6 @@ int may_open(struct nameidata *nd, int a
 	if (S_ISDIR(inode->i_mode) && (flag & FMODE_WRITE))
 		return -EISDIR;
 
-	error = vfs_permission(nd, acc_mode);
-	if (error)
-		return error;
-
 	/*
 	 * FIFO's, sockets and device files are special: they don't
 	 * actually live on the filesystem itself, and as such you
@@ -1622,6 +1618,10 @@ int may_open(struct nameidata *nd, int a
 		flag &= ~O_TRUNC;
 	} else if (IS_RDONLY(inode) && (flag & FMODE_WRITE))
 		return -EROFS;
+
+	error = vfs_permission(nd, acc_mode);
+	if (error)
+		return error;
 	/*
 	 * An append-only file must be opened in append mode for writing.
 	 */
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

origin.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-opend-files.patch
r-o-bind-mounts-elevate-write-count-opend-files-r-o-bind-mounts-fix-bug-in-reiserfs_delete_xattrs.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
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
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
reiser4-fix-null-dereference-in-__mnt_is_readonly-in-ftruncate.patch
page-owner-tracking-leak-detector.patch
