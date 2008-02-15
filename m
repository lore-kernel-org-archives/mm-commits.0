From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-create-helper-to-drop-file-write-access.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:48:47 -0800
Message-ID: <200802152248.m1FMmlVU028135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932814AbYBOWt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:49:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, akpm@linux-foundation.org, bfields@fieldses.org, ezk@cs.sunysb.edu, hch@lst.de, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk


The patch titled
     r/o bind mounts: create helper to drop file write access
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-create-helper-to-drop-file-write-access.patch

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
Subject: r/o bind mounts: create helper to drop file write access
From: Dave Hansen <haveblue@us.ibm.com>

If someone decides to demote a file from r/w to just r/o, they can use this
same code as __fput().

NFS does just that, and will use this in the next patch.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J Bruce Fields" <bfields@fieldses.org>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c      |   19 ++++++++++++++++++-
 fs/nfsd/nfs4state.c  |    3 ++-
 include/linux/file.h |    1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff -puN fs/file_table.c~r-o-bind-mounts-create-helper-to-drop-file-write-access fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-create-helper-to-drop-file-write-access
+++ a/fs/file_table.c
@@ -211,6 +211,23 @@ void fput(struct file *file)
 
 EXPORT_SYMBOL(fput);
 
+/**
+ * drop_file_write_access - give up ability to write to a file
+ * @file: the file to which we will stop writing
+ *
+ * This is a central place which will give up the ability
+ * to write to @file, along with access to write through
+ * its vfsmount.
+ */
+void drop_file_write_access(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+
+	put_write_access(inode);
+}
+EXPORT_SYMBOL_GPL(drop_file_write_access);
+
 /* __fput is called from task context when aio completion releases the last
  * last use of a struct file *.  Do not use otherwise.
  */
@@ -237,7 +254,7 @@ void __fput(struct file *file)
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
 	if (file->f_mode & FMODE_WRITE)
-		put_write_access(inode);
+		drop_file_write_access(file);
 	put_pid(file->f_owner.pid);
 	file_kill(file);
 	file->f_path.dentry = NULL;
diff -puN fs/nfsd/nfs4state.c~r-o-bind-mounts-create-helper-to-drop-file-write-access fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~r-o-bind-mounts-create-helper-to-drop-file-write-access
+++ a/fs/nfsd/nfs4state.c
@@ -41,6 +41,7 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/cache.h>
+#include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/workqueue.h>
 #include <linux/smp_lock.h>
@@ -1239,7 +1240,7 @@ static inline void
 nfs4_file_downgrade(struct file *filp, unsigned int share_access)
 {
 	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
-		put_write_access(filp->f_path.dentry->d_inode);
+		drop_file_write_access(filp);
 		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
 	}
 }
diff -puN include/linux/file.h~r-o-bind-mounts-create-helper-to-drop-file-write-access include/linux/file.h
--- a/include/linux/file.h~r-o-bind-mounts-create-helper-to-drop-file-write-access
+++ a/include/linux/file.h
@@ -61,6 +61,7 @@ extern struct kmem_cache *filp_cachep;
 
 extern void __fput(struct file *);
 extern void fput(struct file *);
+extern void drop_file_write_access(struct file *file);
 
 struct file_operations;
 struct vfsmount;
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
