From: akpm@linux-foundation.org
Subject: [merged]
 vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 13:02:06 -0700
Message-ID: <52336f3e.j72SrPtXbUos6Y//%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab3IMUCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghan@google.com, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, bsingharora@gmail.com, mhocko@suse.cz

Subject: [merged] vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch removed from -mm tree
To: mhocko@suse.cz,bsingharora@gmail.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com,yinghan@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:06 -0700


The patch titled
     Subject: vmscan, memcg: do softlimit reclaim also for targeted reclaim
has been removed from the -mm tree.  Its filename was
     vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: vmscan, memcg: do softlimit reclaim also for targeted reclaim

Soft reclaim has been done only for the global reclaim (both background
and direct).  Since "memcg: integrate soft reclaim tighter with zone
shrinking code" there is no reason for this limitation anymore as the soft
limit reclaim doesn't use any special code paths and it is a part of the
zone shrinking code which is used by both global and targeted reclaims.

From the semantic point of view it is natural to consider soft limit
before touching all groups in the hierarchy tree which is touching the
hard limit because soft limit tells us where to push back when there is a
memory pressure.  It is not important whether the pressure comes from the
limit or imbalanced zones.

This patch simply enables soft reclaim unconditionally in
mem_cgroup_should_soft_reclaim so it is enabled for both global and
targeted reclaim paths.  mem_cgroup_soft_reclaim_eligible needs to learn
about the root of the reclaim to know where to stop checking soft limit
state of parents up the hierarchy.  Say we have

A (over soft limit)
 \
  B (below s.l., hit the hard limit)
 / \
C   D (below s.l.)

B is the source of the outside memory pressure now for D but we shouldn't
soft reclaim it because it is behaving well under B subtree and we can
still reclaim from C (pressumably it is over the limit). 
mem_cgroup_soft_reclaim_eligible should therefore stop climbing up the
hierarchy at B (root of the memory pressure).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Glauber Costa <glommer@openvz.org>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 ++++--
 mm/memcontrol.c            |   14 +++++++++-----
 mm/vmscan.c                |    4 ++--
 3 files changed, 15 insertions(+), 9 deletions(-)

diff -puN include/linux/memcontrol.h~vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim
+++ a/include/linux/memcontrol.h
@@ -180,7 +180,8 @@ static inline void mem_cgroup_dec_page_s
 	mem_cgroup_update_page_stat(page, idx, -1);
 }
 
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg);
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
+		struct mem_cgroup *root);
 
 void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
 static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
@@ -357,7 +358,8 @@ static inline void mem_cgroup_dec_page_s
 }
 
 static inline
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg)
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
+		struct mem_cgroup *root)
 {
 	return false;
 }
diff -puN mm/memcontrol.c~vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim
+++ a/mm/memcontrol.c
@@ -1773,11 +1773,13 @@ int mem_cgroup_select_victim_node(struct
 #endif
 
 /*
- * A group is eligible for the soft limit reclaim if it is
- * 	a) is over its soft limit
+ * A group is eligible for the soft limit reclaim under the given root
+ * hierarchy if
+ * 	a) it is over its soft limit
  * 	b) any parent up the hierarchy is over its soft limit
  */
-bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg)
+bool mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
+		struct mem_cgroup *root)
 {
 	struct mem_cgroup *parent = memcg;
 
@@ -1785,12 +1787,14 @@ bool mem_cgroup_soft_reclaim_eligible(st
 		return true;
 
 	/*
-	 * If any parent up the hierarchy is over its soft limit then we
-	 * have to obey and reclaim from this group as well.
+	 * If any parent up to the root in the hierarchy is over its soft limit
+	 * then we have to obey and reclaim from this group as well.
 	 */
 	while((parent = parent_mem_cgroup(parent))) {
 		if (res_counter_soft_limit_excess(&parent->res))
 			return true;
+		if (parent == root)
+			break;
 	}
 
 	return false;
diff -puN mm/vmscan.c~vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim mm/vmscan.c
--- a/mm/vmscan.c~vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim
+++ a/mm/vmscan.c
@@ -142,7 +142,7 @@ static bool global_reclaim(struct scan_c
 
 static bool mem_cgroup_should_soft_reclaim(struct scan_control *sc)
 {
-	return !mem_cgroup_disabled() && global_reclaim(sc);
+	return !mem_cgroup_disabled();
 }
 #else
 static bool global_reclaim(struct scan_control *sc)
@@ -2161,7 +2161,7 @@ __shrink_zone(struct zone *zone, struct
 			struct lruvec *lruvec;
 
 			if (soft_reclaim &&
-			    !mem_cgroup_soft_reclaim_eligible(memcg)) {
+			    !mem_cgroup_soft_reclaim_eligible(memcg, root)) {
 				memcg = mem_cgroup_iter(root, memcg, &reclaim);
 				continue;
 			}
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
watchdog-update-watchdog_tresh-properly-fix.patch

