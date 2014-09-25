From: akpm@linux-foundation.org
Subject: + fat-skip-cluster-allocation-on-fallocated-region.patch added to -mm tree
Date: Thu, 25 Sep 2014 13:26:52 -0700
Message-ID: <54247a8c.RsXECVynp8Z0RT77%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaIYU0x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 16:26:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: skip cluster allocation on fallocated region
has been added to the -mm tree.  Its filename is
     fat-skip-cluster-allocation-on-fallocated-region.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-skip-cluster-allocation-on-fallocated-region.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-skip-cluster-allocation-on-fallocated-region.patch

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

linux-next.patch
fat-add-i_disksize-to-represent-uninitialized-size.patch
fat-add-fat_fallocate-operation.patch
fat-skip-cluster-allocation-on-fallocated-region.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch

