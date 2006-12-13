From: akpm@osdl.org
Subject: - md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:54 -0800
Message-ID: <200612130654.kBD6ssUh030585@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57697 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965016AbWLMGzA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:55:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raziebe@gmail.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: allow reads that have bypassed the cache to be retried on failure
has been removed from the -mm tree.  Its filename was
     md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: allow reads that have bypassed the cache to be retried on failure
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>

If a bypass-the-cache read fails, we simply try again through the cache.  If
it fails again it will trigger normal recovery precedures.

update 1:


1/
  chunk_aligned_read and retry_aligned_read assume that
      data_disks == raid_disks - 1
  which is not true for raid6.
  So when an aligned read request bypasses the cache, we can get the wrong data.

2/ The cloned bio is being used-after-free in raid5_align_endio
   (to test BIO_UPTODATE).

3/ We forgot to add rdev->data_offset when submitting
   a bio for aligned-read

4/ clone_bio calls blk_recount_segments and then we change bi_bdev,
   so we need to invalidate the segment counts.

5/ We don't de-reference the rdev when the read completes.
   This means we need to record the rdev to so it is still
   available in the end_io routine.  Fortunately
   bi_next in the original bio is unused at this point so
   we can stuff it in there.

6/ We leak a cloned bio if the target rdev is not usable.


update 2:

1/ When aligned requests fail (read error) they need to be retried
   via the normal method (stripe cache).  As we cannot be sure that
   we can process a single read in one go (we may not be able to
   allocate all the stripes needed) we store a bio-being-retried
   and a list of bioes-that-still-need-to-be-retried.
   When find a bio that needs to be retried, we should add it to
   the list, not to single-bio...

2/ We were never incrementing 'scnt' when resubmitting failed
   aligned requests.

[akpm@osdl.org: build fix]
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid5.c         |  165 +++++++++++++++++++++++++++++++++--
 include/linux/raid/raid5.h |    3 
 2 files changed, 163 insertions(+), 5 deletions(-)

diff -puN drivers/md/raid5.c~md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure
+++ a/drivers/md/raid5.c
@@ -134,6 +134,8 @@ static void __release_stripe(raid5_conf_
 			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
 				list_add_tail(&sh->lru, &conf->inactive_list);
 				wake_up(&conf->wait_for_stripe);
+				if (conf->retry_read_aligned)
+					md_wakeup_thread(conf->mddev->thread);
 			}
 		}
 	}
@@ -2645,18 +2647,80 @@ static int in_chunk_boundary(mddev_t *md
 }
 
 /*
+ *  add bio to the retry LIFO  ( in O(1) ... we are in interrupt )
+ *  later sampled by raid5d.
+ */
+static void add_bio_to_retry(struct bio *bi,raid5_conf_t *conf)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&conf->device_lock, flags);
+
+	bi->bi_next = conf->retry_read_aligned_list;
+	conf->retry_read_aligned_list = bi;
+
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+	md_wakeup_thread(conf->mddev->thread);
+}
+
+
+static struct bio *remove_bio_from_retry(raid5_conf_t *conf)
+{
+	struct bio *bi;
+
+	bi = conf->retry_read_aligned;
+	if (bi) {
+		conf->retry_read_aligned = NULL;
+		return bi;
+	}
+	bi = conf->retry_read_aligned_list;
+	if(bi) {
+		conf->retry_read_aligned = bi->bi_next;
+		bi->bi_next = NULL;
+		bi->bi_phys_segments = 1; /* biased count of active stripes */
+		bi->bi_hw_segments = 0; /* count of processed stripes */
+	}
+
+	return bi;
+}
+
+
+/*
  *  The "raid5_align_endio" should check if the read succeeded and if it
  *  did, call bio_endio on the original bio (having bio_put the new bio
  *  first).
  *  If the read failed..
  */
-int raid5_align_endio(struct bio *bi, unsigned int bytes , int error)
+static int raid5_align_endio(struct bio *bi, unsigned int bytes, int error)
 {
 	struct bio* raid_bi  = bi->bi_private;
+	mddev_t *mddev;
+	raid5_conf_t *conf;
+	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
+	mdk_rdev_t *rdev;
+
 	if (bi->bi_size)
 		return 1;
 	bio_put(bi);
-	bio_endio(raid_bi, bytes, error);
+
+	mddev = raid_bi->bi_bdev->bd_disk->queue->queuedata;
+	conf = mddev_to_conf(mddev);
+	rdev = (void*)raid_bi->bi_next;
+	raid_bi->bi_next = NULL;
+
+	rdev_dec_pending(rdev, conf->mddev);
+
+	if (!error && uptodate) {
+		bio_endio(raid_bi, bytes, 0);
+		if (atomic_dec_and_test(&conf->active_aligned_reads))
+			wake_up(&conf->wait_for_stripe);
+		return 0;
+	}
+
+
+	PRINTK("raid5_align_endio : io error...handing IO for a retry\n");
+
+	add_bio_to_retry(raid_bi, conf);
 	return 0;
 }
 
@@ -2665,7 +2729,7 @@ static int chunk_aligned_read(request_qu
 	mddev_t *mddev = q->queuedata;
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	const unsigned int raid_disks = conf->raid_disks;
-	const unsigned int data_disks = raid_disks - 1;
+	const unsigned int data_disks = raid_disks - conf->max_degraded;
 	unsigned int dd_idx, pd_idx;
 	struct bio* align_bi;
 	mdk_rdev_t *rdev;
@@ -2699,13 +2763,25 @@ static int chunk_aligned_read(request_qu
 	rcu_read_lock();
 	rdev = rcu_dereference(conf->disks[dd_idx].rdev);
 	if (rdev && test_bit(In_sync, &rdev->flags)) {
-		align_bi->bi_bdev =  rdev->bdev;
 		atomic_inc(&rdev->nr_pending);
 		rcu_read_unlock();
+		raid_bio->bi_next = (void*)rdev;
+		align_bi->bi_bdev =  rdev->bdev;
+		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
+		align_bi->bi_sector += rdev->data_offset;
+
+		spin_lock_irq(&conf->device_lock);
+		wait_event_lock_irq(conf->wait_for_stripe,
+				    conf->quiesce == 0,
+				    conf->device_lock, /* nothing */);
+		atomic_inc(&conf->active_aligned_reads);
+		spin_unlock_irq(&conf->device_lock);
+
 		generic_make_request(align_bi);
 		return 1;
 	} else {
 		rcu_read_unlock();
+		bio_put(align_bi);
 		return 0;
 	}
 }
@@ -3050,6 +3126,72 @@ static inline sector_t sync_request(mdde
 	return STRIPE_SECTORS;
 }
 
+static int  retry_aligned_read(raid5_conf_t *conf, struct bio *raid_bio)
+{
+	/* We may not be able to submit a whole bio at once as there
+	 * may not be enough stripe_heads available.
+	 * We cannot pre-allocate enough stripe_heads as we may need
+	 * more than exist in the cache (if we allow ever large chunks).
+	 * So we do one stripe head at a time and record in
+	 * ->bi_hw_segments how many have been done.
+	 *
+	 * We *know* that this entire raid_bio is in one chunk, so
+	 * it will be only one 'dd_idx' and only need one call to raid5_compute_sector.
+	 */
+	struct stripe_head *sh;
+	int dd_idx, pd_idx;
+	sector_t sector, logical_sector, last_sector;
+	int scnt = 0;
+	int remaining;
+	int handled = 0;
+
+	logical_sector = raid_bio->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
+	sector = raid5_compute_sector(	logical_sector,
+					conf->raid_disks,
+					conf->raid_disks - conf->max_degraded,
+					&dd_idx,
+					&pd_idx,
+					conf);
+	last_sector = raid_bio->bi_sector + (raid_bio->bi_size>>9);
+
+	for (; logical_sector < last_sector;
+	     logical_sector += STRIPE_SECTORS, scnt++) {
+
+		if (scnt < raid_bio->bi_hw_segments)
+			/* already done this stripe */
+			continue;
+
+		sh = get_active_stripe(conf, sector, conf->raid_disks, pd_idx, 1);
+
+		if (!sh) {
+			/* failed to get a stripe - must wait */
+			raid_bio->bi_hw_segments = scnt;
+			conf->retry_read_aligned = raid_bio;
+			return handled;
+		}
+
+		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
+		add_stripe_bio(sh, raid_bio, dd_idx, 0);
+		handle_stripe(sh, NULL);
+		release_stripe(sh);
+		handled++;
+	}
+	spin_lock_irq(&conf->device_lock);
+	remaining = --raid_bio->bi_phys_segments;
+	spin_unlock_irq(&conf->device_lock);
+	if (remaining == 0) {
+		int bytes = raid_bio->bi_size;
+
+		raid_bio->bi_size = 0;
+		raid_bio->bi_end_io(raid_bio, bytes, 0);
+	}
+	if (atomic_dec_and_test(&conf->active_aligned_reads))
+		wake_up(&conf->wait_for_stripe);
+	return handled;
+}
+
+
+
 /*
  * This is our raid5 kernel thread.
  *
@@ -3071,6 +3213,7 @@ static void raid5d (mddev_t *mddev)
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
 		struct list_head *first;
+		struct bio *bio;
 
 		if (conf->seq_flush != conf->seq_write) {
 			int seq = conf->seq_flush;
@@ -3087,6 +3230,16 @@ static void raid5d (mddev_t *mddev)
 		    !list_empty(&conf->delayed_list))
 			raid5_activate_delayed(conf);
 
+		while ((bio = remove_bio_from_retry(conf))) {
+			int ok;
+			spin_unlock_irq(&conf->device_lock);
+			ok = retry_aligned_read(conf, bio);
+			spin_lock_irq(&conf->device_lock);
+			if (!ok)
+				break;
+			handled++;
+		}
+
 		if (list_empty(&conf->handle_list))
 			break;
 
@@ -3274,6 +3427,7 @@ static int run(mddev_t *mddev)
 	INIT_LIST_HEAD(&conf->inactive_list);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
+	atomic_set(&conf->active_aligned_reads, 0);
 
 	PRINTK("raid5: run(%s) called.\n", mdname(mddev));
 
@@ -3796,7 +3950,8 @@ static void raid5_quiesce(mddev_t *mddev
 		spin_lock_irq(&conf->device_lock);
 		conf->quiesce = 1;
 		wait_event_lock_irq(conf->wait_for_stripe,
-				    atomic_read(&conf->active_stripes) == 0,
+				    atomic_read(&conf->active_stripes) == 0 &&
+				    atomic_read(&conf->active_aligned_reads) == 0,
 				    conf->device_lock, /* nothing */);
 		spin_unlock_irq(&conf->device_lock);
 		break;
diff -puN include/linux/raid/raid5.h~md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure include/linux/raid/raid5.h
--- a/include/linux/raid/raid5.h~md-allow-reads-that-have-bypassed-the-cache-to-be-retried-on-failure
+++ a/include/linux/raid/raid5.h
@@ -227,7 +227,10 @@ struct raid5_private_data {
 	struct list_head	handle_list; /* stripes needing handling */
 	struct list_head	delayed_list; /* stripes that have plugged requests */
 	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
+	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
+	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
 	atomic_t		preread_active_stripes; /* stripes with scheduled io */
+	atomic_t		active_aligned_reads;
 
 	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
 	/* unfortunately we need two cache names as we temporarily have
_

Patches currently in -mm which might be from raziebe@gmail.com are

origin.patch
md-dont-assume-that-read==0-and-write==1-use-the-names-explicitly.patch

