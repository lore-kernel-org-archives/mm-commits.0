Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B36C61D9D
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbjAZBY6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236502AbjAZBYz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:24:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD1B180
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:24:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1D8AB81C6F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676C6C4339B;
        Thu, 26 Jan 2023 01:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674696291;
        bh=j1WNOSLF3Ws3WEsxBiVYDJbB2ocUsn17r7RelIyrx94=;
        h=Date:To:From:Subject:From;
        b=TPKkF7MaoX659FqR78DGgtnNoMbi2iv3mjkrT+k9Sg5REVcSxiEYub4zrYMYv9DxH
         RCBdOXQ1BvGJlxrgPyoKYUKLjOEd63LHuX2/0hG+pM4ndjppPl9exX2mqahb+VgbWC
         ham2eJh56ge6ITcSaZ5mkmvJAr5PtFZ+lRKv4jWs=
Date:   Wed, 25 Jan 2023 17:24:50 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-an-on-stack-bio-for-synchronous-swapin.patch added to mm-unstable branch
Message-Id: <20230126012451.676C6C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use an on-stack bio for synchronous swapin
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-an-on-stack-bio-for-synchronous-swapin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-an-on-stack-bio-for-synchronous-swapin.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

revert-remoteproc-qcom_q6v5_mss-map-unmap-metadata-region-before-after-use.patch
mm-reject-vmap-with-vm_flush_reset_perms.patch
mm-remove-__vfree.patch
mm-remove-__vfree_deferred.patch
mm-move-vmalloc_init-and-free_work-down-in-vmallocc.patch
mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch
mm-move-__remove_vm_area-out-of-va_remove_mappings.patch
mm-use-remove_vm_area-in-__vunmap.patch
mm-move-debug-checks-from-__vunmap-to-remove_vm_area.patch
mm-split-__vunmap.patch
mm-refactor-va_remove_mappings.patch
mpage-stop-using-bdev_readwrite_page.patch
mm-remove-the-swap_readpage-return-value.patch
mm-factor-out-a-swap_readpage_bdev-helper.patch
mm-use-an-on-stack-bio-for-synchronous-swapin.patch
mm-remove-the-__swap_writepage-return-value.patch
mm-factor-out-a-swap_writepage_bdev-helper.patch
block-remove-rw_page.patch

