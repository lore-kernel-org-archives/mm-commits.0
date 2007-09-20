From: akpm@linux-foundation.org
Subject: + ecryptfs-update-metadata-read-write-functions.patch added to -mm tree
Date: Wed, 19 Sep 2007 22:51:34 -0700
Message-ID: <200709200551.l8K5pYpD030764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754413AbXITFvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 01:51:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: update metadata read/write functions
has been added to the -mm tree.  Its filename is
     ecryptfs-update-metadata-read-write-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: update metadata read/write functions
From: Michael Halcrow <mhalcrow@us.ibm.com>

Update the metadata read/write functions and grow_file() to use the
read_write.c routines.  Do not open another lower file; use the persistent
lower file instead.  Provide a separate function for
crypto.c::ecryptfs_read_xattr_region() to get to the lower xattr without
having to go through the eCryptfs getxattr.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |  126 ++++++++++++++------------------
 fs/ecryptfs/ecryptfs_kernel.h |   15 ++-
 fs/ecryptfs/file.c            |    2 
 fs/ecryptfs/inode.c           |  101 +++++++++++--------------
 fs/ecryptfs/mmap.c            |    2 
 5 files changed, 113 insertions(+), 133 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-update-metadata-read-write-functions fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-update-metadata-read-write-functions
+++ a/fs/ecryptfs/crypto.c
@@ -1342,21 +1342,28 @@ out:
 	return rc;
 }
 
-int ecryptfs_read_and_validate_header_region(char *data, struct dentry *dentry,
-					     struct vfsmount *mnt)
+int ecryptfs_read_and_validate_header_region(char *data,
+					     struct inode *ecryptfs_inode)
 {
+	struct ecryptfs_crypt_stat *crypt_stat =
+		&(ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat);
 	int rc;
 
-	rc = ecryptfs_read_header_region(data, dentry, mnt);
-	if (rc)
+	rc = ecryptfs_read_lower(data, 0, crypt_stat->extent_size,
+				 ecryptfs_inode);
+	if (rc) {
+		printk(KERN_ERR "%s: Error reading header region; rc = [%d]\n",
+		       __FUNCTION__, rc);
 		goto out;
-	if (!contains_ecryptfs_marker(data + ECRYPTFS_FILE_SIZE_BYTES))
+	}
+	if (!contains_ecryptfs_marker(data + ECRYPTFS_FILE_SIZE_BYTES)) {
 		rc = -EINVAL;
+		ecryptfs_printk(KERN_DEBUG, "Valid marker not found\n");
+	}
 out:
 	return rc;
 }
 
-
 void
 ecryptfs_write_header_metadata(char *virt,
 			       struct ecryptfs_crypt_stat *crypt_stat,
@@ -1441,24 +1448,18 @@ static int ecryptfs_write_headers_virt(c
 
 static int
 ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
-				    struct file *lower_file, char *page_virt)
+				    struct dentry *ecryptfs_dentry,
+				    char *page_virt)
 {
-	mm_segment_t oldfs;
 	int current_header_page;
 	int header_pages;
-	ssize_t size;
-	int rc = 0;
+	int rc;
 
-	lower_file->f_pos = 0;
-	oldfs = get_fs();
-	set_fs(get_ds());
-	size = vfs_write(lower_file, (char __user *)page_virt, PAGE_CACHE_SIZE,
-			 &lower_file->f_pos);
-	if (size < 0) {
-		rc = (int)size;
-		printk(KERN_ERR "Error attempting to write lower page; "
-		       "rc = [%d]\n", rc);
-		set_fs(oldfs);
+	if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode, page_virt,
+				       0, PAGE_CACHE_SIZE))) {
+		printk(KERN_ERR "%s: Error attempting to write header "
+		       "information to lower file; rc = [%d]\n", __FUNCTION__,
+		       rc);
 		goto out;
 	}
 	header_pages = ((crypt_stat->extent_size
@@ -1467,18 +1468,19 @@ ecryptfs_write_metadata_to_contents(stru
 	memset(page_virt, 0, PAGE_CACHE_SIZE);
 	current_header_page = 1;
 	while (current_header_page < header_pages) {
-		size = vfs_write(lower_file, (char __user *)page_virt,
-				 PAGE_CACHE_SIZE, &lower_file->f_pos);
-		if (size < 0) {
-			rc = (int)size;
-			printk(KERN_ERR "Error attempting to write lower page; "
-			       "rc = [%d]\n", rc);
-			set_fs(oldfs);
+		loff_t offset;
+
+		offset = (current_header_page << PAGE_CACHE_SHIFT);
+		if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode,
+					       page_virt, offset,
+					       PAGE_CACHE_SIZE))) {
+			printk(KERN_ERR "%s: Error attempting to write header "
+			       "information to lower file; rc = [%d]\n",
+			       __FUNCTION__, rc);
 			goto out;
 		}
 		current_header_page++;
 	}
-	set_fs(oldfs);
 out:
 	return rc;
 }
@@ -1498,7 +1500,6 @@ ecryptfs_write_metadata_to_xattr(struct 
 /**
  * ecryptfs_write_metadata
  * @ecryptfs_dentry: The eCryptfs dentry
- * @lower_file: The lower file struct, which was returned from dentry_open
  *
  * Write the file headers out.  This will likely involve a userspace
  * callout, in which the session key is encrypted with one or more
@@ -1506,22 +1507,21 @@ ecryptfs_write_metadata_to_xattr(struct 
  * retrieved via a prompt.  Exactly what happens at this point should
  * be policy-dependent.
  *
+ * TODO: Support header information spanning multiple pages
+ *
  * Returns zero on success; non-zero on error
  */
-int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry,
-			    struct file *lower_file)
+int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry)
 {
-	struct ecryptfs_crypt_stat *crypt_stat;
+	struct ecryptfs_crypt_stat *crypt_stat =
+		&ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->crypt_stat;
 	char *page_virt;
-	size_t size;
+	size_t size = 0;
 	int rc = 0;
 
-	crypt_stat = &ecryptfs_inode_to_private(
-		ecryptfs_dentry->d_inode)->crypt_stat;
 	if (likely(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
 		if (!(crypt_stat->flags & ECRYPTFS_KEY_VALID)) {
-			ecryptfs_printk(KERN_DEBUG, "Key is "
-					"invalid; bailing out\n");
+			printk(KERN_ERR "Key is invalid; bailing out\n");
 			rc = -EINVAL;
 			goto out;
 		}
@@ -1550,7 +1550,8 @@ int ecryptfs_write_metadata(struct dentr
 						      crypt_stat, page_virt,
 						      size);
 	else
-		rc = ecryptfs_write_metadata_to_contents(crypt_stat, lower_file,
+		rc = ecryptfs_write_metadata_to_contents(crypt_stat,
+							 ecryptfs_dentry,
 							 page_virt);
 	if (rc) {
 		printk(KERN_ERR "Error writing metadata out to lower file; "
@@ -1678,15 +1679,17 @@ out:
  *
  * Returns zero on success; non-zero on error
  */
-int ecryptfs_read_xattr_region(char *page_virt, struct dentry *ecryptfs_dentry)
+int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_inode)
 {
+	struct dentry *lower_dentry =
+		ecryptfs_inode_to_private(ecryptfs_inode)->lower_file->f_dentry;
 	ssize_t size;
 	int rc = 0;
 
-	size = ecryptfs_getxattr(ecryptfs_dentry, ECRYPTFS_XATTR_NAME,
-				 page_virt, ECRYPTFS_DEFAULT_EXTENT_SIZE);
+	size = ecryptfs_getxattr_lower(lower_dentry, ECRYPTFS_XATTR_NAME,
+				       page_virt, ECRYPTFS_DEFAULT_EXTENT_SIZE);
 	if (size < 0) {
-		printk(KERN_DEBUG "Error attempting to read the [%s] "
+		printk(KERN_ERR "Error attempting to read the [%s] "
 		       "xattr from the lower file; return value = [%zd]\n",
 		       ECRYPTFS_XATTR_NAME, size);
 		rc = -EINVAL;
@@ -1701,7 +1704,7 @@ int ecryptfs_read_and_validate_xattr_reg
 {
 	int rc;
 
-	rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_dentry);
+	rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_dentry->d_inode);
 	if (rc)
 		goto out;
 	if (!contains_ecryptfs_marker(page_virt	+ ECRYPTFS_FILE_SIZE_BYTES)) {
@@ -1715,8 +1718,6 @@ out:
 
 /**
  * ecryptfs_read_metadata
- * @ecryptfs_dentry: The eCryptfs dentry
- * @lower_file: The lower file from which to read the metadata
  *
  * Common entry point for reading file metadata. From here, we could
  * retrieve the header information from the header region of the file,
@@ -1727,15 +1728,13 @@ out:
  *
  * Returns zero if valid headers found and parsed; non-zero otherwise
  */
-int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry,
-			   struct file *lower_file)
+int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 {
 	int rc = 0;
 	char *page_virt = NULL;
-	mm_segment_t oldfs;
-	ssize_t bytes_read;
+	struct inode *ecryptfs_inode = ecryptfs_dentry->d_inode;
 	struct ecryptfs_crypt_stat *crypt_stat =
-	    &ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->crypt_stat;
+	    &ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
 		&ecryptfs_superblock_to_private(
 			ecryptfs_dentry->d_sb)->mount_crypt_stat;
@@ -1746,27 +1745,18 @@ int ecryptfs_read_metadata(struct dentry
 	page_virt = kmem_cache_alloc(ecryptfs_header_cache_1, GFP_USER);
 	if (!page_virt) {
 		rc = -ENOMEM;
-		ecryptfs_printk(KERN_ERR, "Unable to allocate page_virt\n");
+		printk(KERN_ERR "%s: Unable to allocate page_virt\n",
+		       __FUNCTION__);
 		goto out;
 	}
-	lower_file->f_pos = 0;
-	oldfs = get_fs();
-	set_fs(get_ds());
-	bytes_read = lower_file->f_op->read(lower_file,
-					    (char __user *)page_virt,
-					    ECRYPTFS_DEFAULT_EXTENT_SIZE,
-					    &lower_file->f_pos);
-	set_fs(oldfs);
-	if (bytes_read != ECRYPTFS_DEFAULT_EXTENT_SIZE) {
-		rc = -EINVAL;
-		goto out;
-	}
-	rc = ecryptfs_read_headers_virt(page_virt, crypt_stat,
-					ecryptfs_dentry,
-					ECRYPTFS_VALIDATE_HEADER_SIZE);
+	rc = ecryptfs_read_lower(page_virt, 0, crypt_stat->extent_size,
+				 ecryptfs_inode);
+	if (!rc)
+		rc = ecryptfs_read_headers_virt(page_virt, crypt_stat,
+						ecryptfs_dentry,
+						ECRYPTFS_VALIDATE_HEADER_SIZE);
 	if (rc) {
-		rc = ecryptfs_read_xattr_region(page_virt,
-						ecryptfs_dentry);
+		rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
 			       "file header region or xattr region\n");
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-update-metadata-read-write-functions fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-update-metadata-read-write-functions
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -570,13 +570,11 @@ int ecryptfs_writepage_and_release_lower
 					      struct writeback_control *wbc);
 int ecryptfs_encrypt_page(struct page *page);
 int ecryptfs_decrypt_page(struct page *page);
-int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry,
-			    struct file *lower_file);
-int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry,
-			   struct file *lower_file);
+int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry);
+int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry);
 int ecryptfs_new_file_context(struct dentry *ecryptfs_dentry);
-int ecryptfs_read_and_validate_header_region(char *data, struct dentry *dentry,
-					     struct vfsmount *mnt);
+int ecryptfs_read_and_validate_header_region(char *data,
+					     struct inode *ecryptfs_inode);
 int ecryptfs_read_and_validate_xattr_region(char *page_virt,
 					    struct dentry *ecryptfs_dentry);
 u16 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat);
@@ -599,10 +597,13 @@ int ecryptfs_open_lower_file(struct file
 int ecryptfs_close_lower_file(struct file *lower_file);
 ssize_t ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
 			  size_t size);
+ssize_t
+ecryptfs_getxattr_lower(struct dentry *lower_dentry, const char *name,
+			void *value, size_t size);
 int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		  size_t size, int flags);
-int ecryptfs_read_xattr_region(char *page_virt, struct dentry *ecryptfs_dentry);
+int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_inode);
 int ecryptfs_process_helo(unsigned int transport, uid_t uid, pid_t pid);
 int ecryptfs_process_quit(uid_t uid, pid_t pid);
 int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t uid,
diff -puN fs/ecryptfs/file.c~ecryptfs-update-metadata-read-write-functions fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-update-metadata-read-write-functions
+++ a/fs/ecryptfs/file.c
@@ -248,7 +248,7 @@ static int ecryptfs_open(struct inode *i
 	mutex_lock(&crypt_stat->cs_mutex);
 	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
 	    || !(crypt_stat->flags & ECRYPTFS_KEY_VALID)) {
-		rc = ecryptfs_read_metadata(ecryptfs_dentry, lower_file);
+		rc = ecryptfs_read_metadata(ecryptfs_dentry);
 		if (rc) {
 			ecryptfs_printk(KERN_DEBUG,
 					"Valid headers not found\n");
diff -puN fs/ecryptfs/inode.c~ecryptfs-update-metadata-read-write-functions fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-update-metadata-read-write-functions
+++ a/fs/ecryptfs/inode.c
@@ -153,37 +153,30 @@ out:
 
 /**
  * grow_file
- * @ecryptfs_dentry: the ecryptfs dentry
- * @lower_file: The lower file
- * @inode: The ecryptfs inode
- * @lower_inode: The lower inode
+ * @ecryptfs_dentry: the eCryptfs dentry
  *
  * This is the code which will grow the file to its correct size.
  */
-static int grow_file(struct dentry *ecryptfs_dentry, struct file *lower_file,
-		     struct inode *inode, struct inode *lower_inode)
+static int grow_file(struct dentry *ecryptfs_dentry)
 {
-	int rc = 0;
+	struct inode *ecryptfs_inode = ecryptfs_dentry->d_inode;
 	struct file fake_file;
 	struct ecryptfs_file_info tmp_file_info;
+	char zero_virt[] = { 0x00 };
+	int rc = 0;
 
 	memset(&fake_file, 0, sizeof(fake_file));
 	fake_file.f_path.dentry = ecryptfs_dentry;
 	memset(&tmp_file_info, 0, sizeof(tmp_file_info));
 	ecryptfs_set_file_private(&fake_file, &tmp_file_info);
-	ecryptfs_set_file_lower(&fake_file, lower_file);
-	rc = ecryptfs_fill_zeros(&fake_file, 1);
-	if (rc) {
-		ecryptfs_inode_to_private(inode)->crypt_stat.flags |=
-			ECRYPTFS_SECURITY_WARNING;
-		ecryptfs_printk(KERN_WARNING, "Error attempting to fill zeros "
-				"in file; rc = [%d]\n", rc);
-		goto out;
-	}
-	i_size_write(inode, 0);
-	rc = ecryptfs_write_inode_size_to_metadata(inode);
-	ecryptfs_inode_to_private(inode)->crypt_stat.flags |= ECRYPTFS_NEW_FILE;
-out:
+	ecryptfs_set_file_lower(
+		&fake_file,
+		ecryptfs_inode_to_private(ecryptfs_inode)->lower_file);
+	rc = ecryptfs_write(&fake_file, zero_virt, 0, 1);
+	i_size_write(ecryptfs_inode, 0);
+	rc = ecryptfs_write_inode_size_to_metadata(ecryptfs_inode);
+	ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat.flags |=
+		ECRYPTFS_NEW_FILE;
 	return rc;
 }
 
@@ -197,53 +190,31 @@ out:
  */
 static int ecryptfs_initialize_file(struct dentry *ecryptfs_dentry)
 {
+	struct ecryptfs_crypt_stat *crypt_stat =
+		&ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->crypt_stat;
 	int rc = 0;
-	int lower_flags;
-	struct ecryptfs_crypt_stat *crypt_stat;
-	struct dentry *lower_dentry;
-	struct file *lower_file;
-	struct inode *inode, *lower_inode;
-	struct vfsmount *lower_mnt;
 
-	lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
-	ecryptfs_printk(KERN_DEBUG, "lower_dentry->d_name.name = [%s]\n",
-			lower_dentry->d_name.name);
-	inode = ecryptfs_dentry->d_inode;
-	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
-	lower_flags = ((O_CREAT | O_TRUNC) & O_ACCMODE) | O_RDWR;
-	lower_mnt = ecryptfs_dentry_to_lower_mnt(ecryptfs_dentry);
-	/* Corresponding fput() at end of this function */
-	rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
-				      lower_flags);
-	if (rc) {
-		ecryptfs_printk(KERN_ERR,
-				"Error opening dentry; rc = [%i]\n", rc);
-		goto out;
-	}
-	lower_inode = lower_dentry->d_inode;
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
 		ecryptfs_printk(KERN_DEBUG, "This is a directory\n");
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
-		goto out_fput;
+		goto out;
 	}
 	crypt_stat->flags |= ECRYPTFS_NEW_FILE;
 	ecryptfs_printk(KERN_DEBUG, "Initializing crypto context\n");
 	rc = ecryptfs_new_file_context(ecryptfs_dentry);
 	if (rc) {
-		ecryptfs_printk(KERN_DEBUG, "Error creating new file "
-				"context\n");
-		goto out_fput;
+		ecryptfs_printk(KERN_ERR, "Error creating new file "
+				"context; rc = [%d]\n", rc);
+		goto out;
 	}
-	rc = ecryptfs_write_metadata(ecryptfs_dentry, lower_file);
+	rc = ecryptfs_write_metadata(ecryptfs_dentry);
 	if (rc) {
-		ecryptfs_printk(KERN_DEBUG, "Error writing headers\n");
-		goto out_fput;
+		printk(KERN_ERR "Error writing headers; rc = [%d]\n", rc);
+		goto out;
 	}
-	rc = grow_file(ecryptfs_dentry, lower_file, inode, lower_inode);
-out_fput:
-	rc = ecryptfs_close_lower_file(lower_file);
+	rc = grow_file(ecryptfs_dentry);
 	if (rc)
-		printk(KERN_ERR "Error closing lower_file\n");
+		printk(KERN_ERR "Error growing file; rc = [%d]\n", rc);
 out:
 	return rc;
 }
@@ -389,8 +360,8 @@ static struct dentry *ecryptfs_lookup(st
 	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
 	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED))
 		ecryptfs_set_default_sizes(crypt_stat);
-	rc = ecryptfs_read_and_validate_header_region(page_virt, lower_dentry,
-						      nd->mnt);
+	rc = ecryptfs_read_and_validate_header_region(page_virt,
+						      dentry->d_inode);
 	if (rc) {
 		rc = ecryptfs_read_and_validate_xattr_region(page_virt, dentry);
 		if (rc) {
@@ -941,7 +912,7 @@ static int ecryptfs_setattr(struct dentr
 		}
 		mount_crypt_stat = &ecryptfs_superblock_to_private(
 			dentry->d_sb)->mount_crypt_stat;
-		rc = ecryptfs_read_metadata(dentry, lower_file);
+		rc = ecryptfs_read_metadata(dentry);
 		if (rc) {
 			if (!(mount_crypt_stat->flags
 			      & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)) {
@@ -1003,6 +974,24 @@ out:
 }
 
 ssize_t
+ecryptfs_getxattr_lower(struct dentry *lower_dentry, const char *name,
+			void *value, size_t size)
+{
+	int rc = 0;
+
+	if (!lower_dentry->d_inode->i_op->getxattr) {
+		rc = -ENOSYS;
+		goto out;
+	}
+	mutex_lock(&lower_dentry->d_inode->i_mutex);
+	rc = lower_dentry->d_inode->i_op->getxattr(lower_dentry, name, value,
+						   size);
+	mutex_unlock(&lower_dentry->d_inode->i_mutex);
+out:
+	return rc;
+}
+
+ssize_t
 ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
 		  size_t size)
 {
diff -puN fs/ecryptfs/mmap.c~ecryptfs-update-metadata-read-write-functions fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-update-metadata-read-write-functions
+++ a/fs/ecryptfs/mmap.c
@@ -307,7 +307,7 @@ static int ecryptfs_readpage(struct file
 				memset(page_virt, 0, PAGE_CACHE_SIZE);
 				if (page->index == 0) {
 					rc = ecryptfs_read_xattr_region(
-						page_virt, file->f_path.dentry);
+						page_virt, page->mapping->host);
 					set_header_info(page_virt, crypt_stat);
 				}
 				kunmap_atomic(page_virt, KM_USER0);
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
ecryptfs-add-key-list-structure-search-keyring.patch
ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
ecryptfs-fix-tag-1-parsing-code.patch
ecryptfs-fix-tag-3-parsing-code.patch
ecryptfs-fix-tag-11-parsing-code.patch
ecryptfs-fix-tag-11-writing-code.patch
ecryptfs-update-comment-and-debug-statement.patch
ecryptfs-printk-warning-fixes.patch
ecryptfs-remove-unnecessary-bug_on.patch
ecryptfs-collapse-flag-set-into-one-statement.patch
ecryptfs-grammatical-fix-destruct-to-destroy.patch
ecryptfs-comments-for-some-structs.patch
ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec.patch
ecryptfs-remove-unnecessary-variable-initializations.patch
ecryptfs-make-needlessly-global-symbols-static.patch
ecryptfs-use-generic_file_splice_read.patch
ecryptfs-remove-header_extent_size.patch
ecryptfs-remove-assignments-in-if-statements.patch
ecryptfs-read_writec-routines.patch
ecryptfs-replace-encrypt-decrypt-and-inode-size-write.patch
ecryptfs-set-up-and-destroy-persistent-lower-file.patch
ecryptfs-update-metadata-read-write-functions.patch
ecryptfs-make-open-truncate-and-setattr-use-persistent-file.patch
ecryptfs-convert-mmap-functions-to-use-persistent-file.patch
ecryptfs-initialize-persistent-lower-file-on-inode-create.patch
ecryptfs-remove-unused-functions-and-kmem_cache.patch
ecryptfs-replace-magic-numbers.patch
