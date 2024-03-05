Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E999FC1C
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600570; cv=none; b=L8ld15glmK7QRqdldaPfEHV8vmnnUNKALsh25P0jJLvlfwzmNieYEpvu4Ub0IFl6YtTsjt0thNdYmS7hhEuySyUf1B9Ckfx4daG52DMXdQ88JfsTiudqf5PFgegRnFakGZ3iwC/8c5GcmcQuUgV7d7syGNMGkw8owZp953AF4/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600570; c=relaxed/simple;
	bh=L4Tq8LETqJYokNV7ZJe8sVRfpnZMqyK17IeqdCyZDmM=;
	h=Date:To:From:Subject:Message-Id; b=JLpGMsD1ZU3bEyyg74UtqzKgB1aHRLQLh6L65k3psRKl5I9k0lRxaym5TawKWOa8Pqc0daUHF3VjqDIRlsQs0/P+rLdYUBr+C/+p+5G1e2UQEggUfwh2vCPIh3sLItZQYEP/vossGccGJfGe/HVY3ADQ9l4s+BUe0LQjPpxEkZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jG0HCDM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jG0HCDM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E065CC433C7;
	Tue,  5 Mar 2024 01:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600570;
	bh=L4Tq8LETqJYokNV7ZJe8sVRfpnZMqyK17IeqdCyZDmM=;
	h=Date:To:From:Subject:From;
	b=jG0HCDM0Gs8/8mXnpJgCHf7Z4LFg61WdkC5qkRZFhcpVze+C3yGDNmqXSkzN/VgQv
	 gi9MxqG52lRJNeLg/lrvxOgkuxxMhycA2A9XaE/cYPPje7umyGDaLGN0sRYcanb9yq
	 S0MFudaH41flX16AIZ3YKp/dbpSFY8mDcRnq2FB8=
Date: Mon, 04 Mar 2024 17:02:49 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-large-folios-in-free_unref_folios.patch removed from -mm tree
Message-Id: <20240305010249.E065CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: handle large folios in free_unref_folios()
has been removed from the -mm tree.  Its filename was
     mm-handle-large-folios-in-free_unref_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

