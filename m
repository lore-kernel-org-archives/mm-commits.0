Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE6E8BF8;
	Tue,  5 Mar 2024 00:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709599269; cv=none; b=SzByXOzbF5DdnFGepTl0z1ZLz7G9vUquTxTjnUYA98cYE+azHs2qBjKAHb0OkxE4qGwIJh7heG/hFDiUaSRdzJjvcxR0QLsAKqr+BJqQZ92lI5XPuNlR/bXppmGIuZOzR/qahb5I5R2hL34DVL7Ttejca0VL5RXfyDGZodQaxX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709599269; c=relaxed/simple;
	bh=jU9XcU+LDQbCkCVg9ejrQqTk428GmokQgMssXaZdHOs=;
	h=Date:To:From:Subject:Message-Id; b=EfweTJJnuuOttJ4Iws0FReaTFyV3O27+zOUdc2TzGqne1YEx81tTpA5CitGMdNnqmWw7f+NHa4GTmhnDkfAY7XC7Z7z6vbb/5mpdcEJx9LKBY2cV0xSJvmXV2w1TDre1am48VBl9/MI4JCOzSatzQvpihMxeM2NlRBVw9hPDd20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dz/fXPmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dz/fXPmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDB4C433C7;
	Tue,  5 Mar 2024 00:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709599268;
	bh=jU9XcU+LDQbCkCVg9ejrQqTk428GmokQgMssXaZdHOs=;
	h=Date:To:From:Subject:From;
	b=Dz/fXPmfK3POq8ymrc8sLy9LQRg77IC6wFEztMJOeLQR3quW0Sd4IKavFoAt1jmLa
	 GdHbqcygnMgLmSkCbjMFOUaqc/RFMVcQ42512Phhq2Ecr5EoDSi2Abqw+A3vtJLMNx
	 6BRzMPelkdFbhuH9bH5vtlfFD8YbFUllWDsAYXWg=
Date: Mon, 04 Mar 2024 16:41:08 -0800
To: mm-commits@vger.kernel.org,tiwai@suse.com,svenva@chromium.org,stable@vger.kernel.org,perex@perex.cz,mhocko@kernel.org,mgorman@techsingularity.net,kramasub@chromium.org,cujomalainey@chromium.org,bgeffon@google.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations.patch removed from -mm tree
Message-Id: <20240305004108.BFDB4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, vmscan: prevent infinite loop for costly GFP_NOIO | __GFP_RETRY_MAYFAIL allocations
has been removed from the -mm tree.  Its filename was
     mm-vmscan-prevent-infinite-loop-for-costly-gfp_noio-__gfp_retry_mayfail-allocations.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Tested-by: Karthikeyan Ramasubramanian <kramasub@chromium.org>
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


