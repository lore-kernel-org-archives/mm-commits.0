From: akpm@linux-foundation.org
Subject: +
 fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
 added to -mm tree
Date: Thu, 10 Oct 2013 15:02:40 -0700
Message-ID: <52572400.MahB/p5UBuyD8cK0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab3JJWCl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 18:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: + fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch added to -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 15:02:40 -0700


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
 		 * ->i_disksize can access on only allocation path.
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

fat-add-i_disksize-to-represent-uninitialized-size.patch
fat-add-fat_fallocate-operation.patch
fat-zero-out-seek-range-on-_fat_get_block.patch
fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch

