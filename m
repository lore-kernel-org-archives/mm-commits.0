From: akpm@linux-foundation.org
Subject: + ecryptfs-filename-encryption-tag-70-packets.patch added to -mm tree
Date: Wed, 12 Nov 2008 11:45:53 -0800
Message-ID: <200811121945.mACJjrgk008560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbYKLTqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 14:46:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, dustin.kirkland@gmail.com, sandeen@redhat.com, shaggy@us.ibm.com, tchicks@us.ibm.com


The patch titled
     eCryptfs: Filename Encryption: Tag 70 packets
has been added to the -mm tree.  Its filename is
     ecryptfs-filename-encryption-tag-70-packets.patch

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
Subject: eCryptfs: Filename Encryption: Tag 70 packets
From: Michael Halcrow <mhalcrow@us.ibm.com>

This patchset implements filename encryption via a passphrase-derived
mount-wide Filename Encryption Key (FNEK) specified as a mount parameter. 
Each encrypted filename has a fixed prefix indicating that eCryptfs should
try to decrypt the filename.  When eCryptfs encounters this prefix, it
decodes the filename into a tag 70 packet and then decrypts the packet
contents using the FNEK, setting the filename to the decrypted filename. 
Both unencrypted and encrypted filenames can reside in the same lower
filesystem.

Because filename encryption expands the length of the filename during the
encoding stage, eCryptfs will not properly handle filenames that are
already near the maximum filename length.

In the present implementation, eCryptfs must be able to produce a match
against the lower encrypted and encoded filename representation when given
a plaintext filename.  Therefore, two files having the same plaintext name
will encrypt and encode into the same lower filename if they are both
encrypted using the same FNEK.  This can be changed by finding a way to
replace the prepended bytes in the blocked-aligned filename with random
characters; they are hashes of the FNEK right now, so that it is possible
to deterministically map from a plaintext filename to an encrypted and
encoded filename in the lower filesystem.  An implementation using random
characters will have to decode and decrypt every single directory entry in
any given directory any time an event occurs wherein the VFS needs to
determine whether a particular file exists in the lower directory and the
decrypted and decoded filenames have not yet been extracted for that
directory.

Thanks to Tyler Hicks and David Kleikamp for assistance in the development
of this patchset.


This patch:

A tag 70 packet contains a filename encrypted with a Filename Encryption
Key (FNEK).  This patch implements functions for writing and parsing tag
70 packets.  This patch also adds definitions and extends structures to
support filename encryption.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dustin Kirkland <dustin.kirkland@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Tyler Hicks <tchicks@us.ibm.com>
Cc: David Kleikamp <shaggy@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |   11 
 fs/ecryptfs/ecryptfs_kernel.h |   38 +
 fs/ecryptfs/keystore.c        |  634 ++++++++++++++++++++++++++++----
 3 files changed, 613 insertions(+), 70 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-filename-encryption-tag-70-packets fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-filename-encryption-tag-70-packets
+++ a/fs/ecryptfs/crypto.c
@@ -1149,19 +1149,20 @@ ecryptfs_cipher_code_str_map[] = {
 
 /**
  * ecryptfs_code_for_cipher_string
- * @crypt_stat: The cryptographic context
+ * @cipher_name: The string alias for the cipher
+ * @key_bytes: Length of key in bytes; used for AES code selection
  *
  * Returns zero on no match, or the cipher code on match
  */
-u8 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat)
+u8 ecryptfs_code_for_cipher_string(char *cipher_name, size_t key_bytes)
 {
 	int i;
 	u8 code = 0;
 	struct ecryptfs_cipher_code_str_map_elem *map =
 		ecryptfs_cipher_code_str_map;
 
-	if (strcmp(crypt_stat->cipher, "aes") == 0) {
-		switch (crypt_stat->key_size) {
+	if (strcmp(cipher_name, "aes") == 0) {
+		switch (key_bytes) {
 		case 16:
 			code = RFC2440_CIPHER_AES_128;
 			break;
@@ -1173,7 +1174,7 @@ u8 ecryptfs_code_for_cipher_string(struc
 		}
 	} else {
 		for (i = 0; i < ARRAY_SIZE(ecryptfs_cipher_code_str_map); i++)
-			if (strcmp(crypt_stat->cipher, map[i].cipher_str) == 0){
+			if (strcmp(cipher_name, map[i].cipher_str) == 0) {
 				code = map[i].cipher_code;
 				break;
 			}
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-filename-encryption-tag-70-packets fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-filename-encryption-tag-70-packets
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -199,6 +199,7 @@ ecryptfs_get_key_payload_data(struct key
 #define ECRYPTFS_DEFAULT_CIPHER "aes"
 #define ECRYPTFS_DEFAULT_KEY_BYTES 16
 #define ECRYPTFS_DEFAULT_HASH "md5"
+#define ECRYPTFS_TAG_70_DIGEST ECRYPTFS_DEFAULT_HASH
 #define ECRYPTFS_TAG_1_PACKET_TYPE 0x01
 #define ECRYPTFS_TAG_3_PACKET_TYPE 0x8C
 #define ECRYPTFS_TAG_11_PACKET_TYPE 0xED
@@ -206,7 +207,25 @@ ecryptfs_get_key_payload_data(struct key
 #define ECRYPTFS_TAG_65_PACKET_TYPE 0x41
 #define ECRYPTFS_TAG_66_PACKET_TYPE 0x42
 #define ECRYPTFS_TAG_67_PACKET_TYPE 0x43
+#define ECRYPTFS_TAG_70_PACKET_TYPE 0x46 /* FNEK-encrypted filename
+					  * as dentry name */
+#define ECRYPTFS_TAG_71_PACKET_TYPE 0x47 /* FNEK-encrypted filename in
+					  * metadata */
+#define ECRYPTFS_TAG_72_PACKET_TYPE 0x48 /* FEK-encrypted filename as
+					  * dentry name */
+#define ECRYPTFS_TAG_73_PACKET_TYPE 0x49 /* FEK-encrypted filename as
+					  * metadata */
+/* Constraint: ECRYPTFS_FILENAME_MIN_RANDOM_PREPEND_BYTES >=
+ * ECRYPTFS_MAX_IV_BYTES */
+#define ECRYPTFS_FILENAME_MIN_RANDOM_PREPEND_BYTES 16
+#define ECRYPTFS_NON_NULL 0x42 /* A reasonable substitute for NULL */
 #define MD5_DIGEST_SIZE 16
+#define ECRYPTFS_TAG_70_DIGEST_SIZE MD5_DIGEST_SIZE
+#define ECRYPTFS_FEK_ENCRYPTED_FILENAME_PREFIX "ECRYPTFS_FEK_ENCRYPTED."
+#define ECRYPTFS_FEK_ENCRYPTED_FILENAME_PREFIX_SIZE 23
+#define ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX "ECRYPTFS_FNEK_ENCRYPTED."
+#define ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE 24
+#define ECRYPTFS_ENCRYPTED_DENTRY_NAME_LEN (18 + 1 + 4 + 1 + 32)
 
 struct ecryptfs_key_sig {
 	struct list_head crypt_stat_list;
@@ -332,13 +351,20 @@ struct ecryptfs_mount_crypt_stat {
 #define ECRYPTFS_XATTR_METADATA_ENABLED        0x00000002
 #define ECRYPTFS_ENCRYPTED_VIEW_ENABLED        0x00000004
 #define ECRYPTFS_MOUNT_CRYPT_STAT_INITIALIZED  0x00000008
+#define ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES      0x00000010
+#define ECRYPTFS_GLOBAL_ENCFN_USE_MOUNT_FNEK   0x00000020
+#define ECRYPTFS_GLOBAL_ENCFN_USE_FEK          0x00000040
 	u32 flags;
 	struct list_head global_auth_tok_list;
 	struct mutex global_auth_tok_list_mutex;
 	size_t num_global_auth_toks;
 	size_t global_default_cipher_key_size;
+	size_t global_default_fn_cipher_key_bytes;
 	unsigned char global_default_cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE
 						 + 1];
+	unsigned char global_default_fn_cipher_name[
+		ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
+	char global_default_fnek_sig[ECRYPTFS_SIG_SIZE_HEX + 1];
 };
 
 /* superblock private data. */
@@ -599,7 +625,7 @@ int ecryptfs_read_and_validate_header_re
 					     struct inode *ecryptfs_inode);
 int ecryptfs_read_and_validate_xattr_region(char *page_virt,
 					    struct dentry *ecryptfs_dentry);
-u8 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat);
+u8 ecryptfs_code_for_cipher_string(char *cipher_name, size_t key_bytes);
 int ecryptfs_cipher_code_to_string(char *str, u8 cipher_code);
 void ecryptfs_set_default_sizes(struct ecryptfs_crypt_stat *crypt_stat);
 int ecryptfs_generate_key_packet_set(char *dest_base,
@@ -694,5 +720,15 @@ int ecryptfs_privileged_open(struct file
 			     struct vfsmount *lower_mnt,
 			     const struct cred *cred);
 int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry);
+int
+ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
+			     size_t *packet_size,
+			     struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
+			     char *filename, size_t filename_size);
+int
+ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
+			     size_t *packet_size,
+			     struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
+			     char *data, size_t max_packet_size);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff -puN fs/ecryptfs/keystore.c~ecryptfs-filename-encryption-tag-70-packets fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-filename-encryption-tag-70-packets
+++ a/fs/ecryptfs/keystore.c
@@ -403,6 +403,569 @@ out:
 }
 
 static int
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
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
+	char *sig)
+{
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
+ * write_tag_70_packet can gobble a lot of stack space. We stuff most
+ * of the function's parameters in a kmalloc'd struct to help reduce
+ * eCryptfs' overall stack usage.
+ */
+struct ecryptfs_write_tag_70_packet_silly_stack {
+	u8 cipher_code;
+	size_t max_packet_size;
+	size_t packet_size_len;
+	size_t block_aligned_filename_size;
+	size_t block_size;
+	size_t i;
+	size_t j;
+	size_t num_rand_bytes;
+	struct mutex *tfm_mutex;
+	char *block_aligned_filename;
+	struct ecryptfs_auth_tok *auth_tok;
+	struct scatterlist src_sg;
+	struct scatterlist dst_sg;
+	struct blkcipher_desc desc;
+	char iv[ECRYPTFS_MAX_IV_BYTES];
+	char hash[ECRYPTFS_TAG_70_DIGEST_SIZE];
+	char tmp_hash[ECRYPTFS_TAG_70_DIGEST_SIZE];
+	struct hash_desc hash_desc;
+	struct scatterlist hash_sg;
+};
+
+/**
+ * write_tag_70_packet - Write encrypted filename (EFN) packet against FNEK
+ * @filename: NULL-terminated filename string
+ *
+ * This is the simplest mechanism for achieving filename encryption in
+ * eCryptfs. It encrypts the given filename with the mount-wide
+ * filename encryption key (FNEK) and stores it in a packet to @dest,
+ * which the callee will encode and write directly into the dentry
+ * name.
+ */
+int
+ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
+			     size_t *packet_size,
+			     struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
+			     char *filename, size_t filename_size)
+{
+	struct ecryptfs_write_tag_70_packet_silly_stack *s;
+	int rc = 0;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s) {
+		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
+		       "[%d] bytes of kernel memory\n", __func__, sizeof(*s));
+		goto out;
+	}
+	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	(*packet_size) = 0;
+	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(
+		&s->desc.tfm,
+		&s->tfm_mutex, mount_crypt_stat->global_default_fn_cipher_name);
+	if (unlikely(rc)) {
+		printk(KERN_ERR "Internal error whilst attempting to get "
+		       "tfm and mutex for cipher name [%s]; rc = [%d]\n",
+		       mount_crypt_stat->global_default_fn_cipher_name, rc);
+		goto out;
+	}
+	mutex_lock(s->tfm_mutex);
+	s->block_size = crypto_blkcipher_blocksize(s->desc.tfm);
+	/* Plus one for the \0 separator between the random prefix
+	 * and the plaintext filename */
+	s->num_rand_bytes = (ECRYPTFS_FILENAME_MIN_RANDOM_PREPEND_BYTES + 1);
+	s->block_aligned_filename_size = (s->num_rand_bytes + filename_size);
+	if ((s->block_aligned_filename_size % s->block_size) != 0) {
+		s->num_rand_bytes += (s->block_size
+				      - (s->block_aligned_filename_size
+					 % s->block_size));
+		s->block_aligned_filename_size = (s->num_rand_bytes
+						  + filename_size);
+	}
+	/* Octet 0: Tag 70 identifier
+	 * Octets 1-N1: Tag 70 packet size (includes cipher identifier
+	 *              and block-aligned encrypted filename size)
+	 * Octets N1-N2: FNEK sig (ECRYPTFS_SIG_SIZE)
+	 * Octet N2-N3: Cipher identifier (1 octet)
+	 * Octets N3-N4: Block-aligned encrypted filename
+	 *  - Consists of a minimum number of random characters, a \0
+	 *    separator, and then the filename */
+	s->max_packet_size = (1                   /* Tag 70 identifier */
+			      + 3                 /* Max Tag 70 packet size */
+			      + ECRYPTFS_SIG_SIZE /* FNEK sig */
+			      + 1                 /* Cipher identifier */
+			      + s->block_aligned_filename_size);
+	if (dest == NULL) {
+		(*packet_size) = s->max_packet_size;
+		goto out_unlock;
+	}
+	if (s->max_packet_size > (*remaining_bytes)) {
+		printk(KERN_WARNING "%s: Require [%d] bytes to write; only "
+		       "[%d] available\n", __func__, s->max_packet_size,
+		       (*remaining_bytes));
+		rc = -EINVAL;
+		goto out_unlock;
+	}
+	s->block_aligned_filename = kzalloc(s->block_aligned_filename_size,
+					    GFP_KERNEL);
+	if (!s->block_aligned_filename) {
+		printk(KERN_ERR "%s: Out of kernel memory whilst attempting to "
+		       "kzalloc [%Zd] bytes\n", __func__,
+		       s->block_aligned_filename_size);
+		rc = -ENOMEM;
+		goto out_unlock;
+	}
+	s->i = 0;
+	dest[s->i++] = ECRYPTFS_TAG_70_PACKET_TYPE;
+	rc = ecryptfs_write_packet_length(&dest[s->i],
+					  (ECRYPTFS_SIG_SIZE
+					   + 1 /* Cipher code */
+					   + s->block_aligned_filename_size),
+					  &s->packet_size_len);
+	if (rc) {
+		printk(KERN_ERR "%s: Error generating tag 70 packet "
+		       "header; cannot generate packet length; rc = [%d]\n",
+		       __func__, rc);
+		goto out_free_unlock;
+	}
+	s->i += s->packet_size_len;
+	ecryptfs_from_hex(&dest[s->i],
+			  mount_crypt_stat->global_default_fnek_sig,
+			  ECRYPTFS_SIG_SIZE);
+	s->i += ECRYPTFS_SIG_SIZE;
+	s->cipher_code = ecryptfs_code_for_cipher_string(
+		mount_crypt_stat->global_default_fn_cipher_name,
+		mount_crypt_stat->global_default_fn_cipher_key_bytes);
+	if (s->cipher_code == 0) {
+		printk(KERN_WARNING "%s: Unable to generate code for "
+		       "cipher [%s] with key bytes [%d]\n", __func__,
+		       mount_crypt_stat->global_default_fn_cipher_name,
+		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
+		rc = -EINVAL;
+		goto out_free_unlock;
+	}
+	dest[s->i++] = s->cipher_code;
+	rc = ecryptfs_find_auth_tok_for_sig(
+		&s->auth_tok, mount_crypt_stat,
+		mount_crypt_stat->global_default_fnek_sig);
+	if (rc) {
+		printk(KERN_ERR "%s: Error attempting to find auth tok for "
+		       "fnek sig [%s]; rc = [%d]\n", __func__,
+		       mount_crypt_stat->global_default_fnek_sig, rc);
+		goto out_free_unlock;
+	}
+	/* TODO: Support other key modules than passphrase for
+	 * filename encryption */
+	BUG_ON(s->auth_tok->token_type != ECRYPTFS_PASSWORD);
+	sg_init_one(
+		&s->hash_sg,
+		(u8 *)s->auth_tok->token.password.session_key_encryption_key,
+		s->auth_tok->token.password.session_key_encryption_key_bytes);
+	s->hash_desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	s->hash_desc.tfm = crypto_alloc_hash(ECRYPTFS_TAG_70_DIGEST, 0,
+					     CRYPTO_ALG_ASYNC);
+	if (IS_ERR(s->hash_desc.tfm)) {
+			rc = PTR_ERR(s->hash_desc.tfm);
+			printk(KERN_ERR "%s: Error attempting to "
+			       "allocate hash crypto context; rc = [%d]\n",
+			       __func__, rc);
+			goto out_free_unlock;
+	}
+	rc = crypto_hash_init(&s->hash_desc);
+	if (rc) {
+		printk(KERN_ERR
+		       "%s: Error initializing crypto hash; rc = [%d]\n",
+		       __func__, rc);
+		goto out_release_free_unlock;
+	}
+	rc = crypto_hash_update(
+		&s->hash_desc, &s->hash_sg,
+		s->auth_tok->token.password.session_key_encryption_key_bytes);
+	if (rc) {
+		printk(KERN_ERR
+		       "%s: Error updating crypto hash; rc = [%d]\n",
+		       __func__, rc);
+		goto out_release_free_unlock;
+	}
+	rc = crypto_hash_final(&s->hash_desc, s->hash);
+	if (rc) {
+		printk(KERN_ERR
+		       "%s: Error finalizing crypto hash; rc = [%d]\n",
+		       __func__, rc);
+		goto out_release_free_unlock;
+	}
+	for (s->j = 0; s->j < (s->num_rand_bytes - 1); s->j++) {
+		s->block_aligned_filename[s->j] =
+			s->hash[(s->j % ECRYPTFS_TAG_70_DIGEST_SIZE)];
+		if ((s->j % ECRYPTFS_TAG_70_DIGEST_SIZE)
+		    == (ECRYPTFS_TAG_70_DIGEST_SIZE - 1)) {
+			sg_init_one(&s->hash_sg, (u8 *)s->hash,
+				    ECRYPTFS_TAG_70_DIGEST_SIZE);
+			rc = crypto_hash_init(&s->hash_desc);
+			if (rc) {
+				printk(KERN_ERR
+				       "%s: Error initializing crypto hash; "
+				       "rc = [%d]\n", __func__, rc);
+				goto out_release_free_unlock;
+			}
+			rc = crypto_hash_update(&s->hash_desc, &s->hash_sg,
+						ECRYPTFS_TAG_70_DIGEST_SIZE);
+			if (rc) {
+				printk(KERN_ERR
+				       "%s: Error updating crypto hash; "
+				       "rc = [%d]\n", __func__, rc);
+				goto out_release_free_unlock;
+			}
+			rc = crypto_hash_final(&s->hash_desc, s->tmp_hash);
+			if (rc) {
+				printk(KERN_ERR
+				       "%s: Error finalizing crypto hash; "
+				       "rc = [%d]\n", __func__, rc);
+				goto out_release_free_unlock;
+			}
+			memcpy(s->hash, s->tmp_hash,
+			       ECRYPTFS_TAG_70_DIGEST_SIZE);
+		}
+		if (s->block_aligned_filename[s->j] == '\0')
+			s->block_aligned_filename[s->j] = ECRYPTFS_NON_NULL;
+	}
+	memcpy(&s->block_aligned_filename[s->num_rand_bytes], filename,
+	       filename_size);
+	rc = virt_to_scatterlist(s->block_aligned_filename,
+				 s->block_aligned_filename_size, &s->src_sg, 1);
+	if (rc != 1) {
+		printk(KERN_ERR "%s: Internal error whilst attempting to "
+		       "convert filename memory to scatterlist; "
+		       "expected rc = 1; got rc = [%d]. "
+		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       s->block_aligned_filename_size);
+		goto out_release_free_unlock;
+	}
+	rc = virt_to_scatterlist(&dest[s->i], s->block_aligned_filename_size,
+				 &s->dst_sg, 1);
+	if (rc != 1) {
+		printk(KERN_ERR "%s: Internal error whilst attempting to "
+		       "convert encrypted filename memory to scatterlist; "
+		       "expected rc = 1; got rc = [%d]. "
+		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       s->block_aligned_filename_size);
+		goto out_release_free_unlock;
+	}
+	/* The characters in the first block effectively do the job
+	 * of the IV here, so we just use 0's for the IV. Note the
+	 * constraint that ECRYPTFS_FILENAME_MIN_RANDOM_PREPEND_BYTES
+	 * >= ECRYPTFS_MAX_IV_BYTES. */
+	memset(s->iv, 0, ECRYPTFS_MAX_IV_BYTES);
+	s->desc.info = s->iv;
+	rc = crypto_blkcipher_setkey(
+		s->desc.tfm,
+		s->auth_tok->token.password.session_key_encryption_key,
+		mount_crypt_stat->global_default_fn_cipher_key_bytes);
+	if (rc < 0) {
+		printk(KERN_ERR "%s: Error setting key for crypto context; "
+		       "rc = [%d]. s->auth_tok->token.password.session_key_"
+		       "encryption_key = [0x%p]; mount_crypt_stat->"
+		       "global_default_fn_cipher_key_bytes = [%Zd]\n", __func__,
+		       rc,
+		       s->auth_tok->token.password.session_key_encryption_key,
+		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
+		goto out_release_free_unlock;
+	}
+	rc = crypto_blkcipher_encrypt_iv(&s->desc, &s->dst_sg, &s->src_sg,
+					 s->block_aligned_filename_size);
+	if (rc) {
+		printk(KERN_ERR "%s: Error attempting to encrypt filename; "
+		       "rc = [%d]\n", __func__, rc);
+		goto out_release_free_unlock;
+	}
+	s->i += s->block_aligned_filename_size;
+	(*packet_size) = s->i;
+	(*remaining_bytes) -= (*packet_size);
+out_release_free_unlock:
+	crypto_free_hash(s->hash_desc.tfm);
+out_free_unlock:
+	memset(s->block_aligned_filename, 0, s->block_aligned_filename_size);
+	kfree(s->block_aligned_filename);
+out_unlock:
+	mutex_unlock(s->tfm_mutex);
+out:
+	kfree(s);
+	return rc;
+}
+
+struct ecryptfs_parse_tag_70_packet_silly_stack {
+	u8 cipher_code;
+	size_t max_packet_size;
+	size_t packet_size_len;
+	size_t parsed_tag_70_packet_size;
+	size_t block_aligned_filename_size;
+	size_t block_size;
+	size_t i;
+	struct mutex *tfm_mutex;
+	char *decrypted_filename;
+	struct ecryptfs_auth_tok *auth_tok;
+	struct scatterlist src_sg;
+	struct scatterlist dst_sg;
+	struct blkcipher_desc desc;
+	char fnek_sig_hex[ECRYPTFS_SIG_SIZE_HEX + 1];
+	char iv[ECRYPTFS_MAX_IV_BYTES];
+	char cipher_string[ECRYPTFS_MAX_CIPHER_NAME_SIZE];
+};
+
+/**
+ * parse_tag_70_packet - Parse and process FNEK-encrypted passphrase packet
+ * @filename: This function kmalloc's the memory for the filename
+ */
+int
+ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
+			     size_t *packet_size,
+			     struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
+			     char *data, size_t max_packet_size)
+{
+	struct ecryptfs_parse_tag_70_packet_silly_stack *s;
+	int rc = 0;
+
+	(*packet_size) = 0;
+	(*filename_size) = 0;
+	(*filename) = NULL;
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s) {
+		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
+		       "[%d] bytes of kernel memory\n", __func__, sizeof(*s));
+		goto out;
+	}
+	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	if (max_packet_size < (1 + 1 + ECRYPTFS_SIG_SIZE + 1 + 1)) {
+		printk(KERN_WARNING "%s: max_packet_size is [%Zd]; it must be "
+		       "at least [%d]\n", __func__, max_packet_size,
+			(1 + 1 + ECRYPTFS_SIG_SIZE + 1 + 1));
+		rc = -EINVAL;
+		goto out;
+	}
+	/* Octet 0: Tag 70 identifier
+	 * Octets 1-N1: Tag 70 packet size (includes cipher identifier
+	 *              and block-aligned encrypted filename size)
+	 * Octets N1-N2: FNEK sig (ECRYPTFS_SIG_SIZE)
+	 * Octet N2-N3: Cipher identifier (1 octet)
+	 * Octets N3-N4: Block-aligned encrypted filename
+	 *  - Consists of a minimum number of random numbers, a \0
+	 *    separator, and then the filename */
+	if (data[(*packet_size)++] != ECRYPTFS_TAG_70_PACKET_TYPE) {
+		printk(KERN_WARNING "%s: Invalid packet tag [0x%.2x]; must be "
+		       "tag [0x%.2x]\n", __func__,
+		       data[((*packet_size) - 1)], ECRYPTFS_TAG_70_PACKET_TYPE);
+		rc = -EINVAL;
+		goto out;
+	}
+	rc = ecryptfs_parse_packet_length(&data[(*packet_size)],
+					  &s->parsed_tag_70_packet_size,
+					  &s->packet_size_len);
+	if (rc) {
+		printk(KERN_WARNING "%s: Error parsing packet length; "
+		       "rc = [%d]\n", __func__, rc);
+		goto out;
+	}
+	s->block_aligned_filename_size = (s->parsed_tag_70_packet_size
+					  - ECRYPTFS_SIG_SIZE - 1);
+	if ((1 + s->packet_size_len + s->parsed_tag_70_packet_size)
+	    > max_packet_size) {
+		printk(KERN_WARNING "%s: max_packet_size is [%d]; real packet "
+		       "size is [%d]\n", __func__, max_packet_size,
+		       (1 + s->packet_size_len + 1
+			+ s->block_aligned_filename_size));
+		rc = -EINVAL;
+		goto out;
+	}
+	(*packet_size) += s->packet_size_len;
+	ecryptfs_to_hex(s->fnek_sig_hex, &data[(*packet_size)],
+			ECRYPTFS_SIG_SIZE);
+	s->fnek_sig_hex[ECRYPTFS_SIG_SIZE_HEX] = '\0';
+	(*packet_size) += ECRYPTFS_SIG_SIZE;
+	s->cipher_code = data[(*packet_size)++];
+	rc = ecryptfs_cipher_code_to_string(s->cipher_string, s->cipher_code);
+	if (rc) {
+		printk(KERN_WARNING "%s: Cipher code [%d] is invalid\n",
+		       __func__, s->cipher_code);
+		goto out;
+	}
+	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(&s->desc.tfm,
+							&s->tfm_mutex,
+							s->cipher_string);
+	if (unlikely(rc)) {
+		printk(KERN_ERR "Internal error whilst attempting to get "
+		       "tfm and mutex for cipher name [%s]; rc = [%d]\n",
+		       s->cipher_string, rc);
+		goto out;
+	}
+	mutex_lock(s->tfm_mutex);
+	rc = virt_to_scatterlist(&data[(*packet_size)],
+				 s->block_aligned_filename_size, &s->src_sg, 1);
+	if (rc != 1) {
+		printk(KERN_ERR "%s: Internal error whilst attempting to "
+		       "convert encrypted filename memory to scatterlist; "
+		       "expected rc = 1; got rc = [%d]. "
+		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       s->block_aligned_filename_size);
+		goto out_unlock;
+	}
+	(*packet_size) += s->block_aligned_filename_size;
+	s->decrypted_filename = kmalloc(s->block_aligned_filename_size,
+					GFP_KERNEL);
+	if (!s->decrypted_filename) {
+		printk(KERN_ERR "%s: Out of memory whilst attempting to "
+		       "kmalloc [%d] bytes\n", __func__,
+		       s->block_aligned_filename_size);
+		rc = -ENOMEM;
+		goto out_unlock;
+	}
+	rc = virt_to_scatterlist(s->decrypted_filename,
+				 s->block_aligned_filename_size, &s->dst_sg, 1);
+	if (rc != 1) {
+		printk(KERN_ERR "%s: Internal error whilst attempting to "
+		       "convert decrypted filename memory to scatterlist; "
+		       "expected rc = 1; got rc = [%d]. "
+		       "block_aligned_filename_size = [%d]\n", __func__, rc,
+		       s->block_aligned_filename_size);
+		goto out_free_unlock;
+	}
+	/* The characters in the first block effectively do the job of
+	 * the IV here, so we just use 0's for the IV. Note the
+	 * constraint that ECRYPTFS_FILENAME_MIN_RANDOM_PREPEND_BYTES
+	 * >= ECRYPTFS_MAX_IV_BYTES. */
+	memset(s->iv, 0, ECRYPTFS_MAX_IV_BYTES);
+	s->desc.info = s->iv;
+	rc = ecryptfs_find_auth_tok_for_sig(&s->auth_tok, mount_crypt_stat,
+					    s->fnek_sig_hex);
+	if (rc) {
+		printk(KERN_ERR "%s: Error attempting to find auth tok for "
+		       "fnek sig [%s]; rc = [%d]\n", __func__, s->fnek_sig_hex,
+		       rc);
+		goto out_free_unlock;
+	}
+	/* TODO: Support other key modules than passphrase for
+	 * filename encryption */
+	BUG_ON(s->auth_tok->token_type != ECRYPTFS_PASSWORD);
+	rc = crypto_blkcipher_setkey(
+		s->desc.tfm,
+		s->auth_tok->token.password.session_key_encryption_key,
+		mount_crypt_stat->global_default_fn_cipher_key_bytes);
+	if (rc < 0) {
+		printk(KERN_ERR "%s: Error setting key for crypto context; "
+		       "rc = [%d]. s->auth_tok->token.password.session_key_"
+		       "encryption_key = [0x%p]; mount_crypt_stat->"
+		       "global_default_fn_cipher_key_bytes = [%Zd]\n", __func__,
+		       rc,
+		       s->auth_tok->token.password.session_key_encryption_key,
+		       mount_crypt_stat->global_default_fn_cipher_key_bytes);
+		goto out_free_unlock;
+	}
+	rc = crypto_blkcipher_decrypt_iv(&s->desc, &s->dst_sg, &s->src_sg,
+					 s->block_aligned_filename_size);
+	if (rc) {
+		printk(KERN_ERR "%s: Error attempting to decrypt filename; "
+		       "rc = [%d]\n", __func__, rc);
+		goto out_free_unlock;
+	}
+	s->i = 0;
+	while (s->decrypted_filename[s->i] != '\0'
+	       && s->i < s->block_aligned_filename_size)
+		s->i++;
+	if (s->i == s->block_aligned_filename_size) {
+		printk(KERN_WARNING "%s: Invalid tag 70 packet; could not "
+		       "find valid separator between random characters and "
+		       "the filename\n", __func__);
+		rc = -EINVAL;
+		goto out_free_unlock;
+	}
+	s->i++;
+	(*filename_size) = (s->block_aligned_filename_size - s->i);
+	if (!((*filename_size) > 0 && (*filename_size < PATH_MAX))) {
+		printk(KERN_WARNING "%s: Filename size is [%Zd], which is "
+		       "invalid\n", __func__, (*filename_size));
+		rc = -EINVAL;
+		goto out_free_unlock;
+	}
+	(*filename) = kmalloc(((*filename_size) + 1), GFP_KERNEL);
+	if (!(*filename)) {
+		printk(KERN_ERR "%s: Out of memory whilst attempting to "
+		       "kmalloc [%d] bytes\n", __func__,
+		       ((*filename_size) + 1));
+		rc = -ENOMEM;
+		goto out_free_unlock;
+	}
+	memcpy((*filename), &s->decrypted_filename[s->i], (*filename_size));
+	(*filename)[(*filename_size)] = '\0';
+out_free_unlock:
+	kfree(s->decrypted_filename);
+out_unlock:
+	mutex_unlock(s->tfm_mutex);
+out:
+	if (rc) {
+		(*packet_size) = 0;
+		(*filename_size) = 0;
+		(*filename) = NULL;
+	}
+	kfree(s);
+	return rc;
+}
+
+static int
 ecryptfs_get_auth_tok_sig(char **sig, struct ecryptfs_auth_tok *auth_tok)
 {
 	int rc = 0;
@@ -897,30 +1460,6 @@ out:
 	return rc;
 }
 
-static int
-ecryptfs_find_global_auth_tok_for_sig(
-	struct ecryptfs_global_auth_tok **global_auth_tok,
-	struct ecryptfs_mount_crypt_stat *mount_crypt_stat, char *sig)
-{
-	struct ecryptfs_global_auth_tok *walker;
-	int rc = 0;
-
-	(*global_auth_tok) = NULL;
-	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
-	list_for_each_entry(walker,
-			    &mount_crypt_stat->global_auth_tok_list,
-			    mount_crypt_stat_list) {
-		if (memcmp(walker->sig, sig, ECRYPTFS_SIG_SIZE_HEX) == 0) {
-			(*global_auth_tok) = walker;
-			goto out;
-		}
-	}
-	rc = -EINVAL;
-out:
-	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
-	return rc;
-}
-
 /**
  * ecryptfs_verify_version
  * @version: The version number to confirm
@@ -990,43 +1529,6 @@ out:
 }
 
 /**
- * ecryptfs_find_auth_tok_for_sig
- * @auth_tok: Set to the matching auth_tok; NULL if not found
- * @crypt_stat: inode crypt_stat crypto context
- * @sig: Sig of auth_tok to find
- *
- * For now, this function simply looks at the registered auth_tok's
- * linked off the mount_crypt_stat, so all the auth_toks that can be
- * used must be registered at mount time. This function could
- * potentially try a lot harder to find auth_tok's (e.g., by calling
- * out to ecryptfsd to dynamically retrieve an auth_tok object) so
- * that static registration of auth_tok's will no longer be necessary.
- *
- * Returns zero on no error; non-zero on error
- */
-static int
-ecryptfs_find_auth_tok_for_sig(
-	struct ecryptfs_auth_tok **auth_tok,
-	struct ecryptfs_crypt_stat *crypt_stat, char *sig)
-{
-	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
-		crypt_stat->mount_crypt_stat;
-	struct ecryptfs_global_auth_tok *global_auth_tok;
-	int rc = 0;
-
-	(*auth_tok) = NULL;
-	if (ecryptfs_find_global_auth_tok_for_sig(&global_auth_tok,
-						  mount_crypt_stat, sig)) {
-		struct key *auth_tok_key;
-
-		rc = ecryptfs_keyring_auth_tok_for_sig(&auth_tok_key, auth_tok,
-						       sig);
-	} else
-		(*auth_tok) = global_auth_tok->global_auth_tok;
-	return rc;
-}
-
-/**
  * decrypt_passphrase_encrypted_session_key - Decrypt the session key with the given auth_tok.
  * @auth_tok: The passphrase authentication token to use to encrypt the FEK
  * @crypt_stat: The cryptographic context
@@ -1259,7 +1761,8 @@ find_next_matching_auth_tok:
 			rc = -EINVAL;
 			goto out_wipe_list;
 		}
-		ecryptfs_find_auth_tok_for_sig(&matching_auth_tok, crypt_stat,
+		ecryptfs_find_auth_tok_for_sig(&matching_auth_tok,
+					       crypt_stat->mount_crypt_stat,
 					       candidate_auth_tok_sig);
 		if (matching_auth_tok) {
 			found_auth_tok = 1;
@@ -1339,7 +1842,9 @@ pki_encrypt_session_key(struct ecryptfs_
 	int rc;
 
 	rc = write_tag_66_packet(auth_tok->token.private_key.signature,
-				 ecryptfs_code_for_cipher_string(crypt_stat),
+				 ecryptfs_code_for_cipher_string(
+					 crypt_stat->cipher,
+					 crypt_stat->key_size),
 				 crypt_stat, &payload, &payload_len);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error generating tag 66 packet\n");
@@ -1699,7 +2204,8 @@ encrypted_session_key_set:
 	dest[(*packet_size)++] = 0x04; /* version 4 */
 	/* TODO: Break from RFC2440 so that arbitrary ciphers can be
 	 * specified with strings */
-	cipher_code = ecryptfs_code_for_cipher_string(crypt_stat);
+	cipher_code = ecryptfs_code_for_cipher_string(crypt_stat->cipher,
+						      crypt_stat->key_size);
 	if (cipher_code == 0) {
 		ecryptfs_printk(KERN_WARNING, "Unable to generate code for "
 				"cipher [%s]\n", crypt_stat->cipher);
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

