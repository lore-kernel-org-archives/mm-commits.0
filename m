Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F2A443C29
	for <mm-commits@vger.kernel.org>; Tue, 29 Sep 2026 19:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790711928; cv=none; b=N3URJN5h3hCpSwXcaoL9IgA7UH7JkMg2MpSzRTcSJMoGQ716HOkn2JSbGR87lsdLP0xh3D5pVkKtQujyrgUMBu1OskrEVZNGu7ESJIE5UFayBEJeh2JuqNZZxDSvBp3TNFxa6QVt2ilN9j7FgPFhbrXtzEiCBxlNlbkNd1KJaxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790711928; c=relaxed/simple;
	bh=TTaflg99ObC3x+A0xgtRgUqYOrYONrJpqzxYlUdsvvI=;
	h=Date:To:From:Subject:Message-Id; b=s54Zro/HxyGP+X52ZFvcIBa657knv+GhEGJjm5NoPYvVrjFBAAfue9w8Xw7ynp8/5M5+T9B8wyejfL548YR3AmSRjd3cQVKsTfxPqpUk+e3Z7RgcsbVRDSXCwCJycjFX2Z34spn2xnqbDoajCOoEl3WAW7+JTq7SUsv3dGwwrXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OZ4pAMAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OZ4pAMAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C783A1F000FF;
	Tue, 29 Sep 2026 19:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790711926;
	bh=Qv9e8KT3pG2eBgcevYQpPPedOvuxaIMy7W/Cv+/5npg=;
	h=Date:To:From:Subject;
	b=OZ4pAMAy2eS9dGBpBgmYg0bhgxDTE8dpd/yT57ykDYkoN4MLjpjHVnph9pFnoLKxU
	 +iQLslYABU2BZV7QCRYGUVD23PHNYQpEd79mbQOvO2JGQOiGRSzEzHj2J1AUSKFCpx
	 rBdOVd+N2dHorB2s7yCk50EFXlKiK4v+30gE0lrQ=
Date: Tue, 29 Sep 2026 12:58:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,harry@kernel.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch added to mm-hotfixes-unstable branch
Message-Id: <20260929195846.C783A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: page_alloc: make defrag_mode retries follow the promoted order
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm: page_alloc: make defrag_mode retries follow the promoted order
Date: Tue, 29 Sep 2026 18:45:51 +0100

Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm
in defrag_mode"), direct reclaim and compaction for non-movable requests
under defrag_mode run at pageblock_order, to produce the whole blocks that
ALLOC_NOFRAGMENT needs.  The retry decisions that follow still use the
request order.  An order-0 request can therefore retry indefinitely
without ever reaching the ALLOC_NOFRAGMENT fallback:

- Reclaim at pageblock_order gives up after one pass as soon as a zone
  looks compaction_ready(), and do_try_to_free_pages() then returns 1
  even though nothing was reclaimed. It returns before the retry that
  would reclaim memory.low-protected cgroups, so when most memory is
  protected, the pass that did run finds next to nothing.

- Compaction at pageblock_order fails or is deferred.

- should_reclaim_retry() takes the reported progress as progress for
  the order-0 request and resets no_progress_loops. The request
  retries.

Order 1-3 requests loop the same way, and should_compact_retry() also
checks their pageblock_order compaction result against the request order.

On a production host (64G, defrag_mode, memory.low covering most of the
workload), 95% of direct reclaim runs were order-9 runs that returned 1
with nothing reclaimed, at up to 60k runs per second.  Across ~200M
should_reclaim_retry() calls in a day, no_progress_loops never left 0. 
The spinning allocations were SLUB slab refills for inode and dentry
caches.  The time spent registers as memory pressure, and pressure-based
OOM killing takes down both workloads and system services.

Treat promoted requests like costly orders:

- Reclaim progress does not reset no_progress_loops for them.

- should_compact_retry() checks the compaction result at the promoted
  order. It does not retry COMPACT_SKIPPED, since the request can fall
  back, and it does not escalate compaction to COMPACT_PRIO_SYNC_FULL.

When the fallback is taken, reset the retry counters, so that the fallback
attempt gets a full retry budget before the OOM killer is considered.

In a VM reproducer (32G, defrag_mode, inode churn under memory.low):

                                        before    after
    should_reclaim_retry() calls           63M     293k
    peak memory pressure (PSI some avg10)  99%      12%

File creation runs 5.7x faster.

Link: https://lore.kernel.org/20260929174553.175333-1-kirill@shutemov.name
Fixes: 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim storm in defrag_mode")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Harry Yoo <harry@kernel.org>
---

 mm/page_alloc.c |   85 ++++++++++++++++++++++++++++++----------------
 1 file changed, 56 insertions(+), 29 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order
+++ a/mm/page_alloc.c
@@ -4128,6 +4128,31 @@ out:
 }
 
 /*
+ * If fallbacks are not permitted (defrag_mode), we either need to
+ * reclaim space in a block of matching type, or clear out an entire
+ * block to allow __rmqueue_claim() to convert.
+ *
+ * Reclaim by itself is primarily freeing space in movable blocks,
+ * since that's where the LRU pages live. So this works for movable
+ * requests, but not for others.
+ *
+ * For those, promote the order of reclaim and compaction to help make
+ * blocks, instead of spinning in reclaim alone unproductively. Retry
+ * decisions based on the outcome of that work - reclaim progress and
+ * compaction results - must account for the promotion as well, see
+ * should_reclaim_retry() and should_compact_retry().
+ */
+static inline unsigned int nofrag_promote_order(unsigned int order,
+						unsigned int alloc_flags,
+						const struct alloc_context *ac)
+{
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		return max(order, pageblock_order);
+
+	return order;
+}
+
+/*
  * Maximum number of compaction retries with a progress before OOM
  * killer is consider as the only way to move forward.
  */
@@ -4149,22 +4174,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		.order = order,
 		.page = NULL,
 	};
-	int compact_order = order;
-
-	/*
-	 * If fallbacks are not permitted (defrag_mode), we either
-	 * need to reclaim space in a block of matching type, or clear
-	 * out an entire block to allow __rmqueue_claim() to convert.
-	 *
-	 * Reclaim by itself is primarily freeing space in movable
-	 * blocks, since that's where the LRU pages live. So this
-	 * works for movable requests, but not for others.
-	 *
-	 * For those, promote the order to help make blocks, instead
-	 * of spinning in reclaim alone unproductively.
-	 */
-	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
-		compact_order = max(order, pageblock_order);
+	unsigned int compact_order = nofrag_promote_order(order, alloc_flags, ac);
 
 	if (!compact_order)
 		return NULL;
@@ -4256,8 +4266,11 @@ should_compact_retry(gfp_t gfp_mask, str
 	bool ret = false;
 	int retries = *compaction_retries;
 	enum compact_priority priority = *compact_priority;
+	unsigned int compact_order;
 
-	if (!order)
+	/* Check the compaction result at the order compaction ran at */
+	compact_order = nofrag_promote_order(order, alloc_flags, ac);
+	if (!compact_order)
 		return false;
 
 	if (fatal_signal_pending(current))
@@ -4266,10 +4279,14 @@ should_compact_retry(gfp_t gfp_mask, str
 	/*
 	 * Compaction was skipped due to a lack of free order-0
 	 * migration targets. Continue if reclaim can help.
+	 *
+	 * Promoted requests have exhausted their reclaim retries at
+	 * this point, and they can fall back instead.
 	 */
 	if (compact_result == COMPACT_SKIPPED) {
-		ret = compaction_zonelist_suitable(ac, order, alloc_flags,
-						   gfp_mask);
+		if (compact_order == order)
+			ret = compaction_zonelist_suitable(ac, order, alloc_flags,
+							   gfp_mask);
 		goto out;
 	}
 
@@ -4287,7 +4304,7 @@ should_compact_retry(gfp_t gfp_mask, str
 		 * need much more detailed feedback from compaction to
 		 * make a better decision.
 		 */
-		if (order > PAGE_ALLOC_COSTLY_ORDER)
+		if (compact_order > PAGE_ALLOC_COSTLY_ORDER)
 			max_retries /= 4;
 
 		if (++(*compaction_retries) <= max_retries) {
@@ -4299,7 +4316,7 @@ should_compact_retry(gfp_t gfp_mask, str
 	/*
 	 * Compaction failed. Retry with increasing priority.
 	 */
-	min_priority = (order > PAGE_ALLOC_COSTLY_ORDER) ?
+	min_priority = (compact_order > PAGE_ALLOC_COSTLY_ORDER) ?
 			MIN_COMPACT_COSTLY_PRIORITY : MIN_COMPACT_PRIORITY;
 
 	if (*compact_priority > min_priority) {
@@ -4468,11 +4485,7 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 	struct page *page = NULL;
 	unsigned long pflags;
 	bool drained = false;
-	int reclaim_order = order;
-
-	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
-	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
-		reclaim_order = max(order, pageblock_order);
+	unsigned int reclaim_order = nofrag_promote_order(order, alloc_flags, ac);
 
 	psi_memstall_enter(&pflags);
 	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
@@ -4648,9 +4661,17 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 	/*
 	 * Costly allocations might have made a progress but this doesn't mean
 	 * their order will become available due to high fragmentation so
-	 * always increment the no progress counter for them
+	 * always increment the no progress counter for them.
+	 *
+	 * The same goes for requests whose reclaim is promoted to make whole
+	 * blocks. At that order, reclaim also reports progress when it backs
+	 * off for compaction without freeing anything.
+	 *
+	 * The watermark check below stays at the request order: it asks
+	 * whether the request itself could succeed after reclaim.
 	 */
-	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
+	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER &&
+	    nofrag_promote_order(order, alloc_flags, ac) == order)
 		*no_progress_loops = 0;
 	else
 		(*no_progress_loops)++;
@@ -5024,9 +5045,15 @@ retry:
 				 &compaction_retries))
 		goto retry;
 
-	/* Reclaim/compaction failed to prevent the fallback */
+	/*
+	 * Reclaim/compaction failed to prevent the fallback. The retry
+	 * budget was spent on making blocks, not on the request itself;
+	 * give the fallback a fresh one before considering OOM.
+	 */
 	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
 		alloc_flags &= ~ALLOC_NOFRAGMENT;
+		no_progress_loops = 0;
+		compaction_retries = 0;
 		goto retry;
 	}
 
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
mm-huge_memory-add-folio_reset_partially_mapped.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch
selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

