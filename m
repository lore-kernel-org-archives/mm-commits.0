Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B74152E00
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 22:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717625833; cv=none; b=sfEBxjosP4C3AsOygsgn767h4Dt3yXtEtgPWsEPZNTfLpVdbfc+Yp0f73rpDjFvhZwp2PzHZnvwzUYD5bGExPE5j3PyI31yvWAzfC0UlSRVsdnOePSs+O3FeKcSDb/BbSmTXVW0NZk8rWU8JMA8cb+CUuDABQTaXAq70sWCiTnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717625833; c=relaxed/simple;
	bh=g3D7ki0nnXSQhxTB9GiSFuBn3yjjEvHmYmQpi/it7Xo=;
	h=Date:To:From:Subject:Message-Id; b=iy1MVxVEXbPQY4pZxcfLd8lknsflCisiMXk5kbXuMLKE636gzBTwRWx6TCuhtC3ksq6r/yoyQ2yVSOeu5Kw2+kz6D3kDmHieCp+FwSd3Nhcoeo+zXwaUSKB1CIFp6Q+Lkjis/m9KTRKrc9khchQiXfsMomd/cuhBu850G9ytRhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eivT1tK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eivT1tK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92566C4AF08;
	Wed,  5 Jun 2024 22:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717625832;
	bh=g3D7ki0nnXSQhxTB9GiSFuBn3yjjEvHmYmQpi/it7Xo=;
	h=Date:To:From:Subject:From;
	b=eivT1tK3ckqrAmmivPP7fuQnyeUJTgu2PlSxvGQO/0BZKOCxe3tcQsVNSeoV2C3nE
	 VxOEBVcsBjPzmg9IJxv4jlPFjxLUjTIhURbreyyx++LZZu8ThZPzsk2WUY/yX/CR/Y
	 ++T63GBF86c0KSBfqZMfzN5eIhHdYPf4XywmRc/I=
Date: Wed, 05 Jun 2024 15:17:11 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning.patch removed from -mm tree
Message-Id: <20240605221712.92566C4AF08@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: not always search next deferred_init_pfn from very beginning
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: not always search next deferred_init_pfn from very beginning
Date: Fri, 31 May 2024 00:26:13 +0000

In deferred_init_memmap(), we call deferred_init_mem_pfn_range_in_zone()
to get the next deferred_init_pfn.  But we always search it from the very
beginning.

Since we save the index in i, we can leverage this to search from i next
time.

Link: https://lkml.kernel.org/r/20240531002613.5231-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |   19 -------------------
 mm/mm_init.c             |   21 ++++++++++++---------
 2 files changed, 12 insertions(+), 28 deletions(-)

--- a/include/linux/memblock.h~mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning
+++ a/include/linux/memblock.h
@@ -299,25 +299,6 @@ void __next_mem_pfn_range(int *idx, int
 void __next_mem_pfn_range_in_zone(u64 *idx, struct zone *zone,
 				  unsigned long *out_spfn,
 				  unsigned long *out_epfn);
-/**
- * for_each_free_mem_pfn_range_in_zone - iterate through zone specific free
- * memblock areas
- * @i: u64 used as loop variable
- * @zone: zone in which all of the memory blocks reside
- * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
- * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
- *
- * Walks over free (memory && !reserved) areas of memblock in a specific
- * zone. Available once memblock and an empty zone is initialized. The main
- * assumption is that the zone start, end, and pgdat have been associated.
- * This way we can use the zone to determine NUMA node, and if a given part
- * of the memblock is valid for the zone.
- */
-#define for_each_free_mem_pfn_range_in_zone(i, zone, p_start, p_end)	\
-	for (i = 0,							\
-	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end);	\
-	     i != U64_MAX;					\
-	     __next_mem_pfn_range_in_zone(&i, zone, p_start, p_end))
 
 /**
  * for_each_free_mem_pfn_range_in_zone_from - iterate through zone specific
--- a/mm/mm_init.c~mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning
+++ a/mm/mm_init.c
@@ -2025,18 +2025,21 @@ static unsigned long  __init deferred_in
  * return false indicating there are no valid ranges left.
  */
 static bool __init
-deferred_init_mem_pfn_range_in_zone(u64 *i, struct zone *zone,
+deferred_init_mem_pfn_range_in_zone_from(u64 *i, struct zone *zone,
 				    unsigned long *spfn, unsigned long *epfn,
 				    unsigned long first_init_pfn)
 {
-	u64 j;
+	u64 j = *i;
+
+	if (j == 0)
+		__next_mem_pfn_range_in_zone(&j, zone, spfn, epfn);
 
 	/*
 	 * Start out by walking through the ranges in this zone that have
 	 * already been initialized. We don't need to do anything with them
 	 * so we just need to flush them out of the system.
 	 */
-	for_each_free_mem_pfn_range_in_zone(j, zone, spfn, epfn) {
+	for_each_free_mem_pfn_range_in_zone_from(j, zone, spfn, epfn) {
 		if (*epfn <= first_init_pfn)
 			continue;
 		if (*spfn < first_init_pfn)
@@ -2108,9 +2111,9 @@ deferred_init_memmap_chunk(unsigned long
 {
 	unsigned long spfn, epfn;
 	struct zone *zone = arg;
-	u64 i;
+	u64 i = 0;
 
-	deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, start_pfn);
+	deferred_init_mem_pfn_range_in_zone_from(&i, zone, &spfn, &epfn, start_pfn);
 
 	/*
 	 * Initialize and free pages in MAX_PAGE_ORDER sized increments so that
@@ -2138,7 +2141,7 @@ static int __init deferred_init_memmap(v
 	unsigned long start = jiffies;
 	struct zone *zone;
 	int max_threads;
-	u64 i;
+	u64 i = 0;
 
 	/* Bind memory initialisation thread to a local node if possible */
 	if (!cpumask_empty(cpumask))
@@ -2169,7 +2172,7 @@ static int __init deferred_init_memmap(v
 
 	max_threads = deferred_page_init_max_threads(cpumask);
 
-	while (deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, first_init_pfn)) {
+	while (deferred_init_mem_pfn_range_in_zone_from(&i, zone, &spfn, &epfn, first_init_pfn)) {
 		first_init_pfn = ALIGN(epfn, PAGES_PER_SECTION);
 		struct padata_mt_job job = {
 			.thread_fn   = deferred_init_memmap_chunk,
@@ -2213,7 +2216,7 @@ bool __init deferred_grow_zone(struct zo
 	unsigned long first_deferred_pfn = pgdat->first_deferred_pfn;
 	unsigned long spfn, epfn, flags;
 	unsigned long nr_pages = 0;
-	u64 i;
+	u64 i = 0;
 
 	/* Only the last zone may have deferred pages */
 	if (zone_end_pfn(zone) != pgdat_end_pfn(pgdat))
@@ -2231,7 +2234,7 @@ bool __init deferred_grow_zone(struct zo
 	}
 
 	/* If the zone is empty somebody else may have cleared out the zone */
-	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
+	if (!deferred_init_mem_pfn_range_in_zone_from(&i, zone, &spfn, &epfn,
 						 first_deferred_pfn)) {
 		pgdat->first_deferred_pfn = ULONG_MAX;
 		pgdat_resize_unlock(pgdat, &flags);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


