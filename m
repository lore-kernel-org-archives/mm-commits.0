From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmthpcompactioncma-allow-thp-migration-for-cma-allocations-fix.patch
 removed from -mm tree
Date: Wed, 01 Apr 2020 20:35:21 -0700
Message-ID: <20200402033521.YauveDvkN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732498AbgDBDfY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, js1304@gmail.com, mgorman@techsingularity.net, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, riel@surriel.com, rientjes@google.com, vbabka@suse.cz, ziy@nvidia.com


The patch titled
     Subject: mmthpcompactioncma-allow-thp-migration-for-cma-allocations-fix
has been removed from the -mm tree.  Its filename was
     mmthpcompactioncma-allow-thp-migration-for-cma-allocations-fix.patch

This patch was dropped because it was folded into mmthpcompactioncma-allow-thp-migration-for-cma-allocations.patch

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
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
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mmthpcompactioncma-allow-thp-migration-for-cma-allocations-fix
+++ a/mm/page_alloc.c
@@ -8292,12 +8292,12 @@ struct page *has_unmovable_pages(struct
 			struct page *head = compound_head(page);
 			unsigned int skip_pages;
 
-			if (PageHuge(page) &&
-			    !hugepage_migration_supported(page_hstate(head)))
-				return page;
