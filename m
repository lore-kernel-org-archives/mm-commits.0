From: akpm@linux-foundation.org
Subject: - gendisk-disk-node_id-is-used-uninitialised.patch removed from -mm tree
Date: Mon, 24 Nov 2008 11:29:50 -0800
Message-ID: <200811241929.mAOJToGY027933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbYKXTf5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 14:35:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     gendisk: disk->node_id is used uninitialised
has been removed from the -mm tree.  Its filename was
     gendisk-disk-node_id-is-used-uninitialised.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gendisk: disk->node_id is used uninitialised
From: Cheng Renquan <crquan@gmail.com>

disk->node_id will be used when allocating in disk_expand_part_tbl(), so
we should set it beforehand.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/genhd.c~gendisk-disk-node_id-is-used-uninitialised block/genhd.c
--- a/block/genhd.c~gendisk-disk-node_id-is-used-uninitialised
+++ a/block/genhd.c
@@ -1102,6 +1102,7 @@ struct gendisk *alloc_disk_node(int mino
 			kfree(disk);
 			return NULL;
 		}
+		disk->node_id = node_id;
 		if (disk_expand_part_tbl(disk, 0)) {
 			free_part_stats(&disk->part0);
 			kfree(disk);
@@ -1116,7 +1117,6 @@ struct gendisk *alloc_disk_node(int mino
 		device_initialize(disk_to_dev(disk));
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
-		disk->node_id = node_id;
 	}
 	return disk;
 }
_

Patches currently in -mm which might be from crquan@gmail.com are

linux-next.patch
block-remove-kblockd_flush_work.patch
fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization.patch

