Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5F6C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbjBCGoj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjBCGmu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AAA90384
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70F0661DAB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C987FC4339B;
        Fri,  3 Feb 2023 06:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406325;
        bh=zD544XV9yd8abwwuuRnleZBOfnre/qm3KQHHoZ8bNeI=;
        h=Date:To:From:Subject:From;
        b=czU6tPWfUImpf/auWGpIwj/vRmgiELxgcj6FzvAnZjce2nrb6FAXgyBIu7KOxAso0
         ZrdnXSVzOy4M+577L/yC45xP8ZIa9KH2GGLpBcsOVIgQabPO/yNMFTFBHEp2fI4avb
         AKq9uXrX9JkR3v9b3fyEjt8rVNbK9sMl+dlYr7EQ=
Date:   Thu, 02 Feb 2023 22:38:45 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-an-on-stack-bio-for-synchronous-swapin.patch removed from -mm tree
Message-Id: <20230203063845.C987FC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use an on-stack bio for synchronous swapin
has been removed from the -mm tree.  Its filename was
     mm-use-an-on-stack-bio-for-synchronous-swapin.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: use an on-stack bio for synchronous swapin
Date: Wed, 25 Jan 2023 14:34:33 +0100

Optimize the synchronous swap in case by using an on-stack bio instead of
allocating one using bio_alloc.

Link: https://lkml.kernel.org/r/20230125133436.447864-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_io.c~mm-use-an-on-stack-bio-for-synchronous-swapin
+++ a/mm/page_io.c
@@ -51,10 +51,9 @@ static void end_swap_bio_write(struct bi
 	bio_put(bio);
 }
 
-static void end_swap_bio_read(struct bio *bio)
+static void __end_swap_bio_read(struct bio *bio)
 {
 	struct page *page = bio_first_page_all(bio);
-	struct task_struct *waiter = bio->bi_private;
 
 	if (bio->bi_status) {
 		SetPageError(page);
@@ -62,18 +61,16 @@ static void end_swap_bio_read(struct bio
 		pr_alert_ratelimited("Read-error on swap-device (%u:%u:%llu)\n",
 				     MAJOR(bio_dev(bio)), MINOR(bio_dev(bio)),
 				     (unsigned long long)bio->bi_iter.bi_sector);
-		goto out;
+	} else {
+		SetPageUptodate(page);
 	}
-
-	SetPageUptodate(page);
-out:
 	unlock_page(page);
-	WRITE_ONCE(bio->bi_private, NULL);
+}
+
+static void end_swap_bio_read(struct bio *bio)
+{
+	__end_swap_bio_read(bio);
 	bio_put(bio);
-	if (waiter) {
-		blk_wake_io_task(waiter);
-		put_task_struct(waiter);
-	}
 }
 
 int generic_swapfile_activate(struct swap_info_struct *sis,
@@ -444,10 +441,11 @@ static void swap_readpage_fs(struct page
 		*plug = sio;
 }
 
-static void swap_readpage_bdev(struct page *page, bool synchronous,
+static void swap_readpage_bdev_sync(struct page *page,
 		struct swap_info_struct *sis)
 {
-	struct bio *bio;
+	struct bio_vec bv;
+	struct bio bio;
 
 	if ((sis->flags & SWP_SYNCHRONOUS_IO) &&
 	    !bdev_read_page(sis->bdev, swap_page_sector(page), page)) {
@@ -455,30 +453,37 @@ static void swap_readpage_bdev(struct pa
 		return;
 	}
 
-	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
-	bio->bi_iter.bi_sector = swap_page_sector(page);
-	bio->bi_end_io = end_swap_bio_read;
-	bio_add_page(bio, page, thp_size(page), 0);
+	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_READ);
+	bio.bi_iter.bi_sector = swap_page_sector(page);
+	bio_add_page(&bio, page, thp_size(page), 0);
 	/*
 	 * Keep this task valid during swap readpage because the oom killer may
 	 * attempt to access it in the page fault retry time check.
 	 */
-	if (synchronous) {
-		get_task_struct(current);
-		bio->bi_private = current;
-	}
+	get_task_struct(current);
 	count_vm_event(PSWPIN);
-	bio_get(bio);
-	submit_bio(bio);
-	while (synchronous) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!READ_ONCE(bio->bi_private))
-			break;
+	submit_bio_wait(&bio);
+	__end_swap_bio_read(&bio);
+	put_task_struct(current);
+}
+
+static void swap_readpage_bdev_async(struct page *page,
+		struct swap_info_struct *sis)
+{
+	struct bio *bio;
 
-		blk_io_schedule();
+	if ((sis->flags & SWP_SYNCHRONOUS_IO) &&
+	    !bdev_read_page(sis->bdev, swap_page_sector(page), page)) {
+		count_vm_event(PSWPIN);
+		return;
 	}
-	__set_current_state(TASK_RUNNING);
-	bio_put(bio);
+
+	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
+	bio->bi_iter.bi_sector = swap_page_sector(page);
+	bio->bi_end_io = end_swap_bio_read;
+	bio_add_page(bio, page, thp_size(page), 0);
+	count_vm_event(PSWPIN);
+	submit_bio(bio);
 }
 
 void swap_readpage(struct page *page, bool synchronous, struct swap_iocb **plug)
@@ -508,8 +513,10 @@ void swap_readpage(struct page *page, bo
 		unlock_page(page);
 	} else if (data_race(sis->flags & SWP_FS_OPS)) {
 		swap_readpage_fs(page, plug);
+	} else if (synchronous) {
+		swap_readpage_bdev_sync(page, sis);
 	} else {
-		swap_readpage_bdev(page, synchronous, sis);
+		swap_readpage_bdev_async(page, sis);
 	}
 
 	if (workingset) {
_

Patches currently in -mm which might be from hch@lst.de are


