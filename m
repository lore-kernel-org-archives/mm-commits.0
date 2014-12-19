From: akpm@linux-foundation.org
Subject: +
 fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
 added to -mm tree
Date: Fri, 19 Dec 2014 15:30:35 -0800
Message-ID: <5494b51b.H8kQ1/jGzdKyWa3i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaLSXag (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 18:30:36 -0500
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

Make the fibmap call return the proper physical block number for any
offset request in the fallocated range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |   79 ++++++++++++++++++++++++++++++++---------------
 fs/fat/dir.c   |    2 -
 fs/fat/fat.h   |    5 ++
 fs/fat/inode.c |   31 ++++++++++++++++--
 4 files changed, 87 insertions(+), 30 deletions(-)

diff -puN fs/fat/cache.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/cache.c
--- a/fs/fat/cache.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/cache.c
@@ -303,15 +303,59 @@ static int fat_bmap_cluster(struct inode
 	return dclus;
 }
 
-int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
-	     unsigned long *mapped_blocks, int create)
+int fat_get_mapped_cluster(struct inode *inode, sector_t sector,
+			   sector_t last_block,
+			   unsigned long *mapped_blocks, sector_t *bmap)
 {
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int cluster, offset;
+
+	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
+	offset  = sector & (sbi->sec_per_clus - 1);
+	cluster = fat_bmap_cluster(inode, cluster);
+	if (cluster < 0)
+		return cluster;
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
+static int is_exceed_eof(struct inode *inode, sector_t sector,
+			 sector_t *last_block, int create)
+{
+	struct super_block *sb = inode->i_sb;
 	const unsigned long blocksize = sb->s_blocksize;
 	const unsigned char blocksize_bits = sb->s_blocksize_bits;
+
+	*last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
+	if (sector >= *last_block) {
+		if (!create)
+			return 1;
+
+		/*
+		 * ->mmu_private can access on only allocation path.
+		 * (caller must hold ->i_mutex)
+		 */
+		*last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
+			>> blocksize_bits;
+		if (sector >= *last_block)
+			return 1;
+	}
+
+	return 0;
+}
+
+int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
+	     unsigned long *mapped_blocks, int create, bool from_bmap)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	sector_t last_block;
-	int cluster, offset;
 
 	*phys = 0;
 	*mapped_blocks = 0;
@@ -323,31 +367,16 @@ int fat_bmap(struct inode *inode, sector
 		return 0;
 	}
 
-	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
-	if (sector >= last_block) {
-		if (!create)
+	if (!from_bmap) {
+		if (is_exceed_eof(inode, sector, &last_block, create))
 			return 0;
-
-		/*
-		 * ->mmu_private can access on only allocation path.
-		 * (caller must hold ->i_mutex)
-		 */
-		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
-			>> blocksize_bits;
+	} else {
+		last_block = inode->i_blocks >>
+				(inode->i_sb->s_blocksize_bits - 9);
 		if (sector >= last_block)
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
diff -puN fs/fat/dir.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/dir.c
--- a/fs/fat/dir.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/dir.c
@@ -95,7 +95,7 @@ next:
 
 	*bh = NULL;
 	iblock = *pos >> sb->s_blocksize_bits;
-	err = fat_bmap(dir, iblock, &phys, &mapped_blocks, 0);
+	err = fat_bmap(dir, iblock, &phys, &mapped_blocks, 0, false);
 	if (err || !phys)
 		return -1;	/* beyond EOF or error */
 
diff -puN fs/fat/fat.h~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/fat.h
--- a/fs/fat/fat.h~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/fat.h
@@ -288,8 +288,11 @@ static inline void fatwchar_to16(__u8 *d
 extern void fat_cache_inval_inode(struct inode *inode);
 extern int fat_get_cluster(struct inode *inode, int cluster,
 			   int *fclus, int *dclus);
+extern int fat_get_mapped_cluster(struct inode *inode, sector_t sector,
+				  sector_t last_block,
+				  unsigned long *mapped_blocks, sector_t *bmap);
 extern int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
-		    unsigned long *mapped_blocks, int create);
+		    unsigned long *mapped_blocks, int create, bool from_bmap);
 
 /* fat/dir.c */
 extern const struct file_operations fat_dir_operations;
diff -puN fs/fat/inode.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/inode.c
--- a/fs/fat/inode.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/inode.c
@@ -126,7 +126,7 @@ static inline int __fat_get_block(struct
 	sector_t phys, last_block;
 	int err, offset;
 
-	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
+	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create, false);
 	if (err)
 		return err;
 	if (phys) {
@@ -162,7 +162,7 @@ static inline int __fat_get_block(struct
 	*max_blocks = min(mapped_blocks, *max_blocks);
 	MSDOS_I(inode)->mmu_private += *max_blocks << sb->s_blocksize_bits;
 
-	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
+	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create, false);
 	if (err)
 		return err;
 
@@ -288,13 +288,38 @@ static ssize_t fat_direct_IO(int rw, str
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
+	BUG_ON(create != 0);
+
+	err = fat_bmap(inode, iblock, &bmap, &mapped_blocks, create, true);
+	if (err)
+		return err;
+
+	if (bmap) {
+		map_bh(bh_result, sb, bmap);
+		max_blocks = min(mapped_blocks, max_blocks);
+	}
+
+	bh_result->b_size = max_blocks << sb->s_blocksize_bits;
+
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

origin.patch
fat-add-fat_fallocate-operation.patch
fat-skip-cluster-allocation-on-fallocated-region.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch

