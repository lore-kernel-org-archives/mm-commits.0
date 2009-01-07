From: akpm@linux-foundation.org
Subject: - ecryptfs-filename-encryption-encoding-and-encryption-functions.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:24 -0800
Message-ID: <200901072218.n07MIOJA017903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763394AbZAGWh6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, dustin.kirkland@gmail.com, sandeen@redhat.com, shaggy@us.ibm.com, tchicks@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Filename Encryption: Encoding and encryption functions
has been removed from the -mm tree.  Its filename was
     ecryptfs-filename-encryption-encoding-and-encryption-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: Filename Encryption: Encoding and encryption functions
From: Michael Halcrow <mhalcrow@us.ibm.com>

These functions support encrypting and encoding the filename contents. 
The encrypted filename contents may consist of any ASCII characters.  This
patch includes a custom encoding mechanism to map the ASCII characters to
a reduced character set that is appropriate for filenames.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Dustin Kirkland <dustin.kirkland@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Tyler Hicks <tchicks@us.ibm.com>
Cc: David Kleikamp <shaggy@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |  433 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 433 insertions(+)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-filename-encryption-encoding-and-encryption-functions fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-filename-encryption-encoding-and-encryption-functions
+++ a/fs/ecryptfs/crypto.c
@@ -1721,6 +1721,98 @@ out:
 }
 
 /**
+ * ecryptfs_encrypt_filename - encrypt filename
+ *
+ * CBC-encrypts the filename. We do not want to encrypt the same
+ * filename with the same key and IV, which may happen with hard
+ * links, so we prepend random bits to each filename.
+ *
+ * Returns zero on success; non-zero otherwise
+ */
+static int
+ecryptfs_encrypt_filename(struct ecryptfs_filename *filename,
+			  struct ecryptfs_crypt_stat *crypt_stat,
+			  struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
+{
+	int rc = 0;
+
+	filename->encrypted_filename = NULL;
+	filename->encrypted_filename_size = 0;
+	if ((crypt_stat && (crypt_stat->flags & ECRYPTFS_ENCFN_USE_MOUNT_FNEK))
+	    || (mount_crypt_stat && (mount_crypt_stat->flags
+				     & ECRYPTFS_GLOBAL_ENCFN_USE_MOUNT_FNEK))) {
+		size_t packet_size;
+		size_t remaining_bytes;
+
+		rc = ecryptfs_write_tag_70_packet(
+			NULL, NULL,
+			&filename->encrypted_filename_size,
+			mount_crypt_stat, NULL,
+			filename->filename_size);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to get packet "
+			       "size for tag 72; rc = [%d]\n", __func__,
+			       rc);
+			filename->encrypted_filename_size = 0;
+			goto out;
+		}
+		filename->encrypted_filename =
+			kmalloc(filename->encrypted_filename_size, GFP_KERNEL);
+		if (!filename->encrypted_filename) {
+			printk(KERN_ERR "%s: Out of memory whilst attempting "
+			       "to kmalloc [%Zd] bytes\n", __func__,
+			       filename->encrypted_filename_size);
+			rc = -ENOMEM;
+			goto out;
+		}
+		remaining_bytes = filename->encrypted_filename_size;
+		rc = ecryptfs_write_tag_70_packet(filename->encrypted_filename,
+						  &remaining_bytes,
+						  &packet_size,
+						  mount_crypt_stat,
+						  filename->filename,
+						  filename->filename_size);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to generate "
+			       "tag 70 packet; rc = [%d]\n", __func__,
+			       rc);
+			kfree(filename->encrypted_filename);
+			filename->encrypted_filename = NULL;
+			filename->encrypted_filename_size = 0;
+			goto out;
+		}
+		filename->encrypted_filename_size = packet_size;
+	} else {
+		printk(KERN_ERR "%s: No support for requested filename "
+		       "encryption method in this release\n", __func__);
+		rc = -ENOTSUPP;
+		goto out;
+	}
+out:
+	return rc;
+}
+
+static int ecryptfs_copy_filename(char **copied_name, size_t *copied_name_size,
+				  const char *name, size_t name_size)
+{
+	int rc = 0;
+
+	(*copied_name) = kmalloc((name_size + 2), GFP_KERNEL);
+	if (!(*copied_name)) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	memcpy((void *)(*copied_name), (void *)name, name_size);
+	(*copied_name)[(name_size)] = '\0';	/* Only for convenience
+						 * in printing out the
+						 * string in debug
+						 * messages */
+	(*copied_name_size) = (name_size + 1);
+out:
+	return rc;
+}
+
+/**
  * ecryptfs_process_key_cipher - Perform key cipher initialization.
  * @key_tfm: Crypto context for key material, set by this function
  * @cipher_name: Name of the cipher
@@ -1911,3 +2003,344 @@ out:
 	mutex_unlock(&key_tfm_list_mutex);
 	return rc;
 }
+
+/* 64 characters forming a 6-bit target field */
+static unsigned char *portable_filename_chars = ("-.0123456789ABCD"
+						 "EFGHIJKLMNOPQRST"
+						 "UVWXYZabcdefghij"
+						 "klmnopqrstuvwxyz");
+
+/* We could either offset on every reverse map or just pad some 0x00's
+ * at the front here */
+static unsigned char filename_rev_map[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 7 */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 15 */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 23 */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 31 */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 39 */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, /* 47 */
+	0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, /* 55 */
+	0x0A, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 63 */
+	0x00, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, /* 71 */
+	0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, /* 79 */
+	0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20, 0x21, 0x22, /* 87 */
+	0x23, 0x24, 0x25, 0x00, 0x00, 0x00, 0x00, 0x00, /* 95 */
+	0x00, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, /* 103 */
+	0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32, 0x33, 0x34, /* 111 */
+	0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, /* 119 */
+	0x3D, 0x3E, 0x3F
+};
+
+/**
+ * ecryptfs_encode_for_filename
+ * @dst: Destination location for encoded filename
+ * @dst_size: Size of the encoded filename in bytes
+ * @src: Source location for the filename to encode
+ * @src_size: Size of the source in bytes
+ */
+void ecryptfs_encode_for_filename(unsigned char *dst, size_t *dst_size,
+				  unsigned char *src, size_t src_size)
+{
+	size_t num_blocks;
+	size_t block_num = 0;
+	size_t dst_offset = 0;
+	unsigned char last_block[3];
+
+	if (src_size == 0) {
+		(*dst_size) = 0;
+		goto out;
+	}
+	num_blocks = (src_size / 3);
+	if ((src_size % 3) == 0) {
+		memcpy(last_block, (&src[src_size - 3]), 3);
+	} else {
+		num_blocks++;
+		last_block[2] = 0x00;
+		switch (src_size % 3) {
+		case 1:
+			last_block[0] = src[src_size - 1];
+			last_block[1] = 0x00;
+			break;
+		case 2:
+			last_block[0] = src[src_size - 2];
+			last_block[1] = src[src_size - 1];
+		}
+	}
+	(*dst_size) = (num_blocks * 4);
+	if (!dst)
+		goto out;
+	while (block_num < num_blocks) {
+		unsigned char *src_block;
+		unsigned char dst_block[4];
+
+		if (block_num == (num_blocks - 1))
+			src_block = last_block;
+		else
+			src_block = &src[block_num * 3];
+		dst_block[0] = ((src_block[0] >> 2) & 0x3F);
+		dst_block[1] = (((src_block[0] << 4) & 0x30)
+				| ((src_block[1] >> 4) & 0x0F));
+		dst_block[2] = (((src_block[1] << 2) & 0x3C)
+				| ((src_block[2] >> 6) & 0x03));
+		dst_block[3] = (src_block[2] & 0x3F);
+		dst[dst_offset++] = portable_filename_chars[dst_block[0]];
+		dst[dst_offset++] = portable_filename_chars[dst_block[1]];
+		dst[dst_offset++] = portable_filename_chars[dst_block[2]];
+		dst[dst_offset++] = portable_filename_chars[dst_block[3]];
+		block_num++;
+	}
+out:
+	return;
+}
+
+int ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
+				  const unsigned char *src, size_t src_size)
+{
+	u8 current_bit_offset = 0;
+	size_t src_byte_offset = 0;
+	size_t dst_byte_offset = 0;
+	int rc = 0;
+
+	if (dst == NULL) {
+		/* Not exact; conservatively long */
+		(*dst_size) = (((src_size + 1) * 3) / 4);
+		goto out;
+	}
+	while (src_byte_offset < src_size) {
+		unsigned char src_byte =
+				filename_rev_map[(int)src[src_byte_offset]];
+
+		switch (current_bit_offset) {
+		case 0:
+			dst[dst_byte_offset] = (src_byte << 2);
+			current_bit_offset = 6;
+			break;
+		case 6:
+			dst[dst_byte_offset++] |= (src_byte >> 4);
+			dst[dst_byte_offset] = ((src_byte & 0xF)
+						 << 4);
+			current_bit_offset = 4;
+			break;
+		case 4:
+			dst[dst_byte_offset++] |= (src_byte >> 2);
+			dst[dst_byte_offset] = (src_byte << 6);
+			current_bit_offset = 2;
+			break;
+		case 2:
+			dst[dst_byte_offset++] |= (src_byte);
+			dst[dst_byte_offset] = 0;
+			current_bit_offset = 0;
+			break;
+		}
+		src_byte_offset++;
+	}
+	(*dst_size) = dst_byte_offset;
+out:
+	return rc;
+}
+
+/**
+ * ecryptfs_encrypt_and_encode_filename - converts a plaintext file name to cipher text
+ * @crypt_stat: The crypt_stat struct associated with the file anem to encode
+ * @name: The plaintext name
+ * @length: The length of the plaintext
+ * @encoded_name: The encypted name
+ *
+ * Encrypts and encodes a filename into something that constitutes a
+ * valid filename for a filesystem, with printable characters.
+ *
+ * We assume that we have a properly initialized crypto context,
+ * pointed to by crypt_stat->tfm.
+ *
+ * Returns zero on success; non-zero on otherwise
+ */
+int ecryptfs_encrypt_and_encode_filename(
+	char **encoded_name,
+	size_t *encoded_name_size,
+	struct ecryptfs_crypt_stat *crypt_stat,
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
+	const char *name, size_t name_size)
+{
+	size_t encoded_name_no_prefix_size;
+	int rc = 0;
+
+	(*encoded_name) = NULL;
+	(*encoded_name_size) = 0;
+	if ((crypt_stat && (crypt_stat->flags & ECRYPTFS_ENCRYPT_FILENAMES))
+	    || (mount_crypt_stat && (mount_crypt_stat->flags
+				     & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES))) {
+		struct ecryptfs_filename *filename;
+
+		filename = kzalloc(sizeof(*filename), GFP_KERNEL);
+		if (!filename) {
+			printk(KERN_ERR "%s: Out of memory whilst attempting "
+			       "to kzalloc [%d] bytes\n", __func__,
+			       sizeof(*filename));
+			rc = -ENOMEM;
+			goto out;
+		}
+		filename->filename = (char *)name;
+		filename->filename_size = name_size;
+		rc = ecryptfs_encrypt_filename(filename, crypt_stat,
+					       mount_crypt_stat);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to encrypt "
+			       "filename; rc = [%d]\n", __func__, rc);
+			kfree(filename);
+			goto out;
+		}
+		ecryptfs_encode_for_filename(
+			NULL, &encoded_name_no_prefix_size,
+			filename->encrypted_filename,
+			filename->encrypted_filename_size);
+		if ((crypt_stat && (crypt_stat->flags
+				    & ECRYPTFS_ENCFN_USE_MOUNT_FNEK))
+		    || (mount_crypt_stat
+			&& (mount_crypt_stat->flags
+			    & ECRYPTFS_GLOBAL_ENCFN_USE_MOUNT_FNEK)))
+			(*encoded_name_size) =
+				(ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE
+				 + encoded_name_no_prefix_size);
+		else
+			(*encoded_name_size) =
+				(ECRYPTFS_FEK_ENCRYPTED_FILENAME_PREFIX_SIZE
+				 + encoded_name_no_prefix_size);
+		(*encoded_name) = kmalloc((*encoded_name_size) + 1, GFP_KERNEL);
+		if (!(*encoded_name)) {
+			printk(KERN_ERR "%s: Out of memory whilst attempting "
+			       "to kzalloc [%d] bytes\n", __func__,
+			       (*encoded_name_size));
+			rc = -ENOMEM;
+			kfree(filename->encrypted_filename);
+			kfree(filename);
+			goto out;
+		}
+		if ((crypt_stat && (crypt_stat->flags
+				    & ECRYPTFS_ENCFN_USE_MOUNT_FNEK))
+		    || (mount_crypt_stat
+			&& (mount_crypt_stat->flags
+			    & ECRYPTFS_GLOBAL_ENCFN_USE_MOUNT_FNEK))) {
+			memcpy((*encoded_name),
+			       ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX,
+			       ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE);
+			ecryptfs_encode_for_filename(
+			    ((*encoded_name)
+			     + ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE),
+			    &encoded_name_no_prefix_size,
+			    filename->encrypted_filename,
+			    filename->encrypted_filename_size);
+			(*encoded_name_size) =
+				(ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE
+				 + encoded_name_no_prefix_size);
+			(*encoded_name)[(*encoded_name_size)] = '\0';
+			(*encoded_name_size)++;
+		} else {
+			rc = -ENOTSUPP;
+		}
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to encode "
+			       "encrypted filename; rc = [%d]\n", __func__,
+			       rc);
+			kfree((*encoded_name));
+			(*encoded_name) = NULL;
+			(*encoded_name_size) = 0;
+		}
+		kfree(filename->encrypted_filename);
+		kfree(filename);
+	} else {
+		rc = ecryptfs_copy_filename(encoded_name,
+					    encoded_name_size,
+					    name, name_size);
+	}
+out:
+	return rc;
+}
+
+/**
+ * ecryptfs_decode_and_decrypt_filename - converts the encoded cipher text name to decoded plaintext
+ * @plaintext_name: The plaintext name
+ * @plaintext_name_size: The plaintext name size
+ * @ecryptfs_dir_dentry: eCryptfs directory dentry
+ * @name: The filename in cipher text
+ * @name_size: The cipher text name size
+ *
+ * Decrypts and decodes the filename.
+ *
+ * Returns zero on error; non-zero otherwise
+ */
+int ecryptfs_decode_and_decrypt_filename(char **plaintext_name,
+					 size_t *plaintext_name_size,
+					 struct dentry *ecryptfs_dir_dentry,
+					 const char *name, size_t name_size)
+{
+	char *decoded_name;
+	size_t decoded_name_size;
+	size_t packet_size;
+	int rc = 0;
+
+	if ((name_size > ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE)
+	    && (strncmp(name, ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX,
+			ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE) == 0)) {
+		struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
+			&ecryptfs_superblock_to_private(
+				ecryptfs_dir_dentry->d_sb)->mount_crypt_stat;
+		const char *orig_name = name;
+		size_t orig_name_size = name_size;
+
+		name += ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE;
+		name_size -= ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE;
+		rc = ecryptfs_decode_from_filename(NULL, &decoded_name_size,
+						   name, name_size);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to decode "
+			       "filename; rc = [%d]\n", __func__, rc);
+			rc = ecryptfs_copy_filename(plaintext_name,
+						    plaintext_name_size,
+						    orig_name, orig_name_size);
+			goto out;
+		}
+		decoded_name = kmalloc(decoded_name_size, GFP_KERNEL);
+		if (!decoded_name) {
+			printk(KERN_ERR "%s: Out of memory whilst attempting "
+			       "to kmalloc [%Zd] bytes\n", __func__,
+			       decoded_name_size);
+			rc = -ENOMEM;
+			goto out;
+		}
+		rc = ecryptfs_decode_from_filename(decoded_name,
+						   &decoded_name_size,
+						   name, name_size);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to decode "
+			       "filename; rc = [%d]\n", __func__, rc);
+			rc = ecryptfs_copy_filename(plaintext_name,
+						    plaintext_name_size,
+						    orig_name, orig_name_size);
+			goto out_free;
+		}
+		rc = ecryptfs_parse_tag_70_packet(plaintext_name,
+						  plaintext_name_size,
+						  &packet_size,
+						  mount_crypt_stat,
+						  decoded_name,
+						  decoded_name_size);
+		if (rc) {
+			printk(KERN_INFO "%s: Could not parse tag 70 packet "
+			       "from filename; copying through filename "
+			       "as-is\n", __func__);
+			rc = ecryptfs_copy_filename(plaintext_name,
+						    plaintext_name_size,
+						    orig_name, orig_name_size);
+			goto out_free;
+		}
+	} else {
+		rc = ecryptfs_copy_filename(plaintext_name,
+					    plaintext_name_size,
+					    name, name_size);
+		goto out;
+	}
+out_free:
+	kfree(decoded_name);
+out:
+	return rc;
+}
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
notify_change-callers-must-hold-i_mutex.patch

