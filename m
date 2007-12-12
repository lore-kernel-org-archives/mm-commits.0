From: akpm@linux-foundation.org
Subject: + md-update-md-bitmap-during-resync.patch added to -mm tree
Date: Tue, 11 Dec 2007 22:07:28 -0800
Message-ID: <200712120607.lBC67S2r028890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754059AbXLLGIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 01:08:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: Update md bitmap during resync.
has been added to the -mm tree.  Its filename is
     md-update-md-bitmap-during-resync.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: Update md bitmap during resync.
From: NeilBrown <neilb@suse.de>

Currently an md array with a write-intent bitmap does not updated that bitmap
to reflect successful partial resync.  Rather the entire bitmap is updated
when the resync completes.

This is because there is no guarentee that resync requests will complete in
order, and tracking each request individually is unnecessarily burdensome.

However there is value in regularly updating the bitmap, so add code to
periodically pause while all pending sync requests complete, then update the
bitmap.  Doing this only every few seconds (the same as the bitmap update
time) does not notciably affect resync performance.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c         |   34 +++++++++++++++++++++++++++++-----
 drivers/md/raid1.c          |    1 +
 drivers/md/raid10.c         |    2 ++
 drivers/md/raid5.c          |    3 +++
 include/linux/raid/bitmap.h |    3 +++
 5 files changed, 38 insertions(+), 5 deletions(-)

diff -puN drivers/md/bitmap.c~md-update-md-bitmap-during-resync drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-update-md-bitmap-during-resync
+++ a/drivers/md/bitmap.c
@@ -1348,14 +1348,38 @@ void bitmap_close_sync(struct bitmap *bi
 	 */
 	sector_t sector = 0;
 	int blocks;
-	if (!bitmap) return;
+	if (!bitmap)
+		return;
 	while (sector < bitmap->mddev->resync_max_sectors) {
 		bitmap_end_sync(bitmap, sector, &blocks, 0);
-/*
-		if (sector < 500) printk("bitmap_close_sync: sec %llu blks %d\n",
-					 (unsigned long long)sector, blocks);
-*/		sector += blocks;
+		sector += blocks;
+	}
+}
+
+void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
+{
+	sector_t s = 0;
+	int blocks;
+
+	if (!bitmap)
+		return;
+	if (sector == 0) {
+		bitmap->last_end_sync = jiffies;
+		return;
+	}
+	if (time_before(jiffies, (bitmap->last_end_sync
+				  + bitmap->daemon_sleep * HZ)))
+		return;
+	wait_event(bitmap->mddev->recovery_wait,
+		   atomic_read(&bitmap->mddev->recovery_active) == 0);
+
+	sector &= ~((1ULL << CHUNK_BLOCK_SHIFT(bitmap)) - 1);
+	s = 0;
+	while (s < sector && s < bitmap->mddev->resync_max_sectors) {
+		bitmap_end_sync(bitmap, s, &blocks, 0);
+		s += blocks;
 	}
+	bitmap->last_end_sync = jiffies;
 }
 
 static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed)
diff -puN drivers/md/raid1.c~md-update-md-bitmap-during-resync drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-update-md-bitmap-during-resync
+++ a/drivers/md/raid1.c
@@ -1684,6 +1684,7 @@ static sector_t sync_request(mddev_t *md
 	if (!go_faster && conf->nr_waiting)
 		msleep_interruptible(1000);
 
+	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 	raise_barrier(conf);
 
 	conf->next_resync = sector_nr;
diff -puN drivers/md/raid10.c~md-update-md-bitmap-during-resync drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-update-md-bitmap-during-resync
+++ a/drivers/md/raid10.c
@@ -1670,6 +1670,8 @@ static sector_t sync_request(mddev_t *md
 	if (!go_faster && conf->nr_waiting)
 		msleep_interruptible(1000);
 
+	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
+
 	/* Again, very different code for resync and recovery.
 	 * Both must result in an r10bio with a list of bios that
 	 * have bi_end_io, bi_sector, bi_bdev set,
diff -puN drivers/md/raid5.c~md-update-md-bitmap-during-resync drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-update-md-bitmap-during-resync
+++ a/drivers/md/raid5.c
@@ -4333,6 +4333,9 @@ static inline sector_t sync_request(mdde
 		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole stripes */
 	}
 
+
+	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
+
 	pd_idx = stripe_to_pdidx(sector_nr, conf, raid_disks);
 
 	sh = wait_for_inactive_cache(conf, sector_nr, raid_disks, pd_idx);
diff -puN include/linux/raid/bitmap.h~md-update-md-bitmap-during-resync include/linux/raid/bitmap.h
--- a/include/linux/raid/bitmap.h~md-update-md-bitmap-during-resync
+++ a/include/linux/raid/bitmap.h
@@ -244,6 +244,8 @@ struct bitmap {
 	 */
 	unsigned long daemon_lastrun; /* jiffies of last run */
 	unsigned long daemon_sleep; /* how many seconds between updates? */
+	unsigned long last_end_sync; /* when we lasted called end_sync to
+				      * update bitmap with resync progress */
 
 	atomic_t pending_writes; /* pending writes to the bitmap file */
 	wait_queue_head_t write_wait;
@@ -275,6 +277,7 @@ void bitmap_endwrite(struct bitmap *bitm
 int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int degraded);
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int aborted);
 void bitmap_close_sync(struct bitmap *bitmap);
+void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector);
 
 void bitmap_unplug(struct bitmap *bitmap);
 void bitmap_daemon_work(struct bitmap *bitmap);
_

Patches currently in -mm which might be from neilb@suse.de are

knfsd-change-mailing-list-for-nfsd-in-maintainers.patch
git-md-accel.patch
git-nfsd.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
md-raid6-fix-mktablec.patch
md-raid6-clean-up-the-style-of-raid6test-testc.patch
md-update-md-bitmap-during-resync.patch
md-update-md-bitmap-during-resync-fix.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
