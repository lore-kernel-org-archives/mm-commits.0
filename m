From: akpm@linux-foundation.org
Subject: [failures]
 mm-fix-a-null-dereference-crash-while-accessing-bdev-bd_disk.patch removed
 from -mm tree
Date: Wed, 30 Nov 2016 12:26:17 -0800
Message-ID: <583f35e9.8TRf/93G2PULxuF1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753868AbcK3U0C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 15:26:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fangwei1@huawei.com, hannes@cmpxchg.org, hch@lst.de, jack@suse.cz, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: fix a NULL dereference crash while accessing bdev->bd_disk
has been removed from the -mm tree.  Its filename was
     mm-fix-a-null-dereference-crash-while-accessing-bdev-bd_disk.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Wei Fang <fangwei1@huawei.com>
Subject: mm/filemap.c: fix a NULL dereference crash while accessing bdev->bd_disk

->bd_disk is assigned to NULL in __blkdev_put() when no one is holding the
bdev.  After that, ->bd_inode still can be touched in the
blockdev_superblock->s_inodes list before the final iput.  So
iterate_bdevs() can still get this inode, and start writeback on mapping
dirty pages.  ->bd_disk will be dereferenced in
mapping_cap_writeback_dirty() in this case, and a NULL dereference crash
will be triggered:

Unable to handle kernel NULL pointer dereference at virtual address 00000388
...
[<ffff8000004cb1e4>] blk_get_backing_dev_info+0x1c/0x28
[<ffff8000001c879c>] __filemap_fdatawrite_range+0x54/0x98
[<ffff8000001c8804>] filemap_fdatawrite+0x24/0x2c
[<ffff80000027e7a4>] fdatawrite_one_bdev+0x20/0x28
[<ffff800000288b44>] iterate_bdevs+0xec/0x144
[<ffff80000027eb50>] sys_sync+0x84/0xd0

Since mapping_cap_writeback_dirty() is always return true about block
device inodes, no need to check it if the inode is a block device inode.

Link: http://lkml.kernel.org/r/1480125982-8497-1-git-send-email-fangwei1@huawei.com
Signed-off-by: Wei Fang <fangwei1@huawei.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-fix-a-null-dereference-crash-while-accessing-bdev-bd_disk mm/filemap.c
--- a/mm/filemap.c~mm-fix-a-null-dereference-crash-while-accessing-bdev-bd_disk
+++ a/mm/filemap.c
@@ -383,8 +383,9 @@ int __filemap_fdatawrite_range(struct ad
 		.range_end = end,
 	};
 
-	if (!mapping_cap_writeback_dirty(mapping))
-		return 0;
+	if (!sb_is_blkdev_sb(mapping->host->i_sb))
+		if (!mapping_cap_writeback_dirty(mapping))
+			return 0;
 
 	wbc_attach_fdatawrite_inode(&wbc, mapping->host);
 	ret = do_writepages(mapping, &wbc);
_

Patches currently in -mm which might be from fangwei1@huawei.com are


