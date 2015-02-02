From: akpm@linux-foundation.org
Subject: + zram-fix-umount-reset_store-mount-race-condition.patch added to -mm tree
Date: Mon, 02 Feb 2015 14:30:15 -0800
Message-ID: <54cffa77.fI/75xjuKLwGyxXD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbbBBWaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2015 17:30:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, opensource.ganesh@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix umount-reset_store-mount race condition
has been added to the -mm tree.  Its filename is
     zram-fix-umount-reset_store-mount-race-condition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-fix-umount-reset_store-mount-race-condition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-fix-umount-reset_store-mount-race-condition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: fix umount-reset_store-mount race condition

Ganesh Mahendran was the first one who proposed to use bdev->bd_mutex to
avoid ->bd_holders race condition:

        CPU0                            CPU1
umount /* zram->init_done is true */
reset_store()
bdev->bd_holders == 0                   mount
...                                     zram_make_request()
zram_reset_device()

However, his solution required some considerable amount of code movement,
which we can avoid.

Apart from using bdev->bd_mutex in reset_store(), this patch also
simplifies zram_reset_device().

zram_reset_device() has a bool parameter reset_capacity which tells it
whether disk capacity and itself disk should be reset.  There are two
zram_reset_device() callers:

-- zram_exit() passes reset_capacity=false
-- reset_store() passes reset_capacity=true

So we can move reset_capacity-sensitive work out of zram_reset_device()
and perform it unconditionally in reset_store().  This also lets us drop
reset_capacity parameter from zram_reset_device() and pass zram pointer
only.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-fix-umount-reset_store-mount-race-condition drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-fix-umount-reset_store-mount-race-condition
+++ a/drivers/block/zram/zram_drv.c
@@ -715,7 +715,7 @@ static void zram_bio_discard(struct zram
 	}
 }
 
-static void zram_reset_device(struct zram *zram, bool reset_capacity)
+static void zram_reset_device(struct zram *zram)
 {
 	down_write(&zram->init_lock);
 
@@ -734,18 +734,7 @@ static void zram_reset_device(struct zra
 	memset(&zram->stats, 0, sizeof(zram->stats));
 
 	zram->disksize = 0;
-	if (reset_capacity)
-		set_capacity(zram->disk, 0);
-
 	up_write(&zram->init_lock);
-
-	/*
-	 * Revalidate disk out of the init_lock to avoid lockdep splat.
-	 * It's okay because disk's capacity is protected by init_lock
-	 * so that revalidate_disk always sees up-to-date capacity.
-	 */
-	if (reset_capacity)
-		revalidate_disk(zram->disk);
 }
 
 static ssize_t disksize_store(struct device *dev,
@@ -818,6 +807,7 @@ static ssize_t reset_store(struct device
 	if (!bdev)
 		return -ENOMEM;
 
+	mutex_lock(&bdev->bd_mutex);
 	/* Do not reset an active device! */
 	if (bdev->bd_holders) {
 		ret = -EBUSY;
@@ -835,12 +825,17 @@ static ssize_t reset_store(struct device
 
 	/* Make sure all pending I/O is finished */
 	fsync_bdev(bdev);
+	zram_reset_device(zram);
+	set_capacity(zram->disk, 0);
+
+	mutex_unlock(&bdev->bd_mutex);
+	revalidate_disk(zram->disk);
 	bdput(bdev);
 
-	zram_reset_device(zram, true);
 	return len;
 
 out:
+	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
 	return ret;
 }
@@ -1186,7 +1181,7 @@ static void __exit zram_exit(void)
 		 * Shouldn't access zram->disk after destroy_device
 		 * because destroy_device already released zram->disk.
 		 */
-		zram_reset_device(zram, false);
+		zram_reset_device(zram);
 	}
 
 	unregister_blkdev(zram_major, "zram");
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-clean-up-zram_meta_alloc.patch
zram-free-meta-table-in-zram_meta_free.patch
zram-fix-umount-reset_store-mount-race-condition.patch
linux-next.patch

