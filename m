From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:48:57 -0800
Message-ID: <200802152248.m1FMmv0R028151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34008 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765730AbYBOWtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:49:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, akpm@linux-foundation.org, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     r/o bind mounts: elevate write count for xattr_permission() callers
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch

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
Subject: r/o bind mounts: elevate write count for xattr_permission() callers
From: Dave Hansen <haveblue@us.ibm.com>

This basically audits the callers of xattr_permission(), which calls
permission() and can perform writes to the filesystem.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4proc.c |    7 ++++++-
 fs/xattr.c         |   16 ++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/nfs4proc.c~r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers
+++ a/fs/nfsd/nfs4proc.c
@@ -658,14 +658,19 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 			return status;
 		}
 	}
+	status = mnt_want_write(cstate->current_fh.fh_export->ex_mnt);
+	if (status)
+		return status;
 	status = nfs_ok;
 	if (setattr->sa_acl != NULL)
 		status = nfsd4_set_nfs4_acl(rqstp, &cstate->current_fh,
 					    setattr->sa_acl);
 	if (status)
-		return status;
+		goto out;
 	status = nfsd_setattr(rqstp, &cstate->current_fh, &setattr->sa_iattr,
 				0, (time_t)0);
+out:
+	mnt_drop_write(cstate->current_fh.fh_export->ex_mnt);
 	return status;
 }
 
diff -puN fs/xattr.c~r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers fs/xattr.c
--- a/fs/xattr.c~r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers
+++ a/fs/xattr.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/xattr.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
@@ -32,8 +33,6 @@ xattr_permission(struct inode *inode, co
 	 * filesystem  or on an immutable / append-only inode.
 	 */
 	if (mask & MAY_WRITE) {
-		if (IS_RDONLY(inode))
-			return -EROFS;
 		if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 			return -EPERM;
 	}
@@ -262,7 +261,11 @@ sys_setxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		return error;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
+	mnt_drop_write(nd.path.mnt);
 	path_put(&nd.path);
 	return error;
 }
@@ -277,7 +280,11 @@ sys_lsetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		return error;
 	error = setxattr(nd.path.dentry, name, value, size, flags);
+	mnt_drop_write(nd.path.mnt);
 	path_put(&nd.path);
 	return error;
 }
@@ -293,9 +300,14 @@ sys_fsetxattr(int fd, char __user *name,
 	f = fget(fd);
 	if (!f)
 		return error;
+	error = mnt_want_write(f->f_vfsmnt);
+	if (error)
+		goto out_fput;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry);
 	error = setxattr(dentry, name, value, size, flags);
+	mnt_drop_write(f->f_vfsmnt);
+out_fput:
 	fput(f);
 	return error;
 }
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
hppfs-pass-vfsmount-to-dentry_open.patch
check-for-null-vfsmount-in-dentry_open.patch
fix-up-new-filp-allocators.patch
do-namei_flags-calculation-inside-open_namei.patch
merge-open_namei-and-do_filp_open.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-create-helper-to-drop-file-write-access.patch
r-o-bind-mounts-drop-write-during-emergency-remount.patch
r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch
r-o-bind-mounts-elevate-write-count-for-ncp_ioctl.patch
r-o-bind-mounts-write-counts-for-time-functions.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-write-count-for-file_update_time.patch
r-o-bind-mounts-write-counts-for-link-symlink.patch
r-o-bind-mounts-elevate-write-count-for-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-opens.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch
r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch
r-o-bind-mounts-write-counts-for-truncate.patch
r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch
r-o-bind-mounts-make-access-use-new-r-o-helper.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch
r-o-bind-mounts-track-numbers-of-writers-to-mounts.patch
r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch
r-o-bind-mounts-debugging-for-missed-calls.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
