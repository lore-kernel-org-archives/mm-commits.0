From: akpm@linux-foundation.org
Subject: + ecryptfs-remove-unnecessary-variable-initializations.patch added to -mm tree
Date: Wed, 25 Jul 2007 23:13:06 -0700
Message-ID: <200707260613.l6Q6D6XF017505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbXGZGOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 02:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: remove unnecessary variable initializations
has been added to the -mm tree.  Its filename is
     ecryptfs-remove-unnecessary-variable-initializations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: remove unnecessary variable initializations
From: Michael Halcrow <mhalcrow@us.ibm.com>

Andrew Morton wrote:
> >       struct mutex *tfm_mutex = NULL;
>
> This initialisation looks like it's here to kill bogus gcc warning
> (if it is, it should have been commented).  Please investigate
> uninitialized_var() and __maybe_unused sometime.

Remove some unnecessary variable initializations. There may be a few
more such intializations remaining in the code base; a future patch
will take care of those.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-remove-unnecessary-variable-initializations fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-remove-unnecessary-variable-initializations
+++ a/fs/ecryptfs/keystore.c
@@ -1009,7 +1009,7 @@ decrypt_passphrase_encrypted_session_key
 {
 	struct scatterlist dst_sg;
 	struct scatterlist src_sg;
-	struct mutex *tfm_mutex = NULL;
+	struct mutex *tfm_mutex;
 	struct blkcipher_desc desc = {
 		.flags = CRYPTO_TFM_REQ_MAY_SLEEP
 	};
@@ -1123,8 +1123,8 @@ int ecryptfs_parse_packet_set(struct ecr
 	size_t found_auth_tok;
 	size_t next_packet_is_auth_tok_packet;
 	struct list_head auth_tok_list;
-	struct ecryptfs_auth_tok *matching_auth_tok = NULL;
-	struct ecryptfs_auth_tok *candidate_auth_tok = NULL;
+	struct ecryptfs_auth_tok *matching_auth_tok;
+	struct ecryptfs_auth_tok *candidate_auth_tok;
 	char *candidate_auth_tok_sig;
 	size_t packet_size;
 	struct ecryptfs_auth_tok *new_auth_tok;
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
