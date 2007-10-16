From: akpm@linux-foundation.org
Subject: - ecryptfs-make-open-truncate-and-setattr-use-persistent-file.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:00 -0700
Message-ID: <200710162041.l9GKf0vB015739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935806AbXJPVHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: make open, truncate, and setattr use persistent file
has been removed from the -mm tree.  Its filename was
     ecryptfs-make-open-truncate-and-setattr-use-persistent-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: make open, truncate, and setattr use persistent file
From: Michael Halcrow <mhalcrow@us.ibm.com>

Rather than open a new lower file for every eCryptfs file that is opened,
truncated, or setattr'd, instead use the existing lower persistent file for
the eCryptfs inode.  Change truncate to use read_write.c functions.  Change
ecryptfs_getxattr() to use the common ecryptfs_getxattr_lower() function.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    2 
 fs/ecryptfs/file.c   |   50 +++---------------
 fs/ecryptfs/inode.c  |  113 ++++++++++++-----------------------------
 3 files changed, 44 insertions(+), 121 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-make-open-truncate-and-setattr-use-persistent-file fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-make-open-truncate-and-setattr-use-persistent-file
+++ a/fs/ecryptfs/crypto.c
@@ -1673,7 +1673,7 @@ out:
 /**
  * ecryptfs_read_xattr_region
  * @page_virt: The vitual address into which to read the xattr data
- * @ecryptfs_dentry: The eCryptfs dentry
+ * @ecryptfs_inode: The eCryptfs inode
  *
  * Attempts to read the crypto metadata from the extended attribute
  * region of the lower file.
diff -puN fs/ecryptfs/file.c~ecryptfs-make-open-truncate-and-setattr-use-persistent-file fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-make-open-truncate-and-setattr-use-persistent-file
+++ a/fs/ecryptfs/file.c
@@ -187,11 +187,7 @@ static int ecryptfs_open(struct inode *i
 	/* Private value of ecryptfs_dentry allocated in
 	 * ecryptfs_lookup() */
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
-	struct inode *lower_inode = NULL;
-	struct file *lower_file = NULL;
-	struct vfsmount *lower_mnt;
 	struct ecryptfs_file_info *file_info;
-	int lower_flags;
 
 	mount_crypt_stat = &ecryptfs_superblock_to_private(
 		ecryptfs_dentry->d_sb)->mount_crypt_stat;
@@ -219,26 +215,12 @@ static int ecryptfs_open(struct inode *i
 	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)) {
 		ecryptfs_printk(KERN_DEBUG, "Setting flags for stat...\n");
 		/* Policy code enabled in future release */
-		crypt_stat->flags |= ECRYPTFS_POLICY_APPLIED;
-		crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
+		crypt_stat->flags |= (ECRYPTFS_POLICY_APPLIED
+				      | ECRYPTFS_ENCRYPTED);
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
-	lower_flags = file->f_flags;
-	if ((lower_flags & O_ACCMODE) == O_WRONLY)
-		lower_flags = (lower_flags & O_ACCMODE) | O_RDWR;
-	if (file->f_flags & O_APPEND)
-		lower_flags &= ~O_APPEND;
-	lower_mnt = ecryptfs_dentry_to_lower_mnt(ecryptfs_dentry);
-	/* Corresponding fput() in ecryptfs_release() */
-	rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
-				      lower_flags);
-	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error opening lower file\n");
-		goto out_puts;
-	}
-	ecryptfs_set_file_lower(file, lower_file);
-	/* Isn't this check the same as the one in lookup? */
-	lower_inode = lower_dentry->d_inode;
+	ecryptfs_set_file_lower(
+		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
 		ecryptfs_printk(KERN_DEBUG, "This is a directory\n");
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
@@ -260,7 +242,7 @@ static int ecryptfs_open(struct inode *i
 				       "and plaintext passthrough mode is not "
 				       "enabled; returning -EIO\n");
 				mutex_unlock(&crypt_stat->cs_mutex);
-				goto out_puts;
+				goto out_free;
 			}
 			rc = 0;
 			crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
@@ -272,11 +254,8 @@ static int ecryptfs_open(struct inode *i
 	ecryptfs_printk(KERN_DEBUG, "inode w/ addr = [0x%p], i_ino = [0x%.16x] "
 			"size: [0x%.16x]\n", inode, inode->i_ino,
 			i_size_read(inode));
-	ecryptfs_set_file_lower(file, lower_file);
 	goto out;
-out_puts:
-	mntput(lower_mnt);
-	dput(lower_dentry);
+out_free:
 	kmem_cache_free(ecryptfs_file_info_cache,
 			ecryptfs_file_to_private(file));
 out:
@@ -296,20 +275,9 @@ static int ecryptfs_flush(struct file *f
 
 static int ecryptfs_release(struct inode *inode, struct file *file)
 {
-	struct file *lower_file = ecryptfs_file_to_lower(file);
-	struct ecryptfs_file_info *file_info = ecryptfs_file_to_private(file);
-	struct inode *lower_inode = ecryptfs_inode_to_lower(inode);
-	int rc;
-
-	rc = ecryptfs_close_lower_file(lower_file);
-	if (rc) {
-		printk(KERN_ERR "Error closing lower_file\n");
-		goto out;
-	}
-	inode->i_blocks = lower_inode->i_blocks;
-	kmem_cache_free(ecryptfs_file_info_cache, file_info);
-out:
-	return rc;
+	kmem_cache_free(ecryptfs_file_info_cache,
+			ecryptfs_file_to_private(file));
+	return 0;
 }
 
 static int
diff -puN fs/ecryptfs/inode.c~ecryptfs-make-open-truncate-and-setattr-use-persistent-file fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-make-open-truncate-and-setattr-use-persistent-file
+++ a/fs/ecryptfs/inode.c
@@ -739,8 +739,7 @@ int ecryptfs_truncate(struct dentry *den
 	int rc = 0;
 	struct inode *inode = dentry->d_inode;
 	struct dentry *lower_dentry;
-	struct vfsmount *lower_mnt;
-	struct file fake_ecryptfs_file, *lower_file = NULL;
+	struct file fake_ecryptfs_file;
 	struct ecryptfs_crypt_stat *crypt_stat;
 	loff_t i_size = i_size_read(inode);
 	loff_t lower_size_before_truncate;
@@ -763,51 +762,43 @@ int ecryptfs_truncate(struct dentry *den
 		goto out;
 	}
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	/* This dget & mntget is released through fput at out_fput: */
-	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
-	rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
-				      O_RDWR);
-	if (rc) {
-		ecryptfs_printk(KERN_ERR,
-				"Error opening dentry; rc = [%i]\n", rc);
-		goto out_free;
-	}
-	ecryptfs_set_file_lower(&fake_ecryptfs_file, lower_file);
+	ecryptfs_set_file_lower(
+		&fake_ecryptfs_file,
+		ecryptfs_inode_to_private(dentry->d_inode)->lower_file);
 	/* Switch on growing or shrinking file */
 	if (new_length > i_size) {
-		rc = ecryptfs_fill_zeros(&fake_ecryptfs_file, new_length);
-		if (rc) {
-			ecryptfs_printk(KERN_ERR,
-					"Problem with fill_zeros\n");
-			goto out_fput;
-		}
-		i_size_write(inode, new_length);
-		rc = ecryptfs_write_inode_size_to_metadata(inode);
-		if (rc) {
-			printk(KERN_ERR	"Problem with "
-			       "ecryptfs_write_inode_size_to_metadata; "
-			       "rc = [%d]\n", rc);
-			goto out_fput;
-		}
-	} else { /* new_length < i_size_read(inode) */
-		pgoff_t index = 0;
-		int end_pos_in_page = -1;
+		char zero[] = { 0x00 };
 
-		if (new_length != 0) {
-			index = ((new_length - 1) >> PAGE_CACHE_SHIFT);
-			end_pos_in_page = ((new_length - 1) & ~PAGE_CACHE_MASK);
-		}
-		if (end_pos_in_page != (PAGE_CACHE_SIZE - 1)) {
-			rc = ecryptfs_write_zeros(&fake_ecryptfs_file,
-						  index,
-						  (end_pos_in_page + 1),
-						  ((PAGE_CACHE_SIZE - 1)
-						   - end_pos_in_page));
+		/* Write a single 0 at the last position of the file;
+		 * this triggers code that will fill in 0's throughout
+		 * the intermediate portion of the previous end of the
+		 * file and the new and of the file */
+		rc = ecryptfs_write(&fake_ecryptfs_file, zero,
+				    (new_length - 1), 1);
+	} else { /* new_length < i_size_read(inode) */
+		/* We're chopping off all the pages down do the page
+		 * in which new_length is located. Fill in the end of
+		 * that page from (new_length & ~PAGE_CACHE_MASK) to
+		 * PAGE_CACHE_SIZE with zeros. */
+		size_t num_zeros = (PAGE_CACHE_SIZE
+				    - (new_length & ~PAGE_CACHE_MASK));
+
+		if (num_zeros) {
+			char *zeros_virt;
+
+			zeros_virt = kzalloc(num_zeros, GFP_KERNEL);
+			if (!zeros_virt) {
+				rc = -ENOMEM;
+				goto out_free;
+			}
+			rc = ecryptfs_write(&fake_ecryptfs_file, zeros_virt,
+					    new_length, num_zeros);
+			kfree(zeros_virt);
 			if (rc) {
 				printk(KERN_ERR "Error attempting to zero out "
 				       "the remainder of the end page on "
 				       "reducing truncate; rc = [%d]\n", rc);
-				goto out_fput;
+				goto out_free;
 			}
 		}
 		vmtruncate(inode, new_length);
@@ -816,7 +807,7 @@ int ecryptfs_truncate(struct dentry *den
 			printk(KERN_ERR	"Problem with "
 			       "ecryptfs_write_inode_size_to_metadata; "
 			       "rc = [%d]\n", rc);
-			goto out_fput;
+			goto out_free;
 		}
 		/* We are reducing the size of the ecryptfs file, and need to
 		 * know if we need to reduce the size of the lower file. */
@@ -828,14 +819,6 @@ int ecryptfs_truncate(struct dentry *den
 			vmtruncate(lower_dentry->d_inode,
 				   lower_size_after_truncate);
 	}
-	/* Update the access times */
-	lower_dentry->d_inode->i_mtime = lower_dentry->d_inode->i_ctime
-		= CURRENT_TIME;
-	mark_inode_dirty_sync(inode);
-out_fput:
-	rc = ecryptfs_close_lower_file(lower_file);
-	if (rc)
-		printk(KERN_ERR "Error closing lower_file\n");
 out_free:
 	if (ecryptfs_file_to_private(&fake_ecryptfs_file))
 		kmem_cache_free(ecryptfs_file_info_cache,
@@ -895,21 +878,8 @@ static int ecryptfs_setattr(struct dentr
 	else if (S_ISREG(dentry->d_inode->i_mode)
 		 && (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
 		     || !(crypt_stat->flags & ECRYPTFS_KEY_VALID))) {
-		struct vfsmount *lower_mnt;
-		struct file *lower_file = NULL;
 		struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
-		int lower_flags;
 
-		lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
-		lower_flags = O_RDONLY;
-		rc = ecryptfs_open_lower_file(&lower_file, lower_dentry,
-					      lower_mnt, lower_flags);
-		if (rc) {
-			printk(KERN_ERR
-			       "Error opening lower file; rc = [%d]\n", rc);
-			mutex_unlock(&crypt_stat->cs_mutex);
-			goto out;
-		}
 		mount_crypt_stat = &ecryptfs_superblock_to_private(
 			dentry->d_sb)->mount_crypt_stat;
 		rc = ecryptfs_read_metadata(dentry);
@@ -923,16 +893,13 @@ static int ecryptfs_setattr(struct dentr
 				       "enabled; returning -EIO\n");
 
 				mutex_unlock(&crypt_stat->cs_mutex);
-				fput(lower_file);
 				goto out;
 			}
 			rc = 0;
 			crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
 			mutex_unlock(&crypt_stat->cs_mutex);
-			fput(lower_file);
 			goto out;
 		}
-		fput(lower_file);
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
 	if (ia->ia_valid & ATTR_SIZE) {
@@ -995,20 +962,8 @@ ssize_t
 ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
 		  size_t size)
 {
-	int rc = 0;
-	struct dentry *lower_dentry;
-
-	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	if (!lower_dentry->d_inode->i_op->getxattr) {
-		rc = -ENOSYS;
-		goto out;
-	}
-	mutex_lock(&lower_dentry->d_inode->i_mutex);
-	rc = lower_dentry->d_inode->i_op->getxattr(lower_dentry, name, value,
-						   size);
-	mutex_unlock(&lower_dentry->d_inode->i_mutex);
-out:
-	return rc;
+	return ecryptfs_getxattr_lower(ecryptfs_dentry_to_lower(dentry), name,
+				       value, size);
 }
 
 static ssize_t
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
