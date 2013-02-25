From: akpm@linux-foundation.org
Subject: [merged] block-use-i_size_write-in-bd_set_size.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:29 -0800
Message-ID: <20130225205629.CE5D45A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:40269 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759857Ab3BYU4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:31 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so347825ghb.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: block: use i_size_write() in bd_set_size()
has been removed from the -mm tree.  Its filename was
     block-use-i_size_write-in-bd_set_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: block: use i_size_write() in bd_set_size()

blkdev_ioctl(GETBLKSIZE) uses i_size_read() to read size of block device. 
If we update block size directly, reader may see intermediate result in
some machines and configurations.  Use i_size_write() instead.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guo Chao <yan@linux.vnet.ibm.com>
Cc: M. Hindess <hindessm@uk.ibm.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~block-use-i_size_write-in-bd_set_size fs/block_dev.c
--- a/fs/block_dev.c~block-use-i_size_write-in-bd_set_size
+++ a/fs/block_dev.c
@@ -1033,7 +1033,9 @@ void bd_set_size(struct block_device *bd
 {
 	unsigned bsize = bdev_logical_block_size(bdev);
 
-	bdev->bd_inode->i_size = size;
+	mutex_lock(&bdev->bd_inode->i_mutex);
+	i_size_write(bdev->bd_inode, size);
+	mutex_unlock(&bdev->bd_inode->i_mutex);
 	while (bsize < PAGE_CACHE_SIZE) {
 		if (size & bsize)
 			break;
_

Patches currently in -mm which might be from yan@linux.vnet.ibm.com are

linux-next.patch

