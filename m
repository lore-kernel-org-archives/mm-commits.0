From: akpm@linux-foundation.org
Subject: - block-fix-memory-leak-in-alloc_disk_node.patch removed from -mm tree
Date: Tue, 27 Nov 2007 18:10:01 -0800
Message-ID: <200711280210.lAS2A1fs010956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755639AbXK1CKu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 21:10:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmarchan@redhat.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: fix memory leak in alloc_disk_node()
has been removed from the -mm tree.  Its filename was
     block-fix-memory-leak-in-alloc_disk_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: block: fix memory leak in alloc_disk_node()
From: Jerome Marchand <jmarchan@redhat.com>

Fix a memory leak in alloc_disk_node().  Don't forget to free 'dkstats'
when the allocation of 'part' failed.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN block/genhd.c~block-fix-memory-leak-in-alloc_disk_node block/genhd.c
--- a/block/genhd.c~block-fix-memory-leak-in-alloc_disk_node
+++ a/block/genhd.c
@@ -713,6 +713,7 @@ struct gendisk *alloc_disk_node(int mino
 			disk->part = kmalloc_node(size,
 				GFP_KERNEL | __GFP_ZERO, node_id);
 			if (!disk->part) {
+				free_disk_stats(disk);
 				kfree(disk);
 				return NULL;
 			}
_

Patches currently in -mm which might be from jmarchan@redhat.com are

origin.patch
