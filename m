From: akpm@linux-foundation.org
Subject: + ecryptfs-comments-for-some-structs.patch added to -mm tree
Date: Wed, 25 Jul 2007 23:13:02 -0700
Message-ID: <200707260613.l6Q6D27n017499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbXGZGTA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 02:19:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: comments for some structs
has been added to the -mm tree.  Its filename is
     ecryptfs-comments-for-some-structs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: comments for some structs
From: Michael Halcrow <mhalcrow@us.ibm.com>

Andrew Morton wrote:
> > +struct ecryptfs_global_auth_tok {
> > +#define ECRYPTFS_AUTH_TOK_INVALID 0x00000001
> > +     u32 flags;
> > +     struct list_head mount_crypt_stat_list;
> > +     struct key *global_auth_tok_key;
> > +     struct ecryptfs_auth_tok *global_auth_tok;
> > +     unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1];
> > +};
> > +
> > +struct ecryptfs_key_tfm {
> > +     struct crypto_blkcipher *key_tfm;
> > +     size_t key_size;
> > +     struct mutex key_tfm_mutex;
> > +     struct list_head key_tfm_list;
> > +     unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
> > +};
>
> Please consider commenting your struct fields carefully: it's a
> great way to help other to understand your code.

Add some comments to the ecryptfs_global_auth_tok and ecryptfs_key_tfm
structs to make their functions more easily ascertained.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/ecryptfs_kernel.h |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-comments-for-some-structs fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-comments-for-some-structs
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -273,20 +273,36 @@ struct ecryptfs_dentry_info {
 	struct ecryptfs_crypt_stat *crypt_stat;
 };
 
+/**
+ * ecryptfs_global_auth_tok structs refer to authentication token keys
+ * in the user keyring that apply to newly created files. A list of
+ * these objects hangs off of the mount_crypt_stat struct for any
+ * given eCryptfs mount. This struct maintains a reference to both the
+ * key contents and the key itself so that the key can be put on
+ * unmount.
+ */
 struct ecryptfs_global_auth_tok {
 #define ECRYPTFS_AUTH_TOK_INVALID 0x00000001
 	u32 flags;
-	struct list_head mount_crypt_stat_list;
-	struct key *global_auth_tok_key;
-	struct ecryptfs_auth_tok *global_auth_tok;
-	unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1];
+	struct list_head mount_crypt_stat_list; /* Default auth_tok list for
+						 * the mount_crypt_stat */
+	struct key *global_auth_tok_key; /* The key from the user's keyring for
+					  * the sig */
+	struct ecryptfs_auth_tok *global_auth_tok; /* The key contents */
+	unsigned char sig[ECRYPTFS_SIG_SIZE_HEX + 1]; /* The key identifier */
 };
 
+/**
+ * Typically, eCryptfs will use the same ciphers repeatedly throughout
+ * the course of its operations. In order to avoid unnecessarily
+ * destroying and initializing the same cipher repeatedly, eCryptfs
+ * keeps a list of crypto API contexts around to use when needed.
+ */
 struct ecryptfs_key_tfm {
 	struct crypto_blkcipher *key_tfm;
 	size_t key_size;
 	struct mutex key_tfm_mutex;
-	struct list_head key_tfm_list;
+	struct list_head key_tfm_list; /* The module's tfm list */
 	unsigned char cipher_name[ECRYPTFS_MAX_CIPHER_NAME_SIZE + 1];
 };
 
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
