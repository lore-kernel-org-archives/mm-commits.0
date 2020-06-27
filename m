From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged]
 =?US-ASCII?Q?mm-swap-fix-for-mm-workingset-age-nonresident-information?=
 =?US-ASCII?Q?-alongside-anonymous-pages.patch?= removed from -mm tree
Date: Fri, 26 Jun 2020 20:34:00 -0700
Message-ID: <20200627033400._PRJESEgx%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgF0DeB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:34:01 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, js1304@gmail.com, mhocko@suse.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm/swap: fix for "mm: workingset: age nonresident information alongside anonymous pages"
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-for-mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/swap: fix for "mm: workingset: age nonresident information alongside anonymous pages"

Non-file-lru page could also be activated in mark_page_accessed()
and we need to count this activation for nonresident_age.

Note that it's better for this patch to be squashed into the patch
"mm: workingset: age nonresident information alongside anonymous pages".

Link: http://lkml.kernel.org/r/1592288204-27734-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swap.c~mm-swap-fix-for-mm-workingset-age-nonresident-information-alongside-anonymous-pages
+++ a/mm/swap.c
@@ -443,8 +443,7 @@ void mark_page_accessed(struct page *pag
 		else
 			__lru_cache_activate_page(page);
 		ClearPageReferenced(page);
-		if (page_is_file_lru(page))
-			workingset_activation(page);
+		workingset_activation(page);
 	}
 	if (page_is_idle(page))
 		clear_page_idle(page);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-page_isolation-prefer-the-node-of-the-source-page.patch
mm-migrate-move-migration-helper-from-h-to-c.patch
mm-hugetlb-unify-migration-callbacks.patch
mm-hugetlb-make-hugetlb-migration-callback-cma-aware.patch
mm-migrate-make-a-standard-migration-target-allocation-function.patch
mm-gup-use-a-standard-migration-target-allocation-callback.patch
mm-mempolicy-use-a-standard-migration-target-allocation-callback.patch
mm-page_alloc-remove-a-wrapper-for-alloc_migration_target.patch
