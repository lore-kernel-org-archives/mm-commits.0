From: akpm@linux-foundation.org
Subject: + aoe-ensure-we-initialise-the-request_queue-correctly.patch added to -mm tree
Date: Wed, 02 Sep 2009 12:55:46 -0700
Message-ID: <200909021955.n82JtkrI032267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbZIBT4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 15:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, bonbons@linux-vserver.org, ecashin@coraid.com, jens.axboe@oracle.com, martin.petersen@oracle.com, rjw@sisk.pl


The patch titled
     aoe: ensure we initialise the request_queue correctly
has been added to the -mm tree.  Its filename is
     aoe-ensure-we-initialise-the-request_queue-correctly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: ensure we initialise the request_queue correctly
From: Andy Whitcroft <apw@canonical.com>

When using the aoe driver we see an oops triggered by use of an
incorrectly initialised request_queue object:

  [ 2645.959090] kobject '<NULL>' (ffff880059ca22c0): tried to add
		an uninitialized object, something is seriously wrong.
  [ 2645.959104] Pid: 6, comm: events/0 Not tainted 2.6.31-5-generic #24-Ubuntu
  [ 2645.959107] Call Trace:
  [ 2645.959139] [<ffffffff8126ca2f>] kobject_add+0x5f/0x70
  [ 2645.959151] [<ffffffff8125b4ab>] blk_register_queue+0x8b/0xf0
  [ 2645.959155] [<ffffffff8126043f>] add_disk+0x8f/0x160
  [ 2645.959161] [<ffffffffa01673c4>] aoeblk_gdalloc+0x164/0x1c0 [aoe]

It seems this driver mearly embeds a request_queue object in its main
control structure and does not attempt to initialise it.  Pull this out
and use blk_init_queue/blk_cleanup_queue to handle initialisation and
teardown of this object.

Bruno bisected this regression down to

  cd43e26f071524647e660706b784ebcbefbd2e44

  block: Expose stacked device queues in sysfs

"This seems to generate /sys/block/$device/queue and its contents for
 everyone who is using queues, not just for those queues that have a
 non-NULL queue->request_fn."

Addresses http://bugs.launchpad.net/bugs/410198
Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13942

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Acked-by: Ed Cashin <ecashin@coraid.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bruno Premont <bonbons@linux-vserver.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoeblk.c |    6 +++---
 drivers/block/aoe/aoedev.c |   11 ++++++++++-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-ensure-we-initialise-the-request_queue-correctly drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-ensure-we-initialise-the-request_queue-correctly
+++ a/drivers/block/aoe/aoe.h
@@ -155,7 +155,7 @@ struct aoedev {
 	u16 fw_ver;		/* version of blade's firmware */
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
-	struct request_queue blkq;
+	struct request_queue *blkq;
 	struct hd_geometry geo; 
 	sector_t ssize;
 	struct timer_list timer;
diff -puN drivers/block/aoe/aoeblk.c~aoe-ensure-we-initialise-the-request_queue-correctly drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-ensure-we-initialise-the-request_queue-correctly
+++ a/drivers/block/aoe/aoeblk.c
@@ -264,8 +264,8 @@ aoeblk_gdalloc(void *vp)
 		goto err_disk;
 	}
 
-	blk_queue_make_request(&d->blkq, aoeblk_make_request);
-	if (bdi_init(&d->blkq.backing_dev_info))
+	blk_queue_make_request(d->blkq, aoeblk_make_request);
+	if (bdi_init(&d->blkq->backing_dev_info))
 		goto err_mempool;
 	spin_lock_irqsave(&d->lock, flags);
 	gd->major = AOE_MAJOR;
@@ -276,7 +276,7 @@ aoeblk_gdalloc(void *vp)
 	snprintf(gd->disk_name, sizeof gd->disk_name, "etherd/e%ld.%d",
 		d->aoemajor, d->aoeminor);
 
-	gd->queue = &d->blkq;
+	gd->queue = d->blkq;
 	d->gd = gd;
 	d->flags &= ~DEVFL_GDALLOC;
 	d->flags |= DEVFL_UP;
diff -puN drivers/block/aoe/aoedev.c~aoe-ensure-we-initialise-the-request_queue-correctly drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-ensure-we-initialise-the-request_queue-correctly
+++ a/drivers/block/aoe/aoedev.c
@@ -113,6 +113,7 @@ aoedev_freedev(struct aoedev *d)
 	if (d->bufpool)
 		mempool_destroy(d->bufpool);
 	skbpoolfree(d);
+	blk_cleanup_queue(d->blkq);
 	kfree(d);
 }
 
@@ -202,6 +203,7 @@ aoedev_by_sysminor_m(ulong sysminor)
 {
 	struct aoedev *d;
 	ulong flags;
+	struct request_queue *rq;
 
 	spin_lock_irqsave(&devlist_lock, flags);
 
@@ -210,9 +212,13 @@ aoedev_by_sysminor_m(ulong sysminor)
 			break;
 	if (d)
 		goto out;
+	rq = blk_init_queue(NULL, NULL);
+	if (!rq)
+		goto out;
 	d = kcalloc(1, sizeof *d, GFP_ATOMIC);
 	if (!d)
-		goto out;
+		goto out_rq;
+	d->blkq = rq;
 	INIT_WORK(&d->work, aoecmd_sleepwork);
 	spin_lock_init(&d->lock);
 	skb_queue_head_init(&d->sendq);
@@ -234,6 +240,9 @@ aoedev_by_sysminor_m(ulong sysminor)
  out:
 	spin_unlock_irqrestore(&devlist_lock, flags);
 	return d;
+ out_rq:
+	blk_cleanup_queue(rq);
+	goto out;
 }
 
 static void
_

Patches currently in -mm which might be from apw@canonical.com are

aoe-ensure-we-initialise-the-request_queue-correctly.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
checkpatch-possible-types-else-cannot-start-a-type.patch
checkpatch-handle-c99-comments-correctly-performance-issue.patch
checkpatch-indent-checks-stop-when-we-run-out-of-continuation-lines.patch
checkpatch-make-f-alias-file-add-help-more-verbose-help-message.patch
checkpatch-format-strings-should-not-have-brackets-in-macros.patch
checkpatch-limit-sn-un-matches-to-actual-bit-sizes.patch
checkpatch-version-029.patch

