From: akpm@linux-foundation.org
Subject: - md-add-support-for-reshape-of-a-raid6.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:08 -0800
Message-ID: <200703020506.l22568sg000768@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42238 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422658AbXCBFGN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: add support for reshape of a raid6
has been removed from the -mm tree.  Its filename was
     md-add-support-for-reshape-of-a-raid6.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: add support for reshape of a raid6
From: NeilBrown <neilb@suse.de>

i.e. one or more drives can be added and the array will re-stripe
while on-line.

Most of the interesting work was already done for raid5.  This just extends it
to raid6.

mdadm newer than 2.6 is needed for complete safety, however any version of
mdadm which support raid5 reshape will do a good enough job in almost all
cases (an 'echo repair > /sys/block/mdX/md/sync_action' is recommended after a
reshape that was aborted and had to be restarted with an such a version of
mdadm).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c |  157 +++++++++++++++++++++++++++++++++----------
 1 file changed, 124 insertions(+), 33 deletions(-)

diff -puN drivers/md/raid5.c~md-add-support-for-reshape-of-a-raid6 drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-add-support-for-reshape-of-a-raid6
+++ a/drivers/md/raid5.c
@@ -1050,7 +1050,7 @@ static void compute_parity5(struct strip
 static void compute_parity6(struct stripe_head *sh, int method)
 {
 	raid6_conf_t *conf = sh->raid_conf;
-	int i, pd_idx = sh->pd_idx, qd_idx, d0_idx, disks = conf->raid_disks, count;
+	int i, pd_idx = sh->pd_idx, qd_idx, d0_idx, disks = sh->disks, count;
 	struct bio *chosen;
 	/**** FIX THIS: This could be very bad if disks is close to 256 ****/
 	void *ptrs[disks];
@@ -1131,8 +1131,7 @@ static void compute_parity6(struct strip
 /* Compute one missing block */
 static void compute_block_1(struct stripe_head *sh, int dd_idx, int nozero)
 {
-	raid6_conf_t *conf = sh->raid_conf;
-	int i, count, disks = conf->raid_disks;
+	int i, count, disks = sh->disks;
 	void *ptr[MAX_XOR_BLOCKS], *p;
 	int pd_idx = sh->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
@@ -1170,8 +1169,7 @@ static void compute_block_1(struct strip
 /* Compute two missing blocks */
 static void compute_block_2(struct stripe_head *sh, int dd_idx1, int dd_idx2)
 {
-	raid6_conf_t *conf = sh->raid_conf;
-	int i, count, disks = conf->raid_disks;
+	int i, count, disks = sh->disks;
 	int pd_idx = sh->pd_idx;
 	int qd_idx = raid6_next_disk(pd_idx, disks);
 	int d0_idx = raid6_next_disk(qd_idx, disks);
@@ -1887,11 +1885,11 @@ static void handle_stripe5(struct stripe
 static void handle_stripe6(struct stripe_head *sh, struct page *tmp_page)
 {
 	raid6_conf_t *conf = sh->raid_conf;
-	int disks = conf->raid_disks;
+	int disks = sh->disks;
 	struct bio *return_bi= NULL;
 	struct bio *bi;
 	int i;
-	int syncing;
+	int syncing, expanding, expanded;
 	int locked=0, uptodate=0, to_read=0, to_write=0, failed=0, written=0;
 	int non_overwrite = 0;
 	int failed_num[2] = {0, 0};
@@ -1909,6 +1907,8 @@ static void handle_stripe6(struct stripe
 	clear_bit(STRIPE_DELAYED, &sh->state);
 
 	syncing = test_bit(STRIPE_SYNCING, &sh->state);
+	expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+	expanded = test_bit(STRIPE_EXPAND_READY, &sh->state);
 	/* Now to look around and see what can be done */
 
 	rcu_read_lock();
@@ -2114,13 +2114,15 @@ static void handle_stripe6(struct stripe
 	 * parity, or to satisfy requests
 	 * or to load a block that is being partially written.
 	 */
-	if (to_read || non_overwrite || (to_write && failed) || (syncing && (uptodate < disks))) {
+	if (to_read || non_overwrite || (to_write && failed) ||
+	    (syncing && (uptodate < disks)) || expanding) {
 		for (i=disks; i--;) {
 			dev = &sh->dev[i];
 			if (!test_bit(R5_LOCKED, &dev->flags) && !test_bit(R5_UPTODATE, &dev->flags) &&
 			    (dev->toread ||
 			     (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)) ||
 			     syncing ||
+			     expanding ||
 			     (failed >= 1 && (sh->dev[failed_num[0]].toread || to_write)) ||
 			     (failed >= 2 && (sh->dev[failed_num[1]].toread || to_write))
 				    )
@@ -2355,6 +2357,79 @@ static void handle_stripe6(struct stripe
 				}
 			}
 		}
+
+	if (expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
+		/* Need to write out all blocks after computing P&Q */
+		sh->disks = conf->raid_disks;
+		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
+					     conf->raid_disks);
+		compute_parity6(sh, RECONSTRUCT_WRITE);
+		for (i = conf->raid_disks ; i-- ;  ) {
+			set_bit(R5_LOCKED, &sh->dev[i].flags);
+			locked++;
+			set_bit(R5_Wantwrite, &sh->dev[i].flags);
+		}
+		clear_bit(STRIPE_EXPANDING, &sh->state);
+	} else if (expanded) {
+		clear_bit(STRIPE_EXPAND_READY, &sh->state);
+		atomic_dec(&conf->reshape_stripes);
+		wake_up(&conf->wait_for_overlap);
+		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
+	}
+
+	if (expanding && locked == 0) {
+		/* We have read all the blocks in this stripe and now we need to
+		 * copy some of them into a target stripe for expand.
+		 */
+		clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
+		for (i = 0; i < sh->disks ; i++)
+			if (i != pd_idx && i != qd_idx) {
+				int dd_idx2, pd_idx2, j;
+				struct stripe_head *sh2;
+
+				sector_t bn = compute_blocknr(sh, i);
+				sector_t s = raid5_compute_sector(
+					bn, conf->raid_disks,
+					conf->raid_disks - conf->max_degraded,
+					&dd_idx2, &pd_idx2, conf);
+				sh2 = get_active_stripe(conf, s,
+							conf->raid_disks,
+						       pd_idx2, 1);
+				if (sh2 == NULL)
+					/* so for only the early blocks of
+					 * this stripe have been requests.
+					 * When later blocks get requests, we
+					 * will try again
+					 */
+					continue;
+				if (!test_bit(STRIPE_EXPANDING, &sh2->state) ||
+				    test_bit(R5_Expanded,
+					     &sh2->dev[dd_idx2].flags)) {
+					/* must have already done this block */
+					release_stripe(sh2);
+					continue;
+				}
+				memcpy(page_address(sh2->dev[dd_idx2].page),
+				       page_address(sh->dev[i].page),
+				       STRIPE_SIZE);
+				set_bit(R5_Expanded, &sh2->dev[dd_idx2].flags);
+				set_bit(R5_UPTODATE, &sh2->dev[dd_idx2].flags);
+				for (j = 0 ; j < conf->raid_disks ; j++)
+					if (j != sh2->pd_idx &&
+					    j != raid6_next_disk(sh2->pd_idx,
+							   sh2->disks) &&
+					    !test_bit(R5_Expanded,
+						      &sh2->dev[j].flags))
+						break;
+				if (j == conf->raid_disks) {
+					set_bit(STRIPE_EXPAND_READY,
+						&sh2->state);
+					set_bit(STRIPE_HANDLE, &sh2->state);
+				}
+				release_stripe(sh2);
+			}
+	}
+
 	spin_unlock(&sh->lock);
 
 	while ((bi=return_bi)) {
@@ -2395,7 +2470,7 @@ static void handle_stripe6(struct stripe
 		rcu_read_unlock();
 
 		if (rdev) {
-			if (syncing)
+			if (syncing || expanding || expanded)
 				md_sync_acct(rdev->bdev, STRIPE_SECTORS);
 
 			bi->bi_bdev = rdev->bdev;
@@ -2915,8 +2990,9 @@ static sector_t reshape_request(mddev_t 
 	struct stripe_head *sh;
 	int pd_idx;
 	sector_t first_sector, last_sector;
-	int raid_disks;
-	int data_disks;
+	int raid_disks = conf->previous_raid_disks;
+	int data_disks = raid_disks - conf->max_degraded;
+	int new_data_disks = conf->raid_disks - conf->max_degraded;
 	int i;
 	int dd_idx;
 	sector_t writepos, safepos, gap;
@@ -2925,7 +3001,7 @@ static sector_t reshape_request(mddev_t 
 	    conf->expand_progress != 0) {
 		/* restarting in the middle, skip the initial sectors */
 		sector_nr = conf->expand_progress;
-		sector_div(sector_nr, conf->raid_disks-1);
+		sector_div(sector_nr, new_data_disks);
 		*skipped = 1;
 		return sector_nr;
 	}
@@ -2939,14 +3015,14 @@ static sector_t reshape_request(mddev_t 
 	 * to after where expand_lo old_maps to
 	 */
 	writepos = conf->expand_progress +
-		conf->chunk_size/512*(conf->raid_disks-1);
-	sector_div(writepos, conf->raid_disks-1);
+		conf->chunk_size/512*(new_data_disks);
+	sector_div(writepos, new_data_disks);
 	safepos = conf->expand_lo;
-	sector_div(safepos, conf->previous_raid_disks-1);
+	sector_div(safepos, data_disks);
 	gap = conf->expand_progress - conf->expand_lo;
 
 	if (writepos >= safepos ||
-	    gap > (conf->raid_disks-1)*3000*2 /*3Meg*/) {
+	    gap > (new_data_disks)*3000*2 /*3Meg*/) {
 		/* Cannot proceed until we've updated the superblock... */
 		wait_event(conf->wait_for_overlap,
 			   atomic_read(&conf->reshape_stripes)==0);
@@ -2976,6 +3052,9 @@ static sector_t reshape_request(mddev_t 
 			sector_t s;
 			if (j == sh->pd_idx)
 				continue;
+			if (conf->level == 6 &&
+			    j == raid6_next_disk(sh->pd_idx, sh->disks))
+				continue;
 			s = compute_blocknr(sh, j);
 			if (s < (mddev->array_size<<1)) {
 				skipped = 1;
@@ -2999,21 +3078,20 @@ static sector_t reshape_request(mddev_t 
 	 * The source stripes are determined by mapping the first and last
 	 * block on the destination stripes.
 	 */
-	raid_disks = conf->previous_raid_disks;
-	data_disks = raid_disks - 1;
 	first_sector =
-		raid5_compute_sector(sector_nr*(conf->raid_disks-1),
+		raid5_compute_sector(sector_nr*(new_data_disks),
 				     raid_disks, data_disks,
 				     &dd_idx, &pd_idx, conf);
 	last_sector =
 		raid5_compute_sector((sector_nr+conf->chunk_size/512)
-				     *(conf->raid_disks-1) -1,
+				     *(new_data_disks) -1,
 				     raid_disks, data_disks,
 				     &dd_idx, &pd_idx, conf);
 	if (last_sector >= (mddev->size<<1))
 		last_sector = (mddev->size<<1)-1;
 	while (first_sector <= last_sector) {
-		pd_idx = stripe_to_pdidx(first_sector, conf, conf->previous_raid_disks);
+		pd_idx = stripe_to_pdidx(first_sector, conf,
+					 conf->previous_raid_disks);
 		sh = get_active_stripe(conf, first_sector,
 				       conf->previous_raid_disks, pd_idx, 0);
 		set_bit(STRIPE_EXPAND_SOURCE, &sh->state);
@@ -3348,35 +3426,44 @@ static int run(mddev_t *mddev)
 		 */
 		sector_t here_new, here_old;
 		int old_disks;
+		int max_degraded = (mddev->level == 5 ? 1 : 2);
 
 		if (mddev->new_level != mddev->level ||
 		    mddev->new_layout != mddev->layout ||
 		    mddev->new_chunk != mddev->chunk_size) {
-			printk(KERN_ERR "raid5: %s: unsupported reshape required - aborting.\n",
+			printk(KERN_ERR "raid5: %s: unsupported reshape "
+			       "required - aborting.\n",
 			       mdname(mddev));
 			return -EINVAL;
 		}
 		if (mddev->delta_disks <= 0) {
-			printk(KERN_ERR "raid5: %s: unsupported reshape (reduce disks) required - aborting.\n",
+			printk(KERN_ERR "raid5: %s: unsupported reshape "
+			       "(reduce disks) required - aborting.\n",
 			       mdname(mddev));
 			return -EINVAL;
 		}
 		old_disks = mddev->raid_disks - mddev->delta_disks;
 		/* reshape_position must be on a new-stripe boundary, and one
-		 * further up in new geometry must map after here in old geometry.
+		 * further up in new geometry must map after here in old
+		 * geometry.
 		 */
 		here_new = mddev->reshape_position;
-		if (sector_div(here_new, (mddev->chunk_size>>9)*(mddev->raid_disks-1))) {
-			printk(KERN_ERR "raid5: reshape_position not on a stripe boundary\n");
+		if (sector_div(here_new, (mddev->chunk_size>>9)*
+			       (mddev->raid_disks - max_degraded))) {
+			printk(KERN_ERR "raid5: reshape_position not "
+			       "on a stripe boundary\n");
 			return -EINVAL;
 		}
 		/* here_new is the stripe we will write to */
 		here_old = mddev->reshape_position;
-		sector_div(here_old, (mddev->chunk_size>>9)*(old_disks-1));
-		/* here_old is the first stripe that we might need to read from */
+		sector_div(here_old, (mddev->chunk_size>>9)*
+			   (old_disks-max_degraded));
+		/* here_old is the first stripe that we might need to read
+		 * from */
 		if (here_new >= here_old) {
 			/* Reading from the same stripe as writing to - bad */
-			printk(KERN_ERR "raid5: reshape_position too early for auto-recovery - aborting.\n");
+			printk(KERN_ERR "raid5: reshape_position too early for "
+			       "auto-recovery - aborting.\n");
 			return -EINVAL;
 		}
 		printk(KERN_INFO "raid5: reshape will continue\n");
@@ -3829,8 +3916,7 @@ static int raid5_start_reshape(mddev_t *
 	int added_devices = 0;
 	unsigned long flags;
 
-	if (mddev->degraded ||
-	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return -EBUSY;
 
 	ITERATE_RDEV(mddev, rdev, rtmp)
@@ -3838,7 +3924,7 @@ static int raid5_start_reshape(mddev_t *
 		    !test_bit(Faulty, &rdev->flags))
 			spares++;
 
-	if (spares < mddev->delta_disks-1)
+	if (spares - mddev->degraded < mddev->delta_disks - conf->max_degraded)
 		/* Not enough devices even to make a degraded array
 		 * of that size
 		 */
@@ -3901,7 +3987,8 @@ static void end_reshape(raid5_conf_t *co
 	struct block_device *bdev;
 
 	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
-		conf->mddev->array_size = conf->mddev->size * (conf->raid_disks-1);
+		conf->mddev->array_size = conf->mddev->size *
+			(conf->raid_disks - conf->max_degraded);
 		set_capacity(conf->mddev->gendisk, conf->mddev->array_size << 1);
 		conf->mddev->changed = 1;
 
@@ -3974,6 +4061,10 @@ static struct mdk_personality raid6_pers
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
+#ifdef CONFIG_MD_RAID5_RESHAPE
+	.check_reshape	= raid5_check_reshape,
+	.start_reshape  = raid5_start_reshape,
+#endif
 	.quiesce	= raid5_quiesce,
 };
 static struct mdk_personality raid5_personality =
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch
knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet.patch
knfsd-remove-config_ipv6-ifdefs-from-sunrpc-server-code.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous-tidy.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
md-fix-for-raid6-reshape.patch
