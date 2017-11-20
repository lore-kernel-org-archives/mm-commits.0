From: akpm@linux-foundation.org
Subject: + mm-cma-fix-alloc_contig_range-ret-code-potential-leak.patch
 added to -mm tree
Date: Mon, 20 Nov 2017 13:57:59 -0800
Message-ID: <5a134fe7.WYoCvSL8NnZ4FjdX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43006 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753131AbdKTV6B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:58:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, labbott@redhat.com, mgorman@techsingularity.net, mhocko@suse.com, mina86@mina86.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: fix alloc_contig_range ret code/potential leak
has been added to the -mm tree.  Its filename is
     mm-cma-fix-alloc_contig_range-ret-code-potential-leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-fix-alloc_contig_range-ret-code-potential-leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-fix-alloc_contig_range-ret-code-potential-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Update the return code with the value from test_pages_isolated().

Link: http://lkml.kernel.org/r/20171120193930.23428-2-mike.kravetz@oracle.com
Fixes: 8ef5849fa8a2 ("mm/cma: always check which page caused allocation failure")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Nazarewicz <mina86@mina86.com>
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
@@ -7706,10 +7706,10 @@ int alloc_contig_range(unsigned long sta
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

mm-cma-fix-alloc_contig_range-ret-code-potential-leak.patch

