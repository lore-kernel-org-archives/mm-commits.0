Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7272BF013
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 02:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750126813; cv=none; b=qE/mCPwtShXQoV9p5TTFKLu7IwDoUxKB11SNbLbBiCU3LXBwFUc86YN9b7To3p+lezXFdpbcvddSbT9aKOd3CoINoai2JaSsXMLRXWDupxu2Ab7gL8OWCn09dT3bHxXmZuN2z7z9u6T5wlHvVts6ALfiKZf53cDKX9J2l7oB0Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750126813; c=relaxed/simple;
	bh=o998QoPK5MjGQonBe240I9mJPkH2Er/1MI2yhBnptXM=;
	h=Date:To:From:Subject:Message-Id; b=HmoFXJ4vOe0JYRNdr2H3h23YK84b22gUtCxyKwYV9AkuYFZRaquL/e2psurrokxkDOE6TuWp2madzeMYNhaWrmUoLkCi+h2soD9hf7jxIhgPSz0d3kKQxjMbo3BswwcaECigmGDQ4D7xjkWEoHiTMRkKDwomIKi9BkqlNTPgDjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ijTHNP7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ijTHNP7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31294C4CEEA;
	Tue, 17 Jun 2025 02:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750126813;
	bh=o998QoPK5MjGQonBe240I9mJPkH2Er/1MI2yhBnptXM=;
	h=Date:To:From:Subject:From;
	b=ijTHNP7Rt9MagtjQ7pcPd+/nFqcsvPDoUSs3dNhXjSX9WBhQvlQUWsx5rZ0lbqQ9J
	 CFvZoU+sATIzKs6/4M0iKFmjRg6q+fNuJIWL5D64sQWbdKc4PuIsMVJAwuZtH5ti3J
	 NWM6eLbzdjW0dDM+POey0m4eAEQLhrhm9UL6+YTw=
Date: Mon, 16 Jun 2025 19:20:12 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,richardycc@google.com,osalvador@suse.de,mhocko@suse.com,mgorman@techsingularity.net,kirill.shutemov@linux.intel.com,jackmanb@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch added to mm-new branch
Message-Id: <20250617022013.31294C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_isolation: remove migratetype from move_freepages_block_isolate()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_isolation: remove migratetype from move_freepages_block_isolate()
Date: Mon, 16 Jun 2025 22:11:12 -0400

Since migratetype is no longer overwritten during pageblock isolation,
moving a pageblock out of MIGRATE_ISOLATE no longer needs a new
migratetype.

Add pageblock_isolate_and_move_free_pages() and
pageblock_unisolate_and_move_free_pages() to be explicit about the page
isolation operations.  Both share the common code in
__move_freepages_block_isolate(), which is renamed from
move_freepages_block_isolate().

Add toggle_pageblock_isolate() to flip pageblock isolation bit in
__move_freepages_block_isolate().

Make set_pageblock_migratetype() only accept non MIGRATE_ISOLATE types, so
that one should use set_pageblock_isolate() to isolate pageblocks.  As a
result, move pageblock migratetype code out of __move_freepages_block().

Link: https://lkml.kernel.org/r/20250617021115.2331563-5-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Richard Chang <richardycc@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    5 -
 mm/page_alloc.c                |   80 ++++++++++++++++++++++++-------
 mm/page_isolation.c            |   21 +++-----
 3 files changed, 75 insertions(+), 31 deletions(-)

--- a/include/linux/page-isolation.h~mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate
+++ a/include/linux/page-isolation.h
@@ -44,10 +44,9 @@ static inline void set_pageblock_isolate
 void __meminit init_pageblock_migratetype(struct page *page,
 					  enum migratetype migratetype,
 					  bool isolate);
-void set_pageblock_migratetype(struct page *page, enum migratetype migratetype);
 
-bool move_freepages_block_isolate(struct zone *zone, struct page *page,
-				  int migratetype);
+bool pageblock_isolate_and_move_free_pages(struct zone *zone, struct page *page);
+bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *page);
 
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			     int migratetype, int flags);
--- a/mm/page_alloc.c~mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate
+++ a/mm/page_alloc.c
@@ -525,8 +525,8 @@ void clear_pfnblock_bit(const struct pag
  * @page: The page within the block of interest
  * @migratetype: migratetype to set
  */
-__always_inline void set_pageblock_migratetype(struct page *page,
-					       enum migratetype migratetype)
+static void set_pageblock_migratetype(struct page *page,
+				      enum migratetype migratetype)
 {
 	if (unlikely(page_group_by_mobility_disabled &&
 		     migratetype < MIGRATE_PCPTYPES))
@@ -534,9 +534,13 @@ __always_inline void set_pageblock_migra
 
 #ifdef CONFIG_MEMORY_ISOLATION
 	if (migratetype == MIGRATE_ISOLATE) {
-		set_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+		VM_WARN_ONCE(1,
+			"Use set_pageblock_isolate() for pageblock isolation");
 		return;
 	}
+	VM_WARN_ONCE(get_pfnblock_bit(page, page_to_pfn(page),
+				      PB_migrate_isolate),
+		     "Use clear_pageblock_isolate() to unisolate pageblock");
 	/* MIGRATETYPE_AND_ISO_MASK clears PB_migrate_isolate if it is set */
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page),
@@ -1921,8 +1925,8 @@ static inline struct page *__rmqueue_cma
 #endif
 
 /*
- * Change the type of a block and move all its free pages to that
- * type's freelist.
+ * Move all free pages of a block to new type's freelist. Caller needs to
+ * change the block type.
  */
 static int __move_freepages_block(struct zone *zone, unsigned long start_pfn,
 				  int old_mt, int new_mt)
@@ -1954,8 +1958,6 @@ static int __move_freepages_block(struct
 		pages_moved += 1 << order;
 	}
 
-	set_pageblock_migratetype(pfn_to_page(start_pfn), new_mt);
-
 	return pages_moved;
 }
 
@@ -2013,11 +2015,16 @@ static int move_freepages_block(struct z
 				int old_mt, int new_mt)
 {
 	unsigned long start_pfn;
+	int res;
 
 	if (!prep_move_freepages_block(zone, page, &start_pfn, NULL, NULL))
 		return -1;
 
-	return __move_freepages_block(zone, start_pfn, old_mt, new_mt);
+	res = __move_freepages_block(zone, start_pfn, old_mt, new_mt);
+	set_pageblock_migratetype(pfn_to_page(start_pfn), new_mt);
+
+	return res;
+
 }
 
 #ifdef CONFIG_MEMORY_ISOLATION
@@ -2045,11 +2052,19 @@ static unsigned long find_large_buddy(un
 	return start_pfn;
 }
 
+static inline void toggle_pageblock_isolate(struct page *page, bool isolate)
+{
+	if (isolate)
+		set_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+	else
+		clear_pfnblock_bit(page, page_to_pfn(page), PB_migrate_isolate);
+}
+
 /**
- * move_freepages_block_isolate - move free pages in block for page isolation
+ * __move_freepages_block_isolate - move free pages in block for page isolation
  * @zone: the zone
  * @page: the pageblock page
- * @migratetype: migratetype to set on the pageblock
+ * @isolate: to isolate the given pageblock or unisolate it
  *
  * This is similar to move_freepages_block(), but handles the special
  * case encountered in page isolation, where the block of interest
@@ -2064,10 +2079,18 @@ static unsigned long find_large_buddy(un
  *
  * Returns %true if pages could be moved, %false otherwise.
  */
-bool move_freepages_block_isolate(struct zone *zone, struct page *page,
-				  int migratetype)
+static bool __move_freepages_block_isolate(struct zone *zone,
+		struct page *page, bool isolate)
 {
 	unsigned long start_pfn, pfn;
+	int from_mt;
+	int to_mt;
+
+	if (isolate == get_pageblock_isolate(page)) {
+		VM_WARN_ONCE(1, "%s a pageblock that is already in that state",
+			     isolate ? "Isolate" : "Unisolate");
+		return false;
+	}
 
 	if (!prep_move_freepages_block(zone, page, &start_pfn, NULL, NULL))
 		return false;
@@ -2084,7 +2107,7 @@ bool move_freepages_block_isolate(struct
 
 		del_page_from_free_list(buddy, zone, order,
 					get_pfnblock_migratetype(buddy, pfn));
-		set_pageblock_migratetype(page, migratetype);
+		toggle_pageblock_isolate(page, isolate);
 		split_large_buddy(zone, buddy, pfn, order, FPI_NONE);
 		return true;
 	}
@@ -2095,16 +2118,38 @@ bool move_freepages_block_isolate(struct
 
 		del_page_from_free_list(page, zone, order,
 					get_pfnblock_migratetype(page, pfn));
-		set_pageblock_migratetype(page, migratetype);
+		toggle_pageblock_isolate(page, isolate);
 		split_large_buddy(zone, page, pfn, order, FPI_NONE);
 		return true;
 	}
 move:
-	__move_freepages_block(zone, start_pfn,
-			       get_pfnblock_migratetype(page, start_pfn),
-			       migratetype);
+	/* Use MIGRATETYPE_MASK to get non-isolate migratetype */
+	if (isolate) {
+		from_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
+						    MIGRATETYPE_MASK);
+		to_mt = MIGRATE_ISOLATE;
+	} else {
+		from_mt = MIGRATE_ISOLATE;
+		to_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
+						  MIGRATETYPE_MASK);
+	}
+
+	__move_freepages_block(zone, start_pfn, from_mt, to_mt);
+	toggle_pageblock_isolate(pfn_to_page(start_pfn), isolate);
+
 	return true;
 }
+
+bool pageblock_isolate_and_move_free_pages(struct zone *zone, struct page *page)
+{
+	return __move_freepages_block_isolate(zone, page, true);
+}
+
+bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *page)
+{
+	return __move_freepages_block_isolate(zone, page, false);
+}
+
 #endif /* CONFIG_MEMORY_ISOLATION */
 
 static void change_pageblock_range(struct page *pageblock_page,
@@ -2296,6 +2341,7 @@ try_to_claim_block(struct zone *zone, st
 	if (free_pages + alike_pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled) {
 		__move_freepages_block(zone, start_pfn, block_type, start_type);
+		set_pageblock_migratetype(pfn_to_page(start_pfn), start_type);
 		return __rmqueue_smallest(zone, order, start_type);
 	}
 
--- a/mm/page_isolation.c~mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate
+++ a/mm/page_isolation.c
@@ -188,7 +188,7 @@ static int set_migratetype_isolate(struc
 	unmovable = has_unmovable_pages(check_unmovable_start, check_unmovable_end,
 			migratetype, isol_flags);
 	if (!unmovable) {
-		if (!move_freepages_block_isolate(zone, page, MIGRATE_ISOLATE)) {
+		if (!pageblock_isolate_and_move_free_pages(zone, page)) {
 			spin_unlock_irqrestore(&zone->lock, flags);
 			return -EBUSY;
 		}
@@ -209,7 +209,7 @@ static int set_migratetype_isolate(struc
 	return -EBUSY;
 }
 
-static void unset_migratetype_isolate(struct page *page, int migratetype)
+static void unset_migratetype_isolate(struct page *page)
 {
 	struct zone *zone;
 	unsigned long flags;
@@ -262,10 +262,10 @@ static void unset_migratetype_isolate(st
 		 * Isolating this block already succeeded, so this
 		 * should not fail on zone boundaries.
 		 */
-		WARN_ON_ONCE(!move_freepages_block_isolate(zone, page, migratetype));
+		WARN_ON_ONCE(!pageblock_unisolate_and_move_free_pages(zone, page));
 	} else {
-		set_pageblock_migratetype(page, migratetype);
-		__putback_isolated_page(page, order, migratetype);
+		clear_pageblock_isolate(page);
+		__putback_isolated_page(page, order, get_pageblock_migratetype(page));
 	}
 	zone->nr_isolate_pageblock--;
 out:
@@ -383,7 +383,7 @@ static int isolate_single_pageblock(unsi
 		if (PageBuddy(page)) {
 			int order = buddy_order(page);
 
-			/* move_freepages_block_isolate() handled this */
+			/* pageblock_isolate_and_move_free_pages() handled this */
 			VM_WARN_ON_ONCE(pfn + (1 << order) > boundary_pfn);
 
 			pfn += 1UL << order;
@@ -433,7 +433,7 @@ static int isolate_single_pageblock(unsi
 failed:
 	/* restore the original migratetype */
 	if (!skip_isolation)
-		unset_migratetype_isolate(pfn_to_page(isolate_pageblock), migratetype);
+		unset_migratetype_isolate(pfn_to_page(isolate_pageblock));
 	return -EBUSY;
 }
 
@@ -504,7 +504,7 @@ int start_isolate_page_range(unsigned lo
 	ret = isolate_single_pageblock(isolate_end, flags, true,
 			skip_isolation, migratetype);
 	if (ret) {
-		unset_migratetype_isolate(pfn_to_page(isolate_start), migratetype);
+		unset_migratetype_isolate(pfn_to_page(isolate_start));
 		return ret;
 	}
 
@@ -517,8 +517,7 @@ int start_isolate_page_range(unsigned lo
 					start_pfn, end_pfn)) {
 			undo_isolate_page_range(isolate_start, pfn, migratetype);
 			unset_migratetype_isolate(
-				pfn_to_page(isolate_end - pageblock_nr_pages),
-				migratetype);
+				pfn_to_page(isolate_end - pageblock_nr_pages));
 			return -EBUSY;
 		}
 	}
@@ -548,7 +547,7 @@ void undo_isolate_page_range(unsigned lo
 		page = __first_valid_page(pfn, pageblock_nr_pages);
 		if (!page || !is_migrate_isolate_page(page))
 			continue;
-		unset_migratetype_isolate(page, migratetype);
+		unset_migratetype_isolate(page);
 	}
 }
 /*
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-rename-config_page_block_order-to-config_page_block_max_order.patch
mm-page_alloc-pageblock-flags-functions-clean-up.patch
mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_alloc-add-support-for-initializing-pageblock-as-isolated.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch

