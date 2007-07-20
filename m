From: akpm@linux-foundation.org
Subject: + ecryptfs-add-key-list-structure-search-keyring.patch added to -mm tree
Date: Fri, 20 Jul 2007 15:26:56 -0700
Message-ID: <200707202226.l6KMQvLT019661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763723AbXGTW1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 18:27:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, dhowells@redhat.com, serge@hallyn.com


The patch titled
     eCryptfs: add key list structure; search keyring
has been added to the -mm tree.  Its filename is
     ecryptfs-add-key-list-structure-search-keyring.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: add key list structure; search keyring
From: Michael Halcrow <mhalcrow@us.ibm.com>

Add support structures for handling multiple keys.  The list in crypt_stat
contains the key identifiers for all of the keys that should be used for
encrypting each file's File Encryption Key (FEK).  For now, each inode
inherits this list from the mount-wide crypt_stat struct, via the
ecryptfs_copy_mount_wide_sigs_to_inode_sigs() function.

This patch also removes the global key tfm from the mount-wide crypt_stat
struct, instead keeping a list of tfm's meant for dealing with the various
inode FEK's.  eCryptfs will now search the user's keyring for FEK's parsed
from the existing file metadata, so the user can make keys available at any
time before or after mounting.

Now that multiple FEK packets can be written to the file metadata, we need to
be more meticulous about size limits.  The updates to the code for writing out
packets to the file metadata makes sizes and limits more explicit, uniformly
expressed, and (hopefully) easier to follow.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |  208 +++++++-
 fs/ecryptfs/ecryptfs_kernel.h |   71 ++-
 fs/ecryptfs/keystore.c        |  743 ++++++++++++++++++++------------
 fs/ecryptfs/main.c            |  119 +----
 4 files changed, 741 insertions(+), 400 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-add-key-list-structure-search-keyring fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-add-key-list-structure-search-keyring
+++ a/fs/ecryptfs/crypto.c
@@ -204,6 +204,8 @@ void
 ecryptfs_init_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat)
 {
 	memset((void *)crypt_stat, 0, sizeof(struct ecryptfs_crypt_stat));
+	INIT_LIST_HEAD(&crypt_stat->keysig_list);
+	mutex_init(&crypt_stat->keysig_list_mutex);
 	mutex_init(&crypt_stat->cs_mutex);
 	mutex_init(&crypt_stat->cs_tfm_mutex);
 	mutex_init(&crypt_stat->cs_hash_tfm_mutex);
@@ -218,20 +220,41 @@ ecryptfs_init_crypt_stat(struct ecryptfs
  */
 void ecryptfs_destruct_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat)
 {
+	struct ecryptfs_key_sig *key_sig, *key_sig_tmp;
+
 	if (crypt_stat->tfm)
 		crypto_free_blkcipher(crypt_stat->tfm);
 	if (crypt_stat->hash_tfm)
 		crypto_free_hash(crypt_stat->hash_tfm);
+	mutex_lock(&crypt_stat->keysig_list_mutex);
+	list_for_each_entry_safe(key_sig, key_sig_tmp,
+				 &crypt_stat->keysig_list, crypt_stat_list) {
+		list_del(&key_sig->crypt_stat_list);
+		kmem_cache_free(ecryptfs_key_sig_cache, key_sig);
+	}
+	mutex_unlock(&crypt_stat->keysig_list_mutex);
 	memset(crypt_stat, 0, sizeof(struct ecryptfs_crypt_stat));
 }
 
 void ecryptfs_destruct_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
 {
-	if (mount_crypt_stat->global_auth_tok_key)
-		key_put(mount_crypt_stat->global_auth_tok_key);
-	if (mount_crypt_stat->global_key_tfm)
-		crypto_free_blkcipher(mount_crypt_stat->global_key_tfm);
+	struct ecryptfs_global_auth_tok *auth_tok, *auth_tok_tmp;
+
+	if (!(mount_crypt_stat->flags & ECRYPTFS_MOUNT_CRYPT_STAT_INITIALIZED))
+		return;
+	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
+	list_for_each_entry_safe(auth_tok, auth_tok_tmp,
+				 &mount_crypt_stat->global_auth_tok_list,
+				 mount_crypt_stat_list) {
+		list_del(&auth_tok->mount_crypt_stat_list);
+		mount_crypt_stat->num_global_auth_toks--;
+		if (auth_tok->global_auth_tok_key
+		    && !(auth_tok->flags & ECRYPTFS_AUTH_TOK_INVALID))
+			key_put(auth_tok->global_auth_tok_key);
+		kmem_cache_free(ecryptfs_global_auth_tok_cache, auth_tok);
+	}
+	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
 	memset(mount_crypt_stat, 0, sizeof(struct ecryptfs_mount_crypt_stat));
 }
 
@@ -931,6 +954,30 @@ static void ecryptfs_copy_mount_wide_fla
 		crypt_stat->flags |= ECRYPTFS_VIEW_AS_ENCRYPTED;
 }
 
+static int ecryptfs_copy_mount_wide_sigs_to_inode_sigs(
+	struct ecryptfs_crypt_stat *crypt_stat,
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
+{
+	struct ecryptfs_global_auth_tok *global_auth_tok;
+	int rc = 0;
+
+	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
+	list_for_each_entry(global_auth_tok,
+			    &mount_crypt_stat->global_auth_tok_list,
+			    mount_crypt_stat_list) {
+		rc = ecryptfs_add_keysig(crypt_stat, global_auth_tok->sig);
+		if (rc) {
+			printk(KERN_ERR "Error adding keysig; rc = [%d]\n", rc);
+			mutex_unlock(
+				&mount_crypt_stat->global_auth_tok_list_mutex);
+			goto out;
+		}
+	}
+	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
+out:
+	return rc;
+}
+
 /**
  * ecryptfs_set_default_crypt_stat_vals
  * @crypt_stat
@@ -973,46 +1020,44 @@ static void ecryptfs_set_default_crypt_s
 /* Associate an authentication token(s) with the file */
 int ecryptfs_new_file_context(struct dentry *ecryptfs_dentry)
 {
-	int rc = 0;
 	struct ecryptfs_crypt_stat *crypt_stat =
 	    &ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->crypt_stat;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
 	    &ecryptfs_superblock_to_private(
 		    ecryptfs_dentry->d_sb)->mount_crypt_stat;
 	int cipher_name_len;
+	int rc = 0;
 
 	ecryptfs_set_default_crypt_stat_vals(crypt_stat, mount_crypt_stat);
-	/* See if there are mount crypt options */
-	if (mount_crypt_stat->global_auth_tok) {
-		ecryptfs_printk(KERN_DEBUG, "Initializing context for new "
-				"file using mount_crypt_stat\n");
-		crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
-		crypt_stat->flags |= ECRYPTFS_KEY_VALID;
-		ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
-							      mount_crypt_stat);
-		memcpy(crypt_stat->keysigs[crypt_stat->num_keysigs++],
-		       mount_crypt_stat->global_auth_tok_sig,
-		       ECRYPTFS_SIG_SIZE_HEX);
-		cipher_name_len =
-		    strlen(mount_crypt_stat->global_default_cipher_name);
-		memcpy(crypt_stat->cipher,
-		       mount_crypt_stat->global_default_cipher_name,
-		       cipher_name_len);
-		crypt_stat->cipher[cipher_name_len] = '\0';
-		crypt_stat->key_size =
-			mount_crypt_stat->global_default_cipher_key_size;
-		ecryptfs_generate_new_key(crypt_stat);
-	} else
-		/* We should not encounter this scenario since we
-		 * should detect lack of global_auth_tok at mount time
-		 * TODO: Applies to 0.1 release only; remove in future
-		 * release */
-		BUG();
+	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
+	BUG_ON(mount_crypt_stat->num_global_auth_toks == 0);
+	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
+	crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
+	crypt_stat->flags |= ECRYPTFS_KEY_VALID;
+	ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
+						      mount_crypt_stat);
+	rc = ecryptfs_copy_mount_wide_sigs_to_inode_sigs(crypt_stat,
+							 mount_crypt_stat);
+	if (rc) {
+		printk(KERN_ERR "Error attempting to copy mount-wide key sigs "
+		       "to the inode key sigs; rc = [%d]\n", rc);
+		goto out;
+	}
+	cipher_name_len =
+		strlen(mount_crypt_stat->global_default_cipher_name);
+	memcpy(crypt_stat->cipher,
+	       mount_crypt_stat->global_default_cipher_name,
+	       cipher_name_len);
+	crypt_stat->cipher[cipher_name_len] = '\0';
+	crypt_stat->key_size =
+		mount_crypt_stat->global_default_cipher_key_size;
+	ecryptfs_generate_new_key(crypt_stat);
 	rc = ecryptfs_init_crypt_ctx(crypt_stat);
 	if (rc)
 		ecryptfs_printk(KERN_ERR, "Error initializing cryptographic "
 				"context for cipher [%s]: rc = [%d]\n",
 				crypt_stat->cipher, rc);
+out:
 	return rc;
 }
 
@@ -1776,7 +1821,7 @@ out:
 }
 
 /**
- * ecryptfs_process_cipher - Perform cipher initialization.
+ * ecryptfs_process_key_cipher - Perform key cipher initialization.
  * @key_tfm: Crypto context for key material, set by this function
  * @cipher_name: Name of the cipher
  * @key_size: Size of the key in bytes
@@ -1786,8 +1831,8 @@ out:
  * event, regardless of whether this function succeeds for fails.
  */
 int
-ecryptfs_process_cipher(struct crypto_blkcipher **key_tfm, char *cipher_name,
-			size_t *key_size)
+ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
+			    char *cipher_name, size_t *key_size)
 {
 	char dummy_key[ECRYPTFS_MAX_KEY_BYTES];
 	char *full_alg_name;
@@ -1829,3 +1874,98 @@ ecryptfs_process_cipher(struct crypto_bl
 out:
 	return rc;
 }
+
+struct kmem_cache *ecryptfs_key_tfm_cache;
+struct list_head key_tfm_list;
+struct mutex key_tfm_list_mutex;
+
+int ecryptfs_init_crypto(void)
+{
+	mutex_init(&key_tfm_list_mutex);
+	INIT_LIST_HEAD(&key_tfm_list);
+	return 0;
+}
+
+int ecryptfs_destruct_crypto(void)
+{
+	struct ecryptfs_key_tfm *key_tfm, *key_tfm_tmp;
+
+	mutex_lock(&key_tfm_list_mutex);
+	list_for_each_entry_safe(key_tfm, key_tfm_tmp, &key_tfm_list,
+				 key_tfm_list) {
+		list_del(&key_tfm->key_tfm_list);
+		if (key_tfm->key_tfm)
+			crypto_free_blkcipher(key_tfm->key_tfm);
+		kmem_cache_free(ecryptfs_key_tfm_cache, key_tfm);
+	}
+	mutex_unlock(&key_tfm_list_mutex);
+	return 0;
+}
+
+int
+ecryptfs_add_new_key_tfm(struct ecryptfs_key_tfm **key_tfm, char *cipher_name,
+			 size_t key_size)
+{
+	struct ecryptfs_key_tfm *tmp_tfm;
+	int rc = 0;
+
+	tmp_tfm = kmem_cache_alloc(ecryptfs_key_tfm_cache, GFP_KERNEL);
+	if (key_tfm != NULL)
+		(*key_tfm) = tmp_tfm;
+	if (!tmp_tfm) {
+		rc = -ENOMEM;
+		printk(KERN_ERR "Error attempting to allocate from "
+		       "ecryptfs_key_tfm_cache\n");
+		goto out;
+	}
+	mutex_init(&tmp_tfm->key_tfm_mutex);
+	strncpy(tmp_tfm->cipher_name, cipher_name,
+		ECRYPTFS_MAX_CIPHER_NAME_SIZE);
+	tmp_tfm->key_size = key_size;
+	if ((rc = ecryptfs_process_key_cipher(&tmp_tfm->key_tfm,
+					      tmp_tfm->cipher_name,
+					      &tmp_tfm->key_size))) {
+		printk(KERN_ERR "Error attempting to initialize key TFM "
+		       "cipher with name = [%s]; rc = [%d]\n",
+		       tmp_tfm->cipher_name, rc);
+		kmem_cache_free(ecryptfs_key_tfm_cache, tmp_tfm);
+		if (key_tfm != NULL)
+			(*key_tfm) = NULL;
+		goto out;
+	}
+	mutex_lock(&key_tfm_list_mutex);
+	list_add(&tmp_tfm->key_tfm_list, &key_tfm_list);
+	mutex_unlock(&key_tfm_list_mutex);
+out:
+	return rc;
+}
+
+int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
+					       struct mutex **tfm_mutex,
+					       char *cipher_name)
+{
+	struct ecryptfs_key_tfm *key_tfm;
+	int rc = 0;
+
+	(*tfm) = NULL;
+	(*tfm_mutex) = NULL;
+	mutex_lock(&key_tfm_list_mutex);
+	list_for_each_entry(key_tfm, &key_tfm_list, key_tfm_list) {
+		if (strcmp(key_tfm->cipher_name, cipher_name) == 0) {
+			(*tfm) = key_tfm->key_tfm;
+			(*tfm_mutex) = &key_tfm->key_tfm_mutex;
+			mutex_unlock(&key_tfm_list_mutex);
+			goto out;
+		}
+	}
+	mutex_unlock(&key_tfm_list_mutex);
+	if ((rc = ecryptfs_add_new_key_tfm(&key_tfm, cipher_name, 0))) {
+		printk(KERN_ERR "Error adding new key_tfm to list; rc = [%d]\n",
+		       rc);
+		goto out;
+	}
+	(*tfm) = key_tfm->key_tfm;
+	(*tfm_mutex) = &key_tfm->key_tfm_mutex;
+out:
+	return rc;
+}
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-add-key-list-structure-search-keyring fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-add-key-list-structure-search-keyring
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -48,10 +48,12 @@
 #define ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH 0x00000004
 #define ECRYPTFS_VERSIONING_POLICY                0x00000008
 #define ECRYPTFS_VERSIONING_XATTR                 0x00000010
+#define ECRYPTFS_VERSIONING_MULTKEY               0x00000020
 #define ECRYPTFS_VERSIONING_MASK (ECRYPTFS_VERSIONING_PASSPHRASE \
 				  | ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH \
 				  | ECRYPTFS_VERSIONING_PUBKEY \
-				  | ECRYPTFS_VERSIONING_XATTR)
+				  | ECRYPTFS_VERSIONING_XATTR \
+				  | ECRYPTFS_VERSIONING_MULTKEY)
 #define ECRYPTFS_MAX_PASSWORD_LENGTH 64
 #define ECRYPTFS_MAX_PASSPHRASE_BYTES ECRYPTFS_MAX_PASSWORD_LENGTH
 #define ECRYPTFS_SALT_SIZE 8
@@ -144,6 +146,7 @@ struct ecryptfs_private_key {
 struct ecryptfs_auth_tok {
 	u16 version; /* 8-bit major and 8-bit minor */
 	u16 token_type;
+#define ECRYPTFS_ENCRYPT_ONLY 0x00000001
 	u32 flags;
 	struct ecryptfs_session_key session_key;
 	u8 reserved[32];
@@ -153,6 +156,7 @@ struct ecryptfs_auth_tok {
 	} token;
 } __attribute__ ((packed));
 
+int ecryptfs_get_auth_tok_sig(char **sig, struct ecryptfs_auth_tok *auth_tok);
 void ecryptfs_dump_auth_tok(struct ecryptfs_auth_tok *auth_tok);
 extern void ecryptfs_to_hex(char *dst, char *src, size_t src_size);
 extern void ecryptfs_from_hex(char *dst, char *src, int dst_size);
@@ -194,7 +198,6 @@ ecryptfs_get_key_payload_data(struct key
 #define ECRYPTFS_MAX_KEYSET_SIZE 1024
 #define ECRYPTFS_MAX_CIPHER_NAME_SIZE 32
 #define ECRYPTFS_MAX_NUM_ENC_KEYS 64
-#define ECRYPTFS_MAX_NUM_KEYSIGS 2 /* TODO: Make this a linked list */
 #define ECRYPTFS_MAX_IV_BYTES 16	/* 128 bits */
 #define ECRYPTFS_SALT_BYTES 2
 #define MAGIC_ECRYPTFS_MARKER 0x3c81b7f5
@@ -212,6 +215,11 @@ ecryptfs_get_key_payload_data(struct key
 #define ECRYPTFS_TAG_67_PACKET_TYPE 0x43
 #define MD5_DIGEST_SIZE 16
 
+struct ecryptfs_key_sig {
+	struct list_head crypt_stat_list;
+	char keysig[ECRYPTFS_SIG_SIZE_HEX];
+};
+
 /**
  * This is the primary struct associated with each encrypted file.
  *
@@ -231,7 +239,6 @@ struct ecryptfs_crypt_stat {
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
-	size_t num_keysigs;
 	size_t header_extent_size;
 	size_t num_header_extents_at_front;
 	size_t extent_size; /* Data extent size; default is 4096 */
@@ -245,7 +252,8 @@ struct ecryptfs_crypt_stat {
 	unsigned char cipher[ECRYPTFS_MAX_CIPHER_NAME_SIZE];
 	unsigned char key[ECRYPTFS_MAX_KEY_BYTES];
 	unsigned char root_iv[ECRYPTFS_MAX_IV_BYTES];
-	unsigned char keysigs[ECRYPTFS_MAX_NUM_KEYSIGS][ECRYPTFS_SIG_SIZE_HEX];
+	struct list_head keysig_list;
+	struct mutex keysig_list_mutex;
 	struct mutex cs_tfm_mutex;
 	struct mutex cs_hash_tfm_mutex;
 	struct mutex cs_mutex;
@@ -265,6 +273,26 @@ struct ecryptfs_dentry_info {
 	struct ecryptfs_crypt_stat *crypt_stat;
 };
 
+struct ecryptfs_global_auth_tok {
+#define ECRYPTFS_AUTH_TOK_INVALID 0x00000001
+	u32 flags;
+	struct list_head mount_crypt_stat_list;
+	struct key *global_auth_tok_key;
+	struct ecryptfs_auth_tok *global_auth_tok;
+	unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1];
+};
+
+struct ecryptfs_key_tfm {
+	struct crypto_blkcipher *key_tfm;
+	size_t key_size;
+	struct mutex key_tfm_mutex;
+	struct list_head key_tfm_list;
+	unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
+};
+
+extern struct list_head key_tfm_list;
+extern struct mutex key_tfm_list_mutex;
+
 /**
  * This struct is to enable a mount-wide passphrase/salt combo. This
  * is more or less a stopgap to provide similar functionality to other
@@ -276,15 +304,14 @@ struct ecryptfs_mount_crypt_stat {
 #define ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED 0x00000001
 #define ECRYPTFS_XATTR_METADATA_ENABLED        0x00000002
 #define ECRYPTFS_ENCRYPTED_VIEW_ENABLED        0x00000004
+#define ECRYPTFS_MOUNT_CRYPT_STAT_INITIALIZED  0x00000008
 	u32 flags;
-	struct ecryptfs_auth_tok *global_auth_tok;
-	struct key *global_auth_tok_key;
+	struct list_head global_auth_tok_list;
+	struct mutex global_auth_tok_list_mutex;
+	size_t num_global_auth_toks;
 	size_t global_default_cipher_key_size;
-	struct crypto_blkcipher *global_key_tfm;
-	struct mutex global_key_tfm_mutex;
 	unsigned char global_default_cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE
 						 + 1];
-	unsigned char global_auth_tok_sig[ECRYPTFS_SIG_SIZE_HEX + 1];
 };
 
 /* superblock private data. */
@@ -468,6 +495,9 @@ extern struct kmem_cache *ecryptfs_heade
 extern struct kmem_cache *ecryptfs_xattr_cache;
 extern struct kmem_cache *ecryptfs_lower_page_cache;
 extern struct kmem_cache *ecryptfs_key_record_cache;
+extern struct kmem_cache *ecryptfs_key_sig_cache;
+extern struct kmem_cache *ecryptfs_global_auth_tok_cache;
+extern struct kmem_cache *ecryptfs_key_tfm_cache;
 
 int ecryptfs_interpose(struct dentry *hidden_dentry,
 		       struct dentry *this_dentry, struct super_block *sb,
@@ -538,9 +568,8 @@ int
 ecryptfs_parse_packet_set(struct ecryptfs_crypt_stat *crypt_stat,
 			  unsigned char *src, struct dentry *ecryptfs_dentry);
 int ecryptfs_truncate(struct dentry *dentry, loff_t new_length);
-int
-ecryptfs_process_cipher(struct crypto_blkcipher **key_tfm, char *cipher_name,
-			size_t *key_size);
+int ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
+				char *cipher_name, size_t *key_size);
 int ecryptfs_inode_test(struct inode *inode, void *candidate_lower_inode);
 int ecryptfs_inode_set(struct inode *inode, void *lower_inode);
 void ecryptfs_init_inode(struct inode *inode, struct inode *lower_inode);
@@ -580,6 +609,24 @@ void
 ecryptfs_write_header_metadata(char *virt,
 			       struct ecryptfs_crypt_stat *crypt_stat,
 			       size_t *written);
+int ecryptfs_add_keysig(struct ecryptfs_crypt_stat *crypt_stat, char *sig);
+int
+ecryptfs_add_global_auth_tok(struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
+			   char *sig);
+int ecryptfs_get_global_auth_tok_for_sig(
+	struct ecryptfs_global_auth_tok **global_auth_tok,
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat, char *sig);
+int
+ecryptfs_add_new_key_tfm(struct ecryptfs_key_tfm **key_tfm, char *cipher_name,
+			 size_t key_size);
+int ecryptfs_init_crypto(void);
+int ecryptfs_destruct_crypto(void);
+int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
+					       struct mutex **tfm_mutex,
+					       char *cipher_name);
+int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
+				      struct ecryptfs_auth_tok **auth_tok,
+				      char *sig);
 int ecryptfs_write_zeros(struct file *file, pgoff_t index, int start,
 			 int num_zeros);
 
diff -puN fs/ecryptfs/keystore.c~ecryptfs-add-key-list-structure-search-keyring fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-add-key-list-structure-search-keyring
+++ a/fs/ecryptfs/keystore.c
@@ -402,20 +402,24 @@ out:
  *
  * Returns Zero on success; non-zero error otherwise.
  */
-static int decrypt_pki_encrypted_session_key(
-	struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
-	struct ecryptfs_auth_tok *auth_tok,
-	struct ecryptfs_crypt_stat *crypt_stat)
+static int
+decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
+				  struct ecryptfs_crypt_stat *crypt_stat)
 {
 	u16 cipher_code = 0;
 	struct ecryptfs_msg_ctx *msg_ctx;
 	struct ecryptfs_message *msg = NULL;
+	char *auth_tok_sig;
 	char *netlink_message;
 	size_t netlink_message_length;
 	int rc;
 
-	rc = write_tag_64_packet(mount_crypt_stat->global_auth_tok_sig,
-				 &(auth_tok->session_key),
+	if ((rc = ecryptfs_get_auth_tok_sig(&auth_tok_sig, auth_tok))) {
+		printk(KERN_ERR "Unrecognized auth tok type: [%d]\n",
+		       auth_tok->token_type);
+		goto out;
+	}
+	rc = write_tag_64_packet(auth_tok_sig, &(auth_tok->session_key),
 				 &netlink_message, &netlink_message_length);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Failed to write tag 64 packet");
@@ -921,126 +925,241 @@ out:
 	return rc;
 }
 
+static int
+ecryptfs_find_global_auth_tok_for_sig(
+	struct ecryptfs_global_auth_tok **global_auth_tok,
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat, char *sig)
+{
+	struct ecryptfs_global_auth_tok *walker;
+	int rc = 0;
+
+	(*global_auth_tok) = NULL;
+	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
+	list_for_each_entry(walker,
+			    &mount_crypt_stat->global_auth_tok_list,
+			    mount_crypt_stat_list) {
+		if (memcmp(walker->sig, sig, ECRYPTFS_SIG_SIZE_HEX) == 0) {
+			(*global_auth_tok) = walker;
+			goto out;
+		}
+	}
+	rc = -EINVAL;
+out:
+	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
+	return rc;
+}
+
+/**
+ * ecryptfs_verify_version
+ * @version: The version number to confirm
+ *
+ * Returns zero on good version; non-zero otherwise
+ */
+static int ecryptfs_verify_version(u16 version)
+{
+	int rc = 0;
+	unsigned char major;
+	unsigned char minor;
+
+	major = ((version >> 8) & 0xFF);
+	minor = (version & 0xFF);
+	if (major != ECRYPTFS_VERSION_MAJOR) {
+		ecryptfs_printk(KERN_ERR, "Major version number mismatch. "
+				"Expected [%d]; got [%d]\n",
+				ECRYPTFS_VERSION_MAJOR, major);
+		rc = -EINVAL;
+		goto out;
+	}
+	if (minor != ECRYPTFS_VERSION_MINOR) {
+		ecryptfs_printk(KERN_ERR, "Minor version number mismatch. "
+				"Expected [%d]; got [%d]\n",
+				ECRYPTFS_VERSION_MINOR, minor);
+		rc = -EINVAL;
+		goto out;
+	}
+out:
+	return rc;
+}
+
+int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
+				      struct ecryptfs_auth_tok **auth_tok,
+				      char *sig)
+{
+	int rc = 0;
+
+	(*auth_tok_key) = request_key(&key_type_user, sig, NULL);
+	if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
+		printk(KERN_ERR "Could not find key with description: [%s]\n",
+		       sig);
+		process_request_key_err(PTR_ERR(*auth_tok_key));
+		rc = -EINVAL;
+		goto out;
+	}
+	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
+	if (ecryptfs_verify_version((*auth_tok)->version)) {
+		printk(KERN_ERR
+		       "Data structure version mismatch. "
+		       "Userspace tools must match eCryptfs "
+		       "kernel module with major version [%d] "
+		       "and minor version [%d]\n",
+		       ECRYPTFS_VERSION_MAJOR,
+		       ECRYPTFS_VERSION_MINOR);
+		rc = -EINVAL;
+		goto out;
+	}
+	if ((*auth_tok)->token_type != ECRYPTFS_PASSWORD
+	    && (*auth_tok)->token_type != ECRYPTFS_PRIVATE_KEY) {
+		printk(KERN_ERR "Invalid auth_tok structure "
+		       "returned from key query\n");
+		rc = -EINVAL;
+		goto out;
+	}
+out:
+	return rc;
+}
+
 /**
- * decrypt_session_key - Decrypt the session key with the given auth_tok.
+ * ecryptfs_find_auth_tok_for_sig
+ * @auth_tok: Set to the matching auth_tok; NULL if not found
+ * @crypt_stat: inode crypt_stat crypto context
+ * @sig: Sig of auth_tok to find
+ *
+ * For now, this function simply looks at the registered auth_tok's
+ * linked off the mount_crypt_stat, so all the auth_toks that can be
+ * used must be registered at mount time. This function could
+ * potentially try a lot harder to find auth_tok's (e.g., by calling
+ * out to ecryptfsd to dynamically retrieve an auth_tok object) so
+ * that static registration of auth_tok's will no longer be necessary.
+ *
+ * Returns zero on no error; non-zero on error
+ */
+static int
+ecryptfs_find_auth_tok_for_sig(
+	struct ecryptfs_auth_tok **auth_tok,
+	struct ecryptfs_crypt_stat *crypt_stat, char *sig)
+{
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
+		crypt_stat->mount_crypt_stat;
+	struct ecryptfs_global_auth_tok *global_auth_tok;
+	int rc = 0;
+
+	(*auth_tok) = NULL;
+	if (ecryptfs_find_global_auth_tok_for_sig(&global_auth_tok,
+						  mount_crypt_stat, sig)) {
+		struct key *auth_tok_key;
+
+		rc = ecryptfs_keyring_auth_tok_for_sig(&auth_tok_key, auth_tok,
+						       sig);
+	} else
+		(*auth_tok) = global_auth_tok->global_auth_tok;
+	return rc;
+}
+
+/**
+ * decrypt_passphrase_encrypted_session_key - Decrypt the session key
+ * with the given auth_tok.
  *
  * Returns Zero on success; non-zero error otherwise.
  */
-static int decrypt_session_key(struct ecryptfs_auth_tok *auth_tok,
-			       struct ecryptfs_crypt_stat *crypt_stat)
+static int
+decrypt_passphrase_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
+					 struct ecryptfs_crypt_stat *crypt_stat)
 {
-	struct ecryptfs_password *password_s_ptr;
-	struct scatterlist src_sg[2], dst_sg[2];
+	struct scatterlist dst_sg;
+	struct scatterlist src_sg;
 	struct mutex *tfm_mutex = NULL;
-	char *encrypted_session_key;
-	char *session_key;
 	struct blkcipher_desc desc = {
 		.flags = CRYPTO_TFM_REQ_MAY_SLEEP
 	};
 	int rc = 0;
 
-	password_s_ptr = &auth_tok->token.password;
-	if (password_s_ptr->flags & ECRYPTFS_SESSION_KEY_ENCRYPTION_KEY_SET)
-		ecryptfs_printk(KERN_DEBUG, "Session key encryption key "
-				"set; skipping key generation\n");
-	ecryptfs_printk(KERN_DEBUG, "Session key encryption key (size [%d])"
-			":\n",
-			password_s_ptr->session_key_encryption_key_bytes);
-	if (ecryptfs_verbosity > 0)
-		ecryptfs_dump_hex(password_s_ptr->session_key_encryption_key,
-				  password_s_ptr->
-				  session_key_encryption_key_bytes);
-	if (!strcmp(crypt_stat->cipher,
-		    crypt_stat->mount_crypt_stat->global_default_cipher_name)
-	    && crypt_stat->mount_crypt_stat->global_key_tfm) {
-		desc.tfm = crypt_stat->mount_crypt_stat->global_key_tfm;
-		tfm_mutex = &crypt_stat->mount_crypt_stat->global_key_tfm_mutex;
-	} else {
-		char *full_alg_name;
-
-		rc = ecryptfs_crypto_api_algify_cipher_name(&full_alg_name,
-							    crypt_stat->cipher,
-							    "ecb");
-		if (rc)
-			goto out;
-		desc.tfm = crypto_alloc_blkcipher(full_alg_name, 0,
-						  CRYPTO_ALG_ASYNC);
-		kfree(full_alg_name);
-		if (IS_ERR(desc.tfm)) {
-			rc = PTR_ERR(desc.tfm);
-			printk(KERN_ERR "Error allocating crypto context; "
-			       "rc = [%d]\n", rc);
-			goto out;
-		}
-		crypto_blkcipher_set_flags(desc.tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+	if (unlikely(ecryptfs_verbosity > 0)) {
+		ecryptfs_printk(
+			KERN_DEBUG, "Session key encryption key (size [%d]):\n",
+			auth_tok->token.password.session_key_encryption_key_bytes);
+		ecryptfs_dump_hex(
+			auth_tok->token.password.session_key_encryption_key,
+			auth_tok->token.password.session_key_encryption_key_bytes);
+	}
+	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(&desc.tfm, &tfm_mutex,
+							crypt_stat->cipher);
+	if (unlikely(rc)) {
+		printk(KERN_ERR "Internal error whilst attempting to get "
+		       "tfm and mutex for cipher name [%s]; rc = [%d]\n",
+		       crypt_stat->cipher, rc);
+		goto out;
+	}
+	if ((rc = virt_to_scatterlist(auth_tok->session_key.encrypted_key,
+				      auth_tok->session_key.encrypted_key_size,
+				      &src_sg, 1)) != 1) {
+		printk(KERN_ERR "Internal error whilst attempting to convert "
+			"auth_tok->session_key.encrypted_key to scatterlist; "
+			"expected rc = 1; got rc = [%d]. "
+		       "auth_tok->session_key.encrypted_key_size = [%d]\n", rc,
+			auth_tok->session_key.encrypted_key_size);
+		goto out;
 	}
-	if (tfm_mutex)
-		mutex_lock(tfm_mutex);
-	rc = crypto_blkcipher_setkey(desc.tfm,
-				     password_s_ptr->session_key_encryption_key,
-				     crypt_stat->key_size);
-	if (rc < 0) {
+	auth_tok->session_key.decrypted_key_size =
+		auth_tok->session_key.encrypted_key_size;
+	if ((rc = virt_to_scatterlist(auth_tok->session_key.decrypted_key,
+				      auth_tok->session_key.decrypted_key_size,
+				      &dst_sg, 1)) != 1) {
+		printk(KERN_ERR "Internal error whilst attempting to convert "
+			"auth_tok->session_key.decrypted_key to scatterlist; "
+			"expected rc = 1; got rc = [%d]\n", rc);
+		goto out;
+	}
+	mutex_lock(tfm_mutex);
+	rc = crypto_blkcipher_setkey(
+		desc.tfm, auth_tok->token.password.session_key_encryption_key,
+		crypt_stat->key_size);
+	if (unlikely(rc < 0)) {
+		mutex_unlock(tfm_mutex);
 		printk(KERN_ERR "Error setting key for crypto context\n");
 		rc = -EINVAL;
-		goto out_free_tfm;
-	}
-	/* TODO: virt_to_scatterlist */
-	encrypted_session_key = (char *)__get_free_page(GFP_KERNEL);
-	if (!encrypted_session_key) {
-		ecryptfs_printk(KERN_ERR, "Out of memory\n");
-		rc = -ENOMEM;
-		goto out_free_tfm;
-	}
-	session_key = (char *)__get_free_page(GFP_KERNEL);
-	if (!session_key) {
-		kfree(encrypted_session_key);
-		ecryptfs_printk(KERN_ERR, "Out of memory\n");
-		rc = -ENOMEM;
-		goto out_free_tfm;
+		goto out;
 	}
-	memcpy(encrypted_session_key, auth_tok->session_key.encrypted_key,
-	       auth_tok->session_key.encrypted_key_size);
-	src_sg[0].page = virt_to_page(encrypted_session_key);
-	src_sg[0].offset = 0;
-	BUG_ON(auth_tok->session_key.encrypted_key_size > PAGE_CACHE_SIZE);
-	src_sg[0].length = auth_tok->session_key.encrypted_key_size;
-	dst_sg[0].page = virt_to_page(session_key);
-	dst_sg[0].offset = 0;
-	auth_tok->session_key.decrypted_key_size =
-	    auth_tok->session_key.encrypted_key_size;
-	dst_sg[0].length = auth_tok->session_key.encrypted_key_size;
-	rc = crypto_blkcipher_decrypt(&desc, dst_sg, src_sg,
+	rc = crypto_blkcipher_decrypt(&desc, &dst_sg, &src_sg,
 				      auth_tok->session_key.encrypted_key_size);
-	if (rc) {
+	mutex_unlock(tfm_mutex);
+	if (unlikely(rc)) {
 		printk(KERN_ERR "Error decrypting; rc = [%d]\n", rc);
-		goto out_free_memory;
+		goto out;
 	}
-	auth_tok->session_key.decrypted_key_size =
-	    auth_tok->session_key.encrypted_key_size;
-	memcpy(auth_tok->session_key.decrypted_key, session_key,
-	       auth_tok->session_key.decrypted_key_size);
 	auth_tok->session_key.flags |= ECRYPTFS_CONTAINS_DECRYPTED_KEY;
 	memcpy(crypt_stat->key, auth_tok->session_key.decrypted_key,
 	       auth_tok->session_key.decrypted_key_size);
 	crypt_stat->flags |= ECRYPTFS_KEY_VALID;
-	ecryptfs_printk(KERN_DEBUG, "Decrypted session key:\n");
-	if (ecryptfs_verbosity > 0)
+	if (unlikely(ecryptfs_verbosity > 0)) {
+		ecryptfs_printk(KERN_DEBUG, "FEK of size [%d]:\n",
+				crypt_stat->key_size);
 		ecryptfs_dump_hex(crypt_stat->key,
 				  crypt_stat->key_size);
-out_free_memory:
-	memset(encrypted_session_key, 0, PAGE_CACHE_SIZE);
-	free_page((unsigned long)encrypted_session_key);
-	memset(session_key, 0, PAGE_CACHE_SIZE);
-	free_page((unsigned long)session_key);
-out_free_tfm:
-	if (tfm_mutex)
-		mutex_unlock(tfm_mutex);
-	else
-		crypto_free_blkcipher(desc.tfm);
+	}
 out:
 	return rc;
 }
 
+int ecryptfs_get_auth_tok_sig(char **sig, struct ecryptfs_auth_tok *auth_tok)
+{
+	int rc = 0;
+
+	(*sig) = NULL;
+	switch (auth_tok->token_type) {
+	case ECRYPTFS_PASSWORD:
+		(*sig) = auth_tok->token.password.signature;
+		break;
+	case ECRYPTFS_PRIVATE_KEY:
+		(*sig) = auth_tok->token.private_key.signature;
+		break;
+	default:
+		printk(KERN_ERR "Cannot get sig for auth_tok of type [%d]\n",
+		       auth_tok->token_type);
+		rc = -EINVAL;
+	}
+	return rc;
+}
+
 /**
  * ecryptfs_parse_packet_set
  * @dest: The header page in memory
@@ -1058,25 +1177,22 @@ int ecryptfs_parse_packet_set(struct ecr
 			      struct dentry *ecryptfs_dentry)
 {
 	size_t i = 0;
-	size_t found_auth_tok = 0;
+	size_t found_auth_tok;
 	size_t next_packet_is_auth_tok_packet;
-	char sig[ECRYPTFS_SIG_SIZE_HEX];
 	struct list_head auth_tok_list;
-	struct list_head *walker;
-	struct ecryptfs_auth_tok *chosen_auth_tok = NULL;
-	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
-		&ecryptfs_superblock_to_private(
-			ecryptfs_dentry->d_sb)->mount_crypt_stat;
+	struct ecryptfs_auth_tok *matching_auth_tok = NULL;
 	struct ecryptfs_auth_tok *candidate_auth_tok = NULL;
+	char *candidate_auth_tok_sig;
 	size_t packet_size;
 	struct ecryptfs_auth_tok *new_auth_tok;
 	unsigned char sig_tmp_space[ECRYPTFS_SIG_SIZE];
+	struct ecryptfs_auth_tok_list_item *auth_tok_list_item;
 	size_t tag_11_contents_size;
 	size_t tag_11_packet_size;
 	int rc = 0;
 
 	INIT_LIST_HEAD(&auth_tok_list);
-	/* Parse the header to find as many packets as we can, these will be
+	/* Parse the header to find as many packets as we can; these will be
 	 * added the our &auth_tok_list */
 	next_packet_is_auth_tok_packet = 1;
 	while (next_packet_is_auth_tok_packet) {
@@ -1155,73 +1271,86 @@ int ecryptfs_parse_packet_set(struct ecr
 		}
 	}
 	if (list_empty(&auth_tok_list)) {
-		rc = -EINVAL; /* Do not support non-encrypted files in
-			       * the 0.1 release */
+		printk(KERN_ERR "The lower file appears to be a non-encrypted "
+		       "eCryptfs file; this is not supported in this version "
+		       "of the eCryptfs kernel module\n");
+		rc = -EINVAL;
 		goto out;
 	}
-	/* If we have a global auth tok, then we should try to use
-	 * it */
-	if (mount_crypt_stat->global_auth_tok) {
-		memcpy(sig, mount_crypt_stat->global_auth_tok_sig,
-		       ECRYPTFS_SIG_SIZE_HEX);
-		chosen_auth_tok = mount_crypt_stat->global_auth_tok;
-	} else
-		BUG(); /* We should always have a global auth tok in
-			* the 0.1 release */
-	/* Scan list to see if our chosen_auth_tok works */
-	list_for_each(walker, &auth_tok_list) {
-		struct ecryptfs_auth_tok_list_item *auth_tok_list_item;
-		auth_tok_list_item =
-		    list_entry(walker, struct ecryptfs_auth_tok_list_item,
-			       list);
+	/* auth_tok_list contains the set of authentication tokens
+	 * parsed from the metadata. We need to find a matching
+	 * authentication token that has the secret component(s)
+	 * necessary to decrypt the EFEK in the auth_tok parsed from
+	 * the metadata. There may be several potential matches, but
+	 * just one will be sufficient to decrypt to get the FEK. */
+find_next_matching_auth_tok:
+	found_auth_tok = 0;
+	list_for_each_entry(auth_tok_list_item, &auth_tok_list, list) {
 		candidate_auth_tok = &auth_tok_list_item->auth_tok;
 		if (unlikely(ecryptfs_verbosity > 0)) {
 			ecryptfs_printk(KERN_DEBUG,
 					"Considering cadidate auth tok:\n");
 			ecryptfs_dump_auth_tok(candidate_auth_tok);
 		}
-		/* TODO: Replace ECRYPTFS_SIG_SIZE_HEX w/ dynamic value */
-		if (candidate_auth_tok->token_type == ECRYPTFS_PASSWORD
-		    && !strncmp(candidate_auth_tok->token.password.signature,
-				sig, ECRYPTFS_SIG_SIZE_HEX)) {
-			found_auth_tok = 1;
-			goto leave_list;
-			/* TODO: Transfer the common salt into the
-			 * crypt_stat salt */
-		} else if ((candidate_auth_tok->token_type
-			    == ECRYPTFS_PRIVATE_KEY)
-			   && !strncmp(candidate_auth_tok->token.private_key.signature,
-				     sig, ECRYPTFS_SIG_SIZE_HEX)) {
+		if ((rc = ecryptfs_get_auth_tok_sig(&candidate_auth_tok_sig,
+						    candidate_auth_tok))) {
+			printk(KERN_ERR
+			       "Unrecognized candidate auth tok type: [%d]\n",
+			       candidate_auth_tok->token_type);
+			rc = -EINVAL;
+			goto out_wipe_list;
+		}
+		if ((rc = ecryptfs_find_auth_tok_for_sig(
+			     &matching_auth_tok, crypt_stat,
+			     candidate_auth_tok_sig)))
+			rc = 0;
+		if (matching_auth_tok) {
 			found_auth_tok = 1;
-			goto leave_list;
+			goto found_matching_auth_tok;
 		}
 	}
 	if (!found_auth_tok) {
-		ecryptfs_printk(KERN_ERR, "Could not find authentication "
-				"token on temporary list for sig [%.*s]\n",
-				ECRYPTFS_SIG_SIZE_HEX, sig);
+		ecryptfs_printk(KERN_ERR, "Could not find a usable "
+				"authentication token\n");
 		rc = -EIO;
 		goto out_wipe_list;
 	}
-leave_list:
-	rc = -ENOTSUPP;
+found_matching_auth_tok:
 	if (candidate_auth_tok->token_type == ECRYPTFS_PRIVATE_KEY) {
 		memcpy(&(candidate_auth_tok->token.private_key),
-		       &(chosen_auth_tok->token.private_key),
+		       &(matching_auth_tok->token.private_key),
 		       sizeof(struct ecryptfs_private_key));
-		rc = decrypt_pki_encrypted_session_key(mount_crypt_stat,
-						       candidate_auth_tok,
+		rc = decrypt_pki_encrypted_session_key(candidate_auth_tok,
 						       crypt_stat);
 	} else if (candidate_auth_tok->token_type == ECRYPTFS_PASSWORD) {
 		memcpy(&(candidate_auth_tok->token.password),
-		       &(chosen_auth_tok->token.password),
+		       &(matching_auth_tok->token.password),
 		       sizeof(struct ecryptfs_password));
-		rc = decrypt_session_key(candidate_auth_tok, crypt_stat);
+		rc = decrypt_passphrase_encrypted_session_key(
+			candidate_auth_tok, crypt_stat);
 	}
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error decrypting the "
-				"session key; rc = [%d]\n", rc);
-		goto out_wipe_list;
+		struct ecryptfs_auth_tok_list_item *auth_tok_list_item_tmp;
+
+		ecryptfs_printk(KERN_WARNING, "Error decrypting the "
+				"session key for authentication token with sig "
+				"[%.*s]; rc = [%d]. Removing auth tok "
+				"candidate from the list and searching for "
+				"the next match.\n", candidate_auth_tok_sig,
+				ECRYPTFS_SIG_SIZE_HEX, rc);
+		list_for_each_entry_safe(auth_tok_list_item,
+					 auth_tok_list_item_tmp,
+					 &auth_tok_list, list) {
+			if (candidate_auth_tok
+			    == &auth_tok_list_item->auth_tok) {
+				list_del(&auth_tok_list_item->list);
+				kmem_cache_free(
+					ecryptfs_auth_tok_list_item_cache,
+					auth_tok_list_item);
+				goto find_next_matching_auth_tok;
+			}
+		}
+		BUG();
 	}
 	rc = ecryptfs_compute_root_iv(crypt_stat);
 	if (rc) {
@@ -1240,6 +1369,7 @@ out_wipe_list:
 out:
 	return rc;
 }
+
 static int
 pki_encrypt_session_key(struct ecryptfs_auth_tok *auth_tok,
 			struct ecryptfs_crypt_stat *crypt_stat,
@@ -1291,15 +1421,15 @@ out:
  * Returns zero on success; non-zero on error.
  */
 static int
-write_tag_1_packet(char *dest, size_t max, struct ecryptfs_auth_tok *auth_tok,
+write_tag_1_packet(char *dest, size_t *remaining_bytes,
+		   struct ecryptfs_auth_tok *auth_tok,
 		   struct ecryptfs_crypt_stat *crypt_stat,
-		   struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
 		   struct ecryptfs_key_record *key_rec, size_t *packet_size)
 {
 	size_t i;
 	size_t encrypted_session_key_valid = 0;
-	size_t key_rec_size;
 	size_t packet_size_length;
+	size_t max_packet_size;
 	int rc = 0;
 
 	(*packet_size) = 0;
@@ -1329,37 +1459,23 @@ write_tag_1_packet(char *dest, size_t ma
 		ecryptfs_dump_hex(key_rec->enc_key, key_rec->enc_key_size);
 	}
 encrypted_session_key_set:
-	/* Now we have a valid key_rec.  Append it to the
-	 * key_rec set. */
-	key_rec_size = (sizeof(struct ecryptfs_key_record)
-			- ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES
-			+ (key_rec->enc_key_size));
-	/* TODO: Include a packet size limit as a parameter to this
-	 * function once we have multi-packet headers (for versions
-	 * later than 0.1 */
-	if (key_rec_size >= ECRYPTFS_MAX_KEYSET_SIZE) {
-		ecryptfs_printk(KERN_ERR, "Keyset too large\n");
-		rc = -EINVAL;
-		goto out;
-	}
-	/*              ***** TAG 1 Packet Format *****
-	 *    | version number                     | 1 byte       |
-	 *    | key ID                             | 8 bytes      |
-	 *    | public key algorithm               | 1 byte       |
-	 *    | encrypted session key              | arbitrary    |
-	 */
-	if ((0x02 + ECRYPTFS_SIG_SIZE + key_rec->enc_key_size) >= max) {
-		ecryptfs_printk(KERN_ERR,
-				"Authentication token is too large\n");
+	/* This format is inspired by OpenPGP; see RFC 2440
+	 * packet tag 1 */
+	max_packet_size = (1                         /* Tag 1 identifier */
+			   + 3                       /* Max Tag 1 packet size */
+			   + 1                       /* Version */
+			   + ECRYPTFS_SIG_SIZE       /* Key identifier */
+			   + 1                       /* Cipher identifier */
+			   + key_rec->enc_key_size); /* Encrypted key size */
+	if (max_packet_size > (*remaining_bytes)) {
+		printk(KERN_ERR "Packet length larger than maximum allowable; "
+		       "need up to [%d] bytes, but there are only [%d] "
+		       "available\n", max_packet_size, (*remaining_bytes));
 		rc = -EINVAL;
 		goto out;
 	}
 	dest[(*packet_size)++] = ECRYPTFS_TAG_1_PACKET_TYPE;
-	/* This format is inspired by OpenPGP; see RFC 2440
-	 * packet tag 1 */
-	rc = write_packet_length(&dest[(*packet_size)],
-				 (0x02 + ECRYPTFS_SIG_SIZE +
-				 key_rec->enc_key_size),
+	rc = write_packet_length(&dest[(*packet_size)], (max_packet_size - 4),
 				 &packet_size_length);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error generating tag 1 packet "
@@ -1377,6 +1493,8 @@ encrypted_session_key_set:
 out:
 	if (rc)
 		(*packet_size) = 0;
+	else
+		(*remaining_bytes) -= (*packet_size);
 	return rc;
 }
 
@@ -1448,19 +1566,22 @@ write_tag_11_packet(char *dest, int max,
  * Returns zero on success; non-zero on error.
  */
 static int
-write_tag_3_packet(char *dest, size_t max, struct ecryptfs_auth_tok *auth_tok,
+write_tag_3_packet(char *dest, size_t *remaining_bytes,
+		   struct ecryptfs_auth_tok *auth_tok,
 		   struct ecryptfs_crypt_stat *crypt_stat,
 		   struct ecryptfs_key_record *key_rec, size_t *packet_size)
 {
 	size_t i;
 	size_t encrypted_session_key_valid = 0;
 	char session_key_encryption_key[ECRYPTFS_MAX_KEY_BYTES];
-	struct scatterlist dest_sg[2];
-	struct scatterlist src_sg[2];
+	struct scatterlist dst_sg;
+	struct scatterlist src_sg;
 	struct mutex *tfm_mutex = NULL;
-	size_t key_rec_size;
-	size_t packet_size_length;
 	size_t cipher_code;
+	size_t packet_size_length;
+	size_t max_packet_size;
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
+		crypt_stat->mount_crypt_stat;
 	struct blkcipher_desc desc = {
 		.tfm = NULL,
 		.flags = CRYPTO_TFM_REQ_MAY_SLEEP
@@ -1470,16 +1591,25 @@ write_tag_3_packet(char *dest, size_t ma
 	(*packet_size) = 0;
 	ecryptfs_from_hex(key_rec->sig, auth_tok->token.password.signature,
 			  ECRYPTFS_SIG_SIZE);
-	encrypted_session_key_valid = 0;
-	for (i = 0; i < crypt_stat->key_size; i++)
-		encrypted_session_key_valid |=
-			auth_tok->session_key.encrypted_key[i];
-	if (encrypted_session_key_valid) {
-		memcpy(key_rec->enc_key,
-		       auth_tok->session_key.encrypted_key,
-		       auth_tok->session_key.encrypted_key_size);
-		goto encrypted_session_key_set;
+	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(&desc.tfm, &tfm_mutex,
+							crypt_stat->cipher);
+	if (unlikely(rc)) {
+		printk(KERN_ERR "Internal error whilst attempting to get "
+		       "tfm and mutex for cipher name [%s]; rc = [%d]\n",
+		       crypt_stat->cipher, rc);
+		goto out;
+	}
+	if (mount_crypt_stat->global_default_cipher_key_size == 0) {
+		struct blkcipher_alg *alg = crypto_blkcipher_alg(desc.tfm);
+
+		printk(KERN_WARNING "No key size specified at mount; "
+		       "defaulting to [%d]\n", alg->max_keysize);
+		mount_crypt_stat->global_default_cipher_key_size =
+			alg->max_keysize;
 	}
+	if (crypt_stat->key_size == 0)
+		crypt_stat->key_size =
+			mount_crypt_stat->global_default_cipher_key_size;
 	if (auth_tok->session_key.encrypted_key_size == 0)
 		auth_tok->session_key.encrypted_key_size =
 			crypt_stat->key_size;
@@ -1487,9 +1617,24 @@ write_tag_3_packet(char *dest, size_t ma
 	    && strcmp("aes", crypt_stat->cipher) == 0) {
 		memset((crypt_stat->key + 24), 0, 8);
 		auth_tok->session_key.encrypted_key_size = 32;
-	}
+	} else
+		auth_tok->session_key.encrypted_key_size = crypt_stat->key_size;
 	key_rec->enc_key_size =
 		auth_tok->session_key.encrypted_key_size;
+	encrypted_session_key_valid = 0;
+	for (i = 0; i < auth_tok->session_key.encrypted_key_size; i++)
+		encrypted_session_key_valid |=
+			auth_tok->session_key.encrypted_key[i];
+	if (encrypted_session_key_valid) {
+		ecryptfs_printk(KERN_DEBUG, "encrypted_session_key_valid != 0; "
+				"using auth_tok->session_key.encrypted_key, "
+				"where key_rec->enc_key_size = [%d]\n",
+				key_rec->enc_key_size);
+		memcpy(key_rec->enc_key,
+		       auth_tok->session_key.encrypted_key,
+		       key_rec->enc_key_size);
+		goto encrypted_session_key_set;
+	}
 	if (auth_tok->token.password.flags &
 	    ECRYPTFS_SESSION_KEY_ENCRYPTION_KEY_SET) {
 		ecryptfs_printk(KERN_DEBUG, "Using previously generated "
@@ -1508,54 +1653,32 @@ write_tag_3_packet(char *dest, size_t ma
 		ecryptfs_printk(KERN_DEBUG, "Session key encryption key:\n");
 		ecryptfs_dump_hex(session_key_encryption_key, 16);
 	}
-	rc = virt_to_scatterlist(crypt_stat->key,
-				 key_rec->enc_key_size, src_sg, 2);
-	if (!rc) {
+	if ((rc = virt_to_scatterlist(crypt_stat->key,
+				      key_rec->enc_key_size, &src_sg, 1))
+	    != 1) {
 		ecryptfs_printk(KERN_ERR, "Error generating scatterlist "
-				"for crypt_stat session key\n");
+				"for crypt_stat session key; expected rc = 1; "
+				"got rc = [%d]. key_rec->enc_key_size = [%d]\n",
+				rc, key_rec->enc_key_size);
 		rc = -ENOMEM;
 		goto out;
 	}
-	rc = virt_to_scatterlist(key_rec->enc_key,
-				 key_rec->enc_key_size, dest_sg, 2);
-	if (!rc) {
+	if ((rc = virt_to_scatterlist(key_rec->enc_key,
+				      key_rec->enc_key_size, &dst_sg, 1))
+	    != 1) {
 		ecryptfs_printk(KERN_ERR, "Error generating scatterlist "
-				"for crypt_stat encrypted session key\n");
+				"for crypt_stat encrypted session key; "
+				"expected rc = 1; got rc = [%d]. "
+				"key_rec->enc_key_size = [%d]\n", rc,
+				key_rec->enc_key_size);
 		rc = -ENOMEM;
 		goto out;
 	}
-	if (!strcmp(crypt_stat->cipher,
-		    crypt_stat->mount_crypt_stat->global_default_cipher_name)
-	    && crypt_stat->mount_crypt_stat->global_key_tfm) {
-		desc.tfm = crypt_stat->mount_crypt_stat->global_key_tfm;
-		tfm_mutex = &crypt_stat->mount_crypt_stat->global_key_tfm_mutex;
-	} else {
-		char *full_alg_name;
-
-		rc = ecryptfs_crypto_api_algify_cipher_name(&full_alg_name,
-							    crypt_stat->cipher,
-							    "ecb");
-		if (rc)
-			goto out;
-		desc.tfm = crypto_alloc_blkcipher(full_alg_name, 0,
-						  CRYPTO_ALG_ASYNC);
-		kfree(full_alg_name);
-		if (IS_ERR(desc.tfm)) {
-			rc = PTR_ERR(desc.tfm);
-			ecryptfs_printk(KERN_ERR, "Could not initialize crypto "
-					"context for cipher [%s]; rc = [%d]\n",
-					crypt_stat->cipher, rc);
-			goto out;
-		}
-		crypto_blkcipher_set_flags(desc.tfm, CRYPTO_TFM_REQ_WEAK_KEY);
-	}
-	if (tfm_mutex)
-		mutex_lock(tfm_mutex);
+	mutex_lock(tfm_mutex);
 	rc = crypto_blkcipher_setkey(desc.tfm, session_key_encryption_key,
 				     crypt_stat->key_size);
 	if (rc < 0) {
-		if (tfm_mutex)
-			mutex_unlock(tfm_mutex);
+		mutex_unlock(tfm_mutex);
 		ecryptfs_printk(KERN_ERR, "Error setting key for crypto "
 				"context; rc = [%d]\n", rc);
 		goto out;
@@ -1563,56 +1686,53 @@ write_tag_3_packet(char *dest, size_t ma
 	rc = 0;
 	ecryptfs_printk(KERN_DEBUG, "Encrypting [%d] bytes of the key\n",
 			crypt_stat->key_size);
-	rc = crypto_blkcipher_encrypt(&desc, dest_sg, src_sg,
+	rc = crypto_blkcipher_encrypt(&desc, &dst_sg, &src_sg,
 				      (*key_rec).enc_key_size);
+	mutex_unlock(tfm_mutex);
 	if (rc) {
 		printk(KERN_ERR "Error encrypting; rc = [%d]\n", rc);
 		goto out;
 	}
-	if (tfm_mutex)
-		mutex_unlock(tfm_mutex);
 	ecryptfs_printk(KERN_DEBUG, "This should be the encrypted key:\n");
-	if (ecryptfs_verbosity > 0)
+	if (ecryptfs_verbosity > 0) {
+		ecryptfs_printk(KERN_DEBUG, "EFEK of size [%d]:\n",
+				key_rec->enc_key_size);
 		ecryptfs_dump_hex(key_rec->enc_key,
 				  key_rec->enc_key_size);
-encrypted_session_key_set:
-	/* Now we have a valid key_rec.  Append it to the
-	 * key_rec set. */
-	key_rec_size = (sizeof(struct ecryptfs_key_record)
-			- ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES
-			+ (key_rec->enc_key_size));
-	/* TODO: Include a packet size limit as a parameter to this
-	 * function once we have multi-packet headers (for versions
-	 * later than 0.1 */
-	if (key_rec_size >= ECRYPTFS_MAX_KEYSET_SIZE) {
-		ecryptfs_printk(KERN_ERR, "Keyset too large\n");
-		rc = -EINVAL;
-		goto out;
 	}
-	/* TODO: Packet size limit */
-	/* We have 5 bytes of surrounding packet data */
-	if ((0x05 + ECRYPTFS_SALT_SIZE
-	     + key_rec->enc_key_size) >= max) {
-		ecryptfs_printk(KERN_ERR, "Authentication token is too "
-				"large\n");
+encrypted_session_key_set:
+	/* This format is inspired by OpenPGP; see RFC 2440
+	 * packet tag 3 */
+	max_packet_size = (1                         /* Tag 3 identifier */
+			   + 3                       /* Max Tag 3 packet size */
+			   + 1                       /* Version */
+			   + 1                       /* Cipher code */
+			   + 1                       /* S2K specifier */
+			   + 1                       /* Hash identifier */
+			   + ECRYPTFS_SALT_SIZE      /* Salt */
+			   + 1                       /* Hash iterations */
+			   + key_rec->enc_key_size); /* Encrypted key size */
+	if (max_packet_size > (*remaining_bytes)) {
+		printk(KERN_ERR "Packet too large; need up to [%d] bytes, but "
+		       "there are only [%d] available\n", max_packet_size,
+		       (*remaining_bytes));
 		rc = -EINVAL;
 		goto out;
 	}
-	/* This format is inspired by OpenPGP; see RFC 2440
-	 * packet tag 3 */
 	dest[(*packet_size)++] = ECRYPTFS_TAG_3_PACKET_TYPE;
-	/* ver+cipher+s2k+hash+salt+iter+enc_key */
-	rc = write_packet_length(&dest[(*packet_size)],
-				 (0x05 + ECRYPTFS_SALT_SIZE
-				  + key_rec->enc_key_size),
+	/* Chop off the Tag 3 identifier(1) and Tag 3 packet size(3)
+	 * to get the number of octets in the actual Tag 3 packet */
+	rc = write_packet_length(&dest[(*packet_size)], (max_packet_size - 4),
 				 &packet_size_length);
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error generating tag 3 packet "
-				"header; cannot generate packet length\n");
+		printk(KERN_ERR "Error generating tag 3 packet header; cannot "
+		       "generate packet length. rc = [%d]\n", rc);
 		goto out;
 	}
 	(*packet_size) += packet_size_length;
 	dest[(*packet_size)++] = 0x04; /* version 4 */
+	/* TODO: Break from RFC2440 so that arbitrary ciphers can be
+	 * specified with strings */
 	cipher_code = ecryptfs_code_for_cipher_string(crypt_stat);
 	if (cipher_code == 0) {
 		ecryptfs_printk(KERN_WARNING, "Unable to generate code for "
@@ -1631,10 +1751,10 @@ encrypted_session_key_set:
 	       key_rec->enc_key_size);
 	(*packet_size) += key_rec->enc_key_size;
 out:
-	if (desc.tfm && !tfm_mutex)
-		crypto_free_blkcipher(desc.tfm);
 	if (rc)
 		(*packet_size) = 0;
+	else
+		(*remaining_bytes) -= (*packet_size);
 	return rc;
 }
 
@@ -1662,24 +1782,43 @@ ecryptfs_generate_key_packet_set(char *d
 				 size_t max)
 {
 	struct ecryptfs_auth_tok *auth_tok;
+	struct ecryptfs_global_auth_tok *global_auth_tok;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
 		&ecryptfs_superblock_to_private(
 			ecryptfs_dentry->d_sb)->mount_crypt_stat;
 	size_t written;
 	struct ecryptfs_key_record *key_rec;
+	struct ecryptfs_key_sig *key_sig;
 	int rc = 0;
 
 	(*len) = 0;
+	mutex_lock(&crypt_stat->keysig_list_mutex);
 	key_rec = kmem_cache_alloc(ecryptfs_key_record_cache, GFP_KERNEL);
 	if (!key_rec) {
 		rc = -ENOMEM;
 		goto out;
 	}
-	if (mount_crypt_stat->global_auth_tok) {
-		auth_tok = mount_crypt_stat->global_auth_tok;
+	list_for_each_entry(key_sig, &crypt_stat->keysig_list,
+			    crypt_stat_list) {
+		memset(key_rec, 0, sizeof(*key_rec));
+		rc = ecryptfs_find_global_auth_tok_for_sig(&global_auth_tok,
+							   mount_crypt_stat,
+							   key_sig->keysig);
+		if (rc) {
+			printk(KERN_ERR "Error attempting to get the global "
+			       "auth_tok; rc = [%d]\n", rc);
+			goto out_free;
+		}
+		if (global_auth_tok->flags & ECRYPTFS_AUTH_TOK_INVALID) {
+			printk(KERN_WARNING
+			       "Skipping invalid auth tok with sig = [%s]\n",
+			       global_auth_tok->sig);
+			continue;
+		}
+		auth_tok = global_auth_tok->global_auth_tok;
 		if (auth_tok->token_type == ECRYPTFS_PASSWORD) {
 			rc = write_tag_3_packet((dest_base + (*len)),
-						max, auth_tok,
+						&max, auth_tok,
 						crypt_stat, key_rec,
 						&written);
 			if (rc) {
@@ -1689,10 +1828,9 @@ ecryptfs_generate_key_packet_set(char *d
 			}
 			(*len) += written;
 			/* Write auth tok signature packet */
-			rc = write_tag_11_packet(
-				(dest_base + (*len)),
-				(max - (*len)),
-				key_rec->sig, ECRYPTFS_SIG_SIZE, &written);
+			rc = write_tag_11_packet((dest_base + (*len)), &max,
+						 key_rec->sig,
+						 ECRYPTFS_SIG_SIZE, &written);
 			if (rc) {
 				ecryptfs_printk(KERN_ERR, "Error writing "
 						"auth tok signature packet\n");
@@ -1701,9 +1839,8 @@ ecryptfs_generate_key_packet_set(char *d
 			(*len) += written;
 		} else if (auth_tok->token_type == ECRYPTFS_PRIVATE_KEY) {
 			rc = write_tag_1_packet(dest_base + (*len),
-						max, auth_tok,
-						crypt_stat,mount_crypt_stat,
-						key_rec, &written);
+						&max, auth_tok,
+						crypt_stat, key_rec, &written);
 			if (rc) {
 				ecryptfs_printk(KERN_WARNING, "Error "
 						"writing tag 1 packet\n");
@@ -1716,19 +1853,69 @@ ecryptfs_generate_key_packet_set(char *d
 			rc = -EINVAL;
 			goto out_free;
 		}
-	} else
-		BUG();
-	if (likely((max - (*len)) > 0)) {
+	}
+	if (likely(max > 0)) {
 		dest_base[(*len)] = 0x00;
 	} else {
 		ecryptfs_printk(KERN_ERR, "Error writing boundary byte\n");
 		rc = -EIO;
 	}
-
 out_free:
 	kmem_cache_free(ecryptfs_key_record_cache, key_rec);
 out:
 	if (rc)
 		(*len) = 0;
+	mutex_unlock(&crypt_stat->keysig_list_mutex);
 	return rc;
 }
+
+struct kmem_cache *ecryptfs_key_sig_cache;
+
+int ecryptfs_add_keysig(struct ecryptfs_crypt_stat *crypt_stat, char *sig)
+{
+	struct ecryptfs_key_sig *new_key_sig;
+	int rc = 0;
+
+	new_key_sig = kmem_cache_alloc(ecryptfs_key_sig_cache, GFP_KERNEL);
+	if (!new_key_sig) {
+		rc = -ENOMEM;
+		printk(KERN_ERR
+		       "Error allocating from ecryptfs_key_sig_cache\n");
+		goto out;
+	}
+	memcpy(new_key_sig->keysig, sig, ECRYPTFS_SIG_SIZE_HEX);
+	mutex_lock(&crypt_stat->keysig_list_mutex);
+	list_add(&new_key_sig->crypt_stat_list, &crypt_stat->keysig_list);
+	mutex_unlock(&crypt_stat->keysig_list_mutex);
+out:
+	return rc;
+}
+
+struct kmem_cache *ecryptfs_global_auth_tok_cache;
+
+int
+ecryptfs_add_global_auth_tok(struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
+			     char *sig)
+{
+	struct ecryptfs_global_auth_tok *new_auth_tok;
+	int rc = 0;
+
+	new_auth_tok = kmem_cache_alloc(ecryptfs_global_auth_tok_cache,
+					GFP_KERNEL);
+	if (!new_auth_tok) {
+		rc = -ENOMEM;
+		printk(KERN_ERR "Error allocating from "
+		       "ecryptfs_global_auth_tok_cache\n");
+		goto out;
+	}
+	memcpy(new_auth_tok->sig, sig, ECRYPTFS_SIG_SIZE_HEX);
+	new_auth_tok->sig[ECRYPTFS_SIG_SIZE_HEX] = '\0';
+	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
+	list_add(&new_auth_tok->mount_crypt_stat_list,
+		 &mount_crypt_stat->global_auth_tok_list);
+	mount_crypt_stat->num_global_auth_toks++;
+	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
+out:
+	return rc;
+}
+
diff -puN fs/ecryptfs/main.c~ecryptfs-add-key-list-structure-search-keyring fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-add-key-list-structure-search-keyring
+++ a/fs/ecryptfs/main.c
@@ -179,38 +179,40 @@ static match_table_t tokens = {
 	{ecryptfs_opt_err, NULL}
 };
 
-/**
- * ecryptfs_verify_version
- * @version: The version number to confirm
- *
- * Returns zero on good version; non-zero otherwise
- */
-static int ecryptfs_verify_version(u16 version)
+static int ecryptfs_init_global_auth_toks(
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
 {
+	struct ecryptfs_global_auth_tok *global_auth_tok;
 	int rc = 0;
-	unsigned char major;
-	unsigned char minor;
 
-	major = ((version >> 8) & 0xFF);
-	minor = (version & 0xFF);
-	if (major != ECRYPTFS_VERSION_MAJOR) {
-		ecryptfs_printk(KERN_ERR, "Major version number mismatch. "
-				"Expected [%d]; got [%d]\n",
-				ECRYPTFS_VERSION_MAJOR, major);
-		rc = -EINVAL;
-		goto out;
-	}
-	if (minor != ECRYPTFS_VERSION_MINOR) {
-		ecryptfs_printk(KERN_ERR, "Minor version number mismatch. "
-				"Expected [%d]; got [%d]\n",
-				ECRYPTFS_VERSION_MINOR, minor);
-		rc = -EINVAL;
-		goto out;
+	list_for_each_entry(global_auth_tok,
+			    &mount_crypt_stat->global_auth_tok_list,
+			    mount_crypt_stat_list) {
+		if ((rc = ecryptfs_keyring_auth_tok_for_sig(
+			     &global_auth_tok->global_auth_tok_key,
+			     &global_auth_tok->global_auth_tok,
+			     global_auth_tok->sig))) {
+			printk(KERN_ERR "Could not find valid key in user "
+			       "session keyring for sig specified in mount "
+			       "option: [%s]\n", global_auth_tok->sig);
+			global_auth_tok->flags |= ECRYPTFS_AUTH_TOK_INVALID;
+			rc = 0;
+		} else
+			global_auth_tok->flags &= ~ECRYPTFS_AUTH_TOK_INVALID;
 	}
-out:
 	return rc;
 }
 
+static void ecryptfs_init_mount_crypt_stat(
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
+{
+	memset((void *)mount_crypt_stat, 0,
+	       sizeof(struct ecryptfs_mount_crypt_stat));
+	INIT_LIST_HEAD(&mount_crypt_stat->global_auth_tok_list);
+	mutex_init(&mount_crypt_stat->global_auth_tok_list_mutex);
+	mount_crypt_stat->flags |= ECRYPTFS_MOUNT_CRYPT_STAT_INITIALIZED;
+}
+
 /**
  * ecryptfs_parse_options
  * @sb: The ecryptfs super block
@@ -264,14 +266,13 @@ static int ecryptfs_parse_options(struct
 		case ecryptfs_opt_sig:
 		case ecryptfs_opt_ecryptfs_sig:
 			sig_src = args[0].from;
-			sig_dst =
-				mount_crypt_stat->global_auth_tok_sig;
-			memcpy(sig_dst, sig_src, ECRYPTFS_SIG_SIZE_HEX);
-			sig_dst[ECRYPTFS_SIG_SIZE_HEX] = '\0';
-			ecryptfs_printk(KERN_DEBUG,
-					"The mount_crypt_stat "
-					"global_auth_tok_sig set to: "
-					"[%s]\n", sig_dst);
+			rc = ecryptfs_add_global_auth_tok(mount_crypt_stat,
+							  sig_src);
+			if (rc) {
+				printk(KERN_ERR "Error attempting to register "
+				       "global sig; rc = [%d]\n", rc);
+				goto out;
+			}
 			sig_set = 1;
 			break;
 		case ecryptfs_opt_debug:
@@ -358,55 +359,21 @@ static int ecryptfs_parse_options(struct
 	if (!cipher_key_bytes_set) {
 		mount_crypt_stat->global_default_cipher_key_size = 0;
 	}
-	rc = ecryptfs_process_cipher(
-		&mount_crypt_stat->global_key_tfm,
-		mount_crypt_stat->global_default_cipher_name,
-		&mount_crypt_stat->global_default_cipher_key_size);
-	if (rc) {
-		printk(KERN_ERR "Error attempting to initialize cipher [%s] "
-		       "with key size [%Zd] bytes; rc = [%d]\n",
+	if ((rc = ecryptfs_add_new_key_tfm(
+		     NULL, mount_crypt_stat->global_default_cipher_name,
+		     mount_crypt_stat->global_default_cipher_key_size))) {
+		printk(KERN_ERR "Error attempting to initialize cipher with "
+		       "name = [%s] and key size = [%d]; rc = [%d]\n",
 		       mount_crypt_stat->global_default_cipher_name,
 		       mount_crypt_stat->global_default_cipher_key_size, rc);
-		mount_crypt_stat->global_key_tfm = NULL;
-		mount_crypt_stat->global_auth_tok_key = NULL;
-		rc = -EINVAL;
-		goto out;
-	}
-	mutex_init(&mount_crypt_stat->global_key_tfm_mutex);
-	ecryptfs_printk(KERN_DEBUG, "Requesting the key with description: "
-			"[%s]\n", mount_crypt_stat->global_auth_tok_sig);
-	/* The reference to this key is held until umount is done The
-	 * call to key_put is done in ecryptfs_put_super() */
-	auth_tok_key = request_key(&key_type_user,
-				   mount_crypt_stat->global_auth_tok_sig,
-				   NULL);
-	if (!auth_tok_key || IS_ERR(auth_tok_key)) {
-		ecryptfs_printk(KERN_ERR, "Could not find key with "
-				"description: [%s]\n",
-				mount_crypt_stat->global_auth_tok_sig);
-		process_request_key_err(PTR_ERR(auth_tok_key));
 		rc = -EINVAL;
 		goto out;
 	}
-	auth_tok = ecryptfs_get_key_payload_data(auth_tok_key);
-	if (ecryptfs_verify_version(auth_tok->version)) {
-		ecryptfs_printk(KERN_ERR, "Data structure version mismatch. "
-				"Userspace tools must match eCryptfs kernel "
-				"module with major version [%d] and minor "
-				"version [%d]\n", ECRYPTFS_VERSION_MAJOR,
-				ECRYPTFS_VERSION_MINOR);
-		rc = -EINVAL;
-		goto out;
-	}
-	if (auth_tok->token_type != ECRYPTFS_PASSWORD
-	    && auth_tok->token_type != ECRYPTFS_PRIVATE_KEY) {
-		ecryptfs_printk(KERN_ERR, "Invalid auth_tok structure "
-				"returned from key query\n");
-		rc = -EINVAL;
-		goto out;
+	if ((rc = ecryptfs_init_global_auth_toks(mount_crypt_stat))) {
+		printk(KERN_WARNING "One or more global auth toks could not "
+		       "properly register; rc = [%d]\n", rc);
 	}
-	mount_crypt_stat->global_auth_tok_key = auth_tok_key;
-	mount_crypt_stat->global_auth_tok = auth_tok;
+	rc = 0;
 out:
 	return rc;
 }
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
fs-remove-some-aop_truncated_page-fix.patch
ecryptfs-add-key-list-structure-search-keyring.patch
ecryptfs-use-list_for_each_entry_safe-when-wiping-auth-toks.patch
ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch
ecryptfs-fix-tag-1-parsing-code.patch
ecryptfs-fix-tag-3-parsing-code.patch
ecryptfs-fix-tag-11-parsing-code.patch
ecryptfs-fix-tag-11-writing-code.patch
ecryptfs-update-comment-and-debug-statement.patch
