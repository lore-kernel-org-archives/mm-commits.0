From: akpm@linux-foundation.org
Subject: [merged] page_alloc-break-early-in-check_for_regular_memory.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:34:27 -0800
Message-ID: <20120113203428.186285C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37836 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:34:30 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25396eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:34:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page_alloc: break early in check_for_regular_memory()
has been removed from the -mm tree.  Its filename was
     page_alloc-break-early-in-check_for_regular_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: page_alloc: break early in check_for_regular_memory()

If there is a zone below ZONE_NORMAL has present_pages, we can set node
state to N_NORMAL_MEMORY, no need to loop to end.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page_alloc-break-early-in-check_for_regular_memory mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-break-early-in-check_for_regular_memory
+++ a/mm/page_alloc.c
@@ -4642,8 +4642,10 @@ static void check_for_regular_memory(pg_
 
 	for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
-		if (zone->present_pages)
+		if (zone->present_pages) {
 			node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
+			break;
+		}
 	}
 #endif
 }
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch

