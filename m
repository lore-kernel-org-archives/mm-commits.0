From: akpm@linux-foundation.org
Subject: [merged] fs-coda-dirc-forward-declaration-clean-up.patch removed
 from -mm tree
Date: Wed, 18 Feb 2015 11:42:48 -0800
Message-ID: <54e4eb38.yk+untndP1q59vPA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbbBRTmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:42:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coda/dir.c: forward declaration clean-up
has been removed from the -mm tree.  Its filename was
     fs-coda-dirc-forward-declaration-clean-up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/coda/dir.c: forward declaration clean-up

- Move operation structures to avoid forward declarations.

- Fix some checkpatch warnings:

WARNING: Missing a blank line after declarations
+		struct inode *host_inode = file_inode(host_file);
+		mutex_lock(&host_inode->i_mutex);

ERROR: that open brace { should be on the previous line
+const struct dentry_operations coda_dentry_operations =
+{

ERROR: that open brace { should be on the previous line
+const struct inode_operations coda_dir_inode_operations =
+{

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c |  138 +++++++++++++++++++-----------------------------
 1 file changed, 56 insertions(+), 82 deletions(-)

diff -puN fs/coda/dir.c~fs-coda-dirc-forward-declaration-clean-up fs/coda/dir.c
--- a/fs/coda/dir.c~fs-coda-dirc-forward-declaration-clean-up
+++ a/fs/coda/dir.c
@@ -28,29 +28,6 @@
 
 #include "coda_int.h"
 
-/* dir inode-ops */
-static int coda_create(struct inode *dir, struct dentry *new, umode_t mode, bool excl);
-static struct dentry *coda_lookup(struct inode *dir, struct dentry *target, unsigned int flags);
-static int coda_link(struct dentry *old_dentry, struct inode *dir_inode, 
-		     struct dentry *entry);
-static int coda_unlink(struct inode *dir_inode, struct dentry *entry);
-static int coda_symlink(struct inode *dir_inode, struct dentry *entry,
-			const char *symname);
-static int coda_mkdir(struct inode *dir_inode, struct dentry *entry, umode_t mode);
-static int coda_rmdir(struct inode *dir_inode, struct dentry *entry);
-static int coda_rename(struct inode *old_inode, struct dentry *old_dentry, 
-                       struct inode *new_inode, struct dentry *new_dentry);
-
-/* dir file-ops */
-static int coda_readdir(struct file *file, struct dir_context *ctx);
-
-/* dentry ops */
-static int coda_dentry_revalidate(struct dentry *de, unsigned int flags);
-static int coda_dentry_delete(const struct dentry *);
-
-/* support routines */
-static int coda_venus_readdir(struct file *, struct dir_context *);
-
 /* same as fs/bad_inode.c */
 static int coda_return_EIO(void)
 {
@@ -58,38 +35,6 @@ static int coda_return_EIO(void)
 }
 #define CODA_EIO_ERROR ((void *) (coda_return_EIO))
 
-const struct dentry_operations coda_dentry_operations =
-{
-	.d_revalidate	= coda_dentry_revalidate,
-	.d_delete	= coda_dentry_delete,
-};
-
-const struct inode_operations coda_dir_inode_operations =
-{
-	.create		= coda_create,
-	.lookup		= coda_lookup,
-	.link		= coda_link,
-	.unlink		= coda_unlink,
-	.symlink	= coda_symlink,
-	.mkdir		= coda_mkdir,
-	.rmdir		= coda_rmdir,
-	.mknod		= CODA_EIO_ERROR,
-	.rename		= coda_rename,
-	.permission	= coda_permission,
-	.getattr	= coda_getattr,
-	.setattr	= coda_setattr,
-};
-
-const struct file_operations coda_dir_operations = {
-	.llseek		= generic_file_llseek,
-	.read		= generic_read_dir,
-	.iterate	= coda_readdir,
-	.open		= coda_open,
-	.release	= coda_release,
-	.fsync		= coda_fsync,
-};
-
-
 /* inode operations for directories */
 /* access routines: lookup, readlink, permission */
 static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, unsigned int flags)
@@ -374,33 +319,6 @@ static int coda_rename(struct inode *old
 	return error;
 }
 
-
-/* file operations for directories */
-static int coda_readdir(struct file *coda_file, struct dir_context *ctx)
-{
-	struct coda_file_info *cfi;
-	struct file *host_file;
-	int ret;
-
-	cfi = CODA_FTOC(coda_file);
-	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
-	host_file = cfi->cfi_container;
-
-	if (host_file->f_op->iterate) {
-		struct inode *host_inode = file_inode(host_file);
-		mutex_lock(&host_inode->i_mutex);
-		ret = -ENOENT;
-		if (!IS_DEADDIR(host_inode)) {
-			ret = host_file->f_op->iterate(host_file, ctx);
-			file_accessed(host_file);
-		}
-		mutex_unlock(&host_inode->i_mutex);
-		return ret;
-	}
-	/* Venus: we must read Venus dirents from a file */
-	return coda_venus_readdir(coda_file, ctx);
-}
-
 static inline unsigned int CDT2DT(unsigned char cdt)
 {
 	unsigned int dt;
@@ -495,6 +413,33 @@ out:
 	return 0;
 }
 
+/* file operations for directories */
+static int coda_readdir(struct file *coda_file, struct dir_context *ctx)
+{
+	struct coda_file_info *cfi;
+	struct file *host_file;
+	int ret;
+
+	cfi = CODA_FTOC(coda_file);
+	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
+	host_file = cfi->cfi_container;
+
+	if (host_file->f_op->iterate) {
+		struct inode *host_inode = file_inode(host_file);
+
+		mutex_lock(&host_inode->i_mutex);
+		ret = -ENOENT;
+		if (!IS_DEADDIR(host_inode)) {
+			ret = host_file->f_op->iterate(host_file, ctx);
+			file_accessed(host_file);
+		}
+		mutex_unlock(&host_inode->i_mutex);
+		return ret;
+	}
+	/* Venus: we must read Venus dirents from a file */
+	return coda_venus_readdir(coda_file, ctx);
+}
+
 /* called when a cache lookup succeeds */
 static int coda_dentry_revalidate(struct dentry *de, unsigned int flags)
 {
@@ -603,3 +548,32 @@ int coda_revalidate_inode(struct inode *
 	}
 	return 0;
 }
+
+const struct dentry_operations coda_dentry_operations = {
+	.d_revalidate	= coda_dentry_revalidate,
+	.d_delete	= coda_dentry_delete,
+};
+
+const struct inode_operations coda_dir_inode_operations = {
+	.create		= coda_create,
+	.lookup		= coda_lookup,
+	.link		= coda_link,
+	.unlink		= coda_unlink,
+	.symlink	= coda_symlink,
+	.mkdir		= coda_mkdir,
+	.rmdir		= coda_rmdir,
+	.mknod		= CODA_EIO_ERROR,
+	.rename		= coda_rename,
+	.permission	= coda_permission,
+	.getattr	= coda_getattr,
+	.setattr	= coda_setattr,
+};
+
+const struct file_operations coda_dir_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= generic_read_dir,
+	.iterate	= coda_readdir,
+	.open		= coda_open,
+	.release	= coda_release,
+	.fsync		= coda_fsync,
+};
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

