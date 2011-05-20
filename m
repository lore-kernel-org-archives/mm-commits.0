From: akpm@linux-foundation.org
Subject: + memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch added to -mm tree
Date: Fri, 20 May 2011 13:13:49 -0700
Message-ID: <201105202013.p4KKDnm5028130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935756Ab1ETUOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 May 2011 16:14:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, balbir@in.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: rename mem_cgroup_zone_nr_pages() to mem_cgroup_zone_nr_lru_pages()
has been added to the -mm tree.  Its filename is
     memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch

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
@@ -108,9 +108,9 @@ extern void mem_cgroup_end_migration(str
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
@@ -310,8 +310,8 @@ mem_cgroup_inactive_file_is_low(struct m
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
@@ -172,7 +172,7 @@ static unsigned long zone_nr_lru_pages(s
 				struct scan_control *sc, enum lru_list lru)
 {
 	if (!scanning_global_lru(sc))
-		return mem_cgroup_zone_nr_pages(sc->mem_cgroup, zone, lru);
+		return mem_cgroup_zone_nr_lru_pages(sc->mem_cgroup, zone, lru);
 
 	return zone_page_state(zone, NR_LRU_BASE + lru);
 }
_

Patches currently in -mm which might be from yinghan@google.com are

vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-3.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch

