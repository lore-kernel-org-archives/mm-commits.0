From: akpm@linux-foundation.org
Subject: - md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:20 -0800
Message-ID: <200803050746.m257kKhZ021763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764506AbYCEHq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, k-tanaka@ce.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     md: fix deadlock in md/raid1 and md/raid10 when handling a read error
has been removed from the -mm tree.  Its filename was
     md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix deadlock in md/raid1 and md/raid10 when handling a read error
From: NeilBrown <neilb@suse.de>

When handling a read error, we freeze the array to stop any other IO while
attempting to over-write with correct data.

This is done in the raid1d(raid10d) thread and must wait for all submitted IO
to complete (except for requests that failed and are sitting in the retry
queue - these are counted in ->nr_queue and will stay there during a freeze).

However write requests need attention from raid1d as bitmap updates might be
required.  This can cause a deadlock as raid1 is waiting for requests to
finish that themselves need attention from raid1d.

So we create a new function 'flush_pending_writes' to give that attention, and
call it in freeze_array to be sure that we aren't waiting on raid1d.

Thanks to "K.Tanaka" <k-tanaka@ce.jp.nec.com> for finding and reporting this
problem.

Cc: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/raid1.c  |   62 +++++++++++++++++++++++++++---------------
 drivers/md/raid10.c |   60 ++++++++++++++++++++++++++--------------
 2 files changed, 80 insertions(+), 42 deletions(-)

diff -puN drivers/md/raid1.c~md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error
+++ a/drivers/md/raid1.c
@@ -592,6 +592,37 @@ static int raid1_congested(void *data, i
 }
 
 
+static int flush_pending_writes(conf_t *conf)
+{
+	/* Any writes that have been queued but are awaiting
+	 * bitmap updates get flushed here.
+	 * We return 1 if any requests were actually submitted.
+	 */
+	int rv = 0;
+
+	spin_lock_irq(&conf->device_lock);
+
+	if (conf->pending_bio_list.head) {
+		struct bio *bio;
+		bio = bio_list_get(&conf->pending_bio_list);
+		blk_remove_plug(conf->mddev->queue);
+		spin_unlock_irq(&conf->device_lock);
+		/* flush any pending bitmap writes to
+		 * disk before proceeding w/ I/O */
+		bitmap_unplug(conf->mddev->bitmap);
+
+		while (bio) { /* submit pending writes */
+			struct bio *next = bio->bi_next;
+			bio->bi_next = NULL;
+			generic_make_request(bio);
+			bio = next;
+		}
+		rv = 1;
+	} else
+		spin_unlock_irq(&conf->device_lock);
+	return rv;
+}
+
 /* Barriers....
  * Sometimes we need to suspend IO while we do something else,
  * either some resync/recovery, or reconfigure the array.
@@ -681,7 +712,8 @@ static void freeze_array(conf_t *conf)
 	wait_event_lock_irq(conf->wait_barrier,
 			    conf->barrier+conf->nr_pending == conf->nr_queued+2,
 			    conf->resync_lock,
-			    raid1_unplug(conf->mddev->queue));
+			    ({ flush_pending_writes(conf);
+			       raid1_unplug(conf->mddev->queue); }));
 	spin_unlock_irq(&conf->resync_lock);
 }
 static void unfreeze_array(conf_t *conf)
@@ -907,6 +939,9 @@ static int make_request(struct request_q
 	blk_plug_device(mddev->queue);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
+	/* In case raid1d snuck into freeze_array */
+	wake_up(&conf->wait_barrier);
+
 	if (do_sync)
 		md_wakeup_thread(mddev->thread);
 #if 0
@@ -1473,28 +1508,14 @@ static void raid1d(mddev_t *mddev)
 	
 	for (;;) {
 		char b[BDEVNAME_SIZE];
-		spin_lock_irqsave(&conf->device_lock, flags);
 
-		if (conf->pending_bio_list.head) {
-			bio = bio_list_get(&conf->pending_bio_list);
-			blk_remove_plug(mddev->queue);
-			spin_unlock_irqrestore(&conf->device_lock, flags);
-			/* flush any pending bitmap writes to disk before proceeding w/ I/O */
-			bitmap_unplug(mddev->bitmap);
-
-			while (bio) { /* submit pending writes */
-				struct bio *next = bio->bi_next;
-				bio->bi_next = NULL;
-				generic_make_request(bio);
-				bio = next;
-			}
-			unplug = 1;
-
-			continue;
-		}
+		unplug += flush_pending_writes(conf);
 
-		if (list_empty(head))
+		spin_lock_irqsave(&conf->device_lock, flags);
+		if (list_empty(head)) {
+			spin_unlock_irqrestore(&conf->device_lock, flags);
 			break;
+		}
 		r1_bio = list_entry(head->prev, r1bio_t, retry_list);
 		list_del(head->prev);
 		conf->nr_queued--;
@@ -1590,7 +1611,6 @@ static void raid1d(mddev_t *mddev)
 			}
 		}
 	}
-	spin_unlock_irqrestore(&conf->device_lock, flags);
 	if (unplug)
 		unplug_slaves(mddev);
 }
diff -puN drivers/md/raid10.c~md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-fix-deadlock-in-md-raid1-and-md-raid10-when-handling-a-read-error
+++ a/drivers/md/raid10.c
@@ -629,7 +629,36 @@ static int raid10_congested(void *data, 
 	return ret;
 }
 
+static int flush_pending_writes(conf_t *conf)
+{
+	/* Any writes that have been queued but are awaiting
+	 * bitmap updates get flushed here.
+	 * We return 1 if any requests were actually submitted.
+	 */
+	int rv = 0;
+
+	spin_lock_irq(&conf->device_lock);
 
+	if (conf->pending_bio_list.head) {
+		struct bio *bio;
+		bio = bio_list_get(&conf->pending_bio_list);
+		blk_remove_plug(conf->mddev->queue);
+		spin_unlock_irq(&conf->device_lock);
+		/* flush any pending bitmap writes to disk
+		 * before proceeding w/ I/O */
+		bitmap_unplug(conf->mddev->bitmap);
+
+		while (bio) { /* submit pending writes */
+			struct bio *next = bio->bi_next;
+			bio->bi_next = NULL;
+			generic_make_request(bio);
+			bio = next;
+		}
+		rv = 1;
+	} else
+		spin_unlock_irq(&conf->device_lock);
+	return rv;
+}
 /* Barriers....
  * Sometimes we need to suspend IO while we do something else,
  * either some resync/recovery, or reconfigure the array.
@@ -720,7 +749,8 @@ static void freeze_array(conf_t *conf)
 	wait_event_lock_irq(conf->wait_barrier,
 			    conf->barrier+conf->nr_pending == conf->nr_queued+2,
 			    conf->resync_lock,
-			    raid10_unplug(conf->mddev->queue));
+			    ({ flush_pending_writes(conf);
+			       raid10_unplug(conf->mddev->queue); }));
 	spin_unlock_irq(&conf->resync_lock);
 }
 
@@ -892,6 +922,9 @@ static int make_request(struct request_q
 	blk_plug_device(mddev->queue);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
+	/* In case raid10d snuck in to freeze_array */
+	wake_up(&conf->wait_barrier);
+
 	if (do_sync)
 		md_wakeup_thread(mddev->thread);
 
@@ -1464,28 +1497,14 @@ static void raid10d(mddev_t *mddev)
 
 	for (;;) {
 		char b[BDEVNAME_SIZE];
-		spin_lock_irqsave(&conf->device_lock, flags);
-
-		if (conf->pending_bio_list.head) {
-			bio = bio_list_get(&conf->pending_bio_list);
-			blk_remove_plug(mddev->queue);
-			spin_unlock_irqrestore(&conf->device_lock, flags);
-			/* flush any pending bitmap writes to disk before proceeding w/ I/O */
-			bitmap_unplug(mddev->bitmap);
 
-			while (bio) { /* submit pending writes */
-				struct bio *next = bio->bi_next;
-				bio->bi_next = NULL;
-				generic_make_request(bio);
-				bio = next;
-			}
-			unplug = 1;
+		unplug += flush_pending_writes(conf);
 
-			continue;
-		}
