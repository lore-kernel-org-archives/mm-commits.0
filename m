Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C013710940
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600543; cv=none; b=Tlj/HBDOaipO5P2KPNdLfNOHqLETLuosWNNb+k0fdTbaBkNEfICv2imqBuL/EypwFHCxiazMZb2Ftu2hbDcji6iFXKZ6kuOP7avdOslQOtTJZQywV5GapdJJlhSRJlOZ9t8d/ld7ThXjDZzrHGVRWR6TvBLDoW3yld4/5tYriTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600543; c=relaxed/simple;
	bh=EYr9ssQZjDxRbSByM91tIrb+0MNuHtJb4qgMoj5g4WQ=;
	h=Date:To:From:Subject:Message-Id; b=RJhizefF8YD/G/dtkjUIADcE1BmKscxNB9E5qOFljXQyecsZ4t1a/n1NWM8CfcUbRcvcijGuotUSjwBD7u3FLea86Jv40mfThh8UiJppXwGr0CefSVUd+2DiNgjV5gZjZPxSi5VgLDNavX+PwUDe4MctygPWSyfzpj/J0Ri4QgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rkazojup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rkazojup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ACAC43390;
	Tue,  5 Mar 2024 01:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600543;
	bh=EYr9ssQZjDxRbSByM91tIrb+0MNuHtJb4qgMoj5g4WQ=;
	h=Date:To:From:Subject:From;
	b=rkazojup0J7OY2fQ1OPt1rIdIxsYmfX+twV/thaecz6wPyQOkHtbTKl2M0wDAog3g
	 dkqqgyfrm3vEy+R+QUQZEORlC3aJfgdaEnZn6tFMgXikr/MdAGj2YHh+Omap8/4PHs
	 FDU+jLsQGJ0rQUbQ2vSOr9lPzm9/DyZmUxwQaaOQ=
Date: Mon, 04 Mar 2024 17:02:23 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,yuzhao@google.com,shy828301@gmail.com,ryan.roberts@arm.com,roman.gushchin@linux.dev,mkoutny@suse.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,hughd@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-support-order-1-folios-in-the-page-cache.patch removed from -mm tree
Message-Id: <20240305010223.93ACAC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: support order-1 folios in the page cache
has been removed from the -mm tree.  Its filename was
     mm-support-order-1-folios-in-the-page-cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: support order-1 folios in the page cache
Date: Mon, 26 Feb 2024 15:55:28 -0500

Folios of order 1 have no space to store the deferred list.  This is not a
problem for the page cache as file-backed folios are never placed on the
deferred list.  All we need to do is prevent the core MM from touching the
deferred list for order 1 folios and remove the code which prevented us
from allocating order 1 folios.

Link: https://lore.kernel.org/linux-mm/90344ea7-4eec-47ee-5996-0c22f42d6a6a@google.com/
Link: https://lkml.kernel.org/r/20240226205534.1603748-3-zi.yan@sent.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c     |    2 --
 mm/huge_memory.c |   19 +++++++++++++++----
 mm/internal.h    |    3 +--
 mm/readahead.c   |    3 ---
 4 files changed, 16 insertions(+), 11 deletions(-)

--- a/mm/filemap.c~mm-support-order-1-folios-in-the-page-cache
+++ a/mm/filemap.c
@@ -1912,8 +1912,6 @@ no_page:
 			gfp_t alloc_gfp = gfp;
 
 			err = -ENOMEM;
-			if (order == 1)
-				order = 0;
 			if (order > 0)
 				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
 			folio = filemap_alloc_folio(alloc_gfp, order);
--- a/mm/huge_memory.c~mm-support-order-1-folios-in-the-page-cache
+++ a/mm/huge_memory.c
@@ -790,8 +790,10 @@ struct deferred_split *get_deferred_spli
 
 void folio_prep_large_rmappable(struct folio *folio)
 {
-	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
-	INIT_LIST_HEAD(&folio->_deferred_list);
+	if (!folio || !folio_test_large(folio))
+		return;
+	if (folio_order(folio) > 1)
+		INIT_LIST_HEAD(&folio->_deferred_list);
 	folio_set_large_rmappable(folio);
 }
 
@@ -3114,7 +3116,8 @@ int split_huge_page_to_list(struct page
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
-		if (!list_empty(&folio->_deferred_list)) {
+		if (folio_order(folio) > 1 &&
+		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
 			list_del(&folio->_deferred_list);
 		}
@@ -3165,6 +3168,9 @@ void folio_undo_large_rmappable(struct f
 	struct deferred_split *ds_queue;
 	unsigned long flags;
 
+	if (folio_order(folio) <= 1)
+		return;
+
 	/*
 	 * At this point, there is no one trying to add the folio to
 	 * deferred_list. If folio is not in deferred_list, it's safe
@@ -3190,7 +3196,12 @@ void deferred_split_folio(struct folio *
 #endif
 	unsigned long flags;
 
-	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
+	/*
+	 * Order 1 folios have no space for a deferred list, but we also
+	 * won't waste much memory by not adding them to the deferred list.
+	 */
+	if (folio_order(folio) <= 1)
+		return;
 
 	/*
 	 * The try_to_unmap() in page reclaim path might reach here too,
--- a/mm/internal.h~mm-support-order-1-folios-in-the-page-cache
+++ a/mm/internal.h
@@ -420,8 +420,7 @@ static inline struct folio *page_rmappab
 {
 	struct folio *folio = (struct folio *)page;
 
-	if (folio && folio_order(folio) > 1)
-		folio_prep_large_rmappable(folio);
+	folio_prep_large_rmappable(folio);
 	return folio;
 }
 
--- a/mm/readahead.c~mm-support-order-1-folios-in-the-page-cache
+++ a/mm/readahead.c
@@ -514,9 +514,6 @@ void page_cache_ra_order(struct readahea
 		/* Don't allocate pages past EOF */
 		while (index + (1UL << order) - 1 > limit)
 			order--;
-		/* THP machinery does not support order-1 */
-		if (order == 1)
-			order = 0;
 		err = ra_alloc_folio(ractl, index, mark, order, gfp);
 		if (err)
 			break;
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

