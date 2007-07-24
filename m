From: akpm@linux-foundation.org
Subject: - raid5-add-the-stripe_queue-object-for-tracking-raid.patch removed from -mm tree
Date: Mon, 23 Jul 2007 23:03:56 -0700
Message-ID: <200707240603.l6O63uC8031410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49022 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbXGXGEN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 02:04:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     raid5: add the stripe_queue object for tracking raid io requests
has been removed from the -mm tree.  Its filename was
     raid5-add-the-stripe_queue-object-for-tracking-raid.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: raid5: add the stripe_queue object for tracking raid io requests
From: Dan Williams <dan.j.williams@intel.com>

The raid5 stripe cache object, struct stripe_head, serves two purposes:
	1/ frontend: queuing incoming requests
	2/ backend: transitioning requests through the cache state machine
	   to the backing devices
The problem with this model is that queuing decisions are directly tied to
cache availability.  There is no facility to determine that a request or
group of requests 'deserves' usage of the cache and disks at any given time.

This patch separates the object members needed for queuing from the object
members used for caching.  The stripe_queue object takes over the incoming
bio lists as well as the buffer state flags.

The following fields are moved from struct stripe_head to struct
stripe_queue:
	raid5_private_data *raid_conf
	int pd_idx
	spinlock_t lock
	int bm_seq

The following fields are moved from struct r5dev to struct r5_queue_dev:
	sector_t sector
	struct bio *toread, *towrite
	unsigned long flags

This patch lays the groundwork, but does not implement, the facility to
have more queue objects in the system than available stripes, currently this
remains a 1:1 relationship.  In other words, this patch just moves fields
around and does not implement new logic.

Unit information
================
File size = megabytes
Blk Size  = bytes
Num Thr   = number of threads
Avg Rate  = relative throughput
CPU%      = relative percentage of CPU used during the test
CPU Eff   = Rate divided by CPU% - relative throughput per cpu load

Configuration
=============
Platform: 1200Mhz iop348 with 4-disk sata_vsc array
mdadm --create /dev/md0 /dev/sd[abcd] -n 4 -l 5
mkfs.ext2 /dev/md0
mount /dev/md0 /mnt/raid
tiobench --size 2048 --numruns 5 --block 4096 --block 131072 --dir /mnt/raid

Sequential Reads
                File    Blk     Num     Avg     Maximum CPU
Identifier      Size    Size    Thr     Rate    (CPU%)  Eff
--------------- ------  -----   ---     ------  ------  -----
2.6.22-rc7-iop1 2048    4096    1       0%      4%      -3%
2.6.22-rc7-iop1 2048    4096    2       -38%    -33%    -8%
2.6.22-rc7-iop1 2048    4096    4       -35%    -30%    -8%
2.6.22-rc7-iop1 2048    4096    8       -14%    -11%    -3%
2.6.22-rc7-iop1 2048    13107   1       2%      1%      2%
2.6.22-rc7-iop1 2048    13107   2       -11%    -10%    -2%
2.6.22-rc7-iop1 2048    13107   4       -7%     -6%     -1%
2.6.22-rc7-iop1 2048    13107   8       -9%     -6%     -4%

Random  Reads
                File    Blk     Num     Avg     Maximum CPU
Identifier      Size    Size    Thr     Rate    (CPU%)  Eff
--------------- ------  -----   ---     ------  ------  -----
2.6.22-rc7-iop1 2048    4096    1       -9%     15%     -21%
2.6.22-rc7-iop1 2048    4096    2       -1%     -30%    42%
2.6.22-rc7-iop1 2048    4096    4       -14%    -22%    10%
2.6.22-rc7-iop1 2048    4096    8       -21%    -28%    9%
2.6.22-rc7-iop1 2048    13107   1       -8%     -4%     -4%
2.6.22-rc7-iop1 2048    13107   2       -13%    -13%    0%
2.6.22-rc7-iop1 2048    13107   4       -15%    -15%    0%
2.6.22-rc7-iop1 2048    13107   8       -13%    -13%    0%

Sequential Writes
                File    Blk     Num     Avg     Maximum CPU
Identifier      Size    Size    Thr     Rate    (CPU%)  Eff
--------------- ------  -----   ---     ------  ------  -----
2.6.22-rc7-iop1 2048    4096    1       25%     11%     12%
2.6.22-rc7-iop1 2048    4096    2       41%     42%     -1%
2.6.22-rc7-iop1 2048    4096    4       40%     18%     19%
2.6.22-rc7-iop1 2048    4096    8       15%     -5%     21%
2.6.22-rc7-iop1 2048    13107   1       65%     57%     4%
2.6.22-rc7-iop1 2048    13107   2       46%     36%     8%
2.6.22-rc7-iop1 2048    13107   4       24%     -7%     34%
2.6.22-rc7-iop1 2048    13107   8       28%     -15%    51%

Random  Writes
                File    Blk     Num     Avg     Maximum CPU
Identifier      Size    Size    Thr     Rate    (CPU%)  Eff
--------------- ------  -----   ---     ------  ------  -----
2.6.22-rc7-iop1 2048    4096    1       2%      -8%     11%
2.6.22-rc7-iop1 2048    4096    2       -1%     -19%    21%
2.6.22-rc7-iop1 2048    4096    4       2%      2%      0%
2.6.22-rc7-iop1 2048    4096    8       -1%     -28%    37%
2.6.22-rc7-iop1 2048    13107   1       2%      -3%     5%
2.6.22-rc7-iop1 2048    13107   2       3%      -4%     7%
2.6.22-rc7-iop1 2048    13107   4       4%      -3%     8%
2.6.22-rc7-iop1 2048    13107   8       5%      -9%     15%

The write performance numbers are better than I expected and would seem to
address the concerns raised in the thread "Odd (slow) RAID performance"[2]. 
The read performance drop was not expected.  However, the numbers suggest some
additional changes to be made to the queuing model.  Where read performance is
dropping there appears to be an equal drop in CPU utilization, which seems to
suggest that pure read requests be handled immediately without a trip to the
the stripe-queue workqueue.

Although it is not shown in the above data, another positive aspect is that
increasing the cache size past a certain point causes the write performance
gains to erode.  In other words negative returns in contrast to diminishing
returns.  The stripe-queue can only carry out optimizations while the cache is
busy.  When the cache is large requests can be handled without waiting, and
performance approaches the original 1:1 (queue-to-stripe-head) model.  CPU
speed dictates the maximum effective cache size.  Once the CPU can no longer
keep the stripe-queue saturated performance falls off from the peak.  This is
a positive change because it shows that the new queuing model can produce
higher performance with less resources, but it does require more care when
changing 'stripe_cache_size.' The above numbers were taken with the default
cache size of 256.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c         |  903 +++++++++++++++++++----------------
 include/linux/raid/raid5.h |   29 -
 2 files changed, 530 insertions(+), 402 deletions(-)

diff -puN drivers/md/raid5.c~raid5-add-the-stripe_queue-object-for-tracking-raid drivers/md/raid5.c
--- a/drivers/md/raid5.c~raid5-add-the-stripe_queue-object-for-tracking-raid
+++ a/drivers/md/raid5.c
@@ -31,7 +31,7 @@
  * conf->bm_flush is the number of the last batch that was closed to
  *    new additions.
  * When we discover that we will need to write to any block in a stripe
- * (in add_stripe_bio) we update the in-memory bitmap and record in sh->bm_seq
+ * (in add_stripe_bio) we update the in-memory bitmap and record in sq->bm_seq
  * the number of the batch it will be in. This is bm_flush+1.
  * When we are ready to do a write, if that batch hasn't been written yet,
  *   we plug the array and queue the stripe for later.
@@ -132,7 +132,7 @@ static void __release_stripe(raid5_conf_
 				list_add_tail(&sh->lru, &conf->delayed_list);
 				blk_plug_device(conf->mddev->queue);
 			} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
-				   sh->bm_seq - conf->seq_write > 0) {
+				   sh->sq->bm_seq - conf->seq_write > 0) {
 				list_add_tail(&sh->lru, &conf->bitmap_list);
 				blk_plug_device(conf->mddev->queue);
 			} else {
@@ -159,7 +159,7 @@ static void __release_stripe(raid5_conf_
 }
 static void release_stripe(struct stripe_head *sh)
 {
-	raid5_conf_t *conf = sh->raid_conf;
+	raid5_conf_t *conf = sh->sq->raid_conf;
 	unsigned long flags;
 
 	spin_lock_irqsave(&conf->device_lock, flags);
@@ -238,7 +238,7 @@ static void raid5_build_block (struct st
 
 static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int disks)
 {
-	raid5_conf_t *conf = sh->raid_conf;
+	raid5_conf_t *conf = sh->sq->raid_conf;
 	int i;
 
 	BUG_ON(atomic_read(&sh->count) != 0);
@@ -252,23 +252,24 @@ static void init_stripe(struct stripe_he
 	remove_hash(sh);
 
 	sh->sector = sector;
-	sh->pd_idx = pd_idx;
+	sh->sq->pd_idx = pd_idx;
 	sh->state = 0;
 
 	sh->disks = disks;
 
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sh->sq->dev[i];
 
-		if (dev->toread || dev->read || dev->towrite || dev->written ||
-		    test_bit(R5_LOCKED, &dev->flags)) {
+		if (dev_q->toread || dev->read || dev_q->towrite ||
+			dev->written || test_bit(R5_LOCKED, &dev_q->flags)) {
 			printk(KERN_ERR "sector=%llx i=%d %p %p %p %p %d\n",
-			       (unsigned long long)sh->sector, i, dev->toread,
-			       dev->read, dev->towrite, dev->written,
-			       test_bit(R5_LOCKED, &dev->flags));
+			       (unsigned long long)sh->sector, i, dev_q->toread,
+			       dev->read, dev_q->towrite, dev->written,
+			       test_bit(R5_LOCKED, &dev_q->flags));
 			BUG();
 		}
-		dev->flags = 0;
+		dev_q->flags = 0;
 		raid5_build_block(sh, i);
 	}
 	insert_hash(conf, sh);
@@ -288,6 +289,9 @@ static struct stripe_head *__find_stripe
 	return NULL;
 }
 
+static sector_t compute_blocknr(raid5_conf_t *conf, int raid_disks,
+	sector_t sector, int pd_idx, int i);
+
 static void unplug_slaves(mddev_t *mddev);
 static void raid5_unplug_device(request_queue_t *q);
 
@@ -389,7 +393,8 @@ raid5_end_write_request (struct bio *bi,
 
 static void ops_run_io(struct stripe_head *sh)
 {
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int i, disks = sh->disks;
 
 	might_sleep();
@@ -398,9 +403,9 @@ static void ops_run_io(struct stripe_hea
 		int rw;
 		struct bio *bi;
 		mdk_rdev_t *rdev;
-		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags))
+		if (test_and_clear_bit(R5_Wantwrite, &sq->dev[i].flags))
 			rw = WRITE;
-		else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
+		else if (test_and_clear_bit(R5_Wantread, &sq->dev[i].flags))
 			rw = READ;
 		else
 			continue;
@@ -443,7 +448,7 @@ static void ops_run_io(struct stripe_hea
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
 			if (rw == WRITE &&
-			    test_bit(R5_ReWrite, &sh->dev[i].flags))
+			    test_bit(R5_ReWrite, &sq->dev[i].flags))
 				atomic_add(STRIPE_SECTORS,
 					&rdev->corrected_errors);
 			generic_make_request(bi);
@@ -452,7 +457,7 @@ static void ops_run_io(struct stripe_hea
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
-			clear_bit(R5_LOCKED, &sh->dev[i].flags);
+			clear_bit(R5_LOCKED, &sq->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
 	}
@@ -513,7 +518,8 @@ static void ops_complete_biofill(void *s
 {
 	struct stripe_head *sh = stripe_head_ref;
 	struct bio *return_bi = NULL;
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int i, more_to_read = 0;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
@@ -521,17 +527,19 @@ static void ops_complete_biofill(void *s
 
 	/* clear completed biofills */
 	for (i = sh->disks; i--; ) {
-		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 		/* check if this stripe has new incoming reads */
-		if (dev->toread)
+		if (dev_q->toread)
 			more_to_read++;
 
 		/* acknowledge completion of a biofill operation */
 		/* and check if we need to reply to a read request
 		*/
-		if (test_bit(R5_Wantfill, &dev->flags) && !dev->toread) {
+		if (test_bit(R5_Wantfill, &dev_q->flags) && !dev_q->toread) {
 			struct bio *rbi, *rbi2;
-			clear_bit(R5_Wantfill, &dev->flags);
+			struct r5dev *dev = &sh->dev[i];
+
+			clear_bit(R5_Wantfill, &dev_q->flags);
 
 			/* The access to dev->read is outside of the
 			 * spin_lock_irq(&conf->device_lock), but is protected
@@ -541,8 +549,8 @@ static void ops_complete_biofill(void *s
 			rbi = dev->read;
 			dev->read = NULL;
 			while (rbi && rbi->bi_sector <
-				dev->sector + STRIPE_SECTORS) {
-				rbi2 = r5_next_bio(rbi, dev->sector);
+				dev_q->sector + STRIPE_SECTORS) {
+				rbi2 = r5_next_bio(rbi, dev_q->sector);
 				spin_lock_irq(&conf->device_lock);
 				if (--rbi->bi_phys_segments == 0) {
 					rbi->bi_next = return_bi;
@@ -566,7 +574,7 @@ static void ops_complete_biofill(void *s
 static void ops_run_biofill(struct stripe_head *sh)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
-	raid5_conf_t *conf = sh->raid_conf;
+	raid5_conf_t *conf = sh->sq->raid_conf;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
@@ -574,17 +582,18 @@ static void ops_run_biofill(struct strip
 
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
-		if (test_bit(R5_Wantfill, &dev->flags)) {
+		struct r5_queue_dev *dev_q = &sh->sq->dev[i];
+		if (test_bit(R5_Wantfill, &dev_q->flags)) {
 			struct bio *rbi;
 			spin_lock_irq(&conf->device_lock);
-			dev->read = rbi = dev->toread;
-			dev->toread = NULL;
+			dev->read = rbi = dev_q->toread;
+			dev_q->toread = NULL;
 			spin_unlock_irq(&conf->device_lock);
 			while (rbi && rbi->bi_sector <
-				dev->sector + STRIPE_SECTORS) {
+				dev_q->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(0, rbi, dev->page,
-					dev->sector, tx);
-				rbi = r5_next_bio(rbi, dev->sector);
+					dev_q->sector, tx);
+				rbi = r5_next_bio(rbi, dev_q->sector);
 			}
 		}
 	}
@@ -597,8 +606,9 @@ static void ops_run_biofill(struct strip
 static void ops_complete_compute5(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
+	struct stripe_queue *sq = sh->sq;
 	int target = sh->ops.target;
-	struct r5dev *tgt = &sh->dev[target];
+	struct r5_queue_dev *tgt = &sq->dev[target];
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -618,15 +628,14 @@ ops_run_compute5(struct stripe_head *sh,
 	int disks = sh->disks;
 	struct page *xor_srcs[disks];
 	int target = sh->ops.target;
-	struct r5dev *tgt = &sh->dev[target];
-	struct page *xor_dest = tgt->page;
+	struct page *xor_dest = sh->dev[target].page;
 	int count = 0;
 	struct dma_async_tx_descriptor *tx;
 	int i;
 
 	pr_debug("%s: stripe %llu block: %d\n",
 		__FUNCTION__, (unsigned long long)sh->sector, target);
-	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
+	BUG_ON(!test_bit(R5_Wantcompute, &sh->sq->dev[target].flags));
 
 	for (i = disks; i--; )
 		if (i != target)
@@ -665,7 +674,8 @@ ops_run_prexor(struct stripe_head *sh, s
 	/* kernel stack size limits the total number of disks */
 	int disks = sh->disks;
 	struct page *xor_srcs[disks];
-	int count = 0, pd_idx = sh->pd_idx, i;
+	struct stripe_queue *sq = sh->sq;
+	int count = 0, pd_idx = sq->pd_idx, i;
 
 	/* existing parity data subtracted */
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
@@ -675,8 +685,9 @@ ops_run_prexor(struct stripe_head *sh, s
 
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (dev->towrite && test_bit(R5_Wantprexor, &dev->flags))
+		if (dev_q->towrite && test_bit(R5_Wantprexor, &dev_q->flags))
 			xor_srcs[count++] = dev->page;
 	}
 
@@ -691,7 +702,8 @@ static struct dma_async_tx_descriptor *
 ops_run_biodrain(struct stripe_head *sh, struct dma_async_tx_descriptor *tx)
 {
 	int disks = sh->disks;
-	int pd_idx = sh->pd_idx, i;
+	struct stripe_queue *sq = sh->sq;
+	int pd_idx = sq->pd_idx, i;
 
 	/* check if prexor is active which means only process blocks
 	 * that are part of a read-modify-write (Wantprexor)
@@ -703,35 +715,36 @@ ops_run_biodrain(struct stripe_head *sh,
 
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 		struct bio *chosen;
 		int towrite;
 
 		towrite = 0;
 		if (prexor) { /* rmw */
-			if (dev->towrite &&
-			    test_bit(R5_Wantprexor, &dev->flags))
+			if (dev_q->towrite &&
+			    test_bit(R5_Wantprexor, &dev_q->flags))
 				towrite = 1;
 		} else { /* rcw */
-			if (i != pd_idx && dev->towrite &&
-				test_bit(R5_LOCKED, &dev->flags))
+			if (i != pd_idx && dev_q->towrite &&
+				test_bit(R5_LOCKED, &dev_q->flags))
 				towrite = 1;
 		}
 
 		if (towrite) {
 			struct bio *wbi;
 
-			spin_lock(&sh->lock);
-			chosen = dev->towrite;
-			dev->towrite = NULL;
+			spin_lock(&sq->lock);
+			chosen = dev_q->towrite;
+			dev_q->towrite = NULL;
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
-			spin_unlock(&sh->lock);
+			spin_unlock(&sq->lock);
 
 			while (wbi && wbi->bi_sector <
-				dev->sector + STRIPE_SECTORS) {
+				dev_q->sector + STRIPE_SECTORS) {
 				tx = async_copy_data(1, wbi, dev->page,
-					dev->sector, tx);
-				wbi = r5_next_bio(wbi, dev->sector);
+					dev_q->sector, tx);
+				wbi = r5_next_bio(wbi, dev_q->sector);
 			}
 		}
 	}
@@ -754,15 +767,17 @@ static void ops_complete_postxor(void *s
 static void ops_complete_write(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	int disks = sh->disks, i, pd_idx = sh->pd_idx;
+	struct stripe_queue *sq = sh->sq;
+	int disks = sh->disks, i, pd_idx = sq->pd_idx;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
 
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 		if (dev->written || i == pd_idx)
-			set_bit(R5_UPTODATE, &dev->flags);
+			set_bit(R5_UPTODATE, &dev_q->flags);
 	}
 
 	set_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
@@ -779,7 +794,7 @@ ops_run_postxor(struct stripe_head *sh, 
 	int disks = sh->disks;
 	struct page *xor_srcs[disks];
 
-	int count = 0, pd_idx = sh->pd_idx, i;
+	int count = 0, pd_idx = sh->sq->pd_idx, i;
 	struct page *xor_dest;
 	int prexor = test_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
 	unsigned long flags;
@@ -833,14 +848,15 @@ ops_run_postxor(struct stripe_head *sh, 
 static void ops_complete_check(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	int pd_idx = sh->pd_idx;
+	int pd_idx = sh->sq->pd_idx;
+	struct stripe_queue *sq = sh->sq;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
 
 	if (test_and_clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending) &&
 		sh->ops.zero_sum_result == 0)
-		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+		set_bit(R5_UPTODATE, &sq->dev[pd_idx].flags);
 
 	set_bit(STRIPE_OP_CHECK, &sh->ops.complete);
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -854,7 +870,7 @@ static void ops_run_check(struct stripe_
 	struct page *xor_srcs[disks];
 	struct dma_async_tx_descriptor *tx;
 
-	int count = 0, pd_idx = sh->pd_idx, i;
+	int count = 0, pd_idx = sh->sq->pd_idx, i;
 	struct page *xor_dest = xor_srcs[count++] = sh->dev[pd_idx].page;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
@@ -911,25 +927,39 @@ static void raid5_run_ops(struct stripe_
 
 	if (overlap_clear)
 		for (i = disks; i--; ) {
-			struct r5dev *dev = &sh->dev[i];
-			if (test_and_clear_bit(R5_Overlap, &dev->flags))
-				wake_up(&sh->raid_conf->wait_for_overlap);
+			struct stripe_queue *sq = sh->sq;
+			struct r5_queue_dev *dev_q = &sq->dev[i];
+			if (test_and_clear_bit(R5_Overlap, &dev_q->flags))
+				wake_up(&sh->sq->raid_conf->wait_for_overlap);
 		}
 }
 
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
-	sh = kmem_cache_alloc(conf->slab_cache, GFP_KERNEL);
+	struct stripe_queue *sq;
+
+	sh = kmem_cache_alloc(conf->sh_slab_cache, GFP_KERNEL);
 	if (!sh)
 		return 0;
+
+	sq = kmem_cache_alloc(conf->sq_slab_cache, GFP_KERNEL);
+	if (!sq) {
+		kmem_cache_free(conf->sh_slab_cache, sh);
+		return 0;
+	}
+
 	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
-	sh->raid_conf = conf;
-	spin_lock_init(&sh->lock);
+	memset(sq, 0, sizeof(*sq) +
+		(conf->raid_disks-1) * sizeof(struct r5_queue_dev));
+	sh->sq = sq;
+	sq->raid_conf = conf;
+	spin_lock_init(&sq->lock);
 
 	if (grow_buffers(sh, conf->raid_disks)) {
 		shrink_buffers(sh, conf->raid_disks);
-		kmem_cache_free(conf->slab_cache, sh);
+		kmem_cache_free(conf->sh_slab_cache, sh);
+		kmem_cache_free(conf->sq_slab_cache, sq);
 		return 0;
 	}
 	sh->disks = conf->raid_disks;
@@ -937,7 +967,9 @@ static int grow_one_stripe(raid5_conf_t 
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
 	INIT_LIST_HEAD(&sh->lru);
-	release_stripe(sh);
+	spin_lock_irq(&conf->device_lock);
+	__release_stripe(conf, sh);
+	spin_unlock_irq(&conf->device_lock);
 	return 1;
 }
 
@@ -946,16 +978,29 @@ static int grow_stripes(raid5_conf_t *co
 	struct kmem_cache *sc;
 	int devs = conf->raid_disks;
 
-	sprintf(conf->cache_name[0], "raid5-%s", mdname(conf->mddev));
-	sprintf(conf->cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
+	sprintf(conf->sh_cache_name[0], "raid5-%s", mdname(conf->mddev));
+	sprintf(conf->sh_cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
+	sprintf(conf->sq_cache_name[0], "raid5q-%s", mdname(conf->mddev));
+	sprintf(conf->sq_cache_name[1], "raid5q-%s-alt", mdname(conf->mddev));
+
 	conf->active_name = 0;
-	sc = kmem_cache_create(conf->cache_name[conf->active_name],
+	sc = kmem_cache_create(conf->sh_cache_name[conf->active_name],
 			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
 			       0, 0, NULL);
+
 	if (!sc)
 		return 1;
-	conf->slab_cache = sc;
+	conf->sh_slab_cache = sc;
 	conf->pool_size = devs;
+
+	sc = kmem_cache_create(conf->sq_cache_name[conf->active_name],
+		sizeof(struct stripe_queue) +
+		(devs-1)*sizeof(struct r5_queue_dev), 0, NULL);
+
+	if (!sc)
+		return 1;
+	conf->sq_slab_cache = sc;
+
 	while (num--)
 		if (!grow_one_stripe(conf))
 			return 1;
@@ -992,7 +1037,7 @@ static int resize_stripes(raid5_conf_t *
 	LIST_HEAD(newstripes);
 	struct disk_info *ndisks;
 	int err = 0;
-	struct kmem_cache *sc;
+	struct kmem_cache *sc, *sc_q;
 	int i;
 
 	if (newsize <= conf->pool_size)
@@ -1001,21 +1046,40 @@ static int resize_stripes(raid5_conf_t *
 	md_allow_write(conf->mddev);
 
 	/* Step 1 */
-	sc = kmem_cache_create(conf->cache_name[1-conf->active_name],
+	sc = kmem_cache_create(conf->sh_cache_name[1-conf->active_name],
 			       sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
 			       0, 0, NULL);
 	if (!sc)
 		return -ENOMEM;
 
+	sc_q = kmem_cache_create(conf->sh_cache_name[1-conf->active_name],
+		    sizeof(struct stripe_queue) +
+		    (newsize-1)*sizeof(struct r5_queue_dev), 0, NULL);
+	if (!sc_q) {
+		kmem_cache_destroy(sc);
+		return -ENOMEM;
+	}
+
 	for (i = conf->max_nr_stripes; i; i--) {
+		struct stripe_queue *nsq;
+
 		nsh = kmem_cache_alloc(sc, GFP_KERNEL);
 		if (!nsh)
 			break;
 
+		nsq = kmem_cache_alloc(sc_q, GFP_KERNEL);
+		if (!nsq) {
+			kmem_cache_free(sc, nsh);
+			break;
+		}
+
 		memset(nsh, 0, sizeof(*nsh) + (newsize-1)*sizeof(struct r5dev));
+		memset(nsq, 0, sizeof(*nsq) +
+			(newsize-1)*sizeof(struct r5_queue_dev));
 
-		nsh->raid_conf = conf;
-		spin_lock_init(&nsh->lock);
+		nsq->raid_conf = conf;
+		nsh->sq = nsq;
+		spin_lock_init(&nsq->lock);
 
 		list_add(&nsh->lru, &newstripes);
 	}
@@ -1024,8 +1088,10 @@ static int resize_stripes(raid5_conf_t *
 		while (!list_empty(&newstripes)) {
 			nsh = list_entry(newstripes.next, struct stripe_head, lru);
 			list_del(&nsh->lru);
+			kmem_cache_free(sc_q, nsh->sq);
 			kmem_cache_free(sc, nsh);
 		}
+		kmem_cache_destroy(sc_q);
 		kmem_cache_destroy(sc);
 		return -ENOMEM;
 	}
@@ -1047,9 +1113,11 @@ static int resize_stripes(raid5_conf_t *
 			nsh->dev[i].page = osh->dev[i].page;
 		for( ; i<newsize; i++)
 			nsh->dev[i].page = NULL;
-		kmem_cache_free(conf->slab_cache, osh);
+		kmem_cache_free(conf->sq_slab_cache, osh->sq);
+		kmem_cache_free(conf->sh_slab_cache, osh);
 	}
-	kmem_cache_destroy(conf->slab_cache);
+	kmem_cache_destroy(conf->sh_slab_cache);
+	kmem_cache_destroy(conf->sq_slab_cache);
 
 	/* Step 3.
 	 * At this point, we are holding all the stripes so the array
@@ -1080,7 +1148,8 @@ static int resize_stripes(raid5_conf_t *
 	}
 	/* critical section pass, GFP_NOIO no longer needed */
 
-	conf->slab_cache = sc;
+	conf->sh_slab_cache = sc;
+	conf->sq_slab_cache = sc_q;
 	conf->active_name = 1-conf->active_name;
 	conf->pool_size = newsize;
 	return err;
@@ -1098,7 +1167,9 @@ static int drop_one_stripe(raid5_conf_t 
 		return 0;
 	BUG_ON(atomic_read(&sh->count));
 	shrink_buffers(sh, conf->pool_size);
-	kmem_cache_free(conf->slab_cache, sh);
+	if (sh->sq)
+		kmem_cache_free(conf->sq_slab_cache, sh->sq);
+	kmem_cache_free(conf->sh_slab_cache, sh);
 	atomic_dec(&conf->active_stripes);
 	return 1;
 }
@@ -1108,20 +1179,25 @@ static void shrink_stripes(raid5_conf_t 
 	while (drop_one_stripe(conf))
 		;
 
-	if (conf->slab_cache)
-		kmem_cache_destroy(conf->slab_cache);
-	conf->slab_cache = NULL;
+	if (conf->sh_slab_cache)
+		kmem_cache_destroy(conf->sh_slab_cache);
+	conf->sh_slab_cache = NULL;
+
+	if (conf->sq_slab_cache)
+		kmem_cache_destroy(conf->sq_slab_cache);
+	conf->sq_slab_cache = NULL;
 }
 
 static int raid5_end_read_request(struct bio * bi, unsigned int bytes_done,
 				   int error)
 {
  	struct stripe_head *sh = bi->bi_private;
-	raid5_conf_t *conf = sh->raid_conf;
+	raid5_conf_t *conf = sh->sq->raid_conf;
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	char b[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
+	struct stripe_queue *sq = sh->sq;
 
 	if (bi->bi_size)
 		return 1;
@@ -1139,15 +1215,15 @@ static int raid5_end_read_request(struct
 	}
 
 	if (uptodate) {
-		set_bit(R5_UPTODATE, &sh->dev[i].flags);
-		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
+		set_bit(R5_UPTODATE, &sq->dev[i].flags);
+		if (test_bit(R5_ReadError, &sq->dev[i].flags)) {
 			rdev = conf->disks[i].rdev;
 			printk(KERN_INFO "raid5:%s: read error corrected (%lu sectors at %llu on %s)\n",
 			       mdname(conf->mddev), STRIPE_SECTORS,
 			       (unsigned long long)sh->sector + rdev->data_offset,
 			       bdevname(rdev->bdev, b));
-			clear_bit(R5_ReadError, &sh->dev[i].flags);
-			clear_bit(R5_ReWrite, &sh->dev[i].flags);
+			clear_bit(R5_ReadError, &sq->dev[i].flags);
+			clear_bit(R5_ReWrite, &sq->dev[i].flags);
 		}
 		if (atomic_read(&conf->disks[i].rdev->read_errors))
 			atomic_set(&conf->disks[i].rdev->read_errors, 0);
@@ -1156,14 +1232,14 @@ static int raid5_end_read_request(struct
 		int retry = 0;
 		rdev = conf->disks[i].rdev;
 
-		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
+		clear_bit(R5_UPTODATE, &sq->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
 		if (conf->mddev->degraded)
 			printk(KERN_WARNING "raid5:%s: read error not correctable (sector %llu on %s).\n",
 			       mdname(conf->mddev),
 			       (unsigned long long)sh->sector + rdev->data_offset,
 			       bdn);
-		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
+		else if (test_bit(R5_ReWrite, &sq->dev[i].flags))
 			/* Oh, no!!! */
 			printk(KERN_WARNING "raid5:%s: read error NOT corrected!! (sector %llu on %s).\n",
 			       mdname(conf->mddev),
@@ -1177,15 +1253,15 @@ static int raid5_end_read_request(struct
 		else
 			retry = 1;
 		if (retry)
-			set_bit(R5_ReadError, &sh->dev[i].flags);
+			set_bit(R5_ReadError, &sq->dev[i].flags);
 		else {
-			clear_bit(R5_ReadError, &sh->dev[i].flags);
-			clear_bit(R5_ReWrite, &sh->dev[i].flags);
+			clear_bit(R5_ReadError, &sq->dev[i].flags);
+			clear_bit(R5_ReWrite, &sq->dev[i].flags);
 			md_error(conf->mddev, rdev);
 		}
 	}
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
-	clear_bit(R5_LOCKED, &sh->dev[i].flags);
+	clear_bit(R5_LOCKED, &sq->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 	return 0;
@@ -1195,7 +1271,8 @@ static int raid5_end_write_request (stru
 				    int error)
 {
  	struct stripe_head *sh = bi->bi_private;
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
@@ -1219,18 +1296,16 @@ static int raid5_end_write_request (stru
 
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 	
-	clear_bit(R5_LOCKED, &sh->dev[i].flags);
+	clear_bit(R5_LOCKED, &sq->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 	return 0;
 }
 
-
-static sector_t compute_blocknr(struct stripe_head *sh, int i);
-	
 static void raid5_build_block (struct stripe_head *sh, int i)
 {
 	struct r5dev *dev = &sh->dev[i];
+	struct r5_queue_dev *dev_q = &sh->sq->dev[i];
 
 	bio_init(&dev->req);
 	dev->req.bi_io_vec = &dev->vec;
@@ -1243,8 +1318,9 @@ static void raid5_build_block (struct st
 	dev->req.bi_sector = sh->sector;
 	dev->req.bi_private = sh;
 
-	dev->flags = 0;
-	dev->sector = compute_blocknr(sh, i);
+	dev_q->flags = 0;
+	dev_q->sector = compute_blocknr(sh->sq->raid_conf, sh->disks,
+			sh->sector, sh->sq->pd_idx, i);
 }
 
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
@@ -1379,12 +1455,12 @@ static sector_t raid5_compute_sector(sec
 }
 
 
-static sector_t compute_blocknr(struct stripe_head *sh, int i)
+static sector_t
+compute_blocknr(raid5_conf_t *conf, int raid_disks, sector_t sector,
+	int pd_idx, int i)
 {
-	raid5_conf_t *conf = sh->raid_conf;
-	int raid_disks = sh->disks;
 	int data_disks = raid_disks - conf->max_degraded;
-	sector_t new_sector = sh->sector, check;
+	sector_t new_sector = sector, check;
 	int sectors_per_chunk = conf->chunk_size >> 9;
 	sector_t stripe;
 	int chunk_offset;
@@ -1396,7 +1472,7 @@ static sector_t compute_blocknr(struct s
 	stripe = new_sector;
 	BUG_ON(new_sector != stripe);
 
-	if (i == sh->pd_idx)
+	if (i == pd_idx)
 		return 0;
 	switch(conf->level) {
 	case 4: break;
@@ -1404,14 +1480,14 @@ static sector_t compute_blocknr(struct s
 		switch (conf->algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
 		case ALGORITHM_RIGHT_ASYMMETRIC:
-			if (i > sh->pd_idx)
+			if (i > pd_idx)
 				i--;
 			break;
 		case ALGORITHM_LEFT_SYMMETRIC:
 		case ALGORITHM_RIGHT_SYMMETRIC:
-			if (i < sh->pd_idx)
+			if (i < pd_idx)
 				i += raid_disks;
-			i -= (sh->pd_idx + 1);
+			i -= (pd_idx + 1);
 			break;
 		default:
 			printk(KERN_ERR "raid5: unsupported algorithm %d\n",
@@ -1419,25 +1495,25 @@ static sector_t compute_blocknr(struct s
 		}
 		break;
 	case 6:
-		if (i == raid6_next_disk(sh->pd_idx, raid_disks))
+		if (i == raid6_next_disk(pd_idx, raid_disks))
 			return 0; /* It is the Q disk */
 		switch (conf->algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
 		case ALGORITHM_RIGHT_ASYMMETRIC:
-		  	if (sh->pd_idx == raid_disks-1)
-				i--; 	/* Q D D D P */
-			else if (i > sh->pd_idx)
+			if (pd_idx == raid_disks-1)
+				i--;	/* Q D D D P */
+			else if (i > pd_idx)
 				i -= 2; /* D D P Q D */
 			break;
 		case ALGORITHM_LEFT_SYMMETRIC:
 		case ALGORITHM_RIGHT_SYMMETRIC:
-			if (sh->pd_idx == raid_disks-1)
+			if (pd_idx == raid_disks-1)
 				i--; /* Q D D D P */
 			else {
 				/* D D P Q D */
-				if (i < sh->pd_idx)
+				if (i < pd_idx)
 					i += raid_disks;
-				i -= (sh->pd_idx + 2);
+				i -= (pd_idx + 2);
 			}
 			break;
 		default:
@@ -1451,7 +1527,7 @@ static sector_t compute_blocknr(struct s
 	r_sector = (sector_t)chunk_number * sectors_per_chunk + chunk_offset;
 
 	check = raid5_compute_sector (r_sector, raid_disks, data_disks, &dummy1, &dummy2, conf);
-	if (check != sh->sector || dummy1 != dd_idx || dummy2 != sh->pd_idx) {
+	if (check != sector || dummy1 != dd_idx || dummy2 != pd_idx) {
 		printk(KERN_ERR "compute_blocknr: map not correct\n");
 		return 0;
 	}
@@ -1518,8 +1594,9 @@ static void copy_data(int frombio, struc
 
 static void compute_parity6(struct stripe_head *sh, int method)
 {
-	raid6_conf_t *conf = sh->raid_conf;
-	int i, pd_idx = sh->pd_idx, qd_idx, d0_idx, disks = sh->disks, count;
+	struct stripe_queue *sq = sh->sq;
+	raid6_conf_t *conf = sq->raid_conf;
+	int i, pd_idx = sq->pd_idx, qd_idx, d0_idx, disks = sh->disks, count;
 	struct bio *chosen;
 	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
 	void *ptrs[disks];
@@ -1535,11 +1612,12 @@ static void compute_parity6(struct strip
 		BUG();		/* READ_MODIFY_WRITE N/A for RAID-6 */
 	case RECONSTRUCT_WRITE:
 		for (i= disks; i-- ;)
-			if ( i != pd_idx && i != qd_idx && sh->dev[i].towrite ) {
-				chosen = sh->dev[i].towrite;
-				sh->dev[i].towrite = NULL;
+			if (i != pd_idx && i != qd_idx && sq->dev[i].towrite) {
+				chosen = sq->dev[i].towrite;
+				sq->dev[i].towrite = NULL;
 
-				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+				if (test_and_clear_bit(R5_Overlap,
+							&sq->dev[i].flags))
 					wake_up(&conf->wait_for_overlap);
 
 				BUG_ON(sh->dev[i].written);
@@ -1550,17 +1628,17 @@ static void compute_parity6(struct strip
 		BUG();		/* Not implemented yet */
 	}
 
-	for (i = disks; i--;)
+	for (i = disks; i--; )
 		if (sh->dev[i].written) {
-			sector_t sector = sh->dev[i].sector;
+			sector_t sector = sq->dev[i].sector;
 			struct bio *wbi = sh->dev[i].written;
 			while (wbi && wbi->bi_sector < sector + STRIPE_SECTORS) {
 				copy_data(1, wbi, sh->dev[i].page, sector);
 				wbi = r5_next_bio(wbi, sector);
 			}
 
-			set_bit(R5_LOCKED, &sh->dev[i].flags);
-			set_bit(R5_UPTODATE, &sh->dev[i].flags);
+			set_bit(R5_LOCKED, &sq->dev[i].flags);
+			set_bit(R5_UPTODATE, &sq->dev[i].flags);
 		}
 
 //	switch(method) {
@@ -1573,7 +1651,8 @@ static void compute_parity6(struct strip
 		i = d0_idx;
 		do {
 			ptrs[count++] = page_address(sh->dev[i].page);
-			if (count <= disks-2 && !test_bit(R5_UPTODATE, &sh->dev[i].flags))
+			if (count <= disks-2 &&
+			    !test_bit(R5_UPTODATE, &sq->dev[i].flags))
 				printk("block %d/%d not uptodate on parity calc\n", i,count);
 			i = raid6_next_disk(i, disks);
 		} while ( i != d0_idx );
@@ -1584,14 +1663,14 @@ static void compute_parity6(struct strip
 
 	switch(method) {
 	case RECONSTRUCT_WRITE:
-		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
-		set_bit(R5_UPTODATE, &sh->dev[qd_idx].flags);
-		set_bit(R5_LOCKED,   &sh->dev[pd_idx].flags);
-		set_bit(R5_LOCKED,   &sh->dev[qd_idx].flags);
+		set_bit(R5_UPTODATE, &sq->dev[pd_idx].flags);
+		set_bit(R5_UPTODATE, &sq->dev[qd_idx].flags);
+		set_bit(R5_LOCKED,   &sq->dev[pd_idx].flags);
+		set_bit(R5_LOCKED,   &sq->dev[qd_idx].flags);
 		break;
 	case UPDATE_PARITY:
-		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
-		set_bit(R5_UPTODATE, &sh->dev[qd_idx].flags);
+		set_bit(R5_UPTODATE, &sq->dev[pd_idx].flags);
+		set_bit(R5_UPTODATE, &sq->dev[qd_idx].flags);
 		break;
 	}
 }
@@ -1600,9 +1679,10 @@ static void compute_parity6(struct strip
 /* Compute one missing block */
 static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 {
+	struct stripe_queue *sq = sh->sq;
 	int i, count, disks = sh->disks;
 	void *ptr[MAX_XOR_BLOCKS], *dest, *p;
-	int pd_idx = sh->pd_idx;
+	int pd_idx = sq->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 
 	pr_debug("compute_block_1, stripe %llu, idx %d\n",
@@ -1619,7 +1699,7 @@ static void compute_block_1(struct strip
 			if (i == dd_idx || i == qd_idx)
 				continue;
 			p = page_address(sh->dev[i].page);
-			if (test_bit(R5_UPTODATE, &sh->dev[i].flags))
+			if (test_bit(R5_UPTODATE, &sq->dev[i].flags))
 				ptr[count++] = p;
 			else
 				printk("compute_block() %d, stripe %llu, %d"
@@ -1630,8 +1710,10 @@ static void compute_block_1(struct strip
 		}
 		if (count)
 			xor_blocks(count, STRIPE_SIZE, dest, ptr);
-		if (!nozero) set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
-		else clear_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
+		if (!nozero)
+			set_bit(R5_UPTODATE, &sq->dev[dd_idx].flags);
+		else
+			clear_bit(R5_UPTODATE, &sq->dev[dd_idx].flags);
 	}
 }
 
@@ -1639,7 +1721,7 @@ static void compute_block_1(struct strip
 static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 {
 	int i, count, disks = sh->disks;
-	int pd_idx = sh->pd_idx;
+	int pd_idx = sh->sq->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 	int d0_idx = raid6_next_disk(qd_idx, disks);
 	int faila, failb;
@@ -1671,6 +1753,7 @@ static void compute_block_2(struct strip
 
 	/* We're missing D+P or D+D; build pointer table */
 	{
+		struct stripe_queue *sq = sh->sq;
 		/**** FIX THIS: This could be very bad if disks is close to 256 ****/
 		void *ptrs[disks];
 
@@ -1680,7 +1763,7 @@ static void compute_block_2(struct strip
 			ptrs[count++] = page_address(sh->dev[i].page);
 			i = raid6_next_disk(i, disks);
 			if (i != dd_idx1 && i != dd_idx2 &&
-			    !test_bit(R5_UPTODATE, &sh->dev[i].flags))
+			    !test_bit(R5_UPTODATE, &sq->dev[i].flags))
 				printk("compute_2 with missing block %d/%d\n", count, i);
 		} while ( i != d0_idx );
 
@@ -1693,16 +1776,17 @@ static void compute_block_2(struct strip
 		}
 
 		/* Both the above update both missing blocks */
-		set_bit(R5_UPTODATE, &sh->dev[dd_idx1].flags);
-		set_bit(R5_UPTODATE, &sh->dev[dd_idx2].flags);
+		set_bit(R5_UPTODATE, &sq->dev[dd_idx1].flags);
+		set_bit(R5_UPTODATE, &sq->dev[dd_idx2].flags);
 	}
 }
 
 static int
 handle_write_operations5(struct stripe_head *sh, int rcw, int expand)
 {
-	int i, pd_idx = sh->pd_idx, disks = sh->disks;
 	int locked = 0;
+	struct stripe_queue *sq = sh->sq;
+	int i, pd_idx = sq->pd_idx, disks = sh->disks;
 
 	if (rcw) {
 		/* if we are not expanding this is a proper write request, and
@@ -1718,18 +1802,18 @@ handle_write_operations5(struct stripe_h
 		sh->ops.count++;
 
 		for (i = disks; i--; ) {
-			struct r5dev *dev = &sh->dev[i];
+			struct r5_queue_dev *dev_q = &sq->dev[i];
 
-			if (dev->towrite) {
-				set_bit(R5_LOCKED, &dev->flags);
+			if (dev_q->towrite) {
+				set_bit(R5_LOCKED, &dev_q->flags);
 				if (!expand)
-					clear_bit(R5_UPTODATE, &dev->flags);
+					clear_bit(R5_UPTODATE, &dev_q->flags);
 				locked++;
 			}
 		}
 	} else {
-		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
-			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
+		BUG_ON(!(test_bit(R5_UPTODATE, &sq->dev[pd_idx].flags) ||
+			test_bit(R5_Wantcompute, &sq->dev[pd_idx].flags)));
 
 		set_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
 		set_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
@@ -1738,7 +1822,7 @@ handle_write_operations5(struct stripe_h
 		sh->ops.count += 3;
 
 		for (i = disks; i--; ) {
-			struct r5dev *dev = &sh->dev[i];
+			struct r5_queue_dev *dev_q = &sq->dev[i];
 			if (i == pd_idx)
 				continue;
 
@@ -1747,12 +1831,12 @@ handle_write_operations5(struct stripe_h
 			 * written so we distinguish these blocks by the
 			 * R5_Wantprexor bit
 			 */
-			if (dev->towrite &&
-			    (test_bit(R5_UPTODATE, &dev->flags) ||
-			    test_bit(R5_Wantcompute, &dev->flags))) {
-				set_bit(R5_Wantprexor, &dev->flags);
-				set_bit(R5_LOCKED, &dev->flags);
-				clear_bit(R5_UPTODATE, &dev->flags);
+			if (dev_q->towrite &&
+			    (test_bit(R5_UPTODATE, &dev_q->flags) ||
+			    test_bit(R5_Wantcompute, &dev_q->flags))) {
+				set_bit(R5_Wantprexor, &dev_q->flags);
+				set_bit(R5_LOCKED, &dev_q->flags);
+				clear_bit(R5_UPTODATE, &dev_q->flags);
 				locked++;
 			}
 		}
@@ -1761,8 +1845,8 @@ handle_write_operations5(struct stripe_h
 	/* keep the parity disk locked while asynchronous operations
 	 * are in flight
 	 */
-	set_bit(R5_LOCKED, &sh->dev[pd_idx].flags);
-	clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+	set_bit(R5_LOCKED, &sq->dev[pd_idx].flags);
+	clear_bit(R5_UPTODATE, &sq->dev[pd_idx].flags);
 	locked++;
 
 	pr_debug("%s: stripe %llu locked: %d pending: %lx\n",
@@ -1780,7 +1864,8 @@ handle_write_operations5(struct stripe_h
 static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
 {
 	struct bio **bip;
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int firstwrite=0;
 
 	pr_debug("adding bh b#%llu to stripe s#%llu\n",
@@ -1788,14 +1873,14 @@ static int add_stripe_bio(struct stripe_
 		(unsigned long long)sh->sector);
 
 
-	spin_lock(&sh->lock);
+	spin_lock(&sq->lock);
 	spin_lock_irq(&conf->device_lock);
 	if (forwrite) {
-		bip = &sh->dev[dd_idx].towrite;
+		bip = &sq->dev[dd_idx].towrite;
 		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
 			firstwrite = 1;
 	} else
-		bip = &sh->dev[dd_idx].toread;
+		bip = &sq->dev[dd_idx].toread;
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
 		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
 			goto overlap;
@@ -1810,7 +1895,7 @@ static int add_stripe_bio(struct stripe_
 	*bip = bi;
 	bi->bi_phys_segments ++;
 	spin_unlock_irq(&conf->device_lock);
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)bi->bi_sector,
@@ -1819,29 +1904,29 @@ static int add_stripe_bio(struct stripe_
 	if (conf->mddev->bitmap && firstwrite) {
 		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
 				  STRIPE_SECTORS, 0);
-		sh->bm_seq = conf->seq_flush+1;
+		sq->bm_seq = conf->seq_flush+1;
 		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
 
 	if (forwrite) {
 		/* check if page is covered */
-		sector_t sector = sh->dev[dd_idx].sector;
-		for (bi=sh->dev[dd_idx].towrite;
-		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
+		sector_t sector = sq->dev[dd_idx].sector;
+		for (bi = sq->dev[dd_idx].towrite;
+		     sector < sq->dev[dd_idx].sector + STRIPE_SECTORS &&
 			     bi && bi->bi_sector <= sector;
-		     bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
+		     bi = r5_next_bio(bi, sq->dev[dd_idx].sector)) {
 			if (bi->bi_sector + (bi->bi_size>>9) >= sector)
 				sector = bi->bi_sector + (bi->bi_size>>9);
 		}
-		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
-			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
+		if (sector >= sq->dev[dd_idx].sector + STRIPE_SECTORS)
+			set_bit(R5_OVERWRITE, &sq->dev[dd_idx].flags);
 	}
 	return 1;
 
  overlap:
-	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
+	set_bit(R5_Overlap, &sq->dev[dd_idx].flags);
 	spin_unlock_irq(&conf->device_lock);
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 	return 0;
 }
 
@@ -1873,11 +1958,13 @@ handle_requests_to_failed_array(raid5_co
 				struct bio **return_bi)
 {
 	int i;
+	struct stripe_queue *sq = sh->sq;
+
 	for (i = disks; i--; ) {
 		struct bio *bi;
 		int bitmap_end = 0;
 
-		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
+		if (test_bit(R5_ReadError, &sq->dev[i].flags)) {
 			mdk_rdev_t *rdev;
 			rcu_read_lock();
 			rdev = rcu_dereference(conf->disks[i].rdev);
@@ -1888,19 +1975,19 @@ handle_requests_to_failed_array(raid5_co
 		}
 		spin_lock_irq(&conf->device_lock);
 		/* fail all writes first */
-		bi = sh->dev[i].towrite;
-		sh->dev[i].towrite = NULL;
+		bi = sq->dev[i].towrite;
+		sq->dev[i].towrite = NULL;
 		if (bi) {
 			s->to_write--;
 			bitmap_end = 1;
 		}
 
-		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+		if (test_and_clear_bit(R5_Overlap, &sq->dev[i].flags))
 			wake_up(&conf->wait_for_overlap);
 
 		while (bi && bi->bi_sector <
-			sh->dev[i].sector + STRIPE_SECTORS) {
-			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
+			sq->dev[i].sector + STRIPE_SECTORS) {
+			struct bio *nextbi = r5_next_bio(bi, sq->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (--bi->bi_phys_segments == 0) {
 				md_write_end(conf->mddev);
@@ -1914,8 +2001,8 @@ handle_requests_to_failed_array(raid5_co
 		sh->dev[i].written = NULL;
 		if (bi) bitmap_end = 1;
 		while (bi && bi->bi_sector <
-		       sh->dev[i].sector + STRIPE_SECTORS) {
-			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
+		       sq->dev[i].sector + STRIPE_SECTORS) {
+			struct bio *bi2 = r5_next_bio(bi, sq->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (--bi->bi_phys_segments == 0) {
 				md_write_end(conf->mddev);
@@ -1928,18 +2015,18 @@ handle_requests_to_failed_array(raid5_co
 		/* fail any reads if this device is non-operational and
 		 * the data has not reached the cache yet.
 		 */
-		if (!test_bit(R5_Wantfill, &sh->dev[i].flags) &&
-		    (!test_bit(R5_Insync, &sh->dev[i].flags) ||
-		      test_bit(R5_ReadError, &sh->dev[i].flags))) {
-			bi = sh->dev[i].toread;
-			sh->dev[i].toread = NULL;
-			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
+		if (!test_bit(R5_Wantfill, &sq->dev[i].flags) &&
+		    (!test_bit(R5_Insync, &sq->dev[i].flags) ||
+		      test_bit(R5_ReadError, &sq->dev[i].flags))) {
+			bi = sq->dev[i].toread;
+			sq->dev[i].toread = NULL;
+			if (test_and_clear_bit(R5_Overlap, &sq->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
 			if (bi) s->to_read--;
 			while (bi && bi->bi_sector <
-			       sh->dev[i].sector + STRIPE_SECTORS) {
+			       sq->dev[i].sector + STRIPE_SECTORS) {
 				struct bio *nextbi =
-					r5_next_bio(bi, sh->dev[i].sector);
+					r5_next_bio(bi, sq->dev[i].sector);
 				clear_bit(BIO_UPTODATE, &bi->bi_flags);
 				if (--bi->bi_phys_segments == 0) {
 					bi->bi_next = *return_bi;
@@ -1962,20 +2049,21 @@ handle_requests_to_failed_array(raid5_co
 static int __handle_issuing_new_read_requests5(struct stripe_head *sh,
 			struct stripe_head_state *s, int disk_idx, int disks)
 {
-	struct r5dev *dev = &sh->dev[disk_idx];
-	struct r5dev *failed_dev = &sh->dev[s->failed_num];
+	struct stripe_queue *sq = sh->sq;
+	struct r5_queue_dev *dev_q = &sq->dev[disk_idx];
+	struct r5_queue_dev *failed_dev = &sq->dev[s->failed_num];
 
 	/* don't schedule compute operations or reads on the parity block while
 	 * a check is in flight
 	 */
-	if ((disk_idx == sh->pd_idx) &&
+	if ((disk_idx == sq->pd_idx) &&
 	     test_bit(STRIPE_OP_CHECK, &sh->ops.pending))
 		return ~0;
 
 	/* is the data in this block needed, and can we get it? */
-	if (!test_bit(R5_LOCKED, &dev->flags) &&
-	    !test_bit(R5_UPTODATE, &dev->flags) && (dev->toread ||
-	    (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
+	if (!test_bit(R5_LOCKED, &dev_q->flags) &&
+	    !test_bit(R5_UPTODATE, &dev_q->flags) && (dev_q->toread ||
+	    (dev_q->towrite && !test_bit(R5_OVERWRITE, &dev_q->flags)) ||
 	     s->syncing || s->expanding || (s->failed &&
 	     (failed_dev->toread || (failed_dev->towrite &&
 	     !test_bit(R5_OVERWRITE, &failed_dev->flags)
@@ -1993,7 +2081,7 @@ static int __handle_issuing_new_read_req
 		if ((s->uptodate == disks - 1) &&
 		    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
-			set_bit(R5_Wantcompute, &dev->flags);
+			set_bit(R5_Wantcompute, &dev_q->flags);
 			sh->ops.target = disk_idx;
 			s->req_compute = 1;
 			sh->ops.count++;
@@ -2006,13 +2094,13 @@ static int __handle_issuing_new_read_req
 			s->uptodate++;
 			return 0; /* uptodate + compute == disks */
 		} else if ((s->uptodate < disks - 1) &&
-			test_bit(R5_Insync, &dev->flags)) {
+			test_bit(R5_Insync, &dev_q->flags)) {
 			/* Note: we hold off compute operations while checks are
 			 * in flight, but we still prefer 'compute' over 'read'
 			 * hence we only read if (uptodate < * disks-1)
 			 */
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantread, &dev->flags);
+			set_bit(R5_LOCKED, &dev_q->flags);
+			set_bit(R5_Wantread, &dev_q->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
 			s->locked++;
@@ -2060,18 +2148,19 @@ static void handle_issuing_new_read_requ
 			int disks)
 {
 	int i;
+	struct stripe_queue *sq = sh->sq;
 	for (i = disks; i--; ) {
-		struct r5dev *dev = &sh->dev[i];
-		if (!test_bit(R5_LOCKED, &dev->flags) &&
-		    !test_bit(R5_UPTODATE, &dev->flags) &&
-		    (dev->toread || (dev->towrite &&
-		     !test_bit(R5_OVERWRITE, &dev->flags)) ||
+		struct r5_queue_dev *dev_q = &sq->dev[i];
+		if (!test_bit(R5_LOCKED, &dev_q->flags) &&
+		    !test_bit(R5_UPTODATE, &dev_q->flags) &&
+		    (dev_q->toread || (dev_q->towrite &&
+		     !test_bit(R5_OVERWRITE, &dev_q->flags)) ||
 		     s->syncing || s->expanding ||
 		     (s->failed >= 1 &&
-		      (sh->dev[r6s->failed_num[0]].toread ||
+		      (sq->dev[r6s->failed_num[0]].toread ||
 		       s->to_write)) ||
 		     (s->failed >= 2 &&
-		      (sh->dev[r6s->failed_num[1]].toread ||
+		      (sq->dev[r6s->failed_num[1]].toread ||
 		       s->to_write)))) {
 			/* we would like to get this block, possibly
 			 * by computing it, but we might not be able to
@@ -2090,7 +2179,7 @@ static void handle_issuing_new_read_requ
 					if (other == i)
 						continue;
 					if (!test_bit(R5_UPTODATE,
-					      &sh->dev[other].flags))
+					      &sq->dev[other].flags))
 						break;
 				}
 				BUG_ON(other < 0);
@@ -2099,9 +2188,9 @@ static void handle_issuing_new_read_requ
 				       i, other);
 				compute_block_2(sh, i, other);
 				s->uptodate += 2;
-			} else if (test_bit(R5_Insync, &dev->flags)) {
-				set_bit(R5_LOCKED, &dev->flags);
-				set_bit(R5_Wantread, &dev->flags);
+			} else if (test_bit(R5_Insync, &dev_q->flags)) {
+				set_bit(R5_LOCKED, &dev_q->flags);
+				set_bit(R5_Wantread, &dev_q->flags);
 				s->locked++;
 				pr_debug("Reading block %d (sync=%d)\n",
 					i, s->syncing);
@@ -2121,13 +2210,14 @@ static void handle_completed_write_reque
 	struct stripe_head *sh, int disks, struct bio **return_bi)
 {
 	int i;
-	struct r5dev *dev;
+	struct stripe_queue *sq = sh->sq;
 
 	for (i = disks; i--; )
 		if (sh->dev[i].written) {
-			dev = &sh->dev[i];
-			if (!test_bit(R5_LOCKED, &dev->flags) &&
-				test_bit(R5_UPTODATE, &dev->flags)) {
+			struct r5dev *dev = &sh->dev[i];
+			struct r5_queue_dev *dev_q = &sq->dev[i];
+			if (!test_bit(R5_LOCKED, &dev_q->flags) &&
+				test_bit(R5_UPTODATE, &dev_q->flags)) {
 				/* We can return any write requests */
 				struct bio *wbi, *wbi2;
 				int bitmap_end = 0;
@@ -2136,8 +2226,8 @@ static void handle_completed_write_reque
 				wbi = dev->written;
 				dev->written = NULL;
 				while (wbi && wbi->bi_sector <
-					dev->sector + STRIPE_SECTORS) {
-					wbi2 = r5_next_bio(wbi, dev->sector);
+					dev_q->sector + STRIPE_SECTORS) {
+					wbi2 = r5_next_bio(wbi, dev_q->sector);
 					if (--wbi->bi_phys_segments == 0) {
 						md_write_end(conf->mddev);
 						wbi->bi_next = *return_bi;
@@ -2145,7 +2235,7 @@ static void handle_completed_write_reque
 					}
 					wbi = wbi2;
 				}
-				if (dev->towrite == NULL)
+				if (dev_q->towrite == NULL)
 					bitmap_end = 1;
 				spin_unlock_irq(&conf->device_lock);
 				if (bitmap_end)
@@ -2162,24 +2252,25 @@ static void handle_issuing_new_write_req
 		struct stripe_head *sh,	struct stripe_head_state *s, int disks)
 {
 	int rmw = 0, rcw = 0, i;
+	struct stripe_queue *sq = sh->sq;
 	for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
-		struct r5dev *dev = &sh->dev[i];
-		if ((dev->towrite || i == sh->pd_idx) &&
-		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		      test_bit(R5_Wantcompute, &dev->flags))) {
-			if (test_bit(R5_Insync, &dev->flags))
+		struct r5_queue_dev *dev_q = &sq->dev[i];
+		if ((dev_q->towrite || i == sq->pd_idx) &&
+		    !test_bit(R5_LOCKED, &dev_q->flags) &&
+		    !(test_bit(R5_UPTODATE, &dev_q->flags) ||
+		      test_bit(R5_Wantcompute, &dev_q->flags))) {
+			if (test_bit(R5_Insync, &dev_q->flags))
 				rmw++;
 			else
 				rmw += 2*disks;  /* cannot read it */
 		}
 		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sh->pd_idx &&
-		    !test_bit(R5_LOCKED, &dev->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev->flags) ||
-		    test_bit(R5_Wantcompute, &dev->flags))) {
-			if (test_bit(R5_Insync, &dev->flags)) rcw++;
+		if (!test_bit(R5_OVERWRITE, &dev_q->flags) && i != sq->pd_idx &&
+		    !test_bit(R5_LOCKED, &dev_q->flags) &&
+		    !(test_bit(R5_UPTODATE, &dev_q->flags) ||
+		    test_bit(R5_Wantcompute, &dev_q->flags))) {
+			if (test_bit(R5_Insync, &dev_q->flags)) rcw++;
 			else
 				rcw += 2*disks;
 		}
@@ -2190,18 +2281,18 @@ static void handle_issuing_new_write_req
 	if (rmw < rcw && rmw > 0)
 		/* prefer read-modify-write, but need to get some data */
 		for (i = disks; i--; ) {
-			struct r5dev *dev = &sh->dev[i];
-			if ((dev->towrite || i == sh->pd_idx) &&
-			    !test_bit(R5_LOCKED, &dev->flags) &&
-			    !(test_bit(R5_UPTODATE, &dev->flags) ||
-			    test_bit(R5_Wantcompute, &dev->flags)) &&
-			    test_bit(R5_Insync, &dev->flags)) {
+			struct r5_queue_dev *dev_q = &sq->dev[i];
+			if ((dev_q->towrite || i == sq->pd_idx) &&
+			    !test_bit(R5_LOCKED, &dev_q->flags) &&
+			    !(test_bit(R5_UPTODATE, &dev_q->flags) ||
+			    test_bit(R5_Wantcompute, &dev_q->flags)) &&
+			    test_bit(R5_Insync, &dev_q->flags)) {
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 					pr_debug("Read_old block "
 						"%d for r-m-w\n", i);
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
+					set_bit(R5_LOCKED, &dev_q->flags);
+					set_bit(R5_Wantread, &dev_q->flags);
 					if (!test_and_set_bit(
 						STRIPE_OP_IO, &sh->ops.pending))
 						sh->ops.count++;
@@ -2215,19 +2306,19 @@ static void handle_issuing_new_write_req
 	if (rcw <= rmw && rcw > 0)
 		/* want reconstruct write, but need to get some data */
 		for (i = disks; i--; ) {
-			struct r5dev *dev = &sh->dev[i];
-			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
-			    i != sh->pd_idx &&
-			    !test_bit(R5_LOCKED, &dev->flags) &&
-			    !(test_bit(R5_UPTODATE, &dev->flags) ||
-			    test_bit(R5_Wantcompute, &dev->flags)) &&
-			    test_bit(R5_Insync, &dev->flags)) {
+			struct r5_queue_dev *dev_q = &sq->dev[i];
+			if (!test_bit(R5_OVERWRITE, &dev_q->flags) &&
+			    i != sq->pd_idx &&
+			    !test_bit(R5_LOCKED, &dev_q->flags) &&
+			    !(test_bit(R5_UPTODATE, &dev_q->flags) ||
+			    test_bit(R5_Wantcompute, &dev_q->flags)) &&
+			    test_bit(R5_Insync, &dev_q->flags)) {
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 					pr_debug("Read_old block "
 						"%d for Reconstruct\n", i);
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
+					set_bit(R5_LOCKED, &dev_q->flags);
+					set_bit(R5_Wantread, &dev_q->flags);
 					if (!test_and_set_bit(
 						STRIPE_OP_IO, &sh->ops.pending))
 						sh->ops.count++;
@@ -2259,20 +2350,22 @@ static void handle_issuing_new_write_req
 		struct stripe_head *sh,	struct stripe_head_state *s,
 		struct r6_state *r6s, int disks)
 {
-	int rcw = 0, must_compute = 0, pd_idx = sh->pd_idx, i;
+	struct stripe_queue *sq = sh->sq;
+	int rcw = 0, must_compute = 0, pd_idx = sq->pd_idx, i;
 	int qd_idx = r6s->qd_idx;
+
 	for (i = disks; i--; ) {
-		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev->flags)
+		if (!test_bit(R5_OVERWRITE, &dev_q->flags)
 		    && i != pd_idx && i != qd_idx
-		    && (!test_bit(R5_LOCKED, &dev->flags)
+		    && (!test_bit(R5_LOCKED, &dev_q->flags)
 			    ) &&
-		    !test_bit(R5_UPTODATE, &dev->flags)) {
-			if (test_bit(R5_Insync, &dev->flags)) rcw++;
+		    !test_bit(R5_UPTODATE, &dev_q->flags)) {
+			if (test_bit(R5_Insync, &dev_q->flags)) rcw++;
 			else {
 				pr_debug("raid6: must_compute: "
-					"disk %d flags=%#lx\n", i, dev->flags);
+				   "disk %d flags=%#lx\n", i, dev_q->flags);
 				must_compute++;
 			}
 		}
@@ -2284,19 +2377,19 @@ static void handle_issuing_new_write_req
 	if (rcw > 0)
 		/* want reconstruct write, but need to get some data */
 		for (i = disks; i--; ) {
-			struct r5dev *dev = &sh->dev[i];
-			if (!test_bit(R5_OVERWRITE, &dev->flags)
+			struct r5_queue_dev *dev_q = &sq->dev[i];
+			if (!test_bit(R5_OVERWRITE, &dev_q->flags)
 			    && !(s->failed == 0 && (i == pd_idx || i == qd_idx))
-			    && !test_bit(R5_LOCKED, &dev->flags) &&
-			    !test_bit(R5_UPTODATE, &dev->flags) &&
-			    test_bit(R5_Insync, &dev->flags)) {
+			    && !test_bit(R5_LOCKED, &dev_q->flags) &&
+			    !test_bit(R5_UPTODATE, &dev_q->flags) &&
+			    test_bit(R5_Insync, &dev_q->flags)) {
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 					pr_debug("Read_old stripe %llu "
 						"block %d for Reconstruct\n",
 					     (unsigned long long)sh->sector, i);
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
+					set_bit(R5_LOCKED, &dev_q->flags);
+					set_bit(R5_Wantread, &dev_q->flags);
 					s->locked++;
 				} else {
 					pr_debug("Request delayed stripe %llu "
@@ -2334,11 +2427,11 @@ static void handle_issuing_new_write_req
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		/* now every locked buffer is ready to be written */
 		for (i = disks; i--; )
-			if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
+			if (test_bit(R5_LOCKED, &sq->dev[i].flags)) {
 				pr_debug("Writing stripe %llu block %d\n",
 				       (unsigned long long)sh->sector, i);
 				s->locked++;
-				set_bit(R5_Wantwrite, &sh->dev[i].flags);
+				set_bit(R5_Wantwrite, &sq->dev[i].flags);
 			}
 		/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
 		set_bit(STRIPE_INSYNC, &sh->state);
@@ -2346,7 +2439,7 @@ static void handle_issuing_new_write_req
 		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 			atomic_dec(&conf->preread_active_stripes);
 			if (atomic_read(&conf->preread_active_stripes) <
-			    IO_THRESHOLD)
+				IO_THRESHOLD)
 				md_wakeup_thread(conf->mddev->thread);
 		}
 	}
@@ -2355,6 +2448,8 @@ static void handle_issuing_new_write_req
 static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 				struct stripe_head_state *s, int disks)
 {
+	struct stripe_queue *sq = sh->sq;
+
 	set_bit(STRIPE_HANDLE, &sh->state);
 	/* Take one of the following actions:
 	 * 1/ start a check parity operation if (uptodate == disks)
@@ -2366,7 +2461,7 @@ static void handle_parity_checks5(raid5_
 	    !test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
 		if (!test_and_set_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 			BUG_ON(s->uptodate != disks);
-			clear_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags);
+			clear_bit(R5_UPTODATE, &sq->dev[sq->pd_idx].flags);
 			sh->ops.count++;
 			s->uptodate--;
 		} else if (
@@ -2392,8 +2487,8 @@ static void handle_parity_checks5(raid5_
 					set_bit(STRIPE_OP_MOD_REPAIR_PD,
 						&sh->ops.pending);
 					set_bit(R5_Wantcompute,
-						&sh->dev[sh->pd_idx].flags);
-					sh->ops.target = sh->pd_idx;
+						&sq->dev[sq->pd_idx].flags);
+					sh->ops.target = sq->pd_idx;
 					sh->ops.count++;
 					s->uptodate++;
 				}
@@ -2417,16 +2512,16 @@ static void handle_parity_checks5(raid5_
 	if (!test_bit(STRIPE_INSYNC, &sh->state) &&
 		!test_bit(STRIPE_OP_CHECK, &sh->ops.pending) &&
 		!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
-		struct r5dev *dev;
+		struct r5_queue_dev *dev_q;
 		/* either failed parity check, or recovery is happening */
 		if (s->failed == 0)
-			s->failed_num = sh->pd_idx;
-		dev = &sh->dev[s->failed_num];
-		BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
+			s->failed_num = sq->pd_idx;
+		dev_q = &sq->dev[s->failed_num];
+		BUG_ON(!test_bit(R5_UPTODATE, &dev_q->flags));
 		BUG_ON(s->uptodate != disks);
 
-		set_bit(R5_LOCKED, &dev->flags);
-		set_bit(R5_Wantwrite, &dev->flags);
+		set_bit(R5_LOCKED, &dev_q->flags);
+		set_bit(R5_Wantwrite, &dev_q->flags);
 		if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 			sh->ops.count++;
 
@@ -2443,8 +2538,9 @@ static void handle_parity_checks6(raid5_
 				int disks)
 {
 	int update_p = 0, update_q = 0;
-	struct r5dev *dev;
-	int pd_idx = sh->pd_idx;
+	struct stripe_queue *sq = sh->sq;
+	struct r5_queue_dev *dev_q;
+	int pd_idx = sq->pd_idx;
 	int qd_idx = r6s->qd_idx;
 
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -2500,29 +2596,29 @@ static void handle_parity_checks6(raid5_
 		 */
 
 		if (s->failed == 2) {
-			dev = &sh->dev[r6s->failed_num[1]];
+			dev_q = &sq->dev[r6s->failed_num[1]];
 			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
+			set_bit(R5_LOCKED, &dev_q->flags);
+			set_bit(R5_Wantwrite, &dev_q->flags);
 		}
 		if (s->failed >= 1) {
-			dev = &sh->dev[r6s->failed_num[0]];
+			dev_q = &sq->dev[r6s->failed_num[0]];
 			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
+			set_bit(R5_LOCKED, &dev_q->flags);
+			set_bit(R5_Wantwrite, &dev_q->flags);
 		}
 
 		if (update_p) {
-			dev = &sh->dev[pd_idx];
+			dev_q = &sq->dev[pd_idx];
 			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
+			set_bit(R5_LOCKED, &dev_q->flags);
+			set_bit(R5_Wantwrite, &dev_q->flags);
 		}
 		if (update_q) {
-			dev = &sh->dev[qd_idx];
+			dev_q = &sq->dev[qd_idx];
 			s->locked++;
-			set_bit(R5_LOCKED, &dev->flags);
-			set_bit(R5_Wantwrite, &dev->flags);
+			set_bit(R5_LOCKED, &dev_q->flags);
+			set_bit(R5_Wantwrite, &dev_q->flags);
 		}
 		clear_bit(STRIPE_DEGRADED, &sh->state);
 
@@ -2534,6 +2630,7 @@ static void handle_stripe_expansion(raid
 				struct r6_state *r6s)
 {
 	int i;
+	struct stripe_queue *sq = sh->sq;
 
 	/* We have read all the blocks in this stripe and now we need to
 	 * copy some of them into a target stripe for expand.
@@ -2541,11 +2638,12 @@ static void handle_stripe_expansion(raid
 	struct dma_async_tx_descriptor *tx = NULL;
 	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 	for (i = 0; i < sh->disks; i++)
-		if (i != sh->pd_idx && (r6s && i != r6s->qd_idx)) {
+		if (i != sq->pd_idx && (r6s && i != r6s->qd_idx)) {
 			int dd_idx, pd_idx, j;
 			struct stripe_head *sh2;
 
-			sector_t bn = compute_blocknr(sh, i);
+			sector_t bn = compute_blocknr(conf, sh->disks,
+						sh->sector, sq->pd_idx, i);
 			sector_t s = raid5_compute_sector(bn, conf->raid_disks,
 						conf->raid_disks -
 						conf->max_degraded, &dd_idx,
@@ -2559,7 +2657,7 @@ static void handle_stripe_expansion(raid
 				 */
 				continue;
 			if (!test_bit(STRIPE_EXPANDING, &sh2->state) ||
-			   test_bit(R5_Expanded, &sh2->dev[dd_idx].flags)) {
+			  test_bit(R5_Expanded, &sh2->sq->dev[dd_idx].flags)) {
 				/* must have already done this block */
 				release_stripe(sh2);
 				continue;
@@ -2570,12 +2668,13 @@ static void handle_stripe_expansion(raid
 				sh->dev[i].page, 0, 0, STRIPE_SIZE,
 				ASYNC_TX_DEP_ACK, tx, NULL, NULL);
 
-			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
-			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
+			set_bit(R5_Expanded, &sh2->sq->dev[dd_idx].flags);
+			set_bit(R5_UPTODATE, &sh2->sq->dev[dd_idx].flags);
 			for (j = 0; j < conf->raid_disks; j++)
-				if (j != sh2->pd_idx &&
+				if (j != sh2->sq->pd_idx &&
 				    (r6s && j != r6s->qd_idx) &&
-				    !test_bit(R5_Expanded, &sh2->dev[j].flags))
+				    !test_bit(R5_Expanded,
+				     &sh2->sq->dev[j].flags))
 					break;
 			if (j == conf->raid_disks) {
 				set_bit(STRIPE_EXPAND_READY, &sh2->state);
@@ -2610,20 +2709,21 @@ static void handle_stripe_expansion(raid
 
 static void handle_stripe5(struct stripe_head *sh)
 {
-	raid5_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sh->sq->raid_conf;
 	int disks = sh->disks, i;
 	struct bio *return_bi = NULL;
 	struct stripe_head_state s;
-	struct r5dev *dev;
+	struct r5_queue_dev *dev_q;
 	unsigned long pending = 0;
 
 	memset(&s, 0, sizeof(s));
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d "
 		"ops=%lx:%lx:%lx\n", (unsigned long long)sh->sector, sh->state,
-		atomic_read(&sh->count), sh->pd_idx,
+		atomic_read(&sh->count), sq->pd_idx,
 		sh->ops.pending, sh->ops.ack, sh->ops.complete);
 
-	spin_lock(&sh->lock);
+	spin_lock(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
@@ -2636,33 +2736,35 @@ static void handle_stripe5(struct stripe
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
 		struct r5dev *dev = &sh->dev[i];
-		clear_bit(R5_Insync, &dev->flags);
+
+		dev_q = &sq->dev[i];
+		clear_bit(R5_Insync, &dev_q->flags);
 
 		pr_debug("check %d: state 0x%lx toread %p read %p write %p "
-			"written %p\n",	i, dev->flags, dev->toread, dev->read,
-			dev->towrite, dev->written);
+			"written %p\n",	i, dev_q->flags, dev_q->toread,
+			dev->read, dev_q->towrite, dev->written);
 
 		/* maybe we can request a biofill operation
 		 *
 		 * new wantfill requests are only permitted while
 		 * STRIPE_OP_BIOFILL is clear
 		 */
-		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread &&
+		if (test_bit(R5_UPTODATE, &dev_q->flags) && dev_q->toread &&
 			!test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
-			set_bit(R5_Wantfill, &dev->flags);
+			set_bit(R5_Wantfill, &dev_q->flags);
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
-		if (test_bit(R5_Wantcompute, &dev->flags)) s.compute++;
+		if (test_bit(R5_LOCKED, &dev_q->flags)) s.locked++;
+		if (test_bit(R5_UPTODATE, &dev_q->flags)) s.uptodate++;
+		if (test_bit(R5_Wantcompute, &dev_q->flags)) s.compute++;
 
-		if (test_bit(R5_Wantfill, &dev->flags))
+		if (test_bit(R5_Wantfill, &dev_q->flags))
 			s.to_fill++;
-		else if (dev->toread)
+		else if (dev_q->toread)
 			s.to_read++;
-		if (dev->towrite) {
+		if (dev_q->towrite) {
 			s.to_write++;
-			if (!test_bit(R5_OVERWRITE, &dev->flags))
+			if (!test_bit(R5_OVERWRITE, &dev_q->flags))
 				s.non_overwrite++;
 		}
 		if (dev->written)
@@ -2670,15 +2772,15 @@ static void handle_stripe5(struct stripe
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
-			clear_bit(R5_ReadError, &dev->flags);
-			clear_bit(R5_ReWrite, &dev->flags);
+			clear_bit(R5_ReadError, &dev_q->flags);
+			clear_bit(R5_ReWrite, &dev_q->flags);
 		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)
-		    || test_bit(R5_ReadError, &dev->flags)) {
+		    || test_bit(R5_ReadError, &dev_q->flags)) {
 			s.failed++;
 			s.failed_num = i;
 		} else
-			set_bit(R5_Insync, &dev->flags);
+			set_bit(R5_Insync, &dev_q->flags);
 	}
 	rcu_read_unlock();
 
@@ -2704,12 +2806,12 @@ static void handle_stripe5(struct stripe
 	/* might be able to return some write requests if the parity block
 	 * is safe, or on a failed drive
 	 */
-	dev = &sh->dev[sh->pd_idx];
+	dev_q = &sq->dev[sq->pd_idx];
 	if ( s.written &&
-	     ((test_bit(R5_Insync, &dev->flags) &&
-	       !test_bit(R5_LOCKED, &dev->flags) &&
-	       test_bit(R5_UPTODATE, &dev->flags)) ||
-	       (s.failed == 1 && s.failed_num == sh->pd_idx)))
+	     ((test_bit(R5_Insync, &dev_q->flags) &&
+	       !test_bit(R5_LOCKED, &dev_q->flags) &&
+	       test_bit(R5_UPTODATE, &dev_q->flags)) ||
+		(s.failed == 1 && s.failed_num == sq->pd_idx)))
 		handle_completed_write_requests(conf, sh, disks, &return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
@@ -2736,7 +2838,7 @@ static void handle_stripe5(struct stripe
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
 
 		for (i = disks; i--; )
-			clear_bit(R5_Wantprexor, &sh->dev[i].flags);
+			clear_bit(R5_Wantprexor, &sq->dev[i].flags);
 	}
 
 	/* if only POSTXOR is set then this is an 'expand' postxor */
@@ -2754,18 +2856,20 @@ static void handle_stripe5(struct stripe
 		/* All the 'written' buffers and the parity block are ready to
 		 * be written back to disk
 		 */
-		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sh->pd_idx].flags));
+		BUG_ON(!test_bit(R5_UPTODATE, &sq->dev[sq->pd_idx].flags));
 		for (i = disks; i--; ) {
-			dev = &sh->dev[i];
-			if (test_bit(R5_LOCKED, &dev->flags) &&
-				(i == sh->pd_idx || dev->written)) {
+			struct r5dev *dev = &sh->dev[i];
+
+			dev_q = &sq->dev[i];
+			if (test_bit(R5_LOCKED, &dev_q->flags) &&
+				(i == sq->pd_idx || dev->written)) {
 				pr_debug("Writing block %d\n", i);
-				set_bit(R5_Wantwrite, &dev->flags);
+				set_bit(R5_Wantwrite, &dev_q->flags);
 				if (!test_and_set_bit(
 				    STRIPE_OP_IO, &sh->ops.pending))
 					sh->ops.count++;
-				if (!test_bit(R5_Insync, &dev->flags) ||
-				    (i == sh->pd_idx && s.failed == 0))
+				if (!test_bit(R5_Insync, &dev_q->flags) ||
+				    (i == sq->pd_idx && s.failed == 0))
 					set_bit(STRIPE_INSYNC, &sh->state);
 			}
 		}
@@ -2808,24 +2912,24 @@ static void handle_stripe5(struct stripe
 	 * the repair/check process
 	 */
 	if (s.failed == 1 && !conf->mddev->ro &&
-	    test_bit(R5_ReadError, &sh->dev[s.failed_num].flags)
-	    && !test_bit(R5_LOCKED, &sh->dev[s.failed_num].flags)
-	    && test_bit(R5_UPTODATE, &sh->dev[s.failed_num].flags)
+	    test_bit(R5_ReadError, &sq->dev[s.failed_num].flags)
+	    && !test_bit(R5_LOCKED, &sq->dev[s.failed_num].flags)
+	    && test_bit(R5_UPTODATE, &sq->dev[s.failed_num].flags)
 		) {
-		dev = &sh->dev[s.failed_num];
-		if (!test_bit(R5_ReWrite, &dev->flags)) {
-			set_bit(R5_Wantwrite, &dev->flags);
+		dev_q = &sq->dev[s.failed_num];
+		if (!test_bit(R5_ReWrite, &dev_q->flags)) {
+			set_bit(R5_Wantwrite, &dev_q->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
-			set_bit(R5_ReWrite, &dev->flags);
-			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_ReWrite, &dev_q->flags);
+			set_bit(R5_LOCKED, &dev_q->flags);
 			s.locked++;
 		} else {
 			/* let's read it back */
-			set_bit(R5_Wantread, &dev->flags);
+			set_bit(R5_Wantread, &dev_q->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
-			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_LOCKED, &dev_q->flags);
 			s.locked++;
 		}
 	}
@@ -2843,7 +2947,7 @@ static void handle_stripe5(struct stripe
 		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
 
 		for (i = conf->raid_disks; i--; ) {
-			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+			set_bit(R5_Wantwrite, &sq->dev[i].flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
 		}
@@ -2853,7 +2957,7 @@ static void handle_stripe5(struct stripe
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
+		sq->pd_idx = stripe_to_pdidx(sh->sector, conf,
 			conf->raid_disks);
 		s.locked += handle_write_operations5(sh, 0, 1);
 	} else if (s.expanded &&
@@ -2870,7 +2974,7 @@ static void handle_stripe5(struct stripe
 	if (sh->ops.count)
 		pending = get_stripe_work(sh);
 
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	if (pending)
 		raid5_run_ops(sh, pending);
@@ -2881,13 +2985,14 @@ static void handle_stripe5(struct stripe
 
 static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 {
-	raid6_conf_t *conf = sh->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid6_conf_t *conf = sq->raid_conf;
 	int disks = sh->disks;
 	struct bio *return_bi = NULL;
-	int i, pd_idx = sh->pd_idx;
+	int i, pd_idx = sq->pd_idx;
 	struct stripe_head_state s;
 	struct r6_state r6s;
-	struct r5dev *dev, *pdev, *qdev;
+	struct r5_queue_dev *dev_q, *pdev_q, *qdev_q;
 
 	r6s.qd_idx = raid6_next_disk(pd_idx, disks);
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
@@ -2896,7 +3001,7 @@ static void handle_stripe6(struct stripe
 	       atomic_read(&sh->count), pd_idx, r6s.qd_idx);
 	memset(&s, 0, sizeof(s));
 
-	spin_lock(&sh->lock);
+	spin_lock(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
@@ -2908,24 +3013,28 @@ static void handle_stripe6(struct stripe
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
-		dev = &sh->dev[i];
-		clear_bit(R5_Insync, &dev->flags);
+		struct r5dev *dev = &sh->dev[i];
+
+		dev_q = &sq->dev[i];
+		clear_bit(R5_Insync, &dev_q->flags);
 
 		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
-			i, dev->flags, dev->toread, dev->towrite, dev->written);
+			i, dev_q->flags, dev_q->toread, dev_q->towrite,
+			dev->written);
 		/* maybe we can reply to a read */
-		if (test_bit(R5_UPTODATE, &dev->flags) && dev->toread) {
+		if (test_bit(R5_UPTODATE, &dev_q->flags) && dev_q->toread) {
 			struct bio *rbi, *rbi2;
 			pr_debug("Return read for disc %d\n", i);
 			spin_lock_irq(&conf->device_lock);
-			rbi = dev->toread;
-			dev->toread = NULL;
-			if (test_and_clear_bit(R5_Overlap, &dev->flags))
+			rbi = dev_q->toread;
+			dev_q->toread = NULL;
+			if (test_and_clear_bit(R5_Overlap, &dev_q->flags))
 				wake_up(&conf->wait_for_overlap);
 			spin_unlock_irq(&conf->device_lock);
-			while (rbi && rbi->bi_sector < dev->sector + STRIPE_SECTORS) {
-				copy_data(0, rbi, dev->page, dev->sector);
-				rbi2 = r5_next_bio(rbi, dev->sector);
+			while (rbi && rbi->bi_sector <
+			       dev_q->sector + STRIPE_SECTORS) {
+				copy_data(0, rbi, dev->page, dev_q->sector);
+				rbi2 = r5_next_bio(rbi, dev_q->sector);
 				spin_lock_irq(&conf->device_lock);
 				if (--rbi->bi_phys_segments == 0) {
 					rbi->bi_next = return_bi;
@@ -2937,15 +3046,15 @@ static void handle_stripe6(struct stripe
 		}
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
+		if (test_bit(R5_LOCKED, &dev_q->flags)) s.locked++;
+		if (test_bit(R5_UPTODATE, &dev_q->flags)) s.uptodate++;
 
 
-		if (dev->toread)
+		if (dev_q->toread)
 			s.to_read++;
-		if (dev->towrite) {
+		if (dev_q->towrite) {
 			s.to_write++;
-			if (!test_bit(R5_OVERWRITE, &dev->flags))
+			if (!test_bit(R5_OVERWRITE, &dev_q->flags))
 				s.non_overwrite++;
 		}
 		if (dev->written)
@@ -2953,16 +3062,16 @@ static void handle_stripe6(struct stripe
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
-			clear_bit(R5_ReadError, &dev->flags);
-			clear_bit(R5_ReWrite, &dev->flags);
+			clear_bit(R5_ReadError, &dev_q->flags);
+			clear_bit(R5_ReWrite, &dev_q->flags);
 		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)
-		    || test_bit(R5_ReadError, &dev->flags)) {
+		    || test_bit(R5_ReadError, &dev_q->flags)) {
 			if (s.failed < 2)
 				r6s.failed_num[s.failed] = i;
 			s.failed++;
 		} else
-			set_bit(R5_Insync, &dev->flags);
+			set_bit(R5_Insync, &dev_q->flags);
 	}
 	rcu_read_unlock();
 	pr_debug("locked=%d uptodate=%d to_read=%d"
@@ -2985,20 +3094,20 @@ static void handle_stripe6(struct stripe
 	 * might be able to return some write requests if the parity blocks
 	 * are safe, or on a failed drive
 	 */
-	pdev = &sh->dev[pd_idx];
+	pdev_q = &sq->dev[pd_idx];
 	r6s.p_failed = (s.failed >= 1 && r6s.failed_num[0] == pd_idx)
 		|| (s.failed >= 2 && r6s.failed_num[1] == pd_idx);
-	qdev = &sh->dev[r6s.qd_idx];
+	qdev_q = &sq->dev[r6s.qd_idx];
 	r6s.q_failed = (s.failed >= 1 && r6s.failed_num[0] == r6s.qd_idx)
 		|| (s.failed >= 2 && r6s.failed_num[1] == r6s.qd_idx);
 
 	if ( s.written &&
-	     ( r6s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
-			     && !test_bit(R5_LOCKED, &pdev->flags)
-			     && test_bit(R5_UPTODATE, &pdev->flags)))) &&
-	     ( r6s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
-			     && !test_bit(R5_LOCKED, &qdev->flags)
-			     && test_bit(R5_UPTODATE, &qdev->flags)))))
+	     ( r6s.p_failed || ((test_bit(R5_Insync, &pdev_q->flags)
+			     && !test_bit(R5_LOCKED, &pdev_q->flags)
+			     && test_bit(R5_UPTODATE, &pdev_q->flags)))) &&
+	     ( r6s.q_failed || ((test_bit(R5_Insync, &qdev_q->flags)
+			     && !test_bit(R5_LOCKED, &qdev_q->flags)
+			     && test_bit(R5_UPTODATE, &qdev_q->flags)))))
 		handle_completed_write_requests(conf, sh, disks, &return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
@@ -3030,19 +3139,19 @@ static void handle_stripe6(struct stripe
 	 */
 	if (s.failed <= 2 && !conf->mddev->ro)
 		for (i = 0; i < s.failed; i++) {
-			dev = &sh->dev[r6s.failed_num[i]];
-			if (test_bit(R5_ReadError, &dev->flags)
-			    && !test_bit(R5_LOCKED, &dev->flags)
-			    && test_bit(R5_UPTODATE, &dev->flags)
+			dev_q = &sq->dev[r6s.failed_num[i]];
+			if (test_bit(R5_ReadError, &dev_q->flags)
+			    && !test_bit(R5_LOCKED, &dev_q->flags)
+			    && test_bit(R5_UPTODATE, &dev_q->flags)
 				) {
-				if (!test_bit(R5_ReWrite, &dev->flags)) {
-					set_bit(R5_Wantwrite, &dev->flags);
-					set_bit(R5_ReWrite, &dev->flags);
-					set_bit(R5_LOCKED, &dev->flags);
+				if (!test_bit(R5_ReWrite, &dev_q->flags)) {
+					set_bit(R5_Wantwrite, &dev_q->flags);
+					set_bit(R5_ReWrite, &dev_q->flags);
+					set_bit(R5_LOCKED, &dev_q->flags);
 				} else {
 					/* let's read it back */
-					set_bit(R5_Wantread, &dev->flags);
-					set_bit(R5_LOCKED, &dev->flags);
+					set_bit(R5_Wantread, &dev_q->flags);
+					set_bit(R5_LOCKED, &dev_q->flags);
 				}
 			}
 		}
@@ -3050,13 +3159,13 @@ static void handle_stripe6(struct stripe
 	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
 		/* Need to write out all blocks after computing P&Q */
 		sh->disks = conf->raid_disks;
-		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
+		sq->pd_idx = stripe_to_pdidx(sh->sector, conf,
 					     conf->raid_disks);
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		for (i = conf->raid_disks ; i-- ;  ) {
-			set_bit(R5_LOCKED, &sh->dev[i].flags);
+			set_bit(R5_LOCKED, &sq->dev[i].flags);
 			s.locked++;
-			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+			set_bit(R5_Wantwrite, &sq->dev[i].flags);
 		}
 		clear_bit(STRIPE_EXPANDING, &sh->state);
 	} else if (s.expanded) {
@@ -3069,7 +3178,7 @@ static void handle_stripe6(struct stripe
 	if (s.expanding && s.locked == 0)
 		handle_stripe_expansion(conf, sh, &r6s);
 
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	return_io(return_bi);
 
@@ -3077,9 +3186,9 @@ static void handle_stripe6(struct stripe
 		int rw;
 		struct bio *bi;
 		mdk_rdev_t *rdev;
-		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags))
+		if (test_and_clear_bit(R5_Wantwrite, &sq->dev[i].flags))
 			rw = WRITE;
-		else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
+		else if (test_and_clear_bit(R5_Wantread, &sq->dev[i].flags))
 			rw = READ;
 		else
 			continue;
@@ -3119,7 +3228,7 @@ static void handle_stripe6(struct stripe
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
 			if (rw == WRITE &&
-			    test_bit(R5_ReWrite, &sh->dev[i].flags))
+			    test_bit(R5_ReWrite, &sq->dev[i].flags))
 				atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
 			generic_make_request(bi);
 		} else {
@@ -3127,7 +3236,7 @@ static void handle_stripe6(struct stripe
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
-			clear_bit(R5_LOCKED, &sh->dev[i].flags);
+			clear_bit(R5_LOCKED, &sq->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
 	}
@@ -3135,7 +3244,7 @@ static void handle_stripe6(struct stripe
 
 static void handle_stripe(struct stripe_head *sh, struct page *tmp_page)
 {
-	if (sh->raid_conf->level == 6)
+	if (sh->sq->raid_conf->level == 6)
 		handle_stripe6(sh, tmp_page);
 	else
 		handle_stripe5(sh);
@@ -3465,7 +3574,6 @@ static int chunk_aligned_read(request_qu
 	}
 }
 
-
 static int make_request(request_queue_t *q, struct bio * bi)
 {
 	mddev_t *mddev = q->queuedata;
@@ -3681,19 +3789,22 @@ static sector_t reshape_request(mddev_t 
 		 */
 		for (j=sh->disks; j--;) {
 			sector_t s;
-			if (j == sh->pd_idx)
+			int pd_idx = sh->sq->pd_idx;
+
+			if (j == pd_idx)
 				continue;
 			if (conf->level == 6 &&
-			    j == raid6_next_disk(sh->pd_idx, sh->disks))
+			    j == raid6_next_disk(pd_idx, sh->disks))
 				continue;
-			s = compute_blocknr(sh, j);
+			s = compute_blocknr(conf, sh->disks, sh->sector,
+					pd_idx, j);
 			if (s < (mddev->array_size<<1)) {
 				skipped = 1;
 				continue;
 			}
 			memset(page_address(sh->dev[j].page), 0, STRIPE_SIZE);
-			set_bit(R5_Expanded, &sh->dev[j].flags);
-			set_bit(R5_UPTODATE, &sh->dev[j].flags);
+			set_bit(R5_Expanded, &sh->sq->dev[j].flags);
+			set_bit(R5_UPTODATE, &sh->sq->dev[j].flags);
 		}
 		if (!skipped) {
 			set_bit(STRIPE_EXPAND_READY, &sh->state);
@@ -3738,6 +3849,7 @@ static inline sector_t sync_request(mdde
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct stripe_head *sh;
+	struct stripe_queue *sq;
 	int pd_idx;
 	int raid_disks = conf->raid_disks;
 	sector_t max_sector = mddev->size << 1;
@@ -3794,6 +3906,8 @@ static inline sector_t sync_request(mdde
 		 */
 		schedule_timeout_uninterruptible(1);
 	}
+	sq = sh->sq;
+
 	/* Need to check if array will still be degraded after recovery/resync
 	 * We don't need to check the 'failed' flag as when that gets set,
 	 * recovery aborts.
@@ -3804,10 +3918,10 @@ static inline sector_t sync_request(mdde
 
 	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_degraded);
 
-	spin_lock(&sh->lock);
+	spin_lock(&sq->lock);
 	set_bit(STRIPE_SYNCING, &sh->state);
 	clear_bit(STRIPE_INSYNC, &sh->state);
-	spin_unlock(&sh->lock);
+	spin_unlock(&sq->lock);
 
 	handle_stripe(sh, NULL);
 	release_stripe(sh);
@@ -3828,6 +3942,7 @@ static int  retry_aligned_read(raid5_con
 	 * it will be only one 'dd_idx' and only need one call to raid5_compute_sector.
 	 */
 	struct stripe_head *sh;
+	struct stripe_queue *sq;
 	int dd_idx, pd_idx;
 	sector_t sector, logical_sector, last_sector;
 	int scnt = 0;
@@ -3861,7 +3976,8 @@ static int  retry_aligned_read(raid5_con
 			return handled;
 		}
 
-		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
+		sq = sh->sq;
+		set_bit(R5_ReadError, &sq->dev[dd_idx].flags);
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
 			release_stripe(sh);
 			raid_bio->bi_hw_segments = scnt;
@@ -4327,15 +4443,16 @@ static int stop(mddev_t *mddev)
 static void print_sh (struct seq_file *seq, struct stripe_head *sh)
 {
 	int i;
+	struct stripe_queue *sq = sh->sq;
 
 	seq_printf(seq, "sh %llu, pd_idx %d, state %ld.\n",
-		   (unsigned long long)sh->sector, sh->pd_idx, sh->state);
+		   (unsigned long long)sh->sector, sq->pd_idx, sh->state);
 	seq_printf(seq, "sh %llu,  count %d.\n",
 		   (unsigned long long)sh->sector, atomic_read(&sh->count));
 	seq_printf(seq, "sh %llu, ", (unsigned long long)sh->sector);
 	for (i = 0; i < sh->disks; i++) {
 		seq_printf(seq, "(cache%d: %p %ld) ",
-			   i, sh->dev[i].page, sh->dev[i].flags);
+			   i, sh->dev[i].page, sq->dev[i].flags);
 	}
 	seq_printf(seq, "\n");
 }
@@ -4349,7 +4466,7 @@ static void printall (struct seq_file *s
 	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < NR_HASH; i++) {
 		hlist_for_each_entry(sh, hn, &conf->stripe_hashtbl[i], hash) {
-			if (sh->raid_conf != conf)
+			if (sh->sq->raid_conf != conf)
 				continue;
 			print_sh(seq, sh);
 		}
diff -puN include/linux/raid/raid5.h~raid5-add-the-stripe_queue-object-for-tracking-raid include/linux/raid/raid5.h
--- a/include/linux/raid/raid5.h~raid5-add-the-stripe_queue-object-for-tracking-raid
+++ a/include/linux/raid/raid5.h
@@ -158,16 +158,13 @@
  *    the compute block completes.
  */
 
+struct stripe_queue;
 struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;			/* inactive_list or handle_list */
-	struct raid5_private_data	*raid_conf;
 	sector_t		sector;			/* sector of this row */
-	int			pd_idx;			/* parity disk index */
 	unsigned long		state;			/* state flags */
 	atomic_t		count;			/* nr of active thread/requests */
-	spinlock_t		lock;
-	int			bm_seq;	/* sequence number for bitmap flushes */
 	int			disks;			/* disks in stripe */
 	/* stripe_operations
 	 * @pending - pending ops flags (set for request->issue->complete)
@@ -184,13 +181,12 @@ struct stripe_head {
 		int		   count;
 		u32		   zero_sum_result;
 	} ops;
+	struct stripe_queue *sq;
 	struct r5dev {
 		struct bio	req;
 		struct bio_vec	vec;
 		struct page	*page;
-		struct bio	*toread, *read, *towrite, *written;
-		sector_t	sector;			/* sector of this page */
-		unsigned long	flags;
+		struct bio	*read, *written;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
 
@@ -209,6 +205,19 @@ struct r6_state {
 	int p_failed, q_failed, qd_idx, failed_num[2];
 };
 
+struct stripe_queue {
+	sector_t sector;
+	int pd_idx; /* parity disk index */
+	int bm_seq; /* sequence number for bitmap flushes */
+	spinlock_t lock;
+	struct raid5_private_data *raid_conf;
+	struct r5_queue_dev {
+		sector_t sector; /* hw starting sector for this block */
+		struct bio *toread, *towrite;
+		unsigned long flags;
+	} dev[1];
+};
+
 /* Flags */
 #define	R5_UPTODATE	0	/* page contains current data */
 #define	R5_LOCKED	1	/* IO has been submitted on "req" */
@@ -328,8 +337,10 @@ struct raid5_private_data {
 	 * two caches.
 	 */
 	int			active_name;
-	char			cache_name[2][20];
-	struct kmem_cache		*slab_cache; /* for allocating stripes */
+	char			sh_cache_name[2][20];
+	char			sq_cache_name[2][20];
+	struct kmem_cache	*sh_slab_cache;
+	struct kmem_cache	*sq_slab_cache;
 
 	int			seq_flush, seq_write;
 	int			quiesce;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

git-md-accel.patch
remove-unsafe-from-module-struct.patch
raid5-add-the-stripe_queue-object-for-tracking-raid.patch
raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2.patch
raid5-use-stripe_queues-to-prioritize-the-most.patch
