From: akpm@linux-foundation.org
Subject: +
 mm-compaction-encapsulate-resetting-cached-scanner-positions.patch added to -mm tree
Date: Tue, 04 Aug 2015 16:24:56 -0700
Message-ID: <55c149c8.QF9Nq7+rUkPSW2Xs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbbHDXY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 19:24:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: encapsulate resetting cached scanner positions
has been added to the -mm tree.  Its filename is
     mm-compaction-encapsulate-resetting-cached-scanner-positions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-encapsulate-resetting-cached-scanner-positions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-encapsulate-resetting-cached-scanner-positions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: encapsulate resetting cached scanner positions

Reseting the cached compaction scanner positions is now open-coded in
__reset_isolation_suitable() and compact_finished().  Encapsulate the
functionality in a new function reset_cached_positions().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN mm/compaction.c~mm-compaction-encapsulate-resetting-cached-scanner-positions mm/compaction.c
--- a/mm/compaction.c~mm-compaction-encapsulate-resetting-cached-scanner-positions
+++ a/mm/compaction.c
@@ -207,6 +207,13 @@ static inline bool isolation_suitable(st
 	return !get_pageblock_skip(page);
 }
 
+static void reset_cached_positions(struct zone *zone)
+{
+	zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
+	zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
+	zone->compact_cached_free_pfn = zone_end_pfn(zone);
+}
+
 /*
  * This function is called to clear all cached information on pageblocks that
  * should be skipped for page isolation when the migrate and free page scanner
@@ -218,9 +225,6 @@ static void __reset_isolation_suitable(s
 	unsigned long end_pfn = zone_end_pfn(zone);
 	unsigned long pfn;
 
-	zone->compact_cached_migrate_pfn[0] = start_pfn;
-	zone->compact_cached_migrate_pfn[1] = start_pfn;
-	zone->compact_cached_free_pfn = end_pfn;
 	zone->compact_blockskip_flush = false;
 
 	/* Walk the zone and mark every pageblock as suitable for isolation */
@@ -238,6 +242,8 @@ static void __reset_isolation_suitable(s
 
 		clear_pageblock_skip(page);
 	}
+
+	reset_cached_positions(zone);
 }
 
 void reset_isolation_suitable(pg_data_t *pgdat)
@@ -1160,9 +1166,7 @@ static int __compact_finished(struct zon
 	/* Compaction run completes if the migrate and free scanner meet */
 	if (compact_scanners_met(cc)) {
 		/* Let the next compaction start anew. */
-		zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
-		zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
-		zone->compact_cached_free_pfn = zone_end_pfn(zone);
+		reset_cached_positions(zone);
 
 		/*
 		 * Mark that the PG_migrate_skip information should be cleared
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-dont-wait-for-high-order-page-allocation.patch
mm-mlock-refactor-mlock-munlock-and-munlockall-code.patch
mm-mlock-add-new-mlock-system-call.patch
mm-introduce-vm_lockonfault.patch
mm-mlock-add-mlock-flags-to-enable-vm_lockonfault-usage.patch
selftests-vm-add-tests-for-lock-on-fault.patch
mips-add-entry-for-new-mlock2-syscall.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages.patch
mm-page_isolation-remove-bogus-tests-for-isolated-pages-fix.patch
mm-rename-and-move-get-set_freepage_migratetype.patch
mm-rename-and-move-get-set_freepage_migratetype-v2.patch
mm-page_isolation-make-set-unset_migratetype_isolate-file-local.patch
mm-vmscan-never-isolate-more-pages-than-necessary.patch
mm-compaction-more-robust-check-for-scanners-meeting.patch
mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch
mm-compaction-encapsulate-resetting-cached-scanner-positions.patch
mm-compaction-skip-compound-pages-by-order-in-free-scanner.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages-fix-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
linux-next.patch

