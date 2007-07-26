From: akpm@linux-foundation.org
Subject: + ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec.patch added to -mm tree
Date: Wed, 25 Jul 2007 23:13:04 -0700
Message-ID: <200707260613.l6Q6D4Jw017502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40774 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754712AbXGZGNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 02:13:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, mhalcrow@halcrow.austin.ibm.com


The patch titled
     eCryptfs: kerneldoc fixes for crypto.c and keystore.c
has been added to the -mm tree.  Its filename is
     ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: kerneldoc fixes for crypto.c and keystore.c
From: Michael Halcrow <mhalcrow@us.ibm.com>

Andrew Morton wrote:
> > +/**
> > + * decrypt_passphrase_encrypted_session_key - Decrypt the session key
> > + * with the given auth_tok.
> >   *
> >   * Returns Zero on success; non-zero error otherwise.
> >   */
>
> That comment purports to be a kerneldoc-style comment.  But
>
> - kerneldoc doesn't support multiple lines on the introductory line
>   which identifies the name of the function (alas).  So you'll need to
>   overflow 80 cols here.
>
> - the function args weren't documented
>
> But the return value is!  People regularly forget to do that.  And
> they frequently forget to document the locking prerequisites and the
> permissible calling contexts (process/might_sleep/hardirq, etc)
>
> (please check all ecryptfs kerneldoc for this stuff sometime)

This patch cleans up some of the existing comments and makes a couple
of line break tweaks. There is more work to do to bring eCryptfs into
full kerneldoc-compliance.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c   |   69 +++++++++++++++++++++++++++++----------
 fs/ecryptfs/keystore.c |   48 +++++++++++++++------------
 2 files changed, 79 insertions(+), 38 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec
+++ a/fs/ecryptfs/crypto.c
@@ -722,6 +722,11 @@ out:
 
 /**
  * decrypt_scatterlist
+ * @crypt_stat: Cryptographic context
+ * @dest_sg: The destination scatterlist to decrypt into
+ * @src_sg: The source scatterlist to decrypt from
+ * @size: The number of bytes to decrypt
+ * @iv: The initialization vector to use for the decryption
  *
  * Returns the number of bytes decrypted; negative value on error
  */
@@ -763,6 +768,13 @@ out:
 
 /**
  * ecryptfs_encrypt_page_offset
+ * @crypt_stat: The cryptographic context
+ * @dst_page: The page to encrypt into
+ * @dst_offset: The offset in the page to encrypt into
+ * @src_page: The page to encrypt from
+ * @src_offset: The offset in the page to encrypt from
+ * @size: The number of bytes to encrypt
+ * @iv: The initialization vector to use for the encryption
  *
  * Returns the number of bytes encrypted
  */
@@ -785,6 +797,13 @@ ecryptfs_encrypt_page_offset(struct ecry
 
 /**
  * ecryptfs_decrypt_page_offset
+ * @crypt_stat: The cryptographic context
+ * @dst_page: The page to decrypt into
+ * @dst_offset: The offset in the page to decrypt into
+ * @src_page: The page to decrypt from
+ * @src_offset: The offset in the page to decrypt from
+ * @size: The number of bytes to decrypt
+ * @iv: The initialization vector to use for the decryption
  *
  * Returns the number of bytes decrypted
  */
@@ -940,6 +959,8 @@ static void ecryptfs_generate_new_key(st
 
 /**
  * ecryptfs_copy_mount_wide_flags_to_inode_flags
+ * @crypt_stat: The inode's cryptographic context
+ * @mount_crypt_stat: The mount point's cryptographic context
  *
  * This function propagates the mount-wide flags to individual inode
  * flags.
@@ -980,7 +1001,8 @@ out:
 
 /**
  * ecryptfs_set_default_crypt_stat_vals
- * @crypt_stat
+ * @crypt_stat: The inode's cryptographic context
+ * @mount_crypt_stat: The mount point's cryptographic context
  *
  * Default values in the event that policy does not override them.
  */
@@ -1000,7 +1022,7 @@ static void ecryptfs_set_default_crypt_s
 
 /**
  * ecryptfs_new_file_context
- * @ecryptfs_dentry
+ * @ecryptfs_dentry: The eCryptfs dentry
  *
  * If the crypto context for the file has not yet been established,
  * this is where we do that.  Establishing a new crypto context
@@ -1017,7 +1039,6 @@ static void ecryptfs_set_default_crypt_s
  *
  * Returns zero on success; non-zero otherwise
  */
-/* Associate an authentication token(s) with the file */
 int ecryptfs_new_file_context(struct dentry *ecryptfs_dentry)
 {
 	struct ecryptfs_crypt_stat *crypt_stat =
@@ -1095,7 +1116,7 @@ static struct ecryptfs_flag_map_elem ecr
 
 /**
  * ecryptfs_process_flags
- * @crypt_stat
+ * @crypt_stat: The cryptographic context
  * @page_virt: Source data to be parsed
  * @bytes_read: Updated with the number of bytes read
  *
@@ -1183,7 +1204,7 @@ ecryptfs_cipher_code_str_map[] = {
 
 /**
  * ecryptfs_code_for_cipher_string
- * @str: The string representing the cipher name
+ * @crypt_stat: The cryptographic context
  *
  * Returns zero on no match, or the cipher code on match
  */
@@ -1241,9 +1262,9 @@ int ecryptfs_cipher_code_to_string(char 
 
 /**
  * ecryptfs_read_header_region
- * @data
- * @dentry
- * @nd
+ * @data: The virtual address to write header region data into
+ * @dentry: The lower dentry
+ * @mnt: The lower VFS mount
  *
  * Returns zero on success; non-zero otherwise
  */
@@ -1315,9 +1336,10 @@ struct kmem_cache *ecryptfs_header_cache
 
 /**
  * ecryptfs_write_headers_virt
- * @page_virt
- * @crypt_stat
- * @ecryptfs_dentry
+ * @page_virt: The virtual address to write the headers to
+ * @size: Set to the number of bytes written by this function
+ * @crypt_stat: The cryptographic context
+ * @ecryptfs_dentry: The eCryptfs dentry
  *
  * Format version: 1
  *
@@ -1371,9 +1393,9 @@ static int ecryptfs_write_headers_virt(c
 	return rc;
 }
 
-static int ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
-					       struct file *lower_file,
-					       char *page_virt)
+static int
+ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
+				    struct file *lower_file, char *page_virt)
 {
 	mm_segment_t oldfs;
 	int current_header_page;
@@ -1415,9 +1437,10 @@ out:
 	return rc;
 }
 
-static int ecryptfs_write_metadata_to_xattr(struct dentry *ecryptfs_dentry,
-					    struct ecryptfs_crypt_stat *crypt_stat,
-					    char *page_virt, size_t size)
+static int
+ecryptfs_write_metadata_to_xattr(struct dentry *ecryptfs_dentry,
+				 struct ecryptfs_crypt_stat *crypt_stat,
+				 char *page_virt, size_t size)
 {
 	int rc;
 
@@ -1428,6 +1451,7 @@ static int ecryptfs_write_metadata_to_xa
 
 /**
  * ecryptfs_write_metadata
+ * @ecryptfs_dentry: The eCryptfs dentry
  * @lower_file: The lower file struct, which was returned from dentry_open
  *
  * Write the file headers out.  This will likely involve a userspace
@@ -1525,6 +1549,7 @@ static int parse_header_metadata(struct 
 
 /**
  * set_default_header_data
+ * @crypt_stat: The cryptographic context
  *
  * For version 0 file format; this function is only for backwards
  * compatibility for files created with the prior versions of
@@ -1538,6 +1563,10 @@ static void set_default_header_data(stru
 
 /**
  * ecryptfs_read_headers_virt
+ * @page_virt: The virtual address into which to read the headers
+ * @crypt_stat: The cryptographic context
+ * @ecryptfs_dentry: The eCryptfs dentry
+ * @validate_header_size: Whether to validate the header size while reading
  *
  * Read/parse the header data. The header format is detailed in the
  * comment block for the ecryptfs_write_headers_virt() function.
@@ -1597,9 +1626,13 @@ out:
 
 /**
  * ecryptfs_read_xattr_region
+ * @page_virt: The vitual address into which to read the xattr data
+ * @ecryptfs_dentry: The eCryptfs dentry
  *
  * Attempts to read the crypto metadata from the extended attribute
  * region of the lower file.
+ *
+ * Returns zero on success; non-zero on error
  */
 int ecryptfs_read_xattr_region(char *page_virt, struct dentry *ecryptfs_dentry)
 {
@@ -1638,6 +1671,8 @@ out:
 
 /**
  * ecryptfs_read_metadata
+ * @ecryptfs_dentry: The eCryptfs dentry
+ * @lower_file: The lower file from which to read the metadata
  *
  * Common entry point for reading file metadata. From here, we could
  * retrieve the header information from the header region of the file,
diff -puN fs/ecryptfs/keystore.c~ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec
+++ a/fs/ecryptfs/keystore.c
@@ -71,7 +71,7 @@ int process_request_key_err(long err_cod
  *        address; zero on error
  * @length_size: The number of bytes occupied by the encoded length
  *
- * Returns Zero on success
+ * Returns zero on success; non-zero on error
  */
 static int parse_packet_length(unsigned char *data, size_t *size,
 			       size_t *length_size)
@@ -106,11 +106,11 @@ out:
 
 /**
  * write_packet_length
- * @dest: The byte array target into which to write the
- *       length. Must have at least 5 bytes allocated.
+ * @dest: The byte array target into which to write the length. Must
+ *        have at least 5 bytes allocated.
  * @size: The length to write.
- * @packet_size_length: The number of bytes used to encode the
- *                      packet length is written to this address.
+ * @packet_size_length: The number of bytes used to encode the packet
+ *                      length is written to this address.
  *
  * Returns zero on success; non-zero on error.
  */
@@ -397,10 +397,11 @@ out:
 }
 
 /**
- * decrypt_pki_encrypted_session_key - Decrypt the session key with
- * the given auth_tok.
+ * decrypt_pki_encrypted_session_key - Decrypt the session key with the given auth_tok.
+ * @auth_tok: The key authentication token used to decrypt the session key
+ * @crypt_stat: The cryptographic context
  *
- * Returns Zero on success; non-zero error otherwise.
+ * Returns zero on success; non-zero error otherwise.
  */
 static int
 decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
@@ -484,18 +485,18 @@ struct kmem_cache *ecryptfs_auth_tok_lis
 
 /**
  * parse_tag_1_packet
- * @crypt_stat: The cryptographic context to modify based on packet
- *              contents.
+ * @crypt_stat: The cryptographic context to modify based on packet contents
  * @data: The raw bytes of the packet.
  * @auth_tok_list: eCryptfs parses packets into authentication tokens;
- *                 a new authentication token will be placed at the end
- *                 of this list for this packet.
+ *                 a new authentication token will be placed at the
+ *                 end of this list for this packet.
  * @new_auth_tok: Pointer to a pointer to memory that this function
  *                allocates; sets the memory address of the pointer to
  *                NULL on error. This object is added to the
  *                auth_tok_list.
  * @packet_size: This function writes the size of the parsed packet
  *               into this memory location; zero on error.
+ * @max_packet_size: The maximum allowable packet size
  *
  * Returns zero on success; non-zero on error.
  */
@@ -996,10 +997,11 @@ ecryptfs_find_auth_tok_for_sig(
 }
 
 /**
- * decrypt_passphrase_encrypted_session_key - Decrypt the session key
- * with the given auth_tok.
+ * decrypt_passphrase_encrypted_session_key - Decrypt the session key with the given auth_tok.
+ * @auth_tok: The passphrase authentication token to use to encrypt the FEK
+ * @crypt_stat: The cryptographic context
  *
- * Returns Zero on success; non-zero error otherwise.
+ * Returns zero on success; non-zero error otherwise
  */
 static int
 decrypt_passphrase_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
@@ -1102,8 +1104,9 @@ int ecryptfs_get_auth_tok_sig(char **sig
 
 /**
  * ecryptfs_parse_packet_set
- * @dest: The header page in memory
- * @version: Version of file format, to guide parsing behavior
+ * @crypt_stat: The cryptographic context
+ * @src: Virtual address of region of memory containing the packets
+ * @ecryptfs_dentry: The eCryptfs dentry associated with the packet set
  *
  * Get crypt_stat to have the file's session key if the requisite key
  * is available to decrypt the session key.
@@ -1354,7 +1357,10 @@ out:
 /**
  * write_tag_1_packet - Write an RFC2440-compatible tag 1 (public key) packet
  * @dest: Buffer into which to write the packet
- * @max: Maximum number of bytes that can be writtn
+ * @remaining_bytes: Maximum number of bytes that can be writtn
+ * @auth_tok: The authentication token used for generating the tag 1 packet
+ * @crypt_stat: The cryptographic context
+ * @key_rec: The key record struct for the tag 1 packet
  * @packet_size: This function will write the number of bytes that end
  *               up constituting the packet; set to zero on error
  *
@@ -1441,7 +1447,7 @@ out:
 /**
  * write_tag_11_packet
  * @dest: Target into which Tag 11 packet is to be written
- * @max: Maximum packet length
+ * @remaining_bytes: Maximum packet length
  * @contents: Byte array of contents to copy in
  * @contents_length: Number of bytes in contents
  * @packet_length: Length of the Tag 11 packet written; zero on error
@@ -1501,7 +1507,7 @@ write_tag_11_packet(char *dest, size_t *
 /**
  * write_tag_3_packet
  * @dest: Buffer into which to write the packet
- * @max: Maximum number of bytes that can be written
+ * @remaining_bytes: Maximum number of bytes that can be written
  * @auth_tok: Authentication token
  * @crypt_stat: The cryptographic context
  * @key_rec: encrypted key
@@ -1707,7 +1713,7 @@ struct kmem_cache *ecryptfs_key_record_c
 
 /**
  * ecryptfs_generate_key_packet_set
- * @dest: Virtual address from which to write the key record set
+ * @dest_base: Virtual address from which to write the key record set
  * @crypt_stat: The cryptographic context from which the
  *              authentication tokens will be retrieved
  * @ecryptfs_dentry: The dentry, used to retrieve the mount crypt stat
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

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
ecryptfs-printk-warning-fixes.patch
ecryptfs-remove-unnecessary-bug_on.patch
ecryptfs-collapse-flag-set-into-one-statement.patch
ecryptfs-grammatical-fix-destruct-to-destroy.patch
ecryptfs-comments-for-some-structs.patch
ecryptfs-kerneldoc-fixes-for-cryptoc-and-keystorec.patch
ecryptfs-remove-unnecessary-variable-initializations.patch
ecryptfs-make-needlessly-global-symbols-static.patch
