From: akpm@linux-foundation.org
Subject: + fat-zero-out-seek-range-on-_fat_get_block.patch added to -mm
 tree
Date: Mon, 18 Nov 2013 15:22:42 -0800
Message-ID: <528aa142.5ZmCBdN3QfaddZSv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3KRXWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 18:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: + fat-zero-out-seek-range-on-_fat_get_block.patch added to -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 15:22:42 -0800


The patch titled
     Subject: fat: zero out seek range on _fat_get_block
has been added to the -mm tree.  Its filename is
     fat-zero-out-seek-range-on-_fat_get_block.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-zero-out-seek-range-on-_fat_get_block.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-zero-out-seek-range-on-_fat_get_block.patch

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
Subject: fat: zero out seek range on _fat_get_block

For normal buffered write operations, normally if we try to write to an
offset > than file size, it does a cont_expand_zero till that offset. 
Now, in case of fallocated regions, since the blocks are already
allocated.  So, make it zero out that buffers for those blocks till the
seek'ed offset.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |    3 ++-
 fs/fat/inode.c |   15 +++++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff -puN fs/fat/cache.c~fat-zero-out-seek-range-on-_fat_get_block fs/fat/cache.c
--- a/fs/fat/cache.c~fat-zero-out-seek-range-on-_fat_get_block
+++ a/fs/fat/cache.c
@@ -334,7 +334,8 @@ int fat_bmap(struct inode *inode, sector
 		 */
 		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
 			>> blocksize_bits;
-		if (sector >= last_block)
+		if (sector >= last_block &&
+		    MSDOS_I(inode)->mmu_private == MSDOS_I(inode)->i_disksize)
 			return 0;
 	}
 
diff -puN fs/fat/inode.c~fat-zero-out-seek-range-on-_fat_get_block fs/fat/inode.c
--- a/fs/fat/inode.c~fat-zero-out-seek-range-on-_fat_get_block
+++ a/fs/fat/inode.c
@@ -61,15 +61,26 @@ static inline int __fat_get_block(struct
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	unsigned long mapped_blocks;
-	sector_t phys;
+	sector_t phys, last_block, disk_block;
 	int err, offset;
+	const unsigned long blocksize = sb->s_blocksize;
+	const unsigned char blocksize_bits = sb->s_blocksize_bits;
 
 	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
 	if (err)
 		return err;
 	if (phys) {
-		map_bh(bh_result, sb, phys);
 		*max_blocks = min(mapped_blocks, *max_blocks);
+		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
+			>> blocksize_bits;
+		disk_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
+			>> blocksize_bits;
+		if (iblock >= last_block && iblock <= disk_block) {
+			MSDOS_I(inode)->mmu_private +=
+				*max_blocks << blocksize_bits;
+			set_buffer_new(bh_result);
+		}
+		map_bh(bh_result, sb, phys);
 		return 0;
 	}
 	if (!create)
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-add-i_disksize-to-represent-uninitialized-size.patch
fat-add-fat_fallocate-operation.patch
fat-zero-out-seek-range-on-_fat_get_block.patch
fat-fallback-to-buffered-write-in-case-of-fallocatded-region-on-direct-io.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch

