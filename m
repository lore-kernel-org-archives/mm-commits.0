Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB5BC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D9E064F1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbhBXUJs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhBXUJD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:09:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E860564F09;
        Wed, 24 Feb 2021 20:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197302;
        bh=bRWqzn2KTS9tKTMlKKY2Uwp6eBB0yq+O+PeWay7ZNOQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SxcmFi0riSsCpkrMYGazBCkgbyxenbKUslKbwVy/lPfKijWK5Ngo6/bV78N//2D4f
         UinRBVCcsNaVKkWo6IjpQT97xl5fKuZ9DMMvC+JF+5nnE3lUcpuA8K1DNbNXsxEMro
         dDuYq5urSOKjK5pKknaEPuJQIw9gee3ljHfOYwlI=
Date:   Wed, 24 Feb 2021 12:08:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, willy@infradead.org, yuzhao@google.com
Subject:  [patch 138/173] mm/swap.c: don't pass "enum lru_list" to
 trace_mm_lru_insertion()
Message-ID: <20210224200821.Qm_Mk-Rah%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yu Zhao <yuzhao@google.com>
Subject: mm/swap.c: don't pass "enum lru_list" to trace_mm_lru_insertion()

The parameter is redundant in the sense that it can be extracted
from the "struct page" parameter by page_lru() correctly.

Link: https://lore.kernel.org/linux-mm/20201207220949.830352-5-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-5-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/pagemap.h |   11 ++++-------
 mm/swap.c                      |    5 +----
 2 files changed, 5 insertions(+), 11 deletions(-)

--- a/include/trace/events/pagemap.h~mm-dont-pass-enum-lru_list-to-trace_mm_lru_insertion
+++ a/include/trace/events/pagemap.h
@@ -27,24 +27,21 @@
 
 TRACE_EVENT(mm_lru_insertion,
 
-	TP_PROTO(
-		struct page *page,
-		int lru
-	),
+	TP_PROTO(struct page *page),
 
-	TP_ARGS(page, lru),
+	TP_ARGS(page),
 
 	TP_STRUCT__entry(
 		__field(struct page *,	page	)
 		__field(unsigned long,	pfn	)
-		__field(int,		lru	)
+		__field(enum lru_list,	lru	)
 		__field(unsigned long,	flags	)
 	),
 
 	TP_fast_assign(
 		__entry->page	= page;
 		__entry->pfn	= page_to_pfn(page);
-		__entry->lru	= lru;
+		__entry->lru	= page_lru(page);
 		__entry->flags	= trace_pagemap_flags(page);
 	),
 
--- a/mm/swap.c~mm-dont-pass-enum-lru_list-to-trace_mm_lru_insertion
+++ a/mm/swap.c
@@ -957,7 +957,6 @@ EXPORT_SYMBOL(__pagevec_release);
 
 static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec)
 {
-	enum lru_list lru;
 	int was_unevictable = TestClearPageUnevictable(page);
 	int nr_pages = thp_nr_pages(page);
 
@@ -993,11 +992,9 @@ static void __pagevec_lru_add_fn(struct
 	smp_mb__after_atomic();
 
 	if (page_evictable(page)) {
-		lru = page_lru(page);
 		if (was_unevictable)
 			__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
 	} else {
-		lru = LRU_UNEVICTABLE;
 		ClearPageActive(page);
 		SetPageUnevictable(page);
 		if (!was_unevictable)
@@ -1005,7 +1002,7 @@ static void __pagevec_lru_add_fn(struct
 	}
 
 	add_page_to_lru_list(page, lruvec);
-	trace_mm_lru_insertion(page, lru);
+	trace_mm_lru_insertion(page);
 }
 
 /*
_
