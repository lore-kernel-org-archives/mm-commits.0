From: akpm@linux-foundation.org
Subject: + block-prevent-race-cleanup.patch added to -mm tree
Date: Mon, 03 Dec 2012 16:22:59 -0800
Message-ID: <20121204002300.2C1DC82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56317 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2LDAXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2012 19:23:01 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so44886qaq.1
        for <mm-commits@vger.kernel.org>; Mon, 03 Dec 2012 16:23:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbasehore@chromium.org, axboe@kernel.dk, msb@chromium.org


The patch titled
     Subject: block: prevent race/cleanup
has been added to the -mm tree.  Its filename is
     block-prevent-race-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Derek Basehore <dbasehore@chromium.org>
Subject: block: prevent race/cleanup

Remove a race condition which causes a warning in disk_clear_events.  This
is a race between disk_clear_events() and disk_flush_events(). 
ev->clearing will be altered by disk_flush_events() even though we are
blocking event checking through disk_flush_events().  If this happens
after ev->clearing was cleared for disk_clear_events(), this can cause the
WARN_ON_ONCE() in that function to be triggered.

This change also has disk_clear_events() not go through a workqueue. 
Since we have to wait for the work to complete, we should just call the
function directly.  Also, since this work cannot be put on a freezable
workqueue, it will have to contend with increased demand, so calling the
function directly avoids this.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |   45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff -puN block/genhd.c~block-prevent-race-cleanup block/genhd.c
--- a/block/genhd.c~block-prevent-race-cleanup
+++ a/block/genhd.c
@@ -35,6 +35,8 @@ static DEFINE_IDR(ext_devt_idr);
 
 static struct device_type disk_type;
 
+static void disk_check_events(struct disk_events *ev,
+			      unsigned int *clearing_ptr);
 static void disk_alloc_events(struct gendisk *disk);
 static void disk_add_events(struct gendisk *disk);
 static void disk_del_events(struct gendisk *disk);
@@ -1549,6 +1551,7 @@ unsigned int disk_clear_events(struct ge
 	const struct block_device_operations *bdops = disk->fops;
 	struct disk_events *ev = disk->ev;
 	unsigned int pending;
+	unsigned int clearing = mask;
 
 	if (!ev) {
 		/* for drivers still using the old ->media_changed method */
@@ -1558,41 +1561,53 @@ unsigned int disk_clear_events(struct ge
 		return 0;
 	}
 
-	/* tell the workfn about the events being cleared */
+	disk_block_events(disk);
+
+	/*
+	 * store the union of mask and ev->clearing on the stack so that the
+	 * race with disk_flush_events does not cause ambiguity (ev->clearing
+	 * can still be modified even if events are blocked).
+	 */
 	spin_lock_irq(&ev->lock);
-	ev->clearing |= mask;
+	clearing |= ev->clearing;
+	ev->clearing = 0;
 	spin_unlock_irq(&ev->lock);
 
-	/* uncondtionally schedule event check and wait for it to finish */
-	disk_block_events(disk);
+	disk_check_events(ev, &clearing);
 	/*
-	 * We need to put the work on system_nrt_wq here since there is a
-	 * deadlock that happens while probing a usb device while suspending. If
-	 * we put work on a freezable workqueue here, a usb probe will wait here
-	 * until the workqueue is unfrozen during suspend. Since suspend waits
-	 * on all probes to complete, we have a deadlock
+	 * if ev->clearing is not 0, the disk_flush_events got called in the
+	 * middle of this function, so we want to run the workfn without delay.
 	 */
-	queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
-	flush_delayed_work(&ev->dwork);
-	__disk_unblock_events(disk, false);
+	__disk_unblock_events(disk, ev->clearing ? true : false);
 
 	/* then, fetch and clear pending events */
 	spin_lock_irq(&ev->lock);
-	WARN_ON_ONCE(ev->clearing & mask);	/* cleared by workfn */
 	pending = ev->pending & mask;
 	ev->pending &= ~mask;
 	spin_unlock_irq(&ev->lock);
+	WARN_ON_ONCE(clearing & mask);
 
 	return pending;
 }
 
+/*
+ * Seperate this part out so that a different pointer for clearing_ptr can be
+ * passed in for disk_clear_events.
+ */
 static void disk_events_workfn(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct disk_events *ev = container_of(dwork, struct disk_events, dwork);
+
+	disk_check_events(ev, &ev->clearing);
+}
+
+static void disk_check_events(struct disk_events *ev,
+			      unsigned int *clearing_ptr)
+{
 	struct gendisk *disk = ev->disk;
 	char *envp[ARRAY_SIZE(disk_uevents) + 1] = { };
-	unsigned int clearing = ev->clearing;
+	unsigned int clearing = *clearing_ptr;
 	unsigned int events;
 	unsigned long intv;
 	int nr_events = 0, i;
@@ -1605,7 +1620,7 @@ static void disk_events_workfn(struct wo
 
 	events &= ~ev->pending;
 	ev->pending |= events;
-	ev->clearing &= ~clearing;
+	*clearing_ptr &= ~clearing;
 
 	intv = disk_events_poll_jiffies(disk);
 	if (!ev->block && intv)
_

Patches currently in -mm which might be from dbasehore@chromium.org are

linux-next.patch
block-remove-deadlock-in-disk_clear_events.patch
block-remove-deadlock-in-disk_clear_events-fix.patch
block-prevent-race-cleanup.patch
block-prevent-race-cleanup-fix.patch

