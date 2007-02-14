From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-files-are-opened.patch removed from -mm tree
Date: Wed, 14 Feb 2007 10:52:41 -0800
Message-ID: <200702141852.l1EIqfhD005737@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39214 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbXBNSw4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 13:52:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate write count files are open()ed
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-files-are-opened.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: elevate write count files are open()ed
From: Dave Hansen <hansendc@us.ibm.com>

This is the first really tricky patch in the series.  It elevates the writer
count on a mount each time a non-special file is opened for write.

This is not completely apparent in the patch because the two if() conditions
in may_open() above the mnt_want_write() call are, combined, equivalent to
special_file().

There is also an elevated count around the vfs_create() call in open_namei(). 
The count needs to be kept elevated all the way into the may_open() call. 
Otherwise, when the write is dropped, a ro->rw transisition could occur.  This
would lead to having rw access on the newly created file, while the vfsmount
is ro.  That is bad.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    5 ++++-
 fs/namei.c      |   22 ++++++++++++++++++----
 ipc/mqueue.c    |    3 +++
 3 files changed, 25 insertions(+), 5 deletions(-)

diff -puN fs/file_table.c~r-o-bind-mounts-elevate-write-count-files-are-opened fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-elevate-write-count-files-are-opened
+++ a/fs/file_table.c
@@ -208,8 +208,11 @@ void fastcall __fput(struct file *file)
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
-	if (file->f_mode & FMODE_WRITE)
+	if (file->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
+		if (!special_file(inode->i_mode))
+			mnt_drop_write(mnt);
+	}
 	put_pid(file->f_owner.pid);
 	file_kill(file);
 	file->f_path.dentry = NULL;
diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-files-are-opened fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-elevate-write-count-files-are-opened
+++ a/fs/namei.c
@@ -1544,8 +1544,17 @@ int may_open(struct nameidata *nd, int a
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
-	} else if (IS_RDONLY(inode) && (flag & FMODE_WRITE))
-		return -EROFS;
+	} else if (flag & FMODE_WRITE) {
+		/*
+		 * effectively: !special_file()
+		 * balanced by __fput()
+		 */
+		error = mnt_want_write(nd->mnt);
+		if (error)
+			return error;
+		if (IS_RDONLY(inode))
+			return -EROFS;
+	}
 	/*
 	 * An append-only file must be opened in append mode for writing.
 	 */
@@ -1684,14 +1693,17 @@ do_last:
 	}
 
 	if (IS_ERR(nd->intent.open.file)) {
-		mutex_unlock(&dir->d_inode->i_mutex);
 		error = PTR_ERR(nd->intent.open.file);
-		goto exit_dput;
+		goto exit_mutex_unlock;
 	}
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
+		error = mnt_want_write(nd->mnt);
+		if (error)
+			goto exit_mutex_unlock;
 		error = open_namei_create(nd, &path, flag, mode);
+		mnt_drop_write(nd->mnt);
 		if (error)
 			goto exit;
 		return 0;
@@ -1729,6 +1741,8 @@ ok:
 		goto exit;
 	return 0;
 
+exit_mutex_unlock:
+	mutex_unlock(&dir->d_inode->i_mutex);
 exit_dput:
 	dput_path(&path, nd);
 exit:
diff -puN ipc/mqueue.c~r-o-bind-mounts-elevate-write-count-files-are-opened ipc/mqueue.c
--- a/ipc/mqueue.c~r-o-bind-mounts-elevate-write-count-files-are-opened
+++ a/ipc/mqueue.c
@@ -687,6 +687,9 @@ asmlinkage long sys_mq_open(const char _
 				goto out;
 			filp = do_open(dentry, oflag);
 		} else {
+			error = mnt_want_write(mqueue_mnt);
+			if (error)
+				goto out;
 			filp = do_create(mqueue_mnt->mnt_root, dentry,
 						oflag, mode, u_attr);
 		}
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

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
