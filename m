From: akpm@linux-foundation.org
Subject: + ecryptfs-update-comment-and-debug-statement.patch added to -mm tree
Date: Fri, 20 Jul 2007 15:27:10 -0700
Message-ID: <200707202227.l6KMRAKI019758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763560AbXGTW10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 18:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: update comment and debug statement
has been added to the -mm tree.  Its filename is
     ecryptfs-update-comment-and-debug-statement.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: update comment and debug statement
From: Michael Halcrow <mhalcrow@us.ibm.com>

Trivial updates to comment and debug statement.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    2 --
 fs/ecryptfs/debug.c  |    2 --
 2 files changed, 4 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-update-comment-and-debug-statement fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-update-comment-and-debug-statement
+++ a/fs/ecryptfs/crypto.c
@@ -1267,8 +1267,6 @@ static int ecryptfs_read_header_region(c
 	lower_file->f_pos = 0;
 	oldfs = get_fs();
 	set_fs(get_ds());
-	/* For releases 0.1 and 0.2, all of the header information
-	 * fits in the first data extent-sized region. */
 	rc = lower_file->f_op->read(lower_file, (char __user *)data,
 			      ECRYPTFS_DEFAULT_EXTENT_SIZE, &lower_file->f_pos);
 	set_fs(oldfs);
diff -puN fs/ecryptfs/debug.c~ecryptfs-update-comment-and-debug-statement fs/ecryptfs/debug.c
--- a/fs/ecryptfs/debug.c~ecryptfs-update-comment-and-debug-statement
+++ a/fs/ecryptfs/debug.c
@@ -38,8 +38,6 @@ void ecryptfs_dump_auth_tok(struct ecryp
 			auth_tok);
 	if (auth_tok->flags & ECRYPTFS_PRIVATE_KEY) {
 		ecryptfs_printk(KERN_DEBUG, " * private key type\n");
-		ecryptfs_printk(KERN_DEBUG, " * (NO PRIVATE KEY SUPPORT "
-				"IN ECRYPTFS VERSION 0.1)\n");
 	} else {
 		ecryptfs_printk(KERN_DEBUG, " * passphrase type\n");
 		ecryptfs_to_hex(salt, auth_tok->token.password.salt,
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
