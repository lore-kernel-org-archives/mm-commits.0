Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D618AECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 22:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiIIWFe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 18:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiIIWFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 18:05:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A91A149961
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 15:04:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A2ABB82625
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 22:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5FAC433C1;
        Fri,  9 Sep 2022 22:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662761024;
        bh=R2Mf/WVZoDN6oMrO334bQ1WKqThAkf4b4XaAEEk3M8M=;
        h=Date:To:From:Subject:From;
        b=xnjJdUq0sHsLgFeqZT1KglmMovuxE3V8nHNlUURW4bSCLNZqG18MqF92SgLL3Xkwy
         vi48rtR0Qi0jrlkO/j/kYkbz2axiWKahlGD7PBoNmHMt4+JChPtn+oTZptvw+851p7
         CRHJNyKdLCn9SPERRSJBPDpgZUmuhCG7QDm7bA2I=
Date:   Fri, 09 Sep 2022 15:03:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mike.kravetz@oracle.com, lic121@chinatelecom.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-nth_page-instead-of-mem_map_offset-mem_map_next.patch added to mm-unstable branch
Message-Id: <20220909220344.CE5FAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use nth_page instead of mem_map_offset mem_map_next
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-nth_page-instead-of-mem_map_offset-mem_map_next.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-nth_page-instead-of-mem_map_offset-mem_map_next.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Cheng Li <lic121@chinatelecom.cn>
Subject: mm: use nth_page instead of mem_map_offset mem_map_next
Date: Fri, 9 Sep 2022 07:31:09 +0000

To handle the discontiguous case, mem_map_next() has a parameter named
`offset`.  As a function caller, one would be confused why "get next
entry" needs a parameter named "offset".  The other drawback of
mem_map_next() is that the callers must take care of the map between
parameter "iter" and "offset", otherwise we may get an hole or duplication
during iteration.  So we use nth_page instead of mem_map_next.

And replace mem_map_offset with nth_page() per Matthew's comments.

Link: https://lkml.kernel.org/r/1662708669-9395-1-git-send-email-lic121@chinatelecom.cn
Signed-off-by: Cheng Li <lic121@chinatelecom.cn>
Fixes: 69d177c2fc70 ("hugetlbfs: handle pages higher order than MAX_ORDER")
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |   29 +++++++++++++++++------------
 mm/internal.h |   28 ----------------------------
 mm/memory.c   |   21 ++++++++++-----------
 3 files changed, 27 insertions(+), 51 deletions(-)

--- a/mm/hugetlb.c~mm-use-nth_page-instead-of-mem_map_offset-mem_map_next
+++ a/mm/hugetlb.c
@@ -1307,12 +1307,13 @@ static void __destroy_compound_gigantic_
 {
 	int i;
 	int nr_pages = 1 << order;
-	struct page *p = page + 1;
+	struct page *p;
 
 	atomic_set(compound_mapcount_ptr(page), 0);
 	atomic_set(compound_pincount_ptr(page), 0);
 
-	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
+	for (i = 1; i < nr_pages; i++) {
+		p = nth_page(page, i);
 		p->mapping = NULL;
 		clear_compound_head(p);
 		if (!demote)
@@ -1533,7 +1534,7 @@ static void add_hugetlb_page(struct hsta
 static void __update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
-	struct page *subpage = page;
+	struct page *subpage;
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
@@ -1564,8 +1565,8 @@ static void __update_and_free_page(struc
 	if (unlikely(PageHWPoison(page)))
 		hugetlb_clear_page_hwpoison(page);
 
-	for (i = 0; i < pages_per_huge_page(h);
-	     i++, subpage = mem_map_next(subpage, page, i)) {
+	for (i = 0; i < pages_per_huge_page(h); i++) {
+		subpage = nth_page(page, i);
 		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
 				1 << PG_referenced | 1 << PG_dirty |
 				1 << PG_active | 1 << PG_private |
@@ -1772,13 +1773,15 @@ static bool __prep_compound_gigantic_pag
 {
 	int i, j;
 	int nr_pages = 1 << order;
-	struct page *p = page + 1;
+	struct page *p;
 
 	/* we rely on prep_new_huge_page to set the destructor */
 	set_compound_order(page, order);
 	__ClearPageReserved(page);
 	__SetPageHead(page);
-	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
+	for (i = 1; i < nr_pages; i++) {
+		p = nth_page(page, i);
+
 		/*
 		 * For gigantic hugepages allocated through bootmem at
 		 * boot, it's safer to be consistent with the not-gigantic
@@ -1825,14 +1828,16 @@ static bool __prep_compound_gigantic_pag
 
 out_error:
 	/* undo tail page modifications made above */
-	p = page + 1;
-	for (j = 1; j < i; j++, p = mem_map_next(p, page, j)) {
+	for (j = 1; j < i; j++) {
+		p = nth_page(page, j);
 		clear_compound_head(p);
 		set_page_refcounted(p);
 	}
 	/* need to clear PG_reserved on remaining tail pages  */
-	for (; j < nr_pages; j++, p = mem_map_next(p, page, j))
+	for (; j < nr_pages; j++) {
+		p = nth_page(page, j);
 		__ClearPageReserved(p);
+	}
 	set_compound_order(page, 0);
 #ifdef CONFIG_64BIT
 	page[1].compound_nr = 0;
@@ -6133,7 +6138,7 @@ static void record_subpages_vmas(struct
 
 	for (nr = 0; nr < refs; nr++) {
 		if (likely(pages))
-			pages[nr] = mem_map_offset(page, nr);
+			pages[nr] = nth_page(page, nr);
 		if (vmas)
 			vmas[nr] = vma;
 	}
@@ -6297,7 +6302,7 @@ long follow_hugetlb_page(struct mm_struc
 		    (vma->vm_end - ALIGN_DOWN(vaddr, PAGE_SIZE)) >> PAGE_SHIFT);
 
 		if (pages || vmas)
-			record_subpages_vmas(mem_map_offset(page, pfn_offset),
+			record_subpages_vmas(nth_page(page, pfn_offset),
 					     vma, refs,
 					     likely(pages) ? pages + i : NULL,
 					     vmas ? vmas + i : NULL);
--- a/mm/internal.h~mm-use-nth_page-instead-of-mem_map_offset-mem_map_next
+++ a/mm/internal.h
@@ -638,34 +638,6 @@ static inline void vunmap_range_noflush(
 }
 #endif /* !CONFIG_MMU */
 
-/*
- * Return the mem_map entry representing the 'offset' subpage within
- * the maximally aligned gigantic page 'base'.  Handle any discontiguity
- * in the mem_map at MAX_ORDER_NR_PAGES boundaries.
- */
-static inline struct page *mem_map_offset(struct page *base, int offset)
-{
-	if (unlikely(offset >= MAX_ORDER_NR_PAGES))
-		return nth_page(base, offset);
-	return base + offset;
-}
-
-/*
- * Iterator over all subpages within the maximally aligned gigantic
- * page 'base'.  Handle any discontiguity in the mem_map.
- */
-static inline struct page *mem_map_next(struct page *iter,
-						struct page *base, int offset)
-{
-	if (unlikely((offset & (MAX_ORDER_NR_PAGES - 1)) == 0)) {
-		unsigned long pfn = page_to_pfn(base) + offset;
-		if (!pfn_valid(pfn))
-			return NULL;
-		return pfn_to_page(pfn);
-	}
-	return iter + 1;
-}
-
 /* Memory initialisation debug and verification */
 enum mminit_level {
 	MMINIT_WARNING,
--- a/mm/memory.c~mm-use-nth_page-instead-of-mem_map_offset-mem_map_next
+++ a/mm/memory.c
@@ -5692,11 +5692,11 @@ static void clear_gigantic_page(struct p
 				unsigned int pages_per_huge_page)
 {
 	int i;
-	struct page *p = page;
+	struct page *p;
 
 	might_sleep();
-	for (i = 0; i < pages_per_huge_page;
-	     i++, p = mem_map_next(p, page, i)) {
+	for (i = 0; i < pages_per_huge_page; i++) {
+		p = nth_page(page, i);
 		cond_resched();
 		clear_user_highpage(p, addr + i * PAGE_SIZE);
 	}
@@ -5732,13 +5732,12 @@ static void copy_user_gigantic_page(stru
 	struct page *dst_base = dst;
 	struct page *src_base = src;
 
-	for (i = 0; i < pages_per_huge_page; ) {
+	for (i = 0; i < pages_per_huge_page; i++) {
+		dst = nth_page(dst_base, i);
+		src = nth_page(src_base, i);
+
 		cond_resched();
 		copy_user_highpage(dst, src, addr + i*PAGE_SIZE, vma);
-
-		i++;
-		dst = mem_map_next(dst, dst_base, i);
-		src = mem_map_next(src, src_base, i);
 	}
 }
 
@@ -5785,10 +5784,10 @@ long copy_huge_page_from_user(struct pag
 	void *page_kaddr;
 	unsigned long i, rc = 0;
 	unsigned long ret_val = pages_per_huge_page * PAGE_SIZE;
-	struct page *subpage = dst_page;
+	struct page *subpage;
 
-	for (i = 0; i < pages_per_huge_page;
-	     i++, subpage = mem_map_next(subpage, dst_page, i)) {
+	for (i = 0; i < pages_per_huge_page; i++) {
+		subpage = nth_page(dst_page, i);
 		if (allow_pagefault)
 			page_kaddr = kmap(subpage);
 		else
_

Patches currently in -mm which might be from lic121@chinatelecom.cn are

mm-use-nth_page-instead-of-mem_map_offset-mem_map_next.patch

