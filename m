From: akpm@linux-foundation.org
Subject: [merged] nilfs2-cleanup-nilfs_clear_inode.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:09:12 -0700
Message-ID: <200904071909.n37J9Cv8012169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798AbZDGTXI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:23:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     nilfs2: cleanup nilfs_clear_inode
has been removed from the -mm tree.  Its filename was
     nilfs2-cleanup-nilfs_clear_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
