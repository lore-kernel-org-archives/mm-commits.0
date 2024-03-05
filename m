Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24693101E6
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600563; cv=none; b=L/Scj1Arax1hEVqK6i66gBIKo/QhWcOoKcr1V/Dj/qGQ+FztAcmEk18uWkRdfRh8BtYPDb43lOfSbF9/6FprdUefvU5eTygJegPEOv1M2W0iengh8ikU8bSr7wqeO9oFOIf+zWWBR/Ce/hev4ORY3kwDJL9SILIl8sHjBs4TwCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600563; c=relaxed/simple;
	bh=TtIXLZ+GarGOOfGDJhICIHoiDzmIk7P9xyVyRIPjwgU=;
	h=Date:To:From:Subject:Message-Id; b=F4bqEqjYAAIMw6fBfevjr1LQ8cDTmn//5eY7QgFai6w/XKCe8kaaopDY7z9v6gyUCNx8J8qKe01834/QUk3pCFewfL7psE8qrVZhXawFJPN8nV2hLyqV16gCKVh/+oLhsIu23Att1js0Umq95qMwsriCiY6wC1KvhKaDiQPtYS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yllv2Gx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yllv2Gx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E594BC433F1;
	Tue,  5 Mar 2024 01:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600563;
	bh=TtIXLZ+GarGOOfGDJhICIHoiDzmIk7P9xyVyRIPjwgU=;
	h=Date:To:From:Subject:From;
	b=yllv2Gx+rvZsbUDwP5UiPdGIJuY6+jvqhb5zlWRbV49pITzPYjcClICILjmwddsHC
	 ztcrgV9DCFEKhFVSHlmPUsTmC1ysD7Fo+4qa0Zk4Q69pKlfT3ecakxKdn/cW/1Np6L
	 z68OD/7GctzUoNWvSQ273elLhLtc4qqhy7rQkk9k=
Date: Mon, 04 Mar 2024 17:02:42 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-free_unref_page_list-to-use-folios.patch removed from -mm tree
Message-Id: <20240305010242.E594BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert free_unref_page_list() to use folios
has been removed from the -mm tree.  Its filename was
     mm-convert-free_unref_page_list-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

