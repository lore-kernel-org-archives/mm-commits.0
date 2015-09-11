From: akpm@linux-foundation.org
Subject: [merged] make-affs-root-lookup-from-blkdev-logical-size.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:13:33 -0700
Message-ID: <55f319cd.xetIP0T+7PEqmINw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbbIKSNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pranjas@gmail.com, markk@clara.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: make root lookup from blkdev logical size
has been removed from the -mm tree.  Its filename was
     make-affs-root-lookup-from-blkdev-logical-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Pranay Kr. Srivastava" <pranjas@gmail.com>
Subject: fs/affs: make root lookup from blkdev logical size

This patch resolves https://bugzilla.kernel.org/show_bug.cgi?id=16531.

When logical blkdev size > 512 then sector numbers become larger than the
device can support.

Make affs start lookup based on the device's logical sector size instead
of 512.

Reported-by: Mark <markk@clara.co.uk>
Suggested-by: Mark <markk@clara.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/affs/super.c~make-affs-root-lookup-from-blkdev-logical-size fs/affs/super.c
--- a/fs/affs/super.c~make-affs-root-lookup-from-blkdev-logical-size
+++ a/fs/affs/super.c
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/writeback.h>
+#include <linux/blkdev.h>
 #include "affs.h"
 
 static int affs_statfs(struct dentry *dentry, struct kstatfs *buf);
@@ -352,18 +353,19 @@ static int affs_fill_super(struct super_
 	 * blocks, we will have to change it.
 	 */
 
-	size = sb->s_bdev->bd_inode->i_size >> 9;
+	size = i_size_read(sb->s_bdev->bd_inode) >> 9;
 	pr_debug("initial blocksize=%d, #blocks=%d\n", 512, size);
 
 	affs_set_blocksize(sb, PAGE_SIZE);
 	/* Try to find root block. Its location depends on the block size. */
 
-	i = 512;
-	j = 4096;
+	i = bdev_logical_block_size(sb->s_bdev);
+	j = PAGE_SIZE;
 	if (blocksize > 0) {
 		i = j = blocksize;
 		size = size / (blocksize / 512);
 	}
+
 	for (blocksize = i; blocksize <= j; blocksize <<= 1, size >>= 1) {
 		sbi->s_root_block = root_block;
 		if (root_block < 0)
_

Patches currently in -mm which might be from pranjas@gmail.com are


