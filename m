Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333FCC2B9F4
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 22:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 139B8610CD
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 22:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhFNWNq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 18:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231187AbhFNWNq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 18:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9122961185;
        Mon, 14 Jun 2021 22:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623708688;
        bh=1ZtUi6UWBD667z7pnshjxEvd6dDHxp3aOKt5tl016cs=;
        h=Date:From:To:Subject:From;
        b=GijGsJjo+NGlZ62EwaF0B1VVE3cuAMUiq9xkyONIUU9pU7YvEW94fbleT0aItZ98u
         otcAwqL7m5GrphXgHQmOAC+l2Jfz3uyjaUlacQywuLHRXPw4sqjYQdRAq9GYByo1YR
         UruYkuonMaZfB/px00M8OA3kD3BFNA0uGDEtTtYs=
Date:   Mon, 14 Jun 2021 15:11:28 -0700
From:   akpm@linux-foundation.org
To:     minchan@kernel.org, mm-commits@vger.kernel.org, yuzhao@google.com
Subject:  +
 mm-vmscanc-fix-potential-deadlock-in-reclaim_pages.patch added to -mm tree
Message-ID: <20210614221128.BYGCEI8zz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: fix potential deadlock in reclaim_pages()
has been added to the -mm tree.  Its filename is
     mm-vmscanc-fix-potential-deadlock-in-reclaim_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscanc-fix-potential-deadlock-in-reclaim_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscanc-fix-potential-deadlock-in-reclaim_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm/vmscan.c: fix potential deadlock in reclaim_pages()

Use memalloc_noreclaim_save()/memalloc_noreclaim_restore() in
reclaim_pages() to prevent the page reclaim from going into the block I/O
layer recursively and deadlock.

Link: https://lkml.kernel.org/r/20210614194727.2684053-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/vmscan.c~mm-vmscanc-fix-potential-deadlock-in-reclaim_pages
+++ a/mm/vmscan.c
@@ -1707,6 +1707,7 @@ unsigned int reclaim_clean_pages_from_li
 	unsigned int nr_reclaimed;
 	struct page *page, *next;
 	LIST_HEAD(clean_pages);
+	unsigned int noreclaim_flag;
 
 	list_for_each_entry_safe(page, next, page_list, lru) {
 		if (!PageHuge(page) && page_is_file_lru(page) &&
@@ -1717,8 +1718,17 @@ unsigned int reclaim_clean_pages_from_li
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
@@ -2312,6 +2322,7 @@ unsigned long reclaim_pages(struct list_
 	LIST_HEAD(node_page_list);
 	struct reclaim_stat dummy_stat;
 	struct page *page;
+	unsigned int noreclaim_flag;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.priority = DEF_PRIORITY,
@@ -2320,6 +2331,8 @@ unsigned long reclaim_pages(struct list_
 		.may_swap = 1,
 	};
 
+	noreclaim_flag = memalloc_noreclaim_save();
+
 	while (!list_empty(page_list)) {
 		page = lru_to_page(page_list);
 		if (nid == NUMA_NO_NODE) {
@@ -2356,6 +2369,8 @@ unsigned long reclaim_pages(struct list_
 		}
 	}
 
+	memalloc_noreclaim_restore(noreclaim_flag);
+
 	return nr_reclaimed;
 }
 
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-vmscanc-fix-potential-deadlock-in-reclaim_pages.patch

