Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9FAC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90BD5613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhEHWqV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWqU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:46:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 937F061402;
        Sat,  8 May 2021 22:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513918;
        bh=ngLeFqBVCtb70QGLiB6h3WM4XqG4PflmT96QkxRvy0Q=;
        h=Date:From:To:Subject:From;
        b=zMRoyzYstHLXpQC8fvk+R0IA7F8APMqvLIsWp5t9vS1btY6OopoRzcwe56SS2kgq7
         g2H9UcUR3CGh6E9meaI7ovP1CkeKKIoRkr9bhxO3VakaTBd9qEkEw+Z4OFOo83mXEw
         ktWAZGZN0urHl5N5+BcC6d5flhezVbHbC6DnfBkI=
Date:   Sat, 08 May 2021 15:45:18 -0700
From:   akpm@linux-foundation.org
To:     liushixin2@huawei.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au, vbabka@suse.cz, wangkefeng.wang@huawei.com,
        willy@infradead.org
Subject:  [merged]
 mm-page_alloc-avoid-page_to_pfn-in-move_freepages.patch removed from -mm
 tree
Message-ID: <20210508224518.RdBDweLI6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: avoid page_to_pfn() in move_freepages()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-page_to_pfn-in-move_freepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm, page_alloc: avoid page_to_pfn() in move_freepages()

The start_pfn and end_pfn are already available in move_freepages_block(),
there is no need to go back and forth between page and pfn in
move_freepages and move_freepages_block, and pfn_valid_within() should
validate pfn first before touching the page.

Link: https://lkml.kernel.org/r/20210323131215.934472-1-liushixin2@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-page_to_pfn-in-move_freepages
+++ a/mm/page_alloc.c
@@ -2431,19 +2431,21 @@ static inline struct page *__rmqueue_cma
  * boundary. If alignment is required, use move_freepages_block()
  */
 static int move_freepages(struct zone *zone,
-			  struct page *start_page, struct page *end_page,
+			  unsigned long start_pfn, unsigned long end_pfn,
 			  int migratetype, int *num_movable)
 {
 	struct page *page;
+	unsigned long pfn;
 	unsigned int order;
 	int pages_moved = 0;
 
-	for (page = start_page; page <= end_page;) {
-		if (!pfn_valid_within(page_to_pfn(page))) {
-			page++;
+	for (pfn = start_pfn; pfn <= end_pfn;) {
+		if (!pfn_valid_within(pfn)) {
+			pfn++;
 			continue;
 		}
 
+		page = pfn_to_page(pfn);
 		if (!PageBuddy(page)) {
 			/*
 			 * We assume that pages that could be isolated for
@@ -2453,8 +2455,7 @@ static int move_freepages(struct zone *z
 			if (num_movable &&
 					(PageLRU(page) || __PageMovable(page)))
 				(*num_movable)++;
-
-			page++;
+			pfn++;
 			continue;
 		}
 
@@ -2464,7 +2465,7 @@ static int move_freepages(struct zone *z
 
 		order = buddy_order(page);
 		move_to_free_list(page, zone, order, migratetype);
-		page += 1 << order;
+		pfn += 1 << order;
 		pages_moved += 1 << order;
 	}
 
@@ -2474,25 +2475,22 @@ static int move_freepages(struct zone *z
 int move_freepages_block(struct zone *zone, struct page *page,
 				int migratetype, int *num_movable)
 {
-	unsigned long start_pfn, end_pfn;
-	struct page *start_page, *end_page;
+	unsigned long start_pfn, end_pfn, pfn;
 
 	if (num_movable)
 		*num_movable = 0;
 
-	start_pfn = page_to_pfn(page);
-	start_pfn = start_pfn & ~(pageblock_nr_pages-1);
-	start_page = pfn_to_page(start_pfn);
-	end_page = start_page + pageblock_nr_pages - 1;
+	pfn = page_to_pfn(page);
+	start_pfn = pfn & ~(pageblock_nr_pages - 1);
 	end_pfn = start_pfn + pageblock_nr_pages - 1;
 
 	/* Do not cross zone boundaries */
 	if (!zone_spans_pfn(zone, start_pfn))
-		start_page = page;
+		start_pfn = pfn;
 	if (!zone_spans_pfn(zone, end_pfn))
 		return 0;
 
-	return move_freepages(zone, start_page, end_page, migratetype,
+	return move_freepages(zone, start_pfn, end_pfn, migratetype,
 								num_movable);
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


