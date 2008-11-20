From: akpm@linux-foundation.org
Subject: + gendisk-disk-node_id-is-used-uninitialised.patch added to -mm tree
Date: Thu, 20 Nov 2008 13:52:26 -0800
Message-ID: <200811202152.mAKLqQHb011151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561AbYKTVwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 16:52:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, jens.axboe@oracle.com, viro@zeniv.linux.org.uk


The patch titled
     gendisk: disk->node_id is used uninitialised
has been added to the -mm tree.  Its filename is
     gendisk-disk-node_id-is-used-uninitialised.patch

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

gendisk-disk-node_id-is-used-uninitialised.patch
linux-next.patch
block-remove-kblockd_flush_work.patch
fs-block_devc-__read_mostly-improvement-and-sb_is_blkdev_sb-utilization.patch

