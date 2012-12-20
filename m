From: akpm@linux-foundation.org
Subject: + mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:19:42 -0800
Message-ID: <20121220201943.14CA2200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:39652 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2LTUTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:19:45 -0500
Received: by mail-la0-f73.google.com with SMTP id d3so194414lah.2
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:19:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de


The patch titled
     Subject: mm: compaction: do not accidentally skip pageblocks in the migrate scanner
has been added to the -mm tree.  Its filename is
     mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch

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
Subject: mm: compaction: do not accidentally skip pageblocks in the migrate scanner

Compaction uses the ALIGN macro incorrectly with the migrate scanner by
adding pageblock_nr_pages to a PFN.  It happened to work when initially
implemented as the starting PFN was also aligned but with caching restarts
and isolating in smaller chunks this is no longer always true.

The impact is that the migrate scanner scans outside its current
pageblock.  As pfn_valid() is still checked properly it does not cause any
failure and the impact of the bug is that in some cases it will scan more
than necessary when it crosses a page boundary but by no more than
COMPACT_CLUSTER_MAX.  It is highly unlikely this is even measurable but
it's still wrong so this patch addresses the problem.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner mm/compaction.c
--- a/mm/compaction.c~mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner
+++ a/mm/compaction.c
@@ -597,8 +597,7 @@ check_compact_cluster:
 		continue;
 
 next_pageblock:
-		low_pfn += pageblock_nr_pages;
-		low_pfn = ALIGN(low_pfn, pageblock_nr_pages) - 1;
+		low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
 		last_pageblock_nr = pageblock_nr;
 	}
 
@@ -781,7 +780,7 @@ static isolate_migrate_t isolate_migrate
 	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
 
 	/* Only scan within a pageblock boundary */
-	end_pfn = ALIGN(low_pfn + pageblock_nr_pages, pageblock_nr_pages);
+	end_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages);
 
 	/* Do not cross the free scanner or scan within a memory hole */
 	if (end_pfn > cc->free_pfn || !pfn_valid(low_pfn)) {
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
mm-cond_resched-in-tlb_flush_mmu-to-fix-soft-lockups-on-config_preempt.patch
mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch
mm-memmap_init_zone-performance-improvement.patch

