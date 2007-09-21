From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch added to -mm tree
Date: Fri, 21 Sep 2007 01:02:29 -0700
Message-ID: <200709210802.l8L82TrD025745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488AbXIUIIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 04:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, hch@infradead.org


The patch titled
     r/o bind mounts: sys_mknodat(): elevate write count for vfs_mknod/create()
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: sys_mknodat(): elevate write count for vfs_mknod/create()
From: Dave Hansen <haveblue@us.ibm.com>

This takes care of all of the direct callers of vfs_mknod().  Since a few of
these cases also handle normal file creation as well, this also covers some
calls to vfs_create().

So that we don't have to make three mnt_want/drop_write() calls inside of the
switch statement, we move some of its logic outside of the switch.

Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c         |   32 +++++++++++++++++++++-----------
 fs/nfsd/vfs.c      |    4 ++++
 net/unix/af_unix.c |    4 ++++
 3 files changed, 29 insertions(+), 11 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create
+++ a/fs/namei.c
@@ -1971,12 +1971,25 @@ asmlinkage long sys_mknodat(int dfd, con
 	if (error)
 		goto out;
 	dentry = lookup_create(&nd, 0);
-	error = PTR_ERR(dentry);
-
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto out_unlock;
+	}
 	if (!IS_POSIXACL(nd.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	if (!IS_ERR(dentry)) {
-		switch (mode & S_IFMT) {
+	if (S_ISDIR(mode)) {
+		error = -EPERM;
+		goto out_dput;
+	}
+	if (!S_ISREG(mode)  && !S_ISCHR(mode)  && !S_ISBLK(mode) &&
+	    !S_ISFIFO(mode) && !S_ISSOCK(mode) && mode != 0) {
+		error = -EINVAL;
+		goto out_dput;
+	}
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_dput;
+	switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
 			error = vfs_create(nd.dentry->d_inode,dentry,mode,&nd);
 			break;
@@ -1987,14 +2000,11 @@ asmlinkage long sys_mknodat(int dfd, con
 		case S_IFIFO: case S_IFSOCK:
 			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,0);
 			break;
-		case S_IFDIR:
-			error = -EPERM;
-			break;
-		default:
-			error = -EINVAL;
-		}
-		dput(dentry);
 	}
+	mnt_drop_write(nd.mnt);
+out_dput:
+	dput(dentry);
+out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 	path_release(&nd);
 out:
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create
+++ a/fs/nfsd/vfs.c
@@ -1243,7 +1243,11 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	case S_IFBLK:
 	case S_IFIFO:
 	case S_IFSOCK:
+		host_err = mnt_want_write(fhp->fh_export->ex_mnt);
+		if (host_err)
+			break;
 		host_err = vfs_mknod(dirp, dchild, iap->ia_mode, rdev);
+		mnt_drop_write(fhp->fh_export->ex_mnt);
 		break;
 	default:
 	        printk("nfsd: bad file type %o in nfsd_create\n", type);
diff -puN net/unix/af_unix.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create net/unix/af_unix.c
--- a/net/unix/af_unix.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create
+++ a/net/unix/af_unix.c
@@ -846,7 +846,11 @@ static int unix_bind(struct socket *sock
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current->fs->umask);
+		err = mnt_want_write(nd.mnt);
+		if (err)
+			goto out_mknod_dput;
 		err = vfs_mknod(nd.dentry->d_inode, dentry, mode, 0);
+		mnt_drop_write(nd.mnt);
 		if (err)
 			goto out_mknod_dput;
 		mutex_unlock(&nd.dentry->d_inode->i_mutex);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
make-kobject-dynamic-allocation-check-use-kallsyms_lookup.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-rearrange-may_open-to-be-r-o-friendly.patch
r-o-bind-mounts-give-may_open-a-local-mnt-variable.patch
r-o-bind-mounts-create-cleanup-helper-svc_msnfs.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-opend-files.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
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
page-owner-tracking-leak-detector.patch
