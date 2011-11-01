From: akpm@linux-foundation.org
Subject: [merged] vmscan-limit-direct-reclaim-for-higher-order-allocations.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:12:01 -0700
Message-ID: <201111012112.pA1LC6Ml011350@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29366 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, aarcange@redhat.com, jweiner@redhat.com, mgorman@suse.de, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: limit direct reclaim for higher order allocations
has been removed from the -mm tree.  Its filename was
     vmscan-limit-direct-reclaim-for-higher-order-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: vmscan: limit direct reclaim for higher order allocations

When suffering from memory fragmentation due to unfreeable pages, THP page
faults will repeatedly try to compact memory.  Due to the unfreeable
pages, compaction fails.

Needless to say, at that point page reclaim also fails to create free
contiguous 2MB areas.  However, that doesn't stop the current code from
trying, over and over again, and freeing a minimum of 4MB (2UL <<
sc->order pages) at every single invocation.

This resulted in my 12GB system having 2-3GB free memory, a corresponding
amount of used swap and very sluggish response times.

This can be avoided by having the direct reclaim code not reclaim from
zones that already have plenty of free memory available for compaction.

If compaction still fails due to unmovable memory, doing additional
reclaim will only hurt the system, not help.

[jweiner@redhat.com: change comment to explain the order check]
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN mm/vmscan.c~vmscan-limit-direct-reclaim-for-higher-order-allocations mm/vmscan.c
--- a/mm/vmscan.c~vmscan-limit-direct-reclaim-for-higher-order-allocations
+++ a/mm/vmscan.c
@@ -2125,6 +2125,22 @@ static void shrink_zones(int priority, s
 				continue;
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
+			if (COMPACTION_BUILD) {
+				/*
+				 * If we already have plenty of memory
+				 * free for compaction, don't free any
+				 * more.  Even though compaction is
+				 * invoked for any non-zero order,
+				 * only frequent costly order
+				 * reclamation is disruptive enough to
+				 * become a noticable problem, like
+				 * transparent huge page allocations.
+				 */
+				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
+					(compaction_suitable(zone, sc->order) ||
+					 compaction_deferred(zone)))
+					continue;
+			}
 			/*
 			 * This steals pages from memory cgroups over softlimit
 			 * and returns the number of reclaimed pages and
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-add-extra-free-kbytes-tunable.patch
mm-add-extra-free-kbytes-tunable-update.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch

