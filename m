From: akpm@linux-foundation.org
Subject: - libfs-rename-simple_attr_close-to-simple_attr_release.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:57 -0800
Message-ID: <200802082016.m18KGcFr010747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48201 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757093AbYBHVD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd@arndb.de, greg@kroah.com, stefano.brivio@polimi.it, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     libfs: rename simple_attr_close to simple_attr_release
has been removed from the -mm tree.  Its filename was
     libfs-rename-simple_attr_close-to-simple_attr_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libfs: rename simple_attr_close to simple_attr_release
From: Christoph Hellwig <hch@lst.de>

simple_attr_close implementes ->release so it should be named accordingly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: <stefano.brivio@polimi.it>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/file.c |    2 +-
 fs/libfs.c                               |    4 ++--
 include/linux/fs.h                       |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/file.c~libfs-rename-simple_attr_close-to-simple_attr_release arch/powerpc/platforms/cell/spufs/file.c
--- a/arch/powerpc/platforms/cell/spufs/file.c~libfs-rename-simple_attr_close-to-simple_attr_release
+++ a/arch/powerpc/platforms/cell/spufs/file.c
@@ -470,7 +470,7 @@ spufs_cntl_release(struct inode *inode, 
 	struct spufs_inode_info *i = SPUFS_I(inode);
 	struct spu_context *ctx = i->i_ctx;
 
-	simple_attr_close(inode, file);
+	simple_attr_release(inode, file);
 
 	mutex_lock(&ctx->mapping_lock);
 	if (!--i->i_openers)
diff -puN fs/libfs.c~libfs-rename-simple_attr_close-to-simple_attr_release fs/libfs.c
--- a/fs/libfs.c~libfs-rename-simple_attr_close-to-simple_attr_release
+++ a/fs/libfs.c
@@ -615,7 +615,7 @@ int simple_attr_open(struct inode *inode
 	return nonseekable_open(inode, file);
 }
 
-int simple_attr_close(struct inode *inode, struct file *file)
+int simple_attr_release(struct inode *inode, struct file *file)
 {
 	kfree(file->private_data);
 	return 0;
@@ -804,6 +804,6 @@ EXPORT_SYMBOL(simple_transaction_get);
 EXPORT_SYMBOL(simple_transaction_read);
 EXPORT_SYMBOL(simple_transaction_release);
 EXPORT_SYMBOL_GPL(simple_attr_open);
-EXPORT_SYMBOL_GPL(simple_attr_close);
+EXPORT_SYMBOL_GPL(simple_attr_release);
 EXPORT_SYMBOL_GPL(simple_attr_read);
 EXPORT_SYMBOL_GPL(simple_attr_write);
diff -puN include/linux/fs.h~libfs-rename-simple_attr_close-to-simple_attr_release include/linux/fs.h
--- a/include/linux/fs.h~libfs-rename-simple_attr_close-to-simple_attr_release
+++ a/include/linux/fs.h
@@ -2056,7 +2056,7 @@ static int __fops ## _open(struct inode 
 static struct file_operations __fops = {				\
 	.owner	 = THIS_MODULE,						\
 	.open	 = __fops ## _open,					\
-	.release = simple_attr_close,					\
+	.release = simple_attr_release,					\
 	.read	 = simple_attr_read,					\
 	.write	 = simple_attr_write,					\
 };
@@ -2070,7 +2070,7 @@ __simple_attr_check_format(const char *f
 int simple_attr_open(struct inode *inode, struct file *file,
 		     int (*get)(void *, u64 *), int (*set)(void *, u64),
 		     const char *fmt);
-int simple_attr_close(struct inode *inode, struct file *file);
+int simple_attr_release(struct inode *inode, struct file *file);
 ssize_t simple_attr_read(struct file *file, char __user *buf,
 			 size_t len, loff_t *ppos);
 ssize_t simple_attr_write(struct file *file, const char __user *buf,
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-unionfs.patch
git-xfs.patch
uml-update-defconfig.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
rename-open_namei-to-open_pathname.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
vfs-create-proc-pid-mountinfo.patch
reiserfs-use-open_bdev_excl.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
