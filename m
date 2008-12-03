From: akpm@linux-foundation.org
Subject: - quota-cleanup-use-inode-i_blkbits-to-get-block-bits.patch removed from -mm tree
Date: Wed, 03 Dec 2008 12:44:42 -0800
Message-ID: <200812032044.mB3Kig12004659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbYLCUpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 15:45:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmm@us.ibm.com, hch@lst.de, jack@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     quota cleanup: use inode->i_blkbits to get block bits
has been removed from the -mm tree.  Its filename was
     quota-cleanup-use-inode-i_blkbits-to-get-block-bits.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota cleanup: use inode->i_blkbits to get block bits
From: Mingming Cao <cmm@us.ibm.com>

Andrew has suggested to use inode->i_blkbits to get the block bits info,
rather than use super block's blockbits. That should be faster and emit
less code.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quotaops.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/quotaops.h~quota-cleanup-use-inode-i_blkbits-to-get-block-bits include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-cleanup-use-inode-i_blkbits-to-get-block-bits
+++ a/include/linux/quotaops.h
@@ -411,26 +411,26 @@ static inline void vfs_dq_free_space(str
 static inline int vfs_dq_prealloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
 	return vfs_dq_prealloc_space_nodirty(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+			nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_prealloc_block(struct inode *inode, qsize_t nr)
 {
 	return vfs_dq_prealloc_space(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+			nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_alloc_block_nodirty(struct inode *inode, qsize_t nr)
 {
  	return vfs_dq_alloc_space_nodirty(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+			nr << inode->i_blkbits);
 }
 
 
 static inline int vfs_dq_alloc_block(struct inode *inode, qsize_t nr)
 {
 	return vfs_dq_alloc_space(inode,
-			nr << inode->i_sb->s_blocksize_bits);
+			nr << inode->i_blkbits);
 }
 
 static inline int vfs_dq_reserve_block(struct inode *inode, qsize_t nr)
@@ -453,12 +453,12 @@ void vfs_dq_release_reservation(struct i
 
 static inline void vfs_dq_free_block_nodirty(struct inode *inode, qsize_t nr)
 {
-	vfs_dq_free_space_nodirty(inode, nr << inode->i_sb->s_blocksize_bits);
+	vfs_dq_free_space_nodirty(inode, nr << inode->i_blkbits);
 }
 
 static inline void vfs_dq_free_block(struct inode *inode, qsize_t nr)
 {
-	vfs_dq_free_space(inode, nr << inode->i_sb->s_blocksize_bits);
+	vfs_dq_free_space(inode, nr << inode->i_blkbits);
 }
 
 /*
_

Patches currently in -mm which might be from cmm@us.ibm.com are

quota-cleanup-use-inode-i_blkbits-to-get-block-bits.patch
quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix.patch

