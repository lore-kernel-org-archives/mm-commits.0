From: akpm@linux-foundation.org
Subject: [patch 040/119] mm: split deferred_init_range into
 initializing and freeing parts
Date: Wed, 31 Jan 2018 16:16:30 -0800
Message-ID: <20180201001630.p1z-aRZOV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34306 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbeBAAQc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:16:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, pasha.tatashin@oracle.com, steven.sistare@oracle.com, torvalds@linux-foundation.org

From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm: split deferred_init_range into initializing and freeing parts

In deferred_init_range() we initialize struct pages, and also free them to
buddy allocator.  We do it in separate loops, because buddy page is
computed ahead, so we do not want to access a struct page that has not
been initialized yet.

There is still, however, a corner case where it is potentially possible to
access uninitialized struct page: this is when buddy page is from the next
memblock range.

This patch fixes this problem by splitting deferred_init_range() into two
functions: one to initialize struct pages, and another to free them.

In addition, this patch brings the following improvements:
- Get rid of __def_free() helper function. And simplifies loop logic by
  adding a new pfn validity check function: deferred_pfn_valid().
- Reduces number of variables that we track. So, there is a higher chance
  that we will avoid using stack to store/load variables inside hot loops.
- Enables future multi-threading of these functions: do initialization in
  multiple threads, wait for all threads to finish, do freeing part in
  multithreading.

Tested on x86 with 1T of memory to make sure no regressions are introduced.

[akpm@linux-foundation.org: fix spello in comment]
Link: http://lkml.kernel.org/r/20171107150446.32055-2-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  146 +++++++++++++++++++++++-----------------------
 1 file changed, 76 insertions(+), 70 deletions(-)

diff -puN mm/page_alloc.c~mm-split-deferred_init_range-into-initializing-and-freeing-parts mm/page_alloc.c
--- a/mm/page_alloc.c~mm-split-deferred_init_range-into-initializing-and-freeing-parts
+++ a/mm/page_alloc.c
@@ -1457,92 +1457,87 @@ static inline void __init pgdat_init_rep
 }
 
 /*
- * Helper for deferred_init_range, free the given range, reset the counters, and
- * return number of pages freed.
+ * Returns true if page needs to be initialized or freed to buddy allocator.
+ *
+ * First we check if pfn is valid on architectures where it is possible to have
+ * holes within pageblock_nr_pages. On systems where it is not possible, this
+ * function is optimized out.
+ *
+ * Then, we check if a current large page is valid by only checking the validity
+ * of the head pfn.
+ *
+ * Finally, meminit_pfn_in_nid is checked on systems where pfns can interleave
+ * within a node: a pfn is between start and end of a node, but does not belong
+ * to this memory node.
  */
-static inline unsigned long __init __def_free(unsigned long *nr_free,
-					      unsigned long *free_base_pfn,
-					      struct page **page)
+static inline bool __init
+deferred_pfn_valid(int nid, unsigned long pfn,
+		   struct mminit_pfnnid_cache *nid_init_state)
 {
-	unsigned long nr = *nr_free;
+	if (!pfn_valid_within(pfn))
+		return false;
+	if (!(pfn & (pageblock_nr_pages - 1)) && !pfn_valid(pfn))
+		return false;
+	if (!meminit_pfn_in_nid(pfn, nid, nid_init_state))
+		return false;
+	return true;
+}
 
-	deferred_free_range(*free_base_pfn, nr);
-	*free_base_pfn = 0;
-	*nr_free = 0;
-	*page = NULL;
+/*
+ * Free pages to buddy allocator. Try to free aligned pages in
+ * pageblock_nr_pages sizes.
+ */
+static void __init deferred_free_pages(int nid, int zid, unsigned long pfn,
+				       unsigned long end_pfn)
+{
+	struct mminit_pfnnid_cache nid_init_state = { };
+	unsigned long nr_pgmask = pageblock_nr_pages - 1;
+	unsigned long nr_free = 0;
 
-	return nr;
+	for (; pfn < end_pfn; pfn++) {
+		if (!deferred_pfn_valid(nid, pfn, &nid_init_state)) {
+			deferred_free_range(pfn - nr_free, nr_free);
+			nr_free = 0;
+		} else if (!(pfn & nr_pgmask)) {
+			deferred_free_range(pfn - nr_free, nr_free);
+			nr_free = 1;
+			cond_resched();
+		} else {
+			nr_free++;
+		}
+	}
+	/* Free the last block of pages to allocator */
+	deferred_free_range(pfn - nr_free, nr_free);
 }
 
-static unsigned long __init deferred_init_range(int nid, int zid,
-						unsigned long start_pfn,
-						unsigned long end_pfn)
+/*
+ * Initialize struct pages.  We minimize pfn page lookups and scheduler checks
+ * by performing it only once every pageblock_nr_pages.
+ * Return number of pages initialized.
+ */
+static unsigned long  __init deferred_init_pages(int nid, int zid,
+						 unsigned long pfn,
+						 unsigned long end_pfn)
 {
 	struct mminit_pfnnid_cache nid_init_state = { };
 	unsigned long nr_pgmask = pageblock_nr_pages - 1;
-	unsigned long free_base_pfn = 0;
 	unsigned long nr_pages = 0;
-	unsigned long nr_free = 0;
 	struct page *page = NULL;
-	unsigned long pfn;
 
-	/*
-	 * First we check if pfn is valid on architectures where it is possible
-	 * to have holes within pageblock_nr_pages. On systems where it is not
-	 * possible, this function is optimized out.
-	 *
-	 * Then, we check if a current large page is valid by only checking the
-	 * validity of the head pfn.
-	 *
-	 * meminit_pfn_in_nid is checked on systems where pfns can interleave
-	 * within a node: a pfn is between start and end of a node, but does not
-	 * belong to this memory node.
-	 *
-	 * Finally, we minimize pfn page lookups and scheduler checks by
-	 * performing it only once every pageblock_nr_pages.
-	 *
-	 * We do it in two loops: first we initialize struct page, than free to
-	 * buddy allocator, becuse while we are freeing pages we can access
-	 * pages that are ahead (computing buddy page in __free_one_page()).
-	 */
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-		if (!pfn_valid_within(pfn))
+	for (; pfn < end_pfn; pfn++) {
+		if (!deferred_pfn_valid(nid, pfn, &nid_init_state)) {
+			page = NULL;
 			continue;
-		if ((pfn & nr_pgmask) || pfn_valid(pfn)) {
-			if (meminit_pfn_in_nid(pfn, nid, &nid_init_state)) {
-				if (page && (pfn & nr_pgmask))
-					page++;
-				else
-					page = pfn_to_page(pfn);
-				__init_single_page(page, pfn, zid, nid);
-				cond_resched();
-			}
-		}
-	}
-
-	page = NULL;
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-		if (!pfn_valid_within(pfn)) {
-			nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
-		} else if (!(pfn & nr_pgmask) && !pfn_valid(pfn)) {
-			nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
-		} else if (!meminit_pfn_in_nid(pfn, nid, &nid_init_state)) {
-			nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
-		} else if (page && (pfn & nr_pgmask)) {
-			page++;
-			nr_free++;
-		} else {
-			nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
+		} else if (!page || !(pfn & nr_pgmask)) {
 			page = pfn_to_page(pfn);
-			free_base_pfn = pfn;
-			nr_free = 1;
 			cond_resched();
+		} else {
+			page++;
 		}
+		__init_single_page(page, pfn, zid, nid);
+		nr_pages++;
 	}
-	/* Free the last block of pages to allocator */
-	nr_pages += __def_free(&nr_free, &free_base_pfn, &page);
-
-	return nr_pages;
+	return (nr_pages);
 }
 
 /* Initialise remaining memory on a node */
@@ -1582,10 +1577,21 @@ static int __init deferred_init_memmap(v
 	}
 	first_init_pfn = max(zone->zone_start_pfn, first_init_pfn);
 
+	/*
+	 * Initialize and free pages. We do it in two loops: first we initialize
+	 * struct page, than free to buddy allocator, because while we are
+	 * freeing pages we can access pages that are ahead (computing buddy
+	 * page in __free_one_page()).
+	 */
+	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
+		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
+		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
+		nr_pages += deferred_init_pages(nid, zid, spfn, epfn);
+	}
 	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &spa, &epa, NULL) {
 		spfn = max_t(unsigned long, first_init_pfn, PFN_UP(spa));
 		epfn = min_t(unsigned long, zone_end_pfn(zone), PFN_DOWN(epa));
-		nr_pages += deferred_init_range(nid, zid, spfn, epfn);
+		deferred_free_pages(nid, zid, spfn, epfn);
 	}
 
 	/* Sanity check that the next zone really is unpopulated */
_
