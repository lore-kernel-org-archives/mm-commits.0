Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC70216602
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188396; cv=none; b=TMiLCkjFjckZm9Nk5GAQsstorJC7VvEU9bIhjT9p090HSb2DAuPuNMOyMbzNaYJItfdqnBGujJt0JzpWnyldW9AZf4aBtUoYehdd86w4ImJw/igmXIEy/ZSx5LSFHXYVfz3QkpIt/Ycp9REoRuOJQfQhnpsRfcH3nkqZx4Gs1XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188396; c=relaxed/simple;
	bh=kszuojI0Bi0NZRzbMikcA4g4A0gHrAsLuV/9K36pMNM=;
	h=Date:To:From:Subject:Message-Id; b=Xlrm52rmdgloF6Y2zPdk8a153si0hxpC1mbeAFa7+GZN8CMuRnizCmaElvtK3Ks0z/3pz2mcH38+jIy3953+6+8wufw6NrIM/n/iE0kMwdpg6kBG6+SeR1dvKYJSGLAJvdlwFXfdLVYsTjMrZ/3wlRaUB4pMHR3ZhnV4UL+NV04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xeuHBsGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xeuHBsGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D20C4CEEC;
	Mon, 17 Mar 2025 05:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188396;
	bh=kszuojI0Bi0NZRzbMikcA4g4A0gHrAsLuV/9K36pMNM=;
	h=Date:To:From:Subject:From;
	b=xeuHBsGUW0V9g0T4UZDpH5E692b/rFUXWc7zjsSgYbBkgffgDz9R2cJUs6gGPb4in
	 hO3loljOIkHmgBy3LZC/1TsaQN9JpODoIfFaVZoq2yOxcU23q4kcSIyWIF2K+5+9UT
	 qC7iYs2xBgUsQ4j8OoeGKUvjvHzmSHgLe7BmKX9c=
Date: Sun, 16 Mar 2025 22:13:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-introduce-a-cma-validate-function.patch removed from -mm tree
Message-Id: <20250317051316.84D20C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: introduce a cma validate function
has been removed from the -mm tree.  Its filename was
     mm-cma-introduce-a-cma-validate-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/cma: introduce a cma validate function
Date: Fri, 28 Feb 2025 18:29:24 +0000

Define a function to check if a CMA area is valid, which means: do its
ranges not cross any zone boundaries.  Store the result in the newly
created flags for each CMA area, so that multiple calls are dealt with.

This allows for checking the validity of a CMA area early, which is needed
later in order to be able to allocate hugetlb bootmem pages from it with
pre-HVO.

Link: https://lkml.kernel.org/r/20250228182928.2645936-24-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    5 +++
 mm/cma.c            |   60 +++++++++++++++++++++++++++++++++---------
 mm/cma.h            |    8 ++++-
 3 files changed, 60 insertions(+), 13 deletions(-)

--- a/include/linux/cma.h~mm-cma-introduce-a-cma-validate-function
+++ a/include/linux/cma.h
@@ -60,6 +60,7 @@ extern void cma_reserve_pages_on_error(s
 #ifdef CONFIG_CMA
 struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
 bool cma_free_folio(struct cma *cma, const struct folio *folio);
+bool cma_validate_zones(struct cma *cma);
 #else
 static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
 {
@@ -70,6 +71,10 @@ static inline bool cma_free_folio(struct
 {
 	return false;
 }
+static inline bool cma_validate_zones(struct cma *cma)
+{
+	return false;
+}
 #endif
 
 #endif
--- a/mm/cma.c~mm-cma-introduce-a-cma-validate-function
+++ a/mm/cma.c
@@ -99,6 +99,49 @@ static void cma_clear_bitmap(struct cma
 	spin_unlock_irqrestore(&cma->lock, flags);
 }
 
+/*
+ * Check if a CMA area contains no ranges that intersect with
+ * multiple zones. Store the result in the flags in case
+ * this gets called more than once.
+ */
+bool cma_validate_zones(struct cma *cma)
+{
+	int r;
+	unsigned long base_pfn;
+	struct cma_memrange *cmr;
+	bool valid_bit_set;
+
+	/*
+	 * If already validated, return result of previous check.
+	 * Either the valid or invalid bit will be set if this
+	 * check has already been done. If neither is set, the
+	 * check has not been performed yet.
+	 */
+	valid_bit_set = test_bit(CMA_ZONES_VALID, &cma->flags);
+	if (valid_bit_set || test_bit(CMA_ZONES_INVALID, &cma->flags))
+		return valid_bit_set;
+
+	for (r = 0; r < cma->nranges; r++) {
+		cmr = &cma->ranges[r];
+		base_pfn = cmr->base_pfn;
+
+		/*
+		 * alloc_contig_range() requires the pfn range specified
+		 * to be in the same zone. Simplify by forcing the entire
+		 * CMA resv range to be in the same zone.
+		 */
+		WARN_ON_ONCE(!pfn_valid(base_pfn));
+		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count)) {
+			set_bit(CMA_ZONES_INVALID, &cma->flags);
+			return false;
+		}
+	}
+
+	set_bit(CMA_ZONES_VALID, &cma->flags);
+
+	return true;
+}
+
 static void __init cma_activate_area(struct cma *cma)
 {
 	unsigned long pfn, base_pfn;
@@ -113,19 +156,12 @@ static void __init cma_activate_area(str
 			goto cleanup;
 	}
 
+	if (!cma_validate_zones(cma))
+		goto cleanup;
+
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
 		base_pfn = cmr->base_pfn;
-
-		/*
-		 * alloc_contig_range() requires the pfn range specified
-		 * to be in the same zone. Simplify by forcing the entire
-		 * CMA resv range to be in the same zone.
-		 */
-		WARN_ON_ONCE(!pfn_valid(base_pfn));
-		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count))
-			goto cleanup;
-
 		for (pfn = base_pfn; pfn < base_pfn + cmr->count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
@@ -145,7 +181,7 @@ cleanup:
 		bitmap_free(cma->ranges[r].bitmap);
 
 	/* Expose all pages to the buddy, they are useless for CMA. */
-	if (!cma->reserve_pages_on_error) {
+	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
 		for (r = 0; r < allocrange; r++) {
 			cmr = &cma->ranges[r];
 			for (pfn = cmr->base_pfn;
@@ -172,7 +208,7 @@ core_initcall(cma_init_reserved_areas);
 
 void __init cma_reserve_pages_on_error(struct cma *cma)
 {
-	cma->reserve_pages_on_error = true;
+	set_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags);
 }
 
 static int __init cma_new_area(const char *name, phys_addr_t size,
--- a/mm/cma.h~mm-cma-introduce-a-cma-validate-function
+++ a/mm/cma.h
@@ -49,11 +49,17 @@ struct cma {
 	/* kobject requires dynamic object */
 	struct cma_kobject *cma_kobj;
 #endif
-	bool reserve_pages_on_error;
+	unsigned long flags;
 	/* NUMA node (NUMA_NO_NODE if unspecified) */
 	int nid;
 };
 
+enum cma_flags {
+	CMA_RESERVE_PAGES_ON_ERROR,
+	CMA_ZONES_VALID,
+	CMA_ZONES_INVALID,
+};
+
 extern struct cma cma_areas[MAX_CMA_AREAS];
 extern unsigned int cma_area_count;
 
_

Patches currently in -mm which might be from fvdl@google.com are


