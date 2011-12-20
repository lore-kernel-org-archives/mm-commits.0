From: akpm@linux-foundation.org
Subject: + page_alloc-break-early-in-check_for_regular_memory.patch added to -mm tree
Date: Tue, 20 Dec 2011 15:01:38 -0800
Message-ID: <20111220230139.351CB1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:51700 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1LTXBk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 18:01:40 -0500
Received: by yhjj51 with SMTP id j51so1089976yhj.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 15:01:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: page_alloc: break early in check_for_regular_memory()
has been added to the -mm tree.  Its filename is
     page_alloc-break-early-in-check_for_regular_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: page_alloc: break early in check_for_regular_memory()

If there is a zone below ZONE_NORMAL has present_pages, we can set node
state to N_NORMAL_MEMORY, no need to loop to end.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page_alloc-break-early-in-check_for_regular_memory mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-break-early-in-check_for_regular_memory
+++ a/mm/page_alloc.c
@@ -4655,8 +4655,10 @@ static void check_for_regular_memory(pg_
 
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
Subject: Subject: page_alloc: break early in check_for_regular_memory()

Patches currently in -mm which might be from lliubbo@gmail.com are

linux-next.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch

