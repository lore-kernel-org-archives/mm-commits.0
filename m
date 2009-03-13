From: akpm@linux-foundation.org
Subject: + ecryptfs-dont-encrypt-file-key-with-filename-key.patch added to -mm tree
Date: Fri, 13 Mar 2009 12:36:36 -0700
Message-ID: <200903131936.n2DJaa99017581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbZCMTjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 15:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tyhicks@linux.vnet.ibm.com, kirkland@canonical.com, serue@us.ibm.com


The patch titled
     eCryptfs: don't encrypt file key with filename key
has been added to the -mm tree.  Its filename is
     ecryptfs-dont-encrypt-file-key-with-filename-key.patch

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
Subject: eCryptfs: don't encrypt file key with filename key
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

eCryptfs has file encryption keys (FEK), file encryption key encryption
keys (FEKEK), and filename encryption keys (FNEK).  The per-file FEK is
encrypted with one or more FEKEKs and stored in the header of the
encrypted file.  I noticed that the FEK is also being encrypted by the
FNEK.  This is a problem if a user wants to use a different FNEK than
their FEKEK, as their file contents will still be accessible with the
FNEK.

This is a minimalistic patch which prevents the FNEKs signatures from
being copied to the inode signatures list.  Ultimately, it keeps the FEK
from being encrypted with a FNEK.

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Acked-by: Dustin Kirkland <kirkland@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c          |    2 ++
 fs/ecryptfs/ecryptfs_kernel.h |    3 ++-
 fs/ecryptfs/keystore.c        |    3 ++-
 fs/ecryptfs/main.c            |    5 +++--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-dont-encrypt-file-key-with-filename-key fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-dont-encrypt-file-key-with-filename-key
+++ a/fs/ecryptfs/crypto.c
@@ -946,6 +946,8 @@ static int ecryptfs_copy_mount_wide_sigs
 	list_for_each_entry(global_auth_tok,
 			    &mount_crypt_stat->global_auth_tok_list,
 			    mount_crypt_stat_list) {
+		if (global_auth_tok->flags & ECRYPTFS_AUTH_TOK_FNEK)
+			continue;
 		rc = ecryptfs_add_keysig(crypt_stat, global_auth_tok->sig);
 		if (rc) {
 			printk(KERN_ERR "Error adding keysig; rc = [%d]\n", rc);
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-dont-encrypt-file-key-with-filename-key fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-dont-encrypt-file-key-with-filename-key
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -328,6 +328,7 @@ struct ecryptfs_dentry_info {
  */
 struct ecryptfs_global_auth_tok {
 #define ECRYPTFS_AUTH_TOK_INVALID 0x00000001
+#define ECRYPTFS_AUTH_TOK_FNEK    0x00000002
 	u32 flags;
 	struct list_head mount_crypt_stat_list;
 	struct key *global_auth_tok_key;
@@ -696,7 +697,7 @@ ecryptfs_write_header_metadata(char *vir
 int ecryptfs_add_keysig(struct ecryptfs_crypt_stat *crypt_stat, char *sig);
 int
 ecryptfs_add_global_auth_tok(struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
-			   char *sig);
+			   char *sig, u32 global_auth_tok_flags);
 int ecryptfs_get_global_auth_tok_for_sig(
 	struct ecryptfs_global_auth_tok **global_auth_tok,
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat, char *sig);
diff -puN fs/ecryptfs/keystore.c~ecryptfs-dont-encrypt-file-key-with-filename-key fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-dont-encrypt-file-key-with-filename-key
+++ a/fs/ecryptfs/keystore.c
@@ -2375,7 +2375,7 @@ struct kmem_cache *ecryptfs_global_auth_
 
 int
 ecryptfs_add_global_auth_tok(struct ecryptfs_mount_crypt_stat *mount_crypt_stat,
-			     char *sig)
+			     char *sig, u32 global_auth_tok_flags)
 {
 	struct ecryptfs_global_auth_tok *new_auth_tok;
 	int rc = 0;
@@ -2389,6 +2389,7 @@ ecryptfs_add_global_auth_tok(struct ecry
 		goto out;
 	}
 	memcpy(new_auth_tok->sig, sig, ECRYPTFS_SIG_SIZE_HEX);
+	new_auth_tok->flags = global_auth_tok_flags;
 	new_auth_tok->sig[ECRYPTFS_SIG_SIZE_HEX] = '\0';
 	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
 	list_add(&new_auth_tok->mount_crypt_stat_list,
diff -puN fs/ecryptfs/main.c~ecryptfs-dont-encrypt-file-key-with-filename-key fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-dont-encrypt-file-key-with-filename-key
+++ a/fs/ecryptfs/main.c
@@ -319,7 +319,7 @@ static int ecryptfs_parse_options(struct
 		case ecryptfs_opt_ecryptfs_sig:
 			sig_src = args[0].from;
 			rc = ecryptfs_add_global_auth_tok(mount_crypt_stat,
-							  sig_src);
+							  sig_src, 0);
 			if (rc) {
 				printk(KERN_ERR "Error attempting to register "
 				       "global sig; rc = [%d]\n", rc);
@@ -370,7 +370,8 @@ static int ecryptfs_parse_options(struct
 				ECRYPTFS_SIG_SIZE_HEX] = '\0';
 			rc = ecryptfs_add_global_auth_tok(
 				mount_crypt_stat,
-				mount_crypt_stat->global_default_fnek_sig);
+				mount_crypt_stat->global_default_fnek_sig,
+				ECRYPTFS_AUTH_TOK_FNEK);
 			if (rc) {
 				printk(KERN_ERR "Error attempting to register "
 				       "global fnek sig [%s]; rc = [%d]\n",
_

Patches currently in -mm which might be from tyhicks@linux.vnet.ibm.com are

ecryptfs-dont-encrypt-file-key-with-filename-key.patch
ecryptfs-use-kzfree.patch

