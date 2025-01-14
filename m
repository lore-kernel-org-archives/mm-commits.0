Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3140D23C717
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837064; cv=none; b=FJGIgEqeeklWsqrIaSwmam5+MxBs3wh8L+VB2vt8I96y2BsWkr2OyzuxDfPp0Zd0b+06terWLe6H3HuPMnwLaszIOov6sKUX821bqhoyDq0Ur82lZtUqu54p3Ntq+AFgGQOhuFImLwR9WIFKgOGaVaTCKNtSI32TCX3ZHN4e+tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837064; c=relaxed/simple;
	bh=9hAYPO70v0pDiCZFg73hpZxGOgFBCoq7k8h1L8wo8vA=;
	h=Date:To:From:Subject:Message-Id; b=cQxLWXFCpbK8jvHfSwKr1ys5Uvlecqw6ODZcO3QG36nLJ7F0o4CFNQvwVch/fHO5MwsfrkRGILvUxuYOUAbaLHzL1N+97mrDy5gpVtVBqJTrGoveJSvbDmckMeaTzXW2saajQRG6+OKX4KPF0+eW9vCrimLv8OZCu0iXSOJqe5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2k7i48aQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2k7i48aQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D84C4CEDD;
	Tue, 14 Jan 2025 06:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837064;
	bh=9hAYPO70v0pDiCZFg73hpZxGOgFBCoq7k8h1L8wo8vA=;
	h=Date:To:From:Subject:From;
	b=2k7i48aQ1gwqrkMqfFeNjJmMSdjOx40ThWIMROo1LkaMW2d3GaMM3HYxsKqgLTETy
	 dwZ7ykiUj63io5mcyuBJNLiTPH6GIFnkbf73YkNYSn2rz+SvgQ3/jY0eMzete7q2ps
	 WJv9Gs4LWfqfubjhs6vqAtEP7l2/UxYZi4yyQzsk=
Date: Mon, 13 Jan 2025 22:44:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,iamjoonsoo.kim@lge.com,david@redhat.com,cl@linux.com,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-remove-slab-checks-in-isolate_movable_page.patch removed from -mm tree
Message-Id: <20250114064424.05D84C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: remove slab checks in isolate_movable_page()
has been removed from the -mm tree.  Its filename was
     mm-migrate-remove-slab-checks-in-isolate_movable_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/migrate: remove slab checks in isolate_movable_page()
Date: Tue, 10 Dec 2024 21:48:07 +0900

Commit 8b8817630ae8 ("mm/migrate: make isolate_movable_page() skip slab
pages") introduced slab checks to prevent mis-identification of slab pages
as movable kernel pages.

However, after Matthew's frozen folio series, these slab checks became
unnecessary as the migration logic fails to increase the reference count
for frozen slab folios.  Remove these redundant slab checks and associated
memory barriers.

Link: https://lkml.kernel.org/r/20241210124807.8584-1-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 --------
 mm/slub.c    |    4 ----
 2 files changed, 12 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-slab-checks-in-isolate_movable_page
+++ a/mm/migrate.c
@@ -68,10 +68,6 @@ bool isolate_movable_page(struct page *p
 	if (!folio)
 		goto out;
 
-	if (unlikely(folio_test_slab(folio)))
-		goto out_putfolio;
-	/* Pairs with smp_wmb() in slab freeing, e.g. SLUB's __free_slab() */
-	smp_rmb();
 	/*
 	 * Check movable flag before taking the page lock because
 	 * we use non-atomic bitops on newly allocated page flags so
@@ -79,10 +75,6 @@ bool isolate_movable_page(struct page *p
 	 */
 	if (unlikely(!__folio_test_movable(folio)))
 		goto out_putfolio;
-	/* Pairs with smp_wmb() in slab allocation, e.g. SLUB's alloc_slab_page() */
-	smp_rmb();
-	if (unlikely(folio_test_slab(folio)))
-		goto out_putfolio;
 
 	/*
 	 * As movable pages are not isolated from LRU lists, concurrent
--- a/mm/slub.c~mm-migrate-remove-slab-checks-in-isolate_movable_page
+++ a/mm/slub.c
@@ -2429,8 +2429,6 @@ static inline struct slab *alloc_slab_pa
 
 	slab = folio_slab(folio);
 	__folio_set_slab(folio);
-	/* Make the flag visible before any changes to folio->mapping */
-	smp_wmb();
 	if (folio_is_pfmemalloc(folio))
 		slab_set_pfmemalloc(slab);
 
@@ -2651,8 +2649,6 @@ static void __free_slab(struct kmem_cach
 
 	__slab_clear_pfmemalloc(slab);
 	folio->mapping = NULL;
-	/* Make the mapping reset visible before clearing the flag */
-	smp_wmb();
 	__folio_clear_slab(folio);
 	mm_account_reclaimed_pages(pages);
 	unaccount_slab(slab, order, s);
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-zsmalloc-convert-__zs_map_object-__zs_unmap_object-to-use-zpdesc.patch
mm-zsmalloc-add-and-use-pfn-zpdesc-seeking-funcs.patch
mm-zsmalloc-convert-obj_malloc-to-use-zpdesc.patch
mm-zsmalloc-convert-obj_allocated-and-related-helpers-to-use-zpdesc.patch
mm-zsmalloc-convert-init_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-obj_to_page-and-zs_free-to-use-zpdesc.patch
mm-zsmalloc-add-two-helpers-for-zs_page_migrate-and-make-it-use-zpdesc.patch
mm-zsmalloc-convert-__free_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-location_to_obj-to-take-zpdesc.patch
mm-zsmalloc-convert-migrate_zspage-to-use-zpdesc.patch
mm-zsmalloc-convert-get_zspage-to-take-zpdesc.patch

