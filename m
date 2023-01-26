Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059B8C27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjAZBY5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbjAZBYv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:24:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17EE12B
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:24:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D29261708
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0425C4339B;
        Thu, 26 Jan 2023 01:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674696289;
        bh=IqPri4zFuVsW3IzPJ0BFrRBbiyV989Hq6XSbAb6+Dhk=;
        h=Date:To:From:Subject:From;
        b=ZI4w852nB7yGooifoSjte4fofVINTDACKvQGqiaRwuqP3Ey2BoBfRSEwRXP2X5yNb
         2iW8nYTz2bc7E2TIl13SkjsBnJOvlhYuqjCC/kyGUpw9DrO443Z9FBqCu3nXGPnTgn
         cACdl3KKZgYQKQhhLSeiHaVHy51+/kAZKtiOiOM4=
Date:   Wed, 25 Jan 2023 17:24:48 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-factor-out-a-swap_readpage_bdev-helper.patch added to mm-unstable branch
Message-Id: <20230126012449.A0425C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: factor out a swap_readpage_bdev helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-factor-out-a-swap_readpage_bdev-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-factor-out-a-swap_readpage_bdev-helper.patch

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
Subject: mm: factor out a swap_readpage_bdev helper
Date: Wed, 25 Jan 2023 14:34:32 +0100

Split the block device case from swap_readpage into a separate helper,
following the abstraction for file based swap and frontswap.

Link: https://lkml.kernel.org/r/20230125133436.447864-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_io.c~mm-factor-out-a-swap_readpage_bdev-helper
+++ a/mm/page_io.c
@@ -444,44 +444,15 @@ static void swap_readpage_fs(struct page
 		*plug = sio;
 }
 
-void swap_readpage(struct page *page, bool synchronous, struct swap_iocb **plug)
+static void swap_readpage_bdev(struct page *page, bool synchronous,
+		struct swap_info_struct *sis)
 {
 	struct bio *bio;
-	struct swap_info_struct *sis = page_swap_info(page);
-	bool workingset = PageWorkingset(page);
-	unsigned long pflags;
-	bool in_thrashing;
-
-	VM_BUG_ON_PAGE(!PageSwapCache(page) && !synchronous, page);
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(PageUptodate(page), page);
-
-	/*
-	 * Count submission time as memory stall and delay. When the device
-	 * is congested, or the submitting cgroup IO-throttled, submission
-	 * can be a significant part of overall IO time.
-	 */
-	if (workingset) {
-		delayacct_thrashing_start(&in_thrashing);
-		psi_memstall_enter(&pflags);
-	}
-	delayacct_swapin_start();
-
-	if (frontswap_load(page) == 0) {
-		SetPageUptodate(page);
-		unlock_page(page);
-		goto out;
-	}
-
-	if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_readpage_fs(page, plug);
-		goto out;
-	}
 
 	if ((sis->flags & SWP_SYNCHRONOUS_IO) &&
 	    !bdev_read_page(sis->bdev, swap_page_sector(page), page)) {
 		count_vm_event(PSWPIN);
-		goto out;
+		return;
 	}
 
 	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
@@ -508,8 +479,39 @@ void swap_readpage(struct page *page, bo
 	}
 	__set_current_state(TASK_RUNNING);
 	bio_put(bio);
+}
+
+void swap_readpage(struct page *page, bool synchronous, struct swap_iocb **plug)
+{
+	struct swap_info_struct *sis = page_swap_info(page);
+	bool workingset = PageWorkingset(page);
+	unsigned long pflags;
+	bool in_thrashing;
+
+	VM_BUG_ON_PAGE(!PageSwapCache(page) && !synchronous, page);
+	VM_BUG_ON_PAGE(!PageLocked(page), page);
+	VM_BUG_ON_PAGE(PageUptodate(page), page);
+
+	/*
+	 * Count submission time as memory stall and delay. When the device
+	 * is congested, or the submitting cgroup IO-throttled, submission
+	 * can be a significant part of overall IO time.
+	 */
+	if (workingset) {
+		delayacct_thrashing_start(&in_thrashing);
+		psi_memstall_enter(&pflags);
+	}
+	delayacct_swapin_start();
+
+	if (frontswap_load(page) == 0) {
+		SetPageUptodate(page);
+		unlock_page(page);
+	} else if (data_race(sis->flags & SWP_FS_OPS)) {
+		swap_readpage_fs(page, plug);
+	} else {
+		swap_readpage_bdev(page, synchronous, sis);
+	}
 
-out:
 	if (workingset) {
 		delayacct_thrashing_end(&in_thrashing);
 		psi_memstall_leave(&pflags);
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

