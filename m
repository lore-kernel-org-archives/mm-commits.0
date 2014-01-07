From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
 removed from -mm tree
Date: Tue, 07 Jan 2014 15:08:02 -0800
Message-ID: <52cc88d2.w7NAJxdb/h5P5hCZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaAGXID (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 18:08:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: [to-be-updated] fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch removed from -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 15:08:02 -0800


The patch titled
     Subject: fat: permit to return phy block number by fibmap in fallocated region
has been removed from the -mm tree.  Its filename was
     fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch

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

 fs/fat/cache.c |   16 ++++++++++++++--
 fs/fat/inode.c |    4 ++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff -puN fs/fat/cache.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/cache.c
--- a/fs/fat/cache.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/cache.c
@@ -312,6 +312,7 @@ int fat_bmap(struct inode *inode, sector
 	const unsigned char blocksize_bits = sb->s_blocksize_bits;
 	sector_t last_block;
 	int cluster, offset;
+	loff_t i_size = i_size_read(inode);
 
 	*phys = 0;
 	*mapped_blocks = 0;
@@ -323,10 +324,20 @@ int fat_bmap(struct inode *inode, sector
 		return 0;
 	}
 
-	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
+	last_block = (i_size + (blocksize - 1)) >> blocksize_bits;
 	if (sector >= last_block) {
-		if (!create)
+		if (!create) {
+			/*
+			 * to map cluster in case of read request
+			 * for a block in fallocated region
+			 */
+			if (MSDOS_I(inode)->i_disksize >
+			    round_up(i_size, sb->s_blocksize)) {
+				goto out_map_cluster;
+			}
+
 			return 0;
+		}
 
 		/*
 		 * Both ->mmu_private and ->i_disksize can access
@@ -339,6 +350,7 @@ int fat_bmap(struct inode *inode, sector
 			return 0;
 	}
 
+out_map_cluster:
 	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
 	offset  = sector & (sbi->sec_per_clus - 1);
 	cluster = fat_bmap_cluster(inode, cluster);
diff -puN fs/fat/inode.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/inode.c
--- a/fs/fat/inode.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/inode.c
@@ -245,9 +245,9 @@ static sector_t _fat_bmap(struct address
 	sector_t blocknr;
 
 	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
-	down_read(&MSDOS_I(mapping->host)->truncate_lock);
+	mutex_lock(&mapping->host->i_mutex);
 	blocknr = generic_block_bmap(mapping, block, fat_get_block);
-	up_read(&MSDOS_I(mapping->host)->truncate_lock);
+	mutex_unlock(&mapping->host->i_mutex);
 
 	return blocknr;
 }
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

linux-next.patch

