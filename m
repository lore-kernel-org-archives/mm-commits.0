Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2465E101CF
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600564; cv=none; b=nBdQPHwIoi8kbWHS/7J/6vU/JOgZDtQFmY5OkR0MZVdfpJHpJcv/jBhIv+U6xCfHhh8oF5RR6JkriShkzPDblTk4ZjRzt7RKBxcuhCDhEdZY//XORtck2OJ2xDWoPFW1UCvWHQjpDKDWxoG0qVKL4TqLfvqddvCaKdhuvdkJf1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600564; c=relaxed/simple;
	bh=wpK0HPQDbmtikOSovidOmzJsC6GQjR3rhgz4NQaMoD4=;
	h=Date:To:From:Subject:Message-Id; b=U0LqDQgVgTrxYWzLYwlE0spbKywZIRGDMOqhAy1ueetN3OBAXMXIEheJWtS//ybJbtd0mE6TR76pRFGjeIqY+HrQghsREZOCIJJ4eT4xfXanGdr1LHtBxgLR/4RVmaYLEjcV55MlsLjIP0ruA7/bqqFuqU7pYhiGq1lOxd2Ki8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SNYITQvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SNYITQvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA9BC43394;
	Tue,  5 Mar 2024 01:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600564;
	bh=wpK0HPQDbmtikOSovidOmzJsC6GQjR3rhgz4NQaMoD4=;
	h=Date:To:From:Subject:From;
	b=SNYITQvDdXDTHAOM8MYD1cE9G+VORPnbWbV00eHXw/BBvL94Q0xgt8XST6aLgHjNs
	 L7xTy8YO9uIY0qix5DZu9j9Bnu3k1UICz81olUnTmUGydiyhVq21OyGi7RdeDlu3nF
	 jhpX6DrV0DXlBoSRjJeHLDsxuluqfZlZfyyIzpzg=
Date: Mon, 04 Mar 2024 17:02:43 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-free_unref_folios.patch removed from -mm tree
Message-Id: <20240305010243.EDA9BC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add free_unref_folios()
has been removed from the -mm tree.  Its filename was
     mm-add-free_unref_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add free_unref_folios()
Date: Tue, 27 Feb 2024 17:42:37 +0000

Iterate over a folio_batch rather than a linked list.  This is easier for
the CPU to prefetch and has a batch count naturally built in so we don't
need to track it.  Again, this lowers the maximum lock hold time from
32 folios to 15, but I do not expect this to have a significant effect.

Link: https://lkml.kernel.org/r/20240227174254.710559-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    5 ++-
 mm/page_alloc.c |   59 ++++++++++++++++++++++++++++------------------
 2 files changed, 39 insertions(+), 25 deletions(-)

--- a/mm/internal.h~mm-add-free_unref_folios
+++ a/mm/internal.h
@@ -451,8 +451,9 @@ extern bool free_pages_prepare(struct pa
 
 extern int user_min_free_kbytes;
 
-extern void free_unref_page(struct page *page, unsigned int order);
-extern void free_unref_page_list(struct list_head *list);
+void free_unref_page(struct page *page, unsigned int order);
+void free_unref_folios(struct folio_batch *fbatch);
+void free_unref_page_list(struct list_head *list);
 
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
--- a/mm/page_alloc.c~mm-add-free_unref_folios
+++ a/mm/page_alloc.c
@@ -32,6 +32,7 @@
 #include <linux/sysctl.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
+#include <linux/pagevec.h>
 #include <linux/memory_hotplug.h>
 #include <linux/nodemask.h>
 #include <linux/vmstat.h>
@@ -2515,57 +2516,51 @@ void free_unref_page(struct page *page,
 }
 
 /*
- * Free a list of 0-order pages
+ * Free a batch of 0-order pages
  */
-void free_unref_page_list(struct list_head *list)
+void free_unref_folios(struct folio_batch *folios)
 {
 	unsigned long __maybe_unused UP_flags;
-	struct folio *folio, *next;
 	struct per_cpu_pages *pcp = NULL;
 	struct zone *locked_zone = NULL;
-	int batch_count = 0;
-	int migratetype;
+	int i, j, migratetype;
 
-	/* Prepare pages for freeing */
-	list_for_each_entry_safe(folio, next, list, lru) {
+	/* Prepare folios for freeing */
+	for (i = 0, j = 0; i < folios->nr; i++) {
+		struct folio *folio = folios->folios[i];
 		unsigned long pfn = folio_pfn(folio);
-		if (!free_unref_page_prepare(&folio->page, pfn, 0)) {
-			list_del(&folio->lru);
+		if (!free_unref_page_prepare(&folio->page, pfn, 0))
 			continue;
-		}
 
 		/*
-		 * Free isolated pages directly to the allocator, see
+		 * Free isolated folios directly to the allocator, see
 		 * comment in free_unref_page.
 		 */
 		migratetype = get_pcppage_migratetype(&folio->page);
 		if (unlikely(is_migrate_isolate(migratetype))) {
-			list_del(&folio->lru);
 			free_one_page(folio_zone(folio), &folio->page, pfn,
 					0, migratetype, FPI_NONE);
 			continue;
 		}
+		if (j != i)
+			folios->folios[j] = folio;
+		j++;
 	}
+	folios->nr = j;
 
-	list_for_each_entry_safe(folio, next, list, lru) {
+	for (i = 0; i < folios->nr; i++) {
+		struct folio *folio = folios->folios[i];
 		struct zone *zone = folio_zone(folio);
 
-		list_del(&folio->lru);
 		migratetype = get_pcppage_migratetype(&folio->page);
 
-		/*
-		 * Either different zone requiring a different pcp lock or
-		 * excessive lock hold times when freeing a large list of
-		 * folios.
-		 */
-		if (zone != locked_zone || batch_count == SWAP_CLUSTER_MAX) {
+		/* Different zone requires a different pcp lock */
+		if (zone != locked_zone) {
 			if (pcp) {
 				pcp_spin_unlock(pcp);
 				pcp_trylock_finish(UP_flags);
 			}
 
-			batch_count = 0;
-
 			/*
 			 * trylock is necessary as folios may be getting freed
 			 * from IRQ or SoftIRQ context after an IO completion.
@@ -2592,13 +2587,31 @@ void free_unref_page_list(struct list_he
 
 		trace_mm_page_free_batched(&folio->page);
 		free_unref_page_commit(zone, pcp, &folio->page, migratetype, 0);
-		batch_count++;
 	}
 
 	if (pcp) {
 		pcp_spin_unlock(pcp);
 		pcp_trylock_finish(UP_flags);
 	}
+	folio_batch_reinit(folios);
+}
+
+void free_unref_page_list(struct list_head *list)
+{
+	struct folio_batch fbatch;
+
+	folio_batch_init(&fbatch);
+	while (!list_empty(list)) {
+		struct folio *folio = list_first_entry(list, struct folio, lru);
+
+		list_del(&folio->lru);
+		if (folio_batch_add(&fbatch, folio) > 0)
+			continue;
+		free_unref_folios(&fbatch);
+	}
+
+	if (fbatch.nr)
+		free_unref_folios(&fbatch);
 }
 
 /*
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

