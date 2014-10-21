From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fat-skip-cluster-allocation-on-fallocated-region.patch removed from -mm
 tree
Date: Tue, 21 Oct 2014 12:37:22 -0700
Message-ID: <5446b5f2.XYvDt+czP1/VcLxK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbaJUThX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Oct 2014 15:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: skip cluster allocation on fallocated region
has been removed from the -mm tree.  Its filename was
     fat-skip-cluster-allocation-on-fallocated-region.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: skip cluster allocation on fallocated region

Skip new cluster allocation after checking i_disksize in _fat_get_block.
because the blocks are already allocated in fallocated region.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-skip-cluster-allocation-on-fallocated-region fs/fat/inode.c
--- a/fs/fat/inode.c~fat-skip-cluster-allocation-on-fallocated-region
+++ a/fs/fat/inode.c
@@ -120,6 +120,14 @@ static int fat_add_cluster(struct inode
 	return err;
 }
 
+static inline int check_fallocated_region(struct inode *inode, sector_t iblock)
+{
+	struct super_block *sb = inode->i_sb;
+	sector_t last_disk_block = MSDOS_I(inode)->i_disksize >>
+		sb->s_blocksize_bits;
+	return iblock < last_disk_block;
+}
+
 static inline int __fat_get_block(struct inode *inode, sector_t iblock,
 				  unsigned long *max_blocks,
 				  struct buffer_head *bh_result, int create)
@@ -148,7 +156,7 @@ static inline int __fat_get_block(struct
 	}
 
 	offset = (unsigned long)iblock & (sbi->sec_per_clus - 1);
-	if (!offset) {
+	if (!offset && !check_fallocated_region(inode, iblock)) {
 		/* TODO: multiple cluster allocation would be desirable. */
 		err = fat_add_cluster(inode);
 		if (err)
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

origin.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch

