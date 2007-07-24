From: akpm@linux-foundation.org
Subject: - raid5-use-stripe_queues-to-prioritize-the-most.patch removed from -mm tree
Date: Mon, 23 Jul 2007 23:04:14 -0700
Message-ID: <200707240604.l6O64E70031426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441AbXGXGEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 02:04:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     raid5: use stripe_queues to prioritize the "most deserving" requests
has been removed from the -mm tree.  Its filename was
     raid5-use-stripe_queues-to-prioritize-the-most.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: raid5: use stripe_queues to prioritize the "most deserving" requests
From: Dan Williams <dan.j.williams@intel.com>

Overview:
Taking advantage of the stripe_queue/stripe_head separation, this patch
implements a queue in front of the stripe cache.  A stripe_queue pool
accepts incoming requests.  As requests are attached, the weight of the
queue object is updated.  A workqueue is introduced to control the flow of
requests to the stripe cache.  Pressure (weight of the queue object) can
push requests to be processed by the the cache (raid5d).  raid5d also pulls
requests when its 'handle' list is empty.

The workqueue, raid5qd, prioritizes reads and full stripe-writes, as there
is no performance to be gained by delaying them.  Sub-stripe-width writes
are handled by the existing PREREAD_ACTIVE infrastructure, but can now be
passed by full-stripe-writes on their way to the cache.  Previously there
was no opportunity to make this decision, sub-width-writes would occupy a
stripe cache entry from the time they entered the delayed list until they
finished processing.

Flow:
1/ make_request calls get_active_queue, add_queue_bio, and handle_queue
2/ handle_queue checks to see if this stripe_queue is already attached to a
   stripe_head and if so we bypass the queue and handle the stripe
   immediately, done.  Otherwise, handle_queue checks the incoming requests
   and flags the queue as overwrite, read, sub-width-write, or delayed.
3/ __release_queue is called and depending on the determination made by
   handle queue the stripe_queue is placed on one of four lists.  Then raid5qd
   is woken up.
4/ raid5qd runs and attaches stripe_queues to stripe_heads in priority
   order (full-stripe-writes, reads, sub-width-writes).  If the raid device is
   not plugged and there is nothing else to do it will transition delayed
   queues to the sub-width-write list.  Since there are more stripe_queues in
   the system than stripe_heads we will end up sleeping in get_active_stripe.
   While sleeping requests can still enter the queue and hopefully promote
   sub-width-writes to full-stripe-writes.

Details:
* the number of stripe_queue objects in the pool is set at 2x the maximum
  number of stripes in the stripe_cache (STRIPE_QUEUE_SIZE).
* stripe_queues are tracked in a red-black-tree
* a stripe_queue is considered active while it has STRIPE_QUEUE_HANDLED
  set, or it is attached to a stripe_head
* once a stripe_queue is activated it is not placed on the inactive list
  until it has been serviced by the stripe cache

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid5.c         | 1123 ++++++++++++++++++++++++++---------
 include/linux/raid/raid5.h |   61 +
 2 files changed, 907 insertions(+), 277 deletions(-)

diff -puN drivers/md/raid5.c~raid5-use-stripe_queues-to-prioritize-the-most drivers/md/raid5.c
--- a/drivers/md/raid5.c~raid5-use-stripe_queues-to-prioritize-the-most
+++ a/drivers/md/raid5.c
@@ -65,6 +65,7 @@
 #define	IO_THRESHOLD		1
 #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
+#define STRIPE_QUEUE_SIZE 2 /* multiple of nr_stripes */
 
 #define stripe_hash(conf, sect)	(&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))
 
@@ -78,6 +79,8 @@
  * of the current stripe+device
  */
 #define r5_next_bio(bio, sect) ( ( (bio)->bi_sector + ((bio)->bi_size>>9) < sect + STRIPE_SECTORS) ? (bio)->bi_next : NULL)
+#define r5_io_weight_size(devs) (sizeof(unsigned long) * \
+				  (ALIGN(devs, BITS_PER_LONG) / BITS_PER_LONG))
 /*
  * The following can be used to debug the driver
  */
@@ -122,41 +125,107 @@ static void return_io(struct bio *return
 
 static void print_raid5_conf (raid5_conf_t *conf);
 
+/* __release_queue - route the stripe_queue based on pending i/o's.  The
+ * queue object is allowed to bounce around between 4 lists up until
+ * it is attached to a stripe_head.  The lists in order of priority are:
+ * 1/ overwrite: all data blocks are set to be overwritten, no prereads
+ * 2/ unaligned_read: read requests that get past chunk_aligned_read
+ * 3/ subwidth_write: write requests that require prereading
+ * 4/ delayed_q: write requests pending activation
+ */
+static struct stripe_queue init_sq; /* sq for newborn stripe_heads */
+static struct stripe_head init_sh; /* sh for newborn stripe_queues */
+static void __release_queue(raid5_conf_t *conf, struct stripe_queue *sq)
+{
+	if (atomic_dec_and_test(&sq->count)) {
+		BUG_ON(!list_empty(&sq->list_node));
+		BUG_ON(atomic_read(&conf->active_queues) == 0);
+		if (test_bit(STRIPE_QUEUE_HANDLE, &sq->state)) {
+			BUG_ON(sq->sh);
+			if (test_bit(STRIPE_QUEUE_IO_HI, &sq->state)) {
+				list_add_tail(&sq->list_node,
+						&conf->io_hi_queue);
+				queue_work(conf->workqueue,
+					   &conf->stripe_queue_work);
+			} else if (test_bit(STRIPE_QUEUE_IO_LO, &sq->state)) {
+				list_add_tail(&sq->list_node,
+					       &conf->io_lo_queue);
+				queue_work(conf->workqueue,
+					   &conf->stripe_queue_work);
+			} else if (test_bit(STRIPE_QUEUE_DELAYED, &sq->state)) {
+				list_add_tail(&sq->list_node,
+					       &conf->delayed_q_list);
+				blk_plug_device(conf->mddev->queue);
+			} else {
+				/* nothing to handle */
+				sq->sh = &init_sh;
+				clear_bit(STRIPE_QUEUE_HANDLE, &sq->state);
+				goto nothing_to_handle; /* fall through */
+			}
+		} else {
+nothing_to_handle:
+			BUG_ON(sq->sh == NULL);
+			sq->sh->sq = NULL;
+			sq->sh = NULL;
+			atomic_dec(&conf->active_queues);
+			if (test_and_clear_bit(STRIPE_QUEUE_PREREAD_ACTIVE,
+						&sq->state)) {
+				atomic_dec(&conf->preread_active_queues);
+				if (atomic_read(&conf->preread_active_queues) <
+					IO_THRESHOLD)
+					queue_work(conf->workqueue,
+						   &conf->stripe_queue_work);
+			}
+			if (!test_bit(STRIPE_QUEUE_EXPANDING, &sq->state)) {
+				list_add_tail(&sq->list_node,
+					      &conf->inactive_queue_list);
+				wake_up(&conf->wait_for_queue);
+				if (conf->retry_read_aligned)
+					md_wakeup_thread(conf->mddev->thread);
+			}
+		}
+	}
+}
+
 static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 {
+	struct stripe_queue *sq = sh->sq;
+
 	if (atomic_dec_and_test(&sh->count)) {
 		BUG_ON(!list_empty(&sh->lru));
 		BUG_ON(atomic_read(&conf->active_stripes)==0);
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
-			if (test_bit(STRIPE_DELAYED, &sh->state)) {
-				list_add_tail(&sh->lru, &conf->delayed_list);
-				blk_plug_device(conf->mddev->queue);
-			} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
-				   sh->sq->bm_seq - conf->seq_write > 0) {
+			if (test_bit(STRIPE_QUEUE_BIT_DELAY, &sq->state) &&
+				   sq->bm_seq - conf->seq_write > 0) {
 				list_add_tail(&sh->lru, &conf->bitmap_list);
 				blk_plug_device(conf->mddev->queue);
 			} else {
-				clear_bit(STRIPE_BIT_DELAY, &sh->state);
+				clear_bit(STRIPE_QUEUE_BIT_DELAY, &sq->state);
 				list_add_tail(&sh->lru, &conf->handle_list);
 			}
 			md_wakeup_thread(conf->mddev->thread);
 		} else {
 			BUG_ON(sh->ops.pending);
-			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-				atomic_dec(&conf->preread_active_stripes);
-				if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD)
-					md_wakeup_thread(conf->mddev->thread);
-			}
 			atomic_dec(&conf->active_stripes);
-			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
+			__release_queue(conf, sq);
+			if (!test_bit(STRIPE_QUEUE_EXPANDING, &sq->state)) {
 				list_add_tail(&sh->lru, &conf->inactive_list);
 				wake_up(&conf->wait_for_stripe);
-				if (conf->retry_read_aligned)
-					md_wakeup_thread(conf->mddev->thread);
 			}
 		}
 	}
 }
+
+static void release_queue(struct stripe_queue *sq)
+{
+	raid5_conf_t *conf = sq->raid_conf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&conf->device_lock, flags);
+	__release_queue(conf, sq);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+}
+
 static void release_stripe(struct stripe_head *sh)
 {
 	raid5_conf_t *conf = sh->sq->raid_conf;
@@ -188,9 +257,10 @@ static inline void insert_hash(raid5_con
 
 
 /* find an idle stripe, make sure it is unhashed, and return it. */
-static struct stripe_head *get_free_stripe(raid5_conf_t *conf)
+static struct stripe_head *get_free_stripe(struct stripe_queue *sq)
 {
 	struct stripe_head *sh = NULL;
+	raid5_conf_t *conf = sq->raid_conf;
 	struct list_head *first;
 
 	CHECK_DEVLOCK();
@@ -201,10 +271,29 @@ static struct stripe_head *get_free_stri
 	list_del_init(first);
 	remove_hash(sh);
 	atomic_inc(&conf->active_stripes);
+	atomic_inc(&sq->count);
+	sh->sq = NULL;
 out:
 	return sh;
 }
 
+static struct stripe_queue *get_free_queue(raid5_conf_t *conf)
+{
+	struct stripe_queue *sq = NULL;
+	struct list_head *first;
+
+	CHECK_DEVLOCK();
+	if (list_empty(&conf->inactive_queue_list))
+		goto out;
+	first = conf->inactive_queue_list.next;
+	sq = list_entry(first, struct stripe_queue, list_node);
+	list_del_init(first);
+	rb_erase(&sq->rb_node, &conf->stripe_queue_tree);
+	atomic_inc(&conf->active_queues);
+out:
+	return sq;
+}
+
 static void shrink_buffers(struct stripe_head *sh, int num)
 {
 	struct page *p;
@@ -236,37 +325,53 @@ static int grow_buffers(struct stripe_he
 
 static void raid5_build_block (struct stripe_head *sh, int i);
 
-static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int disks)
+#if BITS_PER_LONG == 32
+#define hweight hweight32
+#else
+#define hweight hweight64
+#endif
+static unsigned long io_weight(unsigned long *bitmap, int disks)
 {
-	raid5_conf_t *conf = sh->sq->raid_conf;
+	unsigned long weight = hweight(*bitmap);
+
+	for (bitmap++; disks > BITS_PER_LONG; disks -= BITS_PER_LONG, bitmap++)
+		weight += hweight(*bitmap);
+
+	return weight;
+}
+
+static void
+init_stripe(struct stripe_head *sh, struct stripe_queue *sq, int disks)
+{
+	raid5_conf_t *conf = sq->raid_conf;
+	sector_t sector = sq->sector;
 	int i;
 
+	pr_debug("init_stripe called, stripe %llu\n",
+		(unsigned long long)sector);
+
 	BUG_ON(atomic_read(&sh->count) != 0);
 	BUG_ON(test_bit(STRIPE_HANDLE, &sh->state));
 	BUG_ON(sh->ops.pending || sh->ops.ack || sh->ops.complete);
+	sh->sq = sq;
 
 	CHECK_DEVLOCK();
-	pr_debug("init_stripe called, stripe %llu\n",
-		(unsigned long long)sh->sector);
 
 	remove_hash(sh);
 
 	sh->sector = sector;
-	sh->sq->pd_idx = pd_idx;
 	sh->state = 0;
 
 	sh->disks = disks;
 
 	for (i = sh->disks; i--; ) {
 		struct r5dev *dev = &sh->dev[i];
-		struct r5_queue_dev *dev_q = &sh->sq->dev[i];
 
-		if (dev_q->toread || dev->read || dev_q->towrite ||
-			dev->written || test_bit(R5_LOCKED, &dev->flags)) {
-			printk(KERN_ERR "sector=%llx i=%d %p %p %p %p %d\n",
-			       (unsigned long long)sh->sector, i, dev_q->toread,
-			       dev->read, dev_q->towrite, dev->written,
-			       test_bit(R5_LOCKED, &dev->flags));
+		if (dev->read || dev->written ||
+		    test_bit(R5_LOCKED, &dev->flags)) {
+			printk(KERN_ERR "sector=%llx i=%d %p %p %d\n",
+			       (unsigned long long)sector, i, dev->read,
+			       dev->written, test_bit(R5_LOCKED, &dev->flags));
 			BUG();
 		}
 		dev->flags = 0;
@@ -289,65 +394,266 @@ static struct stripe_head *__find_stripe
 	return NULL;
 }
 
+static struct stripe_queue *__find_queue(raid5_conf_t *conf, sector_t sector)
+{
+	struct rb_node *n = conf->stripe_queue_tree.rb_node;
+	struct stripe_queue *sq;
+
+	pr_debug("%s, sector %llu\n", __FUNCTION__, (unsigned long long)sector);
+	while (n) {
+		sq = rb_entry(n, struct stripe_queue, rb_node);
+
+		if (sector < sq->sector)
+			n = n->rb_left;
+		else if (sector > sq->sector)
+			n = n->rb_right;
+		else
+			return sq;
+	}
+	pr_debug("__queue %llu not in tree\n", (unsigned long long)sector);
+	return NULL;
+}
+
+static struct stripe_queue *
+__insert_active_sq(raid5_conf_t *conf, sector_t sector, struct rb_node *node)
+{
+	struct rb_node **p = &conf->stripe_queue_tree.rb_node;
+	struct rb_node *parent = NULL;
+	struct stripe_queue *sq;
+
+	while (*p) {
+		parent = *p;
+		sq = rb_entry(parent, struct stripe_queue, rb_node);
+
+		if (sector < sq->sector)
+			p = &(*p)->rb_left;
+		else if (sector > sq->sector)
+			p = &(*p)->rb_right;
+		else
+			return sq;
+	}
+
+	rb_link_node(node, parent, p);
+
+	return NULL;
+}
+
+static inline struct stripe_queue *
+insert_active_sq(raid5_conf_t *conf, sector_t sector, struct rb_node *node)
+{
+	struct stripe_queue *sq = __insert_active_sq(conf, sector, node);
+
+	if (sq)
+		goto out;
+	rb_insert_color(node, &conf->stripe_queue_tree);
+ out:
+	return sq;
+}
+
 static sector_t compute_blocknr(raid5_conf_t *conf, int raid_disks,
 	sector_t sector, int pd_idx, int i);
 
+static void
+pickup_cached_stripe(struct stripe_head *sh, struct stripe_queue *sq)
+{
+	raid5_conf_t *conf = sq->raid_conf;
+
+	if (atomic_read(&sh->count))
+		BUG_ON(!list_empty(&sh->lru));
+	else {
+		if (!test_bit(STRIPE_HANDLE, &sh->state)) {
+			atomic_inc(&conf->active_stripes);
+			atomic_inc(&sq->count);
+			sh->sq = NULL;
+		}
+		if (list_empty(&sh->lru) &&
+		    !test_bit(STRIPE_QUEUE_EXPANDING, &sq->state))
+			BUG();
+		list_del_init(&sh->lru);
+	}
+}
+
 static void unplug_slaves(mddev_t *mddev);
 static void raid5_unplug_device(request_queue_t *q);
 
-static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector, int disks,
-					     int pd_idx, int noblock)
+static void
+__wait_for_inactive_stripe(raid5_conf_t *conf, struct stripe_queue *sq)
 {
-	struct stripe_head *sh;
+	conf->inactive_blocked = 1;
+	wait_event_lock_irq(conf->wait_for_stripe,
+			    (!list_empty(&conf->inactive_list) &&
+			     (atomic_read(&conf->active_stripes)
+			      < (conf->max_nr_stripes * 3/4) ||
+			      !conf->inactive_blocked)),
+			    conf->device_lock,
+			    raid5_unplug_device(conf->mddev->queue)
+		);
+	conf->inactive_blocked = 0;
+}
 
-	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);
+static struct stripe_head *
+__get_active_stripe(raid5_conf_t *conf, struct stripe_queue *sq, int disks, int noblock)
+{
+	struct stripe_head *sh;
+	sector_t sector = sq->sector;
 
-	spin_lock_irq(&conf->device_lock);
+	pr_debug("get_stripe, sector %llu\n", (unsigned long long)sq->sector);
 
 	do {
-		wait_event_lock_irq(conf->wait_for_stripe,
-				    conf->quiesce == 0,
-				    conf->device_lock, /* nothing */);
+		/* try to get a cached stripe */
 		sh = __find_stripe(conf, sector, disks);
+
+		/* try to activate a new stripe */
 		if (!sh) {
 			if (!conf->inactive_blocked)
-				sh = get_free_stripe(conf);
+				sh = get_free_stripe(sq);
 			if (noblock && sh == NULL)
 				break;
-			if (!sh) {
-				conf->inactive_blocked = 1;
-				wait_event_lock_irq(conf->wait_for_stripe,
-						    !list_empty(&conf->inactive_list) &&
-						    (atomic_read(&conf->active_stripes)
-						     < (conf->max_nr_stripes *3/4)
-						     || !conf->inactive_blocked),
-						    conf->device_lock,
-						    raid5_unplug_device(conf->mddev->queue)
-					);
-				conf->inactive_blocked = 0;
-			} else
-				init_stripe(sh, sector, pd_idx, disks);
-		} else {
-			if (atomic_read(&sh->count)) {
-			  BUG_ON(!list_empty(&sh->lru));
-			} else {
-				if (!test_bit(STRIPE_HANDLE, &sh->state))
-					atomic_inc(&conf->active_stripes);
-				if (list_empty(&sh->lru) &&
-				    !test_bit(STRIPE_EXPANDING, &sh->state))
-					BUG();
-				list_del_init(&sh->lru);
-			}
-		}
+			if (!sh)
+				__wait_for_inactive_stripe(conf, sq);
+			else
+				init_stripe(sh, sq, disks);
+		} else
+			pickup_cached_stripe(sh, sq);
 	} while (sh == NULL);
 
-	if (sh)
+	BUG_ON(sq->sector != sector);
+
+	if (sh) {
 		atomic_inc(&sh->count);
 
+		sh->sq = sq;
+
+		if (sq->sh)
+			BUG_ON(sq->sector != sh->sector);
+		else {
+			list_del_init(&sq->list_node);
+			clear_bit(STRIPE_QUEUE_HANDLE, &sq->state);
+			sq->sh = sh;
+		}
+
+		BUG_ON(!list_empty(&sq->list_node));
+		BUG_ON(test_bit(STRIPE_QUEUE_HANDLE, &sq->state));
+	}
+
+	return sh;
+}
+
+static struct stripe_head *
+get_active_stripe(struct stripe_queue *sq, int disks, int noblock)
+{
+	raid5_conf_t *conf = sq->raid_conf;
+	struct stripe_head *sh;
+	spin_lock_irq(&conf->device_lock);
+	sh = __get_active_stripe(conf, sq, disks, noblock);
 	spin_unlock_irq(&conf->device_lock);
+
 	return sh;
 }
 
+static void init_queue(struct stripe_queue *sq, sector_t sector,
+		int disks, int pd_idx)
+{
+	raid5_conf_t *conf = sq->raid_conf;
+	int i;
+
+	pr_debug("%s: %llu -> %llu [%p]\n",
+		__FUNCTION__, (unsigned long long) sq->sector,
+		(unsigned long long) sector, sq);
+
+	BUG_ON(atomic_read(&sq->count) != 0);
+	BUG_ON(io_weight(sq->to_read, disks));
+	BUG_ON(io_weight(sq->to_write, disks));
+	BUG_ON(io_weight(sq->overwrite, disks));
+	BUG_ON(test_bit(STRIPE_QUEUE_HANDLE, &sq->state));
+	BUG_ON(sq->sh);
+
+	sq->state = (1 << STRIPE_QUEUE_HANDLE);
+	sq->sector = sector;
+	sq->pd_idx = pd_idx;
+
+	for (i = disks; i--; ) {
+		struct r5_queue_dev *dev_q = &sq->dev[i];
+
+		if (dev_q->toread || dev_q->towrite) {
+			printk(KERN_ERR "sector=%llx i=%d %p %p\n",
+			       (unsigned long long)sector, i, dev_q->toread,
+			       dev_q->towrite);
+			BUG();
+		}
+		dev_q->sector = compute_blocknr(conf, disks, sector, pd_idx, i);
+	}
+
+	sq = insert_active_sq(conf, sector, &sq->rb_node);
+	if (unlikely(sq)) {
+		printk(KERN_ERR "%s: sq: %p sector: %llu bounced off the "
+			"stripe_queue rb_tree\n", __FUNCTION__, sq,
+			(unsigned long long) sq->sector);
+		BUG();
+	}
+}
+
+static void __wait_for_inactive_queue(raid5_conf_t *conf)
+{
+	conf->inactive_queue_blocked = 1;
+	wait_event_lock_irq(conf->wait_for_queue,
+			    !list_empty(&conf->inactive_queue_list) &&
+			    (atomic_read(&conf->active_queues)
+			     < conf->max_nr_stripes *
+			     STRIPE_QUEUE_SIZE * 7/8 ||
+			    !conf->inactive_queue_blocked),
+			    conf->device_lock,
+			    /* nothing */
+		);
+	conf->inactive_queue_blocked = 0;
+}
+
+
+static struct stripe_queue *
+get_active_queue(raid5_conf_t *conf, sector_t sector, int disks, int pd_idx,
+		  int noblock)
+{
+	struct stripe_queue *sq;
+
+	pr_debug("%s, sector %llu\n", __FUNCTION__,
+		(unsigned long long)sector);
+
+	spin_lock_irq(&conf->device_lock);
+
+	do {
+		wait_event_lock_irq(conf->wait_for_queue,
+				    conf->quiesce == 0,
+				    conf->device_lock, /* nothing */);
+		sq = __find_queue(conf, sector);
+		if (!sq) {
+			if (!conf->inactive_queue_blocked)
+				sq = get_free_queue(conf);
+			if (noblock && sq == NULL)
+				break;
+			if (!sq)
+				__wait_for_inactive_queue(conf);
+			else
+				init_queue(sq, sector, disks, pd_idx);
+		} else {
+			if (atomic_read(&sq->count)) {
+				BUG_ON(!list_empty(&sq->list_node));
+			} else if (!test_and_set_bit(STRIPE_QUEUE_HANDLE,
+						     &sq->state))
+				atomic_inc(&conf->active_queues);
+			list_del_init(&sq->list_node);
+		}
+	} while (sq == NULL);
+
+	if (sq) {
+		atomic_inc(&sq->count);
+		__get_active_stripe(conf, sq, disks, 1);
+
+	}
+	spin_unlock_irq(&conf->device_lock);
+	return sq;
+}
+
+
 /* test_and_ack_op() ensures that we only dequeue an operation once */
 #define test_and_ack_op(op, pend) \
 do {							\
@@ -574,7 +880,8 @@ static void ops_complete_biofill(void *s
 static void ops_run_biofill(struct stripe_head *sh)
 {
 	struct dma_async_tx_descriptor *tx = NULL;
-	raid5_conf_t *conf = sh->sq->raid_conf;
+	struct stripe_queue *sq = sh->sq;
+	raid5_conf_t *conf = sq->raid_conf;
 	int i;
 
 	pr_debug("%s: stripe %llu\n", __FUNCTION__,
@@ -588,6 +895,7 @@ static void ops_run_biofill(struct strip
 			spin_lock_irq(&conf->device_lock);
 			dev->read = rbi = dev_q->toread;
 			dev_q->toread = NULL;
+			clear_bit(i, sq->to_read);
 			spin_unlock_irq(&conf->device_lock);
 			while (rbi && rbi->bi_sector <
 				dev_q->sector + STRIPE_SECTORS) {
@@ -736,6 +1044,7 @@ ops_run_biodrain(struct stripe_head *sh,
 			spin_lock(&sq->lock);
 			chosen = dev_q->towrite;
 			dev_q->towrite = NULL;
+			clear_bit(i, sq->to_write);
 			BUG_ON(dev->written);
 			wbi = dev->written = chosen;
 			spin_unlock(&sq->lock);
@@ -935,46 +1244,73 @@ static void raid5_run_ops(struct stripe_
 static int grow_one_stripe(raid5_conf_t *conf)
 {
 	struct stripe_head *sh;
-	struct stripe_queue *sq;
-
 	sh = kmem_cache_alloc(conf->sh_slab_cache, GFP_KERNEL);
 	if (!sh)
 		return 0;
-
-	sq = kmem_cache_alloc(conf->sq_slab_cache, GFP_KERNEL);
-	if (!sq) {
-		kmem_cache_free(conf->sh_slab_cache, sh);
-		return 0;
-	}
-
 	memset(sh, 0, sizeof(*sh) + (conf->raid_disks-1)*sizeof(struct r5dev));
-	memset(sq, 0, sizeof(*sq) +
-		(conf->raid_disks-1) * sizeof(struct r5_queue_dev));
-	sh->sq = sq;
-	sq->raid_conf = conf;
-	spin_lock_init(&sq->lock);
 
 	if (grow_buffers(sh, conf->raid_disks)) {
 		shrink_buffers(sh, conf->raid_disks);
 		kmem_cache_free(conf->sh_slab_cache, sh);
-		kmem_cache_free(conf->sq_slab_cache, sq);
 		return 0;
 	}
 	sh->disks = conf->raid_disks;
 	/* we just created an active stripe so... */
 	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
+	atomic_set(&init_sq.count, 2); /* set to two so that it is not picked
+					* up by __release_queue
+					*/
 	INIT_LIST_HEAD(&sh->lru);
+	sh->sq = &init_sq;
+
 	spin_lock_irq(&conf->device_lock);
 	__release_stripe(conf, sh);
+	sh->sq = NULL;
 	spin_unlock_irq(&conf->device_lock);
+
+	return 1;
+}
+
+static int grow_one_queue(raid5_conf_t *conf)
+{
+	struct stripe_queue *sq;
+	int disks = conf->raid_disks;
+	void *weight_map;
+	sq = kmem_cache_alloc(conf->sq_slab_cache, GFP_KERNEL);
+	if (!sq)
+		return 0;
+	memset(sq, 0, (sizeof(*sq)+(disks-1) * sizeof(struct r5_queue_dev)) +
+		r5_io_weight_size(disks) + r5_io_weight_size(disks) +
+		r5_io_weight_size(disks));
+
+	/* set the queue weight bitmaps to the free space at the end of sq */
+	weight_map = ((void *) sq) + offsetof(typeof(*sq), dev) +
+			sizeof(struct r5_queue_dev) * disks;
+	sq->to_read = weight_map;
+	weight_map += r5_io_weight_size(disks);
+	sq->to_write = weight_map;
+	weight_map += r5_io_weight_size(disks);
+	sq->overwrite = weight_map;
+
+	spin_lock_init(&sq->lock);
+	sq->sector = MaxSector;
+	sq->raid_conf = conf;
+	/* we just created an active queue so... */
+	atomic_set(&sq->count, 1);
+	atomic_inc(&conf->active_queues);
+	sq->sh = &init_sh;
+	INIT_LIST_HEAD(&sq->list_node);
+	RB_CLEAR_NODE(&sq->rb_node);
+	release_queue(sq);
+
 	return 1;
 }
 
 static int grow_stripes(raid5_conf_t *conf, int num)
 {
 	struct kmem_cache *sc;
-	int devs = conf->raid_disks;
+	int devs = conf->raid_disks, num_q = num * STRIPE_QUEUE_SIZE;
 
 	sprintf(conf->sh_cache_name[0], "raid5-%s", mdname(conf->mddev));
 	sprintf(conf->sh_cache_name[1], "raid5-%s-alt", mdname(conf->mddev));
@@ -990,18 +1326,24 @@ static int grow_stripes(raid5_conf_t *co
 		return 1;
 	conf->sh_slab_cache = sc;
 	conf->pool_size = devs;
+	while (num--)
+		if (!grow_one_stripe(conf))
+			return 1;
 
 	sc = kmem_cache_create(conf->sq_cache_name[conf->active_name],
-		sizeof(struct stripe_queue) +
-		(devs-1)*sizeof(struct r5_queue_dev), 0, NULL);
-
+			       (sizeof(struct stripe_queue)+(devs-1) *
+				sizeof(struct r5_queue_dev)) +
+				r5_io_weight_size(devs) +
+				r5_io_weight_size(devs) +
+				r5_io_weight_size(devs), 0, NULL);
 	if (!sc)
 		return 1;
-	conf->sq_slab_cache = sc;
 
-	while (num--)
-		if (!grow_one_stripe(conf))
+	conf->sq_slab_cache = sc;
+	while (num_q--)
+		if (!grow_one_queue(conf))
 			return 1;
+
 	return 0;
 }
 
@@ -1032,11 +1374,13 @@ static int resize_stripes(raid5_conf_t *
 	 * so we use GFP_NOIO allocations.
 	 */
 	struct stripe_head *osh, *nsh;
+	struct stripe_queue *osq, *nsq;
 	LIST_HEAD(newstripes);
+	LIST_HEAD(newqueues);
 	struct disk_info *ndisks;
 	int err = 0;
 	struct kmem_cache *sc, *sc_q;
-	int i;
+	int i, j;
 
 	if (newsize <= conf->pool_size)
 		return 0; /* never bother to shrink */
@@ -1050,45 +1394,84 @@ static int resize_stripes(raid5_conf_t *
 	if (!sc)
 		return -ENOMEM;
 
-	sc_q = kmem_cache_create(conf->sh_cache_name[1-conf->active_name],
-		    sizeof(struct stripe_queue) +
-		    (newsize-1)*sizeof(struct r5_queue_dev), 0, NULL);
+	sc_q = kmem_cache_create(conf->sq_cache_name[conf->active_name],
+			       (sizeof(struct stripe_queue)+(newsize-1) *
+				sizeof(struct r5_queue_dev)) +
+				r5_io_weight_size(newsize) +
+				r5_io_weight_size(newsize) +
+				r5_io_weight_size(newsize),
+				0, NULL);
+
 	if (!sc_q) {
 		kmem_cache_destroy(sc);
 		return -ENOMEM;
 	}
 
 	for (i = conf->max_nr_stripes; i; i--) {
-		struct stripe_queue *nsq;
+		struct stripe_queue *nsq_per_sh[STRIPE_QUEUE_SIZE];
 
 		nsh = kmem_cache_alloc(sc, GFP_KERNEL);
 		if (!nsh)
 			break;
 
-		nsq = kmem_cache_alloc(sc_q, GFP_KERNEL);
-		if (!nsq) {
+		/* allocate STRIPE_QUEUE_SIZE queues per stripe */
+		for (j = 0; j < ARRAY_SIZE(nsq_per_sh); j++)
+			nsq_per_sh[j] = kmem_cache_alloc(sc_q, GFP_KERNEL);
+
+		for (j = 0; j < ARRAY_SIZE(nsq_per_sh); j++)
+			if (!nsq_per_sh[j])
+				break;
+
+		if (j <= ARRAY_SIZE(nsq_per_sh)) {
 			kmem_cache_free(sc, nsh);
+			do
+				if (nsq_per_sh[j])
+					kmem_cache_free(sc_q, nsq_per_sh[j]);
+			while (--j >= 0);
 			break;
 		}
 
 		memset(nsh, 0, sizeof(*nsh) + (newsize-1)*sizeof(struct r5dev));
-		memset(nsq, 0, sizeof(*nsq) +
-			(newsize-1)*sizeof(struct r5_queue_dev));
-
-		nsq->raid_conf = conf;
-		nsh->sq = nsq;
-		spin_lock_init(&nsq->lock);
-
 		list_add(&nsh->lru, &newstripes);
+
+		for (j = 0; j < ARRAY_SIZE(nsq_per_sh); j++) {
+			void *weight_map;
+			nsq = nsq_per_sh[j];
+			memset(nsq, 0, (sizeof(*nsq)+(newsize-1) *
+				sizeof(struct r5_queue_dev)) +
+				r5_io_weight_size(newsize) +
+				r5_io_weight_size(newsize) +
+				r5_io_weight_size(newsize));
+			/* set the queue weight bitmaps to the free space at
+			 * the end of nsq
+			 */
+			weight_map = ((void *) nsq) +
+					offsetof(typeof(*nsq), dev) +
+					sizeof(struct r5_queue_dev) * newsize;
+			nsq->to_read = weight_map;
+			weight_map += r5_io_weight_size(newsize);
+			nsq->to_write = weight_map;
+			weight_map += r5_io_weight_size(newsize);
+			nsq->overwrite = weight_map;
+			nsq->raid_conf = conf;
+			spin_lock_init(&nsq->lock);
+			list_add(&nsq->list_node, &newqueues);
+		}
 	}
 	if (i) {
 		/* didn't get enough, give up */
 		while (!list_empty(&newstripes)) {
 			nsh = list_entry(newstripes.next, struct stripe_head, lru);
 			list_del(&nsh->lru);
-			kmem_cache_free(sc_q, nsh->sq);
 			kmem_cache_free(sc, nsh);
 		}
+		while (!list_empty(&newqueues)) {
+			nsq = list_entry(newqueues.next,
+					 struct stripe_queue,
+					 list_node);
+			list_del(&nsh->lru);
+			kmem_cache_free(sc_q, nsq);
+		}
 		kmem_cache_destroy(sc_q);
 		kmem_cache_destroy(sc);
 		return -ENOMEM;
@@ -1097,6 +1480,19 @@ static int resize_stripes(raid5_conf_t *
 	 * OK, we have enough stripes, start collecting inactive
 	 * stripes and copying them over
 	 */
+	list_for_each_entry(nsq, &newqueues, list_node) {
+		spin_lock_irq(&conf->device_lock);
+		wait_event_lock_irq(conf->wait_for_queue,
+				    !list_empty(&conf->inactive_queue_list),
+				    conf->device_lock,
+				    unplug_slaves(conf->mddev)
+			);
+		osq = get_free_queue(conf);
+		spin_unlock_irq(&conf->device_lock);
+		atomic_set(&nsq->count, 1);
+		kmem_cache_free(conf->sq_slab_cache, osq);
+	}
+
 	list_for_each_entry(nsh, &newstripes, lru) {
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
@@ -1104,14 +1500,13 @@ static int resize_stripes(raid5_conf_t *
 				    conf->device_lock,
 				    unplug_slaves(conf->mddev)
 			);
-		osh = get_free_stripe(conf);
+		osh = get_free_stripe(&init_sq);
 		spin_unlock_irq(&conf->device_lock);
 		atomic_set(&nsh->count, 1);
 		for(i=0; i<conf->pool_size; i++)
 			nsh->dev[i].page = osh->dev[i].page;
 		for( ; i<newsize; i++)
 			nsh->dev[i].page = NULL;
-		kmem_cache_free(conf->sq_slab_cache, osh->sq);
 		kmem_cache_free(conf->sh_slab_cache, osh);
 	}
 	kmem_cache_destroy(conf->sh_slab_cache);
@@ -1132,8 +1527,11 @@ static int resize_stripes(raid5_conf_t *
 		err = -ENOMEM;
 
 	/* Step 4, return new stripes to service */
-	while(!list_empty(&newstripes)) {
+	while (!list_empty(&newstripes)) {
+		nsq = list_entry(newqueues.next, struct stripe_queue,
+					list_node);
 		nsh = list_entry(newstripes.next, struct stripe_head, lru);
+		list_del_init(&nsq->list_node);
 		list_del_init(&nsh->lru);
 		for (i=conf->raid_disks; i < newsize; i++)
 			if (nsh->dev[i].page == NULL) {
@@ -1142,8 +1540,20 @@ static int resize_stripes(raid5_conf_t *
 				if (!p)
 					err = -ENOMEM;
 			}
+		nsq->sh = nsh;
+		nsh->sq = nsq;
 		release_stripe(nsh);
 	}
+
+	/* dump the remaining sq's onto the inactive list */
+	while (!list_empty(&newqueues)) {
+		nsq = list_entry(newqueues.next, struct stripe_queue,
+					list_node);
+		list_del_init(&nsq->list_node);
+		nsq->sh = &init_sh;
+		release_queue(nsq);
+	}
+
 	/* critical section pass, GFP_NOIO no longer needed */
 
 	conf->sh_slab_cache = sc;
@@ -1159,24 +1569,39 @@ static int drop_one_stripe(raid5_conf_t 
 	struct stripe_head *sh;
 
 	spin_lock_irq(&conf->device_lock);
-	sh = get_free_stripe(conf);
+	sh = get_free_stripe(&init_sq);
 	spin_unlock_irq(&conf->device_lock);
 	if (!sh)
 		return 0;
 	BUG_ON(atomic_read(&sh->count));
 	shrink_buffers(sh, conf->pool_size);
-	if (sh->sq)
-		kmem_cache_free(conf->sq_slab_cache, sh->sq);
 	kmem_cache_free(conf->sh_slab_cache, sh);
 	atomic_dec(&conf->active_stripes);
 	return 1;
 }
 
+static int drop_one_queue(raid5_conf_t *conf)
+{
+	struct stripe_queue *sq;
+
+	spin_lock_irq(&conf->device_lock);
+	sq = get_free_queue(conf);
+	spin_unlock_irq(&conf->device_lock);
+	if (!sq)
+		return 0;
+	kmem_cache_free(conf->sq_slab_cache, sq);
+	atomic_dec(&conf->active_queues);
+	return 1;
+}
+
 static void shrink_stripes(raid5_conf_t *conf)
 {
 	while (drop_one_stripe(conf))
 		;
 
+	while (drop_one_queue(conf))
+		;
+
 	if (conf->sh_slab_cache)
 		kmem_cache_destroy(conf->sh_slab_cache);
 	conf->sh_slab_cache = NULL;
@@ -1302,7 +1727,6 @@ static int raid5_end_write_request (stru
 static void raid5_build_block (struct stripe_head *sh, int i)
 {
 	struct r5dev *dev = &sh->dev[i];
-	struct r5_queue_dev *dev_q = &sh->sq->dev[i];
 
 	bio_init(&dev->req);
 	dev->req.bi_io_vec = &dev->vec;
@@ -1314,10 +1738,6 @@ static void raid5_build_block (struct st
 
 	dev->req.bi_sector = sh->sector;
 	dev->req.bi_private = sh;
-
-	dev->flags = 0;
-	dev_q->sector = compute_blocknr(sh->sq->raid_conf, sh->disks,
-			sh->sector, sh->sq->pd_idx, i);
 }
 
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
@@ -1612,6 +2032,7 @@ static void compute_parity6(struct strip
 			if (i != pd_idx && i != qd_idx && sq->dev[i].towrite) {
 				chosen = sq->dev[i].towrite;
 				sq->dev[i].towrite = NULL;
+				clear_bit(i, sq->to_write);
 
 				if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 					wake_up(&conf->wait_for_overlap);
@@ -1856,23 +2277,24 @@ handle_write_operations5(struct stripe_h
  * toread/towrite point to the first in a chain.
  * The bi_next chain must be in order.
  */
-static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, int forwrite)
+static int add_queue_bio(struct stripe_queue *sq, struct bio *bi, int dd_idx,
+			  int forwrite)
 {
 	struct bio **bip;
-	struct stripe_queue *sq = sh->sq;
 	raid5_conf_t *conf = sq->raid_conf;
 	int firstwrite=0;
+	struct stripe_head *sh;
 
-	pr_debug("adding bh b#%llu to stripe s#%llu\n",
+	pr_debug("adding bio (%llu) to queue (%llu)\n",
 		(unsigned long long)bi->bi_sector,
-		(unsigned long long)sh->sector);
-
+		(unsigned long long)sq->sector);
 
 	spin_lock(&sq->lock);
 	spin_lock_irq(&conf->device_lock);
+	sh = sq->sh;
 	if (forwrite) {
 		bip = &sq->dev[dd_idx].towrite;
-		if (*bip == NULL && sh->dev[dd_idx].written == NULL)
+		if (*bip == NULL && (!sh || (sh && !sh->dev[dd_idx].written)))
 			firstwrite = 1;
 	} else
 		bip = &sq->dev[dd_idx].toread;
@@ -1894,18 +2316,20 @@ static int add_stripe_bio(struct stripe_
 
 	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
 		(unsigned long long)bi->bi_sector,
-		(unsigned long long)sh->sector, dd_idx);
+		(unsigned long long)sq->sector, dd_idx);
 
 	if (conf->mddev->bitmap && firstwrite) {
-		bitmap_startwrite(conf->mddev->bitmap, sh->sector,
+		bitmap_startwrite(conf->mddev->bitmap, sq->sector,
 				  STRIPE_SECTORS, 0);
 		sq->bm_seq = conf->seq_flush+1;
-		set_bit(STRIPE_BIT_DELAY, &sh->state);
+		set_bit(STRIPE_QUEUE_BIT_DELAY, &sq->state);
 	}
 
 	if (forwrite) {
 		/* check if page is covered */
 		sector_t sector = sq->dev[dd_idx].sector;
+
+		set_bit(dd_idx, sq->to_write);
 		for (bi = sq->dev[dd_idx].towrite;
 		     sector < sq->dev[dd_idx].sector + STRIPE_SECTORS &&
 			     bi && bi->bi_sector <= sector;
@@ -1914,8 +2338,10 @@ static int add_stripe_bio(struct stripe_
 				sector = bi->bi_sector + (bi->bi_size>>9);
 		}
 		if (sector >= sq->dev[dd_idx].sector + STRIPE_SECTORS)
-			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
-	}
+			set_bit(dd_idx, sq->overwrite);
+	} else
+		set_bit(dd_idx, sq->to_read);
+
 	return 1;
 
  overlap:
@@ -1972,6 +2398,7 @@ handle_requests_to_failed_array(raid5_co
 		/* fail all writes first */
 		bi = sq->dev[i].towrite;
 		sq->dev[i].towrite = NULL;
+		clear_bit(i, sq->to_write);
 		if (bi) {
 			s->to_write--;
 			bitmap_end = 1;
@@ -2015,6 +2442,7 @@ handle_requests_to_failed_array(raid5_co
 		      test_bit(R5_ReadError, &sh->dev[i].flags))) {
 			bi = sq->dev[i].toread;
 			sq->dev[i].toread = NULL;
+			clear_bit(i, sq->to_read);
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
 			if (bi) s->to_read--;
@@ -2292,20 +2720,13 @@ static void handle_issuing_new_write_req
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
 			    test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
-				if (
-				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-					pr_debug("Read_old block "
-						"%d for r-m-w\n", i);
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					if (!test_and_set_bit(
-						STRIPE_OP_IO, &sh->ops.pending))
-						sh->ops.count++;
-					s->locked++;
-				} else {
-					set_bit(STRIPE_DELAYED, &sh->state);
-					set_bit(STRIPE_HANDLE, &sh->state);
-				}
+				pr_debug("Read_old block %d for r-m-w\n", i);
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
+				if (!test_and_set_bit(STRIPE_OP_IO,
+				    &sh->ops.pending))
+					sh->ops.count++;
+				s->locked++;
 			}
 		}
 	if (rcw <= rmw && rcw > 0)
@@ -2319,20 +2740,14 @@ static void handle_issuing_new_write_req
 			    !(test_bit(R5_UPTODATE, &dev->flags) ||
 			    test_bit(R5_Wantcompute, &dev->flags)) &&
 			    test_bit(R5_Insync, &dev->flags)) {
-				if (
-				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-					pr_debug("Read_old block "
-						"%d for Reconstruct\n", i);
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					if (!test_and_set_bit(
-						STRIPE_OP_IO, &sh->ops.pending))
-						sh->ops.count++;
-					s->locked++;
-				} else {
-					set_bit(STRIPE_DELAYED, &sh->state);
-					set_bit(STRIPE_HANDLE, &sh->state);
-				}
+				pr_debug("Read_old block "
+					 "%d for Reconstruct\n", i);
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
+				if (!test_and_set_bit(STRIPE_OP_IO,
+				    &sh->ops.pending))
+					sh->ops.count++;
+				s->locked++;
 			}
 		}
 	/* now if nothing is locked, and if we have enough data,
@@ -2348,7 +2763,7 @@ static void handle_issuing_new_write_req
 	if ((s->req_compute ||
 	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending)) &&
 		(s->locked == 0 && (rcw == 0 || rmw == 0) &&
-		!test_bit(STRIPE_BIT_DELAY, &sh->state)))
+		!test_bit(STRIPE_QUEUE_BIT_DELAY, &sq->state)))
 		s->locked += handle_write_operations5(sh, rcw == 0, 0);
 }
 
@@ -2388,28 +2803,19 @@ static void handle_issuing_new_write_req
 			    && !test_bit(R5_LOCKED, &dev->flags) &&
 			    !test_bit(R5_UPTODATE, &dev->flags) &&
 			    test_bit(R5_Insync, &dev->flags)) {
-				if (
-				  test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-					pr_debug("Read_old stripe %llu "
-						"block %d for Reconstruct\n",
-					     (unsigned long long)sh->sector, i);
-					set_bit(R5_LOCKED, &dev->flags);
-					set_bit(R5_Wantread, &dev->flags);
-					s->locked++;
-				} else {
-					pr_debug("Request delayed stripe %llu "
-						"block %d for Reconstruct\n",
-					     (unsigned long long)sh->sector, i);
-					set_bit(STRIPE_DELAYED, &sh->state);
-					set_bit(STRIPE_HANDLE, &sh->state);
-				}
+				pr_debug("Read_old stripe %llu "
+					"block %d for Reconstruct\n",
+				     (unsigned long long)sh->sector, i);
+				set_bit(R5_LOCKED, &dev->flags);
+				set_bit(R5_Wantread, &dev->flags);
+				s->locked++;
 			}
 		}
 	/* now if nothing is locked, and if we have enough data, we can start a
 	 * write request
 	 */
 	if (s->locked == 0 && rcw == 0 &&
-	    !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
+	    !test_bit(STRIPE_QUEUE_BIT_DELAY, &sq->state)) {
 		if (must_compute > 0) {
 			/* We have failed blocks and need to compute them */
 			switch (s->failed) {
@@ -2440,13 +2846,6 @@ static void handle_issuing_new_write_req
 			}
 		/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
 		set_bit(STRIPE_INSYNC, &sh->state);
-
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-			atomic_dec(&conf->preread_active_stripes);
-			if (atomic_read(&conf->preread_active_stripes) <
-			    IO_THRESHOLD)
-				md_wakeup_thread(conf->mddev->thread);
-		}
 	}
 }
 
@@ -2646,6 +3045,7 @@ static void handle_stripe_expansion(raid
 		if (i != sq->pd_idx && (r6s && i != r6s->qd_idx)) {
 			int dd_idx, pd_idx, j;
 			struct stripe_head *sh2;
+			struct stripe_queue *sq2;
 
 			sector_t bn = compute_blocknr(conf, sh->disks,
 						sh->sector, sq->pd_idx, i);
@@ -2653,17 +3053,23 @@ static void handle_stripe_expansion(raid
 						conf->raid_disks -
 						conf->max_degraded, &dd_idx,
 						&pd_idx, conf);
-			sh2 = get_active_stripe(conf, s, conf->raid_disks,
+			sq2 = get_active_queue(conf, s, conf->raid_disks,
 						pd_idx, 1);
-			if (sh2 == NULL)
+			if (!(sq2 && sq2->sh)) {
 				/* so far only the early blocks of this stripe
 				 * have been requested.  When later blocks
 				 * get requested, we will try again
 				 */
+				if (sq2)
+					release_queue(sq2);
 				continue;
-			if (!test_bit(STRIPE_EXPANDING, &sh2->state) ||
-			   test_bit(R5_Expanded, &sh2->dev[dd_idx].flags)) {
+			}
+			sh2 = sq2->sh;
+
+			if (!test_bit(STRIPE_QUEUE_EXPANDING, &sq2->state) ||
+			    test_bit(R5_Expanded, &sh2->dev[dd_idx].flags)) {
 				/* must have already done this block */
+				release_queue(sq2);
 				release_stripe(sh2);
 				continue;
 			}
@@ -2684,6 +3090,7 @@ static void handle_stripe_expansion(raid
 				set_bit(STRIPE_EXPAND_READY, &sh2->state);
 				set_bit(STRIPE_HANDLE, &sh2->state);
 			}
+			release_queue(sq2);
 			release_stripe(sh2);
 
 			/* done submitting copies, wait for them to complete */
@@ -2729,7 +3136,6 @@ static void handle_stripe5(struct stripe
 
 	spin_lock(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
-	clear_bit(STRIPE_DELAYED, &sh->state);
 
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
@@ -2742,6 +3148,8 @@ static void handle_stripe5(struct stripe
 		struct r5dev *dev = &sh->dev[i];
 		struct r5_queue_dev *dev_q = &sq->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
+		if (test_and_clear_bit(i, sq->overwrite))
+			set_bit(R5_OVERWRITE, &dev->flags);
 
 		pr_debug("check %d: state 0x%lx toread %p read %p write %p "
 			"written %p\n",	i, dev->flags, dev_q->toread,
@@ -2874,12 +3282,6 @@ static void handle_stripe5(struct stripe
 					set_bit(STRIPE_INSYNC, &sh->state);
 			}
 		}
-		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
-			atomic_dec(&conf->preread_active_stripes);
-			if (atomic_read(&conf->preread_active_stripes) <
-				IO_THRESHOLD)
-				md_wakeup_thread(conf->mddev->thread);
-		}
 	}
 
 	/* Now to consider new write requests and what else, if anything
@@ -2941,7 +3343,7 @@ static void handle_stripe5(struct stripe
 	if (test_bit(STRIPE_OP_POSTXOR, &sh->ops.complete) &&
 		!test_bit(STRIPE_OP_BIODRAIN, &sh->ops.pending)) {
 
-		clear_bit(STRIPE_EXPANDING, &sh->state);
+		clear_bit(STRIPE_QUEUE_EXPANDING, &sq->state);
 
 		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.pending);
 		clear_bit(STRIPE_OP_POSTXOR, &sh->ops.ack);
@@ -2954,7 +3356,7 @@ static void handle_stripe5(struct stripe
 		}
 	}
 
-	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state) &&
+	if (s.expanded && test_bit(STRIPE_QUEUE_EXPANDING, &sq->state) &&
 		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
 		/* Need to write out all blocks after computing parity */
 		sh->disks = conf->raid_disks;
@@ -3004,7 +3406,6 @@ static void handle_stripe6(struct stripe
 
 	spin_lock(&sq->lock);
 	clear_bit(STRIPE_HANDLE, &sh->state);
-	clear_bit(STRIPE_DELAYED, &sh->state);
 
 	s.syncing = test_bit(STRIPE_SYNCING, &sh->state);
 	s.expanding = test_bit(STRIPE_EXPAND_SOURCE, &sh->state);
@@ -3018,6 +3419,8 @@ static void handle_stripe6(struct stripe
 
 		dev = &sh->dev[i];
 		clear_bit(R5_Insync, &dev->flags);
+		if (test_and_clear_bit(i, sq->overwrite))
+			set_bit(R5_OVERWRITE, &dev->flags);
 
 		pr_debug("check %d: state 0x%lx read %p write %p written %p\n",
 			i, dev->flags, dev_q->toread, dev_q->towrite,
@@ -3029,6 +3432,7 @@ static void handle_stripe6(struct stripe
 			spin_lock_irq(&conf->device_lock);
 			rbi = dev_q->toread;
 			dev_q->toread = NULL;
+			clear_bit(i, sq->to_read);
 			if (test_and_clear_bit(R5_Overlap, &dev->flags))
 				wake_up(&conf->wait_for_overlap);
 			spin_unlock_irq(&conf->device_lock);
@@ -3157,7 +3561,7 @@ static void handle_stripe6(struct stripe
 			}
 		}
 
-	if (s.expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
+	if (s.expanded && test_bit(STRIPE_QUEUE_EXPANDING, &sq->state)) {
 		/* Need to write out all blocks after computing P&Q */
 		sh->disks = conf->raid_disks;
 		sq->pd_idx = stripe_to_pdidx(sh->sector, conf,
@@ -3168,7 +3572,7 @@ static void handle_stripe6(struct stripe
 			s.locked++;
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
 		}
-		clear_bit(STRIPE_EXPANDING, &sh->state);
+		clear_bit(STRIPE_QUEUE_EXPANDING, &sq->state);
 	} else if (s.expanded) {
 		clear_bit(STRIPE_EXPAND_READY, &sh->state);
 		atomic_dec(&conf->reshape_stripes);
@@ -3251,20 +3655,55 @@ static void handle_stripe(struct stripe_
 		handle_stripe5(sh);
 }
 
+static void handle_queue(struct stripe_queue *sq, int disks, int data_disks)
+{
+	struct stripe_head *sh = sq->sh;
+
+	/* continue to process i/o while the stripe is cached */
+	if (!sh) {
+		if (io_weight(sq->overwrite, disks) == data_disks) {
+			set_bit(STRIPE_QUEUE_IO_HI, &sq->state);
+			sh = get_active_stripe(sq, disks, 1);
+		} else if (io_weight(sq->to_read, disks)) {
+			set_bit(STRIPE_QUEUE_IO_LO, &sq->state);
+			sh = get_active_stripe(sq, disks, 1);
+		} else if (io_weight(sq->to_write, disks)) {
+			if (test_bit(STRIPE_QUEUE_PREREAD_ACTIVE, &sq->state)) {
+				set_bit(STRIPE_QUEUE_IO_LO, &sq->state);
+				sh = get_active_stripe(sq, disks, 1);
+			} else
+				set_bit(STRIPE_QUEUE_DELAYED, &sq->state);
+		}
+	}
+
+	release_queue(sq);
+	if (sh) {
+		handle_stripe(sh, NULL);
+		release_stripe(sh);
+	}
 
+	pr_debug("%s: sector %llu "
+		 "state: %#lx r: %lu w: %lu o: %lu handled: %s\n", __FUNCTION__,
+		 (unsigned long long) sq->sector, sq->state,
+		 io_weight(sq->to_read, disks),
+		 io_weight(sq->to_write, disks),
+		 io_weight(sq->overwrite, disks), sh ? "yes" : "no");
+}
 
 static void raid5_activate_delayed(raid5_conf_t *conf)
 {
-	if (atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD) {
-		while (!list_empty(&conf->delayed_list)) {
-			struct list_head *l = conf->delayed_list.next;
-			struct stripe_head *sh;
-			sh = list_entry(l, struct stripe_head, lru);
-			list_del_init(l);
-			clear_bit(STRIPE_DELAYED, &sh->state);
-			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
-				atomic_inc(&conf->preread_active_stripes);
-			list_add_tail(&sh->lru, &conf->handle_list);
+	if (atomic_read(&conf->preread_active_queues) < IO_THRESHOLD) {
+		struct stripe_queue *sq, *_sq;
+		pr_debug("%s\n", __FUNCTION__);
+		list_for_each_entry_safe(sq, _sq, &conf->delayed_q_list,
+					 list_node) {
+			clear_bit(STRIPE_QUEUE_DELAYED, &sq->state);
+			set_bit(STRIPE_QUEUE_IO_LO, &sq->state);
+			if (!test_and_set_bit(STRIPE_QUEUE_PREREAD_ACTIVE,
+						&sq->state))
+				atomic_inc(&conf->preread_active_queues);
+			list_move_tail(&sq->list_node,
+					&conf->io_lo_queue);
 		}
 	}
 }
@@ -3319,6 +3758,7 @@ static void raid5_unplug_device(request_
 		conf->seq_flush++;
 		raid5_activate_delayed(conf);
 	}
+
 	md_wakeup_thread(mddev->thread);
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
@@ -3362,13 +3802,13 @@ static int raid5_congested(void *data, i
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 
 	/* No difference between reads and writes.  Just check
-	 * how busy the stripe_cache is
+	 * how busy the stripe_queue is
 	 */
-	if (conf->inactive_blocked)
+	if (conf->inactive_queue_blocked)
 		return 1;
 	if (conf->quiesce)
 		return 1;
-	if (list_empty_careful(&conf->inactive_list))
+	if (list_empty_careful(&conf->inactive_queue_list))
 		return 1;
 
 	return 0;
@@ -3560,7 +4000,7 @@ static int chunk_aligned_read(request_qu
 		}
 
 		spin_lock_irq(&conf->device_lock);
-		wait_event_lock_irq(conf->wait_for_stripe,
+		wait_event_lock_irq(conf->wait_for_queue,
 				    conf->quiesce == 0,
 				    conf->device_lock, /* nothing */);
 		atomic_inc(&conf->active_aligned_reads);
@@ -3583,7 +4023,7 @@ static int make_request(request_queue_t 
 	unsigned int dd_idx, pd_idx;
 	sector_t new_sector;
 	sector_t logical_sector, last_sector;
-	struct stripe_head *sh;
+	struct stripe_queue *sq;
 	const int rw = bio_data_dir(bi);
 	int remaining;
 
@@ -3645,16 +4085,19 @@ static int make_request(request_queue_t 
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
-		sh = get_active_stripe(conf, new_sector, disks, pd_idx, (bi->bi_rw&RWA_MASK));
-		if (sh) {
+		sq = get_active_queue(conf, new_sector, disks, pd_idx,
+					(bi->bi_rw & RWA_MASK));
+		if (sq) {
+			struct stripe_head *sh = sq->sh;
 			if (unlikely(conf->expand_progress != MaxSector)) {
 				/* expansion might have moved on while waiting for a
-				 * stripe, so we must do the range check again.
+				 * queue, so we must do the range check again.
 				 * Expansion could still move past after this
 				 * test, but as we are holding a reference to
-				 * 'sh', we know that if that happens,
-				 *  STRIPE_EXPANDING will get set and the expansion
-				 * won't proceed until we finish with the stripe.
+				 * 'sq', we know that if that happens,
+				 * STRIPE_QUEUE_EXPANDING will get set and the
+				 * expansion won't proceed until we finish
+				 * with the queue.
 				 */
 				int must_retry = 0;
 				spin_lock_irq(&conf->device_lock);
@@ -3664,7 +4107,9 @@ static int make_request(request_queue_t 
 					must_retry = 1;
 				spin_unlock_irq(&conf->device_lock);
 				if (must_retry) {
-					release_stripe(sh);
+					release_queue(sq);
+					if (sh)
+						release_stripe(sh);
 					goto retry;
 				}
 			}
@@ -3673,27 +4118,31 @@ static int make_request(request_queue_t 
 			 */
 			if (logical_sector >= mddev->suspend_lo &&
 			    logical_sector < mddev->suspend_hi) {
-				release_stripe(sh);
+				release_queue(sq);
+				if (sh)
+					release_stripe(sh);
 				schedule();
 				goto retry;
 			}
 
-			if (test_bit(STRIPE_EXPANDING, &sh->state) ||
-			    !add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
+			if (test_bit(STRIPE_QUEUE_EXPANDING, &sq->state) ||
+			    !add_queue_bio(sq, bi, dd_idx,
+						bi->bi_rw & RW_MASK)) {
 				/* Stripe is busy expanding or
 				 * add failed due to overlap.  Flush everything
 				 * and wait a while
 				 */
 				raid5_unplug_device(mddev->queue);
-				release_stripe(sh);
+				release_queue(sq);
+				if (sh)
+					release_stripe(sh);
 				schedule();
 				goto retry;
 			}
 			finish_wait(&conf->wait_for_overlap, &w);
-			handle_stripe(sh, NULL);
-			release_stripe(sh);
+			handle_queue(sq, disks, data_disks);
 		} else {
-			/* cannot get stripe for read-ahead, just give-up */
+			/* cannot get queue for read-ahead, just give-up */
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			finish_wait(&conf->wait_for_overlap, &w);
 			break;
@@ -3716,6 +4165,33 @@ static int make_request(request_queue_t 
 	return 0;
 }
 
+static struct stripe_queue *
+wait_for_cache_attached_queue(raid5_conf_t *conf, sector_t sector, int disks,
+			      int pd_idx)
+{
+	struct stripe_queue *sq;
+
+	sq = get_active_queue(conf, sector, disks, pd_idx, 0);
+	do {
+		wait_queue_t wait;
+		init_waitqueue_entry(&wait, current);
+		add_wait_queue(&conf->wait_for_stripe, &wait);
+		for (;;) {
+		        set_current_state(TASK_UNINTERRUPTIBLE);
+		        if (sq->sh)
+		                break;
+			release_queue(sq);
+			sq = get_active_queue(conf, sector, disks, pd_idx, 0);
+		        schedule();
+		}
+		current->state = TASK_RUNNING;
+		remove_wait_queue(&conf->wait_for_stripe, &wait);
+	} while (0);
+
+	return sq;
+}
+
+
 static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped)
 {
 	/* reshaping is quite different to recovery/resync so it is
@@ -3729,6 +4205,7 @@ static sector_t reshape_request(mddev_t 
 	 */
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct stripe_head *sh;
+	struct stripe_queue *sq;
 	int pd_idx;
 	sector_t first_sector, last_sector;
 	int raid_disks = conf->previous_raid_disks;
@@ -3782,9 +4259,11 @@ static sector_t reshape_request(mddev_t 
 		int j;
 		int skipped = 0;
 		pd_idx = stripe_to_pdidx(sector_nr+i, conf, conf->raid_disks);
-		sh = get_active_stripe(conf, sector_nr+i,
-				       conf->raid_disks, pd_idx, 0);
-		set_bit(STRIPE_EXPANDING, &sh->state);
+		sq = wait_for_cache_attached_queue(conf, sector_nr+i,
+						   conf->raid_disks, pd_idx);
+		sh = sq->sh;
+
+		set_bit(STRIPE_QUEUE_EXPANDING, &sq->state);
 		atomic_inc(&conf->reshape_stripes);
 		/* If any of this stripe is beyond the end of the old
 		 * array, then we need to zero those blocks
@@ -3812,6 +4291,7 @@ static sector_t reshape_request(mddev_t 
 			set_bit(STRIPE_EXPAND_READY, &sh->state);
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
+		release_queue(sq);
 		release_stripe(sh);
 	}
 	spin_lock_irq(&conf->device_lock);
@@ -3836,10 +4316,13 @@ static sector_t reshape_request(mddev_t 
 	while (first_sector <= last_sector) {
 		pd_idx = stripe_to_pdidx(first_sector, conf,
 					 conf->previous_raid_disks);
-		sh = get_active_stripe(conf, first_sector,
-				       conf->previous_raid_disks, pd_idx, 0);
+		sq = wait_for_cache_attached_queue(conf, first_sector,
+						   conf->previous_raid_disks,
+						   pd_idx);
+		sh = sq->sh;
 		set_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 		set_bit(STRIPE_HANDLE, &sh->state);
+		release_queue(sq);
 		release_stripe(sh);
 		first_sector += STRIPE_SECTORS;
 	}
@@ -3900,15 +4383,10 @@ static inline sector_t sync_request(mdde
 	}
 
 	pd_idx = stripe_to_pdidx(sector_nr, conf, raid_disks);
-	sh = get_active_stripe(conf, sector_nr, raid_disks, pd_idx, 1);
-	if (sh == NULL) {
-		sh = get_active_stripe(conf, sector_nr, raid_disks, pd_idx, 0);
-		/* make sure we don't swamp the stripe cache if someone else
-		 * is trying to get access
-		 */
-		schedule_timeout_uninterruptible(1);
-	}
-	sq = sh->sq;
+
+	sq = wait_for_cache_attached_queue(conf, sector_nr, raid_disks,
+					   pd_idx);
+	sh = sq->sh;
 
 	/* Need to check if array will still be degraded after recovery/resync
 	 * We don't need to check the 'failed' flag as when that gets set,
@@ -3926,6 +4404,7 @@ static inline sector_t sync_request(mdde
 	spin_unlock(&sq->lock);
 
 	handle_stripe(sh, NULL);
+	release_queue(sq);
 	release_stripe(sh);
 
 	return STRIPE_SECTORS;
@@ -3943,18 +4422,19 @@ static int  retry_aligned_read(raid5_con
 	 * We *know* that this entire raid_bio is in one chunk, so
 	 * it will be only one 'dd_idx' and only need one call to raid5_compute_sector.
 	 */
-	struct stripe_head *sh;
 	struct stripe_queue *sq;
 	int dd_idx, pd_idx;
 	sector_t sector, logical_sector, last_sector;
 	int scnt = 0;
 	int remaining;
 	int handled = 0;
+	int disks = conf->raid_disks;
+	int data_disks = disks - conf->max_degraded;
 
 	logical_sector = raid_bio->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	sector = raid5_compute_sector(	logical_sector,
-					conf->raid_disks,
-					conf->raid_disks - conf->max_degraded,
+					disks,
+					data_disks,
 					&dd_idx,
 					&pd_idx,
 					conf);
@@ -3964,31 +4444,33 @@ static int  retry_aligned_read(raid5_con
 	     logical_sector += STRIPE_SECTORS,
 		     sector += STRIPE_SECTORS,
 		     scnt++) {
+		struct stripe_head *sh;
 
 		if (scnt < raid_bio->bi_hw_segments)
 			/* already done this stripe */
 			continue;
 
-		sh = get_active_stripe(conf, sector, conf->raid_disks, pd_idx, 1);
-
-		if (!sh) {
-			/* failed to get a stripe - must wait */
+		sq = get_active_queue(conf, sector, disks, pd_idx, 1);
+		if (!(sq && sq->sh)) {
+			/* failed to get a queue/stripe - must wait */
 			raid_bio->bi_hw_segments = scnt;
 			conf->retry_read_aligned = raid_bio;
+			if (sq)
+				release_queue(sq);
 			return handled;
 		}
 
-		sq = sh->sq;
+		sh = sq->sh;
 		set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
-		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
+		if (!add_queue_bio(sq, raid_bio, dd_idx, 0)) {
+			release_queue(sq);
 			release_stripe(sh);
 			raid_bio->bi_hw_segments = scnt;
 			conf->retry_read_aligned = raid_bio;
 			return handled;
 		}
 
-		handle_stripe(sh, NULL);
-		release_stripe(sh);
+		handle_queue(sq, disks, data_disks);
 		handled++;
 	}
 	spin_lock_irq(&conf->device_lock);
@@ -4007,7 +4489,60 @@ static int  retry_aligned_read(raid5_con
 	return handled;
 }
 
+static void raid456_cache_arbiter(struct work_struct *work)
+{
+	raid5_conf_t *conf = container_of(work, raid5_conf_t,
+					  stripe_queue_work);
+	struct list_head *sq_entry;
+	int attach = 0;
+
+	/* attach queues to stripes in priority order */
+	pr_debug("+++ %s active\n", __FUNCTION__);
+	spin_lock_irq(&conf->device_lock);
+	do {
+		sq_entry = NULL;
+		if (!list_empty(&conf->io_hi_queue))
+			sq_entry = conf->io_hi_queue.next;
+		else if (!list_empty(&conf->io_lo_queue))
+			sq_entry = conf->io_lo_queue.next;
+
+		/* "these aren't the droids you're looking for..."
+		 * do not handle the delayed list while there are better
+		 * things to do
+		 */
+		if (!sq_entry &&
+		    atomic_read(&conf->preread_active_queues) <
+		    IO_THRESHOLD && !blk_queue_plugged(conf->mddev->queue) &&
+		    !list_empty(&conf->delayed_q_list)) {
+			raid5_activate_delayed(conf);
+			sq_entry = conf->io_lo_queue.next;
+		}
+
+		if (sq_entry) {
+			struct stripe_queue *sq;
+			struct stripe_head *sh;
+			sq = list_entry(sq_entry, struct stripe_queue,
+					list_node);
+
+			list_del_init(sq_entry);
+			atomic_inc(&sq->count);
+			BUG_ON(atomic_read(&sq->count) != 1);
+			BUG_ON(sq->sh);
 
+			spin_unlock_irq(&conf->device_lock);
+			sh = get_active_stripe(sq, conf->raid_disks, 0);
+			spin_lock_irq(&conf->device_lock);
+
+			set_bit(STRIPE_HANDLE, &sh->state);
+			__release_queue(conf, sq);
+			__release_stripe(conf, sh);
+			attach++;
+		}
+	} while (sq_entry);
+	spin_unlock_irq(&conf->device_lock);
+	pr_debug("%d stripe(s) attached\n", attach);
+	pr_debug("--- %s inactive\n", __FUNCTION__);
+}
 
 /*
  * This is our raid5 kernel thread.
@@ -4041,12 +4576,6 @@ static void raid5d (mddev_t *mddev)
 			activate_bit_delay(conf);
 		}
 
-		if (list_empty(&conf->handle_list) &&
-		    atomic_read(&conf->preread_active_stripes) < IO_THRESHOLD &&
-		    !blk_queue_plugged(mddev->queue) &&
-		    !list_empty(&conf->delayed_list))
-			raid5_activate_delayed(conf);
-
 		while ((bio = remove_bio_from_retry(conf))) {
 			int ok;
 			spin_unlock_irq(&conf->device_lock);
@@ -4058,6 +4587,7 @@ static void raid5d (mddev_t *mddev)
 		}
 
 		if (list_empty(&conf->handle_list)) {
+			queue_work(conf->workqueue, &conf->stripe_queue_work);
 			async_tx_issue_pending_all();
 			break;
 		}
@@ -4100,7 +4630,8 @@ raid5_store_stripe_cache_size(mddev_t *m
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
 	char *end;
-	int new;
+	int new, queue, i;
+
 	if (len >= PAGE_SIZE)
 		return -EINVAL;
 	if (!conf)
@@ -4116,9 +4647,21 @@ raid5_store_stripe_cache_size(mddev_t *m
 			conf->max_nr_stripes--;
 		else
 			break;
+
+		for (i = 0, queue = 0; i < STRIPE_QUEUE_SIZE; i++)
+			queue += drop_one_queue(conf);
+
+		if (queue < STRIPE_QUEUE_SIZE)
+			break;
 	}
 	md_allow_write(mddev);
 	while (new > conf->max_nr_stripes) {
+		for (i = 0, queue = 0; i < STRIPE_QUEUE_SIZE; i++)
+			queue += grow_one_queue(conf);
+
+		if (queue < STRIPE_QUEUE_SIZE)
+			break;
+
 		if (grow_one_stripe(conf))
 			conf->max_nr_stripes++;
 		else break;
@@ -4144,9 +4687,23 @@ stripe_cache_active_show(mddev_t *mddev,
 static struct md_sysfs_entry
 raid5_stripecache_active = __ATTR_RO(stripe_cache_active);
 
+static ssize_t
+stripe_queue_active_show(mddev_t *mddev, char *page)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	if (conf)
+		return sprintf(page, "%d\n", atomic_read(&conf->active_queues));
+	else
+		return 0;
+}
+
+static struct md_sysfs_entry
+raid5_stripequeue_active = __ATTR_RO(stripe_queue_active);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
+	&raid5_stripequeue_active.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
@@ -4247,16 +4804,30 @@ static int run(mddev_t *mddev)
 		if (!conf->spare_page)
 			goto abort;
 	}
+
+	sprintf(conf->workqueue_name, "%s_cache_arb",
+		mddev->gendisk->disk_name);
+	conf->workqueue = create_singlethread_workqueue(conf->workqueue_name);
+	if (!conf->workqueue)
+		goto abort;
+
 	spin_lock_init(&conf->device_lock);
 	init_waitqueue_head(&conf->wait_for_stripe);
+	init_waitqueue_head(&conf->wait_for_queue);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
-	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
+	INIT_LIST_HEAD(&conf->io_hi_queue);
+	INIT_LIST_HEAD(&conf->io_lo_queue);
+	INIT_LIST_HEAD(&conf->delayed_q_list);
+	INIT_LIST_HEAD(&conf->inactive_queue_list);
 	atomic_set(&conf->active_stripes, 0);
-	atomic_set(&conf->preread_active_stripes, 0);
+	atomic_set(&conf->active_queues, 0);
+	atomic_set(&conf->preread_active_queues, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
+	INIT_WORK(&conf->stripe_queue_work, raid456_cache_arbiter);
+	init_sq.raid_conf = conf;
 
 	pr_debug("raid5: run(%s) called.\n", mdname(mddev));
 
@@ -4356,6 +4927,8 @@ static int run(mddev_t *mddev)
 		printk(KERN_INFO "raid5: allocated %dkB for %s\n",
 			memory, mdname(mddev));
 
+	conf->stripe_queue_tree = RB_ROOT;
+
 	if (mddev->degraded == 0)
 		printk("raid5: raid level %d set %s active with %d out of %d"
 			" devices, algorithm %d\n", conf->level, mdname(mddev), 
@@ -4436,6 +5009,7 @@ static int stop(mddev_t *mddev)
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	sysfs_remove_group(&mddev->kobj, &raid5_attrs_group);
 	kfree(conf->disks);
+	destroy_workqueue(conf->workqueue);
 	kfree(conf);
 	mddev->private = NULL;
 	return 0;
@@ -4445,10 +5019,9 @@ static int stop(mddev_t *mddev)
 static void print_sh (struct seq_file *seq, struct stripe_head *sh)
 {
 	int i;
-	struct stripe_queue *sq = sh->sq;
 
-	seq_printf(seq, "sh %llu, pd_idx %d, state %ld.\n",
-		   (unsigned long long)sh->sector, sq->pd_idx, sh->state);
+	seq_printf(seq, "sh %llu, state %ld.\n",
+		   (unsigned long long)sh->sector, sh->state);
 	seq_printf(seq, "sh %llu,  count %d.\n",
 		   (unsigned long long)sh->sector, atomic_read(&sh->count));
 	seq_printf(seq, "sh %llu, ", (unsigned long long)sh->sector);
@@ -4459,19 +5032,33 @@ static void print_sh (struct seq_file *s
 	seq_printf(seq, "\n");
 }
 
-static void printall (struct seq_file *seq, raid5_conf_t *conf)
+static void print_sq(struct seq_file *seq, struct stripe_queue *sq)
 {
-	struct stripe_head *sh;
-	struct hlist_node *hn;
 	int i;
 
+	seq_printf(seq, "sq %llu, pd_idx %d, state %ld.\n",
+		   (unsigned long long)sq->sector, sq->pd_idx, sq->state);
+	seq_printf(seq, "sq %llu,  count %d.\n",
+		   (unsigned long long)sq->sector, atomic_read(&sq->count));
+	seq_printf(seq, "sq %llu, ", (unsigned long long)sq->sector);
+	seq_printf(seq, "\n");
+	seq_printf(seq, "sq %llu,  sh %p.\n",
+		   (unsigned long long) sq->sector, sq->sh);
+	if (sq->sh)
+		print_sh(seq, sq->sh);
+}
+
+static void printall (struct seq_file *seq, raid5_conf_t *conf)
+{
+	struct stripe_queue *sq;
+	struct rb_node *rbn;
+
 	spin_lock_irq(&conf->device_lock);
-	for (i = 0; i < NR_HASH; i++) {
-		hlist_for_each_entry(sh, hn, &conf->stripe_hashtbl[i], hash) {
-			if (sh->sq->raid_conf != conf)
-				continue;
-			print_sh(seq, sh);
-		}
+	rbn = rb_first(&conf->stripe_queue_tree);
+	while (rbn) {
+		sq = rb_entry(rbn, struct stripe_queue, rb_node);
+		print_sq(seq, sq);
+		rbn = rb_next(rbn);
 	}
 	spin_unlock_irq(&conf->device_lock);
 }
@@ -4790,8 +5377,8 @@ static void raid5_quiesce(mddev_t *mddev
 	case 1: /* stop all writes */
 		spin_lock_irq(&conf->device_lock);
 		conf->quiesce = 1;
-		wait_event_lock_irq(conf->wait_for_stripe,
-				    atomic_read(&conf->active_stripes) == 0 &&
+		wait_event_lock_irq(conf->wait_for_queue,
+				    atomic_read(&conf->active_queues) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,
 				    conf->device_lock, /* nothing */);
 		spin_unlock_irq(&conf->device_lock);
@@ -4800,7 +5387,7 @@ static void raid5_quiesce(mddev_t *mddev
 	case 0: /* re-enable writes */
 		spin_lock_irq(&conf->device_lock);
 		conf->quiesce = 0;
-		wake_up(&conf->wait_for_stripe);
+		wake_up(&conf->wait_for_queue);
 		wake_up(&conf->wait_for_overlap);
 		spin_unlock_irq(&conf->device_lock);
 		break;
diff -puN include/linux/raid/raid5.h~raid5-use-stripe_queues-to-prioritize-the-most include/linux/raid/raid5.h
--- a/include/linux/raid/raid5.h~raid5-use-stripe_queues-to-prioritize-the-most
+++ a/include/linux/raid/raid5.h
@@ -3,6 +3,7 @@
 
 #include <linux/raid/md.h>
 #include <linux/raid/xor.h>
+#include <linux/rbtree.h>
 
 /*
  *
@@ -181,7 +182,7 @@ struct stripe_head {
 		int		   count;
 		u32		   zero_sum_result;
 	} ops;
-	struct stripe_queue *sq;
+	struct stripe_queue *sq; /* list of pending bios for this stripe */
 	struct r5dev {
 		struct bio	req;
 		struct bio_vec	vec;
@@ -206,12 +207,28 @@ struct r6_state {
 	int p_failed, q_failed, qd_idx, failed_num[2];
 };
 
+/* stripe_queue
+ * @sector - rb_tree key
+ * @lock
+ * @sh - our stripe_head in the cache
+ * @list_node - once this queue object satisfies some constraint (like full
+ *  stripe write) it is placed on a list for processing by the cache
+ * @overwrite_count - how many blocks are set to be overwritten
+ */
 struct stripe_queue {
+	struct rb_node rb_node;
 	sector_t sector;
 	int pd_idx; /* parity disk index */
 	int bm_seq; /* sequence number for bitmap flushes */
 	spinlock_t lock;
 	struct raid5_private_data *raid_conf;
+	unsigned long state;
+	struct stripe_head *sh;
+	struct list_head list_node;
+	unsigned long *to_read;
+	unsigned long *to_write;
+	unsigned long *overwrite;
+	atomic_t count;
 	struct r5_queue_dev {
 		sector_t sector; /* hw starting sector for this block */
 		struct bio *toread, *towrite;
@@ -254,11 +271,7 @@ struct stripe_queue {
 #define STRIPE_HANDLE		2
 #define	STRIPE_SYNCING		3
 #define	STRIPE_INSYNC		4
-#define	STRIPE_PREREAD_ACTIVE	5
-#define	STRIPE_DELAYED		6
 #define	STRIPE_DEGRADED		7
-#define	STRIPE_BIT_DELAY	8
-#define	STRIPE_EXPANDING	9
 #define	STRIPE_EXPAND_SOURCE	10
 #define	STRIPE_EXPAND_READY	11
 /*
@@ -280,6 +293,17 @@ struct stripe_queue {
 #define STRIPE_OP_MOD_DMA_CHECK 8
 
 /*
+ * Stripe-queue state
+ */
+#define STRIPE_QUEUE_HANDLE		0
+#define STRIPE_QUEUE_IO_HI		1
+#define STRIPE_QUEUE_IO_LO		2
+#define STRIPE_QUEUE_DELAYED		3
+#define STRIPE_QUEUE_EXPANDING		4
+#define STRIPE_QUEUE_PREREAD_ACTIVE	5
+#define STRIPE_QUEUE_BIT_DELAY		6
+
+/*
  * Plugging:
  *
  * To improve write throughput, we need to delay the handling of some
@@ -310,6 +334,7 @@ struct disk_info {
 
 struct raid5_private_data {
 	struct hlist_head	*stripe_hashtbl;
+	struct rb_root		stripe_queue_tree;
 	mddev_t			*mddev;
 	struct disk_info	*spare;
 	int			chunk_size, level, algorithm;
@@ -325,12 +350,22 @@ struct raid5_private_data {
 	int			previous_raid_disks;
 
 	struct list_head	handle_list; /* stripes needing handling */
-	struct list_head	delayed_list; /* stripes that have plugged requests */
 	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
+	struct list_head	delayed_q_list; /* queues that have plugged
+						 * requests
+						 */
+	struct list_head	io_hi_queue; /* reads and full stripe writes */
+	struct list_head	io_lo_queue; /* sub-stripe-width writes */
+	struct workqueue_struct *workqueue; /* attaches sq's to sh's */
+	struct work_struct	stripe_queue_work;
+	char 			workqueue_name[20];
+
 	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
 	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
-	atomic_t		preread_active_stripes; /* stripes with scheduled io */
 	atomic_t		active_aligned_reads;
+	atomic_t		preread_active_queues; /* queues with scheduled
+							* io
+							*/
 
 	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
 	/* unfortunately we need two cache names as we temporarily have
@@ -338,7 +373,7 @@ struct raid5_private_data {
 	 */
 	int			active_name;
 	char			sh_cache_name[2][20];
-	char			sq_cache_name[2][20];
+	char                    sq_cache_name[2][20];
 	struct kmem_cache	*sh_slab_cache;
 	struct kmem_cache	*sq_slab_cache;
 
@@ -353,12 +388,20 @@ struct raid5_private_data {
 	struct page 		*spare_page; /* Used when checking P/Q in raid6 */
 
 	/*
+	 * Free queue pool
+	 */
+	atomic_t		active_queues;
+	struct list_head	inactive_queue_list;
+	wait_queue_head_t	wait_for_queue;
+	wait_queue_head_t	wait_for_overlap;
+	int			inactive_queue_blocked;
+
+	/*
 	 * Free stripes pool
 	 */
 	atomic_t		active_stripes;
 	struct list_head	inactive_list;
 	wait_queue_head_t	wait_for_stripe;
-	wait_queue_head_t	wait_for_overlap;
 	int			inactive_blocked;	/* release of inactive stripes blocked,
 							 * waiting for 25% to be free
 							 */
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

git-md-accel.patch
remove-unsafe-from-module-struct.patch
raid5-use-stripe_queues-to-prioritize-the-most.patch
