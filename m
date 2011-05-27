From: akpm@linux-foundation.org
Subject: [merged] memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:16 -0700
Message-ID: <201105271956.p4RJuLUp017546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148Ab1E0T4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, balbir@in.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: rename mem_cgroup_zone_nr_pages() to mem_cgroup_zone_nr_lru_pages()
has been removed from the -mm tree.  Its filename was
     memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: rename mem_cgroup_zone_nr_pages() to mem_cgroup_zone_nr_lru_pages()
From: Ying Han <yinghan@google.com>

The caller of the function has been renamed to zone_nr_lru_pages(), and
this is just fixing up in the memcg code.  The current name is easily to
be mis-read as zone's total number of pages.

Signed-off-by: Ying Han <yinghan@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +++++-----
 mm/memcontrol.c            |    6 +++---
 mm/vmscan.c                |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages
+++ a/include/linux/memcontrol.h
@@ -107,9 +107,9 @@ extern void mem_cgroup_end_migration(str
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg);
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
-unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
-				       struct zone *zone,
-				       enum lru_list lru);
+unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
+						struct zone *zone,
+						enum lru_list lru);
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
 						      struct zone *zone);
 struct zone_reclaim_stat*
@@ -304,8 +304,8 @@ mem_cgroup_inactive_file_is_low(struct m
 }
 
 static inline unsigned long
-mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg, struct zone *zone,
-			 enum lru_list lru)
+mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, struct zone *zone,
+			     enum lru_list lru)
 {
 	return 0;
 }
diff -puN mm/memcontrol.c~memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages
+++ a/mm/memcontrol.c
@@ -1078,9 +1078,9 @@ int mem_cgroup_inactive_file_is_low(stru
 	return (active > inactive);
 }
 
-unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
-				       struct zone *zone,
-				       enum lru_list lru)
+unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
+						struct zone *zone,
+						enum lru_list lru)
 {
 	int nid = zone_to_nid(zone);
 	int zid = zone_idx(zone);
diff -puN mm/vmscan.c~memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages mm/vmscan.c
--- a/mm/vmscan.c~memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages
+++ a/mm/vmscan.c
@@ -173,7 +173,7 @@ static unsigned long zone_nr_lru_pages(s
 				struct scan_control *sc, enum lru_list lru)
 {
 	if (!scanning_global_lru(sc))
-		return mem_cgroup_zone_nr_pages(sc->mem_cgroup, zone, lru);
+		return mem_cgroup_zone_nr_lru_pages(sc->mem_cgroup, zone, lru);
 
 	return zone_page_state(zone, NR_LRU_BASE + lru);
 }
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch

