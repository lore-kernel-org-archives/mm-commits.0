From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
 removed from -mm tree
Date: Tue, 04 Mar 2014 13:15:27 -0800
Message-ID: <5316426f.vGSxE4oKsyAG5oIX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbaCDVP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 16:15:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: [to-be-updated] fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch removed from -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 13:15:27 -0800


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

 fs/fat/cache.c |   13 ++++++++++---
 fs/fat/fat.h   |    3 +++
 fs/fat/inode.c |    3 +++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff -puN fs/fat/cache.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/cache.c
--- a/fs/fat/cache.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/cache.c
@@ -325,19 +325,26 @@ int fat_bmap(struct inode *inode, sector
 
 	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
 	if (sector >= last_block) {
-		if (!create)
-			return 0;
-
 		/*
 		 * Both ->mmu_private and ->i_disksize can access
 		 * on only allocation path. (caller must hold ->i_mutex)
 		 */
 		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
 			>> blocksize_bits;
+		if (!create) {
+			/* Map a block in fallocated region */
+			if (atomic_read(&MSDOS_I(inode)->beyond_isize))
+				if (sector < last_block)
+					goto out_map_cluster;
+
+			return 0;
+		}
+
 		if (sector >= last_block)
 			return 0;
 	}
 
+out_map_cluster:
 	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
 	offset  = sector & (sbi->sec_per_clus - 1);
 	cluster = fat_bmap_cluster(inode, cluster);
diff -puN fs/fat/fat.h~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/fat.h
--- a/fs/fat/fat.h~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/fat.h
@@ -129,6 +129,9 @@ struct msdos_inode_info {
 	struct hlist_node i_dir_hash;	/* hash by i_logstart */
 	struct rw_semaphore truncate_lock; /* protect bmap against truncate */
 	struct inode vfs_inode;
+
+	/* for getting block number beyond file size in case of fallocate */
+	atomic_t beyond_isize;
 };
 
 struct fat_slot_info {
diff -puN fs/fat/inode.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region fs/fat/inode.c
--- a/fs/fat/inode.c~fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region
+++ a/fs/fat/inode.c
@@ -256,7 +256,10 @@ static sector_t _fat_bmap(struct address
 
 	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
 	down_read(&MSDOS_I(mapping->host)->truncate_lock);
+	/* To get block number beyond file size in fallocated region */
+	atomic_set(&MSDOS_I(mapping->host)->beyond_isize, 1);
 	blocknr = generic_block_bmap(mapping, block, fat_get_block);
+	atomic_set(&MSDOS_I(mapping->host)->beyond_isize, 0);
 	up_read(&MSDOS_I(mapping->host)->truncate_lock);
 
 	return blocknr;
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-update-the-limitation-for-fat-fallocate.patch
linux-next.patch

