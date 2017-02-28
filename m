From: akpm@linux-foundation.org
Subject: [merged] nilfs2-use-i_blocksize.patch removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:03 -0800
Message-ID: <58b5e2b7.xC3Hx79lkP6b7FLD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbdB1Uvf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use i_blocksize()
has been removed from the -mm tree.  Its filename was
     nilfs2-use-i_blocksize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: nilfs2: use i_blocksize()

Since i_blocksize() helper has been defined in fs.h, use it instead
of open-coding.

Link: http://lkml.kernel.org/r/1485184655-3895-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |    2 +-
 fs/nilfs2/btree.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/alloc.c~nilfs2-use-i_blocksize fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-use-i_blocksize
+++ a/fs/nilfs2/alloc.c
@@ -34,7 +34,7 @@
 static inline unsigned long
 nilfs_palloc_groups_per_desc_block(const struct inode *inode)
 {
-	return (1UL << inode->i_blkbits) /
+	return i_blocksize(inode) /
 		sizeof(struct nilfs_palloc_group_desc);
 }
 
diff -puN fs/nilfs2/btree.c~nilfs2-use-i_blocksize fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-use-i_blocksize
+++ a/fs/nilfs2/btree.c
@@ -119,7 +119,7 @@ nilfs_btree_node_set_nchildren(struct ni
 
 static int nilfs_btree_node_size(const struct nilfs_bmap *btree)
 {
-	return 1 << btree->b_inode->i_blkbits;
+	return i_blocksize(btree->b_inode);
 }
 
 static int nilfs_btree_nchildren_per_block(const struct nilfs_bmap *btree)
_

Patches currently in -mm which might be from geliangtang@gmail.com are


