Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF362557E
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059670; cv=none; b=jYpbB8xLWe/CVd3rD4VeKtmlDQaO5z8rK4uDwHrgtPnzYFT4iQjpQxCow1vtzT9reVnH5xKXjSq4BJ0O7xu+Kj9hvzf7v2fPGKXpnvP/t5EnvVjSkk3H0qt4p/qEmnarNYRjvPbS8vopPnJOq8KOa5oQyL6sCxNhnvC2ikRAu+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059670; c=relaxed/simple;
	bh=5fmyKNy8mE/vUt/qjC6fRanEzHtNV+7BhDv7gaCTJFg=;
	h=Date:To:From:Subject:Message-Id; b=oL6/fBJXVOY3vxPEl23qBebvT+clwKFkNVilHcQjbni6jWSg08nagiggJ2jgYrsLRbbv2IQWsOE6hyM5yjfZGmGOSJsEVbsR+5VUtnzRiwEJhie0xfSX+eE4SMUGeJ3Q7uLTQIiolXErH7A0V8/r+vQp7BcEsMy5Tc5CJzcvuG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aoUTkL0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aoUTkL0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4813C43390;
	Tue, 27 Feb 2024 18:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059670;
	bh=5fmyKNy8mE/vUt/qjC6fRanEzHtNV+7BhDv7gaCTJFg=;
	h=Date:To:From:Subject:From;
	b=aoUTkL0gRP/khgx36CZRmG/Kc19eWhOxp+rusZigJNKHvVgW5DifP9bJUkLTR3Vco
	 8ekywIxv1fGnYg3ps5SKBPGxmdJvZEAQIYSEGQcEFngVCDaVsl/aFc2dQYN+JaDOOh
	 8rh8MgcXlEnfQgOhaLq2Z/fGovv+eu3656WH6D2E=
Date: Tue, 27 Feb 2024 10:47:49 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-free_unref_page_list-to-use-folios.patch added to mm-unstable branch
Message-Id: <20240227184749.E4813C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert free_unref_page_list() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-free_unref_page_list-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-free_unref_page_list-to-use-folios.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert free_unref_page_list() to use folios
Date: Tue, 27 Feb 2024 17:42:36 +0000

Most of its callees are not yet ready to accept a folio, but we know all
of the pages passed in are actually folios because they're linked through
->lru.

Link: https://lkml.kernel.org/r/20240227174254.710559-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/mm/page_alloc.c~mm-convert-free_unref_page_list-to-use-folios
+++ a/mm/page_alloc.c
@@ -2520,17 +2520,17 @@ void free_unref_page(struct page *page,
 void free_unref_page_list(struct list_head *list)
 {
 	unsigned long __maybe_unused UP_flags;
-	struct page *page, *next;
+	struct folio *folio, *next;
 	struct per_cpu_pages *pcp = NULL;
 	struct zone *locked_zone = NULL;
 	int batch_count = 0;
 	int migratetype;
 
 	/* Prepare pages for freeing */
-	list_for_each_entry_safe(page, next, list, lru) {
-		unsigned long pfn = page_to_pfn(page);
-		if (!free_unref_page_prepare(page, pfn, 0)) {
-			list_del(&page->lru);
+	list_for_each_entry_safe(folio, next, list, lru) {
+		unsigned long pfn = folio_pfn(folio);
+		if (!free_unref_page_prepare(&folio->page, pfn, 0)) {
+			list_del(&folio->lru);
 			continue;
 		}
 
@@ -2538,24 +2538,25 @@ void free_unref_page_list(struct list_he
 		 * Free isolated pages directly to the allocator, see
 		 * comment in free_unref_page.
 		 */
-		migratetype = get_pcppage_migratetype(page);
+		migratetype = get_pcppage_migratetype(&folio->page);
 		if (unlikely(is_migrate_isolate(migratetype))) {
-			list_del(&page->lru);
-			free_one_page(page_zone(page), page, pfn, 0, migratetype, FPI_NONE);
+			list_del(&folio->lru);
+			free_one_page(folio_zone(folio), &folio->page, pfn,
+					0, migratetype, FPI_NONE);
 			continue;
 		}
 	}
 
-	list_for_each_entry_safe(page, next, list, lru) {
-		struct zone *zone = page_zone(page);
+	list_for_each_entry_safe(folio, next, list, lru) {
+		struct zone *zone = folio_zone(folio);
 
-		list_del(&page->lru);
-		migratetype = get_pcppage_migratetype(page);
+		list_del(&folio->lru);
+		migratetype = get_pcppage_migratetype(&folio->page);
 
 		/*
 		 * Either different zone requiring a different pcp lock or
 		 * excessive lock hold times when freeing a large list of
-		 * pages.
+		 * folios.
 		 */
 		if (zone != locked_zone || batch_count == SWAP_CLUSTER_MAX) {
 			if (pcp) {
@@ -2566,15 +2567,16 @@ void free_unref_page_list(struct list_he
 			batch_count = 0;
 
 			/*
-			 * trylock is necessary as pages may be getting freed
+			 * trylock is necessary as folios may be getting freed
 			 * from IRQ or SoftIRQ context after an IO completion.
 			 */
 			pcp_trylock_prepare(UP_flags);
 			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 			if (unlikely(!pcp)) {
 				pcp_trylock_finish(UP_flags);
-				free_one_page(zone, page, page_to_pfn(page),
-					      0, migratetype, FPI_NONE);
+				free_one_page(zone, &folio->page,
+						folio_pfn(folio), 0,
+						migratetype, FPI_NONE);
 				locked_zone = NULL;
 				continue;
 			}
@@ -2588,8 +2590,8 @@ void free_unref_page_list(struct list_he
 		if (unlikely(migratetype >= MIGRATE_PCPTYPES))
 			migratetype = MIGRATE_MOVABLE;
 
-		trace_mm_page_free_batched(page);
-		free_unref_page_commit(zone, pcp, page, migratetype, 0);
+		trace_mm_page_free_batched(&folio->page);
+		free_unref_page_commit(zone, pcp, &folio->page, migratetype, 0);
 		batch_count++;
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch

