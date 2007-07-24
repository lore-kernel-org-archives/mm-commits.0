From: akpm@linux-foundation.org
Subject: - raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2.patch removed from -mm tree
Date: Mon, 23 Jul 2007 23:04:05 -0700
Message-ID: <200707240604.l6O645sT031419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbXGXGES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 02:04:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     raid5: add the stripe_queue object for tracking raid io requests (take2)
has been removed from the -mm tree.  Its filename was
     raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: raid5: add the stripe_queue object for tracking raid io requests (take2)
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

This patch lays the groundwork, but does not implement, the facility to
have more queue objects in the system than available stripes, currently this
remains a 1:1 relationship.  In other words, this patch just moves fields
around and does not implement new logic.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c         |  496 +++++++++++++++++------------------
 include/linux/raid/raid5.h |    2 
 2 files changed, 250 insertions(+), 248 deletions(-)

diff -puN drivers/md/raid5.c~raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2 drivers/md/raid5.c
--- a/drivers/md/raid5.c~raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2
+++ a/drivers/md/raid5.c
@@ -262,14 +262,14 @@ static void init_stripe(struct stripe_he
 		struct r5_queue_dev *dev_q = &sh->sq->dev[i];
 
 		if (dev_q->toread || dev->read || dev_q->towrite ||
-			dev->written || test_bit(R5_LOCKED, &dev_q->flags)) {
+			dev->written || test_bit(R5_LOCKED, &dev->flags)) {
 			printk(KERN_ERR "sector=%llx i=%d %p %p %p %p %d\n",
 			       (unsigned long long)sh->sector, i, dev_q->toread,
 			       dev->read, dev_q->towrite, dev->written,
-			       test_bit(R5_LOCKED, &dev_q->flags));
+			       test_bit(R5_LOCKED, &dev->flags));
 			BUG();
 		}
-		dev_q->flags = 0;
+		dev->flags = 0;
 		raid5_build_block(sh, i);
 	}
 	insert_hash(conf, sh);
@@ -399,13 +399,13 @@ static void ops_run_io(struct stripe_hea
 
 	might_sleep();
 
-	for (i = disks; i--; ) {
+	for (i = disks; i--;) {
 		int rw;
 		struct bio *bi;
 		mdk_rdev_t *rdev;
-		if (test_and_clear_bit(R5_Wantwrite, &sq->dev[i].flags))
+		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags))
 			rw = WRITE;
-		else if (test_and_clear_bit(R5_Wantread, &sq->dev[i].flags))
+		else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
 			rw = READ;
 		else
 			continue;
@@ -448,7 +448,7 @@ static void ops_run_io(struct stripe_hea
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
 			if (rw == WRITE &&
-			    test_bit(R5_ReWrite, &sq->dev[i].flags))
+			    test_bit(R5_ReWrite, &sh->dev[i].flags))
 				atomic_add(STRIPE_SECTORS,
 					&rdev->corrected_errors);
 			generic_make_request(bi);
@@ -457,7 +457,7 @@ static void ops_run_io(struct stripe_hea
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
-			clear_bit(R5_LOCKED, &sq->dev[i].flags);
+			clear_bit(R5_LOCKED, &sh->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
 	}
@@ -527,7 +527,9 @@ static void ops_complete_biofill(void *s
 
 	/* clear completed biofills */
 	for (i = sh->disks; i--; ) {
+		struct r5dev *dev = &sh->dev[i];
 		struct r5_queue_dev *dev_q = &sq->dev[i];
+
 		/* check if this stripe has new incoming reads */
 		if (dev_q->toread)
 			more_to_read++;
@@ -535,11 +537,9 @@ static void ops_complete_biofill(void *s
 		/* acknowledge completion of a biofill operation */
 		/* and check if we need to reply to a read request
 		*/
-		if (test_bit(R5_Wantfill, &dev_q->flags) && !dev_q->toread) {
+		if (test_bit(R5_Wantfill, &dev->flags) && !dev_q->toread) {
 			struct bio *rbi, *rbi2;
-			struct r5dev *dev = &sh->dev[i];
-
-			clear_bit(R5_Wantfill, &dev_q->flags);
+			clear_bit(R5_Wantfill, &dev->flags);
 
 			/* The access to dev->read is outside of the
 			 * spin_lock_irq(&conf->device_lock), but is protected
@@ -583,7 +583,7 @@ static void ops_run_biofill(struct strip
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
 		struct r5_queue_dev *dev_q = &sh->sq->dev[i];
-		if (test_bit(R5_Wantfill, &dev_q->flags)) {
+		if (test_bit(R5_Wantfill, &dev->flags)) {
 			struct bio *rbi;
 			spin_lock_irq(&conf->device_lock);
 			dev->read = rbi = dev_q->toread;
@@ -606,9 +606,8 @@ static void ops_run_biofill(struct strip
 static void ops_complete_compute5(void *stripe_head_ref)
 {
 	struct stripe_head *sh = stripe_head_ref;
-	struct stripe_queue *sq = sh->sq;
 	int target = sh->ops.target;
-	struct r5_queue_dev *tgt = &sq->dev[target];
+	struct r5dev *tgt = &sh->dev[target];
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
@@ -628,14 +627,15 @@ ops_run_compute5(struct stripe_head *sh,
 	int disks = sh->disks;
 	struct page *xor_srcs[disks];
 	int target = sh->ops.target;
-	struct page *xor_dest = sh->dev[target].page;
+	struct r5dev *tgt = &sh->dev[target];
+	struct page *xor_dest = tgt->page;
 	int count = 0;
 	struct dma_async_tx_descriptor *tx;
 	int i;
 
 	pr_debug("%s: stripe %llu block: %d\n",
 		__FUNCTION__, (unsigned long long)sh->sector, target);
-	BUG_ON(!test_bit(R5_Wantcompute, &sh->sq->dev[target].flags));
+	BUG_ON(!test_bit(R5_Wantcompute, &tgt->flags));
 
 	for (i = disks; i--; )
 		if (i != target)
@@ -687,7 +687,7 @@ ops_run_prexor(struct stripe_head *sh, s
 		struct r5dev *dev = &sh->dev[i];
 		struct r5_queue_dev *dev_q = &sq->dev[i];
 		/* Only process blocks that are known to be uptodate */
-		if (dev_q->towrite && test_bit(R5_Wantprexor, &dev_q->flags))
+		if (dev_q->towrite && test_bit(R5_Wantprexor, &dev->flags))
 			xor_srcs[count++] = dev->page;
 	}
 
@@ -722,11 +722,11 @@ ops_run_biodrain(struct stripe_head *sh,
 		towrite = 0;
 		if (prexor) { /* rmw */
 			if (dev_q->towrite &&
-			    test_bit(R5_Wantprexor, &dev_q->flags))
+			    test_bit(R5_Wantprexor, &dev->flags))
 				towrite = 1;
 		} else { /* rcw */
 			if (i != pd_idx && dev_q->towrite &&
-				test_bit(R5_LOCKED, &dev_q->flags))
+				test_bit(R5_LOCKED, &dev->flags))
 				towrite = 1;
 		}
 
@@ -775,9 +775,8 @@ static void ops_complete_write(void *str
 
 	for (i = disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
-		struct r5_queue_dev *dev_q = &sq->dev[i];
 		if (dev->written || i == pd_idx)
-			set_bit(R5_UPTODATE, &dev_q->flags);
+			set_bit(R5_UPTODATE, &dev->flags);
 	}
 
 	set_bit(STRIPE_OP_BIODRAIN, &sh->ops.complete);
@@ -849,14 +848,13 @@ static void ops_complete_check(void *str
 {
 	struct stripe_head *sh = stripe_head_ref;
 	int pd_idx = sh->sq->pd_idx;
-	struct stripe_queue *sq = sh->sq;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
 		(unsigned long long)sh->sector);
 
 	if (test_and_clear_bit(STRIPE_OP_MOD_DMA_CHECK, &sh->ops.pending) &&
 		sh->ops.zero_sum_result == 0)
-		set_bit(R5_UPTODATE, &sq->dev[pd_idx].flags);
+		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
 
 	set_bit(STRIPE_OP_CHECK, &sh->ops.complete);
 	set_bit(STRIPE_HANDLE, &sh->state);
@@ -925,13 +923,13 @@ static void raid5_run_ops(struct stripe_
 	if (test_bit(STRIPE_OP_IO, &pending))
 		ops_run_io(sh);
 
-	if (overlap_clear)
+	if (overlap_clear) {
 		for (i = disks; i--; ) {
-			struct stripe_queue *sq = sh->sq;
-			struct r5_queue_dev *dev_q = &sq->dev[i];
-			if (test_and_clear_bit(R5_Overlap, &dev_q->flags))
+			struct r5dev *dev = &sh->dev[i];
+			if (test_and_clear_bit(R5_Overlap, &dev->flags))
 				wake_up(&sh->sq->raid_conf->wait_for_overlap);
 		}
+	}
 }
 
 static int grow_one_stripe(raid5_conf_t *conf)
@@ -1197,7 +1195,6 @@ static int raid5_end_read_request(struct
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	char b[BDEVNAME_SIZE];
 	mdk_rdev_t *rdev;
-	struct stripe_queue *sq = sh->sq;
 
 	if (bi->bi_size)
 		return 1;
@@ -1215,15 +1212,15 @@ static int raid5_end_read_request(struct
 	}
 
 	if (uptodate) {
-		set_bit(R5_UPTODATE, &sq->dev[i].flags);
-		if (test_bit(R5_ReadError, &sq->dev[i].flags)) {
+		set_bit(R5_UPTODATE, &sh->dev[i].flags);
+		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			rdev = conf->disks[i].rdev;
 			printk(KERN_INFO "raid5:%s: read error corrected (%lu sectors at %llu on %s)\n",
 			       mdname(conf->mddev), STRIPE_SECTORS,
 			       (unsigned long long)sh->sector + rdev->data_offset,
 			       bdevname(rdev->bdev, b));
-			clear_bit(R5_ReadError, &sq->dev[i].flags);
-			clear_bit(R5_ReWrite, &sq->dev[i].flags);
+			clear_bit(R5_ReadError, &sh->dev[i].flags);
+			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		}
 		if (atomic_read(&conf->disks[i].rdev->read_errors))
 			atomic_set(&conf->disks[i].rdev->read_errors, 0);
@@ -1232,14 +1229,14 @@ static int raid5_end_read_request(struct
 		int retry = 0;
 		rdev = conf->disks[i].rdev;
 
-		clear_bit(R5_UPTODATE, &sq->dev[i].flags);
+		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
 		atomic_inc(&rdev->read_errors);
 		if (conf->mddev->degraded)
 			printk(KERN_WARNING "raid5:%s: read error not correctable (sector %llu on %s).\n",
 			       mdname(conf->mddev),
 			       (unsigned long long)sh->sector + rdev->data_offset,
 			       bdn);
-		else if (test_bit(R5_ReWrite, &sq->dev[i].flags))
+		else if (test_bit(R5_ReWrite, &sh->dev[i].flags))
 			/* Oh, no!!! */
 			printk(KERN_WARNING "raid5:%s: read error NOT corrected!! (sector %llu on %s).\n",
 			       mdname(conf->mddev),
@@ -1253,15 +1250,15 @@ static int raid5_end_read_request(struct
 		else
 			retry = 1;
 		if (retry)
-			set_bit(R5_ReadError, &sq->dev[i].flags);
+			set_bit(R5_ReadError, &sh->dev[i].flags);
 		else {
-			clear_bit(R5_ReadError, &sq->dev[i].flags);
-			clear_bit(R5_ReWrite, &sq->dev[i].flags);
+			clear_bit(R5_ReadError, &sh->dev[i].flags);
+			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 			md_error(conf->mddev, rdev);
 		}
 	}
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
-	clear_bit(R5_LOCKED, &sq->dev[i].flags);
+	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 	return 0;
@@ -1296,7 +1293,7 @@ static int raid5_end_write_request (stru
 
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
 	
-	clear_bit(R5_LOCKED, &sq->dev[i].flags);
+	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
 	return 0;
@@ -1318,7 +1315,7 @@ static void raid5_build_block (struct st
 	dev->req.bi_sector = sh->sector;
 	dev->req.bi_private = sh;
 
-	dev_q->flags = 0;
+	dev->flags = 0;
 	dev_q->sector = compute_blocknr(sh->sq->raid_conf, sh->disks,
 			sh->sector, sh->sq->pd_idx, i);
 }
@@ -1616,8 +1613,7 @@ static void compute_parity6(struct strip
 				chosen = sq->dev[i].towrite;
 				sq->dev[i].towrite = NULL;
 
-				if (test_and_clear_bit(R5_Overlap,
-							&sq->dev[i].flags))
+				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 					wake_up(&conf->wait_for_overlap);
 
 				BUG_ON(sh->dev[i].written);
@@ -1637,8 +1633,8 @@ static void compute_parity6(struct strip
 				wbi = r5_next_bio(wbi, sector);
 			}
 
-			set_bit(R5_LOCKED, &sq->dev[i].flags);
-			set_bit(R5_UPTODATE, &sq->dev[i].flags);
+			set_bit(R5_LOCKED, &sh->dev[i].flags);
+			set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		}
 
 //	switch(method) {
@@ -1651,8 +1647,7 @@ static void compute_parity6(struct strip
 		i = d0_idx;
 		do {
 			ptrs[count++] = page_address(sh->dev[i].page);
-			if (count <= disks-2 &&
-			    !test_bit(R5_UPTODATE, &sq->dev[i].flags))
+			if (count <= disks-2 && !test_bit(R5_UPTODATE, &sh->dev[i].flags))
 				printk("block %d/%d not uptodate on parity calc\n", i,count);
 			i = raid6_next_disk(i, disks);
 		} while ( i != d0_idx );
@@ -1663,14 +1658,14 @@ static void compute_parity6(struct strip
 
 	switch(method) {
 	case RECONSTRUCT_WRITE:
-		set_bit(R5_UPTODATE, &sq->dev[pd_idx].flags);
-		set_bit(R5_UPTODATE, &sq->dev[qd_idx].flags);
-		set_bit(R5_LOCKED,   &sq->dev[pd_idx].flags);
-		set_bit(R5_LOCKED,   &sq->dev[qd_idx].flags);
+		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+		set_bit(R5_UPTODATE, &sh->dev[qd_idx].flags);
+		set_bit(R5_LOCKED,   &sh->dev[pd_idx].flags);
+		set_bit(R5_LOCKED,   &sh->dev[qd_idx].flags);
 		break;
 	case UPDATE_PARITY:
-		set_bit(R5_UPTODATE, &sq->dev[pd_idx].flags);
-		set_bit(R5_UPTODATE, &sq->dev[qd_idx].flags);
+		set_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
+		set_bit(R5_UPTODATE, &sh->dev[qd_idx].flags);
 		break;
 	}
 }
@@ -1699,7 +1694,7 @@ static void compute_block_1(struct strip
 			if (i == dd_idx || i == qd_idx)
 				continue;
 			p = page_address(sh->dev[i].page);
-			if (test_bit(R5_UPTODATE, &sq->dev[i].flags))
+			if (test_bit(R5_UPTODATE, &sh->dev[i].flags))
 				ptr[count++] = p;
 			else
 				printk("compute_block() %d, stripe %llu, %d"
@@ -1710,10 +1705,8 @@ static void compute_block_1(struct strip
 		}
 		if (count)
 			xor_blocks(count, STRIPE_SIZE, dest, ptr);
-		if (!nozero)
-			set_bit(R5_UPTODATE, &sq->dev[dd_idx].flags);
-		else
-			clear_bit(R5_UPTODATE, &sq->dev[dd_idx].flags);
+		if (!nozero) set_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
+		else clear_bit(R5_UPTODATE, &sh->dev[dd_idx].flags);
 	}
 }
 
@@ -1753,7 +1746,6 @@ static void compute_block_2(struct strip
 
 	/* We're missing D+P or D+D; build pointer table */
 	{
-		struct stripe_queue *sq = sh->sq;
 		/**** FIX THIS: This could be very bad if disks is close to 256 ****/
 		void *ptrs[disks];
 
@@ -1763,7 +1755,7 @@ static void compute_block_2(struct strip
 			ptrs[count++] = page_address(sh->dev[i].page);
 			i = raid6_next_disk(i, disks);
 			if (i != dd_idx1 && i != dd_idx2 &&
-			    !test_bit(R5_UPTODATE, &sq->dev[i].flags))
+			    !test_bit(R5_UPTODATE, &sh->dev[i].flags))
 				printk("compute_2 with missing block %d/%d\n", count, i);
 		} while ( i != d0_idx );
 
@@ -1776,8 +1768,8 @@ static void compute_block_2(struct strip
 		}
 
 		/* Both the above update both missing blocks */
-		set_bit(R5_UPTODATE, &sq->dev[dd_idx1].flags);
-		set_bit(R5_UPTODATE, &sq->dev[dd_idx2].flags);
+		set_bit(R5_UPTODATE, &sh->dev[dd_idx1].flags);
+		set_bit(R5_UPTODATE, &sh->dev[dd_idx2].flags);
 	}
 }
 
@@ -1802,18 +1794,19 @@ handle_write_operations5(struct stripe_h
 		sh->ops.count++;
 
 		for (i = disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
 			struct r5_queue_dev *dev_q = &sq->dev[i];
 
 			if (dev_q->towrite) {
-				set_bit(R5_LOCKED, &dev_q->flags);
+				set_bit(R5_LOCKED, &dev->flags);
 				if (!expand)
-					clear_bit(R5_UPTODATE, &dev_q->flags);
+					clear_bit(R5_UPTODATE, &dev->flags);
 				locked++;
 			}
 		}
 	} else {
-		BUG_ON(!(test_bit(R5_UPTODATE, &sq->dev[pd_idx].flags) ||
-			test_bit(R5_Wantcompute, &sq->dev[pd_idx].flags)));
+		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
+			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
 
 		set_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
 		set_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending);
@@ -1822,7 +1815,9 @@ handle_write_operations5(struct stripe_h
 		sh->ops.count += 3;
 
 		for (i = disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
 			struct r5_queue_dev *dev_q = &sq->dev[i];
+
 			if (i == pd_idx)
 				continue;
 
@@ -1832,11 +1827,11 @@ handle_write_operations5(struct stripe_h
 			 * R5_Wantprexor bit
 			 */
 			if (dev_q->towrite &&
-			    (test_bit(R5_UPTODATE, &dev_q->flags) ||
-			    test_bit(R5_Wantcompute, &dev_q->flags))) {
-				set_bit(R5_Wantprexor, &dev_q->flags);
-				set_bit(R5_LOCKED, &dev_q->flags);
-				clear_bit(R5_UPTODATE, &dev_q->flags);
+			    (test_bit(R5_UPTODATE, &dev->flags) ||
+			    test_bit(R5_Wantcompute, &dev->flags))) {
+				set_bit(R5_Wantprexor, &dev->flags);
+				set_bit(R5_LOCKED, &dev->flags);
+				clear_bit(R5_UPTODATE, &dev->flags);
 				locked++;
 			}
 		}
@@ -1845,8 +1840,8 @@ handle_write_operations5(struct stripe_h
 	/* keep the parity disk locked while asynchronous operations
 	 * are in flight
 	 */
-	set_bit(R5_LOCKED, &sq->dev[pd_idx].flags);
-	clear_bit(R5_UPTODATE, &sq->dev[pd_idx].flags);
+	set_bit(R5_LOCKED, &sh->dev[pd_idx].flags);
+	clear_bit(R5_UPTODATE, &sh->dev[pd_idx].flags);
 	locked++;
 
 	pr_debug("%s: stripe %llu locked: %d pending: %lx\n",
@@ -1919,12 +1914,12 @@ static int add_stripe_bio(struct stripe_
 				sector = bi->bi_sector + (bi->bi_size>>9);
 		}
 		if (sector >= sq->dev[dd_idx].sector + STRIPE_SECTORS)
-			set_bit(R5_OVERWRITE, &sq->dev[dd_idx].flags);
+			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
 	}
 	return 1;
 
  overlap:
-	set_bit(R5_Overlap, &sq->dev[dd_idx].flags);
+	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
 	spin_unlock_irq(&conf->device_lock);
 	spin_unlock(&sq->lock);
 	return 0;
@@ -1964,7 +1959,7 @@ handle_requests_to_failed_array(raid5_co
 		struct bio *bi;
 		int bitmap_end = 0;
 
-		if (test_bit(R5_ReadError, &sq->dev[i].flags)) {
+		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			mdk_rdev_t *rdev;
 			rcu_read_lock();
 			rdev = rcu_dereference(conf->disks[i].rdev);
@@ -1982,7 +1977,7 @@ handle_requests_to_failed_array(raid5_co
 			bitmap_end = 1;
 		}
 
-		if (test_and_clear_bit(R5_Overlap, &sq->dev[i].flags))
+		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 			wake_up(&conf->wait_for_overlap);
 
 		while (bi && bi->bi_sector <
@@ -2015,12 +2010,12 @@ handle_requests_to_failed_array(raid5_co
 		/* fail any reads if this device is non-operational and
 		 * the data has not reached the cache yet.
 		 */
-		if (!test_bit(R5_Wantfill, &sq->dev[i].flags) &&
-		    (!test_bit(R5_Insync, &sq->dev[i].flags) ||
-		      test_bit(R5_ReadError, &sq->dev[i].flags))) {
+		if (!test_bit(R5_Wantfill, &sh->dev[i].flags) &&
+		    (!test_bit(R5_Insync, &sh->dev[i].flags) ||
+		      test_bit(R5_ReadError, &sh->dev[i].flags))) {
 			bi = sq->dev[i].toread;
 			sq->dev[i].toread = NULL;
-			if (test_and_clear_bit(R5_Overlap, &sq->dev[i].flags))
+			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
 			if (bi) s->to_read--;
 			while (bi && bi->bi_sector <
@@ -2050,8 +2045,10 @@ static int __handle_issuing_new_read_req
 			struct stripe_head_state *s, int disk_idx, int disks)
 {
 	struct stripe_queue *sq = sh->sq;
+	struct r5dev *dev = &sh->dev[disk_idx];
 	struct r5_queue_dev *dev_q = &sq->dev[disk_idx];
-	struct r5_queue_dev *failed_dev = &sq->dev[s->failed_num];
+	struct r5dev *failed_dev = &sh->dev[s->failed_num];
+	struct r5_queue_dev *failed_dev_q = &sq->dev[s->failed_num];
 
 	/* don't schedule compute operations or reads on the parity block while
 	 * a check is in flight
@@ -2061,11 +2058,11 @@ static int __handle_issuing_new_read_req
 		return ~0;
 
 	/* is the data in this block needed, and can we get it? */
-	if (!test_bit(R5_LOCKED, &dev_q->flags) &&
-	    !test_bit(R5_UPTODATE, &dev_q->flags) && (dev_q->toread ||
-	    (dev_q->towrite && !test_bit(R5_OVERWRITE, &dev_q->flags)) ||
+	if (!test_bit(R5_LOCKED, &dev->flags) &&
+	    !test_bit(R5_UPTODATE, &dev->flags) && (dev_q->toread ||
+	    (dev_q->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
 	     s->syncing || s->expanding || (s->failed &&
-	     (failed_dev->toread || (failed_dev->towrite &&
+	     (failed_dev_q->toread || (failed_dev_q->towrite &&
 	     !test_bit(R5_OVERWRITE, &failed_dev->flags)
 	     ))))) {
 		/* 1/ We would like to get this block, possibly by computing it,
@@ -2081,7 +2078,7 @@ static int __handle_issuing_new_read_req
 		if ((s->uptodate == disks - 1) &&
 		    !test_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 			set_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending);
-			set_bit(R5_Wantcompute, &dev_q->flags);
+			set_bit(R5_Wantcompute, &dev->flags);
 			sh->ops.target = disk_idx;
 			s->req_compute = 1;
 			sh->ops.count++;
@@ -2094,13 +2091,13 @@ static int __handle_issuing_new_read_req
 			s->uptodate++;
 			return 0; /* uptodate + compute == disks */
 		} else if ((s->uptodate < disks - 1) &&
-			test_bit(R5_Insync, &dev_q->flags)) {
+			test_bit(R5_Insync, &dev->flags)) {
 			/* Note: we hold off compute operations while checks are
 			 * in flight, but we still prefer 'compute' over 'read'
 			 * hence we only read if (uptodate < * disks-1)
 			 */
-			set_bit(R5_LOCKED, &dev_q->flags);
-			set_bit(R5_Wantread, &dev_q->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantread, &dev->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
 			s->locked++;
@@ -2149,12 +2146,15 @@ static void handle_issuing_new_read_requ
 {
 	int i;
 	struct stripe_queue *sq = sh->sq;
+
 	for (i = disks; i--; ) {
+		struct r5dev *dev = &sh->dev[i];
 		struct r5_queue_dev *dev_q = &sq->dev[i];
-		if (!test_bit(R5_LOCKED, &dev_q->flags) &&
-		    !test_bit(R5_UPTODATE, &dev_q->flags) &&
+
+		if (!test_bit(R5_LOCKED, &dev->flags) &&
+		    !test_bit(R5_UPTODATE, &dev->flags) &&
 		    (dev_q->toread || (dev_q->towrite &&
-		     !test_bit(R5_OVERWRITE, &dev_q->flags)) ||
+		     !test_bit(R5_OVERWRITE, &dev->flags)) ||
 		     s->syncing || s->expanding ||
 		     (s->failed >= 1 &&
 		      (sq->dev[r6s->failed_num[0]].toread ||
@@ -2179,7 +2179,7 @@ static void handle_issuing_new_read_requ
 					if (other == i)
 						continue;
 					if (!test_bit(R5_UPTODATE,
-					      &sq->dev[other].flags))
+					      &sh->dev[other].flags))
 						break;
 				}
 				BUG_ON(other < 0);
@@ -2188,9 +2188,9 @@ static void handle_issuing_new_read_requ
 				       i, other);
 				compute_block_2(sh, i, other);
 				s->uptodate += 2;
-			} else if (test_bit(R5_Insync, &dev_q->flags)) {
-				set_bit(R5_LOCKED, &dev_q->flags);
-				set_bit(R5_Wantread, &dev_q->flags);
+			} else if (test_bit(R5_Insync, &dev->flags)) {
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
 				s->locked++;
 				pr_debug("Reading block %d (sync=%d)\n",
 					i, s->syncing);
@@ -2216,8 +2216,8 @@ static void handle_completed_write_reque
 		if (sh->dev[i].written) {
 			struct r5dev *dev = &sh->dev[i];
 			struct r5_queue_dev *dev_q = &sq->dev[i];
-			if (!test_bit(R5_LOCKED, &dev_q->flags) &&
-				test_bit(R5_UPTODATE, &dev_q->flags)) {
+			if (!test_bit(R5_LOCKED, &dev->flags) &&
+				test_bit(R5_UPTODATE, &dev->flags)) {
 				/* We can return any write requests */
 				struct bio *wbi, *wbi2;
 				int bitmap_end = 0;
@@ -2253,24 +2253,27 @@ static void handle_issuing_new_write_req
 {
 	int rmw = 0, rcw = 0, i;
 	struct stripe_queue *sq = sh->sq;
+
 	for (i = disks; i--; ) {
 		/* would I have to read this buffer for read_modify_write */
+		struct r5dev *dev = &sh->dev[i];
 		struct r5_queue_dev *dev_q = &sq->dev[i];
+
 		if ((dev_q->towrite || i == sq->pd_idx) &&
-		    !test_bit(R5_LOCKED, &dev_q->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev_q->flags) ||
-		      test_bit(R5_Wantcompute, &dev_q->flags))) {
-			if (test_bit(R5_Insync, &dev_q->flags))
+		    !test_bit(R5_LOCKED, &dev->flags) &&
+		    !(test_bit(R5_UPTODATE, &dev->flags) ||
+		      test_bit(R5_Wantcompute, &dev->flags))) {
+			if (test_bit(R5_Insync, &dev->flags))
 				rmw++;
 			else
 				rmw += 2*disks;  /* cannot read it */
 		}
 		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev_q->flags) && i != sq->pd_idx &&
-		    !test_bit(R5_LOCKED, &dev_q->flags) &&
-		    !(test_bit(R5_UPTODATE, &dev_q->flags) ||
-		    test_bit(R5_Wantcompute, &dev_q->flags))) {
-			if (test_bit(R5_Insync, &dev_q->flags)) rcw++;
+		if (!test_bit(R5_OVERWRITE, &dev->flags) && i != sq->pd_idx &&
+		    !test_bit(R5_LOCKED, &dev->flags) &&
+		    !(test_bit(R5_UPTODATE, &dev->flags) ||
+		    test_bit(R5_Wantcompute, &dev->flags))) {
+			if (test_bit(R5_Insync, &dev->flags)) rcw++;
 			else
 				rcw += 2*disks;
 		}
@@ -2281,18 +2284,20 @@ static void handle_issuing_new_write_req
 	if (rmw < rcw && rmw > 0)
 		/* prefer read-modify-write, but need to get some data */
 		for (i = disks; i--; ) {
+			struct r5dev *dev = &sh->dev[i];
 			struct r5_queue_dev *dev_q = &sq->dev[i];
+
 			if ((dev_q->towrite || i == sq->pd_idx) &&
-			    !test_bit(R5_LOCKED, &dev_q->flags) &&
-			    !(test_bit(R5_UPTODATE, &dev_q->flags) ||
-			    test_bit(R5_Wantcompute, &dev_q->flags)) &&
-			    test_bit(R5_Insync, &dev_q->flags)) {
+			    !test_bit(R5_LOCKED, &dev->flags) &&
+			    !(test_bit(R5_UPTODATE, &dev->flags) ||
+			    test_bit(R5_Wantcompute, &dev->flags)) &&
+			    test_bit(R5_Insync, &dev->flags)) {
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 					pr_debug("Read_old block "
 						"%d for r-m-w\n", i);
-					set_bit(R5_LOCKED, &dev_q->flags);
-					set_bit(R5_Wantread, &dev_q->flags);
+					set_bit(R5_LOCKED, &dev->flags);
+					set_bit(R5_Wantread, &dev->flags);
 					if (!test_and_set_bit(
 						STRIPE_OP_IO, &sh->ops.pending))
 						sh->ops.count++;
@@ -2306,19 +2311,20 @@ static void handle_issuing_new_write_req
 	if (rcw <= rmw && rcw > 0)
 		/* want reconstruct write, but need to get some data */
 		for (i = disks; i--; ) {
-			struct r5_queue_dev *dev_q = &sq->dev[i];
-			if (!test_bit(R5_OVERWRITE, &dev_q->flags) &&
+			struct r5dev *dev = &sh->dev[i];
+
+			if (!test_bit(R5_OVERWRITE, &dev->flags) &&
 			    i != sq->pd_idx &&
-			    !test_bit(R5_LOCKED, &dev_q->flags) &&
-			    !(test_bit(R5_UPTODATE, &dev_q->flags) ||
-			    test_bit(R5_Wantcompute, &dev_q->flags)) &&
-			    test_bit(R5_Insync, &dev_q->flags)) {
+			    !test_bit(R5_LOCKED, &dev->flags) &&
+			    !(test_bit(R5_UPTODATE, &dev->flags) ||
+			    test_bit(R5_Wantcompute, &dev->flags)) &&
+			    test_bit(R5_Insync, &dev->flags)) {
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 					pr_debug("Read_old block "
 						"%d for Reconstruct\n", i);
-					set_bit(R5_LOCKED, &dev_q->flags);
-					set_bit(R5_Wantread, &dev_q->flags);
+					set_bit(R5_LOCKED, &dev->flags);
+					set_bit(R5_Wantread, &dev->flags);
 					if (!test_and_set_bit(
 						STRIPE_OP_IO, &sh->ops.pending))
 						sh->ops.count++;
@@ -2353,19 +2359,18 @@ static void handle_issuing_new_write_req
 	struct stripe_queue *sq = sh->sq;
 	int rcw = 0, must_compute = 0, pd_idx = sq->pd_idx, i;
 	int qd_idx = r6s->qd_idx;
-
 	for (i = disks; i--; ) {
-		struct r5_queue_dev *dev_q = &sq->dev[i];
+		struct r5dev *dev = &sh->dev[i];
 		/* Would I have to read this buffer for reconstruct_write */
-		if (!test_bit(R5_OVERWRITE, &dev_q->flags)
+		if (!test_bit(R5_OVERWRITE, &dev->flags)
 		    && i != pd_idx && i != qd_idx
-		    && (!test_bit(R5_LOCKED, &dev_q->flags)
+		    && (!test_bit(R5_LOCKED, &dev->flags)
 			    ) &&
-		    !test_bit(R5_UPTODATE, &dev_q->flags)) {
-			if (test_bit(R5_Insync, &dev_q->flags)) rcw++;
+		    !test_bit(R5_UPTODATE, &dev->flags)) {
+			if (test_bit(R5_Insync, &dev->flags)) rcw++;
 			else {
 				pr_debug("raid6: must_compute: "
-				   "disk %d flags=%#lx\n", i, dev_q->flags);
+					"disk %d flags=%#lx\n", i, dev->flags);
 				must_compute++;
 			}
 		}
@@ -2377,19 +2382,19 @@ static void handle_issuing_new_write_req
 	if (rcw > 0)
 		/* want reconstruct write, but need to get some data */
 		for (i = disks; i--; ) {
-			struct r5_queue_dev *dev_q = &sq->dev[i];
-			if (!test_bit(R5_OVERWRITE, &dev_q->flags)
+			struct r5dev *dev = &sh->dev[i];
+			if (!test_bit(R5_OVERWRITE, &dev->flags)
 			    && !(s->failed == 0 && (i == pd_idx || i == qd_idx))
-			    && !test_bit(R5_LOCKED, &dev_q->flags) &&
-			    !test_bit(R5_UPTODATE, &dev_q->flags) &&
-			    test_bit(R5_Insync, &dev_q->flags)) {
+			    && !test_bit(R5_LOCKED, &dev->flags) &&
+			    !test_bit(R5_UPTODATE, &dev->flags) &&
+			    test_bit(R5_Insync, &dev->flags)) {
 				if (
 				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 					pr_debug("Read_old stripe %llu "
 						"block %d for Reconstruct\n",
 					     (unsigned long long)sh->sector, i);
-					set_bit(R5_LOCKED, &dev_q->flags);
-					set_bit(R5_Wantread, &dev_q->flags);
+					set_bit(R5_LOCKED, &dev->flags);
+					set_bit(R5_Wantread, &dev->flags);
 					s->locked++;
 				} else {
 					pr_debug("Request delayed stripe %llu "
@@ -2427,11 +2432,11 @@ static void handle_issuing_new_write_req
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		/* now every locked buffer is ready to be written */
 		for (i = disks; i--; )
-			if (test_bit(R5_LOCKED, &sq->dev[i].flags)) {
+			if (test_bit(R5_LOCKED, &sh->dev[i].flags)) {
 				pr_debug("Writing stripe %llu block %d\n",
 				       (unsigned long long)sh->sector, i);
 				s->locked++;
-				set_bit(R5_Wantwrite, &sq->dev[i].flags);
+				set_bit(R5_Wantwrite, &sh->dev[i].flags);
 			}
 		/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
 		set_bit(STRIPE_INSYNC, &sh->state);
@@ -2439,7 +2444,7 @@ static void handle_issuing_new_write_req
 		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
 			atomic_dec(&conf->preread_active_stripes);
 			if (atomic_read(&conf->preread_active_stripes) <
-				IO_THRESHOLD)
+			    IO_THRESHOLD)
 				md_wakeup_thread(conf->mddev->thread);
 		}
 	}
@@ -2449,7 +2454,6 @@ static void handle_parity_checks5(raid5_
 				struct stripe_head_state *s, int disks)
 {
 	struct stripe_queue *sq = sh->sq;
-
 	set_bit(STRIPE_HANDLE, &sh->state);
 	/* Take one of the following actions:
 	 * 1/ start a check parity operation if (uptodate == disks)
@@ -2461,7 +2465,7 @@ static void handle_parity_checks5(raid5_
 	    !test_bit(STRIPE_OP_MOD_REPAIR_PD, &sh->ops.pending)) {
 		if (!test_and_set_bit(STRIPE_OP_CHECK, &sh->ops.pending)) {
 			BUG_ON(s->uptodate != disks);
-			clear_bit(R5_UPTODATE, &sq->dev[sq->pd_idx].flags);
+			clear_bit(R5_UPTODATE, &sh->dev[sq->pd_idx].flags);
 			sh->ops.count++;
 			s->uptodate--;
 		} else if (
@@ -2487,7 +2491,7 @@ static void handle_parity_checks5(raid5_
 					set_bit(STRIPE_OP_MOD_REPAIR_PD,
 						&sh->ops.pending);
 					set_bit(R5_Wantcompute,
-						&sq->dev[sq->pd_idx].flags);
+						&sh->dev[sq->pd_idx].flags);
 					sh->ops.target = sq->pd_idx;
 					sh->ops.count++;
 					s->uptodate++;
@@ -2512,16 +2516,17 @@ static void handle_parity_checks5(raid5_
 	if (!test_bit(STRIPE_INSYNC, &sh->state) &&
 		!test_bit(STRIPE_OP_CHECK, &sh->ops.pending) &&
 		!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) {
-		struct r5_queue_dev *dev_q;
+		struct r5dev *dev;
+
 		/* either failed parity check, or recovery is happening */
 		if (s->failed == 0)
 			s->failed_num = sq->pd_idx;
-		dev_q = &sq->dev[s->failed_num];
-		BUG_ON(!test_bit(R5_UPTODATE, &dev_q->flags));
+		dev = &sh->dev[s->failed_num];
+		BUG_ON(!test_bit(R5_UPTODATE, &dev->flags));
 		BUG_ON(s->uptodate != disks);
 
-		set_bit(R5_LOCKED, &dev_q->flags);
-		set_bit(R5_Wantwrite, &dev_q->flags);
+		set_bit(R5_LOCKED, &dev->flags);
+		set_bit(R5_Wantwrite, &dev->flags);
 		if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 			sh->ops.count++;
 
@@ -2539,7 +2544,7 @@ static void handle_parity_checks6(raid5_
 {
 	int update_p = 0, update_q = 0;
 	struct stripe_queue *sq = sh->sq;
-	struct r5_queue_dev *dev_q;
+	struct r5dev *dev;
 	int pd_idx = sq->pd_idx;
 	int qd_idx = r6s->qd_idx;
 
@@ -2596,29 +2601,29 @@ static void handle_parity_checks6(raid5_
 		 */
 
 		if (s->failed == 2) {
-			dev_q = &sq->dev[r6s->failed_num[1]];
+			dev = &sh->dev[r6s->failed_num[1]];
 			s->locked++;
-			set_bit(R5_LOCKED, &dev_q->flags);
-			set_bit(R5_Wantwrite, &dev_q->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
 		}
 		if (s->failed >= 1) {
-			dev_q = &sq->dev[r6s->failed_num[0]];
+			dev = &sh->dev[r6s->failed_num[0]];
 			s->locked++;
-			set_bit(R5_LOCKED, &dev_q->flags);
-			set_bit(R5_Wantwrite, &dev_q->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
 		}
 
 		if (update_p) {
-			dev_q = &sq->dev[pd_idx];
+			dev = &sh->dev[pd_idx];
 			s->locked++;
-			set_bit(R5_LOCKED, &dev_q->flags);
-			set_bit(R5_Wantwrite, &dev_q->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
 		}
 		if (update_q) {
-			dev_q = &sq->dev[qd_idx];
+			dev = &sh->dev[qd_idx];
 			s->locked++;
-			set_bit(R5_LOCKED, &dev_q->flags);
-			set_bit(R5_Wantwrite, &dev_q->flags);
+			set_bit(R5_LOCKED, &dev->flags);
+			set_bit(R5_Wantwrite, &dev->flags);
 		}
 		clear_bit(STRIPE_DEGRADED, &sh->state);
 
@@ -2657,7 +2662,7 @@ static void handle_stripe_expansion(raid
 				 */
 				continue;
 			if (!test_bit(STRIPE_EXPANDING, &sh2->state) ||
-			  test_bit(R5_Expanded, &sh2->sq->dev[dd_idx].flags)) {
+			   test_bit(R5_Expanded, &sh2->dev[dd_idx].flags)) {
 				/* must have already done this block */
 				release_stripe(sh2);
 				continue;
@@ -2668,13 +2673,12 @@ static void handle_stripe_expansion(raid
 				sh->dev[i].page, 0, 0, STRIPE_SIZE,
 				ASYNC_TX_DEP_ACK, tx, NULL, NULL);
 
-			set_bit(R5_Expanded, &sh2->sq->dev[dd_idx].flags);
-			set_bit(R5_UPTODATE, &sh2->sq->dev[dd_idx].flags);
+			set_bit(R5_Expanded, &sh2->dev[dd_idx].flags);
+			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
 			for (j = 0; j < conf->raid_disks; j++)
 				if (j != sh2->sq->pd_idx &&
 				    (r6s && j != r6s->qd_idx) &&
-				    !test_bit(R5_Expanded,
-				     &sh2->sq->dev[j].flags))
+				    !test_bit(R5_Expanded, &sh2->dev[j].flags))
 					break;
 			if (j == conf->raid_disks) {
 				set_bit(STRIPE_EXPAND_READY, &sh2->state);
@@ -2714,7 +2718,7 @@ static void handle_stripe5(struct stripe
 	int disks = sh->disks, i;
 	struct bio *return_bi = NULL;
 	struct stripe_head_state s;
-	struct r5_queue_dev *dev_q;
+	struct r5dev *dev;
 	unsigned long pending = 0;
 
 	memset(&s, 0, sizeof(s));
@@ -2736,12 +2740,11 @@ static void handle_stripe5(struct stripe
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
 		struct r5dev *dev = &sh->dev[i];
-
-		dev_q = &sq->dev[i];
-		clear_bit(R5_Insync, &dev_q->flags);
+		struct r5_queue_dev *dev_q = &sq->dev[i];
+		clear_bit(R5_Insync, &dev->flags);
 
 		pr_debug("check %d: state 0x%lx toread %p read %p write %p "
-			"written %p\n",	i, dev_q->flags, dev_q->toread,
+			"written %p\n",	i, dev->flags, dev_q->toread,
 			dev->read, dev_q->towrite, dev->written);
 
 		/* maybe we can request a biofill operation
@@ -2749,22 +2752,22 @@ static void handle_stripe5(struct stripe
 		 * new wantfill requests are only permitted while
 		 * STRIPE_OP_BIOFILL is clear
 		 */
-		if (test_bit(R5_UPTODATE, &dev_q->flags) && dev_q->toread &&
+		if (test_bit(R5_UPTODATE, &dev->flags) && dev_q->toread &&
 			!test_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
-			set_bit(R5_Wantfill, &dev_q->flags);
+			set_bit(R5_Wantfill, &dev->flags);
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev_q->flags)) s.locked++;
-		if (test_bit(R5_UPTODATE, &dev_q->flags)) s.uptodate++;
-		if (test_bit(R5_Wantcompute, &dev_q->flags)) s.compute++;
+		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
+		if (test_bit(R5_Wantcompute, &dev->flags)) s.compute++;
 
-		if (test_bit(R5_Wantfill, &dev_q->flags))
+		if (test_bit(R5_Wantfill, &dev->flags))
 			s.to_fill++;
 		else if (dev_q->toread)
 			s.to_read++;
 		if (dev_q->towrite) {
 			s.to_write++;
-			if (!test_bit(R5_OVERWRITE, &dev_q->flags))
+			if (!test_bit(R5_OVERWRITE, &dev->flags))
 				s.non_overwrite++;
 		}
 		if (dev->written)
@@ -2772,15 +2775,15 @@ static void handle_stripe5(struct stripe
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
-			clear_bit(R5_ReadError, &dev_q->flags);
-			clear_bit(R5_ReWrite, &dev_q->flags);
+			clear_bit(R5_ReadError, &dev->flags);
+			clear_bit(R5_ReWrite, &dev->flags);
 		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)
-		    || test_bit(R5_ReadError, &dev_q->flags)) {
+		    || test_bit(R5_ReadError, &dev->flags)) {
 			s.failed++;
 			s.failed_num = i;
 		} else
-			set_bit(R5_Insync, &dev_q->flags);
+			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
 
@@ -2806,11 +2809,11 @@ static void handle_stripe5(struct stripe
 	/* might be able to return some write requests if the parity block
 	 * is safe, or on a failed drive
 	 */
-	dev_q = &sq->dev[sq->pd_idx];
+	dev = &sh->dev[sq->pd_idx];
 	if ( s.written &&
-	     ((test_bit(R5_Insync, &dev_q->flags) &&
-	       !test_bit(R5_LOCKED, &dev_q->flags) &&
-	       test_bit(R5_UPTODATE, &dev_q->flags)) ||
+	     ((test_bit(R5_Insync, &dev->flags) &&
+	       !test_bit(R5_LOCKED, &dev->flags) &&
+	       test_bit(R5_UPTODATE, &dev->flags)) ||
 		(s.failed == 1 && s.failed_num == sq->pd_idx)))
 		handle_completed_write_requests(conf, sh, disks, &return_bi);
 
@@ -2838,7 +2841,7 @@ static void handle_stripe5(struct stripe
 		clear_bit(STRIPE_OP_PREXOR, &sh->ops.pending);
 
 		for (i = disks; i--; )
-			clear_bit(R5_Wantprexor, &sq->dev[i].flags);
+			clear_bit(R5_Wantprexor, &sh->dev[i].flags);
 	}
 
 	/* if only POSTXOR is set then this is an 'expand' postxor */
@@ -2856,19 +2859,17 @@ static void handle_stripe5(struct stripe
 		/* All the 'written' buffers and the parity block are ready to
 		 * be written back to disk
 		 */
-		BUG_ON(!test_bit(R5_UPTODATE, &sq->dev[sq->pd_idx].flags));
+		BUG_ON(!test_bit(R5_UPTODATE, &sh->dev[sq->pd_idx].flags));
 		for (i = disks; i--; ) {
-			struct r5dev *dev = &sh->dev[i];
-
-			dev_q = &sq->dev[i];
-			if (test_bit(R5_LOCKED, &dev_q->flags) &&
+			dev = &sh->dev[i];
+			if (test_bit(R5_LOCKED, &dev->flags) &&
 				(i == sq->pd_idx || dev->written)) {
 				pr_debug("Writing block %d\n", i);
-				set_bit(R5_Wantwrite, &dev_q->flags);
+				set_bit(R5_Wantwrite, &dev->flags);
 				if (!test_and_set_bit(
 				    STRIPE_OP_IO, &sh->ops.pending))
 					sh->ops.count++;
-				if (!test_bit(R5_Insync, &dev_q->flags) ||
+				if (!test_bit(R5_Insync, &dev->flags) ||
 				    (i == sq->pd_idx && s.failed == 0))
 					set_bit(STRIPE_INSYNC, &sh->state);
 			}
@@ -2912,24 +2913,24 @@ static void handle_stripe5(struct stripe
 	 * the repair/check process
 	 */
 	if (s.failed == 1 && !conf->mddev->ro &&
-	    test_bit(R5_ReadError, &sq->dev[s.failed_num].flags)
-	    && !test_bit(R5_LOCKED, &sq->dev[s.failed_num].flags)
-	    && test_bit(R5_UPTODATE, &sq->dev[s.failed_num].flags)
+	    test_bit(R5_ReadError, &sh->dev[s.failed_num].flags)
+	    && !test_bit(R5_LOCKED, &sh->dev[s.failed_num].flags)
+	    && test_bit(R5_UPTODATE, &sh->dev[s.failed_num].flags)
 		) {
-		dev_q = &sq->dev[s.failed_num];
-		if (!test_bit(R5_ReWrite, &dev_q->flags)) {
-			set_bit(R5_Wantwrite, &dev_q->flags);
+		dev = &sh->dev[s.failed_num];
+		if (!test_bit(R5_ReWrite, &dev->flags)) {
+			set_bit(R5_Wantwrite, &dev->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
-			set_bit(R5_ReWrite, &dev_q->flags);
-			set_bit(R5_LOCKED, &dev_q->flags);
+			set_bit(R5_ReWrite, &dev->flags);
+			set_bit(R5_LOCKED, &dev->flags);
 			s.locked++;
 		} else {
 			/* let's read it back */
-			set_bit(R5_Wantread, &dev_q->flags);
+			set_bit(R5_Wantread, &dev->flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
-			set_bit(R5_LOCKED, &dev_q->flags);
+			set_bit(R5_LOCKED, &dev->flags);
 			s.locked++;
 		}
 	}
@@ -2947,7 +2948,7 @@ static void handle_stripe5(struct stripe
 		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.complete);
 
 		for (i = conf->raid_disks; i--; ) {
-			set_bit(R5_Wantwrite, &sq->dev[i].flags);
+			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 			if (!test_and_set_bit(STRIPE_OP_IO, &sh->ops.pending))
 				sh->ops.count++;
 		}
@@ -2992,7 +2993,7 @@ static void handle_stripe6(struct stripe
 	int i, pd_idx = sq->pd_idx;
 	struct stripe_head_state s;
 	struct r6_state r6s;
-	struct r5_queue_dev *dev_q, *pdev_q, *qdev_q;
+	struct r5dev *dev, *pdev, *qdev;
 
 	r6s.qd_idx = raid6_next_disk(pd_idx, disks);
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
@@ -3013,22 +3014,22 @@ static void handle_stripe6(struct stripe
 	rcu_read_lock();
 	for (i=disks; i--; ) {
 		mdk_rdev_t *rdev;
-		struct r5dev *dev = &sh->dev[i];
+		struct r5_queue_dev *dev_q = &sq->dev[i];
 
-		dev_q = &sq->dev[i];
-		clear_bit(R5_Insync, &dev_q->flags);
+		dev = &sh->dev[i];
+		clear_bit(R5_Insync, &dev->flags);
 
 		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
-			i, dev_q->flags, dev_q->toread, dev_q->towrite,
+			i, dev->flags, dev_q->toread, dev_q->towrite,
 			dev->written);
 		/* maybe we can reply to a read */
-		if (test_bit(R5_UPTODATE, &dev_q->flags) && dev_q->toread) {
+		if (test_bit(R5_UPTODATE, &dev->flags) && dev_q->toread) {
 			struct bio *rbi, *rbi2;
 			pr_debug("Return read for disc %d\n", i);
 			spin_lock_irq(&conf->device_lock);
 			rbi = dev_q->toread;
 			dev_q->toread = NULL;
-			if (test_and_clear_bit(R5_Overlap, &dev_q->flags))
+			if (test_and_clear_bit(R5_Overlap, &dev->flags))
 				wake_up(&conf->wait_for_overlap);
 			spin_unlock_irq(&conf->device_lock);
 			while (rbi && rbi->bi_sector <
@@ -3046,15 +3047,15 @@ static void handle_stripe6(struct stripe
 		}
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev_q->flags)) s.locked++;
-		if (test_bit(R5_UPTODATE, &dev_q->flags)) s.uptodate++;
+		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
 
 
 		if (dev_q->toread)
 			s.to_read++;
 		if (dev_q->towrite) {
 			s.to_write++;
-			if (!test_bit(R5_OVERWRITE, &dev_q->flags))
+			if (!test_bit(R5_OVERWRITE, &dev->flags))
 				s.non_overwrite++;
 		}
 		if (dev->written)
@@ -3062,16 +3063,16 @@ static void handle_stripe6(struct stripe
 		rdev = rcu_dereference(conf->disks[i].rdev);
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
-			clear_bit(R5_ReadError, &dev_q->flags);
-			clear_bit(R5_ReWrite, &dev_q->flags);
+			clear_bit(R5_ReadError, &dev->flags);
+			clear_bit(R5_ReWrite, &dev->flags);
 		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)
-		    || test_bit(R5_ReadError, &dev_q->flags)) {
+		    || test_bit(R5_ReadError, &dev->flags)) {
 			if (s.failed < 2)
 				r6s.failed_num[s.failed] = i;
 			s.failed++;
 		} else
-			set_bit(R5_Insync, &dev_q->flags);
+			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
 	pr_debug("locked=%d uptodate=%d to_read=%d"
@@ -3094,20 +3095,20 @@ static void handle_stripe6(struct stripe
 	 * might be able to return some write requests if the parity blocks
 	 * are safe, or on a failed drive
 	 */
-	pdev_q = &sq->dev[pd_idx];
+	pdev = &sh->dev[pd_idx];
 	r6s.p_failed = (s.failed >= 1 && r6s.failed_num[0] == pd_idx)
 		|| (s.failed >= 2 && r6s.failed_num[1] == pd_idx);
-	qdev_q = &sq->dev[r6s.qd_idx];
+	qdev = &sh->dev[r6s.qd_idx];
 	r6s.q_failed = (s.failed >= 1 && r6s.failed_num[0] == r6s.qd_idx)
 		|| (s.failed >= 2 && r6s.failed_num[1] == r6s.qd_idx);
 
 	if ( s.written &&
-	     ( r6s.p_failed || ((test_bit(R5_Insync, &pdev_q->flags)
-			     && !test_bit(R5_LOCKED, &pdev_q->flags)
-			     && test_bit(R5_UPTODATE, &pdev_q->flags)))) &&
-	     ( r6s.q_failed || ((test_bit(R5_Insync, &qdev_q->flags)
-			     && !test_bit(R5_LOCKED, &qdev_q->flags)
-			     && test_bit(R5_UPTODATE, &qdev_q->flags)))))
+	     ( r6s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
+			     && !test_bit(R5_LOCKED, &pdev->flags)
+			     && test_bit(R5_UPTODATE, &pdev->flags)))) &&
+	     ( r6s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
+			     && !test_bit(R5_LOCKED, &qdev->flags)
+			     && test_bit(R5_UPTODATE, &qdev->flags)))))
 		handle_completed_write_requests(conf, sh, disks, &return_bi);
 
 	/* Now we might consider reading some blocks, either to check/generate
@@ -3139,19 +3140,19 @@ static void handle_stripe6(struct stripe
 	 */
 	if (s.failed <= 2 && !conf->mddev->ro)
 		for (i = 0; i < s.failed; i++) {
-			dev_q = &sq->dev[r6s.failed_num[i]];
-			if (test_bit(R5_ReadError, &dev_q->flags)
-			    && !test_bit(R5_LOCKED, &dev_q->flags)
-			    && test_bit(R5_UPTODATE, &dev_q->flags)
+			dev = &sh->dev[r6s.failed_num[i]];
+			if (test_bit(R5_ReadError, &dev->flags)
+			    && !test_bit(R5_LOCKED, &dev->flags)
+			    && test_bit(R5_UPTODATE, &dev->flags)
 				) {
-				if (!test_bit(R5_ReWrite, &dev_q->flags)) {
-					set_bit(R5_Wantwrite, &dev_q->flags);
-					set_bit(R5_ReWrite, &dev_q->flags);
-					set_bit(R5_LOCKED, &dev_q->flags);
+				if (!test_bit(R5_ReWrite, &dev->flags)) {
+					set_bit(R5_Wantwrite, &dev->flags);
+					set_bit(R5_ReWrite, &dev->flags);
+					set_bit(R5_LOCKED, &dev->flags);
 				} else {
 					/* let's read it back */
-					set_bit(R5_Wantread, &dev_q->flags);
-					set_bit(R5_LOCKED, &dev_q->flags);
+					set_bit(R5_Wantread, &dev->flags);
+					set_bit(R5_LOCKED, &dev->flags);
 				}
 			}
 		}
@@ -3163,9 +3164,9 @@ static void handle_stripe6(struct stripe
 					     conf->raid_disks);
 		compute_parity6(sh, RECONSTRUCT_WRITE);
 		for (i = conf->raid_disks ; i-- ;  ) {
-			set_bit(R5_LOCKED, &sq->dev[i].flags);
+			set_bit(R5_LOCKED, &sh->dev[i].flags);
 			s.locked++;
-			set_bit(R5_Wantwrite, &sq->dev[i].flags);
+			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 		}
 		clear_bit(STRIPE_EXPANDING, &sh->state);
 	} else if (s.expanded) {
@@ -3186,9 +3187,9 @@ static void handle_stripe6(struct stripe
 		int rw;
 		struct bio *bi;
 		mdk_rdev_t *rdev;
-		if (test_and_clear_bit(R5_Wantwrite, &sq->dev[i].flags))
+		if (test_and_clear_bit(R5_Wantwrite, &sh->dev[i].flags))
 			rw = WRITE;
-		else if (test_and_clear_bit(R5_Wantread, &sq->dev[i].flags))
+		else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
 			rw = READ;
 		else
 			continue;
@@ -3228,7 +3229,7 @@ static void handle_stripe6(struct stripe
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
 			if (rw == WRITE &&
-			    test_bit(R5_ReWrite, &sq->dev[i].flags))
+			    test_bit(R5_ReWrite, &sh->dev[i].flags))
 				atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
 			generic_make_request(bi);
 		} else {
@@ -3236,7 +3237,7 @@ static void handle_stripe6(struct stripe
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
-			clear_bit(R5_LOCKED, &sq->dev[i].flags);
+			clear_bit(R5_LOCKED, &sh->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
 	}
@@ -3574,6 +3575,7 @@ static int chunk_aligned_read(request_qu
 	}
 }
 
+
 static int make_request(request_queue_t *q, struct bio * bi)
 {
 	mddev_t *mddev = q->queuedata;
@@ -3797,14 +3799,14 @@ static sector_t reshape_request(mddev_t 
 			    j == raid6_next_disk(pd_idx, sh->disks))
 				continue;
 			s = compute_blocknr(conf, sh->disks, sh->sector,
-					pd_idx, j);
+					    pd_idx, j);
 			if (s < (mddev->array_size<<1)) {
 				skipped = 1;
 				continue;
 			}
 			memset(page_address(sh->dev[j].page), 0, STRIPE_SIZE);
-			set_bit(R5_Expanded, &sh->sq->dev[j].flags);
-			set_bit(R5_UPTODATE, &sh->sq->dev[j].flags);
+			set_bit(R5_Expanded, &sh->dev[j].flags);
+			set_bit(R5_UPTODATE, &sh->dev[j].flags);
 		}
 		if (!skipped) {
 			set_bit(STRIPE_EXPAND_READY, &sh->state);
@@ -3977,7 +3979,7 @@ static int  retry_aligned_read(raid5_con
 		}
 
 		sq = sh->sq;
-		set_bit(R5_ReadError, &sq->dev[dd_idx].flags);
+		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
 			release_stripe(sh);
 			raid_bio->bi_hw_segments = scnt;
@@ -4452,7 +4454,7 @@ static void print_sh (struct seq_file *s
 	seq_printf(seq, "sh %llu, ", (unsigned long long)sh->sector);
 	for (i = 0; i < sh->disks; i++) {
 		seq_printf(seq, "(cache%d: %p %ld) ",
-			   i, sh->dev[i].page, sq->dev[i].flags);
+			   i, sh->dev[i].page, sh->dev[i].flags);
 	}
 	seq_printf(seq, "\n");
 }
diff -puN include/linux/raid/raid5.h~raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2 include/linux/raid/raid5.h
--- a/include/linux/raid/raid5.h~raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2
+++ a/include/linux/raid/raid5.h
@@ -187,6 +187,7 @@ struct stripe_head {
 		struct bio_vec	vec;
 		struct page	*page;
 		struct bio	*read, *written;
+		unsigned long flags;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
 
@@ -214,7 +215,6 @@ struct stripe_queue {
 	struct r5_queue_dev {
 		sector_t sector; /* hw starting sector for this block */
 		struct bio *toread, *towrite;
-		unsigned long flags;
 	} dev[1];
 };
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

git-md-accel.patch
remove-unsafe-from-module-struct.patch
raid5-add-the-stripe_queue-object-for-tracking-raid-io-requests-take2.patch
raid5-use-stripe_queues-to-prioritize-the-most.patch
