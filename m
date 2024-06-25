Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEE8145338
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291720; cv=none; b=HDWaTde831DPDUVuIhyCBoRkcXkIBynehn+7nJ5x4SXCIncY/23pTqzmV9ZkCoEhdvEHnhNCoU64pLKWzRaAXBnfLt1IwK9bnJM80bhwWGFUx3X4/qLwwxp4gfg82Dj8K+xEthBX+xMLt/cmeLm+DvLWO+E88R+TABxkHhxPEdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291720; c=relaxed/simple;
	bh=N1UX2ViLxu/Fq4PB8he3IA3fJa+n1jXrO7yiyVg11jY=;
	h=Date:To:From:Subject:Message-Id; b=a/t1L12K4uXdV/ycXlbJVT6815kUlCFhiSK64yaN0xr6dSqt/pGnbBJSIhWCF3xYZz6a8U/sG/n2wIzUwC/Rv+PPZYprqPN1irnee8YPoC0YwZByLALxJwNFpYXUKVF2LgOumvYMo+5rKB2Mkzr9K5isKNEyDvA0V1ewE3aAvVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zmB5eAUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zmB5eAUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06D5C32782;
	Tue, 25 Jun 2024 05:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291719;
	bh=N1UX2ViLxu/Fq4PB8he3IA3fJa+n1jXrO7yiyVg11jY=;
	h=Date:To:From:Subject:From;
	b=zmB5eAUp7hyTJOUCIHu6gQfgFm+4jhF1VisZ5H+P54VgJJSjwxKuJo5zCr0mgH3m3
	 28lUR6LYLNqkrLhjmqJKu3wDegkDV4jADhMphGgJPCdLTMUHMnYg9CeMGJKLmls4yL
	 Gir5OFk00TREpRYlFDA2uYS5186XVb2Y3G9Z00iU=
Date: Mon, 24 Jun 2024 22:01:59 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,kirill.shutemov@linux.intel.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-simplify-logic-of-deferred__pages.patch removed from -mm tree
Message-Id: <20240625050159.C06D5C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: simplify logic of deferred_[init|free]_pages
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-simplify-logic-of-deferred__pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: simplify logic of deferred_[init|free]_pages
Date: Wed, 12 Jun 2024 02:04:21 +0000

Function deferred_[init|free]_pages are only used in
deferred_init_maxorder(), which makes sure the range to init/free is
within MAX_ORDER_NR_PAGES size.

With this knowledge, we can simplify these two functions. Since

  * only the first pfn could be IS_MAX_ORDER_ALIGNED()

Also since the range passed to deferred_[init|free]_pages is always from
memblock.memory for those we have already allocated memmap to cover,
pfn_valid() always return true.  Then we can remove related check.

[richard.weiyang@gmail.com: adjust function declaration indention per David]
  Link: https://lkml.kernel.org/r/20240613114525.27528-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20240612020421.31975-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   64 ++++++-------------------------------------------
 1 file changed, 8 insertions(+), 56 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-simplify-logic-of-deferred__pages
+++ a/mm/mm_init.c
@@ -1916,8 +1916,8 @@ unsigned long __init node_map_pfn_alignm
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
-static void __init deferred_free_range(unsigned long pfn,
-				       unsigned long nr_pages)
+static void __init deferred_free_pages(unsigned long pfn,
+		unsigned long nr_pages)
 {
 	struct page *page;
 	unsigned long i;
@@ -1956,68 +1956,20 @@ static inline void __init pgdat_init_rep
 }
 
 /*
- * Returns true if page needs to be initialized or freed to buddy allocator.
- *
- * We check if a current MAX_PAGE_ORDER block is valid by only checking the
- * validity of the head pfn.
- */
-static inline bool __init deferred_pfn_valid(unsigned long pfn)
-{
-	if (IS_MAX_ORDER_ALIGNED(pfn) && !pfn_valid(pfn))
-		return false;
-	return true;
-}
-
-/*
- * Free pages to buddy allocator. Try to free aligned pages in
- * MAX_ORDER_NR_PAGES sizes.
- */
-static void __init deferred_free_pages(unsigned long pfn,
-				       unsigned long end_pfn)
-{
-	unsigned long nr_free = 0;
-
-	for (; pfn < end_pfn; pfn++) {
-		if (!deferred_pfn_valid(pfn)) {
-			deferred_free_range(pfn - nr_free, nr_free);
-			nr_free = 0;
-		} else if (IS_MAX_ORDER_ALIGNED(pfn)) {
-			deferred_free_range(pfn - nr_free, nr_free);
-			nr_free = 1;
-		} else {
-			nr_free++;
-		}
-	}
-	/* Free the last block of pages to allocator */
-	deferred_free_range(pfn - nr_free, nr_free);
-}
-
-/*
  * Initialize struct pages.  We minimize pfn page lookups and scheduler checks
  * by performing it only once every MAX_ORDER_NR_PAGES.
  * Return number of pages initialized.
  */
-static unsigned long  __init deferred_init_pages(struct zone *zone,
-						 unsigned long pfn,
-						 unsigned long end_pfn)
+static unsigned long __init deferred_init_pages(struct zone *zone,
+		unsigned long pfn, unsigned long end_pfn)
 {
 	int nid = zone_to_nid(zone);
-	unsigned long nr_pages = 0;
+	unsigned long nr_pages = end_pfn - pfn;
 	int zid = zone_idx(zone);
-	struct page *page = NULL;
+	struct page *page = pfn_to_page(pfn);
 
-	for (; pfn < end_pfn; pfn++) {
-		if (!deferred_pfn_valid(pfn)) {
-			page = NULL;
-			continue;
-		} else if (!page || IS_MAX_ORDER_ALIGNED(pfn)) {
-			page = pfn_to_page(pfn);
-		} else {
-			page++;
-		}
+	for (; pfn < end_pfn; pfn++, page++)
 		__init_single_page(page, pfn, zid, nid);
-		nr_pages++;
-	}
 	return nr_pages;
 }
 
@@ -2096,7 +2048,7 @@ deferred_init_maxorder(u64 *i, struct zo
 			break;
 
 		t = min(mo_pfn, epfn);
-		deferred_free_pages(spfn, t);
+		deferred_free_pages(spfn, t - spfn);
 
 		if (mo_pfn <= epfn)
 			break;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-sparse-nr_pages-wont-be-0.patch
mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch
mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch
mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch

