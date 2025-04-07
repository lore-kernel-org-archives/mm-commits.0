Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EE5268C53;
	Mon,  7 Apr 2025 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744049707; cv=none; b=IkdjKrHusXf/WqT6PeBQlaagrOjAQnzfTPMbJzdMXCb5nopb/f4yYWZEB/QD4Gc11iUH7nvWHXDzUVVC+rNRFBqh1NEJr2uYpKjOD5/4MuLPMSrp149weL4Qh2Lqa9OSNP9TgaWvd+DAjtYpLuemdKl6gLdsZIr9+x71JUdygNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744049707; c=relaxed/simple;
	bh=4Zx6KaLbDL+tM/u0ewIqQynWh69rLwnCPElyw/pJw7M=;
	h=Date:To:From:Subject:Message-Id; b=iBIZITCOpBeUlUB7rEnEKnYsQ2/+7Ny+7zn757rB2W5j0jmLx8HBnucRNWw4A6BJDqm31Pg8iMKCNy2GvvaLve6VzUe8c6OUdDFu8ePpmBAkDDeKlKQ9JoNkIOpE4eN2N9tblk0U+c+ch76DGXmc//mWn3WC5qpks2d3T+qCm/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BdgfMIqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BdgfMIqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8DBC4CEE7;
	Mon,  7 Apr 2025 18:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744049706;
	bh=4Zx6KaLbDL+tM/u0ewIqQynWh69rLwnCPElyw/pJw7M=;
	h=Date:To:From:Subject:From;
	b=BdgfMIqJhJwl22h+w2OGfm8XhkpmEXD5LNS/rrI2nXZ8PlqXCOrfF8JEYbuOm3z2r
	 vh7piIrMdxha/iWoU2WafY6JmTkY36H4LOW/Lv1GYQwDz+GvKrwPMl21+6cp7qFlJl
	 vrbuMOO46pUtgHgsfqCb2zxKX78wqKfiEaZJBk0A=
Date: Mon, 07 Apr 2025 11:15:05 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,oliver.sang@intel.com,carlos.song@nxp.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk.patch added to mm-hotfixes-unstable branch
Message-Id: <20250407181506.7D8DBC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: speed up fallbacks in rmqueue_bulk()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: speed up fallbacks in rmqueue_bulk()
Date: Mon, 7 Apr 2025 14:01:53 -0400

The test robot identified c2f6ea38fc1b ("mm: page_alloc: don't steal
single pages from biggest buddy") as the root cause of a 56.4% regression
in vm-scalability::lru-file-mmap-read.

Carlos reports an earlier patch, c0cd6f557b90 ("mm: page_alloc: fix
freelist movement during block conversion"), as the root cause for a
regression in worst-case zone->lock+irqoff hold times.

Both of these patches modify the page allocator's fallback path to be less
greedy in an effort to stave off fragmentation.  The flip side of this is
that fallbacks are also less productive each time around, which means the
fallback search can run much more frequently.

Carlos' traces point to rmqueue_bulk() specifically, which tries to refill
the percpu cache by allocating a large batch of pages in a loop.  It
highlights how once the native freelists are exhausted, the fallback code
first scans orders top-down for whole blocks to claim, then falls back to
a bottom-up search for the smallest buddy to steal.  For the next batch
page, it goes through the same thing again.

This can be made more efficient.  Since rmqueue_bulk() holds the
zone->lock over the entire batch, the freelists are not subject to outside
changes; when the search for a block to claim has already failed, there is
no point in trying again for the next page.

Modify __rmqueue() to remember the last successful fallback mode, and
restart directly from there on the next rmqueue_bulk() iteration.

Oliver confirms that this improves beyond the regression that the test
robot reported against c2f6ea38fc1b:

commit:
  f3b92176f4 ("tools/selftests: add guard region test for /proc/$pid/pagemap")
  c2f6ea38fc ("mm: page_alloc: don't steal single pages from biggest buddy")
  acc4d5ff0b ("Merge tag 'net-6.15-rc0' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
  2c847f27c3 ("mm: page_alloc: speed up fallbacks in rmqueue_bulk()")   <--- your patch

f3b92176f4f7100f c2f6ea38fc1b640aa7a2e155cc1 acc4d5ff0b61eb1715c498b6536 2c847f27c37da65a93d23c237c5
---------------- --------------------------- --------------------------- ---------------------------
         %stddev     %change         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \          |                \
  25525364 ±  3%     -56.4%   11135467           -57.8%   10779336           +31.6%   33581409        vm-scalability.throughput

Carlos confirms that worst-case times are almost fully recovered
compared to before the earlier culprit patch:

  2dd482ba627d (before freelist hygiene):    1ms
  c0cd6f557b90  (after freelist hygiene):   90ms
 next-20250319    (steal smallest buddy):  280ms
    this patch                          :    8ms

Link: https://lkml.kernel.org/r/20250407180154.63348-1-hannes@cmpxchg.org
Fixes: c0cd6f557b90 ("mm: page_alloc: fix freelist movement during block conversion")
Fixes: c2f6ea38fc1b ("mm: page_alloc: don't steal single pages from biggest buddy")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reported-by: Carlos Song <carlos.song@nxp.com>
Tested-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202503271547.fc08b188-lkp@intel.com
Cc: <stable@vger.kernel.org>	[6.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  100 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 74 insertions(+), 26 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk
+++ a/mm/page_alloc.c
@@ -2189,11 +2189,11 @@ try_to_claim_block(struct zone *zone, st
  * The use of signed ints for order and current_order is a deliberate
  * deviation from the rest of this file, to make the for loop
  * condition simpler.
- *
- * Return the stolen page, or NULL if none can be found.
  */
+
+/* Try to claim a whole foreign block, take a page, expand the remainder */
 static __always_inline struct page *
-__rmqueue_fallback(struct zone *zone, int order, int start_migratetype,
+__rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 						unsigned int alloc_flags)
 {
 	struct free_area *area;
@@ -2231,14 +2231,26 @@ __rmqueue_fallback(struct zone *zone, in
 		page = try_to_claim_block(zone, page, current_order, order,
 					  start_migratetype, fallback_mt,
 					  alloc_flags);
-		if (page)
-			goto got_one;
+		if (page) {
+			trace_mm_page_alloc_extfrag(page, order, current_order,
+						    start_migratetype, fallback_mt);
+			return page;
+		}
 	}
 
-	if (alloc_flags & ALLOC_NOFRAGMENT)
-		return NULL;
+	return NULL;
+}
+
+/* Try to steal a single page from a foreign block */
+static __always_inline struct page *
+__rmqueue_steal(struct zone *zone, int order, int start_migratetype)
+{
+	struct free_area *area;
+	int current_order;
+	struct page *page;
+	int fallback_mt;
+	bool claim_block;
 
-	/* No luck claiming pageblock. Find the smallest fallback page */
 	for (current_order = order; current_order < NR_PAGE_ORDERS; current_order++) {
 		area = &(zone->free_area[current_order]);
 		fallback_mt = find_suitable_fallback(area, current_order,
@@ -2248,25 +2260,28 @@ __rmqueue_fallback(struct zone *zone, in
 
 		page = get_page_from_free_area(area, fallback_mt);
 		page_del_and_expand(zone, page, order, current_order, fallback_mt);
-		goto got_one;
+		trace_mm_page_alloc_extfrag(page, order, current_order,
+					    start_migratetype, fallback_mt);
+		return page;
 	}
 
 	return NULL;
-
-got_one:
-	trace_mm_page_alloc_extfrag(page, order, current_order,
-		start_migratetype, fallback_mt);
-
-	return page;
 }
 
+enum rmqueue_mode {
+	RMQUEUE_NORMAL,
+	RMQUEUE_CMA,
+	RMQUEUE_CLAIM,
+	RMQUEUE_STEAL,
+};
+
 /*
  * Do the hard work of removing an element from the buddy allocator.
  * Call me with the zone->lock already held.
  */
 static __always_inline struct page *
 __rmqueue(struct zone *zone, unsigned int order, int migratetype,
-						unsigned int alloc_flags)
+	  unsigned int alloc_flags, enum rmqueue_mode *mode)
 {
 	struct page *page;
 
@@ -2285,16 +2300,47 @@ __rmqueue(struct zone *zone, unsigned in
 		}
 	}
 
-	page = __rmqueue_smallest(zone, order, migratetype);
-	if (unlikely(!page)) {
-		if (alloc_flags & ALLOC_CMA)
+	/*
+	 * Try the different freelists, native then foreign.
+	 *
+	 * The fallback logic is expensive and rmqueue_bulk() calls in
+	 * a loop with the zone->lock held, meaning the freelists are
+	 * not subject to any outside changes. Remember in *mode where
+	 * we found pay dirt, to save us the search on the next call.
+	 */
+	switch (*mode) {
+	case RMQUEUE_NORMAL:
+		page = __rmqueue_smallest(zone, order, migratetype);
+		if (page)
+			return page;
+		fallthrough;
+	case RMQUEUE_CMA:
+		if (alloc_flags & ALLOC_CMA) {
 			page = __rmqueue_cma_fallback(zone, order);
-
-		if (!page)
-			page = __rmqueue_fallback(zone, order, migratetype,
-						  alloc_flags);
+			if (page) {
+				*mode = RMQUEUE_CMA;
+				return page;
+			}
+		}
+		fallthrough;
+	case RMQUEUE_CLAIM:
+		page = __rmqueue_claim(zone, order, migratetype, alloc_flags);
+		if (page) {
+			/* Replenished native freelist, back to normal mode */
+			*mode = RMQUEUE_NORMAL;
+			return page;
+		}
+		fallthrough;
+	case RMQUEUE_STEAL:
+		if (!(alloc_flags & ALLOC_NOFRAGMENT)) {
+			page = __rmqueue_steal(zone, order, migratetype);
+			if (page) {
+				*mode = RMQUEUE_STEAL;
+				return page;
+			}
+		}
 	}
-	return page;
+	return NULL;
 }
 
 /*
@@ -2306,6 +2352,7 @@ static int rmqueue_bulk(struct zone *zon
 			unsigned long count, struct list_head *list,
 			int migratetype, unsigned int alloc_flags)
 {
+	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
 	unsigned long flags;
 	int i;
 
@@ -2317,7 +2364,7 @@ static int rmqueue_bulk(struct zone *zon
 	}
 	for (i = 0; i < count; ++i) {
 		struct page *page = __rmqueue(zone, order, migratetype,
-								alloc_flags);
+					      alloc_flags, &rmqm);
 		if (unlikely(page == NULL))
 			break;
 
@@ -2930,6 +2977,7 @@ struct page *rmqueue_buddy(struct zone *
 {
 	struct page *page;
 	unsigned long flags;
+	enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
 
 	do {
 		page = NULL;
@@ -2942,7 +2990,7 @@ struct page *rmqueue_buddy(struct zone *
 		if (alloc_flags & ALLOC_HIGHATOMIC)
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 		if (!page) {
-			page = __rmqueue(zone, order, migratetype, alloc_flags);
+			page = __rmqueue(zone, order, migratetype, alloc_flags, &rmqm);
 
 			/*
 			 * If the allocation fails, allow OOM handling and
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-speed-up-fallbacks-in-rmqueue_bulk.patch

