Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB7BC433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 23:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 236FE613D0
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 23:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhEIXhr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 19:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229920AbhEIXhq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 19:37:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FE2E613D0;
        Sun,  9 May 2021 23:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620603402;
        bh=7lEuw6/KYmXnlqT3xWep6SaKnV7NnmpWD4QrUSUkb3I=;
        h=Date:From:To:Subject:From;
        b=K41kqI7rdJbg57lQaHo8ZZV/15jV69Mje3ZiAD0t3gIR3BpOwGdykGW8FtwDXzRTl
         WsG+xur8ZqFTDq3/eZXoO0OgWJnb3lUzA/eDLymh00V747O3F6zrhhL1JsxlFoegHl
         /cErw9WWLPcpKkvW06VfUegsnGeDjsdUJ5sTfefU=
Date:   Sun, 09 May 2021 16:36:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wuchi.zero@gmail.com
Subject:  +
 mm-page-writeback-fix-performance-when-bdis-share-of-ratio-is-0.patch added
 to -mm tree
Message-ID: <20210509233642.44pLNclWk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback: Fix performance when BDI's share of ratio is 0.
has been added to the -mm tree.  Its filename is
     mm-page-writeback-fix-performance-when-bdis-share-of-ratio-is-0.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page-writeback-fix-performance-when-bdis-share-of-ratio-is-0.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writeback-fix-performance-when-bdis-share-of-ratio-is-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page-writeback-fix-performance-when-bdis-share-of-ratio-is-0.patch

