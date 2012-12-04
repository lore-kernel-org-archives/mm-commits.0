From: akpm@linux-foundation.org
Subject: + aoe-avoid-races-between-device-destruction-and-discovery.patch added to -mm tree
Date: Tue, 04 Dec 2012 15:48:41 -0800
Message-ID: <20121204234842.AB2CE20005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:61656 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2LDXsp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 18:48:45 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so322781eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 15:48:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, axboe@kernel.dk


The patch titled
     Subject: aoe: avoid races between device destruction and discovery
has been added to the -mm tree.  Its filename is
     aoe-avoid-races-between-device-destruction-and-discovery.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: avoid races between device destruction and discovery

This change avoids a race that could result in a NULL pointer derference
following a WARNing from kobject_add_internal, "don't try to register
things with the same name in the same directory."

The problem was found with a test that forgets and discovers an
aoe device in a loop:

  while test ! -r /tmp/stop; do
	aoe-flush -a
	aoe-discover
  done

The race was between aoedev_flush taking aoedevs out of the devlist,
allowing a new discovery of the same AoE target to take place before the
driver gets around to calling sysfs_remove_group.  Fixing that one
revealed another race between do_open and add_disk, and this patch avoids
that, too.

The fix required some care, because for flushing (forgetting) an aoedev,
some of the steps must be performed under lock and some must be able to
sleep.  Also, for discovering a new aoedev, some steps might sleep.

The check for a bad aoedev pointer remains from a time when about half of
this patch was done, and it was possible for the
bdev->bd_disk->private_data to become corrupted.  The check should be
removed eventually, but it is not expected to add significant overhead,
occurring in the aoeblk_open routine.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    7 +
 drivers/block/aoe/aoeblk.c |   36 +++++++
 drivers/block/aoe/aoedev.c |  166 ++++++++++++++++++++++-------------
 3 files changed, 146 insertions(+), 63 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-avoid-races-between-device-destruction-and-discovery drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-avoid-races-between-device-destruction-and-discovery
+++ a/drivers/block/aoe/aoe.h
@@ -74,8 +74,11 @@ enum {
 	DEVFL_TKILL = (1<<1),	/* flag for timer to know when to kill self */
 	DEVFL_EXT = (1<<2),	/* device accepts lba48 commands */
 	DEVFL_GDALLOC = (1<<3),	/* need to alloc gendisk */
-	DEVFL_KICKME = (1<<4),	/* slow polling network card catch */
-	DEVFL_NEWSIZE = (1<<5),	/* need to update dev size in block layer */
+	DEVFL_GD_NOW = (1<<4),	/* allocating gendisk */
+	DEVFL_KICKME = (1<<5),	/* slow polling network card catch */
+	DEVFL_NEWSIZE = (1<<6),	/* need to update dev size in block layer */
+	DEVFL_FREEING = (1<<7),	/* set when device is being cleaned up */
+	DEVFL_FREED = (1<<8),	/* device has been cleaned up */
 };
 
 enum {
diff -puN drivers/block/aoe/aoeblk.c~aoe-avoid-races-between-device-destruction-and-discovery drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-avoid-races-between-device-destruction-and-discovery
+++ a/drivers/block/aoe/aoeblk.c
@@ -147,9 +147,18 @@ aoeblk_open(struct block_device *bdev, f
 	struct aoedev *d = bdev->bd_disk->private_data;
 	ulong flags;
 
+	if (!virt_addr_valid(d)) {
+		pr_crit("aoe: invalid device pointer in %s\n",
+			__func__);
+		WARN_ON(1);
+		return -ENODEV;
+	}
+	if (!(d->flags & DEVFL_UP) || d->flags & DEVFL_TKILL)
+		return -ENODEV;
+
 	mutex_lock(&aoeblk_mutex);
 	spin_lock_irqsave(&d->lock, flags);
-	if (d->flags & DEVFL_UP) {
+	if (d->flags & DEVFL_UP && !(d->flags & DEVFL_TKILL)) {
 		d->nopen++;
 		spin_unlock_irqrestore(&d->lock, flags);
 		mutex_unlock(&aoeblk_mutex);
@@ -259,6 +268,18 @@ aoeblk_gdalloc(void *vp)
 	struct request_queue *q;
 	enum { KB = 1024, MB = KB * KB, READ_AHEAD = 2 * MB, };
 	ulong flags;
+	int late = 0;
+
+	spin_lock_irqsave(&d->lock, flags);
+	if (d->flags & DEVFL_GDALLOC
+	&& !(d->flags & DEVFL_TKILL)
+	&& !(d->flags & DEVFL_GD_NOW))
+		d->flags |= DEVFL_GD_NOW;
+	else
+		late = 1;
+	spin_unlock_irqrestore(&d->lock, flags);
+	if (late)
+		return;
 
 	gd = alloc_disk(AOE_PARTITIONS);
 	if (gd == NULL) {
@@ -282,6 +303,11 @@ aoeblk_gdalloc(void *vp)
 	}
 
 	spin_lock_irqsave(&d->lock, flags);
+	WARN_ON(!(d->flags & DEVFL_GD_NOW));
+	WARN_ON(!(d->flags & DEVFL_GDALLOC));
+	WARN_ON(d->flags & DEVFL_TKILL);
+	WARN_ON(d->gd);
+	WARN_ON(d->flags & DEVFL_UP);
 	blk_queue_max_hw_sectors(q, BLK_DEF_MAX_SECTORS);
 	q->backing_dev_info.name = "aoe";
 	q->backing_dev_info.ra_pages = READ_AHEAD / PAGE_CACHE_SIZE;
@@ -306,6 +332,11 @@ aoeblk_gdalloc(void *vp)
 
 	add_disk(gd);
 	aoedisk_add_sysfs(d);
+
+	spin_lock_irqsave(&d->lock, flags);
+	WARN_ON(!(d->flags & DEVFL_GD_NOW));
+	d->flags &= ~DEVFL_GD_NOW;
+	spin_unlock_irqrestore(&d->lock, flags);
 	return;
 
 err_mempool:
@@ -314,7 +345,8 @@ err_disk:
 	put_disk(gd);
 err:
 	spin_lock_irqsave(&d->lock, flags);
-	d->flags &= ~DEVFL_GDALLOC;
+	d->flags &= ~DEVFL_GD_NOW;
+	schedule_work(&d->work);
 	spin_unlock_irqrestore(&d->lock, flags);
 }
 
diff -puN drivers/block/aoe/aoedev.c~aoe-avoid-races-between-device-destruction-and-discovery drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-avoid-races-between-device-destruction-and-discovery
+++ a/drivers/block/aoe/aoedev.c
@@ -15,7 +15,6 @@
 #include "aoe.h"
 
 static void dummy_timer(ulong);
-static void aoedev_freedev(struct aoedev *);
 static void freetgt(struct aoedev *d, struct aoetgt *t);
 static void skbpoolfree(struct aoedev *d);
 
@@ -236,29 +235,6 @@ aoedev_downdev(struct aoedev *d)
 		set_capacity(d->gd, 0);
 }
 
-static void
-aoedev_freedev(struct aoedev *d)
-{
-	struct aoetgt **t, **e;
-
-	cancel_work_sync(&d->work);
-	if (d->gd) {
-		aoedisk_rm_sysfs(d);
-		del_gendisk(d->gd);
-		put_disk(d->gd);
-		blk_cleanup_queue(d->blkq);
-	}
-	t = d->targets;
-	e = t + NTARGETS;
-	for (; t < e && *t; t++)
-		freetgt(d, *t);
-	if (d->bufpool)
-		mempool_destroy(d->bufpool);
-	skbpoolfree(d);
-	minor_free(d->sysminor);
-	kfree(d);
-}
-
 /* return whether the user asked for this particular
  * device to be flushed
  */
@@ -283,17 +259,62 @@ user_req(char *s, size_t slen, struct ao
 	return !strncmp(s, p, lim);
 }
 
-int
-aoedev_flush(const char __user *str, size_t cnt)
+static void
+freedev(struct aoedev *d)
+{
+	struct aoetgt **t, **e;
+	int freeing = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&d->lock, flags);
+	if (d->flags & DEVFL_TKILL
+	&& !(d->flags & DEVFL_FREEING)) {
+		d->flags |= DEVFL_FREEING;
+		freeing = 1;
+	}
+	spin_unlock_irqrestore(&d->lock, flags);
+	if (!freeing)
+		return;
+
+	del_timer_sync(&d->timer);
+	if (d->gd) {
+		aoedisk_rm_sysfs(d);
+		del_gendisk(d->gd);
+		put_disk(d->gd);
+		blk_cleanup_queue(d->blkq);
+	}
+	t = d->targets;
+	e = t + NTARGETS;
+	for (; t < e && *t; t++)
+		freetgt(d, *t);
+	if (d->bufpool)
+		mempool_destroy(d->bufpool);
+	skbpoolfree(d);
+	minor_free(d->sysminor);
+
+	spin_lock_irqsave(&d->lock, flags);
+	d->flags |= DEVFL_FREED;
+	spin_unlock_irqrestore(&d->lock, flags);
+}
+
+enum flush_parms {
+	NOT_EXITING = 0,
+	EXITING = 1,
+};
+
+static int
+flush(const char __user *str, size_t cnt, int exiting)
 {
 	ulong flags;
 	struct aoedev *d, **dd;
-	struct aoedev *rmd = NULL;
 	char buf[16];
 	int all = 0;
 	int specified = 0;	/* flush a specific device */
+	unsigned int skipflags;
 
-	if (cnt >= 3) {
+	skipflags = DEVFL_GDALLOC | DEVFL_NEWSIZE | DEVFL_TKILL;
+
+	if (!exiting && cnt >= 3) {
 		if (cnt > sizeof buf)
 			cnt = sizeof buf;
 		if (copy_from_user(buf, str, cnt))
@@ -303,39 +324,71 @@ aoedev_flush(const char __user *str, siz
 			specified = 1;
 	}
 
+	flush_scheduled_work();
+	/* pass one: without sleeping, do aoedev_downdev */
 	spin_lock_irqsave(&devlist_lock, flags);
-	dd = &devlist;
-	while ((d = *dd)) {
+	for (d = devlist; d; d = d->next) {
 		spin_lock(&d->lock);
-		if (specified) {
+		if (exiting) {
+			/* unconditionally take each device down */
+		} else if (specified) {
 			if (!user_req(buf, cnt, d))
-				goto skip;
+				goto cont;
 		} else if ((!all && (d->flags & DEVFL_UP))
-		|| (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
+		|| d->flags & skipflags
 		|| d->nopen
 		|| d->ref)
-			goto skip;
+			goto cont;
 
-		*dd = d->next;
 		aoedev_downdev(d);
 		d->flags |= DEVFL_TKILL;
+cont:
 		spin_unlock(&d->lock);
-		d->next = rmd;
-		rmd = d;
-		continue;
-skip:
-		spin_unlock(&d->lock);
-		dd = &d->next;
 	}
 	spin_unlock_irqrestore(&devlist_lock, flags);
-	while ((d = rmd)) {
-		rmd = d->next;
-		del_timer_sync(&d->timer);
-		aoedev_freedev(d);	/* must be able to sleep */
+
+	/* pass two: call freedev, which might sleep,
+	 * for aoedevs marked with DEVFL_TKILL
+	 */
+restart:
+	spin_lock_irqsave(&devlist_lock, flags);
+	for (d = devlist; d; d = d->next) {
+		spin_lock(&d->lock);
+		if (d->flags & DEVFL_TKILL
+		&& !(d->flags & DEVFL_FREEING)) {
+			spin_unlock(&d->lock);
+			spin_unlock_irqrestore(&devlist_lock, flags);
+			freedev(d);
+			goto restart;
+		}
+		spin_unlock(&d->lock);
+	}
+
+	/* pass three: remove aoedevs marked with DEVFL_FREED */
+	for (dd = &devlist, d = *dd; d; d = *dd) {
+		struct aoedev *doomed = NULL;
+
+		spin_lock(&d->lock);
+		if (d->flags & DEVFL_FREED) {
+			*dd = d->next;
+			doomed = d;
+		} else {
+			dd = &d->next;
+		}
+		spin_unlock(&d->lock);
+		kfree(doomed);
 	}
+	spin_unlock_irqrestore(&devlist_lock, flags);
+
 	return 0;
 }
 
+int
+aoedev_flush(const char __user *str, size_t cnt)
+{
+	return flush(str, cnt, NOT_EXITING);
+}
+
 /* This has been confirmed to occur once with Tms=3*1000 due to the
  * driver changing link and not processing its transmit ring.  The
  * problem is hard enough to solve by returning an error that I'm
@@ -388,7 +441,14 @@ aoedev_by_aoeaddr(ulong maj, int min, in
 
 	for (d=devlist; d; d=d->next)
 		if (d->aoemajor == maj && d->aoeminor == min) {
+			spin_lock(&d->lock);
+			if (d->flags & DEVFL_TKILL) {
+				spin_unlock(&d->lock);
+				d = NULL;
+				goto out;
+			}
 			d->ref++;
+			spin_unlock(&d->lock);
 			break;
 		}
 	if (d || !do_alloc || minor_get(&sysminor, maj, min) < 0)
@@ -448,21 +508,9 @@ freetgt(struct aoedev *d, struct aoetgt 
 void
 aoedev_exit(void)
 {
-	struct aoedev *d;
-	ulong flags;
-
+	flush_scheduled_work();
 	aoe_flush_iocq();
-	while ((d = devlist)) {
-		devlist = d->next;
-
-		spin_lock_irqsave(&d->lock, flags);
-		aoedev_downdev(d);
-		d->flags |= DEVFL_TKILL;
-		spin_unlock_irqrestore(&d->lock, flags);
-
-		del_timer_sync(&d->timer);
-		aoedev_freedev(d);
-	}
+	flush(NULL, 0, EXITING);
 }
 
 int __init
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-next.patch
linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
documentation-sparsetxt-document-context-annotations-for-lock-checking.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-v2.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits-fix.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch
aoe-provide-ata-identify-device-content-to-user-on-request.patch
aoe-improve-network-congestion-handling.patch
aoe-err-device-include-mac-addresses-for-unexpected-responses.patch
aoe-manipulate-aoedev-network-stats-under-lock.patch
aoe-use-high-resolution-rtts-with-fallback-to-low-res.patch
aoe-commands-in-retransmit-queue-use-new-destination-on-failure.patch
aoe-update-driver-internal-version-to-64.patch
aoe-copy-fallback-timing-information-on-destination-failover.patch
aoe-remove-vestigial-request-queue-allocation.patch
aoe-increase-default-cap-on-outstanding-aoe-commands-in-the-network.patch
aoe-cleanup-correct-comment-for-aoetgt-nout.patch
aoe-remove-call-to-request-handler-from-i-o-completion.patch
aoe-make-error-messages-more-specific-in-static-minor-allocation.patch
aoe-initialize-sysminor-to-avoid-compiler-warning.patch
aoe-return-real-minor-number-for-static-minors.patch
aoe-improve-handling-of-misbehaving-network-paths.patch
aoe-avoid-races-between-device-destruction-and-discovery.patch
aoe-use-dynamic-number-of-remote-ports-for-aoe-storage-target.patch
aoe-allow-user-to-disable-target-failure-timeout.patch
aoe-allow-comma-separator-in-aoe_iflist-value.patch
aoe-identify-source-of-runt-aoe-packets.patch
aoe-update-internal-version-number-to-81.patch

