Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF52C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00D9E61A1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbhCXWnE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238710AbhCXWnB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 18:43:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5644619E4;
        Wed, 24 Mar 2021 22:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616625780;
        bh=dY983+pfYRsdyU/ihuTeVs7abKUIGTyHN5pK/tCALdk=;
        h=Date:From:To:Subject:From;
        b=d3N8hfG5dMiFxWzRBarUMVBXg0/i7U5H0dLHYy1NGwiOQuFUbGZ2UERAC4wyY2NvJ
         Q6C+SWKUayjciJS0186a+D01vrKVwacyqtKCX3k5RLu2vCnm6Ud8kCIyn/ym0BJHf5
         5wPGOiBpa70wWE9oNYd5nlba27662M3PMKM/hFVA=
Date:   Wed, 24 Mar 2021 15:43:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        sfr@canb.auug.org.au, mhocko@suse.com, liushixin2@huawei.com,
        wangkefeng.wang@huawei.com
Subject:  + mm-page_alloc-avoid-page_to_pfn-in-move_freepages.patch
 added to -mm tree
Message-ID: <20210324224300.eRVlM%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: avoid page_to_pfn() in move_freepages()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-avoid-page_to_pfn-in-move_freepages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-avoid-page_to_pfn-in-move_freepages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-avoid-page_to_pfn-in-move_freepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-page_to_pfn-in-move_freepages
+++ a/mm/page_alloc.c
@@ -2425,19 +2425,21 @@ static inline struct page *__rmqueue_cma
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
@@ -2447,8 +2449,7 @@ static int move_freepages(struct zone *z
 			if (num_movable &&
 					(PageLRU(page) || __PageMovable(page)))
 				(*num_movable)++;
-
-			page++;
+			pfn++;
 			continue;
 		}
 
@@ -2458,7 +2459,7 @@ static int move_freepages(struct zone *z
 
 		order = buddy_order(page);
 		move_to_free_list(page, zone, order, migratetype);
-		page += 1 << order;
+		pfn += 1 << order;
 		pages_moved += 1 << order;
 	}
 
@@ -2468,25 +2469,22 @@ static int move_freepages(struct zone *z
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

mm-page_alloc-avoid-page_to_pfn-in-move_freepages.patch

