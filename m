From: akpm@linux-foundation.org
Subject: + aoe-remove-vestigial-request-queue-allocation.patch added to -mm tree
Date: Wed, 28 Nov 2012 15:42:18 -0800
Message-ID: <20121128234219.18F1982004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:61592 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab2K1XmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 18:42:19 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so582143ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 15:42:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: remove vestigial request queue allocation
has been added to the -mm tree.  Its filename is
     aoe-remove-vestigial-request-queue-allocation.patch

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
Subject: aoe: remove vestigial request queue allocation

Before the aoe driver was an I/O request handler, it was a
make_request-style block driver.  Even so, there was a problem where sysfs
expected a request queue to exist, so one was provided in commit
7135a71b19be1fa ("aoe: allocate unused request_queue for sysfs").

During the transition to the request-handler style, a patch was merged
that was based on a driver without the noop queue, and the noop queue
remained in place after the patch was merged, even though a new functional
queue was introduced by the patch, allocated through blk_init_queue.

The user impact is a memory leak proportional to the number of AoE targets
discovered.  This patch removes the memory leak and cleans up vestiges of
the old do-nothing queue from the aoeblk_gdalloc function.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoeblk.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN drivers/block/aoe/aoeblk.c~aoe-remove-vestigial-request-queue-allocation drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-remove-vestigial-request-queue-allocation
+++ a/drivers/block/aoe/aoeblk.c
@@ -278,18 +278,12 @@ aoeblk_gdalloc(void *vp)
 	if (q == NULL) {
 		pr_err("aoe: cannot allocate block queue for %ld.%d\n",
 			d->aoemajor, d->aoeminor);
-		mempool_destroy(mp);
-		goto err_disk;
+		goto err_mempool;
 	}
 
-	d->blkq = blk_alloc_queue(GFP_KERNEL);
-	if (!d->blkq)
-		goto err_mempool;
-	d->blkq->backing_dev_info.name = "aoe";
-	if (bdi_init(&d->blkq->backing_dev_info))
-		goto err_blkq;
 	spin_lock_irqsave(&d->lock, flags);
-	blk_queue_max_hw_sectors(d->blkq, BLK_DEF_MAX_SECTORS);
+	blk_queue_max_hw_sectors(q, BLK_DEF_MAX_SECTORS);
+	q->backing_dev_info.name = "aoe";
 	q->backing_dev_info.ra_pages = READ_AHEAD / PAGE_CACHE_SIZE;
 	d->bufpool = mp;
 	d->blkq = gd->queue = q;
@@ -314,11 +308,8 @@ aoeblk_gdalloc(void *vp)
 	aoedisk_add_sysfs(d);
 	return;
 
-err_blkq:
-	blk_cleanup_queue(d->blkq);
-	d->blkq = NULL;
 err_mempool:
-	mempool_destroy(d->bufpool);
+	mempool_destroy(mp);
 err_disk:
 	put_disk(gd);
 err:
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

