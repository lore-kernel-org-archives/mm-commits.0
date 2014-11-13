From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fat-skip-cluster-allocation-on-fallocated-region.patch removed from -mm
 tree
Date: Thu, 13 Nov 2014 13:19:06 -0800
Message-ID: <5465204a.+s7CaV4Rizb5Gjo0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934175AbaKMVTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Nov 2014 16:19:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: skip cluster allocation on fallocated region
has been removed from the -mm tree.  Its filename was
     fat-skip-cluster-allocation-on-fallocated-region.patch

This patch was dropped because an updated version will be merged

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

 fs/fat/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-skip-cluster-allocation-on-fallocated-region fs/fat/inode.c
--- a/fs/fat/inode.c~fat-skip-cluster-allocation-on-fallocated-region
+++ a/fs/fat/inode.c
@@ -144,7 +144,12 @@ static inline int __fat_get_block(struct
 	}
 
 	offset = (unsigned long)iblock & (sbi->sec_per_clus - 1);
-	if (!offset) {
+	/*
+	 * allocate a cluster according to the following.
+	 * 1) no more available blocks
+	 * 2) not part of fallocate region
+	 */
+	if (!offset && !(iblock < (sector_t)inode->i_blocks)) {
 		/* TODO: multiple cluster allocation would be desirable. */
 		err = fat_add_cluster(inode);
 		if (err)
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch
fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch
fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2.patch

