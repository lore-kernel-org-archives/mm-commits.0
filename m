From: akpm@linux-foundation.org
Subject: +
 mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch added to -mm tree
Date: Tue, 04 Aug 2015 16:24:54 -0700
Message-ID: <55c149c6.LuDOdWL5w54bfxsH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbbHDXYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2015 19:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: simplify handling restart position in free pages scanner
has been added to the -mm tree.  Its filename is
     mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-simplify-handling-restart-position-in-free-pages-scanner.patch

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
Subject: mm, compaction: simplify handling restart position in free pages scanner

Handling the position where compaction free scanner should restart (stored
in cc->free_pfn) got more complex with commit e14c720efdd7 ("mm,
compaction: remember position within pageblock in free pages scanner"). 
Currently the position is updated in each loop iteration of
isolate_freepages(), although it should be enough to update it only when
breaking from the loop.  There's also an extra check outside the loop
updates the position in case we have met the migration scanner.

This can be simplified if we move the test for having isolated enough from
the for-loop header next to the test for contention, and determining the
restart position only in these cases.  We can reuse the isolate_start_pfn
variable for this instead of setting cc->free_pfn directly.  Outside the
loop, we can simply set cc->free_pfn to current value of isolate_start_pfn
without any extra check.

Also add a VM_BUG_ON to catch possible mistake in the future, in case we
later add a new condition that terminates isolate_freepages_block()
prematurely without also considering the condition in isolate_freepages().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff -puN mm/compaction.c~mm-compaction-simplify-handling-restart-position-in-free-pages-scanner mm/compaction.c
--- a/mm/compaction.c~mm-compaction-simplify-handling-restart-position-in-free-pages-scanner
+++ a/mm/compaction.c
@@ -943,8 +943,7 @@ static void isolate_freepages(struct com
 	 * pages on cc->migratepages. We stop searching if the migrate
 	 * and free page scanners meet or enough free pages are isolated.
 	 */
-	for (; block_start_pfn >= low_pfn &&
-			cc->nr_migratepages > cc->nr_freepages;
+	for (; block_start_pfn >= low_pfn;
 				block_end_pfn = block_start_pfn,
 				block_start_pfn -= pageblock_nr_pages,
 				isolate_start_pfn = block_start_pfn) {
@@ -976,6 +975,8 @@ static void isolate_freepages(struct com
 					block_end_pfn, freelist, false);
 
 		/*
+		 * If we isolated enough freepages, or aborted due to async
+		 * compaction being contended, terminate the loop.
 		 * Remember where the free scanner should restart next time,
 		 * which is where isolate_freepages_block() left off.
 		 * But if it scanned the whole pageblock, isolate_start_pfn
@@ -984,27 +985,31 @@ static void isolate_freepages(struct com
 		 * In that case we will however want to restart at the start
 		 * of the previous pageblock.
 		 */
-		cc->free_pfn = (isolate_start_pfn < block_end_pfn) ?
-				isolate_start_pfn :
-				block_start_pfn - pageblock_nr_pages;
-
-		/*
-		 * isolate_freepages_block() might have aborted due to async
-		 * compaction being contended
-		 */
-		if (cc->contended)
+		if ((cc->nr_freepages >= cc->nr_migratepages)
+							|| cc->contended) {
+			if (isolate_start_pfn >= block_end_pfn)
+				isolate_start_pfn =
+					block_start_pfn - pageblock_nr_pages;
 			break;
+		} else {
+			/*
+			 * isolate_freepages_block() should not terminate
+			 * prematurely unless contended, or isolated enough
+			 */
+			VM_BUG_ON(isolate_start_pfn < block_end_pfn);
+		}
 	}
 
 	/* split_free_page does not map the pages */
 	map_pages(freelist);
 
 	/*
-	 * If we crossed the migrate scanner, we want to keep it that way
-	 * so that compact_finished() may detect this
+	 * Record where the free scanner will restart next time. Either we
+	 * broke from the loop and set isolate_start_pfn based on the last
+	 * call to isolate_freepages_block(), or we met the migration scanner
+	 * and the loop terminated due to isolate_start_pfn < low_pfn
 	 */
-	if (block_start_pfn < low_pfn)
-		cc->free_pfn = cc->migrate_pfn;
+	cc->free_pfn = isolate_start_pfn;
 }
 
 /*
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

