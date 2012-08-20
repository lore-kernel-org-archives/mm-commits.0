From: akpm@linux-foundation.org
Subject: + mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:19:16 -0700
Message-ID: <20120820211917.C0CBC20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:63801 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2HTVTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:19:20 -0400
Received: by wibhr14 with SMTP id hr14so219524wib.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:19:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: mm: vmscan: scale number of pages reclaimed by reclaim/compaction based on failures
has been added to the -mm tree.  Its filename is
     mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: scale number of pages reclaimed by reclaim/compaction based on failures

If allocation fails after compaction then compaction may be deferred for a
number of allocation attempts.  If there are subsequent failures,
compact_defer_shift is increased to defer for longer periods.  This patch
uses that information to scale the number of pages reclaimed with
compact_defer_shift until allocations succeed again.  The rationale is
that reclaiming the normal number of pages still allowed compaction to
fail and its success depends on the number of pages.  If it's failing,
reclaim more pages until it succeeds again.

Note that this is not implying that VM reclaim is not reclaiming enough
pages or that its logic is broken.  try_to_free_pages() always asks for
SWAP_CLUSTER_MAX pages to be reclaimed regardless of order and that is
what it does.  Direct reclaim stops normally with this check.

	if (sc->nr_reclaimed >= sc->nr_to_reclaim)
		goto out;

should_continue_reclaim delays when that check is made until a minimum
number of pages for reclaim/compaction are reclaimed.  It is possible that
this patch could instead set nr_to_reclaim in try_to_free_pages() and
drive it from there but that's behaves differently and not necessarily for
the better.  If driven from do_try_to_free_pages(), it is also possible
that priorities will rise.  When they reach DEF_PRIORITY-2, it will also
start stalling and setting pages for immediate reclaim which is more
disruptive than not desirable in this case.  That is a more wide-reaching
change that could cause another regression related to THP requests causing
interactive jitter.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/vmscan.c~mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures
+++ a/mm/vmscan.c
@@ -1743,6 +1743,7 @@ static inline bool should_continue_recla
 {
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
+	struct zone *zone;
 
 	/* If not in reclaim/compaction mode, stop */
 	if (!in_reclaim_compaction(sc))
@@ -1776,6 +1777,15 @@ static inline bool should_continue_recla
 	 * inactive lists are large enough, continue reclaiming
 	 */
 	pages_for_compaction = (2UL << sc->order);
+
+	/*
+	 * If compaction is deferred for sc->order then scale the number of
+	 * pages reclaimed based on the number of consecutive allocation
+	 * failures
+	 */
+	zone = lruvec_zone(lruvec);
+	if (zone->compact_order_failed <= sc->order)
+		pages_for_compaction <<= zone->compact_defer_shift;
 	inactive_lru_pages = get_lru_size(lruvec, LRU_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
 		inactive_lru_pages += get_lru_size(lruvec, LRU_INACTIVE_ANON);
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts.patch
netvm-check-for-page-==-null-when-propagating-the-skb-pfmemalloc-flag.patch
mm-correct-page-pfmemalloc-to-fix-deactivate_slab-regression.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages.patch
mm-compaction-abort-async-compaction-if-locks-are-contended-or-taking-too-long.patch

