From: akpm@linux-foundation.org
Subject: - coda-kill-file_count-abuse.patch removed from -mm tree
Date: Thu, 19 Jul 2007 15:25:50 -0700
Message-ID: <200707192225.l6JMPo33026099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35675 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756754AbXGSW0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 18:26:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: kill file_count abuse
has been removed from the -mm tree.  Its filename was
     coda-kill-file_count-abuse.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: coda: kill file_count abuse
From: Christoph Hellwig <hch@lst.de>

->release is the proper way to detect the last close of a file,
file_count should never be used in filesystems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c              |    1 
 fs/coda/file.c             |   55 ++++++++---------------------------
 include/linux/coda_linux.h |    1 
 3 files changed, 13 insertions(+), 44 deletions(-)

diff -puN fs/coda/dir.c~coda-kill-file_count-abuse fs/coda/dir.c
--- a/fs/coda/dir.c~coda-kill-file_count-abuse
+++ a/fs/coda/dir.c
@@ -86,7 +86,6 @@ const struct file_operations coda_dir_op
 	.read		= generic_read_dir,
 	.readdir	= coda_readdir,
 	.open		= coda_open,
-	.flush		= coda_flush,
 	.release	= coda_release,
 	.fsync		= coda_fsync,
 };
diff -puN fs/coda/file.c~coda-kill-file_count-abuse fs/coda/file.c
--- a/fs/coda/file.c~coda-kill-file_count-abuse
+++ a/fs/coda/file.c
@@ -163,58 +163,31 @@ int coda_open(struct inode *coda_inode, 
 	return 0;
 }
 
-int coda_flush(struct file *coda_file, fl_owner_t id)
+int coda_release(struct inode *coda_inode, struct file *coda_file)
 {
 	unsigned short flags = coda_file->f_flags & ~O_EXCL;
 	unsigned short coda_flags = coda_flags_to_cflags(flags);
-	struct coda_file_info *cfi;
-	struct inode *coda_inode;
-	int err = 0, fcnt;
+	struct coda_file_info *cfi = CODA_FTOC(coda_file);
+	struct coda_inode_info *cii;
+	struct inode *host_inode;
+	int err = 0;
 
 	lock_kernel();
 
-	/* last close semantics */
-	fcnt = file_count(coda_file);
-	if (fcnt > 1)
-		goto out;
-
 	/* No need to make an upcall when we have not made any modifications
 	 * to the file */
-	if ((coda_file->f_flags & O_ACCMODE) == O_RDONLY)
-		goto out;
-
-	if (use_coda_close)
-		goto out;
+	if (((coda_file->f_flags & O_ACCMODE) != O_RDONLY) && !use_coda_close) {
+		BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
 
-	cfi = CODA_FTOC(coda_file);
-	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
-
-	coda_inode = coda_file->f_path.dentry->d_inode;
-
-	err = venus_store(coda_inode->i_sb, coda_i2f(coda_inode), coda_flags,
-			  coda_file->f_uid);
+		err = venus_store(coda_inode->i_sb, coda_i2f(coda_inode), coda_flags,
+				  coda_file->f_uid);
 
-	if (err == -EOPNOTSUPP) {
-		use_coda_close = 1;
-		err = 0;
+		if (err == -EOPNOTSUPP) {
+			use_coda_close = 1;
+			err = 0;
+		}
 	}
 
-out:
-	unlock_kernel();
-	return err;
-}
-
-int coda_release(struct inode *coda_inode, struct file *coda_file)
-{
-	unsigned short flags = (coda_file->f_flags) & (~O_EXCL);
-	unsigned short coda_flags = coda_flags_to_cflags(flags);
-	struct coda_file_info *cfi;
-	struct coda_inode_info *cii;
-	struct inode *host_inode;
-	int err = 0;
-
-	lock_kernel();
-
 	if (!use_coda_close) {
 		err = venus_release(coda_inode->i_sb, coda_i2f(coda_inode),
 				    coda_flags);
@@ -224,7 +197,6 @@ int coda_release(struct inode *coda_inod
 		}
 	}
 
-	cfi = CODA_FTOC(coda_file);
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
 
 	if (use_coda_close)
@@ -288,7 +260,6 @@ const struct file_operations coda_file_o
 	.write		= coda_file_write,
 	.mmap		= coda_file_mmap,
 	.open		= coda_open,
-	.flush		= coda_flush,
 	.release	= coda_release,
 	.fsync		= coda_fsync,
 	.splice_read	= coda_file_splice_read,
diff -puN include/linux/coda_linux.h~coda-kill-file_count-abuse include/linux/coda_linux.h
--- a/include/linux/coda_linux.h~coda-kill-file_count-abuse
+++ a/include/linux/coda_linux.h
@@ -36,7 +36,6 @@ extern const struct file_operations coda
 
 /* operations shared over more than one file */
 int coda_open(struct inode *i, struct file *f);
-int coda_flush(struct file *f, fl_owner_t id);
 int coda_release(struct inode *i, struct file *f);
 int coda_permission(struct inode *inode, int mask, struct nameidata *nd);
 int coda_revalidate_inode(struct dentry *);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
fix-spufs-build-after-fault-changes.patch
gdth-remove-redundant-pci-stuff.patch
gdth-remove-redundant-pci-stuff-update.patch
git-xfs.patch
remove-handle_mm_fault-export.patch
sysv-convert-to-new-aops.patch
kill-declare_mutex_locked.patch
coda-kill-file_count-abuse.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
