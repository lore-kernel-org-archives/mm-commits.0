Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86EA7C3DA7C
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 21:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbiL3Vwu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Dec 2022 16:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbiL3Vwq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Dec 2022 16:52:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307C11CFDE
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 13:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFB46B81D93
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 21:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B67C433D2;
        Fri, 30 Dec 2022 21:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672437162;
        bh=ttzKaSFI64PV68b0ekcZeRqOoPlsPh0v/EDpNZw+e2M=;
        h=Date:To:From:Subject:From;
        b=EfJf3oo/GGj4E1+PIiLTi7ypBREZZe/uGYjbDG83bQfPaBLSO/JtlaiWKppGBhxcO
         /Axp6N7zuYBpCi7CLZYc8132kLP8t7f1ZWuf/IvDAoUAGbuPSOaLH+4MjlS1l6UY1Q
         EEJuLqqnX0+ZUkJqz1wHD8ARD8kCTaWGF6Df+obE=
Date:   Fri, 30 Dec 2022 13:52:41 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-convert-damon_pa_-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20221230215242.74B67C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/paddr: convert damon_pa_*() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-convert-damon_pa_-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-convert-damon_pa_-to-use-a-folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/damon/paddr: convert damon_pa_*() to use a folio
Date: Fri, 30 Dec 2022 15:08:46 +0800

With damon_get_folio(), let's convert all the damon_pa_*() to use a folio.

Link: https://lkml.kernel.org/r/20221230070849.63358-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/paddr.c~mm-damon-paddr-convert-damon_pa_-to-use-a-folio
+++ a/mm/damon/paddr.c
@@ -33,17 +33,15 @@ static bool __damon_pa_mkold(struct foli
 
 static void damon_pa_mkold(unsigned long paddr)
 {
-	struct folio *folio;
-	struct page *page = damon_get_page(PHYS_PFN(paddr));
+	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	struct rmap_walk_control rwc = {
 		.rmap_one = __damon_pa_mkold,
 		.anon_lock = folio_lock_anon_vma_read,
 	};
 	bool need_lock;
 
-	if (!page)
+	if (!folio)
 		return;
-	folio = page_folio(page);
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
 		folio_set_idle(folio);
@@ -122,8 +120,7 @@ static bool __damon_pa_young(struct foli
 
 static bool damon_pa_young(unsigned long paddr, unsigned long *page_sz)
 {
-	struct folio *folio;
-	struct page *page = damon_get_page(PHYS_PFN(paddr));
+	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	struct damon_pa_access_chk_result result = {
 		.page_sz = PAGE_SIZE,
 		.accessed = false,
@@ -135,9 +132,8 @@ static bool damon_pa_young(unsigned long
 	};
 	bool need_lock;
 
-	if (!page)
+	if (!folio)
 		return false;
-	folio = page_folio(page);
 
 	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
 		if (folio_test_idle(folio))
@@ -203,18 +199,18 @@ static unsigned int damon_pa_check_acces
 }
 
 static bool __damos_pa_filter_out(struct damos_filter *filter,
-		struct page *page)
+		struct folio *folio)
 {
 	bool matched = false;
 	struct mem_cgroup *memcg;
 
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_ANON:
-		matched = PageAnon(page);
+		matched = folio_test_anon(folio);
 		break;
 	case DAMOS_FILTER_TYPE_MEMCG:
 		rcu_read_lock();
-		memcg = page_memcg_check(page);
+		memcg = folio_memcg_check(folio);
 		if (!memcg)
 			matched = false;
 		else
@@ -231,12 +227,12 @@ static bool __damos_pa_filter_out(struct
 /*
  * damos_pa_filter_out - Return true if the page should be filtered out.
  */
-static bool damos_pa_filter_out(struct damos *scheme, struct page *page)
+static bool damos_pa_filter_out(struct damos *scheme, struct folio *folio)
 {
 	struct damos_filter *filter;
 
 	damos_for_each_filter(filter, scheme) {
-		if (__damos_pa_filter_out(filter, page))
+		if (__damos_pa_filter_out(filter, folio))
 			return true;
 	}
 	return false;
@@ -245,33 +241,33 @@ static bool damos_pa_filter_out(struct d
 static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s)
 {
 	unsigned long addr, applied;
-	LIST_HEAD(page_list);
+	LIST_HEAD(folio_list);
 
 	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
-		struct page *page = damon_get_page(PHYS_PFN(addr));
+		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
 
-		if (!page)
+		if (!folio)
 			continue;
 
-		if (damos_pa_filter_out(s, page)) {
-			put_page(page);
+		if (damos_pa_filter_out(s, folio)) {
+			folio_put(folio);
 			continue;
 		}
 
-		ClearPageReferenced(page);
-		test_and_clear_page_young(page);
-		if (isolate_lru_page(page)) {
-			put_page(page);
+		folio_clear_referenced(folio);
+		folio_test_clear_young(folio);
+		if (folio_isolate_lru(folio)) {
+			folio_put(folio);
 			continue;
 		}
-		if (PageUnevictable(page)) {
-			putback_lru_page(page);
+		if (folio_test_unevictable(folio)) {
+			folio_putback_lru(folio);
 		} else {
-			list_add(&page->lru, &page_list);
-			put_page(page);
+			list_add(&folio->lru, &folio_list);
+			folio_put(folio);
 		}
 	}
-	applied = reclaim_pages(&page_list);
+	applied = reclaim_pages(&folio_list);
 	cond_resched();
 	return applied * PAGE_SIZE;
 }
@@ -282,14 +278,12 @@ static inline unsigned long damon_pa_mar
 	unsigned long addr, applied = 0;
 
 	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
-		struct page *page = damon_get_page(PHYS_PFN(addr));
-		struct folio *folio;
+		struct folio *folio = damon_get_folio(PHYS_PFN(addr));
 
-		if (!page)
+		if (!folio)
 			continue;
-		folio = page_folio(page);
 
-		if (damos_pa_filter_out(s, &folio->page)) {
+		if (damos_pa_filter_out(s, folio)) {
 			folio_put(folio);
 			continue;
 		}
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch
mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch
mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio.patch
mm-page_idle-convert-page-idle-to-use-a-folio.patch
mm-damon-introduce-damon_get_folio.patch
mm-damon-convert-damon_ptep-pmdp_mkold-to-use-a-folio.patch
mm-damon-paddr-convert-damon_pa_-to-use-a-folio.patch
mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-a-folio.patch
mm-damon-remove-unneeded-damon_get_page.patch
mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio.patch

