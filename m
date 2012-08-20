From: akpm@linux-foundation.org
Subject: + mm-correct-page-pfmemalloc-to-fix-deactivate_slab-regression.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:10:35 -0700
Message-ID: <20120820211036.184E15C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55613 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2HTVKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:10:38 -0400
Received: by bkcjc3 with SMTP id jc3so313814bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:10:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex.shi@intel.com, a.p.zijlstra@chello.nl, davem@davemloft.net, mgorman@suse.de


The patch titled
     Subject: mm: correct page->pfmemalloc to fix deactivate_slab regression
has been added to the -mm tree.  Its filename is
     mm-correct-page-pfmemalloc-to-fix-deactivate_slab-regression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@intel.com>
Subject: mm: correct page->pfmemalloc to fix deactivate_slab regression

cfd19c5a9ec ("mm: only set page->pfmemalloc when ALLOC_NO_WATERMARKS was
used") tried to narrow down page->pfmemalloc setting, but it missed some
places the pfmemalloc should be set.

So, in __slab_alloc, the unalignment pfmemalloc and ALLOC_NO_WATERMARKS
cause incorrect deactivate_slab() on our core2 server:

    64.73%           fio  [kernel.kallsyms]     [k] _raw_spin_lock
                     |
                     --- _raw_spin_lock
                        |
                        |---0.34%-- deactivate_slab
                        |          __slab_alloc
                        |          kmem_cache_alloc
                        |          |

That causes our fio sync write performance to have a 40% regression.

Move the checking in get_page_from_freelist() which resolves this issue.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-correct-page-pfmemalloc-to-fix-deactivate_slab-regression mm/page_alloc.c
--- a/mm/page_alloc.c~mm-correct-page-pfmemalloc-to-fix-deactivate_slab-regression
+++ a/mm/page_alloc.c
@@ -1928,6 +1928,17 @@ this_zone_full:
 		zlc_active = 0;
 		goto zonelist_scan;
 	}
+
+	if (page)
+		/*
+		 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
+		 * necessary to allocate the page. The expectation is
+		 * that the caller is taking steps that will free more
+		 * memory. The caller should avoid the page being used
+		 * for !PFMEMALLOC purposes.
+		 */
+		page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
+
 	return page;
 }
 
@@ -2389,14 +2400,6 @@ rebalance:
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
 		if (page) {
-			/*
-			 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
-			 * necessary to allocate the page. The expectation is
-			 * that the caller is taking steps that will free more
-			 * memory. The caller should avoid the page being used
-			 * for !PFMEMALLOC purposes.
-			 */
-			page->pfmemalloc = true;
 			goto got_pg;
 		}
 	}
@@ -2569,8 +2572,6 @@ retry_cpuset:
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
-	else
-		page->pfmemalloc = false;
 
 	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
 
_

Patches currently in -mm which might be from alex.shi@intel.com are

linux-next.patch
mm-correct-page-pfmemalloc-to-fix-deactivate_slab-regression.patch

