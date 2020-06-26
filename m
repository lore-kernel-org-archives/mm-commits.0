From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 27/32] mm/memory: fix IO cost for anonymous page
Date: Thu, 25 Jun 2020 20:30:37 -0700
Message-ID: <20200626033037.DBF4bo_E5%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728328AbgFZDah (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 23:30:37 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, js1304@gmail.com, mhocko@suse.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org, riel@surriel.com, torvalds@linux-foundation.org

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
