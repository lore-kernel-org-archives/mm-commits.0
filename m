From: akpm@linux-foundation.org
Subject: +
 fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
 added to -mm tree
Date: Thu, 25 Sep 2014 13:26:53 -0700
Message-ID: <54247a8d.yV8hvimk3O+N8tuM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaIYU0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 16:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: permit to return phy block number by fibmap in fallocated region
has been added to the -mm tree.  Its filename is
     fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: permit to return phy block number by fibmap in fallocated region

Make the fibmap call the return the proper physical block number for any
offset request in the fallocated range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |   40 +++++++++++++++++++++++++++-------------
 fs/fat/fat.h   |    3 +++
 fs/fat/inode.c |   35 ++++++++++++++++++++++++++++++++++-
 3 files changed, 64 insertions(+), 14 deletions(-)

diff -puN fs/fat/cache.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/cache.c
--- a/fs/fat/cache.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/cache.c
@@ -303,6 +303,31 @@ static int fat_bmap_cluster(struct inode
 	return dclus;
 }
 
+int fat_get_mapped_cluster(struct inode *inode, sector_t sector,
+			   sector_t last_block,
+			   unsigned long *mapped_blocks, sector_t *bmap)
+{
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int cluster, offset;
+
+	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
+	offset  = sector & (sbi->sec_per_clus - 1);
+	cluster = fat_bmap_cluster(inode, cluster);
+
+	if (cluster < 0)
+		return cluster;
+
+	else if (cluster) {
+		*bmap = fat_clus_to_blknr(sbi, cluster) + offset;
+		*mapped_blocks = sbi->sec_per_clus - offset;
+		if (*mapped_blocks > last_block - sector)
+			*mapped_blocks = last_block - sector;
+	}
+
+	return 0;
+}
+
 int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 	     unsigned long *mapped_blocks, int create)
 {
@@ -311,7 +336,6 @@ int fat_bmap(struct inode *inode, sector
 	const unsigned long blocksize = sb->s_blocksize;
 	const unsigned char blocksize_bits = sb->s_blocksize_bits;
 	sector_t last_block;
-	int cluster, offset;
 
 	*phys = 0;
 	*mapped_blocks = 0;
@@ -338,16 +362,6 @@ int fat_bmap(struct inode *inode, sector
 			return 0;
 	}
 
-	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
-	offset  = sector & (sbi->sec_per_clus - 1);
-	cluster = fat_bmap_cluster(inode, cluster);
-	if (cluster < 0)
-		return cluster;
-	else if (cluster) {
-		*phys = fat_clus_to_blknr(sbi, cluster) + offset;
-		*mapped_blocks = sbi->sec_per_clus - offset;
-		if (*mapped_blocks > last_block - sector)
-			*mapped_blocks = last_block - sector;
-	}
-	return 0;
+	return fat_get_mapped_cluster(inode, sector, last_block, mapped_blocks,
+				      phys);
 }
diff -puN fs/fat/fat.h~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/fat.h
--- a/fs/fat/fat.h~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/fat.h
@@ -289,6 +289,9 @@ static inline void fatwchar_to16(__u8 *d
 extern void fat_cache_inval_inode(struct inode *inode);
 extern int fat_get_cluster(struct inode *inode, int cluster,
 			   int *fclus, int *dclus);
+extern int fat_get_mapped_cluster(struct inode *inode, sector_t sector,
+				  sector_t last_block,
+				  unsigned long *mapped_blocks, sector_t *bmap);
 extern int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 		    unsigned long *mapped_blocks, int create);
 
diff -puN fs/fat/inode.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/inode.c
--- a/fs/fat/inode.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/inode.c
@@ -294,13 +294,46 @@ static ssize_t fat_direct_IO(int rw, str
 	return ret;
 }
 
+static int fat_get_block_bmap(struct inode *inode, sector_t iblock,
+		struct buffer_head *bh_result, int create)
+{
+	struct super_block *sb = inode->i_sb;
+	unsigned long max_blocks = bh_result->b_size >> inode->i_blkbits;
+	int err;
+	sector_t bmap, last_block;
+	unsigned long mapped_blocks;
+	const unsigned long blocksize = sb->s_blocksize;
+	const unsigned char blocksize_bits = sb->s_blocksize_bits;
+
+	BUG_ON(create != 0);
+
+	last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
+		>> blocksize_bits;
+
+	if (iblock >= last_block)
+		return 0;
+
+	err = fat_get_mapped_cluster(inode, iblock, last_block, &mapped_blocks,
+		&bmap);
+	if (err)
+		return err;
+
+	if (bmap) {
+		map_bh(bh_result, sb, bmap);
+		max_blocks = min(mapped_blocks, max_blocks);
+	}
+
+	bh_result->b_size = max_blocks << sb->s_blocksize_bits;
+	return 0;
+}
+
 static sector_t _fat_bmap(struct address_space *mapping, sector_t block)
 {
 	sector_t blocknr;
 
 	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
 	down_read(&MSDOS_I(mapping->host)->truncate_lock);
-	blocknr = generic_block_bmap(mapping, block, fat_get_block);
+	blocknr = generic_block_bmap(mapping, block, fat_get_block_bmap);
 	up_read(&MSDOS_I(mapping->host)->truncate_lock);
 
 	return blocknr;
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

linux-next.patch
fat-add-i_disksize-to-represent-uninitialized-size.patch
fat-add-fat_fallocate-operation.patch
fat-skip-cluster-allocation-on-fallocated-region.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch

