From: akpm@linux-foundation.org
Subject: + mm-broken-deferred-calculation.patch added to -mm tree
Date: Thu, 02 Nov 2017 14:48:23 -0700
Message-ID: <59fb92a7.RQSD3UPaM2udh0ib%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40574 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbdKBVsY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 17:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, mgorman@techsingularity.net, mhocko@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: broken deferred calculation
has been added to the -mm tree.  Its filename is
     mm-broken-deferred-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-broken-deferred-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-broken-deferred-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm/page_alloc.c: broken deferred calculation

In reset_deferred_meminit() we determine number of pages that must not be
deferred.  We initialize pages for at least 2G of memory, but also pages
for reserved memory in this node.

The reserved memory is determined in this function:
memblock_reserved_memory_within(), which operates over physical addresses,
and returns size in bytes.  However, reset_deferred_meminit() assumes that
that this function operates with pfns, and returns page count.

The result is that in the best case machine boots slower than expected due
to initializing more pages than needed in single thread, and in the worst
case panics because fewer than needed pages are initialized early.

Link: http://lkml.kernel.org/r/20171021011707.15191-1-pasha.tatashin@oracle.com
Fixes: 864b9a393dcb ("mm: consider memblock reservations for deferred memory initialization sizing")
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 ++-
 mm/page_alloc.c        |   27 ++++++++++++++++++---------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-broken-deferred-calculation include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-broken-deferred-calculation
+++ a/include/linux/mmzone.h
@@ -700,7 +700,8 @@ typedef struct pglist_data {
 	 * is the first PFN that needs to be initialised.
 	 */
 	unsigned long first_deferred_pfn;
-	unsigned long static_init_size;
+	/* Number of non-deferred pages */
+	unsigned long static_init_pgcnt;
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff -puN mm/page_alloc.c~mm-broken-deferred-calculation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-broken-deferred-calculation
+++ a/mm/page_alloc.c
@@ -291,28 +291,37 @@ EXPORT_SYMBOL(nr_online_nodes);
 int page_group_by_mobility_disabled __read_mostly;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
+
+/*
+ * Determine how many pages need to be initialized durig early boot
+ * (non-deferred initialization).
+ * The value of first_deferred_pfn will be set later, once non-deferred pages
+ * are initialized, but for now set it ULONG_MAX.
+ */
 static inline void reset_deferred_meminit(pg_data_t *pgdat)
 {
-	unsigned long max_initialise;
-	unsigned long reserved_lowmem;
+	phys_addr_t start_addr, end_addr;
+	unsigned long max_pgcnt;
+	unsigned long reserved;
 
 	/*
 	 * Initialise at least 2G of a node but also take into account that
 	 * two large system hashes that can take up 1GB for 0.25TB/node.
 	 */
-	max_initialise = max(2UL << (30 - PAGE_SHIFT),
-		(pgdat->node_spanned_pages >> 8));
+	max_pgcnt = max(2UL << (30 - PAGE_SHIFT),
+			(pgdat->node_spanned_pages >> 8));
 
 	/*
 	 * Compensate the all the memblock reservations (e.g. crash kernel)
 	 * from the initial estimation to make sure we will initialize enough
 	 * memory to boot.
 	 */
-	reserved_lowmem = memblock_reserved_memory_within(pgdat->node_start_pfn,
-			pgdat->node_start_pfn + max_initialise);
-	max_initialise += reserved_lowmem;
+	start_addr = PFN_PHYS(pgdat->node_start_pfn);
+	end_addr = PFN_PHYS(pgdat->node_start_pfn + max_pgcnt);
+	reserved = memblock_reserved_memory_within(start_addr, end_addr);
+	max_pgcnt += PHYS_PFN(reserved);
 
-	pgdat->static_init_size = min(max_initialise, pgdat->node_spanned_pages);
+	pgdat->static_init_pgcnt = min(max_pgcnt, pgdat->node_spanned_pages);
 	pgdat->first_deferred_pfn = ULONG_MAX;
 }
 
@@ -339,7 +348,7 @@ static inline bool update_defer_init(pg_
 	if (zone_end < pgdat_end_pfn(pgdat))
 		return true;
 	(*nr_initialised)++;
-	if ((*nr_initialised > pgdat->static_init_size) &&
+	if ((*nr_initialised > pgdat->static_init_pgcnt) &&
 	    (pfn & (PAGES_PER_SECTION - 1)) == 0) {
 		pgdat->first_deferred_pfn = pfn;
 		return false;
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-deferred_init_memmap-improvements.patch
mm-deferred_init_memmap-improvements-fix-3.patch
x86-mm-setting-fields-in-deferred-pages.patch
sparc64-mm-setting-fields-in-deferred-pages.patch
sparc64-simplify-vmemmap_populate.patch
mm-defining-memblock_virt_alloc_try_nid_raw.patch
mm-zero-reserved-and-unavailable-struct-pages.patch
x86-kasan-add-and-use-kasan_map_populate.patch
arm64-kasan-add-and-use-kasan_map_populate.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap.patch
sparc64-optimized-struct-page-zeroing.patch
mm-broken-deferred-calculation.patch
sparc64-ng4-memset-32-bits-overflow.patch

