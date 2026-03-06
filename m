Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F133C18787A
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 00:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772755280; cv=none; b=jqu0QCelVy9XG1G1MJnCHP6w3n7xcRKYJY9LIbIeWcyPTmc9xQ20V32pLemZz24exdqQWsbKnOh7rBqEcX40A2BK26lHXomVLr0zj4eGNyRS6EmGv3tksXqn+CniaBRQbyjzzllHfjulKsZQpqCG1hp8R8mnuKHqHwDoGKrrI18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772755280; c=relaxed/simple;
	bh=7jYgTIM6XQw7dsrCv+k1sdiQDF8YfJpYkC6kISD3xC0=;
	h=Date:To:From:Subject:Message-Id; b=txneDCwU3L3HE3qVYgIQunoY4BvFk5mFeb6M6KCYvLdycydGDZ4Pb/64f8muJxhrT1gBzfk/rLxmykn0PO6CAnc1D0bHWft3tkbxOCjndEr7DurFxnl2e+W0vlOm7E/V6lvWMhdcBFSckMAx67c6VatzEVfg968eh/ArPwnZH9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w7G66owK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w7G66owK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976A5C116C6;
	Fri,  6 Mar 2026 00:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772755279;
	bh=7jYgTIM6XQw7dsrCv+k1sdiQDF8YfJpYkC6kISD3xC0=;
	h=Date:To:From:Subject:From;
	b=w7G66owKup5NknLIc3zwMvbyzejp0FGsF/bJ78s0673iFmTlLm8QVLh0iMF85cic+
	 5oPOGJiqUuW4sBiU7XDC6oIXHfmpzroETuGaqznv4wZ0GfjhHTCG1KGDtNTqgwh4RA
	 ZxnQ8aNe51iVxTZ8NhKtwISsk3Js0BQ+JPgfL+iA=
Date: Thu, 05 Mar 2026 16:01:18 -0800
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-zone-lock-to-zone-_lock-fix-3.patch added to mm-new branch
Message-Id: <20260306000119.976A5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: documentation: standardize on "zone lock" terminology
has been added to the -mm mm-new branch.  Its filename is
     mm-rename-zone-lock-to-zone-_lock-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-zone-lock-to-zone-_lock-fix-3.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -729,7 +729,7 @@ static inline unsigned int buddy_order(s
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
@@ -2476,7 +2476,7 @@ enum rmqueue_mode {
 
 /*
  * Do the hard work of removing an element from the buddy allocator.
- * Call me with the zone->_lock already held.
+ * Call me with the zone lock already held.
  */
 static __always_inline struct page *
 __rmqueue(struct zone *zone, unsigned int order, int migratetype,
@@ -2504,7 +2504,7 @@ __rmqueue(struct zone *zone, unsigned in
 	 * fallbacks modes with increasing levels of fragmentation risk.
 	 *
 	 * The fallback logic is expensive and rmqueue_bulk() calls in
-	 * a loop with the zone->_lock held, meaning the freelists are
+	 * a loop with the zone lock held, meaning the freelists are
 	 * not subject to any outside changes. Remember in *mode where
 	 * we found pay dirt, to save us the search on the next call.
 	 */
@@ -7090,7 +7090,7 @@ int alloc_contig_frozen_range_noprof(uns
 	 * pages.  Because of this, we reserve the bigger range and
 	 * once this is done free the pages we are not interested in.
 	 *
-	 * We don't have to hold zone->_lock here because the pages are
+	 * We don't have to hold zone lock here because the pages are
 	 * isolated thus they won't get removed from buddy.
 	 */
 	outer_start = find_large_buddy(start);
@@ -7659,7 +7659,7 @@ void accept_page(struct page *page)
 		return;
 	}
 
-	/* Unlocks zone->_lock */
+	/* Unlocks zone lock */
 	__accept_page(zone, &flags, page);
 }
 
@@ -7676,7 +7676,7 @@ static bool try_to_accept_memory_one(str
 		return false;
 	}
 
-	/* Unlocks zone->_lock */
+	/* Unlocks zone lock */
 	__accept_page(zone, &flags, page);
 
 	return true;
@@ -7817,7 +7817,7 @@ struct page *alloc_frozen_pages_nolock_n
 
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
mm-rename-zone-lock-to-zone-_lock-fix-2.patch
mm-rename-zone-lock-to-zone-_lock-fix-3.patch
mm-add-tracepoints-for-zone-lock.patch

