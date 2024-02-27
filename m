Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAC32557E
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059671; cv=none; b=t4jReiKz7g6UbzDWM8UE9BXsFB97ow330Mi+L/Spo0CPHpbAdswIG3Hp91gJyjr71tirfPBn7gKnO+untNdcDs8z3Zlb5Gx5kgEF526GwwMELq9USXKko6pq80lTho4l9qfq2nbAqyS7GYCa6eWIKhfRR0FMKuUA/Mja1vSXAxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059671; c=relaxed/simple;
	bh=V7R3kUezFJdAu0BgTMSnlKGoMNUCiTvyfIe0bkIK35I=;
	h=Date:To:From:Subject:Message-Id; b=MkpUTxXiF0Lrj77A6ZLexCMRVg8eIQ7yuu0gt27ELN8MhAr3uLQ2e269uMt6LlNwtqsWoG1z1S2Y8Oa0hq3jGaXvdu5eQKkMIgYd/J2qToP1+Rlee0CRMpbnXKH6zGxI4Uu9VvWu9DaR7SxH5B14OZs+2hK4MWRsUICXYWC5xHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q73wwgW5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q73wwgW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FEEC43390;
	Tue, 27 Feb 2024 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059671;
	bh=V7R3kUezFJdAu0BgTMSnlKGoMNUCiTvyfIe0bkIK35I=;
	h=Date:To:From:Subject:From;
	b=Q73wwgW5RSA7lBIOSMBtePfUDxLXl0gG9/obX8PPePvUrRCXH+fyzLrbfKNYpEStl
	 MQ0ORTu95ckZlLLzl9JHeLlRmJxB00S06UCRcfBnvryQmLa6UWI6/meqdNWnQ+H5H4
	 zyUSMsy8uXUl6OrG2BSlwxWOc2MluMZU+C5DVaUM=
Date: Tue, 27 Feb 2024 10:47:50 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-free_unref_folios.patch added to mm-unstable branch
Message-Id: <20240227184751.66FEEC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add free_unref_folios()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-free_unref_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-free_unref_folios.patch

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
@@ -541,8 +541,9 @@ extern bool free_pages_prepare(struct pa
 
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

