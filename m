From: akpm@linux-foundation.org
Subject: + ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8.patch added to -mm tree
Date: Sat, 22 Dec 2007 00:39:12 -0800
Message-ID: <200712220839.lBM8dCMj024986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58574 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbXLVIj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 03:39:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thighlan@gmail.com, mhalcrow@us.ibm.com, trevor.highland@gmail.com


The patch titled
     eCryptfs: change the type of cipher_code from u16 to u8
has been added to the -mm tree.  Its filename is
     ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: eCryptfs: change the type of cipher_code from u16 to u8
From: Trevor Highland <thighlan@gmail.com>

Only the lower byte of cipher_code is ever used, so it makes sense
for its type to be u8.

Signed-off-by: Trevor Highland <trevor.highland@gmail.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |    8 ++++----
 fs/ecryptfs/ecryptfs_kernel.h |    4 ++--
 fs/ecryptfs/keystore.c        |    8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8 fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8
+++ a/fs/ecryptfs/crypto.c
@@ -1128,7 +1128,7 @@ write_ecryptfs_flags(char *page_virt, st
 
 struct ecryptfs_cipher_code_str_map_elem {
 	char cipher_str[16];
-	u16 cipher_code;
+	u8 cipher_code;
 };
 
 /* Add support for additional ciphers by adding elements here. The
@@ -1152,10 +1152,10 @@ ecryptfs_cipher_code_str_map[] = {
  *
  * Returns zero on no match, or the cipher code on match
  */
-u16 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat)
+u8 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat)
 {
 	int i;
-	u16 code = 0;
+	u8 code = 0;
 	struct ecryptfs_cipher_code_str_map_elem *map =
 		ecryptfs_cipher_code_str_map;
 
@@ -1187,7 +1187,7 @@ u16 ecryptfs_code_for_cipher_string(stru
  *
  * Returns zero on success
  */
-int ecryptfs_cipher_code_to_string(char *str, u16 cipher_code)
+int ecryptfs_cipher_code_to_string(char *str, u8 cipher_code)
 {
 	int rc = 0;
 	int i;
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8 fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -558,8 +558,8 @@ int ecryptfs_read_and_validate_header_re
 					     struct inode *ecryptfs_inode);
 int ecryptfs_read_and_validate_xattr_region(char *page_virt,
 					    struct dentry *ecryptfs_dentry);
-u16 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat);
-int ecryptfs_cipher_code_to_string(char *str, u16 cipher_code);
+u8 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat);
+int ecryptfs_cipher_code_to_string(char *str, u8 cipher_code);
 void ecryptfs_set_default_sizes(struct ecryptfs_crypt_stat *crypt_stat);
 int ecryptfs_generate_key_packet_set(char *dest_base,
 				     struct ecryptfs_crypt_stat *crypt_stat,
diff -puN fs/ecryptfs/keystore.c~ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8 fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8
+++ a/fs/ecryptfs/keystore.c
@@ -189,7 +189,7 @@ out:
 }
 
 static int
-parse_tag_65_packet(struct ecryptfs_session_key *session_key, u16 *cipher_code,
+parse_tag_65_packet(struct ecryptfs_session_key *session_key, u8 *cipher_code,
 		    struct ecryptfs_message *msg)
 {
 	size_t i = 0;
@@ -275,7 +275,7 @@ out:
 
 
 static int
-write_tag_66_packet(char *signature, size_t cipher_code,
+write_tag_66_packet(char *signature, u8 cipher_code,
 		    struct ecryptfs_crypt_stat *crypt_stat, char **packet,
 		    size_t *packet_len)
 {
@@ -428,7 +428,7 @@ static int
 decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 				  struct ecryptfs_crypt_stat *crypt_stat)
 {
-	u16 cipher_code = 0;
+	u8 cipher_code = 0;
 	struct ecryptfs_msg_ctx *msg_ctx;
 	struct ecryptfs_message *msg = NULL;
 	char *auth_tok_sig;
@@ -1537,7 +1537,7 @@ write_tag_3_packet(char *dest, size_t *r
 	struct scatterlist dst_sg;
 	struct scatterlist src_sg;
 	struct mutex *tfm_mutex = NULL;
-	size_t cipher_code;
+	u8 cipher_code;
 	size_t packet_size_length;
 	size_t max_packet_size;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
_

Patches currently in -mm which might be from thighlan@gmail.com are

ecryptfs-change-the-type-of-cipher_code-from-u16-to-u8.patch
ecryptfs-load-each-file-decryption-key-only-once.patch
