Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D37C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbjBCGoi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbjBCGmu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDEC8DAF0
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 612B761DAC
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC81C433D2;
        Fri,  3 Feb 2023 06:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406324;
        bh=peaid+E9H+3LWk/kV38ApKZ+O6BC3PV/5+nlLMsTxxU=;
        h=Date:To:From:Subject:From;
        b=TfAfTU233yyRIEOHR0HPr7RcohPDBdg/q+XbXTwaKOi1+rOsN/yYyT6yDOw/sOlh3
         bXt3uIqsklKhL52q+5UVuqYAxUuI25E/a3mAGy6t83WAItQG92MHDaYgsyqi2vsH00
         +eYtElD05jvvLnY1Y4pOliamPOQkyr2oft7kMWhU=
Date:   Thu, 02 Feb 2023 22:38:44 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-factor-out-a-swap_readpage_bdev-helper.patch removed from -mm tree
Message-Id: <20230203063844.BBC81C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: factor out a swap_readpage_bdev helper
has been removed from the -mm tree.  Its filename was
     mm-factor-out-a-swap_readpage_bdev-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


