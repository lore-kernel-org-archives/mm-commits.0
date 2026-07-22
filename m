Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6602135C183
	for <mm-commits@vger.kernel.org>; Wed, 22 Jul 2026 23:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784762551; cv=none; b=DIPLznhYJTmduUjae4UnXhUo4l903zO2JT75Y8qrHI7vr3OKOL15OYlnrCWVEy92BOeV5HWTialkfhf3X074wcp9w1dSgaOd1AmqL/J3AD0dRmMGpfknAis3mt3u3UWDd0pz6pwbnN73Ber2s1lCopGFM8RiG04tOvDPGZhf3Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784762551; c=relaxed/simple;
	bh=IIsDPG2vSsib9AEp2kFlvgEug6BRmerLfvPyjR3xvwg=;
	h=Date:To:From:Subject:Message-Id; b=dJjbKE18h/k9J47j4G9XpKeZ32+VOgaqu+MZKZI4aTGthpW8zDgzlig24/X8J5HpZAsGjRiupQFnBNY9OYe/u0ZRTPF+X9SnSqmXfQl2+hmrofifEPLPzihy0Betjf8+PNeIGrcuFx8AR8aVljWXKhUN9HV/zth2VkSegeaexIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TrMb8nlp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TrMb8nlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0101F000E9;
	Wed, 22 Jul 2026 23:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784762550;
	bh=uEae3kflhmBlz5VX0jPjEUwhhI+LcxdhFpiiqRgwbj4=;
	h=Date:To:From:Subject;
	b=TrMb8nlpCvGdECx3uKistng6ZDmvUX1IDssq6sIZowcDHDYpK6oLnPqYQt6pyIV9O
	 eJO/+oON09NmA1XqXWGu9tpuvSSO8CD8Vx2e2bPj5hL/6GjyzhhP8ybn6iy1jmQqMd
	 1622lyZHl3uC392zp3mw0DDcXTLDFQ2PokQkzki0=
Date: Wed, 22 Jul 2026 16:22:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,brendan.jackman@linux.dev,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-move-capture_control-to-the-page-allocator.patch added to mm-new branch
Message-Id: <20260722232229.EB0101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: move capture_control to the page allocator
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-move-capture_control-to-the-page-allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-move-capture_control-to-the-page-allocator.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: mm: page_alloc: move capture_control to the page allocator
Date: Wed, 22 Jul 2026 10:56:46 -0400

The compaction capturing code assumes the allocation request order and
compaction target order are the same.  That won't be true once defrag_mode
promotes sub-block allocations to pageblock-order compaction: compaction
targets the larger order, while capture should remain at the original
allocation order.

Move the capture_control to the page allocator and give it its own copies
of what the page freeing path matches against - zone, migratetype and the
allocation order - rather than reaching into compaction's live
compact_control.  __alloc_pages_direct_compact() fills in migratetype and
order, and installs and hides current->capture_control around the whole
compaction call; try_to_compact_pages() aims capc->zone at each zone while
it is being compacted.  compact_zone_order() no longer deals with capture
at all.

Pass the capture_control through try_to_compact_pages() /
compact_zone_order() in place of the bare struct page **.

No functional change.

Link: https://lore.kernel.org/20260722150006.3848560-4-hannes@cmpxchg.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    3 +-
 mm/compaction.c            |   50 +++++++++--------------------------
 mm/internal.h              |    4 ++
 mm/page_alloc.c            |   45 ++++++++++++++++++++++++++-----
 4 files changed, 57 insertions(+), 45 deletions(-)

--- a/include/linux/compaction.h~mm-page_alloc-move-capture_control-to-the-page-allocator
+++ a/include/linux/compaction.h
@@ -58,6 +58,7 @@ enum compact_result {
 };
 
 struct alloc_context; /* in mm/internal.h */
+struct capture_control; /* in mm/internal.h */
 
 /*
  * Number of free order-0 pages that should be available above given watermark
@@ -92,7 +93,7 @@ extern int fragmentation_index(struct zo
 extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
 		unsigned int order, unsigned int alloc_flags,
 		const struct alloc_context *ac, enum compact_priority prio,
-		struct page **page);
+		struct capture_control *capc);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern bool compaction_suitable(struct zone *zone, int order,
 				unsigned long watermark, int highest_zoneidx);
--- a/mm/compaction.c~mm-page_alloc-move-capture_control-to-the-page-allocator
+++ a/mm/compaction.c
@@ -2800,9 +2800,8 @@ out:
 static enum compact_result compact_zone_order(struct zone *zone, int order,
 		gfp_t gfp_mask, enum compact_priority prio,
 		unsigned int alloc_flags, int highest_zoneidx,
-		struct page **capture)
+		struct capture_control *capc)
 {
-	enum compact_result ret;
 	struct compact_control cc = {
 		.order = order,
 		.search_order = order,
@@ -2817,38 +2816,8 @@ static enum compact_result compact_zone_
 		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY),
 		.ignore_block_suitable = (prio == MIN_COMPACT_PRIORITY)
 	};
-	struct capture_control capc = {
-		.cc = &cc,
-		.page = NULL,
-	};
-
-	/*
-	 * Make sure the structs are really initialized before we expose the
-	 * capture control, in case we are interrupted and the interrupt handler
-	 * frees a page.
-	 */
-	barrier();
-	WRITE_ONCE(current->capture_control, &capc);
-
-	ret = compact_zone(&cc, &capc);
-
-	/*
-	 * Make sure we hide capture control first before we read the captured
-	 * page pointer, otherwise an interrupt could free and capture a page
-	 * and we would leak it.
-	 */
-	WRITE_ONCE(current->capture_control, NULL);
-	*capture = READ_ONCE(capc.page);
-	/*
-	 * Technically, it is also possible that compaction is skipped but
-	 * the page is still captured out of luck(IRQ came and freed the page).
-	 * Returning COMPACT_SUCCESS in such cases helps in properly accounting
-	 * the COMPACT[STALL|FAIL] when compaction is skipped.
-	 */
-	if (*capture)
-		ret = COMPACT_SUCCESS;
 
-	return ret;
+	return compact_zone(&cc, capc);
 }
 
 /**
@@ -2858,13 +2827,13 @@ static enum compact_result compact_zone_
  * @alloc_flags: The allocation flags of the current allocation
  * @ac: The context of current allocation
  * @prio: Determines how hard direct compaction should try to succeed
- * @capture: Pointer to free page created by compaction will be stored here
+ * @capc: Free page capture bypassing the freelist
  *
  * This is the main entry point for direct page compaction.
  */
 enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum compact_priority prio, struct page **capture)
+		enum compact_priority prio, struct capture_control *capc)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -2891,8 +2860,17 @@ enum compact_result try_to_compact_pages
 			continue;
 		}
 
+		WRITE_ONCE(capc->zone, zone);
+
 		status = compact_zone_order(zone, order, gfp_mask, prio,
-				alloc_flags, ac->highest_zoneidx, capture);
+				alloc_flags, ac->highest_zoneidx, capc);
+
+		WRITE_ONCE(capc->zone, NULL);
+
+		/* Stop if a page has been captured */
+		if (READ_ONCE(capc->page))
+			status = COMPACT_SUCCESS;
+
 		rc = max(status, rc);
 
 		/* The allocation should succeed, stop compacting */
--- a/mm/internal.h~mm-page_alloc-move-capture_control-to-the-page-allocator
+++ a/mm/internal.h
@@ -872,7 +872,9 @@ struct compact_control {
  * immediately when one is created during the free path.
  */
 struct capture_control {
-	struct compact_control *cc;
+	struct zone *zone;
+	int migratetype;
+	int order;
 	struct page *page;
 };
 
--- a/mm/page_alloc.c~mm-page_alloc-move-capture_control-to-the-page-allocator
+++ a/mm/page_alloc.c
@@ -725,14 +725,14 @@ static inline struct capture_control *ta
 	return unlikely(capc) &&
 		!(current->flags & PF_KTHREAD) &&
 		!capc->page &&
-		capc->cc->zone == zone ? capc : NULL;
+		capc->zone == zone ? capc : NULL;
 }
 
 static inline bool
 compaction_capture(struct capture_control *capc, struct page *page,
 		   int order, int migratetype)
 {
-	if (!capc || order != capc->cc->order)
+	if (!capc || order != capc->order)
 		return false;
 
 	/* Do not accidentally pollute CMA or isolated regions*/
@@ -748,12 +748,12 @@ compaction_capture(struct capture_contro
 	 * have trouble finding a high-order free page.
 	 */
 	if (order < pageblock_order && migratetype == MIGRATE_MOVABLE &&
-	    capc->cc->migratetype != MIGRATE_MOVABLE)
+	    capc->migratetype != MIGRATE_MOVABLE)
 		return false;
 
-	if (migratetype != capc->cc->migratetype)
-		trace_mm_page_alloc_extfrag(page, capc->cc->order, order,
-					    capc->cc->migratetype, migratetype);
+	if (migratetype != capc->migratetype)
+		trace_mm_page_alloc_extfrag(page, capc->order, order,
+					    capc->migratetype, migratetype);
 
 	capc->page = page;
 	return true;
@@ -4201,6 +4201,12 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	struct page *page = NULL;
 	unsigned long pflags;
 	unsigned int noreclaim_flag;
+	struct capture_control capc = {
+		.zone = NULL,
+		.migratetype = ac->migratetype,
+		.order = order,
+		.page = NULL,
+	};
 
 	if (!order)
 		return NULL;
@@ -4210,8 +4216,33 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
+	/*
+	 * Make sure the structs are really initialized before we expose the
+	 * capture control, in case we are interrupted and the interrupt handler
+	 * frees a page.
+	 */
+	barrier();
+	WRITE_ONCE(current->capture_control, &capc);
+
 	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
-								prio, &page);
+							       prio, &capc);
+
+	/*
+	 * Make sure we hide capture control first before we read the captured
+	 * page pointer, otherwise an interrupt could free and capture a page
+	 * and we would leak it.
+	 */
+	WRITE_ONCE(current->capture_control, NULL);
+	page = READ_ONCE(capc.page);
+
+	/*
+	 * Technically, it is also possible that compaction is skipped but
+	 * the page is still captured out of luck(IRQ came and freed the page).
+	 * Returning COMPACT_SUCCESS in such cases helps in properly accounting
+	 * the COMPACT[STALL|FAIL] when compaction is skipped.
+	 */
+	if (page)
+		*compact_result = COMPACT_SUCCESS;
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(gfp_mask);
_

Patches currently in -mm which might be from vbabka@kernel.org are

mm-remove-the-__gfp_no_obj_ext-flag.patch
mm-page_alloc-move-capture_control-to-the-page-allocator.patch

