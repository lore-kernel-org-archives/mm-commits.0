From: akpm@linux-foundation.org
Subject: [merged] aoe-remove-vestigial-request-queue-allocation.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:45 -0800
Message-ID: <20121218201046.2B5DE20005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:58405 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:48 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so63340fae.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: remove vestigial request queue allocation
has been removed from the -mm tree.  Its filename was
     aoe-remove-vestigial-request-queue-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: remove vestigial request queue allocation

Before the aoe driver was an I/O request handler, it was a
make_request-style block driver.  Even so, there was a problem where sysfs
expected a request queue to exist, so one was provided in commit
7135a71b19be1fa ("aoe: allocate unused request_queue for sysfs").

During the transition to the request-handler style, a patch was merged
that was based on a driver without the noop queue, and the noop queue
remained in place after the patch was merged, even though a new functional
queue was introduced by the patch, allocated through blk_init_queue.

The user impact is a memory leak proportional to the number of AoE targets
discovered.  This patch removes the memory leak and cleans up vestiges of
the old do-nothing queue from the aoeblk_gdalloc function.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoeblk.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN drivers/block/aoe/aoeblk.c~aoe-remove-vestigial-request-queue-allocation drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-remove-vestigial-request-queue-allocation
+++ a/drivers/block/aoe/aoeblk.c
@@ -278,18 +278,12 @@ aoeblk_gdalloc(void *vp)
 	if (q == NULL) {
 		pr_err("aoe: cannot allocate block queue for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
-		mempool_destroy(mp);
-		goto err_disk;
+		goto err_mempool;
 	}
 
-	d->blkq = blk_alloc_queue(GFP_KERNEL);
-	if (!d->blkq)
-		goto err_mempool;
-	d->blkq->backing_dev_info.name = "aoe";
-	if (bdi_init(&d->blkq->backing_dev_info))
-		goto err_blkq;
 	spin_lock_irqsave(&d->lock, flags);
-	blk_queue_max_hw_sectors(d->blkq, BLK_DEF_MAX_SECTORS);
+	blk_queue_max_hw_sectors(q, BLK_DEF_MAX_SECTORS);
+	q->backing_dev_info.name = "aoe";
 	q->backing_dev_info.ra_pages = READ_AHEAD / PAGE_CACHE_SIZE;
 	d->bufpool = mp;
 	d->blkq = gd->queue = q;
@@ -314,11 +308,8 @@ aoeblk_gdalloc(void *vp)
 	aoedisk_add_sysfs(d);
 	return;
 
-err_blkq:
-	blk_cleanup_queue(d->blkq);
-	d->blkq = NULL;
 err_mempool:
-	mempool_destroy(d->bufpool);
+	mempool_destroy(mp);
 err_disk:
 	put_disk(gd);
 err:
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
linux-next.patch

