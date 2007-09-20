From: akpm@linux-foundation.org
Subject: + ecryptfs-initialize-persistent-lower-file-on-inode-create.patch added to -mm tree
Date: Wed, 19 Sep 2007 22:51:40 -0700
Message-ID: <200709200551.l8K5pecd030773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236AbXITFvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 01:51:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: initialize persistent lower file on inode create
has been added to the -mm tree.  Its filename is
     ecryptfs-initialize-persistent-lower-file-on-inode-create.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: initialize persistent lower file on inode create
From: Michael Halcrow <mhalcrow@us.ibm.com>

Initialize persistent lower file on inode create.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/super.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/ecryptfs/super.c~ecryptfs-initialize-persistent-lower-file-on-inode-create fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-initialize-persistent-lower-file-on-inode-create
+++ a/fs/ecryptfs/super.c
@@ -47,15 +47,16 @@ struct kmem_cache *ecryptfs_inode_info_c
  */
 static struct inode *ecryptfs_alloc_inode(struct super_block *sb)
 {
-	struct ecryptfs_inode_info *ecryptfs_inode;
+	struct ecryptfs_inode_info *inode_info;
 	struct inode *inode = NULL;
 
-	ecryptfs_inode = kmem_cache_alloc(ecryptfs_inode_info_cache,
-					  GFP_KERNEL);
-	if (unlikely(!ecryptfs_inode))
+	inode_info = kmem_cache_alloc(ecryptfs_inode_info_cache, GFP_KERNEL);
+	if (unlikely(!inode_info))
 		goto out;
-	ecryptfs_init_crypt_stat(&ecryptfs_inode->crypt_stat);
-	inode = &ecryptfs_inode->vfs_inode;
+	ecryptfs_init_crypt_stat(&inode_info->crypt_stat);
+	mutex_init(&inode_info->lower_file_mutex);
+	inode_info->lower_file = NULL;
+	inode = &inode_info->vfs_inode;
 out:
 	return inode;
 }
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
git-unionfs.patch
fs-remove-some-aop_truncated_page.patch
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
ecryptfs-use-generic_file_splice_read.patch
ecryptfs-remove-header_extent_size.patch
ecryptfs-remove-assignments-in-if-statements.patch
ecryptfs-read_writec-routines.patch
ecryptfs-replace-encrypt-decrypt-and-inode-size-write.patch
ecryptfs-set-up-and-destroy-persistent-lower-file.patch
ecryptfs-update-metadata-read-write-functions.patch
ecryptfs-make-open-truncate-and-setattr-use-persistent-file.patch
ecryptfs-convert-mmap-functions-to-use-persistent-file.patch
ecryptfs-initialize-persistent-lower-file-on-inode-create.patch
ecryptfs-remove-unused-functions-and-kmem_cache.patch
ecryptfs-replace-magic-numbers.patch
