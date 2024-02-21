Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9274C85958;
	Wed, 21 Feb 2024 20:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708547279; cv=none; b=iLxyr5ea8z6XWALNlRAYvidPdlUHsLVhu5aVRjoeTW18WO/FBRCq6sK8/UGTsT22KyOioGjnvfUu204iPRKYpwDsU+oMF7dDfttuRfh3jjDWc46sncMIXFlSgtcsfJZpaMeS8c+qnKrIa1lcqYi9fxLMEs7aQ5PpKvvS8jPEwQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708547279; c=relaxed/simple;
	bh=bCp1vKo+oZ7/SLYFwatkFSMs7y4ORrvBQy6AiqJRmVI=;
	h=Date:To:From:Subject:Message-Id; b=V13kR25YfdrcW8MDtKyxesxdJtujzD/iQkHhiVbAqL0kZ2dFrbUjcTMULZhspzwj2eqeykzpe2amZNqKDgGqFizVgBpeDfOLoTbCgatw0qHF1KOEewMIZXnvSTsvBOZXa6KVeq2YiHB0O2tqNhp5wfqEw2EPrGDT5vexy2mWwjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e5MuZbi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e5MuZbi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB89C433F1;
	Wed, 21 Feb 2024 20:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708547276;
	bh=bCp1vKo+oZ7/SLYFwatkFSMs7y4ORrvBQy6AiqJRmVI=;
	h=Date:To:From:Subject:From;
	b=e5MuZbi6Op5zrJPpS3fUuOrm5Yl/C4muHXnG81AhzLB1CpFJirWxmHAQgTiW+XTCP
	 ZlNdDh3mpFR+dRkw8dTgowyxB0YEDl2uXGq43Qe06tkmtWz1gya3rYogAb4VEn96bV
	 B06s4rH7MBSOyXTFy3TDd6z2xk2E0OlNgaTEH+74=
Date: Wed, 21 Feb 2024 12:27:55 -0800
To: mm-commits@vger.kernel.org,tiwai@suse.com,svenva@chromium.org,stable@vger.kernel.org,perex@perex.cz,mhocko@kernel.org,mgorman@techsingularity.net,cujomalainey@chromium.org,bgeffon@google.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations.patch added to mm-hotfixes-unstable branch
Message-Id: <20240221202756.5AB89C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, vmscan: prevent infinite loop for costly GFP_NOIO | __GFP_RETRY_MAYFAIL allocations
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, vmscan: prevent infinite loop for costly GFP_NOIO | __GFP_RETRY_MAYFAIL allocations
Date: Wed, 21 Feb 2024 12:43:58 +0100

Sven reports an infinite loop in __alloc_pages_slowpath() for costly order
__GFP_RETRY_MAYFAIL allocations that are also GFP_NOIO.  Such combination
can happen in a suspend/resume context where a GFP_KERNEL allocation can
have __GFP_IO masked out via gfp_allowed_mask.

Quoting Sven:

1. try to do a "costly" allocation (order > PAGE_ALLOC_COSTLY_ORDER)
   with __GFP_RETRY_MAYFAIL set.

2. page alloc's __alloc_pages_slowpath tries to get a page from the
   freelist. This fails because there is nothing free of that costly
   order.

3. page alloc tries to reclaim by calling __alloc_pages_direct_reclaim,
   which bails out because a zone is ready to be compacted; it pretends
   to have made a single page of progress.

4. page alloc tries to compact, but this always bails out early because
   __GFP_IO is not set (it's not passed by the snd allocator, and even
   if it were, we are suspending so the __GFP_IO flag would be cleared
   anyway).

5. page alloc believes reclaim progress was made (because of the
   pretense in item 3) and so it checks whether it should retry
   compaction. The compaction retry logic thinks it should try again,
   because:
    a) reclaim is needed because of the early bail-out in item 4
    b) a zonelist is suitable for compaction

6. goto 2. indefinite stall.

(end quote)

The immediate root cause is confusing the COMPACT_SKIPPED returned from
__alloc_pages_direct_compact() (step 4) due to lack of __GFP_IO to be
indicating a lack of order-0 pages, and in step 5 evaluating that in
should_compact_retry() as a reason to retry, before incrementing and
limiting the number of retries.  There are however other places that
wrongly assume that compaction can happen while we lack __GFP_IO.

To fix this, introduce gfp_compaction_allowed() to abstract the __GFP_IO
evaluation and switch the open-coded test in try_to_compact_pages() to use
it.

Also use the new helper in:
- compaction_ready(), which will make reclaim not bail out in step 3, so
  there's at least one attempt to actually reclaim, even if chances are
  small for a costly order
- in_reclaim_compaction() which will make should_continue_reclaim()
  return false and we don't over-reclaim unnecessarily
- in __alloc_pages_slowpath() to set a local variable can_compact,
  which is then used to avoid retrying reclaim/compaction for costly
  allocations (step 5) if we can't compact and also to skip the early
  compaction attempt that we do in some cases

Link: https://lkml.kernel.org/r/20240221114357.13655-2-vbabka@suse.cz
Fixes: 3250845d0526 ("Revert "mm, oom: prevent premature OOM killer invocation for high order request"")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Sven van Ashbrook <svenva@chromium.org>
Closes: https://lore.kernel.org/all/CAG-rBihs_xMKb3wrMO1%2B-%2Bp4fowP9oy1pa_OTkfxBzPUVOZF%2Bg@mail.gmail.com/
Cc: Brian Geffon <bgeffon@google.com>
Cc: Curtis Malainey <cujomalainey@chromium.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    9 +++++++++
 mm/compaction.c     |    7 +------
 mm/page_alloc.c     |   10 ++++++----
 mm/vmscan.c         |    5 ++++-
 4 files changed, 20 insertions(+), 11 deletions(-)

--- a/include/linux/gfp.h~mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations
+++ a/include/linux/gfp.h
@@ -353,6 +353,15 @@ static inline bool gfp_has_io_fs(gfp_t g
 	return (gfp & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS);
 }
 
+/*
+ * Check if the gfp flags allow compaction - GFP_NOIO is a really
+ * tricky context because the migration might require IO.
+ */
+static inline bool gfp_compaction_allowed(gfp_t gfp_mask)
+{
+	return IS_ENABLED(CONFIG_COMPACTION) && (gfp_mask & __GFP_IO);
+}
+
 extern gfp_t vma_thp_gfp_mask(struct vm_area_struct *vma);
 
 #ifdef CONFIG_CONTIG_ALLOC
--- a/mm/compaction.c~mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations
+++ a/mm/compaction.c
@@ -2723,16 +2723,11 @@ enum compact_result try_to_compact_pages
 		unsigned int alloc_flags, const struct alloc_context *ac,
 		enum compact_priority prio, struct page **capture)
 {
-	int may_perform_io = (__force int)(gfp_mask & __GFP_IO);
 	struct zoneref *z;
 	struct zone *zone;
 	enum compact_result rc = COMPACT_SKIPPED;
 
-	/*
-	 * Check if the GFP flags allow compaction - GFP_NOIO is really
-	 * tricky context because the migration might require IO
-	 */
-	if (!may_perform_io)
+	if (!gfp_compaction_allowed(gfp_mask))
 		return COMPACT_SKIPPED;
 
 	trace_mm_compaction_try_to_compact_pages(order, gfp_mask, prio);
--- a/mm/page_alloc.c~mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations
+++ a/mm/page_alloc.c
@@ -4041,6 +4041,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 						struct alloc_context *ac)
 {
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	bool can_compact = gfp_compaction_allowed(gfp_mask);
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
@@ -4111,7 +4112,7 @@ restart:
 	 * Don't try this for allocations that are allowed to ignore
 	 * watermarks, as the ALLOC_NO_WATERMARKS attempt didn't yet happen.
 	 */
-	if (can_direct_reclaim &&
+	if (can_direct_reclaim && can_compact &&
 			(costly_order ||
 			   (order > 0 && ac->migratetype != MIGRATE_MOVABLE))
 			&& !gfp_pfmemalloc_allowed(gfp_mask)) {
@@ -4209,9 +4210,10 @@ retry:
 
 	/*
 	 * Do not retry costly high order allocations unless they are
-	 * __GFP_RETRY_MAYFAIL
+	 * __GFP_RETRY_MAYFAIL and we can compact
 	 */
-	if (costly_order && !(gfp_mask & __GFP_RETRY_MAYFAIL))
+	if (costly_order && (!can_compact ||
+			     !(gfp_mask & __GFP_RETRY_MAYFAIL)))
 		goto nopage;
 
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
@@ -4224,7 +4226,7 @@ retry:
 	 * implementation of the compaction depends on the sufficient amount
 	 * of free memory (see __compaction_suitable)
 	 */
-	if (did_some_progress > 0 &&
+	if (did_some_progress > 0 && can_compact &&
 			should_compact_retry(ac, order, alloc_flags,
 				compact_result, &compact_priority,
 				&compaction_retries))
--- a/mm/vmscan.c~mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations
+++ a/mm/vmscan.c
@@ -5753,7 +5753,7 @@ static void shrink_lruvec(struct lruvec
 /* Use reclaim/compaction for costly allocs or under memory pressure */
 static bool in_reclaim_compaction(struct scan_control *sc)
 {
-	if (IS_ENABLED(CONFIG_COMPACTION) && sc->order &&
+	if (gfp_compaction_allowed(sc->gfp_mask) && sc->order &&
 			(sc->order > PAGE_ALLOC_COSTLY_ORDER ||
 			 sc->priority < DEF_PRIORITY - 2))
 		return true;
@@ -5998,6 +5998,9 @@ static inline bool compaction_ready(stru
 {
 	unsigned long watermark;
 
+	if (!gfp_compaction_allowed(sc->gfp_mask))
+		return false;
+
 	/* Allocation can already succeed, nothing to do */
 	if (zone_watermark_ok(zone, sc->order, min_wmark_pages(zone),
 			      sc->reclaim_idx, 0))
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations.patch
mm-document-memalloc_noreclaim_save-and-memalloc_pin_save.patch
mm-document-memalloc_noreclaim_save-and-memalloc_pin_save-v2.patch

