Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3469B3E716D
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 14:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450042; cv=none; b=Gyb5NFXppfSQFPC2wEu1PIKENbvLI032YwVol1mOTKc6VNMT7KfB0o1FMh6vcAFaUVvm+x0tLwnAz8j/Je/OgfKPWhNiUivvYQfPB5rgwQkT7nUgzx7V7Raitg/z55LZaARukgHM3/DoBwUZjnb2536XG2dEmukMSBhTnFk2q2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450042; c=relaxed/simple;
	bh=7r+PV58vpZiSC1Z8sQ6YJqC+C/h2aOor9L4a3KCjn34=;
	h=Date:To:From:Subject:Message-Id; b=e2P1/sgj+OWAJJjqMLT90X5x9/DXt8s+uzvBD76h6mX7M5TQhardh0cnNm/a+Mx+rLnIYqyQBirVioY00q37S2dpf7Ixnl6ncmkShfyi2B40xdzOJfHCLySauO4zMeM0W7X4tiDaCv0o5G8sp7O+P9DZJ9xYgvoE/DFssz8VWJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rUAlbKof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rUAlbKof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F79DC4CEF7;
	Wed, 25 Mar 2026 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774450041;
	bh=7r+PV58vpZiSC1Z8sQ6YJqC+C/h2aOor9L4a3KCjn34=;
	h=Date:To:From:Subject:From;
	b=rUAlbKofctN8sdMhc3H0+5QP2R3fQR3RT2mpobnKk/qiHMU2mEAFZdtI9h31bdH/8
	 PXq5TZx2lZcAnuwpDHFIieKMPYpP6mt96R47ENNOJNddD839qbSj9XoNqRwHCtI+w/
	 cej5N/LTOqUkVMMxbNi6wP/3iTF0zlI503KgLtl0=
Date: Wed, 25 Mar 2026 07:47:21 -0700
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rename-zone-lock-to-zone-_lock-fix-3.patch removed from -mm tree
Message-Id: <20260325144721.9F79DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: documentation: standardize on "zone lock" terminology
has been removed from the -mm tree.  Its filename was
     mm-rename-zone-lock-to-zone-_lock-fix-3.patch

This patch was dropped because it was folded into mm-rename-zone-lock-to-zone-_lock.patch

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: documentation: standardize on "zone lock" terminology
Date: Thu, 5 Mar 2026 10:36:17 -0800

During review of the zone lock tracing series it was suggested to
standardize documentation and comments on the term "zone lock" instead of
using zone_lock or referring to the internal field zone->_lock.

Update references accordingly.

Link: https://lkml.kernel.org/r/aanSnywUXTVPaYUj@shell.ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/physical_memory.rst |    4 ++--
 Documentation/trace/events-kmem.rst  |    8 ++++----
 mm/compaction.c                      |    2 +-
 mm/internal.h                        |    2 +-
 mm/page_alloc.c                      |   12 ++++++------
 mm/page_isolation.c                  |    4 ++--
 mm/page_owner.c                      |    2 +-
 7 files changed, 17 insertions(+), 17 deletions(-)

--- a/Documentation/mm/physical_memory.rst~mm-rename-zone-lock-to-zone-_lock-fix-3
+++ a/Documentation/mm/physical_memory.rst
@@ -500,11 +500,11 @@ General
 ``nr_isolate_pageblock``
   Number of isolated pageblocks. It is used to solve incorrect freepage counting
   problem due to racy retrieving migratetype of pageblock. Protected by
-  ``zone_lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
+  zone lock. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
 
 ``span_seqlock``
   The seqlock to protect ``zone_start_pfn`` and ``spanned_pages``. It is a
-  seqlock because it has to be read outside of ``zone_lock``, and it is done in
+  seqlock because it has to be read outside of zone lock, and it is done in
   the main allocator path. However, the seqlock is written quite infrequently.
   Defined only when ``CONFIG_MEMORY_HOTPLUG`` is enabled.
 
--- a/Documentation/trace/events-kmem.rst~mm-rename-zone-lock-to-zone-_lock-fix-3
+++ a/Documentation/trace/events-kmem.rst
@@ -57,7 +57,7 @@ the per-CPU allocator (high performance)
 
 If pages are allocated directly from the buddy allocator, the
 mm_page_alloc_zone_locked event is triggered. This event is important as high
-amounts of activity imply high activity on the zone_lock. Taking this lock
+amounts of activity imply high activity on the zone lock. Taking this lock
 impairs performance by disabling interrupts, dirtying cache lines between
 CPUs and serialising many CPUs.
 
@@ -79,11 +79,11 @@ contention on the lruvec->lru_lock.
   mm_page_pcpu_drain		page=%p pfn=%lu order=%d cpu=%d migratetype=%d
 
 In front of the page allocator is a per-cpu page allocator. It exists only
-for order-0 pages, reduces contention on the zone_lock and reduces the
+for order-0 pages, reduces contention on the zone lock and reduces the
 amount of writing on struct page.
 
 When a per-CPU list is empty or pages of the wrong type are allocated,
-the zone_lock will be taken once and the per-CPU list refilled. The event
+the zone lock will be taken once and the per-CPU list refilled. The event
 triggered is mm_page_alloc_zone_locked for each page allocated with the
 event indicating whether it is for a percpu_refill or not.
 
@@ -92,7 +92,7 @@ which triggers a mm_page_pcpu_drain even
 
 The individual nature of the events is so that pages can be tracked
 between allocation and freeing. A number of drain or refill pages that occur
-consecutively imply the zone_lock being taken once. Large amounts of per-CPU
+consecutively imply the zone lock being taken once. Large amounts of per-CPU
 refills and drains could imply an imbalance between CPUs where too much work
 is being concentrated in one place. It could also indicate that the per-CPU
 lists should be a larger size. Finally, large amounts of refills on one CPU
--- a/mm/compaction.c~mm-rename-zone-lock-to-zone-_lock-fix-3
+++ a/mm/compaction.c
@@ -1419,7 +1419,7 @@ static bool suitable_migration_target(st
 		int order = cc->order > 0 ? cc->order : pageblock_order;
 
 		/*
-		 * We are checking page_order without zone->_lock taken. But
+		 * We are checking page_order without zone lock taken. But
 		 * the only small danger is that we skip a potentially suitable
 		 * pageblock, so it's not worth to check order for valid range.
 		 */
--- a/mm/internal.h~mm-rename-zone-lock-to-zone-_lock-fix-3
+++ a/mm/internal.h
@@ -727,7 +727,7 @@ static inline unsigned int buddy_order(s
  * (d) a page and its buddy are in the same zone.
  *
  * For recording whether a page is in the buddy system, we set PageBuddy.
- * Setting, clearing, and testing PageBuddy is serialized by zone->_lock.
+ * Setting, clearing, and testing PageBuddy is serialized by zone lock.
  *
  * For recording page's order, we use page_private(page).
  */
--- a/mm/page_alloc.c~mm-rename-zone-lock-to-zone-_lock-fix-3
+++ a/mm/page_alloc.c
@@ -2442,7 +2442,7 @@ enum rmqueue_mode {
 
 /*
  * Do the hard work of removing an element from the buddy allocator.
- * Call me with the zone->_lock already held.
+ * Call me with the zone lock already held.
  */
 static __always_inline struct page *
 __rmqueue(struct zone *zone, unsigned int order, int migratetype,
@@ -2470,7 +2470,7 @@ __rmqueue(struct zone *zone, unsigned in
 	 * fallbacks modes with increasing levels of fragmentation risk.
 	 *
 	 * The fallback logic is expensive and rmqueue_bulk() calls in
-	 * a loop with the zone->_lock held, meaning the freelists are
+	 * a loop with the zone lock held, meaning the freelists are
 	 * not subject to any outside changes. Remember in *mode where
 	 * we found pay dirt, to save us the search on the next call.
 	 */
@@ -7048,7 +7048,7 @@ int alloc_contig_frozen_range_noprof(uns
 	 * pages.  Because of this, we reserve the bigger range and
 	 * once this is done free the pages we are not interested in.
 	 *
-	 * We don't have to hold zone->_lock here because the pages are
+	 * We don't have to hold zone lock here because the pages are
 	 * isolated thus they won't get removed from buddy.
 	 */
 	outer_start = find_large_buddy(start);
@@ -7617,7 +7617,7 @@ void accept_page(struct page *page)
 		return;
 	}
 
-	/* Unlocks zone->_lock */
+	/* Unlocks zone lock */
 	__accept_page(zone, &flags, page);
 }
 
@@ -7634,7 +7634,7 @@ static bool try_to_accept_memory_one(str
 		return false;
 	}
 
-	/* Unlocks zone->_lock */
+	/* Unlocks zone lock */
 	__accept_page(zone, &flags, page);
 
 	return true;
@@ -7775,7 +7775,7 @@ struct page *alloc_frozen_pages_nolock_n
 
 	/*
 	 * Best effort allocation from percpu free list.
-	 * If it's empty attempt to spin_trylock zone->_lock.
+	 * If it's empty attempt to spin_trylock zone lock.
 	 */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
 
--- a/mm/page_isolation.c~mm-rename-zone-lock-to-zone-_lock-fix-3
+++ a/mm/page_isolation.c
@@ -212,7 +212,7 @@ static int set_migratetype_isolate(struc
 	zone_unlock_irqrestore(zone, flags);
 	if (mode == PB_ISOLATE_MODE_MEM_OFFLINE) {
 		/*
-		 * printk() with zone->_lock held will likely trigger a
+		 * printk() with zone lock held will likely trigger a
 		 * lockdep splat, so defer it here.
 		 */
 		dump_page(unmovable, "unmovable page");
@@ -553,7 +553,7 @@ void undo_isolate_page_range(unsigned lo
 /*
  * Test all pages in the range is free(means isolated) or not.
  * all pages in [start_pfn...end_pfn) must be in the same zone.
- * zone->_lock must be held before call this.
+ * zone lock must be held before call this.
  *
  * Returns the last tested pfn.
  */
--- a/mm/page_owner.c~mm-rename-zone-lock-to-zone-_lock-fix-3
+++ a/mm/page_owner.c
@@ -799,7 +799,7 @@ static void init_pages_in_zone(struct zo
 				continue;
 
 			/*
-			 * To avoid having to grab zone->_lock, be a little
+			 * To avoid having to grab zone lock, be a little
 			 * careful when reading buddy page order. The only
 			 * danger is that we skip too much and potentially miss
 			 * some early allocated pages, which is better than
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-introduce-zone-lock-wrappers.patch
mm-convert-zone-lock-users-to-wrappers.patch
mm-convert-compaction-to-zone-lock-wrappers.patch
mm-rename-zone-lock-to-zone-_lock.patch
mm-add-tracepoints-for-zone-lock.patch

