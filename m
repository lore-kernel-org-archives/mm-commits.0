From: akpm@linux-foundation.org
Subject: - ecryptfs-xattr-flags-and-mount-options.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:47:07 -0800
Message-ID: <200702122247.l1CMl738013887@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45954 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030443AbXBLWx3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:53:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: xattr flags and mount options
has been removed from the -mm tree.  Its filename was
     ecryptfs-xattr-flags-and-mount-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

   When storing the data in the file header, there is a minimum of 8KB
   reserved for the header information for each file, making each file at
   least 12KB in size.  This can take up a lot of extra disk space if the user
   creates a lot of small files.  By storing the data in the extended
   attribute, each file will only occupy at least of 4KB of space.

   As the eCryptfs metadata set becomes larger with new features such as
   multi-key associations, most popular filesystems will not be able to store
   all of the information in the xattr region in some cases due to space
   constraints.  However, the majority of users will only ever associate one
   key per file, so most users will be okay with storing their data in the
   xattr region.

   This option should be used with caution.  I want to emphasize that the
   xattr must be maintained under all circumstances, or the file will be
   rendered permanently unrecoverable.  The last thing I want is for a user to
   forget to set an xattr flag in a backup utility, only to later discover
   that their backups are worthless.

ecryptfs_encrypted_view
 - When set, this option causes eCryptfs to present applications a
   view of encrypted files as if the cryptographic metadata were
   stored in the file header, whether the metadata is actually stored
   in the header or in the extended attributes.

   No matter what eCryptfs winds up doing in the lower filesystem, I want
   to preserve a baseline format compatibility for the encrypted files.  As of
   right now, the metadata may be in the file header or in an xattr.  There is
   no reason why the metadata could not be put in a separate file in future
   versions.

   Without the compatibility mode, backup utilities would have to know to
   back up the metadata file along with the files.  The semantics of eCryptfs
   have always been that the lower files are self-contained units of encrypted
   data, and the only additional information required to decrypt any given
   eCryptfs file is the key.  That is what has always been emphasized about
   eCryptfs lower files, and that is what users expect.  Providing the
   encrypted view option will provide a way to userspace applications wherein
   they can always get to the same old familiar eCryptfs encrypted files,
   regardless of what eCryptfs winds up doing with the metadata behind the
   scenes.

This patch:

Add extended attribute support to version bit vector, flags to indicate when
xattr or encrypted view modes are enabled, and support for the new mount
options.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |   20 ++++++++++++++++++++
 fs/ecryptfs/ecryptfs_kernel.h |   15 ++++++++++-----
 fs/ecryptfs/main.c            |   18 ++++++++++++++++--
 3 files changed, 46 insertions(+), 7 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-xattr-flags-and-mount-options fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-xattr-flags-and-mount-options
+++ a/fs/ecryptfs/crypto.c
@@ -915,6 +915,22 @@ static void ecryptfs_generate_new_key(st
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
@@ -924,6 +940,8 @@ static void ecryptfs_set_default_crypt_s
 	struct ecryptfs_crypt_stat *crypt_stat,
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
 {
+	ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
+						      mount_crypt_stat);
 	ecryptfs_set_default_sizes(crypt_stat);
 	strcpy(crypt_stat->cipher, ECRYPTFS_DEFAULT_CIPHER);
 	crypt_stat->key_size = ECRYPTFS_DEFAULT_KEY_BYTES;
@@ -969,6 +987,8 @@ int ecryptfs_new_file_context(struct den
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
@@ -227,6 +228,8 @@ struct ecryptfs_crypt_stat {
 #define ECRYPTFS_ENABLE_HMAC        0x00000020
 #define ECRYPTFS_ENCRYPT_IV_PAGES   0x00000040
 #define ECRYPTFS_KEY_VALID          0x00000080
+#define ECRYPTFS_METADATA_IN_XATTR  0x00000100
+#define ECRYPTFS_VIEW_AS_ENCRYPTED  0x00000200
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
@@ -273,6 +276,8 @@ struct ecryptfs_dentry_info {
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

origin.patch
git-unionfs.patch
ecryptfs-convert-lookup_one_len-to-lookup_one_len_nd.patch
