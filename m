Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFCDC76196
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjC1XVB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjC1XU6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:20:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD5610FB
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:20:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A592619E9
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5584C433D2;
        Tue, 28 Mar 2023 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045655;
        bh=U1wqy3LU/FTP3X6VW6z1EsuECzOZOVMugoA+9qPpOEc=;
        h=Date:To:From:Subject:From;
        b=fOM4oWGABJibVX4wpg35J3XuqJRF6YO1bT9dfey8JoZUdxBAqSRncyRGteSeX/2Jq
         hOUi+97hbhkt3nejyztt+fS+7Dn2Ck+JVCax4lEWZ95LavVYbO7pBQMbyTOU4vuMw3
         hD5vleI6b6inevn7S0WQ3NbfmjZV7iKRdhJ0/4UA=
Date:   Tue, 28 Mar 2023 16:20:55 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, halbuer@sra.uni-hannover.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-reduce-lock-contention-of-pcp-buffer-refill.patch removed from -mm tree
Message-Id: <20230328232055.C5584C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: reduce lock contention of pcp buffer refill
has been removed from the -mm tree.  Its filename was
     mm-reduce-lock-contention-of-pcp-buffer-refill.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 mm/page_alloc.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-reduce-lock-contention-of-pcp-buffer-refill
+++ a/mm/page_alloc.c
@@ -3138,6 +3138,8 @@ static int rmqueue_bulk(struct zone *zon
 {
 	unsigned long flags;
 	int i, allocated = 0;
+	struct list_head *prev_tail = list->prev;
+	struct page *pos, *n;
 
 	spin_lock_irqsave(&zone->lock, flags);
 	for (i = 0; i < count; ++i) {
@@ -3146,9 +3148,6 @@ static int rmqueue_bulk(struct zone *zon
 		if (unlikely(page == NULL))
 			break;
 
-		if (unlikely(check_pcp_refill(page, order)))
-			continue;
-
 		/*
 		 * Split buddy pages returned by expand() are received here in
 		 * physical page order. The page is added to the tail of
@@ -3160,7 +3159,6 @@ static int rmqueue_bulk(struct zone *zon
 		 * pages are ordered properly.
 		 */
 		list_add_tail(&page->pcp_list, list);
-		allocated++;
 		if (is_migrate_cma(get_pcppage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
 					      -(1 << order));
@@ -3174,6 +3172,22 @@ static int rmqueue_bulk(struct zone *zon
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


