From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch added to -mm tree
Date: Fri, 21 Sep 2007 01:02:23 -0700
Message-ID: <200709210802.l8L82N94025730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754240AbXIUICm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 04:02:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, hch@infradead.org


The patch titled
     r/o bind mounts: elevate write count over calls to vfs_rename()
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: elevate write count over calls to vfs_rename()
From: Dave Hansen <haveblue@us.ibm.com>

This also uses the little helper in the NFS code to make an if() a little bit
less ugly.  We introduced the helper at the beginning of the series.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c    |    4 ++++
 fs/nfsd/vfs.c |   15 +++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename
+++ a/fs/namei.c
@@ -2656,8 +2656,12 @@ static int do_rename(int olddfd, const c
 	if (new_dentry == trap)
 		goto exit5;
 
+	error = mnt_want_write(oldnd.mnt);
+	if (error)
+		goto exit5;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
 				   new_dir->d_inode, new_dentry);
+	mnt_drop_write(oldnd.mnt);
 exit5:
 	dput(new_dentry);
 exit4:
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename
+++ a/fs/nfsd/vfs.c
@@ -1669,13 +1669,20 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 	if (ndentry == trap)
 		goto out_dput_new;
 
-#ifdef MSNFS
-	if ((ffhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
+	if (svc_msnfs(ffhp) &&
 		((atomic_read(&odentry->d_count) > 1)
 		 || (atomic_read(&ndentry->d_count) > 1))) {
 			host_err = -EPERM;
-	} else
-#endif
+			goto out_dput_new;
+	}
+
+	host_err = -EXDEV;
+	if (ffhp->fh_export->ex_mnt != tfhp->fh_export->ex_mnt)
+		goto out_dput_new;
+	host_err = mnt_want_write(ffhp->fh_export->ex_mnt);
+	if (host_err)
+		goto out_dput_new;
+
 	host_err = vfs_rename(fdir, odentry, tdir, ndentry);
 	if (!host_err && EX_ISSYNC(tfhp->fh_export)) {
 		host_err = nfsd_sync_dir(tdentry);
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
