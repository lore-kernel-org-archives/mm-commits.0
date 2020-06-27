From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-fix-io-cost-for-anonymous-page.patch
 removed from -mm tree
Date: Fri, 26 Jun 2020 20:34:02 -0700
Message-ID: <20200627033402.5NkvfK1Qq%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgF0DeD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:34:03 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, js1304@gmail.com, mhocko@suse.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm/memory: fix IO cost for anonymous page
has been removed from the -mm tree.  Its filename was
     mm-memory-fix-io-cost-for-anonymous-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/memory: fix IO cost for anonymous page

With synchronous IO swap device, swap-in is directly handled in fault
code.  Since IO cost notation isn't added there, with synchronous IO swap
device, LRU balancing could be wrongly biased.  Fix it to count it in
fault code.

Link: http://lkml.kernel.org/r/1592288204-27734-4-git-send-email-iamjoonsoo.kim@lge.com
Fixes: 314b57fb0460001 ("mm: balance LRU lists based on relative thrashing cache sizing")
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory.c~mm-memory-fix-io-cost-for-anonymous-page
+++ a/mm/memory.c
@@ -3146,6 +3146,14 @@ vm_fault_t do_swap_page(struct vm_fault
 					goto out_page;
 				}
 
+				/*
+				 * XXX: Move to lru_cache_add() when it
+				 * supports new vs putback
+				 */
+				spin_lock_irq(&page_pgdat(page)->lru_lock);
+				lru_note_cost_page(page);
+				spin_unlock_irq(&page_pgdat(page)->lru_lock);
+
 				lru_cache_add(page);
 				swap_readpage(page, true);
 			}
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
