Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5320D2557E
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059682; cv=none; b=L95/VU5TkcTlSJEQrHroRkxHB22ezxDMo0hUmBhR21xmHp57aiKCK4bhgqLuI4vrmD6KDWfE7FLS5u7VYvpqeTwRM0Z2a/hZQkZPliL+uSHHRJKqW72w9erfKoUVWNLYfdnPLhOFFq3mIFeaEzjpsU/yaCZ+iohdZFyW7ynjkRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059682; c=relaxed/simple;
	bh=ULMntp6Q4eWpV2yFg/D0iIe7U5XKiGljKziI6Zgx+XU=;
	h=Date:To:From:Subject:Message-Id; b=lL6B1KPLktDoKRFptv1kzpb8JUajNI01YV4Ey2YZYXUC8qYYmuKFTHnyEbvg+XE98vV3V/gF99AjLgeo/Jj9vP5x/dhC14S2x4GCm6hD+x7yRYIuZNOLspOGuXwLNLtzbEdNpheo3xQuoq6laUlkXJmUo0ROd/Lr0Hu1g2CC5no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tcv93buW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tcv93buW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B50C433F1;
	Tue, 27 Feb 2024 18:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059682;
	bh=ULMntp6Q4eWpV2yFg/D0iIe7U5XKiGljKziI6Zgx+XU=;
	h=Date:To:From:Subject:From;
	b=Tcv93buWaaxdahq5lp+m9inC+CfKj+eDnVpy3RtHnIa08/xeqpOA323Ce9FPCCpA6
	 ToNxjUjsG7k9DD3sS8Z+OkO50MuziQjh6VxsAsWkrQMYqHMjzNn1n1a3GVOV6agHH2
	 bNzwgHR4ytyvPmN0+tpySJGYLzS/a8yiv+6kHZlY=
Date: Tue, 27 Feb 2024 10:47:59 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-large-folios-in-free_unref_folios.patch added to mm-unstable branch
Message-Id: <20240227184802.04B50C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: handle large folios in free_unref_folios()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-handle-large-folios-in-free_unref_folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-handle-large-folios-in-free_unref_folios.patch

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
Subject: mm: handle large folios in free_unref_folios()
Date: Tue, 27 Feb 2024 17:42:43 +0000

Call folio_undo_large_rmappable() if needed.  free_unref_page_prepare()
destroys the ability to call folio_order(), so stash the order in
folio->private for the benefit of the second loop.

Link: https://lkml.kernel.org/r/20240227174254.710559-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/mm/page_alloc.c~mm-handle-large-folios-in-free_unref_folios
+++ a/mm/page_alloc.c
@@ -2516,7 +2516,7 @@ void free_unref_page(struct page *page,
 }
 
 /*
- * Free a batch of 0-order pages
+ * Free a batch of folios
  */
 void free_unref_folios(struct folio_batch *folios)
 {
@@ -2529,19 +2529,25 @@ void free_unref_folios(struct folio_batc
 	for (i = 0, j = 0; i < folios->nr; i++) {
 		struct folio *folio = folios->folios[i];
 		unsigned long pfn = folio_pfn(folio);
-		if (!free_unref_page_prepare(&folio->page, pfn, 0))
+		unsigned int order = folio_order(folio);
+
+		if (order > 0 && folio_test_large_rmappable(folio))
+			folio_undo_large_rmappable(folio);
+		if (!free_unref_page_prepare(&folio->page, pfn, order))
 			continue;
 
 		/*
-		 * Free isolated folios directly to the allocator, see
-		 * comment in free_unref_page.
+		 * Free isolated folios and orders not handled on the PCP
+		 * directly to the allocator, see comment in free_unref_page.
 		 */
 		migratetype = get_pcppage_migratetype(&folio->page);
-		if (unlikely(is_migrate_isolate(migratetype))) {
+		if (!pcp_allowed_order(order) ||
+		    is_migrate_isolate(migratetype)) {
 			free_one_page(folio_zone(folio), &folio->page, pfn,
-					0, migratetype, FPI_NONE);
+					order, migratetype, FPI_NONE);
 			continue;
 		}
+		folio->private = (void *)(unsigned long)order;
 		if (j != i)
 			folios->folios[j] = folio;
 		j++;
@@ -2551,7 +2557,9 @@ void free_unref_folios(struct folio_batc
 	for (i = 0; i < folios->nr; i++) {
 		struct folio *folio = folios->folios[i];
 		struct zone *zone = folio_zone(folio);
+		unsigned int order = (unsigned long)folio->private;
 
+		folio->private = NULL;
 		migratetype = get_pcppage_migratetype(&folio->page);
 
 		/* Different zone requires a different pcp lock */
@@ -2570,7 +2578,7 @@ void free_unref_folios(struct folio_batc
 			if (unlikely(!pcp)) {
 				pcp_trylock_finish(UP_flags);
 				free_one_page(zone, &folio->page,
-						folio_pfn(folio), 0,
+						folio_pfn(folio), order,
 						migratetype, FPI_NONE);
 				locked_zone = NULL;
 				continue;
@@ -2586,7 +2594,8 @@ void free_unref_folios(struct folio_batc
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(&folio->page);
-		free_unref_page_commit(zone, pcp, &folio->page, migratetype, 0);
+		free_unref_page_commit(zone, pcp, &folio->page, migratetype,
+				order);
 	}
 
 	if (pcp) {
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

