Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3447DC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18D6661038
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhJSSlB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234526AbhJSSlB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE217610E5;
        Tue, 19 Oct 2021 18:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668728;
        bh=zUxOUIhc43TmNJ6JjeWAjlh3LYw4564DoLYn1IqZ7JQ=;
        h=Date:From:To:Subject:From;
        b=Kb8SJVjFVEHla2j1SycjmfY7oWwpfkDzz3uCQWeTeg2+e3PsdZroF22vzrGshYc8h
         OHHI8Ak86mNu8qZcJ0GW7Lh+z4TNTDaeWDvJaIVVycujeTj2206aX+A/Eq8/yFfxu4
         CcxrXXYEWL0QOkzkc5UXi//yG5dmSekYq+JIwx6A=
Date:   Tue, 19 Oct 2021 11:38:47 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20211019183847.fkBFZ7DP0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c                    |   32 --------------------------
 drivers/iio/accel/fxls8962af-core.c |    3 --
 drivers/iio/adc/aspeed_adc.c        |    3 --
 3 files changed, 38 deletions(-)

--- a/block/blk-core.c~linux-next-git-rejects
+++ a/block/blk-core.c
@@ -50,11 +50,8 @@
 #include "blk-mq.h"
 #include "blk-mq-sched.h"
 #include "blk-pm.h"
-<<<<<<< HEAD
-=======
 #include "blk-rq-qos.h"
 #include "blk-throttle.h"
->>>>>>> linux-next/akpm-base
 
 struct dentry *blk_debugfs_root;
 
@@ -476,14 +473,8 @@ int blk_queue_enter(struct request_queue
 
 static inline int bio_queue_enter(struct bio *bio)
 {
-<<<<<<< HEAD
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
-	struct request_queue *q = disk->queue;
-=======
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	bool nowait = bio->bi_opf & REQ_NOWAIT;
-	int ret;
->>>>>>> linux-next/akpm-base
 
 	while (!blk_try_enter_queue(q, false)) {
 		if (bio->bi_opf & REQ_NOWAIT) {
@@ -929,27 +920,15 @@ static void __submit_bio(struct bio *bio
 {
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
 
-<<<<<<< HEAD
-	if (unlikely(bio_queue_enter(bio) != 0))
-		return BLK_QC_T_NONE;
-
-	if (!submit_bio_checks(bio) || !blk_crypto_bio_prep(&bio))
-		goto queue_exit;
-	if (disk->fops->submit_bio) {
-		ret = disk->fops->submit_bio(bio);
-		goto queue_exit;
-=======
 	if (blk_crypto_bio_prep(&bio)) {
 		if (!disk->fops->submit_bio) {
 			blk_mq_submit_bio(bio);
 			return;
 		}
 		disk->fops->submit_bio(bio);
->>>>>>> linux-next/akpm-base
 	}
 	return blk_mq_submit_bio(bio);
 
-queue_exit:
 	blk_queue_exit(disk->queue);
 }
 
@@ -1019,17 +998,10 @@ static void __submit_bio_noacct(struct b
 static void __submit_bio_noacct_mq(struct bio *bio)
 {
 	struct bio_list bio_list[2] = { };
-<<<<<<< HEAD
-	blk_qc_t ret;
-=======
->>>>>>> linux-next/akpm-base
 
 	current->bio_list = bio_list;
 
 	do {
-<<<<<<< HEAD
-		ret = __submit_bio(bio);
-=======
 		struct gendisk *disk = bio->bi_bdev->bd_disk;
 
 		if (unlikely(bio_queue_enter(bio) != 0))
@@ -1041,7 +1013,6 @@ static void __submit_bio_noacct_mq(struc
 		}
 
 		blk_mq_submit_bio(bio);
->>>>>>> linux-next/akpm-base
 	} while ((bio = bio_list_pop(&bio_list[0])));
 
 	current->bio_list = NULL;
@@ -1058,12 +1029,9 @@ static void __submit_bio_noacct_mq(struc
  */
 void submit_bio_noacct(struct bio *bio)
 {
-<<<<<<< HEAD
-=======
 	if (!submit_bio_checks(bio))
 		return;
 
->>>>>>> linux-next/akpm-base
 	/*
 	 * We only want one ->submit_bio to be active at a time, else stack
 	 * usage with stacked devices could be a problem.  Use current->bio_list
--- a/drivers/iio/accel/fxls8962af-core.c~linux-next-git-rejects
+++ a/drivers/iio/accel/fxls8962af-core.c
@@ -1027,8 +1027,6 @@ static irqreturn_t fxls8962af_interrupt(
 	if (reg & FXLS8962AF_INT_STATUS_SRC_BUF) {
 		ret = fxls8962af_fifo_flush(indio_dev);
 		if (ret < 0)
-<<<<<<< HEAD
-=======
 			return IRQ_NONE;
 
 		return IRQ_HANDLED;
@@ -1037,7 +1035,6 @@ static irqreturn_t fxls8962af_interrupt(
 	if (reg & FXLS8962AF_INT_STATUS_SRC_SDCD_OT) {
 		ret = fxls8962af_event_interrupt(indio_dev);
 		if (ret < 0)
->>>>>>> linux-next/akpm-base
 			return IRQ_NONE;
 
 		return IRQ_HANDLED;
--- a/drivers/iio/adc/aspeed_adc.c~linux-next-git-rejects
+++ a/drivers/iio/adc/aspeed_adc.c
@@ -493,10 +493,7 @@ static int aspeed_adc_probe(struct platf
 	data = iio_priv(indio_dev);
 	data->dev = &pdev->dev;
 	platform_set_drvdata(pdev, indio_dev);
-<<<<<<< HEAD
-=======
 	data->model_data = of_device_get_match_data(&pdev->dev);
->>>>>>> linux-next/akpm-base
 
 	data->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(data->base))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
kernel-forkc-export-kernel_thread-to-modules.patch

