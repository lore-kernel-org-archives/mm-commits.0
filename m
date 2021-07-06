Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D98C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E51E61C98
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhGFTUv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:20:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231785AbhGFTUv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:20:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74D3861C96;
        Tue,  6 Jul 2021 19:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599092;
        bh=ip4+PZ/4GBlI2BSrFt+Ag7Bq3Pd5AfLPjRUBFpORQyY=;
        h=Date:From:To:Subject:From;
        b=K6Kqqa4XYdVwlv/CHs3vDR4Rfl1GCQ6AHQT0bUxdLsPnNdH+9Pfdy17pOZQ0XoTJb
         YYlpvtsoyMCs5416UK3FeayHx7TMyni+lW96XPQAGBXtWf80kKLIY4//uA7P4V0cFy
         jCwe2E54Saw0IL47Ptfw7dpV6T8l6XBYD0KD2wkg=
Date:   Tue, 06 Jul 2021 12:18:12 -0700
From:   akpm@linux-foundation.org
To:     minchan@kernel.org, mm-commits@vger.kernel.org, yuzhao@google.com
Subject:  [merged]
 mm-vmscanc-fix-potential-deadlock-in-reclaim_pages.patch removed from -mm
 tree
Message-ID: <20210706191812.iRcGi1I-7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: fix potential deadlock in reclaim_pages()
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-fix-potential-deadlock-in-reclaim_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/vmscan.c: fix potential deadlock in reclaim_pages()

Theoretically without the protect from memalloc_noreclaim_save() and
memalloc_noreclaim_restore(), reclaim_pages() can go into the block
I/O layer recursively and deadlock.

Querying 'reclaim_pages' in our kernel crash databases didn't yield
any results. So the deadlock seems unlikely to happen. A possible
explanation is that the only user of reclaim_pages(), i.e.,
MADV_PAGEOUT, is usually called before memory pressure builds up,
e.g., on Android and Chrome OS. Under such a condition, allocations in
the block I/O layer can be fulfilled without diverting to direct
reclaim and therefore the recursion is avoided.

Link: https://lkml.kernel.org/r/20210622074642.785473-1-yuzhao@google.com
Link: https://lkml.kernel.org/r/20210614194727.2684053-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/vmscan.c~mm-vmscanc-fix-potential-deadlock-in-reclaim_pages
+++ a/mm/vmscan.c
@@ -1701,6 +1701,7 @@ unsigned int reclaim_clean_pages_from_li
 	unsigned int nr_reclaimed;
 	struct page *page, *next;
 	LIST_HEAD(clean_pages);
+	unsigned int noreclaim_flag;
 
 	list_for_each_entry_safe(page, next, page_list, lru) {
 		if (!PageHuge(page) && page_is_file_lru(page) &&
@@ -1711,8 +1712,17 @@ unsigned int reclaim_clean_pages_from_li
 		}
 	}
 
+	/*
+	 * We should be safe here since we are only dealing with file pages and
+	 * we are not kswapd and therefore cannot write dirty file pages. But
+	 * call memalloc_noreclaim_save() anyway, just in case these conditions
+	 * change in the future.
+	 */
+	noreclaim_flag = memalloc_noreclaim_save();
 	nr_reclaimed = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
 					&stat, true);
+	memalloc_noreclaim_restore(noreclaim_flag);
+
 	list_splice(&clean_pages, page_list);
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
 			    -(long)nr_reclaimed);
@@ -2306,6 +2316,7 @@ unsigned long reclaim_pages(struct list_
 	LIST_HEAD(node_page_list);
 	struct reclaim_stat dummy_stat;
 	struct page *page;
+	unsigned int noreclaim_flag;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.priority = DEF_PRIORITY,
@@ -2314,6 +2325,8 @@ unsigned long reclaim_pages(struct list_
 		.may_swap = 1,
 	};
 
+	noreclaim_flag = memalloc_noreclaim_save();
+
 	while (!list_empty(page_list)) {
 		page = lru_to_page(page_list);
 		if (nid == NUMA_NO_NODE) {
@@ -2350,6 +2363,8 @@ unsigned long reclaim_pages(struct list_
 		}
 	}
 
+	memalloc_noreclaim_restore(noreclaim_flag);
+
 	return nr_reclaimed;
 }
 
_

Patches currently in -mm which might be from yuzhao@google.com are


