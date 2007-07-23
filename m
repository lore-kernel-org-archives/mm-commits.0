From: akpm@linux-foundation.org
Subject: - coda-remove-coda_store-coda_release-upcalls.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:33:42 -0700
Message-ID: <200707230933.l6N9XgSL016319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756848AbXGWJey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaharkes@cs.cmu.edu, hch@lst.de, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     coda: remove CODA_STORE/CODA_RELEASE upcalls
has been removed from the -mm tree.  Its filename was
     coda-remove-coda_store-coda_release-upcalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: coda: remove CODA_STORE/CODA_RELEASE upcalls
From: Jan Harkes <jaharkes@cs.cmu.edu>

This is an variation on the patch sent by Christoph Hellwig which kills
file_count abuse by the Coda kernel module by moving the coda_flush
functionality into coda_release.  However part of reason we were using the
coda_flush callback was to allow Coda to pass errors that occur during
writeback from the userspace cache manager back to close().

As Al Viro explained on linux-fsdevel, it is impossible to guarantee that
such errors can in fact be returned back to the caller.  There are many
cases where the last reference to a file is not released by the close
system call and it is also impossible to pick some close as a 'last-close'
and delay it until all other references have been destroyed.

The CODA_STORE/CODA_RELEASE upcall combination is clearly a broken design,
and it is better to remove it completely.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@ftp.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/dir.c              |    1 
 fs/coda/file.c             |   65 +++--------------------------------
 fs/coda/upcall.c           |   49 --------------------------
 include/linux/coda_linux.h |    1 
 include/linux/coda_psdev.h |    3 -
 5 files changed, 7 insertions(+), 112 deletions(-)

diff -puN fs/coda/dir.c~coda-remove-coda_store-coda_release-upcalls fs/coda/dir.c
--- a/fs/coda/dir.c~coda-remove-coda_store-coda_release-upcalls
+++ a/fs/coda/dir.c
@@ -86,7 +86,6 @@ const struct file_operations coda_dir_op
 	.read		= generic_read_dir,
 	.readdir	= coda_readdir,
 	.open		= coda_open,
-	.flush		= coda_flush,
 	.release	= coda_release,
 	.fsync		= coda_fsync,
 };
diff -puN fs/coda/file.c~coda-remove-coda_store-coda_release-upcalls fs/coda/file.c
--- a/fs/coda/file.c~coda-remove-coda_store-coda_release-upcalls
+++ a/fs/coda/file.c
@@ -25,10 +25,6 @@
 
 #include "coda_int.h"
 
-/* if CODA_STORE fails with EOPNOTSUPP, venus clearly doesn't support
- * CODA_STORE/CODA_RELEASE and we fall back on using the CODA_CLOSE upcall */
-static int use_coda_close;
-
 static ssize_t
 coda_file_read(struct file *coda_file, char __user *buf, size_t count, loff_t *ppos)
 {
@@ -163,47 +159,6 @@ int coda_open(struct inode *coda_inode, 
 	return 0;
 }
 
-int coda_flush(struct file *coda_file, fl_owner_t id)
-{
-	unsigned short flags = coda_file->f_flags & ~O_EXCL;
-	unsigned short coda_flags = coda_flags_to_cflags(flags);
-	struct coda_file_info *cfi;
-	struct inode *coda_inode;
-	int err = 0, fcnt;
-
-	lock_kernel();
-
-	/* last close semantics */
-	fcnt = file_count(coda_file);
-	if (fcnt > 1)
-		goto out;
-
-	/* No need to make an upcall when we have not made any modifications
-	 * to the file */
-	if ((coda_file->f_flags & O_ACCMODE) == O_RDONLY)
-		goto out;
-
-	if (use_coda_close)
-		goto out;
-
-	cfi = CODA_FTOC(coda_file);
-	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
-
-	coda_inode = coda_file->f_path.dentry->d_inode;
-
-	err = venus_store(coda_inode->i_sb, coda_i2f(coda_inode), coda_flags,
-			  coda_file->f_uid);
-
-	if (err == -EOPNOTSUPP) {
-		use_coda_close = 1;
-		err = 0;
-	}
-
-out:
-	unlock_kernel();
-	return err;
-}
-
 int coda_release(struct inode *coda_inode, struct file *coda_file)
 {
 	unsigned short flags = (coda_file->f_flags) & (~O_EXCL);
@@ -215,21 +170,11 @@ int coda_release(struct inode *coda_inod
 
 	lock_kernel();
 
-	if (!use_coda_close) {
-		err = venus_release(coda_inode->i_sb, coda_i2f(coda_inode),
-				    coda_flags);
-		if (err == -EOPNOTSUPP) {
-			use_coda_close = 1;
-			err = 0;
-		}
-	}
-
 	cfi = CODA_FTOC(coda_file);
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
 
-	if (use_coda_close)
-		err = venus_close(coda_inode->i_sb, coda_i2f(coda_inode),
-				  coda_flags, coda_file->f_uid);
+	err = venus_close(coda_inode->i_sb, coda_i2f(coda_inode),
+			  coda_flags, coda_file->f_uid);
 
 	host_inode = cfi->cfi_container->f_path.dentry->d_inode;
 	cii = ITOC(coda_inode);
@@ -246,7 +191,10 @@ int coda_release(struct inode *coda_inod
 	coda_file->private_data = NULL;
 
 	unlock_kernel();
-	return err;
+
+	/* VFS fput ignores the return value from file_operations->release, so
+	 * there is no use returning an error here */
+	return 0;
 }
 
 int coda_fsync(struct file *coda_file, struct dentry *coda_dentry, int datasync)
@@ -288,7 +236,6 @@ const struct file_operations coda_file_o
 	.write		= coda_file_write,
 	.mmap		= coda_file_mmap,
 	.open		= coda_open,
-	.flush		= coda_flush,
 	.release	= coda_release,
 	.fsync		= coda_fsync,
 	.splice_read	= coda_file_splice_read,
diff -puN fs/coda/upcall.c~coda-remove-coda_store-coda_release-upcalls fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-remove-coda_store-coda_release-upcalls
+++ a/fs/coda/upcall.c
@@ -160,55 +160,8 @@ int venus_lookup(struct super_block *sb,
 	return error;
 }
 
-int venus_store(struct super_block *sb, struct CodaFid *fid, int flags,
-                vuid_t uid)
-{
-        union inputArgs *inp;
-        union outputArgs *outp;
-        int insize, outsize, error;
-#ifdef CONFIG_CODA_FS_OLD_API
-	struct coda_cred cred = { 0, };
-	cred.cr_fsuid = uid;
-#endif
-	
-	insize = SIZE(store);
-	UPARG(CODA_STORE);
-	
-#ifdef CONFIG_CODA_FS_OLD_API
-	memcpy(&(inp->ih.cred), &cred, sizeof(cred));
-#else
-	inp->ih.uid = uid;
-#endif
-	
-        inp->coda_store.VFid = *fid;
-        inp->coda_store.flags = flags;
-
-	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
-
-	CODA_FREE(inp, insize);
-        return error;
-}
-
-int venus_release(struct super_block *sb, struct CodaFid *fid, int flags)
-{
-        union inputArgs *inp;
-        union outputArgs *outp;
-        int insize, outsize, error;
-	
-	insize = SIZE(release);
-	UPARG(CODA_RELEASE);
-	
-	inp->coda_release.VFid = *fid;
-	inp->coda_release.flags = flags;
-
-	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
-
-	CODA_FREE(inp, insize);
-	return error;
-}
-
 int venus_close(struct super_block *sb, struct CodaFid *fid, int flags,
-                vuid_t uid)
+		vuid_t uid)
 {
 	union inputArgs *inp;
 	union outputArgs *outp;
diff -puN include/linux/coda_linux.h~coda-remove-coda_store-coda_release-upcalls include/linux/coda_linux.h
--- a/include/linux/coda_linux.h~coda-remove-coda_store-coda_release-upcalls
+++ a/include/linux/coda_linux.h
@@ -36,7 +36,6 @@ extern const struct file_operations coda
 
 /* operations shared over more than one file */
 int coda_open(struct inode *i, struct file *f);
-int coda_flush(struct file *f, fl_owner_t id);
 int coda_release(struct inode *i, struct file *f);
 int coda_permission(struct inode *inode, int mask, struct nameidata *nd);
 int coda_revalidate_inode(struct dentry *);
diff -puN include/linux/coda_psdev.h~coda-remove-coda_store-coda_release-upcalls include/linux/coda_psdev.h
--- a/include/linux/coda_psdev.h~coda-remove-coda_store-coda_release-upcalls
+++ a/include/linux/coda_psdev.h
@@ -33,9 +33,6 @@ int venus_setattr(struct super_block *, 
 int venus_lookup(struct super_block *sb, struct CodaFid *fid, 
 		 const char *name, int length, int *type, 
 		 struct CodaFid *resfid);
-int venus_store(struct super_block *sb, struct CodaFid *fid, int flags,
-		vuid_t uid);
-int venus_release(struct super_block *sb, struct CodaFid *fid, int flags);
 int venus_close(struct super_block *sb, struct CodaFid *fid, int flags,
 		vuid_t uid);
 int venus_open(struct super_block *sb, struct CodaFid *fid, int flags,
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are
