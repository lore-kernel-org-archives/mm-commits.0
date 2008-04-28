From: akpm@linux-foundation.org
Subject: - md-introduce-get_priority_stripe-to-improve-raid456-write-performance.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:56 -0700
Message-ID: <200804282159.m3SLxvsY018628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965502AbYD1WAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, babydr@baby-dragons.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: introduce get_priority_stripe() to improve raid456 write performance
has been removed from the -mm tree.  Its filename was
     md-introduce-get_priority_stripe-to-improve-raid456-write-performance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: introduce get_priority_stripe() to improve raid456 write performance
From: Dan Williams <dan.j.williams@intel.com>

Improve write performance by preventing the delayed_list from dumping all its
stripes onto the handle_list in one shot.  Delayed stripes are now further
delayed by being held on the 'hold_list'.  The 'hold_list' is bypassed when:

  * a STRIPE_IO_STARTED stripe is found at the head of 'handle_list'
  * 'handle_list' is empty and i/o is being done to satisfy full stripe-width
    write requests
  * 'bypass_count' is less than 'bypass_threshold'.  By default the threshold
    is 1, i.e. every other stripe handled is a preread stripe provided the
    top two conditions are false.

Benchmark data:
System: 2x Xeon 5150, 4x SATA, mem=1GB
Baseline: 2.6.24-rc7
Configuration: mdadm --create /dev/md0 /dev/sd[b-e] -n 4 -l 5 --assume-clean
Test1: dd if=/dev/zero of=/dev/md0 bs=1024k count=2048
  * patched:  +33% (stripe_cache_size = 256), +25% (stripe_cache_size = 512)

Test2: tiobench --size 2048 --numruns 5 --block 4096 --block 131072 (XFS)
  * patched: +13%
  * patched + preread_bypass_threshold = 0: +37%

Changes since v1:
* reduce bypass_threshold from (chunk_size / sectors_per_chunk) to (1) and
  make it configurable.  This defaults to fairness and modest performance
  gains out of the box.
Changes since v2:
* [neilb@suse.de]: kill STRIPE_PRIO_HI and preread_needed as they are not
  necessary, the important change was clearing STRIPE_DELAYED in
  add_stripe_bio and this has been moved out to make_request for the hang
  fix.
* [neilb@suse.de]: simplify get_priority_stripe
* [dan.j.williams@intel.com]: reset the bypass_count when ->hold_list is
  sampled empty (+11%)
* [dan.j.williams@intel.com]: decrement the bypass_count at the detection
  of stripes being naturally promoted off of hold_list +2%.  Note, resetting
  bypass_count instead of decrementing on these events yields +4% but that is
  probably too aggressive.
Changes since v3:
* cosmetic fixups

Tested-by: James W. Laferriere <babydr@baby-dragons.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/md.txt       |    6 +
 drivers/md/raid5.c         |  122 ++++++++++++++++++++++++++++++++---
 include/linux/raid/raid5.h |    7 ++
 3 files changed, 125 insertions(+), 10 deletions(-)

diff -puN Documentation/md.txt~md-introduce-get_priority_stripe-to-improve-raid456-write-performance Documentation/md.txt
--- a/Documentation/md.txt~md-introduce-get_priority_stripe-to-improve-raid456-write-performance
+++ a/Documentation/md.txt
@@ -450,3 +450,9 @@ These currently include
       there are upper and lower limits (32768, 16).  Default is 128.
   strip_cache_active (currently raid5 only)
       number of active entries in the stripe cache
+  preread_bypass_threshold (currently raid5 only)
+      number of times a stripe requiring preread will be bypassed by
+      a stripe that does not require preread.  For fairness defaults
+      to 1.  Setting this to 0 disables bypass accounting and
+      requires preread stripes to wait until all full-width stripe-
+      writes are complete.  Valid values are 0 to stripe_cache_size.
diff -puN drivers/md/raid5.c~md-introduce-get_priority_stripe-to-improve-raid456-write-performance drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-introduce-get_priority_stripe-to-improve-raid456-write-performance
+++ a/drivers/md/raid5.c
@@ -63,6 +63,7 @@
 #define STRIPE_SHIFT		(PAGE_SHIFT - 9)
 #define STRIPE_SECTORS		(STRIPE_SIZE>>9)
 #define	IO_THRESHOLD		1
+#define BYPASS_THRESHOLD	1
 #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
 
@@ -398,6 +399,7 @@ static void ops_run_io(struct stripe_hea
 
 	might_sleep();
 
+	set_bit(STRIPE_IO_STARTED, &sh->state);
 	for (i = disks; i--; ) {
 		int rw;
 		struct bio *bi;
@@ -1720,6 +1722,9 @@ handle_write_operations5(struct stripe_h
 				locked++;
 			}
 		}
+		if (locked + 1 == disks)
+			if (!test_and_set_bit(STRIPE_FULL_WRITE, &sh->state))
+				atomic_inc(&sh->raid_conf->pending_full_writes);
 	} else {
 		BUG_ON(!(test_bit(R5_UPTODATE, &sh->dev[pd_idx].flags) ||
 			test_bit(R5_Wantcompute, &sh->dev[pd_idx].flags)));
@@ -1947,6 +1952,9 @@ handle_requests_to_failed_array(raid5_co
 					STRIPE_SECTORS, 0, 0);
 	}
 
+	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
+		if (atomic_dec_and_test(&conf->pending_full_writes))
+			md_wakeup_thread(conf->mddev->thread);
 }
 
 /* __handle_issuing_new_read_requests5 - returns 0 if there are no more disks
@@ -2149,6 +2157,10 @@ static void handle_completed_write_reque
 							0);
 			}
 		}
+
+	if (test_and_clear_bit(STRIPE_FULL_WRITE, &sh->state))
+		if (atomic_dec_and_test(&conf->pending_full_writes))
+			md_wakeup_thread(conf->mddev->thread);
 }
 
 static void handle_issuing_new_write_requests5(raid5_conf_t *conf,
@@ -2333,6 +2345,9 @@ static void handle_issuing_new_write_req
 				s->locked++;
 				set_bit(R5_Wantwrite, &sh->dev[i].flags);
 			}
+		if (s->locked == disks)
+			if (!test_and_set_bit(STRIPE_FULL_WRITE, &sh->state))
+				atomic_inc(&conf->pending_full_writes);
 		/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
 		set_bit(STRIPE_INSYNC, &sh->state);
 
@@ -3094,6 +3109,8 @@ static void handle_stripe6(struct stripe
 		else
 			continue;
 
+		set_bit(STRIPE_IO_STARTED, &sh->state);
+
 		bi = &sh->dev[i].req;
 
 		bi->bi_rw = rw;
@@ -3164,7 +3181,7 @@ static void raid5_activate_delayed(raid5
 			clear_bit(STRIPE_DELAYED, &sh->state);
 			if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
-			list_add_tail(&sh->lru, &conf->handle_list);
+			list_add_tail(&sh->lru, &conf->hold_list);
 		}
 	} else
 		blk_plug_device(conf->mddev->queue);
@@ -3442,6 +3459,58 @@ static int chunk_aligned_read(struct req
 	}
 }
 
+/* __get_priority_stripe - get the next stripe to process
+ *
+ * Full stripe writes are allowed to pass preread active stripes up until
+ * the bypass_threshold is exceeded.  In general the bypass_count
+ * increments when the handle_list is handled before the hold_list; however, it
+ * will not be incremented when STRIPE_IO_STARTED is sampled set signifying a
+ * stripe with in flight i/o.  The bypass_count will be reset when the
+ * head of the hold_list has changed, i.e. the head was promoted to the
+ * handle_list.
+ */
+static struct stripe_head *__get_priority_stripe(raid5_conf_t *conf)
+{
+	struct stripe_head *sh;
+
+	pr_debug("%s: handle: %s hold: %s full_writes: %d bypass_count: %d\n",
+		  __func__,
+		  list_empty(&conf->handle_list) ? "empty" : "busy",
+		  list_empty(&conf->hold_list) ? "empty" : "busy",
+		  atomic_read(&conf->pending_full_writes), conf->bypass_count);
+
+	if (!list_empty(&conf->handle_list)) {
+		sh = list_entry(conf->handle_list.next, typeof(*sh), lru);
+
+		if (list_empty(&conf->hold_list))
+			conf->bypass_count = 0;
+		else if (!test_bit(STRIPE_IO_STARTED, &sh->state)) {
+			if (conf->hold_list.next == conf->last_hold)
+				conf->bypass_count++;
+			else {
+				conf->last_hold = conf->hold_list.next;
+				conf->bypass_count -= conf->bypass_threshold;
+				if (conf->bypass_count < 0)
+					conf->bypass_count = 0;
+			}
+		}
+	} else if (!list_empty(&conf->hold_list) &&
+		   ((conf->bypass_threshold &&
+		     conf->bypass_count > conf->bypass_threshold) ||
+		    atomic_read(&conf->pending_full_writes) == 0)) {
+		sh = list_entry(conf->hold_list.next,
+				typeof(*sh), lru);
+		conf->bypass_count -= conf->bypass_threshold;
+		if (conf->bypass_count < 0)
+			conf->bypass_count = 0;
+	} else
+		return NULL;
+
+	list_del_init(&sh->lru);
+	atomic_inc(&sh->count);
+	BUG_ON(atomic_read(&sh->count) != 1);
+	return sh;
+}
 
 static int make_request(struct request_queue *q, struct bio * bi)
 {
@@ -3914,7 +3983,6 @@ static void raid5d(mddev_t *mddev)
 	handled = 0;
 	spin_lock_irq(&conf->device_lock);
 	while (1) {
-		struct list_head *first;
 		struct bio *bio;
 
 		if (conf->seq_flush != conf->seq_write) {
@@ -3936,17 +4004,12 @@ static void raid5d(mddev_t *mddev)
 			handled++;
 		}
 
-		if (list_empty(&conf->handle_list)) {
+		sh = __get_priority_stripe(conf);
+
+		if (!sh) {
 			async_tx_issue_pending_all();
 			break;
 		}
-
-		first = conf->handle_list.next;
-		sh = list_entry(first, struct stripe_head, lru);
-
-		list_del_init(first);
-		atomic_inc(&sh->count);
-		BUG_ON(atomic_read(&sh->count)!= 1);
 		spin_unlock_irq(&conf->device_lock);
 		
 		handled++;
@@ -4011,6 +4074,42 @@ raid5_stripecache_size = __ATTR(stripe_c
 				raid5_store_stripe_cache_size);
 
 static ssize_t
+raid5_show_preread_threshold(mddev_t *mddev, char *page)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	if (conf)
+		return sprintf(page, "%d\n", conf->bypass_threshold);
+	else
+		return 0;
+}
+
+static ssize_t
+raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t len)
+{
+	raid5_conf_t *conf = mddev_to_conf(mddev);
+	char *end;
+	int new;
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (!conf)
+		return -ENODEV;
+
+	new = simple_strtoul(page, &end, 10);
+	if (!*page || (*end && *end != '\n'))
+		return -EINVAL;
+	if (new > conf->max_nr_stripes || new < 0)
+		return -EINVAL;
+	conf->bypass_threshold = new;
+	return len;
+}
+
+static struct md_sysfs_entry
+raid5_preread_bypass_threshold = __ATTR(preread_bypass_threshold,
+					S_IRUGO | S_IWUSR,
+					raid5_show_preread_threshold,
+					raid5_store_preread_threshold);
+
+static ssize_t
 stripe_cache_active_show(mddev_t *mddev, char *page)
 {
 	raid5_conf_t *conf = mddev_to_conf(mddev);
@@ -4026,6 +4125,7 @@ raid5_stripecache_active = __ATTR_RO(str
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
+	&raid5_preread_bypass_threshold.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {
@@ -4130,12 +4230,14 @@ static int run(mddev_t *mddev)
 	init_waitqueue_head(&conf->wait_for_stripe);
 	init_waitqueue_head(&conf->wait_for_overlap);
 	INIT_LIST_HEAD(&conf->handle_list);
+	INIT_LIST_HEAD(&conf->hold_list);
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 	atomic_set(&conf->active_aligned_reads, 0);
+	conf->bypass_threshold = BYPASS_THRESHOLD;
 
 	pr_debug("raid5: run(%s) called.\n", mdname(mddev));
 
diff -puN include/linux/raid/raid5.h~md-introduce-get_priority_stripe-to-improve-raid456-write-performance include/linux/raid/raid5.h
--- a/include/linux/raid/raid5.h~md-introduce-get_priority_stripe-to-improve-raid456-write-performance
+++ a/include/linux/raid/raid5.h
@@ -252,6 +252,8 @@ struct r6_state {
 #define	STRIPE_EXPANDING	9
 #define	STRIPE_EXPAND_SOURCE	10
 #define	STRIPE_EXPAND_READY	11
+#define	STRIPE_IO_STARTED	12 /* do not count towards 'bypass_count' */
+#define	STRIPE_FULL_WRITE	13 /* all blocks are set to be overwritten */
 /*
  * Operations flags (in issue order)
  */
@@ -316,12 +318,17 @@ struct raid5_private_data {
 	int			previous_raid_disks;
 
 	struct list_head	handle_list; /* stripes needing handling */
+	struct list_head	hold_list; /* preread ready stripes */
 	struct list_head	delayed_list; /* stripes that have plugged requests */
 	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update */
 	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
 	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
 	atomic_t		preread_active_stripes; /* stripes with scheduled io */
 	atomic_t		active_aligned_reads;
+	atomic_t		pending_full_writes; /* full write backlog */
+	int			bypass_count; /* bypassed prereads */
+	int			bypass_threshold; /* preread nice */
+	struct list_head	*last_hold; /* detect hold_list promotions */
 
 	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */
 	/* unfortunately we need two cache names as we temporarily have
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

