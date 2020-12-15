Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D62C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13C59224B2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgLODOL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727725AbgLODNm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:42 -0500
Date:   Mon, 14 Dec 2020 19:12:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001980;
        bh=a2/fza+QoE1VuIH7oUPRY7Ffw2yPzb/srsPPT8bMW/s=;
        h=From:To:Subject:In-Reply-To:From;
        b=lTIekurTdKWksDqjn3H8OeXFZCZQawE6ZSwusM/3XfbHn8apx5OtAx4pt2b5b9tn8
         QrMriaJohby7fw06Rcylkh7xgzfLoPgPZzQnE4SAm6T7n8MxiULb263ILYxEHLccFq
         +Fdtnl2gtEJ+UNDKtTrjWjrKGKd4MUw1tD4qKkcw=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jack@suse.cz, linux-mm@kvack.org,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        naresh.kamboju@linaro.org, shy828301@gmail.com,
        songliubraving@fb.com, torvalds@linux-foundation.org,
        willy@infradead.org, ziy@nvidia.com
Subject:  [patch 165/200] mm: support THPs in zero_user_segments
Message-ID: <20201215031259.TbwPkPJjP%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: support THPs in zero_user_segments

We can only kmap() one subpage of a THP at a time, so loop over all
relevant subpages, skipping ones which don't need to be zeroed.  This is
too large to inline when THPs are enabled and we actually need highmem, so
put it in highmem.c.

[willy@infradead.org: start1 was allowed to be less than start2]
Link: https://lkml.kernel.org/r/20201124041507.28996-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |   19 ++++++++++---
 mm/highmem.c            |   52 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 4 deletions(-)

--- a/include/linux/highmem.h~mm-support-thps-in-zero_user_segments
+++ a/include/linux/highmem.h
@@ -284,13 +284,22 @@ static inline void clear_highpage(struct
 	kunmap_atomic(kaddr);
 }
 
+/*
+ * If we pass in a base or tail page, we can zero up to PAGE_SIZE.
+ * If we pass in a head page, we can zero up to the size of the compound page.
+ */
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+void zero_user_segments(struct page *page, unsigned start1, unsigned end1,
+		unsigned start2, unsigned end2);
+#else /* !HIGHMEM || !TRANSPARENT_HUGEPAGE */
 static inline void zero_user_segments(struct page *page,
-	unsigned start1, unsigned end1,
-	unsigned start2, unsigned end2)
+		unsigned start1, unsigned end1,
+		unsigned start2, unsigned end2)
 {
 	void *kaddr = kmap_atomic(page);
+	unsigned int i;
 
-	BUG_ON(end1 > PAGE_SIZE || end2 > PAGE_SIZE);
+	BUG_ON(end1 > page_size(page) || end2 > page_size(page));
 
 	if (end1 > start1)
 		memset(kaddr + start1, 0, end1 - start1);
@@ -299,8 +308,10 @@ static inline void zero_user_segments(st
 		memset(kaddr + start2, 0, end2 - start2);
 
 	kunmap_atomic(kaddr);
-	flush_dcache_page(page);
+	for (i = 0; i < compound_nr(page); i++)
+		flush_dcache_page(page + i);
 }
+#endif /* !HIGHMEM || !TRANSPARENT_HUGEPAGE */
 
 static inline void zero_user_segment(struct page *page,
 	unsigned start, unsigned end)
--- a/mm/highmem.c~mm-support-thps-in-zero_user_segments
+++ a/mm/highmem.c
@@ -369,6 +369,58 @@ void kunmap_high(struct page *page)
 }
 
 EXPORT_SYMBOL(kunmap_high);
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void zero_user_segments(struct page *page, unsigned start1, unsigned end1,
+		unsigned start2, unsigned end2)
+{
+	unsigned int i;
+
+	BUG_ON(end1 > page_size(page) || end2 > page_size(page));
+
+	for (i = 0; i < compound_nr(page); i++) {
+		void *kaddr = NULL;
+
+		if (start1 < PAGE_SIZE || start2 < PAGE_SIZE)
+			kaddr = kmap_atomic(page + i);
+
+		if (start1 >= PAGE_SIZE) {
+			start1 -= PAGE_SIZE;
+			end1 -= PAGE_SIZE;
+		} else {
+			unsigned this_end = min_t(unsigned, end1, PAGE_SIZE);
+
+			if (end1 > start1)
+				memset(kaddr + start1, 0, this_end - start1);
+			end1 -= this_end;
+			start1 = 0;
+		}
+
+		if (start2 >= PAGE_SIZE) {
+			start2 -= PAGE_SIZE;
+			end2 -= PAGE_SIZE;
+		} else {
+			unsigned this_end = min_t(unsigned, end2, PAGE_SIZE);
+
+			if (end2 > start2)
+				memset(kaddr + start2, 0, this_end - start2);
+			end2 -= this_end;
+			start2 = 0;
+		}
+
+		if (kaddr) {
+			kunmap_atomic(kaddr);
+			flush_dcache_page(page + i);
+		}
+
+		if (!end1 && !end2)
+			break;
+	}
+
+	BUG_ON((start1 | start2 | end1 | end2) != 0);
+}
+EXPORT_SYMBOL(zero_user_segments);
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif	/* CONFIG_HIGHMEM */
 
 #if defined(HASHED_PAGE_VIRTUAL)
_
