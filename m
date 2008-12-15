From: akpm@linux-foundation.org
Subject: + nilfs2-cleanup-nilfs_clear_inode.patch added to -mm tree
Date: Mon, 15 Dec 2008 15:27:20 -0800
Message-ID: <200812152327.mBFNRK2P004947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbYLOX2B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 18:28:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp


The patch titled
     nilfs2: cleanup nilfs_clear_inode
has been added to the -mm tree.  Its filename is
     nilfs2-cleanup-nilfs_clear_inode.patch

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
Subject: nilfs2: cleanup nilfs_clear_inode
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This will remove the following unnecessary locks and cleanup code in
nilfs_clear_inode():

- unnecessary protection using nilfs_transaction_begin() and
  nilfs_transaction_end().

- cleanup code of i_dirty list field which is never chained
  when this function is called.

- spinlock used when releasing i_bh field.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN fs/nilfs2/super.c~nilfs2-cleanup-nilfs_clear_inode fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-cleanup-nilfs_clear_inode
+++ a/fs/nilfs2/super.c
@@ -184,8 +184,6 @@ static inline void nilfs_destroy_inode_c
 static void nilfs_clear_inode(struct inode *inode)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct nilfs_transaction_info ti;
-	struct nilfs_sb_info *sbi = NILFS_SB(inode->i_sb);
 
 #ifdef CONFIG_NILFS_POSIX_ACL
 	if (ii->i_acl && ii->i_acl != NILFS_ACL_NOT_CACHED) {
@@ -200,21 +198,14 @@ static void nilfs_clear_inode(struct ino
 	/*
 	 * Free resources allocated in nilfs_read_inode(), here.
 	 */
-	nilfs_transaction_begin(inode->i_sb, &ti, 0);
-
-	spin_lock(&sbi->s_inode_lock);
-	if (!list_empty(&ii->i_dirty))
-		list_del_init(&ii->i_dirty);
+	BUG_ON(!list_empty(&ii->i_dirty));
 	brelse(ii->i_bh);
 	ii->i_bh = NULL;
-	spin_unlock(&sbi->s_inode_lock);
 
 	if (test_bit(NILFS_I_BMAP, &ii->i_state))
 		nilfs_bmap_clear(ii->i_bmap);
 
 	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
-
-	nilfs_transaction_end(inode->i_sb, 0);
 }
 
 /**
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-add-document.patch
nilfs2-disk-format-and-userland-interface.patch
nilfs2-add-inode-and-other-major-structures.patch
nilfs2-integrated-block-mapping.patch
nilfs2-b-tree-based-block-mapping.patch
nilfs2-direct-block-mapping.patch
nilfs2-b-tree-node-cache.patch
nilfs2-buffer-and-page-operations.patch
nilfs2-meta-data-file.patch
nilfs2-persistent-object-allocator.patch
nilfs2-disk-address-translator.patch
nilfs2-inode-map-file.patch
nilfs2-checkpoint-file.patch
nilfs2-segment-usage-file.patch
nilfs2-inode-operations.patch
nilfs2-inode-operations-fix.patch
nilfs2-file-operations.patch
nilfs2-directory-entry-operations.patch
nilfs2-pathname-operations.patch
nilfs2-pathname-operations-fix.patch
nilfs2-operations-for-the_nilfs-core-object.patch
nilfs2-super-block-operations.patch
nilfs2-super-block-operations-fix.patch
nilfs2-segment-buffer.patch
nilfs2-segment-constructor.patch
nilfs2-recovery-functions.patch
nilfs2-another-dat-for-garbage-collection.patch
nilfs2-block-cache-for-garbage-collection.patch
nilfs2-ioctl-operations.patch
nilfs2-update-makefile-and-kconfig.patch
nilfs2-fix-problems-of-memory-allocation-in-ioctl.patch
nilfs2-cleanup-nilfs_clear_inode.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
nilfs2-insert-explanations-in-gcinode-file.patch
nilfs2-add-maintainer.patch

