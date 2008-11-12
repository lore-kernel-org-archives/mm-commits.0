From: akpm@linux-foundation.org
Subject: + ecryptfs-filename-encryption-filldir-lookup-and-readlink.patch added to -mm tree
Date: Wed, 12 Nov 2008 11:46:01 -0800
Message-ID: <200811121946.mACJk1Tc008687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbYKLTqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 14:46:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, dustin.kirkland@gmail.com, sandeen@redhat.com, shaggy@us.ibm.com, tchicks@us.ibm.com


The patch titled
     eCryptfs: Filename Encryption: filldir, lookup, and readlink
has been added to the -mm tree.  Its filename is
     ecryptfs-filename-encryption-filldir-lookup-and-readlink.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Filename Encryption: filldir, lookup, and readlink
From: Michael Halcrow <mhalcrow@us.ibm.com>

Make the requisite modifications to ecryptfs_filldir(), ecryptfs_lookup(),
and ecryptfs_readlink() to call out to filename encryption functions. 
Propagate filename encryption policy flags from mount-wide crypt_stat to
inode crypt_stat.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dustin Kirkland <dustin.kirkland@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Tyler Hicks <tchicks@us.ibm.com>
Cc: David Kleikamp <shaggy@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |  107 +----------
 fs/ecryptfs/ecryptfs_kernel.h |    6 
 fs/ecryptfs/file.c            |   30 +--
 fs/ecryptfs/inode.c           |  294 ++++++++++++++++++--------------
 4 files changed, 195 insertions(+), 242 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-filename-encryption-filldir-lookup-and-readlink fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-filename-encryption-filldir-lookup-and-readlink
+++ a/fs/ecryptfs/crypto.c
@@ -924,6 +924,15 @@ static void ecryptfs_copy_mount_wide_fla
 		crypt_stat->flags |= ECRYPTFS_METADATA_IN_XATTR;
 	if (mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
 		crypt_stat->flags |= ECRYPTFS_VIEW_AS_ENCRYPTED;
+	if (mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES) {
+		crypt_stat->flags |= ECRYPTFS_ENCRYPT_FILENAMES;
+		if (mount_crypt_stat->flags
+		    & ECRYPTFS_GLOBAL_ENCFN_USE_MOUNT_FNEK)
+			crypt_stat->flags |= ECRYPTFS_ENCFN_USE_MOUNT_FNEK;
+		else if (mount_crypt_stat->flags
+			 & ECRYPTFS_GLOBAL_ENCFN_USE_FEK)
+			crypt_stat->flags |= ECRYPTFS_ENCFN_USE_FEK;
+	}
 }
 
 static int ecryptfs_copy_mount_wide_sigs_to_inode_sigs(
@@ -1060,7 +1069,8 @@ struct ecryptfs_flag_map_elem {
 static struct ecryptfs_flag_map_elem ecryptfs_flag_map[] = {
 	{0x00000001, ECRYPTFS_ENABLE_HMAC},
 	{0x00000002, ECRYPTFS_ENCRYPTED},
-	{0x00000004, ECRYPTFS_METADATA_IN_XATTR}
+	{0x00000004, ECRYPTFS_METADATA_IN_XATTR},
+	{0x00000008, ECRYPTFS_ENCRYPT_FILENAMES}
 };
 
 /**
@@ -1213,6 +1223,8 @@ int ecryptfs_read_and_validate_header_re
 		&(ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat);
 	int rc;
 
+	if (crypt_stat->extent_size == 0)
+		crypt_stat->extent_size = ECRYPTFS_DEFAULT_EXTENT_SIZE;
 	rc = ecryptfs_read_lower(data, 0, crypt_stat->extent_size,
 				 ecryptfs_inode);
 	if (rc) {
@@ -1222,7 +1234,6 @@ int ecryptfs_read_and_validate_header_re
 	}
 	if (!contains_ecryptfs_marker(data + ECRYPTFS_FILE_SIZE_BYTES)) {
 		rc = -EINVAL;
-		ecryptfs_printk(KERN_DEBUG, "Valid marker not found\n");
 	}
 out:
 	return rc;
@@ -1629,98 +1640,6 @@ out:
 }
 
 /**
- * ecryptfs_encode_filename - converts a plaintext file name to cipher text
- * @crypt_stat: The crypt_stat struct associated with the file anem to encode
- * @name: The plaintext name
- * @length: The length of the plaintext
- * @encoded_name: The encypted name
- *
- * Encrypts and encodes a filename into something that constitutes a
- * valid filename for a filesystem, with printable characters.
- *
- * We assume that we have a properly initialized crypto context,
- * pointed to by crypt_stat->tfm.
- *
- * TODO: Implement filename decoding and decryption here, in place of
- * memcpy. We are keeping the framework around for now to (1)
- * facilitate testing of the components needed to implement filename
- * encryption and (2) to provide a code base from which other
- * developers in the community can easily implement this feature.
- *
- * Returns the length of encoded filename; negative if error
- */
-int
-ecryptfs_encode_filename(struct ecryptfs_crypt_stat *crypt_stat,
-			 const char *name, int length, char **encoded_name)
-{
-	int error = 0;
-
-	(*encoded_name) = kmalloc(length + 2, GFP_KERNEL);
-	if (!(*encoded_name)) {
-		error = -ENOMEM;
-		goto out;
-	}
-	/* TODO: Filename encryption is a scheduled feature for a
-	 * future version of eCryptfs. This function is here only for
-	 * the purpose of providing a framework for other developers
-	 * to easily implement filename encryption. Hint: Replace this
-	 * memcpy() with a call to encrypt and encode the
-	 * filename, the set the length accordingly. */
-	memcpy((void *)(*encoded_name), (void *)name, length);
-	(*encoded_name)[length] = '\0';
-	error = length + 1;
-out:
-	return error;
-}
-
-/**
- * ecryptfs_decode_filename - converts the cipher text name to plaintext
- * @crypt_stat: The crypt_stat struct associated with the file
- * @name: The filename in cipher text
- * @length: The length of the cipher text name
- * @decrypted_name: The plaintext name
- *
- * Decodes and decrypts the filename.
- *
- * We assume that we have a properly initialized crypto context,
- * pointed to by crypt_stat->tfm.
- *
- * TODO: Implement filename decoding and decryption here, in place of
- * memcpy. We are keeping the framework around for now to (1)
- * facilitate testing of the components needed to implement filename
- * encryption and (2) to provide a code base from which other
- * developers in the community can easily implement this feature.
- *
- * Returns the length of decoded filename; negative if error
- */
-int
-ecryptfs_decode_filename(struct ecryptfs_crypt_stat *crypt_stat,
-			 const char *name, int length, char **decrypted_name)
-{
-	int error = 0;
-
-	(*decrypted_name) = kmalloc(length + 2, GFP_KERNEL);
-	if (!(*decrypted_name)) {
-		error = -ENOMEM;
-		goto out;
-	}
-	/* TODO: Filename encryption is a scheduled feature for a
-	 * future version of eCryptfs. This function is here only for
-	 * the purpose of providing a framework for other developers
-	 * to easily implement filename encryption. Hint: Replace this
-	 * memcpy() with a call to decode and decrypt the
-	 * filename, the set the length accordingly. */
-	memcpy((void *)(*decrypted_name), (void *)name, length);
-	(*decrypted_name)[length + 1] = '\0';	/* Only for convenience
-						 * in printing out the
-						 * string in debug
-						 * messages */
-	error = length;
-out:
-	return error;
-}
-
-/**
  * ecryptfs_encrypt_filename - encrypt filename
  *
  * CBC-encrypts the filename. We do not want to encrypt the same
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-filename-encryption-filldir-lookup-and-readlink fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-filename-encryption-filldir-lookup-and-readlink
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -627,12 +627,6 @@ int ecryptfs_decode_and_decrypt_filename
 					 struct dentry *ecryptfs_dentry,
 					 const char *name, size_t name_size);
 int ecryptfs_fill_zeros(struct file *file, loff_t new_length);
-int ecryptfs_decode_filename(struct ecryptfs_crypt_stat *crypt_stat,
-			     const char *name, int length,
-			     char **decrypted_name);
-int ecryptfs_encode_filename(struct ecryptfs_crypt_stat *crypt_stat,
-			     const char *name, int length,
-			     char **encoded_name);
 int ecryptfs_encrypt_and_encode_filename(
 	char **encoded_name,
 	size_t *encoded_name_size,
diff -puN fs/ecryptfs/file.c~ecryptfs-filename-encryption-filldir-lookup-and-readlink fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-filename-encryption-filldir-lookup-and-readlink
+++ a/fs/ecryptfs/file.c
@@ -77,27 +77,27 @@ struct ecryptfs_getdents_callback {
 
 /* Inspired by generic filldir in fs/readdir.c */
 static int
-ecryptfs_filldir(void *dirent, const char *name, int namelen, loff_t offset,
-		 u64 ino, unsigned int d_type)
+ecryptfs_filldir(void *dirent, const char *lower_name, int lower_namelen,
+		 loff_t offset, u64 ino, unsigned int d_type)
 {
-	struct ecryptfs_crypt_stat *crypt_stat;
 	struct ecryptfs_getdents_callback *buf =
 	    (struct ecryptfs_getdents_callback *)dirent;
+	int name_size;
+	char *name;
 	int rc;
-	int decoded_length;
-	char *decoded_name;
 
-	crypt_stat = ecryptfs_dentry_to_private(buf->dentry)->crypt_stat;
 	buf->filldir_called++;
-	decoded_length = ecryptfs_decode_filename(crypt_stat, name, namelen,
-						  &decoded_name);
-	if (decoded_length < 0) {
-		rc = decoded_length;
+	rc = ecryptfs_decode_and_decrypt_filename(&name, &name_size,
+						  buf->dentry, lower_name,
+						  lower_namelen);
+	if (rc) {
+		printk(KERN_ERR "%s: Error attempting to decode and decrypt "
+		       "filename [%s]; rc = [%d]\n", __func__, lower_name,
+		       rc);
 		goto out;
 	}
-	rc = buf->filldir(buf->dirent, decoded_name, decoded_length, offset,
-			  ino, d_type);
-	kfree(decoded_name);
+	rc = buf->filldir(buf->dirent, name, name_size, offset, ino, d_type);
+	kfree(name);
 	if (rc >= 0)
 		buf->entries_written++;
 out:
@@ -106,8 +106,8 @@ out:
 
 /**
  * ecryptfs_readdir
- * @file: The ecryptfs file struct
- * @dirent: Directory entry
+ * @file: The eCryptfs directory file
+ * @dirent: Directory entry handle
  * @filldir: The filldir callback function
  */
 static int ecryptfs_readdir(struct file *file, void *dirent, filldir_t filldir)
diff -puN fs/ecryptfs/inode.c~ecryptfs-filename-encryption-filldir-lookup-and-readlink fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-filename-encryption-filldir-lookup-and-readlink
+++ a/fs/ecryptfs/inode.c
@@ -228,8 +228,7 @@ ecryptfs_create(struct inode *directory_
 {
 	int rc;
 
-	/* ecryptfs_do_create() calls ecryptfs_interpose(), which opens
-	 * the crypt_stat->lower_file (persistent file) */
+	/* ecryptfs_do_create() calls ecryptfs_interpose() */
 	rc = ecryptfs_do_create(directory_inode, ecryptfs_dentry, mode, nd);
 	if (unlikely(rc)) {
 		ecryptfs_printk(KERN_WARNING, "Failed to create file in"
@@ -244,141 +243,91 @@ out:
 }
 
 /**
- * ecryptfs_lookup
- * @dir: inode
- * @dentry: The dentry
- * @nd: nameidata, may be NULL
- *
- * Find a file on disk. If the file does not exist, then we'll add it to the
- * dentry cache and continue on to read it from the disk.
+ * ecryptfs_lookup_and_interpose_lower - Perform a lookup
  */
-static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
-				      struct nameidata *nd)
+int ecryptfs_lookup_and_interpose_lower(struct dentry *ecryptfs_dentry,
+					struct dentry *lower_dentry,
+					struct ecryptfs_crypt_stat *crypt_stat,
+					struct inode *ecryptfs_dir_inode,
+					struct nameidata *ecryptfs_nd)
 {
-	int rc = 0;
 	struct dentry *lower_dir_dentry;
-	struct dentry *lower_dentry;
 	struct vfsmount *lower_mnt;
-	char *encoded_name;
-	int encoded_namelen;
-	struct ecryptfs_crypt_stat *crypt_stat = NULL;
+	struct inode *lower_inode;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
 	char *page_virt = NULL;
-	struct inode *lower_inode;
 	u64 file_size;
+	int rc = 0;
 
-	lower_dir_dentry = ecryptfs_dentry_to_lower(dentry->d_parent);
-	dentry->d_op = &ecryptfs_dops;
-	if ((dentry->d_name.len == 1 && !strcmp(dentry->d_name.name, "."))
-	    || (dentry->d_name.len == 2
-		&& !strcmp(dentry->d_name.name, ".."))) {
-		d_drop(dentry);
-		goto out;
-	}
-	encoded_namelen = ecryptfs_encode_filename(crypt_stat,
-						   dentry->d_name.name,
-						   dentry->d_name.len,
-						   &encoded_name);
-	if (encoded_namelen < 0) {
-		rc = encoded_namelen;
-		d_drop(dentry);
-		goto out;
-	}
-	ecryptfs_printk(KERN_DEBUG, "encoded_name = [%s]; encoded_namelen "
-			"= [%d]\n", encoded_name, encoded_namelen);
-	lower_dentry = lookup_one_len(encoded_name, lower_dir_dentry,
-				      encoded_namelen - 1);
-	kfree(encoded_name);
-	if (IS_ERR(lower_dentry)) {
-		ecryptfs_printk(KERN_ERR, "ERR from lower_dentry\n");
-		rc = PTR_ERR(lower_dentry);
-		d_drop(dentry);
-		goto out;
-	}
-	lower_mnt = mntget(ecryptfs_dentry_to_lower_mnt(dentry->d_parent));
-	ecryptfs_printk(KERN_DEBUG, "lower_dentry = [%p]; lower_dentry->"
-       		"d_name.name = [%s]\n", lower_dentry,
-		lower_dentry->d_name.name);
+	lower_dir_dentry = lower_dentry->d_parent;
+	lower_mnt = mntget(ecryptfs_dentry_to_lower_mnt(
+				   ecryptfs_dentry->d_parent));
 	lower_inode = lower_dentry->d_inode;
-	fsstack_copy_attr_atime(dir, lower_dir_dentry->d_inode);
+	fsstack_copy_attr_atime(ecryptfs_dir_inode, lower_dir_dentry->d_inode);
 	BUG_ON(!atomic_read(&lower_dentry->d_count));
-	ecryptfs_set_dentry_private(dentry,
+	ecryptfs_set_dentry_private(ecryptfs_dentry,
 				    kmem_cache_alloc(ecryptfs_dentry_info_cache,
 						     GFP_KERNEL));
-	if (!ecryptfs_dentry_to_private(dentry)) {
+	if (!ecryptfs_dentry_to_private(ecryptfs_dentry)) {
 		rc = -ENOMEM;
-		ecryptfs_printk(KERN_ERR, "Out of memory whilst attempting "
-				"to allocate ecryptfs_dentry_info struct\n");
+		printk(KERN_ERR "%s: Out of memory whilst attempting "
+		       "to allocate ecryptfs_dentry_info struct\n",
+			__func__);
 		goto out_dput;
 	}
-	ecryptfs_set_dentry_lower(dentry, lower_dentry);
-	ecryptfs_set_dentry_lower_mnt(dentry, lower_mnt);
+	ecryptfs_set_dentry_lower(ecryptfs_dentry, lower_dentry);
+	ecryptfs_set_dentry_lower_mnt(ecryptfs_dentry, lower_mnt);
 	if (!lower_dentry->d_inode) {
 		/* We want to add because we couldn't find in lower */
-		d_add(dentry, NULL);
+		d_add(ecryptfs_dentry, NULL);
 		goto out;
 	}
-	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb,
-				ECRYPTFS_INTERPOSE_FLAG_D_ADD);
+	rc = ecryptfs_interpose(lower_dentry, ecryptfs_dentry,
+				ecryptfs_dir_inode->i_sb, 1);
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error interposing\n");
+		printk(KERN_ERR "%s: Error interposing; rc = [%d]\n",
+		       __func__, rc);
 		goto out;
 	}
-	if (S_ISDIR(lower_inode->i_mode)) {
-		ecryptfs_printk(KERN_DEBUG, "Is a directory; returning\n");
+	if (S_ISDIR(lower_inode->i_mode))
 		goto out;
-	}
-	if (S_ISLNK(lower_inode->i_mode)) {
-		ecryptfs_printk(KERN_DEBUG, "Is a symlink; returning\n");
+	if (S_ISLNK(lower_inode->i_mode))
 		goto out;
-	}
-	if (special_file(lower_inode->i_mode)) {
-		ecryptfs_printk(KERN_DEBUG, "Is a special file; returning\n");
+	if (special_file(lower_inode->i_mode))
 		goto out;
-	}
-	if (!nd) {
-		ecryptfs_printk(KERN_DEBUG, "We have a NULL nd, just leave"
-				"as we *think* we are about to unlink\n");
+	if (!ecryptfs_nd)
 		goto out;
-	}
 	/* Released in this function */
-	page_virt = kmem_cache_zalloc(ecryptfs_header_cache_2,
-				      GFP_USER);
+	page_virt = kmem_cache_zalloc(ecryptfs_header_cache_2, GFP_USER);
 	if (!page_virt) {
+		printk(KERN_ERR "%s: Cannot kmem_cache_zalloc() a page\n",
+		       __func__);
 		rc = -ENOMEM;
-		ecryptfs_printk(KERN_ERR,
-				"Cannot ecryptfs_kmalloc a page\n");
 		goto out;
 	}
-	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
-	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED))
-		ecryptfs_set_default_sizes(crypt_stat);
-	if (!ecryptfs_inode_to_private(dentry->d_inode)->lower_file) {
-		rc = ecryptfs_init_persistent_file(dentry);
+	if (!ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->lower_file) {
+		rc = ecryptfs_init_persistent_file(ecryptfs_dentry);
 		if (rc) {
 			printk(KERN_ERR "%s: Error attempting to initialize "
 			       "the persistent file for the dentry with name "
 			       "[%s]; rc = [%d]\n", __func__,
-			       dentry->d_name.name, rc);
-			goto out;
+			       ecryptfs_dentry->d_name.name, rc);
+			goto out_free_kmem;
 		}
 	}
 	rc = ecryptfs_read_and_validate_header_region(page_virt,
-						      dentry->d_inode);
+						      ecryptfs_dentry->d_inode);
 	if (rc) {
-		rc = ecryptfs_read_and_validate_xattr_region(page_virt, dentry);
+		rc = ecryptfs_read_and_validate_xattr_region(page_virt,
+							     ecryptfs_dentry);
 		if (rc) {
-			printk(KERN_DEBUG "Valid metadata not found in header "
-			       "region or xattr region; treating file as "
-			       "unencrypted\n");
 			rc = 0;
-			kmem_cache_free(ecryptfs_header_cache_2, page_virt);
-			goto out;
+			goto out_free_kmem;
 		}
 		crypt_stat->flags |= ECRYPTFS_METADATA_IN_XATTR;
 	}
 	mount_crypt_stat = &ecryptfs_superblock_to_private(
-		dentry->d_sb)->mount_crypt_stat;
+		ecryptfs_dentry->d_sb)->mount_crypt_stat;
 	if (mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED) {
 		if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
 			file_size = (crypt_stat->num_header_bytes_at_front
@@ -388,14 +337,103 @@ static struct dentry *ecryptfs_lookup(st
 	} else {
 		file_size = get_unaligned_be64(page_virt);
 	}
-	i_size_write(dentry->d_inode, (loff_t)file_size);
+	i_size_write(ecryptfs_dentry->d_inode, (loff_t)file_size);
+out_free_kmem:
 	kmem_cache_free(ecryptfs_header_cache_2, page_virt);
 	goto out;
-
 out_dput:
 	dput(lower_dentry);
-	d_drop(dentry);
+	d_drop(ecryptfs_dentry);
 out:
+	return rc;
+}
+
+/**
+ * ecryptfs_lookup
+ * @ecryptfs_dir_inode: The eCryptfs directory inode
+ * @ecryptfs_dentry: The eCryptfs dentry that we are looking up
+ * @ecryptfs_nd: nameidata; may be NULL
+ *
+ * Find a file on disk. If the file does not exist, then we'll add it to the
+ * dentry cache and continue on to read it from the disk.
+ */
+static struct dentry *ecryptfs_lookup(struct inode *ecryptfs_dir_inode,
+				      struct dentry *ecryptfs_dentry,
+				      struct nameidata *ecryptfs_nd)
+{
+	char *encrypted_and_encoded_name = NULL;
+	int encrypted_and_encoded_name_size;
+	struct ecryptfs_crypt_stat *crypt_stat = NULL;
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat = NULL;
+	struct ecryptfs_inode_info *inode_info;
+	struct dentry *lower_dir_dentry, *lower_dentry;
+	int rc = 0;
+
+	ecryptfs_dentry->d_op = &ecryptfs_dops;
+	if ((ecryptfs_dentry->d_name.len == 1
+	     && !strcmp(ecryptfs_dentry->d_name.name, "."))
+	    || (ecryptfs_dentry->d_name.len == 2
+		&& !strcmp(ecryptfs_dentry->d_name.name, ".."))) {
+		goto out_d_drop;
+	}
+	lower_dir_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry->d_parent);
+	lower_dentry = lookup_one_len(ecryptfs_dentry->d_name.name,
+				      lower_dir_dentry,
+				      ecryptfs_dentry->d_name.len);
+	if (IS_ERR(lower_dentry)) {
+		rc = PTR_ERR(lower_dentry);
+		printk(KERN_ERR "%s: lookup_one_len() returned [%d] on "
+		       "lower_dentry = [%s]\n", __func__, rc,
+		       ecryptfs_dentry->d_name.name);
+		goto out_d_drop;
+	}
+	if (lower_dentry->d_inode)
+		goto lookup_and_interpose;
+	inode_info =  ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
+	if (inode_info) {
+		crypt_stat = &inode_info->crypt_stat;
+		/* TODO: lock for crypt_stat comparison */
+		if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED))
+			ecryptfs_set_default_sizes(crypt_stat);
+	}
+	if (crypt_stat)
+		mount_crypt_stat = crypt_stat->mount_crypt_stat;
+	else
+		mount_crypt_stat = &ecryptfs_superblock_to_private(
+			ecryptfs_dentry->d_sb)->mount_crypt_stat;
+	if (!(crypt_stat && (crypt_stat->flags & ECRYPTFS_ENCRYPT_FILENAMES))
+	    && !(mount_crypt_stat && (mount_crypt_stat->flags
+				     & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)))
+		goto lookup_and_interpose;
+	dput(lower_dentry);
+	rc = ecryptfs_encrypt_and_encode_filename(
+		&encrypted_and_encoded_name, &encrypted_and_encoded_name_size,
+		crypt_stat, mount_crypt_stat, ecryptfs_dentry->d_name.name,
+		ecryptfs_dentry->d_name.len);
+	if (rc) {
+		printk(KERN_ERR "%s: Error attempting to encrypt and encode "
+		       "filename; rc = [%d]\n", __func__, rc);
+		goto out_d_drop;
+	}
+	lower_dentry = lookup_one_len(encrypted_and_encoded_name,
+				      lower_dir_dentry,
+				      encrypted_and_encoded_name_size - 1);
+	if (IS_ERR(lower_dentry)) {
+		rc = PTR_ERR(lower_dentry);
+		printk(KERN_ERR "%s: lookup_one_len() returned [%d] on "
+		       "lower_dentry = [%s]\n", __func__, rc,
+		       encrypted_and_encoded_name);
+		goto out_d_drop;
+	}
+lookup_and_interpose:
+	rc = ecryptfs_lookup_and_interpose_lower(ecryptfs_dentry, lower_dentry,
+						 crypt_stat, ecryptfs_dir_inode,
+						 ecryptfs_nd);
+	goto out;
+out_d_drop:
+	d_drop(ecryptfs_dentry);
+out:
+	kfree(encrypted_and_encoded_name);
 	return ERR_PTR(rc);
 }
 
@@ -466,19 +504,21 @@ static int ecryptfs_symlink(struct inode
 	struct dentry *lower_dentry;
 	struct dentry *lower_dir_dentry;
 	char *encoded_symname;
-	int encoded_symlen;
-	struct ecryptfs_crypt_stat *crypt_stat = NULL;
+	size_t encoded_symlen;
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat = NULL;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	dget(lower_dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
-	encoded_symlen = ecryptfs_encode_filename(crypt_stat, symname,
-						  strlen(symname),
-						  &encoded_symname);
-	if (encoded_symlen < 0) {
-		rc = encoded_symlen;
+	mount_crypt_stat = &ecryptfs_superblock_to_private(
+		dir->i_sb)->mount_crypt_stat;
+	rc = ecryptfs_encrypt_and_encode_filename(&encoded_symname,
+						  &encoded_symlen,
+						  NULL,
+						  mount_crypt_stat, symname,
+						  strlen(symname));
+	if (rc)
 		goto out_lock;
-	}
 	rc = vfs_symlink(lower_dir_dentry->d_inode, lower_dentry,
 			 encoded_symname);
 	kfree(encoded_symname);
@@ -602,14 +642,15 @@ out_lock:
 }
 
 static int
-ecryptfs_readlink(struct dentry *dentry, char __user * buf, int bufsiz)
+ecryptfs_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
 {
-	int rc;
-	struct dentry *lower_dentry;
-	char *decoded_name;
 	char *lower_buf;
-	mm_segment_t old_fs;
+	struct dentry *lower_dentry;
 	struct ecryptfs_crypt_stat *crypt_stat;
+	char *plaintext_name;
+	size_t plaintext_name_size;
+	mm_segment_t old_fs;
+	int rc;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	if (!lower_dentry->d_inode->i_op ||
@@ -617,38 +658,39 @@ ecryptfs_readlink(struct dentry *dentry,
 		rc = -EINVAL;
 		goto out;
 	}
+	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
 	/* Released in this function */
 	lower_buf = kmalloc(bufsiz, GFP_KERNEL);
 	if (lower_buf == NULL) {
-		ecryptfs_printk(KERN_ERR, "Out of memory\n");
+		printk(KERN_ERR "%s: Out of memory whilst attempting to "
+		       "kmalloc [%d] bytes\n", __func__, bufsiz);
 		rc = -ENOMEM;
 		goto out;
 	}
 	old_fs = get_fs();
 	set_fs(get_ds());
-	ecryptfs_printk(KERN_DEBUG, "Calling readlink w/ "
-			"lower_dentry->d_name.name = [%s]\n",
-			lower_dentry->d_name.name);
 	rc = lower_dentry->d_inode->i_op->readlink(lower_dentry,
 						   (char __user *)lower_buf,
 						   bufsiz);
 	set_fs(old_fs);
 	if (rc >= 0) {
-		crypt_stat = NULL;
-		rc = ecryptfs_decode_filename(crypt_stat, lower_buf, rc,
-					      &decoded_name);
-		if (rc == -ENOMEM)
+		rc = ecryptfs_decode_and_decrypt_filename(&plaintext_name,
+							  &plaintext_name_size,
+							  dentry, lower_buf,
+							  rc);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to decode and "
+			       "decrypt filename; rc = [%d]\n", __func__,
+				rc);
 			goto out_free_lower_buf;
-		if (rc > 0) {
-			ecryptfs_printk(KERN_DEBUG, "Copying [%d] bytes "
-					"to userspace: [%*s]\n", rc,
-					decoded_name);
-			if (copy_to_user(buf, decoded_name, rc))
-				rc = -EFAULT;
 		}
-		kfree(decoded_name);
-		fsstack_copy_attr_atime(dentry->d_inode,
-					lower_dentry->d_inode);
+		rc = copy_to_user(buf, plaintext_name, plaintext_name_size);
+		if (rc)
+			rc = -EFAULT;
+		else
+			rc = plaintext_name_size;
+		kfree(plaintext_name);
+		fsstack_copy_attr_atime(dentry->d_inode, lower_dentry->d_inode);
 	}
 out_free_lower_buf:
 	kfree(lower_buf);
@@ -670,8 +712,6 @@ static void *ecryptfs_follow_link(struct
 	}
 	old_fs = get_fs();
 	set_fs(get_ds());
-	ecryptfs_printk(KERN_DEBUG, "Calling readlink w/ "
-			"dentry->d_name.name = [%s]\n", dentry->d_name.name);
 	rc = dentry->d_inode->i_op->readlink(dentry, (char __user *)buf, len);
 	buf[rc] = '\0';
 	set_fs(old_fs);
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

linux-next.patch
ecryptfs-filename-encryption-tag-70-packets.patch
ecryptfs-filename-encryption-header-updates.patch
ecryptfs-filename-encryption-encoding-and-encryption-functions.patch
ecryptfs-filename-encryption-filldir-lookup-and-readlink.patch
ecryptfs-filename-encryption-mount-option.patch
ecryptfs-replace-%z-with-%z.patch
ecryptfs-fix-data-types-int-size_t.patch
ecryptfs-kerneldoc-for-ecryptfs_parse_tag_70_packet.patch
ecryptfs-clean-up-ecryptfs_decode_from_filename.patch
notify_change-callers-must-hold-i_mutex.patch

