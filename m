Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D91AC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 412662087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817532;
	bh=3BA0Ii63ANDUuv4mX0H+Tu/qgAN26ZS7Uvm0pBPs3nY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=THtdlh0Mhnqvn7kKKRDOBmq1A1BizcIhfA2KEwV5SQZHR1dUkNA1N83vrZ4hqA1GV
	 pjL5WApAWa+wQF3hya/KwEfpc4JR4ybd3QAM7kK+0d2R+5K7wzQCCQ1AtlGdPcX2Ye
	 yPY7/L7uOdjWr5xDATjit17/LPhOZcuNQKz0icG0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393938AbgJPDFb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbgJPDFb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:05:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 562FA20789;
        Fri, 16 Oct 2020 03:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817530;
        bh=3BA0Ii63ANDUuv4mX0H+Tu/qgAN26ZS7Uvm0pBPs3nY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OWA6vjrTSRRlmJGJMgGaJcqwH3XlJekB9XheEixz39JbrxggkT6UU6PqAAr4MVKsA
         466/ECWE4/ClS7UR9iRdNgHaXb3aMgBKa1p4V5pWz/cu35UfRVQk2C8v7TBVkycTQg
         Lb2H0bsAEpFj8LqydqYvMkbhkLAB3dkL6W6CAkzU=
Date:   Thu, 15 Oct 2020 20:05:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 021/156] mm/page_owner: change split_page_owner to
 take a count
Message-ID: <20201016030529.QOyrET_qx%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_owner: change split_page_owner to take a count

The implementation of split_page_owner() prefers a count rather than the
old order of the page.  When we support a variable size THP, we won't
have the order at this point, but we will have the number of pages.
So change the interface to what the caller and callee would prefer.

Link: https://lkml.kernel.org/r/20200908195539.25896-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: SeongJae Park <sjpark@amazon.de>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |    6 +++---
 mm/huge_memory.c           |    2 +-
 mm/page_owner.c            |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/page_owner.h~mm-page_owner-change-split_page_owner-to-take-a-count
+++ a/include/linux/page_owner.h
@@ -11,7 +11,7 @@ extern struct page_ext_operations page_o
 extern void __reset_page_owner(struct page *page, unsigned int order);
 extern void __set_page_owner(struct page *page,
 			unsigned int order, gfp_t gfp_mask);
-extern void __split_page_owner(struct page *page, unsigned int order);
+extern void __split_page_owner(struct page *page, unsigned int nr);
 extern void __copy_page_owner(struct page *oldpage, struct page *newpage);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 extern void __dump_page_owner(struct page *page);
@@ -31,10 +31,10 @@ static inline void set_page_owner(struct
 		__set_page_owner(page, order, gfp_mask);
 }
 
-static inline void split_page_owner(struct page *page, unsigned int order)
+static inline void split_page_owner(struct page *page, unsigned int nr)
 {
 	if (static_branch_unlikely(&page_owner_inited))
-		__split_page_owner(page, order);
+		__split_page_owner(page, nr);
 }
 static inline void copy_page_owner(struct page *oldpage, struct page *newpage)
 {
--- a/mm/huge_memory.c~mm-page_owner-change-split_page_owner-to-take-a-count
+++ a/mm/huge_memory.c
@@ -2454,7 +2454,7 @@ static void __split_huge_page(struct pag
 
 	ClearPageCompound(head);
 
-	split_page_owner(head, HPAGE_PMD_ORDER);
+	split_page_owner(head, HPAGE_PMD_NR);
 
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
--- a/mm/page_owner.c~mm-page_owner-change-split_page_owner-to-take-a-count
+++ a/mm/page_owner.c
@@ -204,7 +204,7 @@ void __set_page_owner_migrate_reason(str
 	page_owner->last_migrate_reason = reason;
 }
 
-void __split_page_owner(struct page *page, unsigned int order)
+void __split_page_owner(struct page *page, unsigned int nr)
 {
 	int i;
 	struct page_ext *page_ext = lookup_page_ext(page);
@@ -213,7 +213,7 @@ void __split_page_owner(struct page *pag
 	if (unlikely(!page_ext))
 		return;
 
-	for (i = 0; i < (1 << order); i++) {
+	for (i = 0; i < nr; i++) {
 		page_owner = get_page_owner(page_ext);
 		page_owner->order = 0;
 		page_ext = page_ext_next(page_ext);
_
