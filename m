Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E4A3EF0D4
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 14:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774450114; cv=none; b=BvwC5QpgY5Zh5e3E/l2jJ/nkJ9RPcGZSjCj5oUoftfvlJQiYAwG8rEBkmSJ35GoVEp8j5swBYXtRI//1VEo42IOA2L36PRZv9WLF4tSseYkZR+nfuXnTPTLVPUsOM9rV27V57A4tLGJK2ntwV3B4Cp3txntYHwRxY+ARTCUjhEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774450114; c=relaxed/simple;
	bh=DbrpRITO8zpgZIgBs7lvNDvfdZbG3vL+Xo8+3CrC87A=;
	h=Date:To:From:Subject:Message-Id; b=rlqQJsCSg7ad7WbxWz8qG5a7PD/5VbRsOt0YFTq1FDYagOmGvVkcjpjHtcj88bTVB6gtCvxIuNadF4MYWb6zrZBtQqyh/LH28GHlX49ty8R6Ixbx4efGD/jTZiqbe0n/AEhTgQzKBSKBUC9R5InsQLe32z5CiIYzNNn1dYTqS+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KDujz0K9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KDujz0K9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FA7C4CEF7;
	Wed, 25 Mar 2026 14:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774450114;
	bh=DbrpRITO8zpgZIgBs7lvNDvfdZbG3vL+Xo8+3CrC87A=;
	h=Date:To:From:Subject:From;
	b=KDujz0K9JyGJymihQHTMURitEYYxh+gaHX9iss6K/IjRRUSMMcW1yIC0CHJ1zHW9J
	 r19eoANI3Snn5X2tDAvizlaR+hxnLP7hBmFdfQfFRHveBD6b0HKAeRAfZQEbDQwG+l
	 4/QxrhBqVQEzJJY7pF0q5MWjzdGgmeN4FE0Ah770=
Date: Wed, 25 Mar 2026 07:48:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,osalvador@suse.de,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lenb@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,akpm@linux-foundation.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-rename-zone-lock-to-zone-_lock.patch removed from -mm tree
Message-Id: <20260325144834.56FA7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename zone->lock to zone->_lock
has been removed from the -mm tree.  Its filename was
     mm-rename-zone-lock-to-zone-_lock.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: rename zone->lock to zone->_lock
Date: Fri, 27 Feb 2026 16:00:26 +0000

This intentionally breaks direct users of zone->lock at compile time so
all call sites are converted to the zone lock wrappers.  Without the
rename, present and future out-of-tree code could continue using
spin_lock(&zone->lock) and bypass the wrappers and tracing infrastructure.

No functional change intended.

[akpm@linux-foundation.org: update comments in mmzone.h]
[d@ilvokhin.com: fix remaining zone->lock references]
  Link: https://lkml.kernel.org/r/aabvc4Xhc9qBfaG7@shell.ilvokhin.com
[d@ilvokhin.com: documentation: standardize on "zone lock" terminology]
  Link: https://lkml.kernel.org/r/aanSnywUXTVPaYUj@shell.ilvokhin.com
Link: https://lkml.kernel.org/r/d61500c5784c64e971f4d328c57639303c475f81.1772206930.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/physical_memory.rst |    4 ++--
 Documentation/trace/events-kmem.rst  |    8 ++++----
 include/linux/mmzone.h               |   17 ++++++++++-------
 include/linux/mmzone_lock.h          |   12 ++++++------
 mm/compaction.c                      |    4 ++--
 mm/internal.h                        |    2 +-
 mm/page_alloc.c                      |   16 ++++++++--------
 mm/page_isolation.c                  |    4 ++--
 mm/page_owner.c                      |    2 +-
 9 files changed, 36 insertions(+), 33 deletions(-)

--- a/include/linux/mmzone.h~mm-rename-zone-lock-to-zone-_lock
+++ a/include/linux/mmzone.h
@@ -1038,12 +1038,12 @@ struct zone {
 	 * Locking rules:
 	 *
 	 * zone_start_pfn and spanned_pages are protected by span_seqlock.
-	 * It is a seqlock because it has to be read outside of zone->lock,
+	 * It is a seqlock because it has to be read outside of zone_lock,
 	 * and it is done in the main allocator path.  But, it is written
 	 * quite infrequently.
 	 *
-	 * The span_seq lock is declared along with zone->lock because it is
-	 * frequently read in proximity to zone->lock.  It's good to
+	 * The span_seq lock is declared along with zone_lock because it is
+	 * frequently read in proximity to zone_lock.  It's good to
 	 * give them a chance of being in the same cacheline.
 	 *
 	 * Write access to present_pages at runtime should be protected by
@@ -1066,7 +1066,7 @@ struct zone {
 	/*
 	 * Number of isolated pageblock. It is used to solve incorrect
 	 * freepage counting problem due to racy retrieving migratetype
-	 * of pageblock. Protected by zone->lock.
+	 * of pageblock. Protected by zone_lock.
 	 */
 	unsigned long		nr_isolate_pageblock;
 #endif
@@ -1095,8 +1095,11 @@ struct zone {
 	/* zone flags, see below */
 	unsigned long		flags;
 
-	/* Primarily protects free_area */
-	spinlock_t		lock;
+	/*
+	 * Primarily protects free_area. Should be accessed via zone_lock_*
+	 * helpers.
+	 */
+	spinlock_t		_lock;
 
 	/* Pages to be freed when next trylock succeeds */
 	struct llist_head	trylock_free_pages;
@@ -1500,7 +1503,7 @@ typedef struct pglist_data {
 	 * manipulate node_size_lock without checking for CONFIG_MEMORY_HOTPLUG
 	 * or CONFIG_DEFERRED_STRUCT_PAGE_INIT.
 	 *
-	 * Nests above zone->lock and zone->span_seqlock
+	 * Nests above zone_lock and zone->span_seqlock
 	 */
 	spinlock_t node_size_lock;
 #endif
--- a/include/linux/mmzone_lock.h~mm-rename-zone-lock-to-zone-_lock
+++ a/include/linux/mmzone_lock.h
@@ -7,32 +7,32 @@
 
 static inline void zone_lock_init(struct zone *zone)
 {
-	spin_lock_init(&zone->lock);
+	spin_lock_init(&zone->_lock);
 }
 
 #define zone_lock_irqsave(zone, flags)				\
 do {								\
-	spin_lock_irqsave(&(zone)->lock, flags);		\
+	spin_lock_irqsave(&(zone)->_lock, flags);		\
 } while (0)
 
 #define zone_trylock_irqsave(zone, flags)			\
 ({								\
-	spin_trylock_irqsave(&(zone)->lock, flags);		\
+	spin_trylock_irqsave(&(zone)->_lock, flags);		\
 })
 
 static inline void zone_unlock_irqrestore(struct zone *zone, unsigned long flags)
 {
-	spin_unlock_irqrestore(&zone->lock, flags);
+	spin_unlock_irqrestore(&zone->_lock, flags);
 }
 
 static inline void zone_lock_irq(struct zone *zone)
 {
-	spin_lock_irq(&zone->lock);
+	spin_lock_irq(&zone->_lock);
 }
 
 static inline void zone_unlock_irq(struct zone *zone)
 {
-	spin_unlock_irq(&zone->lock);
+	spin_unlock_irq(&zone->_lock);
 }
 
 #endif /* _LINUX_MMZONE_LOCK_H */
--- a/mm/compaction.c~mm-rename-zone-lock-to-zone-_lock
+++ a/mm/compaction.c
@@ -506,7 +506,7 @@ static bool test_and_set_skip(struct com
 static bool compact_zone_lock_irqsave(struct zone *zone,
 				      unsigned long *flags,
 				      struct compact_control *cc)
-	__acquires(&zone->lock)
+	__acquires(&zone->_lock)
 {
 	/* Track if the lock is contended in async mode */
 	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
@@ -1419,7 +1419,7 @@ static bool suitable_migration_target(st
 		int order = cc->order > 0 ? cc->order : pageblock_order;
 
 		/*
-		 * We are checking page_order without zone->lock taken. But
+		 * We are checking page_order without zone lock taken. But
 		 * the only small danger is that we skip a potentially suitable
 		 * pageblock, so it's not worth to check order for valid range.
 		 */
--- a/mm/internal.h~mm-rename-zone-lock-to-zone-_lock
+++ a/mm/internal.h
@@ -733,7 +733,7 @@ static inline unsigned int buddy_order(s
  * (d) a page and its buddy are in the same zone.
  *
  * For recording whether a page is in the buddy system, we set PageBuddy.
- * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
+ * Setting, clearing, and testing PageBuddy is serialized by zone lock.
  *
  * For recording page's order, we use page_private(page).
  */
--- a/mm/page_alloc.c~mm-rename-zone-lock-to-zone-_lock
+++ a/mm/page_alloc.c
@@ -779,7 +779,7 @@ compaction_capture(struct capture_contro
 static inline void account_freepages(struct zone *zone, int nr_pages,
 				     int migratetype)
 {
-	lockdep_assert_held(&zone->lock);
+	lockdep_assert_held(&zone->_lock);
 
 	if (is_migrate_isolate(migratetype))
 		return;
@@ -2442,7 +2442,7 @@ enum rmqueue_mode {
 
 /*
  * Do the hard work of removing an element from the buddy allocator.
- * Call me with the zone->lock already held.
+ * Call me with the zone lock already held.
  */
 static __always_inline struct page *
 __rmqueue(struct zone *zone, unsigned int order, int migratetype,
@@ -2470,7 +2470,7 @@ __rmqueue(struct zone *zone, unsigned in
 	 * fallbacks modes with increasing levels of fragmentation risk.
 	 *
 	 * The fallback logic is expensive and rmqueue_bulk() calls in
-	 * a loop with the zone->lock held, meaning the freelists are
+	 * a loop with the zone lock held, meaning the freelists are
 	 * not subject to any outside changes. Remember in *mode where
 	 * we found pay dirt, to save us the search on the next call.
 	 */
@@ -3167,7 +3167,7 @@ void __putback_isolated_page(struct page
 	struct zone *zone = page_zone(page);
 
 	/* zone lock should be held when this function is called */
-	lockdep_assert_held(&zone->lock);
+	lockdep_assert_held(&zone->_lock);
 
 	/* Return isolated page to tail of freelist. */
 	__free_one_page(page, page_to_pfn(page), zone, order, mt,
@@ -7048,7 +7048,7 @@ int alloc_contig_frozen_range_noprof(uns
 	 * pages.  Because of this, we reserve the bigger range and
 	 * once this is done free the pages we are not interested in.
 	 *
-	 * We don't have to hold zone->lock here because the pages are
+	 * We don't have to hold zone lock here because the pages are
 	 * isolated thus they won't get removed from buddy.
 	 */
 	outer_start = find_large_buddy(start);
@@ -7617,7 +7617,7 @@ void accept_page(struct page *page)
 		return;
 	}
 
-	/* Unlocks zone->lock */
+	/* Unlocks zone lock */
 	__accept_page(zone, &flags, page);
 }
 
@@ -7634,7 +7634,7 @@ static bool try_to_accept_memory_one(str
 		return false;
 	}
 
-	/* Unlocks zone->lock */
+	/* Unlocks zone lock */
 	__accept_page(zone, &flags, page);
 
 	return true;
@@ -7775,7 +7775,7 @@ struct page *alloc_frozen_pages_nolock_n
 
 	/*
 	 * Best effort allocation from percpu free list.
-	 * If it's empty attempt to spin_trylock zone->lock.
+	 * If it's empty attempt to spin_trylock zone lock.
 	 */
 	page = get_page_from_freelist(alloc_gfp, order, alloc_flags, &ac);
 
--- a/mm/page_isolation.c~mm-rename-zone-lock-to-zone-_lock
+++ a/mm/page_isolation.c
@@ -212,7 +212,7 @@ static int set_migratetype_isolate(struc
 	zone_unlock_irqrestore(zone, flags);
 	if (mode == PB_ISOLATE_MODE_MEM_OFFLINE) {
 		/*
-		 * printk() with zone->lock held will likely trigger a
+		 * printk() with zone lock held will likely trigger a
 		 * lockdep splat, so defer it here.
 		 */
 		dump_page(unmovable, "unmovable page");
@@ -553,7 +553,7 @@ void undo_isolate_page_range(unsigned lo
 /*
  * Test all pages in the range is free(means isolated) or not.
  * all pages in [start_pfn...end_pfn) must be in the same zone.
- * zone->lock must be held before call this.
+ * zone lock must be held before call this.
  *
  * Returns the last tested pfn.
  */
--- a/mm/page_owner.c~mm-rename-zone-lock-to-zone-_lock
+++ a/mm/page_owner.c
@@ -799,7 +799,7 @@ static void init_pages_in_zone(struct zo
 				continue;
 
 			/*
-			 * To avoid having to grab zone->lock, be a little
+			 * To avoid having to grab zone lock, be a little
 			 * careful when reading buddy page order. The only
 			 * danger is that we skip too much and potentially miss
 			 * some early allocated pages, which is better than
--- a/Documentation/mm/physical_memory.rst~mm-rename-zone-lock-to-zone-_lock
+++ a/Documentation/mm/physical_memory.rst
@@ -500,11 +500,11 @@ General
 ``nr_isolate_pageblock``
   Number of isolated pageblocks. It is used to solve incorrect freepage counting
   problem due to racy retrieving migratetype of pageblock. Protected by
-  ``zone->lock``. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
+  zone lock. Defined only when ``CONFIG_MEMORY_ISOLATION`` is enabled.
 
 ``span_seqlock``
   The seqlock to protect ``zone_start_pfn`` and ``spanned_pages``. It is a
-  seqlock because it has to be read outside of ``zone->lock``, and it is done in
+  seqlock because it has to be read outside of zone lock, and it is done in
   the main allocator path. However, the seqlock is written quite infrequently.
   Defined only when ``CONFIG_MEMORY_HOTPLUG`` is enabled.
 
--- a/Documentation/trace/events-kmem.rst~mm-rename-zone-lock-to-zone-_lock
+++ a/Documentation/trace/events-kmem.rst
@@ -57,7 +57,7 @@ the per-CPU allocator (high performance)
 
 If pages are allocated directly from the buddy allocator, the
 mm_page_alloc_zone_locked event is triggered. This event is important as high
-amounts of activity imply high activity on the zone->lock. Taking this lock
+amounts of activity imply high activity on the zone lock. Taking this lock
 impairs performance by disabling interrupts, dirtying cache lines between
 CPUs and serialising many CPUs.
 
@@ -79,11 +79,11 @@ contention on the lruvec->lru_lock.
   mm_page_pcpu_drain		page=%p pfn=%lu order=%d cpu=%d migratetype=%d
 
 In front of the page allocator is a per-cpu page allocator. It exists only
-for order-0 pages, reduces contention on the zone->lock and reduces the
+for order-0 pages, reduces contention on the zone lock and reduces the
 amount of writing on struct page.
 
 When a per-CPU list is empty or pages of the wrong type are allocated,
-the zone->lock will be taken once and the per-CPU list refilled. The event
+the zone lock will be taken once and the per-CPU list refilled. The event
 triggered is mm_page_alloc_zone_locked for each page allocated with the
 event indicating whether it is for a percpu_refill or not.
 
@@ -92,7 +92,7 @@ which triggers a mm_page_pcpu_drain even
 
 The individual nature of the events is so that pages can be tracked
 between allocation and freeing. A number of drain or refill pages that occur
-consecutively imply the zone->lock being taken once. Large amounts of per-CPU
+consecutively imply the zone lock being taken once. Large amounts of per-CPU
 refills and drains could imply an imbalance between CPUs where too much work
 is being concentrated in one place. It could also indicate that the per-CPU
 lists should be a larger size. Finally, large amounts of refills on one CPU
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-add-tracepoints-for-zone-lock.patch

