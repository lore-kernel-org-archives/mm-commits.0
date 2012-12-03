From: akpm@linux-foundation.org
Subject: [merged] loop-limit-the-number-of-requests-in-the-bio-list.patch removed from -mm tree
Date: Mon, 03 Dec 2012 14:01:50 -0800
Message-ID: <20121203220150.CE553100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:59477 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2LCWBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2012 17:01:52 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so407010ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 03 Dec 2012 14:01:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lczerner@redhat.com, a.p.zijlstra@chello.nl, axboe@kernel.dk, david@fromorbit.com, dhowells@redhat.com, jmoyer@redhat.com, mingo@elte.hu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: loop: limit the number of requests in the bio list
has been removed from the -mm tree.  Its filename was
     loop-limit-the-number-of-requests-in-the-bio-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lukas Czerner <lczerner@redhat.com>
Subject: loop: limit the number of requests in the bio list

Currently there is no limit on the number of requests in the loop bio
list.  This can lead into some nasty situations when the caller spawns
tons of bio requests taking huge amount of memory.  This is even more
obvious with discard where blkdev_issue_discard() will submit all bios for
the range and wait for them to finish afterwards.  On really big loop
devices and slow backing file system this can lead to OOM situation as
reported by Dave Chinner.

With this patch we will wait in loop_make_request() if the number of bios
in the loop bio list would exceed 'nr_congestion_on'.  We'll wake up the
process as we process the bios form the list.  Some threshold hysteresis
is in place to avoid high frequency oscillation.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Dave Chinner <david@fromorbit.com>
Cc: Neil Brown <neilb@suse.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jens Axboe <axboe@kernel.dk>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |   10 ++++++++++
 include/linux/loop.h |    3 +++
 2 files changed, 13 insertions(+)

diff -puN drivers/block/loop.c~loop-limit-the-number-of-requests-in-the-bio-list drivers/block/loop.c
--- a/drivers/block/loop.c~loop-limit-the-number-of-requests-in-the-bio-list
+++ a/drivers/block/loop.c
@@ -463,6 +463,7 @@ out:
  */
 static void loop_add_bio(struct loop_device *lo, struct bio *bio)
 {
+	lo->lo_bio_count++;
 	bio_list_add(&lo->lo_bio_list, bio);
 }
 
@@ -471,6 +472,7 @@ static void loop_add_bio(struct loop_dev
  */
 static struct bio *loop_get_bio(struct loop_device *lo)
 {
+	lo->lo_bio_count--;
 	return bio_list_pop(&lo->lo_bio_list);
 }
 
@@ -489,6 +491,10 @@ static void loop_make_request(struct req
 		goto out;
 	if (unlikely(rw == WRITE && (lo->lo_flags & LO_FLAGS_READ_ONLY)))
 		goto out;
+	if (lo->lo_bio_count >= q->nr_congestion_on)
+		wait_event_lock_irq(lo->lo_req_wait,
+				    lo->lo_bio_count < q->nr_congestion_off,
+				    lo->lo_lock);
 	loop_add_bio(lo, old_bio);
 	wake_up(&lo->lo_event);
 	spin_unlock_irq(&lo->lo_lock);
@@ -546,6 +552,8 @@ static int loop_thread(void *data)
 			continue;
 		spin_lock_irq(&lo->lo_lock);
 		bio = loop_get_bio(lo);
+		if (lo->lo_bio_count < lo->lo_queue->nr_congestion_off)
+			wake_up(&lo->lo_req_wait);
 		spin_unlock_irq(&lo->lo_lock);
 
 		BUG_ON(!bio);
@@ -873,6 +881,7 @@ static int loop_set_fd(struct loop_devic
 	lo->transfer = transfer_none;
 	lo->ioctl = NULL;
 	lo->lo_sizelimit = 0;
+	lo->lo_bio_count = 0;
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 
@@ -1673,6 +1682,7 @@ static int loop_add(struct loop_device *
 	lo->lo_number		= i;
 	lo->lo_thread		= NULL;
 	init_waitqueue_head(&lo->lo_event);
+	init_waitqueue_head(&lo->lo_req_wait);
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
 	disk->first_minor	= i << part_shift;
diff -puN include/linux/loop.h~loop-limit-the-number-of-requests-in-the-bio-list include/linux/loop.h
--- a/include/linux/loop.h~loop-limit-the-number-of-requests-in-the-bio-list
+++ a/include/linux/loop.h
@@ -53,10 +53,13 @@ struct loop_device {
 
 	spinlock_t		lo_lock;
 	struct bio_list		lo_bio_list;
+	unsigned int		lo_bio_count;
 	int			lo_state;
 	struct mutex		lo_ctl_mutex;
 	struct task_struct	*lo_thread;
 	wait_queue_head_t	lo_event;
+	/* wait queue for incoming requests */
+	wait_queue_head_t	lo_req_wait;
 
 	struct request_queue	*lo_queue;
 	struct gendisk		*lo_disk;
_

Patches currently in -mm which might be from lczerner@redhat.com are

linux-next.patch

