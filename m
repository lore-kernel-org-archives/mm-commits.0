Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7357C678DB
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjASBUR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjASBSf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B442D6C558
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00219B81FBD
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987D0C433F0;
        Thu, 19 Jan 2023 01:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090956;
        bh=eaCWpWQPWeYwmH7bTWM9tLvCKi7cRvBZ7g9/ITtp228=;
        h=Date:To:From:Subject:From;
        b=tAqkguHa0CvCzTlOkisbSelo9U6CAd+ikVFwMYj20H8W6YQiW7tBeetRE+NfEaj0C
         gHAoc2t6eBMD6x48gC9n/ZQupSX0fHw/BrYDOjIgDz+QzNWoaTMndyOVnqv5n5SVYn
         YkU6Gn7g0+IpePLWKVIPxSDzjSW9B3hxkbD9j/HM=
Date:   Wed, 18 Jan 2023 17:15:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-paddr-convert-damon_pa_-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230119011556.987D0C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/paddr: convert damon_pa_*() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-damon-paddr-convert-damon_pa_-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 mm/damon/paddr.c |   58 ++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

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
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

