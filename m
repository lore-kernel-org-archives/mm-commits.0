From: akpm@linux-foundation.org
Subject: + block-fix-memory-leak-in-alloc_disk_node.patch added to -mm tree
Date: Mon, 26 Nov 2007 21:15:07 -0800
Message-ID: <200711270515.lAR5F77l028537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbXK0FP5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 00:15:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmarchan@redhat.com, jens.axboe@oracle.com


The patch titled
     block: fix memory leak in alloc_disk_node()
has been added to the -mm tree.  Its filename is
     block-fix-memory-leak-in-alloc_disk_node.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

block-fix-memory-leak-in-alloc_disk_node.patch
