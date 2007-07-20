From: akpm@linux-foundation.org
Subject: + ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch added to -mm tree
Date: Fri, 20 Jul 2007 15:27:00 -0700
Message-ID: <200707202227.l6KMR0MI019671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757923AbXGTW1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 18:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: kmem_cache objects for multiple keys; init/exit functions
has been added to the -mm tree.  Its filename is
     ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: kmem_cache objects for multiple keys; init/exit functions
From: Michael Halcrow <mhalcrow@us.ibm.com>

Introduce kmem_cache objects for handling multiple keys per inode.  Add calls
in the module init and exit code to call the key list
initialization/destruction functions.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/main.c |   39 +++++++++++++++++++++++++++++++--------
 1 files changed, 31 insertions(+), 8 deletions(-)

diff -puN fs/ecryptfs/main.c~ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-kmem_cache-objects-for-multiple-keys-init-exit-functions
+++ a/fs/ecryptfs/main.c
@@ -240,14 +240,11 @@ static int ecryptfs_parse_options(struct
 	int cipher_name_set = 0;
 	int cipher_key_bytes;
 	int cipher_key_bytes_set = 0;
-	struct key *auth_tok_key = NULL;
-	struct ecryptfs_auth_tok *auth_tok = NULL;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
 		&ecryptfs_superblock_to_private(sb)->mount_crypt_stat;
 	substring_t args[MAX_OPT_ARGS];
 	int token;
 	char *sig_src;
-	char *sig_dst;
 	char *debug_src;
 	char *cipher_name_dst;
 	char *cipher_name_src;
@@ -258,6 +255,7 @@ static int ecryptfs_parse_options(struct
 		rc = -EINVAL;
 		goto out;
 	}
+	ecryptfs_init_mount_crypt_stat(mount_crypt_stat);
 	while ((p = strsep(&options, ",")) != NULL) {
 		if (!*p)
 			continue;
@@ -334,12 +332,10 @@ static int ecryptfs_parse_options(struct
 					p);
 		}
 	}
-	/* Do not support lack of mount-wide signature in 0.1
-	 * release */
 	if (!sig_set) {
 		rc = -EINVAL;
-		ecryptfs_printk(KERN_ERR, "You must supply a valid "
-				"passphrase auth tok signature as a mount "
+		ecryptfs_printk(KERN_ERR, "You must supply at least one valid "
+				"auth tok signature as a mount "
 				"parameter; see the eCryptfs README\n");
 		goto out;
 	}
@@ -615,6 +611,21 @@ static struct ecryptfs_cache_info {
 		.name = "ecryptfs_key_record_cache",
 		.size = sizeof(struct ecryptfs_key_record),
 	},
+	{
+		.cache = &ecryptfs_key_sig_cache,
+		.name = "ecryptfs_key_sig_cache",
+		.size = sizeof(struct ecryptfs_key_sig),
+	},
+	{
+		.cache = &ecryptfs_global_auth_tok_cache,
+		.name = "ecryptfs_global_auth_tok_cache",
+		.size = sizeof(struct ecryptfs_global_auth_tok),
+	},
+	{
+		.cache = &ecryptfs_key_tfm_cache,
+		.name = "ecryptfs_key_tfm_cache",
+		.size = sizeof(struct ecryptfs_key_tfm),
+	},
 };
 
 static void ecryptfs_free_kmem_caches(void)
@@ -717,7 +728,8 @@ static struct ecryptfs_version_str_map_e
 	{ECRYPTFS_VERSIONING_PUBKEY, "pubkey"},
 	{ECRYPTFS_VERSIONING_PLAINTEXT_PASSTHROUGH, "plaintext passthrough"},
 	{ECRYPTFS_VERSIONING_POLICY, "policy"},
-	{ECRYPTFS_VERSIONING_XATTR, "metadata in extended attribute"}
+	{ECRYPTFS_VERSIONING_XATTR, "metadata in extended attribute"},
+	{ECRYPTFS_VERSIONING_MULTKEY, "multiple keys per file"}
 };
 
 static ssize_t version_str_show(struct ecryptfs_obj *obj, char *buff)
@@ -818,6 +830,11 @@ static int __init ecryptfs_init(void)
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Failure occured while attempting to "
 				"initialize the eCryptfs netlink socket\n");
+		goto out;
+	}
+	if ((rc = ecryptfs_init_crypto())) {
+		printk(KERN_ERR "Failure whilst attempting to init crypto; "
+		       "rc = [%d]\n", rc);
 	}
 out:
 	return rc;
@@ -825,6 +842,12 @@ out:
 
 static void __exit ecryptfs_exit(void)
 {
+	int rc;
+
+	if ((rc = ecryptfs_destruct_crypto())) {
+		printk(KERN_ERR "Failure whilst attempting to destruct crypto; "
+		       "rc = [%d]\n", rc);
+	}
 	sysfs_remove_file(&ecryptfs_subsys.kobj,
 			  &sysfs_attr_version.attr);
 	sysfs_remove_file(&ecryptfs_subsys.kobj,
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
