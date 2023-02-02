Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C9FC636D7
	for <mm-commits@archiver.kernel.org>; Thu,  2 Feb 2023 23:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBBX16 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Feb 2023 18:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjBBX15 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2023 18:27:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C82B7F696
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 15:27:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 57319CE2D81
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 23:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93679C433D2;
        Thu,  2 Feb 2023 23:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675380383;
        bh=bQRIWyaMcRzpzAoqW74Rh0c6SAYHleNQh55SPR+mkaE=;
        h=Date:To:From:Subject:From;
        b=cq4q8160DWwW6/sDJWQtmgn7XvCkyBWX3qiJiXyANJj4xCkYdXRLAVHZEd9e9dlbt
         zzFYZjUnIwq25F5hkABmOpVoIwPzXzXG2np7MtHcTgAA+D1mHkWpeo9CC/CNPKNucY
         /dN2AlUm1c/M5pZqboCMOe3eq0XMCK7qEjb1AG6Y=
Date:   Thu, 02 Feb 2023 15:26:22 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, halbuer@sra.uni-hannover.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reduce-lock-contention-of-pcp-buffer-refill.patch added to mm-unstable branch
Message-Id: <20230202232623.93679C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: reduce lock contention of pcp buffer refill
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reduce-lock-contention-of-pcp-buffer-refill.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reduce-lock-contention-of-pcp-buffer-refill.patch

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
From: Alexander Halbuer <halbuer@sra.uni-hannover.de>
Subject: mm: reduce lock contention of pcp buffer refill
Date: Wed, 1 Feb 2023 17:25:49 +0100

rmqueue_bulk() batches the allocation of multiple elements to refill the
per-CPU buffers into a single hold of the zone lock.  Each element is
allocated and checked using check_pcp_refill().  The check touches every
related struct page which is especially expensive for higher order
allocations (huge pages).

This patch reduces the time holding the lock by moving the check out of
the critical section similar to rmqueue_buddy() which allocates a single
element.

Measurements of parallel allocation-heavy workloads show a reduction of
the average huge page allocation latency of 50 percent for two cores and
nearly 90 percent for 24 cores.

Link: https://lkml.kernel.org/r/20230201162549.68384-1-halbuer@sra.uni-hannover.de
Signed-off-by: Alexander Halbuer <halbuer@sra.uni-hannover.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/page_alloc.c~mm-reduce-lock-contention-of-pcp-buffer-refill
+++ a/mm/page_alloc.c
@@ -3140,6 +3140,8 @@ static int rmqueue_bulk(struct zone *zon
 {
 	unsigned long flags;
 	int i, allocated = 0;
+	struct list_head *prev_tail = list->prev;
+	struct page *pos, *n;
 
 	spin_lock_irqsave(&zone->lock, flags);
 	for (i = 0; i < count; ++i) {
@@ -3148,9 +3150,6 @@ static int rmqueue_bulk(struct zone *zon
 		if (unlikely(page == NULL))
 			break;
 
-		if (unlikely(check_pcp_refill(page, order)))
-			continue;
-
 		/*
 		 * Split buddy pages returned by expand() are received here in
 		 * physical page order. The page is added to the tail of
@@ -3162,7 +3161,6 @@ static int rmqueue_bulk(struct zone *zon
 		 * pages are ordered properly.
 		 */
 		list_add_tail(&page->pcp_list, list);
-		allocated++;
 		if (is_migrate_cma(get_pcppage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
 					      -(1 << order));
@@ -3176,6 +3174,22 @@ static int rmqueue_bulk(struct zone *zon
 	 */
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 	spin_unlock_irqrestore(&zone->lock, flags);
+
+	/*
+	 * Pages are appended to the pcp list without checking to reduce the
+	 * time holding the zone lock. Checking the appended pages happens right
+	 * after the critical section while still holding the pcp lock.
+	 */
+	pos = list_first_entry(prev_tail, struct page, pcp_list);
+	list_for_each_entry_safe_from(pos, n, list, pcp_list) {
+		if (unlikely(check_pcp_refill(pos, order))) {
+			list_del(&pos->pcp_list);
+			continue;
+		}
+
+		allocated++;
+	}
+
 	return allocated;
 }
 
_

Patches currently in -mm which might be from halbuer@sra.uni-hannover.de are

mm-reduce-lock-contention-of-pcp-buffer-refill.patch

