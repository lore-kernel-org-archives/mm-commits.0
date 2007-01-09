From: akpm@osdl.org
Subject: + ecryptfs-encrypted-passthrough.patch added to -mm tree
Date: Tue, 09 Jan 2007 14:26:58 -0800
Message-ID: <200701092226.l09MQwBM017148@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48895 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460AbXAIWaO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 17:30:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: Encrypted passthrough
has been added to the -mm tree.  Its filename is
     ecryptfs-encrypted-passthrough.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: Encrypted passthrough
From: Michael Halcrow <mhalcrow@us.ibm.com>

Provide an option to provide a view of the encrypted files such that the
metadata is always in the header of the files, regardless of whether the
metadata is actually in the header or in the extended attribute.  This mode of
operation is useful for applications like incremental backup utilities that do
not preserve the extended attributes when directly accessing the lower files.

With this option enabled, the files under the eCryptfs mount point will be
read-only.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/crypto.c          |   15 ++++--
 fs/ecryptfs/ecryptfs_kernel.h |    7 ++-
 fs/ecryptfs/file.c            |   13 ++++-
 fs/ecryptfs/inode.c           |   15 +++++-
 fs/ecryptfs/mmap.c            |   74 +++++++++++++++++++++++++++++++-
 5 files changed, 113 insertions(+), 11 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-encrypted-passthrough fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-encrypted-passthrough
+++ a/fs/ecryptfs/crypto.c
@@ -1258,9 +1258,10 @@ out:
 }
 
 
-static void
-write_header_metadata(char *virt, struct ecryptfs_crypt_stat *crypt_stat,
-		      size_t *written)
+void
+ecryptfs_write_header_metadata(char *virt,
+			       struct ecryptfs_crypt_stat *crypt_stat,
+			       size_t *written)
 {
 	u32 header_extent_size;
 	u16 num_header_extents_at_front;
@@ -1322,7 +1323,8 @@ int ecryptfs_write_headers_virt(char *pa
 	offset += written;
 	write_ecryptfs_flags((page_virt + offset), crypt_stat, &written);
 	offset += written;
-	write_header_metadata((page_virt + offset), crypt_stat, &written);
+	ecryptfs_write_header_metadata((page_virt + offset), crypt_stat,
+				       &written);
 	offset += written;
 	rc = ecryptfs_generate_key_packet_set((page_virt + offset), crypt_stat,
 					      ecryptfs_dentry, &written,
@@ -1608,7 +1610,12 @@ int ecryptfs_read_metadata(struct dentry
 	ssize_t bytes_read;
 	struct ecryptfs_crypt_stat *crypt_stat =
 	    &ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->crypt_stat;
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
+		&ecryptfs_superblock_to_private(
+			ecryptfs_dentry->d_sb)->mount_crypt_stat;
 
+	ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
+						      mount_crypt_stat);
 	/* Read the first page from the underlying file */
 	page_virt = kmem_cache_alloc(ecryptfs_header_cache_1, GFP_USER);
 	if (!page_virt) {
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-encrypted-passthrough fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-encrypted-passthrough
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -578,7 +578,7 @@ ssize_t ecryptfs_getxattr(struct dentry 
 int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		  size_t size, int flags);
-
+int ecryptfs_read_xattr_region(char *page_virt, struct dentry *ecryptfs_dentry);
 int ecryptfs_process_helo(unsigned int transport, uid_t uid, pid_t pid);
 int ecryptfs_process_quit(uid_t uid, pid_t pid);
 int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t uid,
@@ -601,6 +601,9 @@ int ecryptfs_send_connector(char *data, 
 			    u16 msg_flags, pid_t daemon_pid);
 int ecryptfs_init_connector(void);
 void ecryptfs_release_connector(void);
-
+void
+ecryptfs_write_header_metadata(char *virt,
+			       struct ecryptfs_crypt_stat *crypt_stat,
+			       size_t *written);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff -puN fs/ecryptfs/file.c~ecryptfs-encrypted-passthrough fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-encrypted-passthrough
+++ a/fs/ecryptfs/file.c
@@ -250,6 +250,17 @@ static int ecryptfs_open(struct inode *i
 	struct ecryptfs_file_info *file_info;
 	int lower_flags;
 
+	mount_crypt_stat = &ecryptfs_superblock_to_private(
+		ecryptfs_dentry->d_sb)->mount_crypt_stat;
+	if ((mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
+	    && ((file->f_flags & O_WRONLY) || (file->f_flags & O_RDWR)
+		|| (file->f_flags & O_CREAT) || (file->f_flags & O_TRUNC)
+		|| (file->f_flags & O_APPEND))) {
+		printk(KERN_WARNING "Mount has encrypted view enabled; "
+		       "files may only be read\n");
+		rc = -EPERM;
+		goto out;
+	}
 	/* Released in ecryptfs_release or end of function if failure */
 	file_info = kmem_cache_zalloc(ecryptfs_file_info_cache, GFP_KERNEL);
 	ecryptfs_set_file_private(file, file_info);
@@ -261,8 +272,6 @@ static int ecryptfs_open(struct inode *i
 	}
 	lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
 	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
-	mount_crypt_stat = &ecryptfs_superblock_to_private(
-		ecryptfs_dentry->d_sb)->mount_crypt_stat;
 	mutex_lock(&crypt_stat->cs_mutex);
 	if (!ECRYPTFS_CHECK_FLAG(crypt_stat->flags, ECRYPTFS_POLICY_APPLIED)) {
 		ecryptfs_printk(KERN_DEBUG, "Setting flags for stat...\n");
diff -puN fs/ecryptfs/inode.c~ecryptfs-encrypted-passthrough fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-encrypted-passthrough
+++ a/fs/ecryptfs/inode.c
@@ -289,6 +289,7 @@ static struct dentry *ecryptfs_lookup(st
 	char *encoded_name;
 	unsigned int encoded_namelen;
 	struct ecryptfs_crypt_stat *crypt_stat = NULL;
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
 	char *page_virt = NULL;
 	struct inode *lower_inode;
 	u64 file_size;
@@ -388,8 +389,18 @@ static struct dentry *ecryptfs_lookup(st
 		}
 		crypt_stat->flags |= ECRYPTFS_METADATA_IN_XATTR;
 	}
-	memcpy(&file_size, page_virt, sizeof(file_size));
-	file_size = be64_to_cpu(file_size);
+	mount_crypt_stat = &ecryptfs_superblock_to_private(
+		dentry->d_sb)->mount_crypt_stat;
+	if (mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED) {
+		if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
+			file_size = (crypt_stat->header_extent_size
+				     + i_size_read(lower_dentry->d_inode));
+		else
+			file_size = i_size_read(lower_dentry->d_inode);
+	} else {
+		memcpy(&file_size, page_virt, sizeof(file_size));
+		file_size = be64_to_cpu(file_size);
+	}
 	i_size_write(dentry->d_inode, (loff_t)file_size);
 	kmem_cache_free(ecryptfs_header_cache_2, page_virt);
 	goto out;
diff -puN fs/ecryptfs/mmap.c~ecryptfs-encrypted-passthrough fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-encrypted-passthrough
+++ a/fs/ecryptfs/mmap.c
@@ -260,6 +260,33 @@ out:
 		ClearPageUptodate(page);
 	return rc;
 }
+/**
+ *   Header Extent:
+ *     Octets 0-7:        Unencrypted file size (big-endian)
+ *     Octets 8-15:       eCryptfs special marker
+ *     Octets 16-19:      Flags
+ *      Octet 16:         File format version number (between 0 and 255)
+ *      Octets 17-18:     Reserved
+ *      Octet 19:         Bit 1 (lsb): Reserved
+ *                        Bit 2: Encrypted?
+ *                        Bits 3-8: Reserved
+ *     Octets 20-23:      Header extent size (big-endian)
+ *     Octets 24-25:      Number of header extents at front of file
+ *                        (big-endian)
+ *     Octet  26:         Begin RFC 2440 authentication token packet set
+ */
+static void set_header_info(char *page_virt,
+			    struct ecryptfs_crypt_stat *crypt_stat)
+{
+	size_t written;
+	int save_num_header_extents_at_front =
+		crypt_stat->num_header_extents_at_front;
+
+	crypt_stat->num_header_extents_at_front = 1;
+	ecryptfs_write_header_metadata(page_virt + 20, crypt_stat, &written);
+	crypt_stat->num_header_extents_at_front =
+		save_num_header_extents_at_front;
+}
 
 /**
  * ecryptfs_readpage
@@ -289,10 +316,55 @@ static int ecryptfs_readpage(struct file
 					"[%d]\n", rc);
 			goto out;
 		}
+	} else if (crypt_stat->flags & ECRYPTFS_VIEW_AS_ENCRYPTED) {
+		if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR) {
+			int num_pages_in_header_region =
+				(crypt_stat->header_extent_size
+				 / PAGE_CACHE_SIZE);
+
+			if (page->index < num_pages_in_header_region) {
+				char *page_virt;
+
+				page_virt = (char *)kmap(page);
+				if (!page_virt) {
+					rc = -ENOMEM;
+					printk(KERN_ERR "Error mapping page\n");
+					goto out;
+				}
+				memset(page_virt, 0, PAGE_CACHE_SIZE);
+				if (page->index == 0) {
+					rc = ecryptfs_read_xattr_region(
+						page_virt, file->f_path.dentry);
+					set_header_info(page_virt, crypt_stat);
+				}
+				kunmap(page);
+				if (rc) {
+					printk(KERN_ERR "Error reading xattr "
+					       "region\n");
+					goto out;
+				}
+			} else {
+				rc = ecryptfs_do_readpage(
+					file, page,
+					(page->index
+					 - num_pages_in_header_region));
+				if (rc) {
+					printk(KERN_ERR "Error reading page; "
+					       "rc = [%d]\n", rc);
+					goto out;
+				}
+			}
+		} else {
+			rc = ecryptfs_do_readpage(file, page, page->index);
+			if (rc) {
+				printk(KERN_ERR "Error reading page; rc = "
+				       "[%d]\n", rc);
+				goto out;
+			}
+		}
 	} else {
 		rc = ecryptfs_decrypt_page(file, page);
 		if (rc) {
-
 			ecryptfs_printk(KERN_ERR, "Error decrypting page; "
 					"rc = [%d]\n", rc);
 			goto out;
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-transport-mechanism-fix.patch
ecryptfs-public-key-packet-management.patch
ecryptfs-public-key-packet-management-slab-fix.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
ecryptfs-xattr-flags-and-mount-options.patch
ecryptfs-generalize-metadata-read-write.patch
ecryptfs-encrypted-passthrough.patch
