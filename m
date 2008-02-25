From: akpm@linux-foundation.org
Subject: - nbd-make-nbd-default-to-deadline-i-o-scheduler.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:45:08 -0800
Message-ID: <200802250045.m1P0j88U006231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100AbYBYAtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:49:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.clements@steeleye.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     NBD: make nbd default to deadline I/O scheduler
has been removed from the -mm tree.  Its filename was
     nbd-make-nbd-default-to-deadline-i-o-scheduler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NBD: make nbd default to deadline I/O scheduler
From: Paul Clements <paul.clements@steeleye.com>

NBD doesn't work well with CFQ (or AS) schedulers, so let's default to
something else.

The two problems I have experienced with nbd and cfq are:

1) nbd hangs with cfq on RHEL 5 (2.6.18) -- this may well have been
   fixed

   There's a similar debian bug that has been filed as well:

   http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=447638

   There have been posts to nbd-general mailing list about problems with
   cfq and nbd also.

2) nbd performs about 10% better (the last time I tested) with deadline
   vs.  cfq (the overhead of cfq doesn't provide much advantage to nbd [not
   being a real disk], and you end up going through the I/O scheduler on
   the nbd server anyway, so it makes sense that deadline is better with
   nbd)

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/block/nbd.c~nbd-make-nbd-default-to-deadline-i-o-scheduler drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-make-nbd-default-to-deadline-i-o-scheduler
+++ a/drivers/block/nbd.c
@@ -655,6 +655,7 @@ static int __init nbd_init(void)
 
 	for (i = 0; i < nbds_max; i++) {
 		struct gendisk *disk = alloc_disk(1);
+		elevator_t *old_e;
 		if (!disk)
 			goto out;
 		nbd_dev[i].disk = disk;
@@ -668,6 +669,11 @@ static int __init nbd_init(void)
 			put_disk(disk);
 			goto out;
 		}
+		old_e = disk->queue->elevator;
+		if (elevator_init(disk->queue, "deadline") == 0 ||
+			elevator_init(disk->queue, "noop") == 0) {
+				elevator_exit(old_e);
+		}
 	}
 
 	if (register_blkdev(NBD_MAJOR, "nbd")) {
_

Patches currently in -mm which might be from paul.clements@steeleye.com are
