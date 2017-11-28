From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-cma-fix-alloc_contig_range-ret-code-potential-leak.patch removed from
 -mm tree
Date: Tue, 28 Nov 2017 15:39:31 -0800
Message-ID: <5a1df3b3.PVTZrB/Qfh+Av9k5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52040 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdK1Xjc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2017 18:39:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, labbott@redhat.com, mgorman@techsingularity.net, mhocko@suse.com, mina86@mina86.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: fix alloc_contig_range ret code/potential leak
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-alloc_contig_range-ret-code-potential-leak.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/cma: fix alloc_contig_range ret code/potential leak

In an attempt to make contiguous allocation routines more available to
drivers, I have been experimenting with code similar to that used by
alloc_gigantic_page().  While stressing this code with many other
allocations and frees in progress, I would sometimes notice large
'leaks' of page ranges.

I traced this down to the routine alloc_contig_range() itself.  In
8ef5849fa8a2 ("mm/cma: always check which page caused allocation
failure") the code was changed so that an -EBUSY returned by
__alloc_contig_migrate_range() would not immediately return to the
caller.  Rather, processing continues so that test_pages_isolated() is
eventually called.  This is done because test_pages_isolated() has a
tracepoint to identify the busy pages.

However, it is possible (observed in my testing) that pages which were
busy when __alloc_contig_migrate_range was called may become available
by the time test_pages_isolated is called.  Further, it is possible
that the entire range can actually be allocated.  Unfortunately, in
this case the return code originally set by
__alloc_contig_migrate_range (-EBUSY) is returned to the calller. 
Therefore, the caller assumes the range was not allocated and the pages
are essentially leaked.

The following patch simply updates the return code based on the value
returned from test_pages_isolated.

It is unlikely that we will hit this issue today based on the limited
number of callers to alloc_contig_range.  However, I have Cc'ed stable
because if we do hit this issue it has the potential to leak a large
number of pages.

If the call __alloc_contig_migrate_range() in alloc_contig_range returns
-EBUSY, processing continues so that test_pages_isolated() is called where
there is a tracepoint to identify the busy pages.  However, it is possible
for busy pages to become available between the calls to these two
routines.  In this case, the range of pages may be allocated. 
Unfortunately, the original return code (ret == -EBUSY) is still set and
returned to the caller.  Therefore, the caller believes the pages were not
allocated and they are leaked.

Update the return code with the value from test_pages_isolated().

Link: http://lkml.kernel.org/r/20171120193930.23428-2-mike.kravetz@oracle.com
Fixes: 8ef5849fa8a2 ("mm/cma: always check which page caused allocation failure")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-cma-fix-alloc_contig_range-ret-code-potential-leak mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-fix-alloc_contig_range-ret-code-potential-leak
+++ a/mm/page_alloc.c
@@ -7702,10 +7702,10 @@ int alloc_contig_range(unsigned long sta
 	}
 
 	/* Make sure the range is really isolated. */
-	if (test_pages_isolated(outer_start, end, false)) {
+	ret = test_pages_isolated(outer_start, end, false);
+	if (ret) {
 		pr_info_ratelimited("%s: [%lx, %lx) PFNs busy\n",
 			__func__, outer_start, end);
-		ret = -EBUSY;
 		goto done;
 	}
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

mm-cma-fix-alloc_contig_range-ret-code-potential-leak-v2.patch

