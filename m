Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEF933EC
	for <mm-commits@vger.kernel.org>; Tue, 25 Feb 2025 02:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740450496; cv=none; b=Bh0RG7kSrnDR3+N1jXiq5qH6ocVj5ez+97ZPVcGkeQJGgdLbvVSIXJckya6wo2kIrj97XrAehXUeHBYKuICOtPNmSdRI3AivFPG2/j7oXZ+d2BUUK8uwxNSQb+VwQELBIdQT/o5MoyBG3PhTYwNPpqn0iKAqwUmYAfvXOShhm78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740450496; c=relaxed/simple;
	bh=vbJI28dJqnEh96qoGU5Uy2PRYCactkcqnYfmySdgKYk=;
	h=Date:To:From:Subject:Message-Id; b=Q3lhZXNE9W8c9s2cfDKPDEUpCERrOGnoMDV9dguS+3IjX0zKF+hKJ1R8Jg+Jf6zHxREJMdnfajyJiA58QgSiOKnxSm4zQpzJEBZdC8yKqfSJA6DnhB7d7e/zVvh3EeBSg7DkePKpiD3LxGJunRw5UhKaJFJKbZ0ZTuHYl05WX4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W+1PopJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W+1PopJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C29BC4CED6;
	Tue, 25 Feb 2025 02:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740450496;
	bh=vbJI28dJqnEh96qoGU5Uy2PRYCactkcqnYfmySdgKYk=;
	h=Date:To:From:Subject:From;
	b=W+1PopJrgY2U71pg9lQxO5Lzgn03SDdQBzGgpSXzS1DaqVM99RYDlBycKIhD2py5S
	 j252R6DGQHK87TZUQBZV6VhApDyHI0TEEKrrN/h35TjOG69CP+JjC341CxfFRi/jUI
	 WF72mIt4mDKwcqcZZhuz2Tg63J0b5163HJ3GrGdk=
Date: Mon, 24 Feb 2025 18:28:15 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-dont-steal-single-pages-from-biggest-buddy.patch added to mm-unstable branch
Message-Id: <20250225022816.2C29BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: don't steal single pages from biggest buddy
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-dont-steal-single-pages-from-biggest-buddy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-dont-steal-single-pages-from-biggest-buddy.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: don't steal single pages from biggest buddy
Date: Mon, 24 Feb 2025 19:08:24 -0500

The fallback code searches for the biggest buddy first in an attempt to
steal the whole block and encourage type grouping down the line.

The approach used to be this:

- Non-movable requests will split the largest buddy and steal the
  remainder. This splits up contiguity, but it allows subsequent
  requests of this type to fall back into adjacent space.

- Movable requests go and look for the smallest buddy instead. The
  thinking is that movable requests can be compacted, so grouping is
  less important than retaining contiguity.

c0cd6f557b90 ("mm: page_alloc: fix freelist movement during block
conversion") enforces freelist type hygiene, which restricts stealing to
either claiming the whole block or just taking the requested chunk; no
additional pages or buddy remainders can be stolen any more.

The patch mishandled when to switch to finding the smallest buddy in that
new reality.  As a result, it may steal the exact request size, but from
the biggest buddy.  This causes fracturing for no good reason.

Fix this by committing to the new behavior: either steal the whole block,
or fall back to the smallest buddy.

Remove single-page stealing from steal_suitable_fallback().  Rename it to
try_to_steal_block() to make the intentions clear.  If this fails, always
fall back to the smallest buddy.

The following is from 4 runs of mmtest's thpchallenge.  "Pollute" is
single page fallback, "steal" is conversion of a partially used block. 
The numbers for free block conversions (omitted) are comparable.

				     vanilla	      patched

@pollute[unmovable from reclaimable]:	  27		  106
@pollute[unmovable from movable]:	  82		   46
@pollute[reclaimable from unmovable]:	 256		   83
@pollute[reclaimable from movable]:	  46		    8
@pollute[movable from unmovable]:	4841		  868
@pollute[movable from reclaimable]:	5278		12568

@steal[unmovable from reclaimable]:	  11		   12
@steal[unmovable from movable]:		 113		   49
@steal[reclaimable from unmovable]:	  19		   34
@steal[reclaimable from movable]:	  47		   21
@steal[movable from unmovable]:		 250		  183
@steal[movable from reclaimable]:	  81		   93

The allocator appears to do a better job at keeping stealing and polluting
to the first fallback preference.  As a result, the numbers for "from
movable" - the least preferred fallback option, and most detrimental to
compactability - are down across the board.

Link: https://lkml.kernel.org/r/20250225001023.1494422-2-hannes@cmpxchg.org
Fixes: c0cd6f557b90 ("mm: page_alloc: fix freelist movement during block conversion")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   80 +++++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 46 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-steal-single-pages-from-biggest-buddy
+++ a/mm/page_alloc.c
@@ -1986,13 +1986,12 @@ static inline bool boost_watermark(struc
  * can claim the whole pageblock for the requested migratetype. If not, we check
  * the pageblock for constituent pages; if at least half of the pages are free
  * or compatible, we can still claim the whole block, so pages freed in the
- * future will be put on the correct free list. Otherwise, we isolate exactly
- * the order we need from the fallback block and leave its migratetype alone.
+ * future will be put on the correct free list.
  */
 static struct page *
-steal_suitable_fallback(struct zone *zone, struct page *page,
-			int current_order, int order, int start_type,
-			unsigned int alloc_flags, bool whole_block)
+try_to_steal_block(struct zone *zone, struct page *page,
+		   int current_order, int order, int start_type,
+		   unsigned int alloc_flags)
 {
 	int free_pages, movable_pages, alike_pages;
 	unsigned long start_pfn;
@@ -2005,7 +2004,7 @@ steal_suitable_fallback(struct zone *zon
 	 * highatomic accounting.
 	 */
 	if (is_migrate_highatomic(block_type))
-		goto single_page;
+		return NULL;
 
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
@@ -2026,14 +2025,10 @@ steal_suitable_fallback(struct zone *zon
 	if (boost_watermark(zone) && (alloc_flags & ALLOC_KSWAPD))
 		set_bit(ZONE_BOOSTED_WATERMARK, &zone->flags);
 
-	/* We are not allowed to try stealing from the whole block */
-	if (!whole_block)
-		goto single_page;
-
 	/* moving whole block can fail due to zone boundary conditions */
 	if (!prep_move_freepages_block(zone, page, &start_pfn, &free_pages,
 				       &movable_pages))
-		goto single_page;
+		return NULL;
 
 	/*
 	 * Determine how many pages are compatible with our allocation.
@@ -2066,9 +2061,7 @@ steal_suitable_fallback(struct zone *zon
 		return __rmqueue_smallest(zone, order, start_type);
 	}
 
-single_page:
-	page_del_and_expand(zone, page, order, current_order, block_type);
-	return page;
+	return NULL;
 }
 
 /*
@@ -2250,14 +2243,19 @@ static bool unreserve_highatomic_pageblo
 }
 
 /*
- * Try finding a free buddy page on the fallback list and put it on the free
- * list of requested migratetype, possibly along with other pages from the same
- * block, depending on fragmentation avoidance heuristics. Returns true if
- * fallback was found so that __rmqueue_smallest() can grab it.
+ * Try finding a free buddy page on the fallback list.
+ *
+ * This will attempt to steal a whole pageblock for the requested type
+ * to ensure grouping of such requests in the future.
+ *
+ * If a whole block cannot be stolen, regress to __rmqueue_smallest()
+ * logic to at least break up as little contiguity as possible.
  *
  * The use of signed ints for order and current_order is a deliberate
  * deviation from the rest of this file, to make the for loop
  * condition simpler.
+ *
+ * Return the stolen page, or NULL if none can be found.
  */
 static __always_inline struct page *
 __rmqueue_fallback(struct zone *zone, int order, int start_migratetype,
@@ -2291,45 +2289,35 @@ __rmqueue_fallback(struct zone *zone, in
 		if (fallback_mt == -1)
 			continue;
 
-		/*
-		 * We cannot steal all free pages from the pageblock and the
-		 * requested migratetype is movable. In that case it's better to
-		 * steal and split the smallest available page instead of the
-		 * largest available page, because even if the next movable
-		 * allocation falls back into a different pageblock than this
-		 * one, it won't cause permanent fragmentation.
-		 */
-		if (!can_steal && start_migratetype == MIGRATE_MOVABLE
-					&& current_order > order)
-			goto find_smallest;
+		if (!can_steal)
+			break;
 
-		goto do_steal;
+		page = get_page_from_free_area(area, fallback_mt);
+		page = try_to_steal_block(zone, page, current_order, order,
+					  start_migratetype, alloc_flags);
+		if (page)
+			goto got_one;
 	}
 
-	return NULL;
+	if (alloc_flags & ALLOC_NOFRAGMENT)
+		return NULL;
 
-find_smallest:
+	/* No luck stealing blocks. Find the smallest fallback page */
 	for (current_order = order; current_order < NR_PAGE_ORDERS; current_order++) {
 		area = &(zone->free_area[current_order]);
 		fallback_mt = find_suitable_fallback(area, current_order,
 				start_migratetype, false, &can_steal);
-		if (fallback_mt != -1)
-			break;
-	}
-
-	/*
-	 * This should not happen - we already found a suitable fallback
-	 * when looking for the largest page.
-	 */
-	VM_BUG_ON(current_order > MAX_PAGE_ORDER);
+		if (fallback_mt == -1)
+			continue;
 
-do_steal:
-	page = get_page_from_free_area(area, fallback_mt);
+		page = get_page_from_free_area(area, fallback_mt);
+		page_del_and_expand(zone, page, order, current_order, fallback_mt);
+		goto got_one;
+	}
 
-	/* take off list, maybe claim block, expand remainder */
-	page = steal_suitable_fallback(zone, page, current_order, order,
-				       start_migratetype, alloc_flags, can_steal);
+	return NULL;
 
+got_one:
 	trace_mm_page_alloc_extfrag(page, order, current_order,
 		start_migratetype, fallback_mt);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-unshare-v2-only-charge-api-bits-again.patch
mm-memcontrol-move-stray-ratelimit-bits-to-v1.patch
mm-memcontrol-move-memsw-charge-callbacks-to-v1.patch
mm-page_alloc-dont-steal-single-pages-from-biggest-buddy.patch
mm-page_alloc-remove-remnants-of-unlocked-migratetype-updates.patch
mm-page_alloc-group-fallback-functions-together.patch

