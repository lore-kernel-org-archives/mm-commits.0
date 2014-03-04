From: akpm@linux-foundation.org
Subject: + fat-zero-out-seek-range-on-_fat_get_block-v4.patch added to -mm tree
Date: Tue, 04 Mar 2014 13:20:02 -0800
Message-ID: <53164382.KUxO8wpdf9pNLSl3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334AbaCDVUD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 16:20:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: + fat-zero-out-seek-range-on-_fat_get_block-v4.patch added to -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 13:20:02 -0800


The patch titled
     Subject: fat: zero out seek range on _fat_get_block
has been added to the -mm tree.  Its filename is
     fat-zero-out-seek-range-on-_fat_get_block-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-zero-out-seek-range-on-_fat_get_block-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-zero-out-seek-range-on-_fat_get_block-v4.patch

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

 fs/fat/inode.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-zero-out-seek-range-on-_fat_get_block-v4 fs/fat/inode.c
--- a/fs/fat/inode.c~fat-zero-out-seek-range-on-_fat_get_block-v4
+++ a/fs/fat/inode.c
@@ -54,6 +54,25 @@ static int fat_add_cluster(struct inode
 	return err;
 }
 
+static void check_fallocated_region(struct inode *inode, sector_t iblock,
+		unsigned long *max_blocks, struct buffer_head *bh_result)
+{
+	struct super_block *sb = inode->i_sb;
+	sector_t last_block, disk_block;
+	const unsigned long blocksize = sb->s_blocksize;
+	const unsigned char blocksize_bits = sb->s_blocksize_bits;
+
+	last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
+		>> blocksize_bits;
+	disk_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
+		>> blocksize_bits;
+	if (iblock >= last_block && iblock <= disk_block) {
+		MSDOS_I(inode)->mmu_private += *max_blocks << blocksize_bits;
+		set_buffer_new(bh_result);
+	}
+
+}
+
 static inline int __fat_get_block(struct inode *inode, sector_t iblock,
 				  unsigned long *max_blocks,
 				  struct buffer_head *bh_result, int create)
@@ -68,8 +87,11 @@ static inline int __fat_get_block(struct
 	if (err)
 		return err;
 	if (phys) {
-		map_bh(bh_result, sb, phys);
 		*max_blocks = min(mapped_blocks, *max_blocks);
+		if (create)
+			check_fallocated_region(inode, iblock, max_blocks,
+				bh_result);
+		map_bh(bh_result, sb, phys);
 		return 0;
 	}
 	if (!create)
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-add-i_disksize-to-represent-uninitialized-size-v4.patch
fat-add-fat_fallocate-operation-v4.patch
fat-zero-out-seek-range-on-_fat_get_block-v4.patch
fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io-v4.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region-v4.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch
linux-next.patch

