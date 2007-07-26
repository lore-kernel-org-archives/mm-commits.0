From: akpm@linux-foundation.org
Subject: + ecryptfs-collapse-flag-set-into-one-statement.patch added to -mm tree
Date: Wed, 25 Jul 2007 23:13:00 -0700
Message-ID: <200707260613.l6Q6D0WP017485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53510 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbXGZGNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 02:13:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: collapse flag set into one statement
has been added to the -mm tree.  Its filename is
     ecryptfs-collapse-flag-set-into-one-statement.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: collapse flag set into one statement
From: Michael Halcrow <mhalcrow@us.ibm.com>

Andrew Morton wrote:
> > +     crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
> > +     crypt_stat->flags |= ECRYPTFS_KEY_VALID;
>
> Maybe the compiler can optimise those two statements, but we'd
> normally provide it with some manual help.

This patch provides the compiler with some manual help for
optimizing the setting of some flags.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-collapse-flag-set-into-one-statement fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-collapse-flag-set-into-one-statement
+++ a/fs/ecryptfs/crypto.c
@@ -1029,8 +1029,7 @@ int ecryptfs_new_file_context(struct den
 	int rc = 0;
 
 	ecryptfs_set_default_crypt_stat_vals(crypt_stat, mount_crypt_stat);
-	crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
-	crypt_stat->flags |= ECRYPTFS_KEY_VALID;
+	crypt_stat->flags |= (ECRYPTFS_ENCRYPTED | ECRYPTFS_KEY_VALID);
 	ecryptfs_copy_mount_wide_flags_to_inode_flags(crypt_stat,
 						      mount_crypt_stat);
 	rc = ecryptfs_copy_mount_wide_sigs_to_inode_sigs(crypt_stat,
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
