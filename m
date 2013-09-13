From: akpm@linux-foundation.org
Subject: [merged]
 memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 13:02:16 -0700
Message-ID: <52336f48.afYa8R003Fb9t+qZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3IMUCR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghan@google.com, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, bsingharora@gmail.com, mhocko@suse.cz

Subject: [merged] memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch removed from -mm tree
To: mhocko@suse.cz,bsingharora@gmail.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com,yinghan@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:16 -0700


The patch titled
     Subject: memcg, vmscan: do not fall into reclaim-all pass too quickly
has been removed from the -mm tree.  Its filename was
     memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg, vmscan: do not fall into reclaim-all pass too quickly

shrink_zone starts with soft reclaim pass first and then falls back to
regular reclaim if nothing has been scanned.  This behavior is natural but
there is a catch.  Memcg iterators, when used with the reclaim cookie, are
designed to help to prevent from over reclaim by interleaving reclaimers
(per node-zone-priority) so the tree walk might miss many (even all) nodes
in the hierarchy e.g.  when there are direct reclaimers racing with each
other or with kswapd in the global case or multiple allocators reaching
the limit for the target reclaim case.  To make it even more complicated,
targeted reclaim doesn't do the whole tree walk because it stops
reclaiming once it reclaims sufficient pages.  As a result groups over the
limit might be missed, thus nothing is scanned, and reclaim would fall
back to the reclaim all mode.

This patch checks for the incomplete tree walk in shrink_zone.  If no
group has been visited and the hierarchy is soft reclaimable then we must
have missed some groups, in which case the __shrink_zone is called again. 
This doesn't guarantee there will be some progress of course because the
current reclaimer might be still racing with others but it would at least
give a chance to start the walk without a big risk of reclaim latencies.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly mm/vmscan.c
--- a/mm/vmscan.c~memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly
+++ a/mm/vmscan.c
@@ -2142,10 +2142,11 @@ static inline bool should_continue_recla
 	}
 }
 
-static void
+static int
 __shrink_zone(struct zone *zone, struct scan_control *sc, bool soft_reclaim)
 {
 	unsigned long nr_reclaimed, nr_scanned;
+	int groups_scanned = 0;
 
 	do {
 		struct mem_cgroup *root = sc->target_mem_cgroup;
@@ -2163,6 +2164,7 @@ __shrink_zone(struct zone *zone, struct
 		while ((memcg = mem_cgroup_iter_cond(root, memcg, &reclaim, filter))) {
 			struct lruvec *lruvec;
 
+			groups_scanned++;
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
 			shrink_lruvec(lruvec, sc);
@@ -2190,6 +2192,8 @@ __shrink_zone(struct zone *zone, struct
 
 	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
 					 sc->nr_scanned - nr_scanned, sc));
+
+	return groups_scanned;
 }
 
 
@@ -2197,8 +2201,19 @@ static void shrink_zone(struct zone *zon
 {
 	bool do_soft_reclaim = mem_cgroup_should_soft_reclaim(sc);
 	unsigned long nr_scanned = sc->nr_scanned;
+	int scanned_groups;
 
-	__shrink_zone(zone, sc, do_soft_reclaim);
+	scanned_groups = __shrink_zone(zone, sc, do_soft_reclaim);
+	/*
+         * memcg iterator might race with other reclaimer or start from
+         * a incomplete tree walk so the tree walk in __shrink_zone
+         * might have missed groups that are above the soft limit. Try
+         * another loop to catch up with others. Do it just once to
+         * prevent from reclaim latencies when other reclaimers always
+         * preempt this one.
+	 */
+	if (do_soft_reclaim && !scanned_groups)
+		__shrink_zone(zone, sc, do_soft_reclaim);
 
 	/*
 	 * No group is over the soft limit or those that are do not have
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
watchdog-update-watchdog_tresh-properly-fix.patch

