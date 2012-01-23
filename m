From: akpm@linux-foundation.org
Subject: [merged] mm-__count_immobile_pages-make-sure-the-node-is-online.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:17 -0800
Message-ID: <20120123202117.B34FF1E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58337 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2AWUVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:18 -0500
Received: by ghbg20 with SMTP id g20so288772ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 12:21:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: __count_immobile_pages(): make sure the node is online
has been removed from the -mm tree.  Its filename was
     mm-__count_immobile_pages-make-sure-the-node-is-online.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: __count_immobile_pages(): make sure the node is online

page_zone() requires an online node otherwise we are accessing NULL
NODE_DATA.  This is not an issue at the moment because node_zones are
located at the structure beginning but this might change in the future so
better be careful about that.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-__count_immobile_pages-make-sure-the-node-is-online mm/page_alloc.c
--- a/mm/page_alloc.c~mm-__count_immobile_pages-make-sure-the-node-is-online
+++ a/mm/page_alloc.c
@@ -5413,15 +5413,22 @@ __count_immobile_pages(struct zone *zone
 
 bool is_pageblock_removable_nolock(struct page *page)
 {
-	struct zone *zone = page_zone(page);
-	unsigned long pfn = page_to_pfn(page);
+	struct zone *zone;
+	unsigned long pfn;
 
 	/*
 	 * We have to be careful here because we are iterating over memory
 	 * sections which are not zone aware so we might end up outside of
 	 * the zone but still within the section.
+	 * We have to take care about the node as well. If the node is offline
+	 * its NODE_DATA will be NULL - see page_zone.
 	 */
-	if (!zone || zone->zone_start_pfn > pfn ||
+	if (!node_online(page_to_nid(page)))
+		return false;
+
+	zone = page_zone(page);
+	pfn = page_to_pfn(page);
+	if (zone->zone_start_pfn > pfn ||
 			zone->zone_start_pfn + zone->spanned_pages <= pfn)
 		return false;
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch

