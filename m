From: akpm@linux-foundation.org
Subject: +
 mmthpcompactioncma-allow-thp-migration-for-cma-allocations-fix.patch added
 to -mm tree
Date: Sat, 29 Feb 2020 20:22:57 -0800
Message-ID: <20200301042257.VyNwfqIqa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgCAEW6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 23:22:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, riel@surriel.com, rientjes@google.com, vbabka@suse.cz, ziy@nvidia.com


The patch titled
     Subject: mmthpcompactioncma-allow-thp-migration-for-cma-allocations-fix
has been added to the -mm tree.  Its filename is
     mmthpcompactioncma-allow-thp-migration-for-cma-allocations-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmthpcompactioncma-allow-thp-migration-for-cma-allocations-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmthpcompactioncma-allow-thp-migration-for-cma-allocations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------

Author: Rik van Riel <riel@surriel.com>
Subject: mmthpcompactioncma-allow-thp-migration-for-cma-allocations-fix

Mike Kravetz pointed out that the second if condition could do the
wrong thing for hugetlbfs pages, and that check really only needs
to run on THPs.

Cleanup suggested by Vlastimil.

Thank you both!

Link: http://lkml.kernel.org/r/20200228104700.0af2f18d@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Suggested-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mmthpcompactioncma-allow-thp-migration-for-cma-allocations-fix
+++ a/mm/page_alloc.c
@@ -8263,12 +8263,12 @@ struct page *has_unmovable_pages(struct
 			struct page *head = compound_head(page);
 			unsigned int skip_pages;
 
-			if (PageHuge(page) &&
-			    !hugepage_migration_supported(page_hstate(head)))
-				return page;
