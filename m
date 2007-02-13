From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:13:00 -0800
Message-ID: <200702130513.l1D5D0cv022296@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54639 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161034AbXBMFNL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:13:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk


The patch titled
     r/o bind mounts: elevate mount count for extended attributes
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: elevate mount count for extended attributes
From: Dave Hansen <hansendc@us.ibm.com>

This basically audits the callers of xattr_permission(), which calls
permission() and can perform writes to the filesystem.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4proc.c |    7 ++++++-
 fs/xattr.c         |   14 ++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4proc.c~r-o-bind-mounts-elevate-mount-count-for-extended-attributes fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~r-o-bind-mounts-elevate-mount-count-for-extended-attributes
+++ a/fs/nfsd/nfs4proc.c
@@ -626,14 +626,19 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
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
 
diff -puN fs/xattr.c~r-o-bind-mounts-elevate-mount-count-for-extended-attributes fs/xattr.c
--- a/fs/xattr.c~r-o-bind-mounts-elevate-mount-count-for-extended-attributes
+++ a/fs/xattr.c
@@ -12,6 +12,7 @@
 #include <linux/smp_lock.h>
 #include <linux/file.h>
 #include <linux/xattr.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
@@ -237,7 +238,11 @@ sys_setxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		return error;
 	error = setxattr(nd.dentry, name, value, size, flags);
+	mnt_drop_write(nd.mnt);
 	path_release(&nd);
 	return error;
 }
@@ -252,7 +257,11 @@ sys_lsetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		return error;
 	error = setxattr(nd.dentry, name, value, size, flags);
+	mnt_drop_write(nd.mnt);
 	path_release(&nd);
 	return error;
 }
@@ -268,9 +277,14 @@ sys_fsetxattr(int fd, char __user *name,
 	f = fget(fd);
 	if (!f)
 		return error;
+	error = mnt_want_write(f->f_vfsmnt);
+	if (error)
+		goto out_fput;
 	dentry = f->f_path.dentry;
 	audit_inode(NULL, dentry->d_inode);
 	error = setxattr(dentry, name, value, size, flags);
+	mnt_drop_write(f->f_vfsmnt);
+out_fput:
 	fput(f);
 	return error;
 }
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
r-o-bind-mounts-add-vfsmount-writer-counts.patch
r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-mount_is_safe-add-comment.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-write-count-files-are-opened.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-gfs-check-nlink-count.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch
