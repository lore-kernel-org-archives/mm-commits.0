From: akpm@linux-foundation.org
Subject: + mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch added to -mm tree
Date: Fri, 16 Dec 2011 15:29:43 -0800
Message-ID: <20111216232944.5C06B10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:57650 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab1LPX3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 18:29:45 -0500
Received: by qcsg15 with SMTP id g15so494620qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 15:29:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, mgorman@suse.de, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com


The patch titled
     Subject: mm: vmscan: check if we isolated a compound page during lumpy scan
has been added to the -mm tree.  Its filename is
     mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: vmscan: check if we isolated a compound page during lumpy scan

Properly take into account if we isolated a compound page during the lumpy
scan in reclaim and skip over the tail pages when encountered.  This
corrects the values given to the tracepoint for number of lumpy pages
isolated and will avoid breaking the loop early if compound pages smaller
than the requested allocation size are requested.

[mgorman@suse.de: Updated changelog]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan
+++ a/mm/vmscan.c
@@ -1171,13 +1171,16 @@ static unsigned long isolate_lru_pages(u
 				break;
 
 			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
+				unsigned int isolated_pages;
 				list_move(&cursor_page->lru, dst);
 				mem_cgroup_del_lru(cursor_page);
-				nr_taken += hpage_nr_pages(page);
-				nr_lumpy_taken++;
+				isolated_pages = hpage_nr_pages(page);
+				nr_taken += isolated_pages;
+				nr_lumpy_taken += isolated_pages;
 				if (PageDirty(cursor_page))
-					nr_lumpy_dirty++;
+					nr_lumpy_dirty += isolated_pages;
 				scan++;
+				pfn += isolated_pages-1;
 			} else {
 				/*
 				 * Check if the page is freed already.
_
Subject: Subject: mm: vmscan: check if we isolated a compound page during lumpy scan

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
memcg-keep-root-group-unchanged-if-creation-fails.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-more-intensive-memory-corruption-debug.patch
mm-more-intensive-memory-corruption-debug-fix.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-compaction-allow-compaction-to-isolate-dirty-pages.patch
mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory.patch
mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch
mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction.patch
mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch
mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch
mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch

