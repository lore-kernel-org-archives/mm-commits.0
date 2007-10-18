From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-give-permission-a-local-mnt-variable.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:07 -0700
Message-ID: <200710180704.l9I7475A031503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50265 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714AbXJRHZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: give permission() a local 'mnt' variable
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-give-permission-a-local-mnt-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: r/o bind mounts: give permission() a local 'mnt' variable
From: Dave Hansen <haveblue@us.ibm.com>

First of all, this makes the structure jumping look a little bit cleaner.  So,
this stands alone as a tiny cleanup.  But, we also need 'mnt' by itself a few
more times later in this series, so this isn't _just_ a cleanup.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~r-o-bind-mounts-give-permission-a-local-mnt-variable fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-give-permission-a-local-mnt-variable
+++ a/fs/namei.c
@@ -228,6 +228,10 @@ int generic_permission(struct inode *ino
 int permission(struct inode *inode, int mask, struct nameidata *nd)
 {
 	int retval, submask;
+	struct vfsmount *mnt = NULL;
+
+	if (nd)
+		mnt = nd->mnt;
 
 	if (mask & MAY_WRITE) {
 		umode_t mode = inode->i_mode;
@@ -251,7 +255,7 @@ int permission(struct inode *inode, int 
 		 * MAY_EXEC on regular files is denied if the fs is mounted
 		 * with the "noexec" flag.
 		 */
-		if (nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))
+		if (mnt && (mnt->mnt_flags & MNT_NOEXEC))
 			return -EACCES;
 	}
 
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
