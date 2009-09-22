From: akpm@linux-foundation.org
Subject: [merged] page-allocator-limit-the-number-of-migrate_reserve-pageblocks-per-zone.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:54 -0700
Message-ID: <200909222041.n8MKfsWJ008535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970AbZIVUmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     page-allocator: limit the number of MIGRATE_RESERVE pageblocks per zone
has been removed from the -mm tree.  Its filename was
     page-allocator-limit-the-number-of-migrate_reserve-pageblocks-per-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: limit the number of MIGRATE_RESERVE pageblocks per zone
From: Mel Gorman <mel@csn.ul.ie>

After anti-fragmentation was merged, a bug was reported whereby devices
that depended on high-order atomic allocations were failing.  The solution
was to preserve a property in the buddy allocator which tended to keep the
minimum number of free pages in the zone at the lower physical addresses
and contiguous.  To preserve this property, MIGRATE_RESERVE was introduced
and a number of pageblocks at the start of a zone would be marked
"reserve", the number of which depended on min_free_kbytes.

Anti-fragmentation works by avoiding the mixing of page migratetypes
within the same pageblock.  One way of helping this is to increase
min_free_kbytes because it becomes less like that it will be necessary to
place pages of of MIGRATE_RESERVE is unbounded, the free memory is kept
there in large contiguous blocks instead of helping anti-fragmentation as
much as it should.  With the page-allocator tracepoint patches applied, it
was found during anti-fragmentation tests that the number of
fragmentation-related events were far higher than expected even with
min_free_kbytes at higher values.

This patch limits the number of MIGRATE_RESERVE blocks that exist per zone
to two.  For example, with a sufficient min_free_kbytes, 4MB of memory
will be kept aside on an x86-64 and remain more or less free and
contiguous for the systems uptime.  This should be sufficient for devices
depending on high-order atomic allocations while helping fragmentation
control when min_free_kbytes is tuned appropriately.  As side-effect of
this patch is that the reserve variable is converted to int as unsigned
long was the wrong type to use when ensuring that only the required number
of reserve blocks are created.

With the patches applied, fragmentation-related events as measured by the
page allocator tracepoints were significantly reduced when running some
fragmentation stress-tests on systems with min_free_kbytes tuned to a
value appropriate for hugepage allocations at runtime.  On x86, the events
recorded were reduced by 99.8%, on x86-64 by 99.72% and on ppc64 by
99.83%.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page-allocator-limit-the-number-of-migrate_reserve-pageblocks-per-zone mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-limit-the-number-of-migrate_reserve-pageblocks-per-zone
+++ a/mm/page_alloc.c
@@ -2836,7 +2836,8 @@ static void setup_zone_migrate_reserve(s
 {
 	unsigned long start_pfn, pfn, end_pfn;
 	struct page *page;
-	unsigned long reserve, block_migratetype;
+	unsigned long block_migratetype;
+	int reserve;
 
 	/* Get the start pfn, end pfn and the number of blocks to reserve */
 	start_pfn = zone->zone_start_pfn;
@@ -2844,6 +2845,15 @@ static void setup_zone_migrate_reserve(s
 	reserve = roundup(min_wmark_pages(zone), pageblock_nr_pages) >>
 							pageblock_order;
 
+	/*
+	 * Reserve blocks are generally in place to help high-order atomic
+	 * allocations that are short-lived. A min_free_kbytes value that
+	 * would result in more than 2 reserve blocks for atomic allocations
+	 * is assumed to be in place to help anti-fragmentation for the
+	 * future allocation of hugepages at runtime.
+	 */
+	reserve = min(2, reserve);
+
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
 		if (!pfn_valid(pfn))
 			continue;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
add-debugging-aid-for-memory-initialisation-problems.patch

