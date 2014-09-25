From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4.patch removed from -mm tree
Date: Thu, 25 Sep 2014 12:56:04 -0700
Message-ID: <54247354.t4sKXUdFXPJ0UADB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaIYT4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 15:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: permit to return phy block number by fibmap in fallocated region
has been removed from the -mm tree.  Its filename was
     fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4.patch

This patch was dropped because an updated version will be merged

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

 fs/fat/cache.c |   64 +++++++++++++++++++++++++++++++++++++----------
 fs/fat/fat.h   |    3 ++
 fs/fat/inode.c |   25 +++++++++++++++++-
 3 files changed, 78 insertions(+), 14 deletions(-)

diff -puN fs/fat/cache.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4 fs/fat/cache.c
--- a/fs/fat/cache.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4
+++ a/fs/fat/cache.c
@@ -303,6 +303,31 @@ static int fat_bmap_cluster(struct inode
 	return dclus;
 }
 
+static int fat_get_mapped_cluster(struct inode *inode, sector_t sector,
+				  sector_t last_block,
+				  unsigned long *mapped_blocks, sector_t *bmap)
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
@@ -338,16 +362,30 @@ int fat_bmap(struct inode *inode, sector
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
+}
+
+int fat_bmap2(struct inode *inode, sector_t sector,
+	      unsigned long *mapped_blocks, struct buffer_head *bh_result,
+	      int create, sector_t *bmap)
+{
+	struct super_block *sb = inode->i_sb;
+	sector_t last_block;
+	const unsigned long blocksize = sb->s_blocksize;
+	const unsigned char blocksize_bits = sb->s_blocksize_bits;
+
+	BUG_ON(create != 0);
+
+	*bmap = 0;
+	*mapped_blocks = 0;
+
+	last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
+		>> blocksize_bits;
+
+	if (sector >= last_block)
+		return 0;
+
+	return fat_get_mapped_cluster(inode, sector, last_block, mapped_blocks,
+				      bmap);
 }
diff -puN fs/fat/fat.h~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4 fs/fat/fat.h
--- a/fs/fat/fat.h~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4
+++ a/fs/fat/fat.h
@@ -291,6 +291,9 @@ extern int fat_get_cluster(struct inode
 			   int *fclus, int *dclus);
 extern int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
 		    unsigned long *mapped_blocks, int create);
+extern int fat_bmap2(struct inode *inode, sector_t sector,
+		     unsigned long *mapped_blocks,
+		     struct buffer_head *bh_result, int create, sector_t *bmap);
 
 /* fat/dir.c */
 extern const struct file_operations fat_dir_operations;
diff -puN fs/fat/inode.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4 fs/fat/inode.c
--- a/fs/fat/inode.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4
+++ a/fs/fat/inode.c
@@ -312,13 +312,36 @@ static ssize_t fat_direct_IO(int rw, str
 	return ret;
 }
 
+static int fat_get_block_bmap(struct inode *inode, sector_t iblock,
+		struct buffer_head *bh_result, int create)
+{
+	struct super_block *sb = inode->i_sb;
+	unsigned long max_blocks = bh_result->b_size >> inode->i_blkbits;
+	int err;
+	sector_t bmap;
+	unsigned long mapped_blocks;
+
+	err = fat_bmap2(inode, iblock, &mapped_blocks, bh_result, create,
+			&bmap);
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
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate-v4.patch

