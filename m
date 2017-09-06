From: akpm@linux-foundation.org
Subject: [patch 041/119] mm, page_owner: don't grab zone->lock for
 init_pages_in_zone()
Date: Wed, 06 Sep 2017 16:20:51 -0700
Message-ID: <20170906232051.gEaoz8_tm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49754 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753570AbdIFXUx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, labbott@redhat.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, vinmenon@codeaurora.org, yang.shi@linaro.org, zhongjiang@huawei.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: don't grab zone->lock for init_pages_in_zone()

init_pages_in_zone() is run under zone->lock, which means a long lock time
and disabled interrupts on large machines.  This is currently not an issue
since it runs early in boot, but a later patch will change that.  However,
like other pfn scanners, we don't actually need zone->lock even when other
cpus are running.  The only potentially dangerous operation here is
reading bogus buddy page owner due to race, and we already know how to
handle that.  The worse that can happen is that we skip some early
allocated pages, which should not affect the debugging power of page_owner
noticeably.

Link: http://lkml.kernel.org/r/20170720134029.25268-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: zhong jiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN mm/page_owner.c~mm-page_owner-dont-grab-zone-lock-for-init_pages_in_zone mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-dont-grab-zone-lock-for-init_pages_in_zone
+++ a/mm/page_owner.c
@@ -562,11 +562,17 @@ static void init_pages_in_zone(pg_data_t
 				continue;
 
 			/*
-			 * We are safe to check buddy flag and order, because
-			 * this is init stage and only single thread runs.
+			 * To avoid having to grab zone->lock, be a little
+			 * careful when reading buddy page order. The only
+			 * danger is that we skip too much and potentially miss
+			 * some early allocated pages, which is better than
+			 * heavy lock contention.
 			 */
 			if (PageBuddy(page)) {
-				pfn += (1UL << page_order(page)) - 1;
+				unsigned long order = page_order_unsafe(page);
+
+				if (order > 0 && order < MAX_ORDER)
+					pfn += (1UL << order) - 1;
 				continue;
 			}
 
@@ -585,6 +591,7 @@ static void init_pages_in_zone(pg_data_t
 			__set_page_owner_handle(page_ext, early_handle, 0, 0);
 			count++;
 		}
+		cond_resched();
 	}
 
 	pr_info("Node %d, zone %8s: page owner found early allocated %lu pages\n",
@@ -595,15 +602,12 @@ static void init_zones_in_node(pg_data_t
 {
 	struct zone *zone;
 	struct zone *node_zones = pgdat->node_zones;
-	unsigned long flags;
 
 	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
 		if (!populated_zone(zone))
 			continue;
 
-		spin_lock_irqsave(&zone->lock, flags);
 		init_pages_in_zone(pgdat, zone);
-		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 }
 
_
