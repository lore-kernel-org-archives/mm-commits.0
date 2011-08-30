From: akpm@linux-foundation.org
Subject: + vfs-cache-request_queue-in-struct-block_device.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:54:12 -0700
Message-ID: <201108302354.p7UNsCPb026584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014Ab1H3Xyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com


The patch titled
     vfs: cache request_queue in struct block_device
has been added to the -mm tree.  Its filename is
     vfs-cache-request_queue-in-struct-block_device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: cache request_queue in struct block_device
From: Andi Kleen <ak@linux.intel.com>

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
@@ -1115,6 +1115,7 @@ static int __blkdev_get(struct block_dev
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
+		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
 		if (!partno) {
 			struct backing_dev_info *bdi;
@@ -1135,6 +1136,7 @@ static int __blkdev_get(struct block_dev
 					disk_put_part(bdev->bd_part);
 					bdev->bd_part = NULL;
 					bdev->bd_disk = NULL;
+					bdev->bd_queue = NULL;
 					mutex_unlock(&bdev->bd_mutex);
 					disk_unblock_events(disk);
 					module_put(disk->fops->owner);
@@ -1208,6 +1210,7 @@ static int __blkdev_get(struct block_dev
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
@@ -657,6 +657,7 @@ struct address_space {
 	 * must be enforced here for CRIS, to let the least significant bit
 	 * of struct page's "mapping" pointer be used for PAGE_MAPPING_ANON.
 	 */
+struct request_queue;
 
 struct block_device {
 	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
@@ -679,6 +680,7 @@ struct block_device {
 	unsigned		bd_part_count;
 	int			bd_invalidated;
 	struct gendisk *	bd_disk;
+	struct request_queue *  bd_queue;
 	struct list_head	bd_list;
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
_

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-fix-a-wrong-comment.patch
dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes.patch
dio-use-a-slab-cache-for-struct-dio.patch
dio-separate-map_bh-from-dio-v2.patch
dio-inline-the-complete-submission-path-v2.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch
dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch

