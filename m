From: akpm@linux-foundation.org
Subject: + mm-set-page-pfmemalloc-in-prep_new_page.patch added to -mm tree
Date: Fri, 09 Jan 2015 15:46:52 -0800
Message-ID: <54b0686c.NxVyNYaMdlBviL/d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbbAIXqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 18:46:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: set page->pfmemalloc in prep_new_page()
has been added to the -mm tree.  Its filename is
     mm-set-page-pfmemalloc-in-prep_new_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-set-page-pfmemalloc-in-prep_new_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-set-page-pfmemalloc-in-prep_new_page.patch

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
Subject: mm: set page->pfmemalloc in prep_new_page()

The possibility of replacing the numerous parameters of alloc_pages*
functions with a single structure has been discussed when Minchan proposed
to expand the x86 kernel stack [1].  This series implements the change,
along with few more cleanups/microoptimizations.

The series is based on next-20150108 and I used gcc 4.8.3 20140627 on
openSUSE 13.2 for compiling.  Config includess NUMA and COMPACTION.

The core change is the introduction of a new struct alloc_context, which looks
like this:

struct alloc_context {
        struct zonelist *zonelist;
        nodemask_t *nodemask;
        struct zone *preferred_zone;
        int classzone_idx;
        int migratetype;
        enum zone_type high_zoneidx;
};

All the contents is mostly constant, except that __alloc_pages_slowpath()
changes preferred_zone, classzone_idx and potentially zonelist.  But
that's not a problem in case control returns to retry_cpuset: in
__alloc_pages_nodemask(), those will be reset to initial values again
(although it's a bit subtle).  On the other hand, gfp_flags and alloc_info
mutate so much that it doesn't make sense to put them into alloc_context. 
Still, the result is one parameter instead of up to 7.  This is all in
Patch 2.

Patch 3 is a step to expand alloc_context usage out of page_alloc.c
itself.  The function try_to_compact_pages() can also much benefit from
the parameter reduction, but it means the struct definition has to be
moved to a shared header.

Patch 1 should IMHO be included even if the rest is deemed not useful
enough.  It improves maintainability and also has some code/stack
reduction.  Patch 4 is OTOH a tiny optimization.

Overall bloat-o-meter results:

add/remove: 0/0 grow/shrink: 0/4 up/down: 0/-460 (-460)
function                                     old     new   delta
nr_free_zone_pages                           129     115     -14
__alloc_pages_direct_compact                 329     256     -73
get_page_from_freelist                      2670    2576     -94
__alloc_pages_nodemask                      2564    2285    -279
try_to_compact_pages                         582     579      -3

Overall stack sizes per ./scripts/checkstack.pl:

                          old   new delta
get_page_from_freelist:   184   184     0
__alloc_pages_nodemask    248   200   -48
__alloc_pages_direct_c     40     -   -40  
try_to_compact_pages       72    72     0
                                      -88

[1] http://marc.info/?l=linux-mm&m=140142462528257&w=2



This patch (of 4):

prep_new_page() sets almost everything in the struct page of the page
being allocated, except page->pfmemalloc.  This is not obvious and has at
least once led to a bug where page->pfmemalloc was forgotten to be set
correctly, see commit 8fb74b9fb2b1 ("mm: compaction: partially revert
capture of suitable high-order page").

This patch moves the pfmemalloc setting to prep_new_page(), which means it
needs to gain alloc_flags parameter.  The call to prep_new_page is moved
from buffered_rmqueue() to get_page_from_freelist(), which also leads to
simpler code.  An obsolete comment for buffered_rmqueue() is replaced.

In addition to better maintainability there is a small reduction of code
and stack usage for get_page_from_freelist(), which inlines the other
functions involved.

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-145 (-145)
function                                     old     new   delta
get_page_from_freelist                      2670    2525    -145

Stack usage is reduced from 184 to 168 bytes.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff -puN mm/page_alloc.c~mm-set-page-pfmemalloc-in-prep_new_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-set-page-pfmemalloc-in-prep_new_page
+++ a/mm/page_alloc.c
@@ -937,7 +937,8 @@ static inline int check_new_page(struct
 	return 0;
 }
 
-static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags)
+static int prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
+								int alloc_flags)
 {
 	int i;
 
@@ -961,6 +962,14 @@ static int prep_new_page(struct page *pa
 
 	set_page_owner(page, order, gfp_flags);
 
+	/*
+	 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was necessary to
+	 * allocate the page. The expectation is that the caller is taking
+	 * steps that will free more memory. The caller should avoid the page
+	 * being used for !PFMEMALLOC purposes.
+	 */
+	page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
+
 	return 0;
 }
 
@@ -1609,9 +1618,7 @@ int split_free_page(struct page *page)
 }
 
 /*
- * Really, prep_compound_page() should be called from __rmqueue_bulk().  But
- * we cheat by calling it from here, in the order > 0 path.  Saves a branch
- * or two.
+ * Allocate a page from the given zone. Use pcplists for order-0 allocations.
  */
 static inline
 struct page *buffered_rmqueue(struct zone *preferred_zone,
@@ -1622,7 +1629,6 @@ struct page *buffered_rmqueue(struct zon
 	struct page *page;
 	bool cold = ((gfp_flags & __GFP_COLD) != 0);
 
-again:
 	if (likely(order == 0)) {
 		struct per_cpu_pages *pcp;
 		struct list_head *list;
@@ -1678,8 +1684,6 @@ again:
 	local_irq_restore(flags);
 
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
-	if (prep_new_page(page, order, gfp_flags))
-		goto again;
 	return page;
 
 failed:
@@ -2144,25 +2148,16 @@ zonelist_scan:
 try_this_zone:
 		page = buffered_rmqueue(preferred_zone, zone, order,
 						gfp_mask, migratetype);
-		if (page)
-			break;
+		if (page) {
+			if (prep_new_page(page, order, gfp_mask, alloc_flags))
+				goto try_this_zone;
+			return page;
+		}
 this_zone_full:
 		if (IS_ENABLED(CONFIG_NUMA) && zlc_active)
 			zlc_mark_zone_full(zonelist, z);
 	}
 
-	if (page) {
-		/*
-		 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
-		 * necessary to allocate the page. The expectation is
-		 * that the caller is taking steps that will free more
-		 * memory. The caller should avoid the page being used
-		 * for !PFMEMALLOC purposes.
-		 */
-		page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
-		return page;
-	}
