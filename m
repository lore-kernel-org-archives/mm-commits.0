Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADF21C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836916; cv=none; b=MBnzqKEasFP/bGP+vumLzPH7APW7O+AkhjgD3Dg6bX+hdpWXfMf5kYlVxGQ/l2z6b+miI2VSdghRq4iz7jIcWnw/BeKycn8vPmePR+WsezIi+NTuizNkt0/dDgkgYj895F9PhkYGG4cDi0kWPtjgZ4wleobPoH5MnrP5G18o1PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836916; c=relaxed/simple;
	bh=tXJIMckKAeDgRRa2MrRQXkcC2mg3+ViW+bysJAhIdTY=;
	h=Date:To:From:Subject:Message-Id; b=j/QKrBgDJv2h67C5Dao3ty/mJT2hxAPQG8BoAWizSZh+pblIw7Wo1d50uPnH4CTJNfE0apDhVBfovPK0HG718EZWqpSVbIR+ARdMaAC6/77GwgZs0iDWyy+bTAGwMd5Fa6H+5ol7FewMytnkuiShqgyitF6ztNplJmeetJeAb28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AwQdvOc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AwQdvOc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D16C4CEDD;
	Tue, 14 Jan 2025 06:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836916;
	bh=tXJIMckKAeDgRRa2MrRQXkcC2mg3+ViW+bysJAhIdTY=;
	h=Date:To:From:Subject:From;
	b=AwQdvOc6uSzVXdOinAsc6hulJOmQ0ITaEIuyYEaB0MzrIRltDiuLKa9igkfRp7QWn
	 NQF21PaMpqGRjPUw3NM+QKrK0e+8biEIkDc14KjyYiS/azxT8coFTmU1v9kktu7Qs3
	 tA+9cXqvE0OeZ8OhpIU4rRB0WNHuj31MsQkKvFU0=
Date: Mon, 13 Jan 2025 22:41:55 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,william.kucharski@oracle.com,vbabka@suse.cz,songmuchun@bytedance.com,mgorman@techsingularity.net,linmiaohe@huawei.com,david@redhat.com,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch removed from -mm tree
Message-Id: <20250114064155.E3D16C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: export free_frozen_pages() instead of free_unref_page()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/page_alloc: export free_frozen_pages() instead of free_unref_page()
Date: Mon, 25 Nov 2024 21:01:35 +0000

We already have the concept of "frozen pages" (eg page_ref_freeze()), so
let's not complicate things by also having the concept of "unref pages".

Link: https://lkml.kernel.org/r/20241125210149.2976098-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h        |    2 +-
 mm/page_alloc.c      |   18 +++++++++---------
 mm/page_frag_cache.c |    6 +++---
 mm/swap.c            |    2 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

--- a/mm/internal.h~mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page
+++ a/mm/internal.h
@@ -741,7 +741,7 @@ extern bool free_pages_prepare(struct pa
 
 extern int user_min_free_kbytes;
 
-void free_unref_page(struct page *page, unsigned int order);
+void free_frozen_pages(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
 
 extern void zone_pcp_reset(struct zone *zone);
--- a/mm/page_alloc.c~mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page
+++ a/mm/page_alloc.c
@@ -2592,9 +2592,9 @@ static int nr_pcp_high(struct per_cpu_pa
 	return high;
 }
 
-static void free_unref_page_commit(struct zone *zone, struct per_cpu_pages *pcp,
-				   struct page *page, int migratetype,
-				   unsigned int order)
+static void free_frozen_page_commit(struct zone *zone,
+		struct per_cpu_pages *pcp, struct page *page, int migratetype,
+		unsigned int order)
 {
 	int high, batch;
 	int pindex;
@@ -2643,7 +2643,7 @@ static void free_unref_page_commit(struc
 /*
  * Free a pcp page
  */
-void free_unref_page(struct page *page, unsigned int order)
+void free_frozen_pages(struct page *page, unsigned int order)
 {
 	unsigned long __maybe_unused UP_flags;
 	struct per_cpu_pages *pcp;
@@ -2679,7 +2679,7 @@ void free_unref_page(struct page *page,
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
-		free_unref_page_commit(zone, pcp, page, migratetype, order);
+		free_frozen_page_commit(zone, pcp, page, migratetype, order);
 		pcp_spin_unlock(pcp);
 	} else {
 		free_one_page(zone, page, pfn, order, FPI_NONE);
@@ -2743,7 +2743,7 @@ void free_unref_folios(struct folio_batc
 
 			/*
 			 * Free isolated pages directly to the
-			 * allocator, see comment in free_unref_page.
+			 * allocator, see comment in free_frozen_pages.
 			 */
 			if (is_migrate_isolate(migratetype)) {
 				free_one_page(zone, &folio->page, pfn,
@@ -2774,7 +2774,7 @@ void free_unref_folios(struct folio_batc
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(&folio->page);
-		free_unref_page_commit(zone, pcp, &folio->page, migratetype,
+		free_frozen_page_commit(zone, pcp, &folio->page, migratetype,
 				order);
 	}
 
@@ -4837,11 +4837,11 @@ void __free_pages(struct page *page, uns
 	struct alloc_tag *tag = pgalloc_tag_get(page);
 
 	if (put_page_testzero(page))
-		free_unref_page(page, order);
+		free_frozen_pages(page, order);
 	else if (!head) {
 		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
 		while (order-- > 0)
-			free_unref_page(page + (1 << order), order);
+			free_frozen_pages(page + (1 << order), order);
 	}
 }
 EXPORT_SYMBOL(__free_pages);
--- a/mm/page_frag_cache.c~mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page
+++ a/mm/page_frag_cache.c
@@ -86,7 +86,7 @@ void __page_frag_cache_drain(struct page
 	VM_BUG_ON_PAGE(page_ref_count(page) == 0, page);
 
 	if (page_ref_sub_and_test(page, count))
-		free_unref_page(page, compound_order(page));
+		free_frozen_pages(page, compound_order(page));
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);
 
@@ -138,7 +138,7 @@ refill:
 			goto refill;
 
 		if (unlikely(encoded_page_decode_pfmemalloc(encoded_page))) {
-			free_unref_page(page,
+			free_frozen_pages(page,
 					encoded_page_decode_order(encoded_page));
 			goto refill;
 		}
@@ -166,6 +166,6 @@ void page_frag_free(void *addr)
 	struct page *page = virt_to_head_page(addr);
 
 	if (unlikely(put_page_testzero(page)))
-		free_unref_page(page, compound_order(page));
+		free_frozen_pages(page, compound_order(page));
 }
 EXPORT_SYMBOL(page_frag_free);
--- a/mm/swap.c~mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page
+++ a/mm/swap.c
@@ -109,7 +109,7 @@ void __folio_put(struct folio *folio)
 	page_cache_release(folio);
 	folio_unqueue_deferred_split(folio);
 	mem_cgroup_uncharge(folio);
-	free_unref_page(&folio->page, folio_order(folio));
+	free_frozen_pages(&folio->page, folio_order(folio));
 }
 EXPORT_SYMBOL(__folio_put);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-pagetranstail.patch

