From: akpm@linux-foundation.org
Subject: + mm-page_owner-dont-grab-zone-lock-for-init_pages_in_zone.patch
 added to -mm tree
Date: Fri, 21 Jul 2017 13:07:29 -0700
Message-ID: <59725f01.c6zFTaFYPRjiFopD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbdGUUHa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 16:07:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, labbott@redhat.com, mgorman@techsingularity.net, mhocko@kernel.org, vinmenon@codeaurora.org, yang.shi@linaro.org, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: don't grab zone->lock for init_pages_in_zone()
has been added to the -mm tree.  Its filename is
     mm-page_owner-dont-grab-zone-lock-for-init_pages_in_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-dont-grab-zone-lock-for-init_pages_in_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-dont-grab-zone-lock-for-init_pages_in_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
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
@@ -567,11 +567,17 @@ static void init_pages_in_zone(pg_data_t
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
 
@@ -590,6 +596,7 @@ static void init_pages_in_zone(pg_data_t
 			__set_page_owner_init(page_ext, init_handle);
 			count++;
 		}
+		cond_resched();
 	}
 
 	pr_info("Node %d, zone %8s: page owner found early allocated %lu pages\n",
@@ -600,15 +607,12 @@ static void init_zones_in_node(pg_data_t
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_owner-make-init_pages_in_zone-faster.patch
mm-page_ext-periodically-reschedule-during-page_ext_init.patch
mm-page_owner-dont-grab-zone-lock-for-init_pages_in_zone.patch
mm-page_ext-move-page_ext_init-after-page_alloc_init_late.patch

