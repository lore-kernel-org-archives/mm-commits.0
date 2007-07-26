From: akpm@linux-foundation.org
Subject: + ecryptfs-grammatical-fix-destruct-to-destroy.patch added to -mm tree
Date: Wed, 25 Jul 2007 23:13:01 -0700
Message-ID: <200707260613.l6Q6D1Rf017489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37631 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282AbXGZGNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 02:13:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: grammatical fix (destruct to destroy)
has been added to the -mm tree.  Its filename is
     ecryptfs-grammatical-fix-destruct-to-destroy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: grammatical fix (destruct to destroy)
From: Michael Halcrow <mhalcrow@us.ibm.com>

Andrew Morton wrote:
> > +int ecryptfs_destruct_crypto(void)
>
> ecryptfs_destroy_crypto would be more grammatically correct ;)

Grammatical fix for some function names.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |    8 ++++----
 fs/ecryptfs/ecryptfs_kernel.h |    6 +++---
 fs/ecryptfs/main.c            |    4 ++--
 fs/ecryptfs/super.c           |    4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-grammatical-fix-destruct-to-destroy fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-grammatical-fix-destruct-to-destroy
+++ a/fs/ecryptfs/crypto.c
@@ -213,12 +213,12 @@ ecryptfs_init_crypt_stat(struct ecryptfs
 }
 
 /**
- * ecryptfs_destruct_crypt_stat
+ * ecryptfs_destroy_crypt_stat
  * @crypt_stat: Pointer to the crypt_stat struct to initialize.
  *
  * Releases all memory associated with a crypt_stat struct.
  */
-void ecryptfs_destruct_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat)
+void ecryptfs_destroy_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat)
 {
 	struct ecryptfs_key_sig *key_sig, *key_sig_tmp;
 
@@ -236,7 +236,7 @@ void ecryptfs_destruct_crypt_stat(struct
 	memset(crypt_stat, 0, sizeof(struct ecryptfs_crypt_stat));
 }
 
-void ecryptfs_destruct_mount_crypt_stat(
+void ecryptfs_destroy_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat)
 {
 	struct ecryptfs_global_auth_tok *auth_tok, *auth_tok_tmp;
@@ -1880,7 +1880,7 @@ int ecryptfs_init_crypto(void)
 	return 0;
 }
 
-int ecryptfs_destruct_crypto(void)
+int ecryptfs_destroy_crypto(void)
 {
 	struct ecryptfs_key_tfm *key_tfm, *key_tfm_tmp;
 
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-grammatical-fix-destruct-to-destroy fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-grammatical-fix-destruct-to-destroy
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -516,8 +516,8 @@ int virt_to_scatterlist(const void *addr
 int ecryptfs_compute_root_iv(struct ecryptfs_crypt_stat *crypt_stat);
 void ecryptfs_rotate_iv(unsigned char *iv);
 void ecryptfs_init_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat);
-void ecryptfs_destruct_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat);
-void ecryptfs_destruct_mount_crypt_stat(
+void ecryptfs_destroy_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat);
+void ecryptfs_destroy_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat);
 int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat);
 int ecryptfs_crypto_api_algify_cipher_name(char **algified_name,
@@ -620,7 +620,7 @@ int
 ecryptfs_add_new_key_tfm(struct ecryptfs_key_tfm **key_tfm, char *cipher_name,
 			 size_t key_size);
 int ecryptfs_init_crypto(void);
-int ecryptfs_destruct_crypto(void);
+int ecryptfs_destroy_crypto(void);
 int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
 					       struct mutex **tfm_mutex,
 					       char *cipher_name);
diff -puN fs/ecryptfs/main.c~ecryptfs-grammatical-fix-destruct-to-destroy fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-grammatical-fix-destruct-to-destroy
+++ a/fs/ecryptfs/main.c
@@ -843,8 +843,8 @@ static void __exit ecryptfs_exit(void)
 {
 	int rc;
 
-	if ((rc = ecryptfs_destruct_crypto())) {
-		printk(KERN_ERR "Failure whilst attempting to destruct crypto; "
+	if ((rc = ecryptfs_destroy_crypto())) {
+		printk(KERN_ERR "Failure whilst attempting to destroy crypto; "
 		       "rc = [%d]\n", rc);
 	}
 	sysfs_remove_file(&ecryptfs_subsys.kobj,
diff -puN fs/ecryptfs/super.c~ecryptfs-grammatical-fix-destruct-to-destroy fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-grammatical-fix-destruct-to-destroy
+++ a/fs/ecryptfs/super.c
@@ -73,7 +73,7 @@ static void ecryptfs_destroy_inode(struc
 	struct ecryptfs_inode_info *inode_info;
 
 	inode_info = ecryptfs_inode_to_private(inode);
-	ecryptfs_destruct_crypt_stat(&inode_info->crypt_stat);
+	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
 	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
 }
 
@@ -104,7 +104,7 @@ static void ecryptfs_put_super(struct su
 {
 	struct ecryptfs_sb_info *sb_info = ecryptfs_superblock_to_private(sb);
 
-	ecryptfs_destruct_mount_crypt_stat(&sb_info->mount_crypt_stat);
+	ecryptfs_destroy_mount_crypt_stat(&sb_info->mount_crypt_stat);
 	kmem_cache_free(ecryptfs_sb_info_cache, sb_info);
 	ecryptfs_set_superblock_private(sb, NULL);
 }
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
