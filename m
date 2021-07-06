Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD96C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52DF36117A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhGFTMU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231737AbhGFTMU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:12:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EF8760FEE;
        Tue,  6 Jul 2021 19:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598580;
        bh=nhQT3NrChO6tJ9/6bttfJdL/i1DbV21smMIqUM5UAH0=;
        h=Date:From:To:Subject:From;
        b=y97dtx4HUPZQTotYVDTtsAYQmAi9Dxp0cNuaDpp4YSHH2MhDuDMtV3GoKgzzJSKKK
         r5SA5OFUmxrCCzDOq+MTuIfFMYn9HcRrnLGItq9xKQnyOfoOFDqMGoTfGsPpeD6CNE
         GWWf1f0RYwlxlR6lm+Gbtyd3GuBRs1QOo6PpBT6I=
Date:   Tue, 06 Jul 2021 12:09:40 -0700
From:   akpm@linux-foundation.org
To:     axboe@fb.com, jack@suse.cz, mm-commits@vger.kernel.org,
        mszeredi@redhat.com, sedat.dilek@gmail.com, tj@kernel.org,
        wuchi.zero@gmail.com
Subject:  [merged]
 mm-page-writeback-fix-performance-when-bdis-share-of-ratio-is-0.patch
 removed from -mm tree
Message-ID: <20210706190940.ZhKTrPEMz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: Fix performance when BDI's share of ratio is 0.
has been removed from the -mm tree.  Its filename was
     mm-page-writeback-fix-performance-when-bdis-share-of-ratio-is-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chi Wu <wuchi.zero@gmail.com>
Subject: mm/page-writeback: Fix performance when BDI's share of ratio is 0.

Fix performance when BDI's share of ratio is 0.

The issue is similar to commit 74d369443325 ("writeback: Fix
performance regression in wb_over_bg_thresh()").

Balance_dirty_pages and the writeback worker will also disagree on
whether writeback when a BDI uses BDI_CAP_STRICTLIMIT and BDI's share
of the thresh ratio is zero.

For example, A thread on cpu0 writes 32 pages and then
balance_dirty_pages, it will wake up background writeback and pauses
because wb_dirty > wb->wb_thresh = 0 (share of thresh ratio is zero).
A thread may runs on cpu0 again because scheduler prefers pre_cpu.
Then writeback worker may runs on other cpus(1,2..) which causes the
value of wb_stat(wb, WB_RECLAIMABLE) in wb_over_bg_thresh is 0 and does
not writeback and returns.

Thus, balance_dirty_pages keeps looping, sleeping and then waking up the
worker who will do nothing. It remains stuck in this state until the
writeback worker hit the right dirty cpu or the dirty pages expire.

The fix that we should get the wb_stat_sum radically when thresh is low.

Link: https://lkml.kernel.org/r/20210428225046.16301-1-wuchi.zero@gmail.com
Signed-off-by: Chi Wu <wuchi.zero@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/mm/page-writeback.c~mm-page-writeback-fix-performance-when-bdis-share-of-ratio-is-0
+++ a/mm/page-writeback.c
@@ -1944,6 +1944,8 @@ bool wb_over_bg_thresh(struct bdi_writeb
 	struct dirty_throttle_control * const gdtc = &gdtc_stor;
 	struct dirty_throttle_control * const mdtc = mdtc_valid(&mdtc_stor) ?
 						     &mdtc_stor : NULL;
+	unsigned long reclaimable;
+	unsigned long thresh;
 
 	/*
 	 * Similar to balance_dirty_pages() but ignores pages being written
@@ -1956,8 +1958,13 @@ bool wb_over_bg_thresh(struct bdi_writeb
 	if (gdtc->dirty > gdtc->bg_thresh)
 		return true;
 
-	if (wb_stat(wb, WB_RECLAIMABLE) >
-	    wb_calc_thresh(gdtc->wb, gdtc->bg_thresh))
+	thresh = wb_calc_thresh(gdtc->wb, gdtc->bg_thresh);
+	if (thresh < 2 * wb_stat_error())
+		reclaimable = wb_stat_sum(wb, WB_RECLAIMABLE);
+	else
+		reclaimable = wb_stat(wb, WB_RECLAIMABLE);
+
+	if (reclaimable > thresh)
 		return true;
 
 	if (mdtc) {
@@ -1971,8 +1978,13 @@ bool wb_over_bg_thresh(struct bdi_writeb
 		if (mdtc->dirty > mdtc->bg_thresh)
 			return true;
 
-		if (wb_stat(wb, WB_RECLAIMABLE) >
-		    wb_calc_thresh(mdtc->wb, mdtc->bg_thresh))
+		thresh = wb_calc_thresh(mdtc->wb, mdtc->bg_thresh);
+		if (thresh < 2 * wb_stat_error())
+			reclaimable = wb_stat_sum(wb, WB_RECLAIMABLE);
+		else
+			reclaimable = wb_stat(wb, WB_RECLAIMABLE);
+
+		if (reclaimable > thresh)
 			return true;
 	}
 
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are


