From: akpm@linux-foundation.org
Subject: [merged] mm-refactor-inactive_file_is_low-to-use-get_lru_size.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:54:20 -0800
Message-ID: <20130225205420.AEFD15A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:44389 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3BYUyW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:54:22 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so348027ggn.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:54:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor inactive_file_is_low() to use get_lru_size()
has been removed from the -mm tree.  Its filename was
     mm-refactor-inactive_file_is_low-to-use-get_lru_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: refactor inactive_file_is_low() to use get_lru_size()

An inactive file list is considered low when its active counterpart is
bigger, regardless of whether it is a global zone LRU list or a memcg zone
LRU list.  The only difference is in how the LRU size is assessed.

get_lru_size() does the right thing for both global and memcg reclaim
situations.

Get rid of inactive_file_is_low_global() and
mem_cgroup_inactive_file_is_low() by using get_lru_size() and compare the
numbers in common code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 -------
 mm/memcontrol.c            |   11 -----------
 mm/vmscan.c                |   19 ++++++-------------
 3 files changed, 6 insertions(+), 31 deletions(-)

diff -puN include/linux/memcontrol.h~mm-refactor-inactive_file_is_low-to-use-get_lru_size include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-refactor-inactive_file_is_low-to-use-get_lru_size
+++ a/include/linux/memcontrol.h
@@ -116,7 +116,6 @@ void mem_cgroup_iter_break(struct mem_cg
  * For memory reclaim.
  */
 int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec);
-int mem_cgroup_inactive_file_is_low(struct lruvec *lruvec);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list);
 void mem_cgroup_update_lru_size(struct lruvec *, enum lru_list, int);
@@ -321,12 +320,6 @@ mem_cgroup_inactive_anon_is_low(struct l
 	return 1;
 }
 
-static inline int
-mem_cgroup_inactive_file_is_low(struct lruvec *lruvec)
-{
-	return 1;
-}
-
 static inline unsigned long
 mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
 {
diff -puN mm/memcontrol.c~mm-refactor-inactive_file_is_low-to-use-get_lru_size mm/memcontrol.c
--- a/mm/memcontrol.c~mm-refactor-inactive_file_is_low-to-use-get_lru_size
+++ a/mm/memcontrol.c
@@ -1396,17 +1396,6 @@ int mem_cgroup_inactive_anon_is_low(stru
 	return inactive * inactive_ratio < active;
 }
 
-int mem_cgroup_inactive_file_is_low(struct lruvec *lruvec)
-{
-	unsigned long active;
-	unsigned long inactive;
-
-	inactive = mem_cgroup_get_lru_size(lruvec, LRU_INACTIVE_FILE);
-	active = mem_cgroup_get_lru_size(lruvec, LRU_ACTIVE_FILE);
-
-	return (active > inactive);
-}
-
 #define mem_cgroup_from_res_counter(counter, member)	\
 	container_of(counter, struct mem_cgroup, member)
 
diff -puN mm/vmscan.c~mm-refactor-inactive_file_is_low-to-use-get_lru_size mm/vmscan.c
--- a/mm/vmscan.c~mm-refactor-inactive_file_is_low-to-use-get_lru_size
+++ a/mm/vmscan.c
@@ -1579,16 +1579,6 @@ static inline int inactive_anon_is_low(s
 }
 #endif
 
-static int inactive_file_is_low_global(struct zone *zone)
-{
-	unsigned long active, inactive;
-
-	active = zone_page_state(zone, NR_ACTIVE_FILE);
-	inactive = zone_page_state(zone, NR_INACTIVE_FILE);
-
-	return (active > inactive);
-}
-
 /**
  * inactive_file_is_low - check if file pages need to be deactivated
  * @lruvec: LRU vector to check
@@ -1605,10 +1595,13 @@ static int inactive_file_is_low_global(s
  */
 static int inactive_file_is_low(struct lruvec *lruvec)
 {
-	if (!mem_cgroup_disabled())
-		return mem_cgroup_inactive_file_is_low(lruvec);
+	unsigned long inactive;
+	unsigned long active;
+
+	inactive = get_lru_size(lruvec, LRU_INACTIVE_FILE);
+	active = get_lru_size(lruvec, LRU_ACTIVE_FILE);
 
-	return inactive_file_is_low_global(lruvec_zone(lruvec));
+	return active > inactive;
 }
 
 static int inactive_list_is_low(struct lruvec *lruvec, enum lru_list lru)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

