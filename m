From: akpm@linux-foundation.org
Subject: + fat-skip-cluster-allocation-on-fallocated-region.patch added to -mm tree
Date: Fri, 19 Dec 2014 15:30:33 -0800
Message-ID: <5494b519.sbKeLDlDBXUYDV0d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaLSXae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 18:30:34 -0500
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

Skip new cluster allocation after checking i_blocks limit in _fat_get_block,
because the blocks are already allocated in fallocated region.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/fat/inode.c~fat-skip-cluster-allocation-on-fallocated-region fs/fat/inode.c
--- a/fs/fat/inode.c~fat-skip-cluster-allocation-on-fallocated-region
+++ a/fs/fat/inode.c
@@ -123,7 +123,7 @@ static inline int __fat_get_block(struct
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	unsigned long mapped_blocks;
-	sector_t phys;
+	sector_t phys, last_block;
 	int err, offset;
 
 	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
@@ -143,8 +143,14 @@ static inline int __fat_get_block(struct
 		return -EIO;
 	}
 
+	last_block = inode->i_blocks >> (sb->s_blocksize_bits - 9);
 	offset = (unsigned long)iblock & (sbi->sec_per_clus - 1);
-	if (!offset) {
+	/*
+	 * allocate a cluster according to the following.
+	 * 1) no more available blocks
+	 * 2) not part of fallocate region
+	 */
+	if (!offset && !(iblock < last_block)) {
 		/* TODO: multiple cluster allocation would be desirable. */
 		err = fat_add_cluster(inode);
 		if (err)
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

origin.patch
fat-add-fat_fallocate-operation.patch
fat-skip-cluster-allocation-on-fallocated-region.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch

