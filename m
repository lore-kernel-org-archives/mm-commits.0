From: akpm@linux-foundation.org
Subject: [merged] vfs-cache-request_queue-in-struct-block_device.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:53 -0800
Message-ID: <20120113203654.1B78D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:56 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: cache request_queue in struct block_device
has been removed from the -mm tree.  Its filename was
     vfs-cache-request_queue-in-struct-block_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: vfs: cache request_queue in struct block_device

This makes it possible to get from the inode to the request_queue with one
less cache miss.  Used in followon optimization.

The livetime of the pointer is the same as the gendisk.

This assumes that the queue will always stay the same in the gendisk while
it's visible to block_devices.  I think that's safe correct?

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c     |    3 +++
 include/linux/fs.h |    2 ++
 2 files changed, 5 insertions(+)

diff -puN fs/block_dev.c~vfs-cache-request_queue-in-struct-block_device fs/block_dev.c
--- a/fs/block_dev.c~vfs-cache-request_queue-in-struct-block_device
+++ a/fs/block_dev.c
@@ -1139,6 +1139,7 @@ static int __blkdev_get(struct block_dev
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
+		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
 		if (!partno) {
 			struct backing_dev_info *bdi;
@@ -1159,6 +1160,7 @@ static int __blkdev_get(struct block_dev
 					disk_put_part(bdev->bd_part);
 					bdev->bd_part = NULL;
 					bdev->bd_disk = NULL;
+					bdev->bd_queue = NULL;
 					mutex_unlock(&bdev->bd_mutex);
 					disk_unblock_events(disk);
 					put_disk(disk);
@@ -1232,6 +1234,7 @@ static int __blkdev_get(struct block_dev
 	disk_put_part(bdev->bd_part);
 	bdev->bd_disk = NULL;
 	bdev->bd_part = NULL;
+	bdev->bd_queue = NULL;
 	bdev_inode_switch_bdi(bdev->bd_inode, &default_backing_dev_info);
 	if (bdev != bdev->bd_contains)
 		__blkdev_put(bdev->bd_contains, mode, 1);
diff -puN include/linux/fs.h~vfs-cache-request_queue-in-struct-block_device include/linux/fs.h
--- a/include/linux/fs.h~vfs-cache-request_queue-in-struct-block_device
+++ a/include/linux/fs.h
@@ -660,6 +660,7 @@ struct address_space {
 	 * must be enforced here for CRIS, to let the least significant bit
 	 * of struct page's "mapping" pointer be used for PAGE_MAPPING_ANON.
 	 */
+struct request_queue;
 
 struct block_device {
 	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
@@ -682,6 +683,7 @@ struct block_device {
 	unsigned		bd_part_count;
 	int			bd_invalidated;
 	struct gendisk *	bd_disk;
+	struct request_queue *  bd_queue;
 	struct list_head	bd_list;
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch

