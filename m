From: akpm@linux-foundation.org
Subject: - ecryptfs-filename-encryption-header-updates.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:20 -0800
Message-ID: <200901072218.n07MIKe5017817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763386AbZAGWh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, dustin.kirkland@gmail.com, sandeen@redhat.com, shaggy@us.ibm.com, tchicks@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Filename Encryption: Header updates
has been removed from the -mm tree.  Its filename was
     ecryptfs-filename-encryption-header-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Filename Encryption: Header updates
From: Michael Halcrow <mhalcrow@us.ibm.com>

Extensions to the header file to support filename encryption.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dustin Kirkland <dustin.kirkland@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Tyler Hicks <tchicks@us.ibm.com>
Cc: David Kleikamp <shaggy@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |    4 +-
 fs/ecryptfs/ecryptfs_kernel.h |   61 +++++++++++++++++++++++++-------
 2 files changed, 51 insertions(+), 14 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-filename-encryption-header-updates fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-filename-encryption-header-updates
+++ a/fs/ecryptfs/crypto.c
@@ -175,8 +175,8 @@ out:
  *
  * Returns zero on success; non-zero on error.
  */
-static int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
-			      loff_t offset)
+int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
+		       loff_t offset)
 {
 	int rc = 0;
 	char dst[MD5_DIGEST_SIZE];
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-filename-encryption-header-updates fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-filename-encryption-header-updates
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -51,12 +51,16 @@
 #define ECRYPTFS_VERSIONING_XATTR                 0x00000010
 #define ECRYPTFS_VERSIONING_MULTKEY               0x00000020
 #define ECRYPTFS_VERSIONING_DEVMISC               0x00000040
+#define ECRYPTFS_VERSIONING_HMAC                  0x00000080
+#define ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION   0x00000100
+#define ECRYPTFS_VERSIONING_GCM                   0x00000200
 #define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
 				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
 				  | ECRYPTFS_VERSIONING_PUBKEY \
 				  | ECRYPTFS_VERSIONING_XATTR \
 				  | ECRYPTFS_VERSIONING_MULTKEY \
-				  | ECRYPTFS_VERSIONING_DEVMISC)
+				  | ECRYPTFS_VERSIONING_DEVMISC \
+				  | ECRYPTFS_VERSIONING_FILENAME_ENCRYPTION)
 #define ECRYPTFS_MAX_PASSWORD_LENGTH 64
 #define ECRYPTFS_MAX_PASSPHRASE_BYTES ECRYPTFS_MAX_PASSWORD_LENGTH
 #define ECRYPTFS_SALT_SIZE 8
@@ -232,23 +236,39 @@ struct ecryptfs_key_sig {
 	char keysig[ECRYPTFS_SIG_SIZE_HEX];
 };
 
+struct ecryptfs_filename {
+	struct list_head crypt_stat_list;
+#define ECRYPTFS_FILENAME_CONTAINS_DECRYPTED 0x00000001
+	u32 flags;
+	u32 seq_no;
+	char *filename;
+	char *encrypted_filename;
+	size_t filename_size;
+	size_t encrypted_filename_size;
+	char fnek_sig[ECRYPTFS_SIG_SIZE_HEX];
+	char dentry_name[ECRYPTFS_ENCRYPTED_DENTRY_NAME_LEN + 1];
+};
+
 /**
  * This is the primary struct associated with each encrypted file.
  *
  * TODO: cache align/pack?
  */
 struct ecryptfs_crypt_stat {
-#define ECRYPTFS_STRUCT_INITIALIZED 0x00000001
-#define ECRYPTFS_POLICY_APPLIED     0x00000002
-#define ECRYPTFS_NEW_FILE           0x00000004
-#define ECRYPTFS_ENCRYPTED          0x00000008
-#define ECRYPTFS_SECURITY_WARNING   0x00000010
-#define ECRYPTFS_ENABLE_HMAC        0x00000020
-#define ECRYPTFS_ENCRYPT_IV_PAGES   0x00000040
-#define ECRYPTFS_KEY_VALID          0x00000080
-#define ECRYPTFS_METADATA_IN_XATTR  0x00000100
-#define ECRYPTFS_VIEW_AS_ENCRYPTED  0x00000200
-#define ECRYPTFS_KEY_SET            0x00000400
+#define ECRYPTFS_STRUCT_INITIALIZED   0x00000001
+#define ECRYPTFS_POLICY_APPLIED       0x00000002
+#define ECRYPTFS_NEW_FILE             0x00000004
+#define ECRYPTFS_ENCRYPTED            0x00000008
+#define ECRYPTFS_SECURITY_WARNING     0x00000010
+#define ECRYPTFS_ENABLE_HMAC          0x00000020
+#define ECRYPTFS_ENCRYPT_IV_PAGES     0x00000040
+#define ECRYPTFS_KEY_VALID            0x00000080
+#define ECRYPTFS_METADATA_IN_XATTR    0x00000100
+#define ECRYPTFS_VIEW_AS_ENCRYPTED    0x00000200
+#define ECRYPTFS_KEY_SET              0x00000400
+#define ECRYPTFS_ENCRYPT_FILENAMES    0x00000800
+#define ECRYPTFS_ENCFN_USE_MOUNT_FNEK 0x00001000
+#define ECRYPTFS_ENCFN_USE_FEK        0x00002000
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
@@ -597,6 +617,15 @@ struct ecryptfs_open_req {
 int ecryptfs_interpose(struct dentry *hidden_dentry,
 		       struct dentry *this_dentry, struct super_block *sb,
 		       u32 flags);
+int ecryptfs_lookup_and_interpose_lower(struct dentry *ecryptfs_dentry,
+					struct dentry *lower_dentry,
+					struct ecryptfs_crypt_stat *crypt_stat,
+					struct inode *ecryptfs_dir_inode,
+					struct nameidata *ecryptfs_nd);
+int ecryptfs_decode_and_decrypt_filename(char **decrypted_name,
+					 size_t *decrypted_name_size,
+					 struct dentry *ecryptfs_dentry,
+					 const char *name, size_t name_size);
 int ecryptfs_fill_zeros(struct file *file, loff_t new_length);
 int ecryptfs_decode_filename(struct ecryptfs_crypt_stat *crypt_stat,
 			     const char *name, int length,
@@ -604,6 +633,12 @@ int ecryptfs_decode_filename(struct ecry
 int ecryptfs_encode_filename(struct ecryptfs_crypt_stat *crypt_stat,
 			     const char *name, int length,
 			     char **encoded_name);
+int ecryptfs_encrypt_and_encode_filename(
+	char **encoded_name,
+	size_t *encoded_name_size,
+	struct ecryptfs_crypt_stat *crypt_stat,
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
+	const char *name, size_t name_size);
 struct dentry *ecryptfs_lower_dentry(struct dentry *this_dentry);
 void ecryptfs_dump_hex(char *data, int bytes);
 int virt_to_scatterlist(const void *addr, int size, struct scatterlist *sg,
@@ -730,5 +765,7 @@ ecryptfs_parse_tag_70_packet(char **file
 			     size_t *packet_size,
 			     struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
 			     char *data, size_t max_packet_size);
+int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
+		       loff_t offset);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
notify_change-callers-must-hold-i_mutex.patch

