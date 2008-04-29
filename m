From: akpm@linux-foundation.org
Subject: + md-md-support-blocking-writes-to-an-array-on-device-failure.patch added to -mm tree
Date: Mon, 28 Apr 2008 20:56:37 -0700
Message-ID: <200804290356.m3T3ub3t032377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633AbYD2D4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 23:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, neilb@suse.de


The patch titled
     md: md: support blocking writes to an array on device failure
has been added to the -mm tree.  Its filename is
     md-md-support-blocking-writes-to-an-array-on-device-failure.patch

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
Subject: md: md: support blocking writes to an array on device failure
From: Dan Williams <dan.j.williams@intel.com>

Allows a userspace metadata handler to take action upon detecting a device
failure.

Based on an original patch by Neil Brown.

Changes:
-added blocked_wait waitqueue to rdev
-don't qualify Blocked with Faulty always let userspace block writes
-added md_wait_for_blocked_rdev to wait for the block device to be clear, if
 userspace misses the notification another one is sent every 5 seconds
-set MD_RECOVERY_NEEDED after clearing "blocked"
-kill DoBlock flag, just test mddev->external

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c           |   33 ++++++++++++++++++++++++++++++++-
 drivers/md/raid1.c        |   27 ++++++++++++++++++++++++---
 drivers/md/raid10.c       |   29 ++++++++++++++++++++++++++---
 drivers/md/raid5.c        |   33 +++++++++++++++++++++++++++++++++
 include/linux/raid/md.h   |    1 +
 include/linux/raid/md_k.h |    4 ++++
 6 files changed, 120 insertions(+), 7 deletions(-)

diff -puN drivers/md/md.c~md-md-support-blocking-writes-to-an-array-on-device-failure drivers/md/md.c
--- a/drivers/md/md.c~md-md-support-blocking-writes-to-an-array-on-device-failure
+++ a/drivers/md/md.c
@@ -1827,6 +1827,10 @@ state_show(mdk_rdev_t *rdev, char *page)
 		len += sprintf(page+len, "%swrite_mostly",sep);
 		sep = ",";
 	}
+	if (test_bit(Blocked, &rdev->flags)) {
+		len += sprintf(page+len, "%sblocked", sep);
+		sep = ",";
+	}
 	if (!test_bit(Faulty, &rdev->flags) &&
 	    !test_bit(In_sync, &rdev->flags)) {
 		len += sprintf(page+len, "%sspare", sep);
@@ -1843,6 +1847,8 @@ state_store(mdk_rdev_t *rdev, const char
 	 *  remove  - disconnects the device
 	 *  writemostly - sets write_mostly
 	 *  -writemostly - clears write_mostly
+	 *  blocked - sets the Blocked flag
+	 *  -blocked - clears the Blocked flag
 	 */
 	int err = -EINVAL;
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
@@ -1865,6 +1871,16 @@ state_store(mdk_rdev_t *rdev, const char
 	} else if (cmd_match(buf, "-writemostly")) {
 		clear_bit(WriteMostly, &rdev->flags);
 		err = 0;
+	} else if (cmd_match(buf, "blocked")) {
+		set_bit(Blocked, &rdev->flags);
+		err = 0;
+	} else if (cmd_match(buf, "-blocked")) {
+		clear_bit(Blocked, &rdev->flags);
+		wake_up(&rdev->blocked_wait);
+		set_bit(MD_RECOVERY_NEEDED, &rdev->mddev->recovery);
+		md_wakeup_thread(rdev->mddev->thread);
+
+		err = 0;
 	}
 	return err ? err : len;
 }
@@ -2193,7 +2209,9 @@ static mdk_rdev_t *md_import_device(dev_
 			goto abort_free;
 		}
 	}
+
 	INIT_LIST_HEAD(&rdev->same_set);
+	init_waitqueue_head(&rdev->blocked_wait);
 
 	return rdev;
 
@@ -4957,6 +4975,9 @@ void md_error(mddev_t *mddev, mdk_rdev_t
 
 	if (!rdev || test_bit(Faulty, &rdev->flags))
 		return;
+
+	if (mddev->external)
+		set_bit(Blocked, &rdev->flags);
 /*
 	dprintk("md_error dev:%s, rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
 		mdname(mddev),
@@ -5759,7 +5780,7 @@ static int remove_and_add_spares(mddev_t
 
 	rdev_for_each(rdev, rtmp, mddev)
 		if (rdev->raid_disk >= 0 &&
-		    !mddev->external &&
+		    !test_bit(Blocked, &rdev->flags) &&
 		    (test_bit(Faulty, &rdev->flags) ||
 		     ! test_bit(In_sync, &rdev->flags)) &&
 		    atomic_read(&rdev->nr_pending)==0) {
@@ -5958,6 +5979,16 @@ void md_check_recovery(mddev_t *mddev)
 	}
 }
 
+void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev)
+{
+	sysfs_notify(&rdev->kobj, NULL, "state");
+	wait_event_timeout(rdev->blocked_wait,
+			   !test_bit(Blocked, &rdev->flags),
+			   msecs_to_jiffies(5000));
+	rdev_dec_pending(rdev, mddev);
+}
+EXPORT_SYMBOL(md_wait_for_blocked_rdev);
+
 static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {
diff -puN drivers/md/raid1.c~md-md-support-blocking-writes-to-an-array-on-device-failure drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-md-support-blocking-writes-to-an-array-on-device-failure
+++ a/drivers/md/raid1.c
@@ -773,7 +773,6 @@ static int make_request(struct request_q
 	r1bio_t *r1_bio;
 	struct bio *read_bio;
 	int i, targets = 0, disks;
-	mdk_rdev_t *rdev;
 	struct bitmap *bitmap = mddev->bitmap;
 	unsigned long flags;
 	struct bio_list bl;
@@ -781,6 +780,7 @@ static int make_request(struct request_q
 	const int rw = bio_data_dir(bio);
 	const int do_sync = bio_sync(bio);
 	int do_barriers;
+	mdk_rdev_t *blocked_rdev;
 
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -862,10 +862,17 @@ static int make_request(struct request_q
 	first = 0;
 	}
 #endif
+ retry_write:
+	blocked_rdev = NULL;
 	rcu_read_lock();
 	for (i = 0;  i < disks; i++) {
-		if ((rdev=rcu_dereference(conf->mirrors[i].rdev)) != NULL &&
-		    !test_bit(Faulty, &rdev->flags)) {
+		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
+		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
+			atomic_inc(&rdev->nr_pending);
+			blocked_rdev = rdev;
+			break;
+		}
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			atomic_inc(&rdev->nr_pending);
 			if (test_bit(Faulty, &rdev->flags)) {
 				rdev_dec_pending(rdev, mddev);
@@ -878,6 +885,20 @@ static int make_request(struct request_q
 	}
 	rcu_read_unlock();
 
+	if (unlikely(blocked_rdev)) {
+		/* Wait for this device to become unblocked */
+		int j;
+
+		for (j = 0; j < i; j++)
+			if (r1_bio->bios[j])
+				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
+
+		allow_barrier(conf);
+		md_wait_for_blocked_rdev(blocked_rdev, mddev);
+		wait_barrier(conf);
+		goto retry_write;
+	}
+
 	BUG_ON(targets == 0); /* we never fail the last device */
 
 	if (targets < conf->raid_disks) {
diff -puN drivers/md/raid10.c~md-md-support-blocking-writes-to-an-array-on-device-failure drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-md-support-blocking-writes-to-an-array-on-device-failure
+++ a/drivers/md/raid10.c
@@ -790,6 +790,7 @@ static int make_request(struct request_q
 	const int do_sync = bio_sync(bio);
 	struct bio_list bl;
 	unsigned long flags;
+	mdk_rdev_t *blocked_rdev;
 
 	if (unlikely(bio_barrier(bio))) {
 		bio_endio(bio, -EOPNOTSUPP);
@@ -879,17 +880,23 @@ static int make_request(struct request_q
 	/*
 	 * WRITE:
 	 */
-	/* first select target devices under spinlock and
+	/* first select target devices under rcu_lock and
 	 * inc refcount on their rdev.  Record them by setting
 	 * bios[x] to bio
 	 */
 	raid10_find_phys(conf, r10_bio);
+ retry_write:
+	blocked_rdev = 0;
 	rcu_read_lock();
 	for (i = 0;  i < conf->copies; i++) {
 		int d = r10_bio->devs[i].devnum;
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[d].rdev);
-		if (rdev &&
-		    !test_bit(Faulty, &rdev->flags)) {
+		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
+			atomic_inc(&rdev->nr_pending);
+			blocked_rdev = rdev;
+			break;
+		}
+		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			atomic_inc(&rdev->nr_pending);
 			r10_bio->devs[i].bio = bio;
 		} else {
@@ -899,6 +906,22 @@ static int make_request(struct request_q
 	}
 	rcu_read_unlock();
 
+	if (unlikely(blocked_rdev)) {
+		/* Have to wait for this device to get unblocked, then retry */
+		int j;
+		int d;
+
+		for (j = 0; j < i; j++)
+			if (r10_bio->devs[j].bio) {
+				d = r10_bio->devs[j].devnum;
+				rdev_dec_pending(conf->mirrors[d].rdev, mddev);
+			}
+		allow_barrier(conf);
+		md_wait_for_blocked_rdev(blocked_rdev, mddev);
+		wait_barrier(conf);
+		goto retry_write;
+	}
+
 	atomic_set(&r10_bio->remaining, 0);
 
 	bio_list_init(&bl);
diff -puN drivers/md/raid5.c~md-md-support-blocking-writes-to-an-array-on-device-failure drivers/md/raid5.c
--- a/drivers/md/raid5.c~md-md-support-blocking-writes-to-an-array-on-device-failure
+++ a/drivers/md/raid5.c
@@ -2610,6 +2610,7 @@ static void handle_stripe_expansion(raid
 	}
 }
 
+
 /*
  * handle_stripe - do things to a stripe.
  *
@@ -2635,6 +2636,7 @@ static void handle_stripe5(struct stripe
 	struct stripe_head_state s;
 	struct r5dev *dev;
 	unsigned long pending = 0;
+	mdk_rdev_t *blocked_rdev = NULL;
 
 	memset(&s, 0, sizeof(s));
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, pd_idx=%d "
@@ -2694,6 +2696,11 @@ static void handle_stripe5(struct stripe
 		if (dev->written)
 			s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
+		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
+			blocked_rdev = rdev;
+			atomic_inc(&rdev->nr_pending);
+			break;
+		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
 			clear_bit(R5_ReadError, &dev->flags);
@@ -2708,6 +2715,11 @@ static void handle_stripe5(struct stripe
 	}
 	rcu_read_unlock();
 
+	if (unlikely(blocked_rdev)) {
+		set_bit(STRIPE_HANDLE, &sh->state);
+		goto unlock;
+	}
+
 	if (s.to_fill && !test_and_set_bit(STRIPE_OP_BIOFILL, &sh->ops.pending))
 		sh->ops.count++;
 
@@ -2897,8 +2909,13 @@ static void handle_stripe5(struct stripe
 	if (sh->ops.count)
 		pending = get_stripe_work(sh);
 
+ unlock:
 	spin_unlock(&sh->lock);
 
+	/* wait for this device to become unblocked */
+	if (unlikely(blocked_rdev))
+		md_wait_for_blocked_rdev(blocked_rdev, conf->mddev);
+
 	if (pending)
 		raid5_run_ops(sh, pending);
 
@@ -2915,6 +2932,7 @@ static void handle_stripe6(struct stripe
 	struct stripe_head_state s;
 	struct r6_state r6s;
 	struct r5dev *dev, *pdev, *qdev;
+	mdk_rdev_t *blocked_rdev = NULL;
 
 	r6s.qd_idx = raid6_next_disk(pd_idx, disks);
 	pr_debug("handling stripe %llu, state=%#lx cnt=%d, "
@@ -2978,6 +2996,11 @@ static void handle_stripe6(struct stripe
 		if (dev->written)
 			s.written++;
 		rdev = rcu_dereference(conf->disks[i].rdev);
+		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
+			blocked_rdev = rdev;
+			atomic_inc(&rdev->nr_pending);
+			break;
+		}
 		if (!rdev || !test_bit(In_sync, &rdev->flags)) {
 			/* The ReadError flag will just be confusing now */
 			clear_bit(R5_ReadError, &dev->flags);
@@ -2992,6 +3015,11 @@ static void handle_stripe6(struct stripe
 			set_bit(R5_Insync, &dev->flags);
 	}
 	rcu_read_unlock();
+
+	if (unlikely(blocked_rdev)) {
+		set_bit(STRIPE_HANDLE, &sh->state);
+		goto unlock;
+	}
 	pr_debug("locked=%d uptodate=%d to_read=%d"
 	       " to_write=%d failed=%d failed_num=%d,%d\n",
 	       s.locked, s.uptodate, s.to_read, s.to_write, s.failed,
@@ -3097,8 +3125,13 @@ static void handle_stripe6(struct stripe
 	    !test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending))
 		handle_stripe_expansion(conf, sh, &r6s);
 
+ unlock:
 	spin_unlock(&sh->lock);
 
+	/* wait for this device to become unblocked */
+	if (unlikely(blocked_rdev))
+		md_wait_for_blocked_rdev(blocked_rdev, conf->mddev);
+
 	return_io(return_bi);
 
 	for (i=disks; i-- ;) {
diff -puN include/linux/raid/md.h~md-md-support-blocking-writes-to-an-array-on-device-failure include/linux/raid/md.h
--- a/include/linux/raid/md.h~md-md-support-blocking-writes-to-an-array-on-device-failure
+++ a/include/linux/raid/md.h
@@ -94,6 +94,7 @@ extern int sync_page_io(struct block_dev
 extern void md_do_sync(mddev_t *mddev);
 extern void md_new_event(mddev_t *mddev);
 extern void md_allow_write(mddev_t *mddev);
+extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
 
 #endif /* CONFIG_MD */
 #endif 
diff -puN include/linux/raid/md_k.h~md-md-support-blocking-writes-to-an-array-on-device-failure include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~md-md-support-blocking-writes-to-an-array-on-device-failure
+++ a/include/linux/raid/md_k.h
@@ -84,6 +84,10 @@ struct mdk_rdev_s
 #define	AllReserved	6		/* If whole device is reserved for
 					 * one array */
 #define	AutoDetected	7		/* added by auto-detect */
+#define Blocked		8		/* An error occured on an externally
+					 * managed array, don't allow writes
+					 * until it is cleared */
+	wait_queue_head_t blocked_wait;
 
 	int desc_nr;			/* descriptor index in the superblock */
 	int raid_disk;			/* role of device in array */
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch
md-fix-use-after-free-when-removing-rdev-via-sysfs.patch
md-remove-a-stray-command-from-a-copy-and-paste-error-in-resync_start_store.patch
md-prevent-duplicates-in-bind_rdev_to_array.patch
md-md-raid5-rate-limit-error-printk.patch
md-md-support-blocking-writes-to-an-array-on-device-failure.patch

