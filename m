From: akpm@linux-foundation.org
Subject: + ecryptfs-remove-unnecessary-bug_on.patch added to -mm tree
Date: Wed, 25 Jul 2007 23:12:58 -0700
Message-ID: <200707260612.l6Q6CwuT017475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671AbXGZGNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 02:13:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: remove unnecessary BUG_ON
has been added to the -mm tree.  Its filename is
     ecryptfs-remove-unnecessary-bug_on.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: remove unnecessary BUG_ON
From: Michael Halcrow <mhalcrow@us.ibm.com>

Andrew Morton wrote:
> > +     mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
> > +     BUG_ON(mount_crypt_stat->num_global_auth_toks == 0);
> > +     mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
>
> That's odd-looking.  If it was a bug for num_global_auth_toks to be
> zero, and if that mutex protects num_global_auth_toks then as soon
> as the lock gets dropped, another thread can make
> num_global_auth_toks zero, hence the bug is present.  Perhaps?

That was serving as an internal sanity check that should not have made
it into the final patch set in the first place. This patch removes it.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-remove-unnecessary-bug_on fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-remove-unnecessary-bug_on
+++ a/fs/ecryptfs/crypto.c
@@ -1029,9 +1029,6 @@ int ecryptfs_new_file_context(struct den
 	int rc = 0;
 
 	ecryptfs_set_default_crypt_stat_vals(crypt_stat, mount_crypt_stat);
-	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
-	BUG_ON(mount_crypt_stat->num_global_auth_toks == 0);
-	mutex_unlock(&mount_crypt_stat->global_auth_tok_list_mutex);
 	crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
 	crypt_stat->flags |= ECRYPTFS_KEY_VALID;
 	ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
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
