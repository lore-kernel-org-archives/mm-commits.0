Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8170AC432BE
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C8F961106
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbhHTCEu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Aug 2021 22:04:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235974AbhHTCEt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Aug 2021 22:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 812E7610FA;
        Fri, 20 Aug 2021 02:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629425052;
        bh=0brUu55efluUi+zOi7kskt0ubaHHPzCfzuZMesJsS6s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=p29zOiQRGVT3AveV+lDXOce4ppwn+sl5tVBvSvbEL4+tCaEvStFEHYVIiQlOlhAXg
         n1x/XrSoSYB7w3xiHY3njZrI5U1L1iRABIdYRuxGU8simdlp0InyNXBX8GI1Sh39LL
         vvzYv/T4XWNM3tpz4+oE4nVBIyxzc11Mo6/dO+yw=
Date:   Thu, 19 Aug 2021 19:04:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        opendmb@gmail.com, peterz@infradead.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 03/10] mm/page_alloc: don't corrupt
 pcppage_migratetype
Message-ID: <20210820020412.EA2QVRAWd%akpm@linux-foundation.org>
In-Reply-To: <20210819190327.14fc4e97102e1af7929e30af@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Doug Berger <opendmb@gmail.com>
Subject: mm/page_alloc: don't corrupt pcppage_migratetype

When placing pages on a pcp list, migratetype values over MIGRATE_PCPTYPES
get added to the MIGRATE_MOVABLE pcp list.

However, the actual migratetype is preserved in the page and should not be
changed to MIGRATE_MOVABLE or the page may end up on the wrong free_list.

The impact is that HIGHATOMIC or CMA pages getting bulk freed from the PCP
lists could potentially end up on the wrong buddy list.  There are various
consequences but minimally NR_FREE_CMA_PAGES accounting could get screwed
up.

[mgorman@techsingularity.net: changelog update]
Link: https://lkml.kernel.org/r/20210811182917.2607994-1-opendmb@gmail.com
Fixes: df1acc856923 ("mm/page_alloc: avoid conflating IRQs disabled with zone->lock")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-corrupt-pcppage_migratetype
+++ a/mm/page_alloc.c
@@ -3453,19 +3453,10 @@ void free_unref_page_list(struct list_he
 		 * comment in free_unref_page.
 		 */
 		migratetype = get_pcppage_migratetype(page);
-		if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
-			if (unlikely(is_migrate_isolate(migratetype))) {
-				list_del(&page->lru);
-				free_one_page(page_zone(page), page, pfn, 0,
-							migratetype, FPI_NONE);
-				continue;
-			}
-
-			/*
-			 * Non-isolated types over MIGRATE_PCPTYPES get added
-			 * to the MIGRATE_MOVABLE pcp list.
-			 */
-			set_pcppage_migratetype(page, MIGRATE_MOVABLE);
+		if (unlikely(is_migrate_isolate(migratetype))) {
+			list_del(&page->lru);
+			free_one_page(page_zone(page), page, pfn, 0, migratetype, FPI_NONE);
+			continue;
 		}
 
 		set_page_private(page, pfn);
@@ -3475,7 +3466,15 @@ void free_unref_page_list(struct list_he
 	list_for_each_entry_safe(page, next, list, lru) {
 		pfn = page_private(page);
 		set_page_private(page, 0);
+
+		/*
+		 * Non-isolated types over MIGRATE_PCPTYPES get added
+		 * to the MIGRATE_MOVABLE pcp list.
+		 */
 		migratetype = get_pcppage_migratetype(page);
+		if (unlikely(migratetype >= MIGRATE_PCPTYPES))
+			migratetype = MIGRATE_MOVABLE;
+
 		trace_mm_page_free_batched(page);
 		free_unref_page_commit(page, pfn, migratetype, 0);
 
_
