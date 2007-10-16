From: akpm@linux-foundation.org
Subject: - ecryptfs-remove-header_extent_size.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:44 -0700
Message-ID: <200710162040.l9GKei6c015717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965407AbXJPVRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:17:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: remove header_extent_size
has been removed from the -mm tree.  Its filename was
     ecryptfs-remove-header_extent_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: remove header_extent_size
From: Michael Halcrow <mhalcrow@us.ibm.com>

There is no point to keeping a separate header_extent_size and an extent_size.
 The total size of the header can always be represented as some multiple of
the regular data extent size.

[randy.dunlap@oracle.com: ecryptfs: fix printk format warning]
Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |   40 ++++++++++++++++----------------
 fs/ecryptfs/ecryptfs_kernel.h |   39 +++++++++++++++++++++----------
 fs/ecryptfs/inode.c           |    7 +++--
 fs/ecryptfs/mmap.c            |    2 -
 4 files changed, 52 insertions(+), 36 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-remove-header_extent_size fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-remove-header_extent_size
+++ a/fs/ecryptfs/crypto.c
@@ -366,8 +366,8 @@ ecryptfs_extent_to_lwr_pg_idx_and_offset
 	int extents_per_page;
 
 	bytes_occupied_by_headers_at_front =
-		( crypt_stat->header_extent_size
-		  * crypt_stat->num_header_extents_at_front );
+		(crypt_stat->extent_size
+		 * crypt_stat->num_header_extents_at_front);
 	extents_occupied_by_headers_at_front =
 		( bytes_occupied_by_headers_at_front
 		  / crypt_stat->extent_size );
@@ -376,8 +376,8 @@ ecryptfs_extent_to_lwr_pg_idx_and_offset
 	(*lower_page_idx) = lower_extent_num / extents_per_page;
 	extent_offset = lower_extent_num % extents_per_page;
 	(*byte_offset) = extent_offset * crypt_stat->extent_size;
-	ecryptfs_printk(KERN_DEBUG, " * crypt_stat->header_extent_size = "
-			"[%d]\n", crypt_stat->header_extent_size);
+	ecryptfs_printk(KERN_DEBUG, " * crypt_stat->extent_size = "
+			"[%d]\n", crypt_stat->extent_size);
 	ecryptfs_printk(KERN_DEBUG, " * crypt_stat->"
 			"num_header_extents_at_front = [%d]\n",
 			crypt_stat->num_header_extents_at_front);
@@ -899,15 +899,17 @@ void ecryptfs_set_default_sizes(struct e
 	crypt_stat->extent_size = ECRYPTFS_DEFAULT_EXTENT_SIZE;
 	set_extent_mask_and_shift(crypt_stat);
 	crypt_stat->iv_bytes = ECRYPTFS_DEFAULT_IV_BYTES;
-	if (PAGE_CACHE_SIZE <= ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE) {
-		crypt_stat->header_extent_size =
-			ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE;
-	} else
-		crypt_stat->header_extent_size = PAGE_CACHE_SIZE;
 	if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
 		crypt_stat->num_header_extents_at_front = 0;
-	else
-		crypt_stat->num_header_extents_at_front = 1;
+	else {
+		if (PAGE_CACHE_SIZE <= ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE)
+			crypt_stat->num_header_extents_at_front =
+				(ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE
+				 / crypt_stat->extent_size);
+		else
+			crypt_stat->num_header_extents_at_front =
+				(PAGE_CACHE_SIZE / crypt_stat->extent_size);
+	}
 }
 
 /**
@@ -1319,7 +1321,7 @@ ecryptfs_write_header_metadata(char *vir
 	u32 header_extent_size;
 	u16 num_header_extents_at_front;
 
-	header_extent_size = (u32)crypt_stat->header_extent_size;
+	header_extent_size = (u32)crypt_stat->extent_size;
 	num_header_extents_at_front =
 		(u16)crypt_stat->num_header_extents_at_front;
 	header_extent_size = cpu_to_be32(header_extent_size);
@@ -1415,7 +1417,7 @@ ecryptfs_write_metadata_to_contents(stru
 		set_fs(oldfs);
 		goto out;
 	}
-	header_pages = ((crypt_stat->header_extent_size
+	header_pages = ((crypt_stat->extent_size
 			 * crypt_stat->num_header_extents_at_front)
 			/ PAGE_CACHE_SIZE);
 	memset(page_virt, 0, PAGE_CACHE_SIZE);
@@ -1532,17 +1534,16 @@ static int parse_header_metadata(struct 
 	virt += 4;
 	memcpy(&num_header_extents_at_front, virt, 2);
 	num_header_extents_at_front = be16_to_cpu(num_header_extents_at_front);
-	crypt_stat->header_extent_size = (int)header_extent_size;
 	crypt_stat->num_header_extents_at_front =
 		(int)num_header_extents_at_front;
-	(*bytes_read) = 6;
+	(*bytes_read) = (sizeof(u32) + sizeof(u16));
 	if ((validate_header_size == ECRYPTFS_VALIDATE_HEADER_SIZE)
-	    && ((crypt_stat->header_extent_size
+	    && ((crypt_stat->extent_size
 		 * crypt_stat->num_header_extents_at_front)
 		< ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE)) {
 		rc = -EINVAL;
-		ecryptfs_printk(KERN_WARNING, "Invalid header extent size: "
-				"[%d]\n", crypt_stat->header_extent_size);
+		printk(KERN_WARNING "Invalid number of header extents: [%zd]\n",
+		       crypt_stat->num_header_extents_at_front);
 	}
 	return rc;
 }
@@ -1557,8 +1558,7 @@ static int parse_header_metadata(struct 
  */
 static void set_default_header_data(struct ecryptfs_crypt_stat *crypt_stat)
 {
-	crypt_stat->header_extent_size = 4096;
-	crypt_stat->num_header_extents_at_front = 1;
+	crypt_stat->num_header_extents_at_front = 2;
 }
 
 /**
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-remove-header_extent_size fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-remove-header_extent_size
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -38,7 +38,7 @@
 /* Version verification for shared data structures w/ userspace */
 #define ECRYPTFS_VERSION_MAJOR 0x00
 #define ECRYPTFS_VERSION_MINOR 0x04
-#define ECRYPTFS_SUPPORTED_FILE_VERSION 0x02
+#define ECRYPTFS_SUPPORTED_FILE_VERSION 0x03
 /* These flags indicate which features are supported by the kernel
  * module; userspace tools such as the mount helper read
  * ECRYPTFS_VERSIONING_MASK from a sysfs handle in order to determine
@@ -67,8 +67,7 @@
 #define ECRYPTFS_MAX_KEY_BYTES 64
 #define ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES 512
 #define ECRYPTFS_DEFAULT_IV_BYTES 16
-#define ECRYPTFS_FILE_VERSION 0x02
-#define ECRYPTFS_DEFAULT_HEADER_EXTENT_SIZE 8192
+#define ECRYPTFS_FILE_VERSION 0x03
 #define ECRYPTFS_DEFAULT_EXTENT_SIZE 4096
 #define ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE 8192
 #define ECRYPTFS_DEFAULT_MSG_CTX_ELEMS 32
@@ -201,7 +200,7 @@ ecryptfs_get_key_payload_data(struct key
 #define ECRYPTFS_SALT_BYTES 2
 #define MAGIC_ECRYPTFS_MARKER 0x3c81b7f5
 #define MAGIC_ECRYPTFS_MARKER_SIZE_BYTES 8	/* 4*2 */
-#define ECRYPTFS_FILE_SIZE_BYTES 8
+#define ECRYPTFS_FILE_SIZE_BYTES (sizeof(u64))
 #define ECRYPTFS_DEFAULT_CIPHER "aes"
 #define ECRYPTFS_DEFAULT_KEY_BYTES 16
 #define ECRYPTFS_DEFAULT_HASH "md5"
@@ -238,7 +237,6 @@ struct ecryptfs_crypt_stat {
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
-	size_t header_extent_size;
 	size_t num_header_extents_at_front;
 	size_t extent_size; /* Data extent size; default is 4096 */
 	size_t key_size;
@@ -273,6 +271,17 @@ struct ecryptfs_dentry_info {
 };
 
 /**
+ * ecryptfs_global_auth_tok - A key used to encrypt all new files under the mountpoint
+ * @flags: Status flags
+ * @mount_crypt_stat_list: These auth_toks hang off the mount-wide
+ *                         cryptographic context. Every time a new
+ *                         inode comes into existence, eCryptfs copies
+ *                         the auth_toks on that list to the set of
+ *                         auth_toks on the inode's crypt_stat
+ * @global_auth_tok_key: The key from the user's keyring for the sig
+ * @global_auth_tok: The key contents
+ * @sig: The key identifier
+ *
  * ecryptfs_global_auth_tok structs refer to authentication token keys
  * in the user keyring that apply to newly created files. A list of
  * these objects hangs off of the mount_crypt_stat struct for any
@@ -283,15 +292,21 @@ struct ecryptfs_dentry_info {
 struct ecryptfs_global_auth_tok {
 #define ECRYPTFS_AUTH_TOK_INVALID 0x00000001
 	u32 flags;
-	struct list_head mount_crypt_stat_list; /* Default auth_tok list for
-						 * the mount_crypt_stat */
-	struct key *global_auth_tok_key; /* The key from the user's keyring for
-					  * the sig */
-	struct ecryptfs_auth_tok *global_auth_tok; /* The key contents */
-	unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1]; /* The key identifier */
+	struct list_head mount_crypt_stat_list;
+	struct key *global_auth_tok_key;
+	struct ecryptfs_auth_tok *global_auth_tok;
+	unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1];
 };
 
 /**
+ * ecryptfs_key_tfm - Persistent key tfm
+ * @key_tfm: crypto API handle to the key
+ * @key_size: Key size in bytes
+ * @key_tfm_mutex: Mutex to ensure only one operation in eCryptfs is
+ *                 using the persistent TFM at any point in time
+ * @key_tfm_list: Handle to hang this off the module-wide TFM list
+ * @cipher_name: String name for the cipher for this TFM
+ *
  * Typically, eCryptfs will use the same ciphers repeatedly throughout
  * the course of its operations. In order to avoid unnecessarily
  * destroying and initializing the same cipher repeatedly, eCryptfs
@@ -301,7 +316,7 @@ struct ecryptfs_key_tfm {
 	struct crypto_blkcipher *key_tfm;
 	size_t key_size;
 	struct mutex key_tfm_mutex;
-	struct list_head key_tfm_list; /* The module's tfm list */
+	struct list_head key_tfm_list;
 	unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
 };
 
diff -puN fs/ecryptfs/inode.c~ecryptfs-remove-header_extent_size fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-remove-header_extent_size
+++ a/fs/ecryptfs/inode.c
@@ -392,7 +392,8 @@ static struct dentry *ecryptfs_lookup(st
 		dentry->d_sb)->mount_crypt_stat;
 	if (mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED) {
 		if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
-			file_size = (crypt_stat->header_extent_size
+			file_size = ((crypt_stat->extent_size
+				      * crypt_stat->num_header_extents_at_front)
 				     + i_size_read(lower_dentry->d_inode));
 		else
 			file_size = i_size_read(lower_dentry->d_inode);
@@ -722,8 +723,8 @@ upper_size_to_lower_size(struct ecryptfs
 {
 	loff_t lower_size;
 
-	lower_size = ( crypt_stat->header_extent_size
-		       * crypt_stat->num_header_extents_at_front );
+	lower_size = (crypt_stat->extent_size
+		      * crypt_stat->num_header_extents_at_front);
 	if (upper_size != 0) {
 		loff_t num_extents;
 
diff -puN fs/ecryptfs/mmap.c~ecryptfs-remove-header_extent_size fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-remove-header_extent_size
+++ a/fs/ecryptfs/mmap.c
@@ -301,7 +301,7 @@ static int ecryptfs_readpage(struct file
 	} else if (crypt_stat->flags & ECRYPTFS_VIEW_AS_ENCRYPTED) {
 		if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR) {
 			int num_pages_in_header_region =
-				(crypt_stat->header_extent_size
+				(crypt_stat->extent_size
 				 / PAGE_CACHE_SIZE);
 
 			if (page->index < num_pages_in_header_region) {
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
