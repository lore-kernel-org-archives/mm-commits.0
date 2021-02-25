Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D688AC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BEFA64F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhBYTe4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:34:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:41172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235017AbhBYTcr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:32:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBFC264F97;
        Thu, 25 Feb 2021 19:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280669;
        bh=cPTdWyhLkosy948quLburevGoM95wm7NHUjq3eWHOiE=;
        h=Date:From:To:Subject:From;
        b=PKT5eUY8bXQbtC0yNG3NV0wibAPo1U4JPdPL3xJ53tkAMi6KSEWLRLATgcUJRUxXI
         5rlnIp3YxTzlQJJMIHwDvu0eJCQ5JKZHh7IZHFaGc9Fe/uFZGGF3gpTrsAcwk8YjRD
         3aK4Hf4fCm9Qfs2Az3/Io2JkC/UJtpmRpfdxWFOI=
Date:   Thu, 25 Feb 2021 11:17:48 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yuzhao@google.com
Subject:  [merged]
 mm-dont-pass-enum-lru_list-to-trace_mm_lru_insertion.patch removed from -mm
 tree
Message-ID: <20210225191748.U8QXCmluN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: don't pass "enum lru_list" to trace_mm_lru_insertion()
has been removed from the -mm tree.  Its filename was
     mm-dont-pass-enum-lru_list-to-trace_mm_lru_insertion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from yuzhao@google.com are


