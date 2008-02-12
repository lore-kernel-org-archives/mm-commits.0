From: akpm@linux-foundation.org
Subject: + nbd-make-nbd-default-to-deadline-i-o-scheduler.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:16:06 -0800
Message-ID: <200802122316.m1CNG6b8027869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943AbYBLXQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:16:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paul.clements@steeleye.com, jens.axboe@oracle.com


The patch titled
     NBD: make nbd default to deadline I/O scheduler
has been added to the -mm tree.  Its filename is
     nbd-make-nbd-default-to-deadline-i-o-scheduler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
nbd-make-nbd-default-to-deadline-i-o-scheduler.patch
