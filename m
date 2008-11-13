From: akpm@linux-foundation.org
Subject: + quota-cleanup-use-inode-i_blkbits-to-get-block-bits.patch added to -mm tree
Date: Wed, 12 Nov 2008 16:40:48 -0800
Message-ID: <200811130040.mAD0emKe026587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbYKMAlI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 19:41:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmm@us.ibm.com, hch@lst.de, jack@ucw.cz


The patch titled
     quota cleanup: use inode->i_blkbits to get block bits
has been added to the -mm tree.  Its filename is
     quota-cleanup-use-inode-i_blkbits-to-get-block-bits.patch

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
@@ -404,26 +404,26 @@ static inline void vfs_dq_free_space(str
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
@@ -446,12 +446,12 @@ void vfs_dq_release_reservation(struct i
 
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

quota-add-reservation-support-for-delayed-block-allocation.patch
quota-add-quota-claim-and-release-reserved-quota-blocks-operations.patch
ext4-quota-handling-for-delayed-allocation.patch
quota-cleanup-use-inode-i_blkbits-to-get-block-bits.patch
quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix.patch
quota-cleanup-move-export_symbol-immediatlely-next-to-the-functions-variables.patch

