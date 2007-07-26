From: akpm@linux-foundation.org
Subject: + ecryptfs-make-needlessly-global-symbols-static.patch added to -mm tree
Date: Wed, 25 Jul 2007 23:13:07 -0700
Message-ID: <200707260613.l6Q6D7lX017508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55940 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbXGZGNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 02:13:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: make needlessly global symbols static
has been added to the -mm tree.  Its filename is
     ecryptfs-make-needlessly-global-symbols-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: make needlessly global symbols static
From: Michael Halcrow <mhalcrow@us.ibm.com>

Andrew Morton wrote:
> Please check that all the newly-added global symbols do indeed need
> to be global.

Change symbols in keystore.c and crypto.o to static if they do not
need to be global.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |    8 ++---
 fs/ecryptfs/ecryptfs_kernel.h |    7 -----
 fs/ecryptfs/keystore.c        |   43 ++++++++++++++++----------------
 3 files changed, 26 insertions(+), 32 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-make-needlessly-global-symbols-static fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-make-needlessly-global-symbols-static
+++ a/fs/ecryptfs/crypto.c
@@ -123,9 +123,9 @@ out:
 	return rc;
 }
 
-int ecryptfs_crypto_api_algify_cipher_name(char **algified_name,
-					   char *cipher_name,
-					   char *chaining_modifier)
+static int ecryptfs_crypto_api_algify_cipher_name(char **algified_name,
+						  char *cipher_name,
+						  char *chaining_modifier)
 {
 	int cipher_name_len = strlen(cipher_name);
 	int chaining_modifier_len = strlen(chaining_modifier);
@@ -1859,7 +1859,7 @@ out:
  * should be released by other functions, such as on a superblock put
  * event, regardless of whether this function succeeds for fails.
  */
-int
+static int
 ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
 			    char *cipher_name, size_t *key_size)
 {
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-make-needlessly-global-symbols-static fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-make-needlessly-global-symbols-static
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -156,7 +156,6 @@ struct ecryptfs_auth_tok {
 	} token;
 } __attribute__ ((packed));
 
-int ecryptfs_get_auth_tok_sig(char **sig, struct ecryptfs_auth_tok *auth_tok);
 void ecryptfs_dump_auth_tok(struct ecryptfs_auth_tok *auth_tok);
 extern void ecryptfs_to_hex(char *dst, char *src, size_t src_size);
 extern void ecryptfs_from_hex(char *dst, char *src, int dst_size);
@@ -536,9 +535,6 @@ void ecryptfs_destroy_crypt_stat(struct 
 void ecryptfs_destroy_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat);
 int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat);
-int ecryptfs_crypto_api_algify_cipher_name(char **algified_name,
-					   char *cipher_name,
-					   char *chaining_modifier);
 #define ECRYPTFS_LOWER_I_MUTEX_NOT_HELD 0
 #define ECRYPTFS_LOWER_I_MUTEX_HELD 1
 int ecryptfs_write_inode_size_to_metadata(struct file *lower_file,
@@ -579,13 +575,10 @@ int ecryptfs_generate_key_packet_set(cha
 				     struct ecryptfs_crypt_stat *crypt_stat,
 				     struct dentry *ecryptfs_dentry,
 				     size_t *len, size_t max);
-int process_request_key_err(long err_code);
 int
 ecryptfs_parse_packet_set(struct ecryptfs_crypt_stat *crypt_stat,
 			  unsigned char *src, struct dentry *ecryptfs_dentry);
 int ecryptfs_truncate(struct dentry *dentry, loff_t new_length);
-int ecryptfs_process_key_cipher(struct crypto_blkcipher **key_tfm,
-				char *cipher_name, size_t *key_size);
 int ecryptfs_inode_test(struct inode *inode, void *candidate_lower_inode);
 int ecryptfs_inode_set(struct inode *inode, void *lower_inode);
 void ecryptfs_init_inode(struct inode *inode, struct inode *lower_inode);
diff -puN fs/ecryptfs/keystore.c~ecryptfs-make-needlessly-global-symbols-static fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-make-needlessly-global-symbols-static
+++ a/fs/ecryptfs/keystore.c
@@ -39,7 +39,7 @@
  * determine the type of error, make appropriate log entries, and
  * return an error code.
  */
-int process_request_key_err(long err_code)
+static int process_request_key_err(long err_code)
 {
 	int rc = 0;
 
@@ -396,6 +396,27 @@ out:
 	return rc;
 }
 
+static int
+ecryptfs_get_auth_tok_sig(char **sig, struct ecryptfs_auth_tok *auth_tok)
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
  * decrypt_pki_encrypted_session_key - Decrypt the session key with the given auth_tok.
  * @auth_tok: The key authentication token used to decrypt the session key
@@ -1082,26 +1103,6 @@ out:
 	return rc;
 }
 
-int ecryptfs_get_auth_tok_sig(char **sig, struct ecryptfs_auth_tok *auth_tok)
-{
-	int rc = 0;
-
-	(*sig) = NULL;
-	switch (auth_tok->token_type) {
-	case ECRYPTFS_PASSWORD:
-		(*sig) = auth_tok->token.password.signature;
-		break;
-	case ECRYPTFS_PRIVATE_KEY:
-		(*sig) = auth_tok->token.private_key.signature;
-		break;
-	default:
-		printk(KERN_ERR "Cannot get sig for auth_tok of type [%d]\n",
-		       auth_tok->token_type);
-		rc = -EINVAL;
-	}
-	return rc;
-}
-
 /**
  * ecryptfs_parse_packet_set
  * @crypt_stat: The cryptographic context
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
