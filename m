Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F79C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E8C1223E0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgLODNB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728030AbgLODMu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:50 -0500
Date:   Mon, 14 Dec 2020 19:11:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001886;
        bh=V9+DVml/NeWf8gUp5R7GUgu+kMkY0cbIf9kmYcKKVVc=;
        h=From:To:Subject:In-Reply-To:From;
        b=JmVpJHH1tKLyA7ol2rjlZhD8nJYK7LZeaAdSxsat67H6/Bwcy/sXwdYhBJtmaWbCU
         1JZWhQzFRmAJQCq6emWw+eFP9BpzIbJiejq3EW9asrW5ZPgqmLVnuXN8W/NZiGqXcR
         TCkj6RUb0C8ZA2xF4lcOEsKbLmdQo6NlCvjR2YrI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 137/200] mm/page_alloc: speed up the iteration of
 max_order
Message-ID: <20201215031125.G8qpfmqBw%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/page_alloc: speed up the iteration of max_order

When we free a page whose order is very close to MAX_ORDER and greater
than pageblock_order, it wastes some CPU cycles to increase max_order to
MAX_ORDER one by one and check the pageblock migratetype of that page
repeatedly especially when MAX_ORDER is much larger than pageblock_order.

We also should not be checking migratetype of buddy when "order ==
MAX_ORDER - 1" as the buddy pfn may be invalid, so adjust the condition. 
With the new check, we don't need the max_order check anymore, so we
replace it.

Also adjust max_order initialization so that it's lower by one than
previously, which makes the code hopefully more clear.

Link: https://lkml.kernel.org/r/20201204155109.55451-1-songmuchun@bytedance.com
Fixes: d9dddbf55667 ("mm/page_alloc: prevent merging between isolated and other pageblocks")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-speeding-up-the-iteration-of-max_order
+++ a/mm/page_alloc.c
@@ -996,7 +996,7 @@ static inline void __free_one_page(struc
 	struct page *buddy;
 	bool to_tail;
 
-	max_order = min_t(unsigned int, MAX_ORDER, pageblock_order + 1);
+	max_order = min_t(unsigned int, MAX_ORDER - 1, pageblock_order);
 
 	VM_BUG_ON(!zone_is_initialized(zone));
 	VM_BUG_ON_PAGE(page->flags & PAGE_FLAGS_CHECK_AT_PREP, page);
@@ -1009,7 +1009,7 @@ static inline void __free_one_page(struc
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
 continue_merging:
-	while (order < max_order - 1) {
+	while (order < max_order) {
 		if (compaction_capture(capc, page, order, migratetype)) {
 			__mod_zone_freepage_state(zone, -(1 << order),
 								migratetype);
@@ -1035,7 +1035,7 @@ continue_merging:
 		pfn = combined_pfn;
 		order++;
 	}
-	if (max_order < MAX_ORDER) {
+	if (order < MAX_ORDER - 1) {
 		/* If we are here, it means order is >= pageblock_order.
 		 * We want to prevent merge between freepages on isolate
 		 * pageblock and normal pageblock. Without this, pageblock
@@ -1056,7 +1056,7 @@ continue_merging:
 						is_migrate_isolate(buddy_mt)))
 				goto done_merging;
 		}
-		max_order++;
+		max_order = order + 1;
 		goto continue_merging;
 	}
 
_
