From: akpm@osdl.org
Subject: + ecryptfs-xattr-flags-and-mount-options.patch added to -mm tree
Date: Tue, 09 Jan 2007 14:26:54 -0800
Message-ID: <200701092226.l09MQtFW017142@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48753 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932472AbXAIW1p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 17:27:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: xattr flags and mount options
has been added to the -mm tree.  Its filename is
     ecryptfs-xattr-flags-and-mount-options.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: xattr flags and mount options
From: Michael Halcrow <mhalcrow@us.ibm.com>

This patch set introduces the ability to store cryptographic metadata into an
lower file extended attribute rather than the lower file header region.

This patch set implements two new mount options:

ecryptfs_xattr_metadata
 - When set, newly created files will have their cryptographic
   metadata stored in the extended attribute region of the file rather
   than the header.

ecryptfs_encrypted_view
 - When set, this option causes eCryptfs to present applications a
   view of encrypted files as if the cryptographic metadata were
   stored in the file header, whether the metadata is actually stored
   in the header or in the extended attributes.



This patch:

Add extended attribute support to version bit vector, flags to indicate when
xattr or encrypted view modes are enabled, and support for the new mount
options.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/crypto.c          |   20 ++++++++++++++++++++
 fs/ecryptfs/ecryptfs_kernel.h |   15 ++++++++++-----
 fs/ecryptfs/main.c            |   18 ++++++++++++++++--
 3 files changed, 46 insertions(+), 7 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-xattr-flags-and-mount-options fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-xattr-flags-and-mount-options
+++ a/fs/ecryptfs/crypto.c
@@ -917,6 +917,22 @@ static void ecryptfs_generate_new_key(st
 }
 
 /**
+ * ecryptfs_copy_mount_wide_flags_to_inode_flags
+ *
+ * This function propagates the mount-wide flags to individual inode
+ * flags.
+ */
+static void ecryptfs_copy_mount_wide_flags_to_inode_flags(
+	struct ecryptfs_crypt_stat *crypt_stat,
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
+{
+	if (mount_crypt_stat->flags & ECRYPTFS_XATTR_METADATA_ENABLED)
+		crypt_stat->flags |= ECRYPTFS_METADATA_IN_XATTR;
+	if (mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
+		crypt_stat->flags |= ECRYPTFS_VIEW_AS_ENCRYPTED;
+}
+
+/**
  * ecryptfs_set_default_crypt_stat_vals
  * @crypt_stat
  *
@@ -926,6 +942,8 @@ static void ecryptfs_set_default_crypt_s
 	struct ecryptfs_crypt_stat *crypt_stat,
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
 {
+	ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
+						      mount_crypt_stat);
 	ecryptfs_set_default_sizes(crypt_stat);
 	strcpy(crypt_stat->cipher, ECRYPTFS_DEFAULT_CIPHER);
 	crypt_stat->key_size = ECRYPTFS_DEFAULT_KEY_BYTES;
@@ -971,6 +989,8 @@ int ecryptfs_new_file_context(struct den
 				"file using mount_crypt_stat\n");
 		ECRYPTFS_SET_FLAG(crypt_stat->flags, ECRYPTFS_ENCRYPTED);
 		ECRYPTFS_SET_FLAG(crypt_stat->flags, ECRYPTFS_KEY_VALID);
+		ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
+							      mount_crypt_stat);
 		memcpy(crypt_stat->keysigs[crypt_stat->num_keysigs++],
 		       mount_crypt_stat->global_auth_tok_sig,
 		       ECRYPTFS_SIG_SIZE_HEX);
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-xattr-flags-and-mount-options fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-xattr-flags-and-mount-options
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -43,13 +43,14 @@
  * module; userspace tools such as the mount helper read
  * ECRYPTFS_VERSIONING_MASK from a sysfs handle in order to determine
  * how to behave. */
-#define ECRYPTFS_VERSIONING_PASSPHRASE 0x00000001
-#define ECRYPTFS_VERSIONING_PUBKEY 0x00000002
+#define ECRYPTFS_VERSIONING_PASSPHRASE            0x00000001
+#define ECRYPTFS_VERSIONING_PUBKEY                0x00000002
 #define ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH 0x00000004
-#define ECRYPTFS_VERSIONING_POLICY 0x00000008
+#define ECRYPTFS_VERSIONING_POLICY                0x00000008
+#define ECRYPTFS_VERSIONING_XATTR                 0x00000010
 #define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
-                                  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
-                                  | ECRYPTFS_VERSIONING_PUBKEY)
+				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
+				  | ECRYPTFS_VERSIONING_PUBKEY)
 
 #define ECRYPTFS_MAX_PASSWORD_LENGTH 64
 #define ECRYPTFS_MAX_PASSPHRASE_BYTES ECRYPTFS_MAX_PASSWORD_LENGTH
@@ -228,6 +229,8 @@ struct ecryptfs_crypt_stat {
 #define ECRYPTFS_ENABLE_HMAC        0x00000020
 #define ECRYPTFS_ENCRYPT_IV_PAGES   0x00000040
 #define ECRYPTFS_KEY_VALID          0x00000080
+#define ECRYPTFS_METADATA_IN_XATTR  0x00000100
+#define ECRYPTFS_VIEW_AS_ENCRYPTED  0x00000200
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
@@ -274,6 +277,8 @@ struct ecryptfs_dentry_info {
 struct ecryptfs_mount_crypt_stat {
 	/* Pointers to memory we do not own, do not free these */
 #define ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED 0x00000001
+#define ECRYPTFS_XATTR_METADATA_ENABLED        0x00000002
+#define ECRYPTFS_ENCRYPTED_VIEW_ENABLED        0x00000004
 	u32 flags;
 	struct ecryptfs_auth_tok *global_auth_tok;
 	struct key *global_auth_tok_key;
diff -puN fs/ecryptfs/main.c~ecryptfs-xattr-flags-and-mount-options fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-xattr-flags-and-mount-options
+++ a/fs/ecryptfs/main.c
@@ -162,7 +162,8 @@ out:
 enum { ecryptfs_opt_sig, ecryptfs_opt_ecryptfs_sig, ecryptfs_opt_debug,
        ecryptfs_opt_ecryptfs_debug, ecryptfs_opt_cipher,
        ecryptfs_opt_ecryptfs_cipher, ecryptfs_opt_ecryptfs_key_bytes,
-       ecryptfs_opt_passthrough, ecryptfs_opt_err };
+       ecryptfs_opt_passthrough, ecryptfs_opt_xattr_metadata,
+       ecryptfs_opt_encrypted_view, ecryptfs_opt_err };
 
 static match_table_t tokens = {
 	{ecryptfs_opt_sig, "sig=%s"},
@@ -173,6 +174,8 @@ static match_table_t tokens = {
 	{ecryptfs_opt_ecryptfs_cipher, "ecryptfs_cipher=%s"},
 	{ecryptfs_opt_ecryptfs_key_bytes, "ecryptfs_key_bytes=%u"},
 	{ecryptfs_opt_passthrough, "ecryptfs_passthrough"},
+	{ecryptfs_opt_xattr_metadata, "ecryptfs_xattr_metadata"},
+	{ecryptfs_opt_encrypted_view, "ecryptfs_encrypted_view"},
 	{ecryptfs_opt_err, NULL}
 };
 
@@ -313,6 +316,16 @@ static int ecryptfs_parse_options(struct
 			mount_crypt_stat->flags |=
 				ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED;
 			break;
+		case ecryptfs_opt_xattr_metadata:
+			mount_crypt_stat->flags |=
+				ECRYPTFS_XATTR_METADATA_ENABLED;
+			break;
+		case ecryptfs_opt_encrypted_view:
+			mount_crypt_stat->flags |=
+				ECRYPTFS_XATTR_METADATA_ENABLED;
+			mount_crypt_stat->flags |=
+				ECRYPTFS_ENCRYPTED_VIEW_ENABLED;
+			break;
 		case ecryptfs_opt_err:
 		default:
 			ecryptfs_printk(KERN_WARNING,
@@ -734,7 +747,8 @@ static struct ecryptfs_version_str_map_e
 	{ECRYPTFS_VERSIONING_PASSPHRASE, "passphrase"},
 	{ECRYPTFS_VERSIONING_PUBKEY, "pubkey"},
 	{ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH, "plaintext passthrough"},
-	{ECRYPTFS_VERSIONING_POLICY, "policy"}
+	{ECRYPTFS_VERSIONING_POLICY, "policy"},
+	{ECRYPTFS_VERSIONING_XATTR, "metadata in extended attribute"}
 };
 
 static ssize_t version_str_show(struct ecryptfs_obj *obj, char *buff)
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
