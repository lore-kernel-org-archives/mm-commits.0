From: akpm@linux-foundation.org
Subject: [patch 03/28] mm/cma: fix alloc_contig_range ret code/potential
 leak
Date: Wed, 29 Nov 2017 16:10:01 -0800
Message-ID: <5a1f4c59.mJMQdCnOz/ZPvpRp%akpm__23910.4411135942$1512000619$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60446 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753513AbdK3AKE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:10:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mike.kravetz@oracle.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, labbott@redhat.com, mgorman@techsingularity.net, mhocko@suse.com, mina86@mina86.com, stable@vger.kernel.org, vbabka@suse.cz

From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/cma: fix alloc_contig_range ret code/potential leak

If the call __alloc_contig_migrate_range() in alloc_contig_range returns
-EBUSY, processing continues so that test_pages_isolated() is called where
there is a tracepoint to identify the busy pages.  However, it is possible
for busy pages to become available between the calls to these two
routines.  In this case, the range of pages may be allocated. 
Unfortunately, the original return code (ret == -EBUSY) is still set and
returned to the caller.  Therefore, the caller believes the pages were not
allocated and they are leaked.

Update comment to indicate that allocation is still possible even if
__alloc_contig_migrate_range returns -EBUSY.  Also, clear return code in
this case so that it is not accidentally used or returned to caller.

Link: http://lkml.kernel.org/r/20171122185214.25285-1-mike.kravetz@oracle.com
Fixes: 8ef5849fa8a2 ("mm/cma: always check which page caused allocation failure")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-cma-fix-alloc_contig_range-ret-code-potential-leak-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-fix-alloc_contig_range-ret-code-potential-leak-v2
+++ a/mm/page_alloc.c
@@ -7652,11 +7652,18 @@ int alloc_contig_range(unsigned long sta
 
 	/*
 	 * In case of -EBUSY, we'd like to know which page causes problem.
-	 * So, just fall through. We will check it in test_pages_isolated().
+	 * So, just fall through. test_pages_isolated() has a tracepoint
+	 * which will report the busy page.
+	 *
+	 * It is possible that busy pages could become available before
+	 * the call to test_pages_isolated, and the range will actually be
+	 * allocated.  So, if we fall through be sure to clear ret so that
+	 * -EBUSY is not accidentally used or returned to caller.
 	 */
 	ret = __alloc_contig_migrate_range(&cc, start, end);
 	if (ret && ret != -EBUSY)
 		goto done;
+	ret =0;
 
 	/*
 	 * Pages from [start, end) are within a MAX_ORDER_NR_PAGES
_
