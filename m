From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:29:55 -0800
Message-ID: <56a169f3.271orCzLmkGRI0ce%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAUX3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:29:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: replace mem_cgroup_lruvec_online with mem_cgroup_online
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: replace mem_cgroup_lruvec_online with mem_cgroup_online

mem_cgroup_lruvec_online() takes lruvec, but it only needs memcg.  Since
get_scan_count(), which is the only user of this function, now possesses
pointer to memcg, let's pass memcg directly to mem_cgroup_online() instead
of picking it out of lruvec and rename the function accordingly.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   27 ++++++++++-----------------
 mm/vmscan.c                |    2 +-
 2 files changed, 11 insertions(+), 18 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online
+++ a/include/linux/memcontrol.h
@@ -355,6 +355,13 @@ static inline bool mem_cgroup_disabled(v
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
+static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled())
+		return true;
+	return !!(memcg->css.flags & CSS_ONLINE);
+}
+
 /*
  * For memory reclaim.
  */
@@ -363,20 +370,6 @@ int mem_cgroup_select_victim_node(struct
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int nr_pages);
 
-static inline bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
-{
-	struct mem_cgroup_per_zone *mz;
-	struct mem_cgroup *memcg;
-
-	if (mem_cgroup_disabled())
-		return true;
-
-	mz = container_of(lruvec, struct mem_cgroup_per_zone, lruvec);
-	memcg = mz->memcg;
-
-	return !!(memcg->css.flags & CSS_ONLINE);
-}
-
 static inline
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
@@ -589,13 +582,13 @@ static inline bool mem_cgroup_disabled(v
 	return true;
 }
 
-static inline bool
-mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
+static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 {
 	return true;
 }
 
-static inline bool mem_cgroup_lruvec_online(struct lruvec *lruvec)
+static inline bool
+mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
 {
 	return true;
 }
diff -puN mm/vmscan.c~mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online mm/vmscan.c
--- a/mm/vmscan.c~mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online
+++ a/mm/vmscan.c
@@ -1997,7 +1997,7 @@ static void get_scan_count(struct lruvec
 	if (current_is_kswapd()) {
 		if (!zone_reclaimable(zone))
 			force_scan = true;
-		if (!mem_cgroup_lruvec_online(lruvec))
+		if (!mem_cgroup_online(memcg))
 			force_scan = true;
 	}
 	if (!global_reclaim(sc))
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are


