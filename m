Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DA83FD4
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 00:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717202109; cv=none; b=MqpCdll6Zc1O5WvdqQpvPy+dIzwa18IFBJnezckUJM9d4xvi2Qe42UPT+arTRjcqclEPLgTNfWq/MupYA2zB7qxQETgPJxp3VbmEDpRznzqcT1MZokgeohTa8ZSBbJ0r4T1YwxR8f2YtwkwgVaq8YF5rSuor8RnhZoasnsGCRaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717202109; c=relaxed/simple;
	bh=UlZ9wjBrU6AlYefmqeFiMOYd3AbmLcAZ474kxdP3k4I=;
	h=Date:To:From:Subject:Message-Id; b=nEL9RSBMmylgz3vK4QIo4djOXisjX+6GLjXjD8GAIpNgAVbTeQ9OftHI2rXfg7Xfs/iYbmAl7btgHkZMpWt8jA7gE0y3DcN9Z7XsSoUyGNXJSVir7oRNInmjSTIy5exAIjnDEoFIYLNuy6rgloNWK8QE4ac2tIg8pKB4hmvAlIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=17787k8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="17787k8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21B5C116B1;
	Sat,  1 Jun 2024 00:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717202108;
	bh=UlZ9wjBrU6AlYefmqeFiMOYd3AbmLcAZ474kxdP3k4I=;
	h=Date:To:From:Subject:From;
	b=17787k8YMZQGlLFaqEP+XgQF+GHWPOfSL2F9KPJ36xf/sMXA7FTltK3Q4GjQoVueH
	 qyO+uaLkMK7qcQs+JlpoAn+SBYic57/AmnaJzftjJpXwXIqhYX99DGyXv6yf4vR7wj
	 OVlEuC8PBrFTC8PuWZOV5dKGu+s2roPsCM59bEWQ=
Date: Fri, 31 May 2024 17:35:07 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning.patch added to mm-unstable branch
Message-Id: <20240601003508.A21B5C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: not always search next deferred_init_pfn from very beginning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning.patch

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
@@ -2139,7 +2142,7 @@ static int __init deferred_init_memmap(v
 	unsigned long start = jiffies;
 	struct zone *zone;
 	int max_threads;
-	u64 i;
+	u64 i = 0;
 
 	/* Bind memory initialisation thread to a local node if possible */
 	if (!cpumask_empty(cpumask))
@@ -2170,7 +2173,7 @@ static int __init deferred_init_memmap(v
 
 	max_threads = deferred_page_init_max_threads(cpumask);
 
-	while (deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, first_init_pfn)) {
+	while (deferred_init_mem_pfn_range_in_zone_from(&i, zone, &spfn, &epfn, first_init_pfn)) {
 		first_init_pfn = ALIGN(epfn, PAGES_PER_SECTION);
 		struct padata_mt_job job = {
 			.thread_fn   = deferred_init_memmap_chunk,
@@ -2214,7 +2217,7 @@ bool __init deferred_grow_zone(struct zo
 	unsigned long first_deferred_pfn = pgdat->first_deferred_pfn;
 	unsigned long spfn, epfn, flags;
 	unsigned long nr_pages = 0;
-	u64 i;
+	u64 i = 0;
 
 	/* Only the last zone may have deferred pages */
 	if (zone_end_pfn(zone) != pgdat_end_pfn(pgdat))
@@ -2232,7 +2235,7 @@ bool __init deferred_grow_zone(struct zo
 	}
 
 	/* If the zone is empty somebody else may have cleared out the zone */
-	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
+	if (!deferred_init_mem_pfn_range_in_zone_from(&i, zone, &spfn, &epfn,
 						 first_deferred_pfn)) {
 		pgdat->first_deferred_pfn = ULONG_MAX;
 		pgdat_resize_unlock(pgdat, &flags);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-get-the-highest-zone-directly.patch
mm-mm_initc-use-deferred_init_mem_pfn_range_in_zone-to-decide-loop-condition.patch
mm-mm_initc-not-always-search-next-deferred_init_pfn-from-very-beginning.patch

