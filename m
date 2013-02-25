From: akpm@linux-foundation.org
Subject: [merged] memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:53 -0800
Message-ID: <20130225204853.C69655A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:41254 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826Ab3BYUsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:55 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so345991ghb.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, glommer@parallels.com, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg,vmscan: do not break out targeted reclaim without reclaimed pages
has been removed from the -mm tree.  Its filename was
     memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg,vmscan: do not break out targeted reclaim without reclaimed pages

Targeted (hard resp.  soft) reclaim has traditionally tried to scan one
group with decreasing priority until nr_to_reclaim (SWAP_CLUSTER_MAX
pages) is reclaimed or all priorities are exhausted.  The reclaim is then
retried until the limit is met.

This approach, however, doesn't work well with deeper hierarchies where
groups higher in the hierarchy do not have any or only very few pages
(this usually happens if those groups do not have any tasks and they have
only re-parented pages after some of their children is removed).  Those
groups are reclaimed with decreasing priority pointlessly as there is
nothing to reclaim from them.

An easiest fix is to break out of the memcg iteration loop in shrink_zone
only if the whole hierarchy has been visited or sufficient pages have been
reclaimed.  This is also more natural because the reclaimer expects that
the hierarchy under the given root is reclaimed.  As a result we can
simplify the soft limit reclaim which does its own iteration.

[yinghan@google.com: break out of the hierarchy loop only if nr_reclaimed exceeded nr_to_reclaim]
[akpm@linux-foundation.org: use conventional comparison order]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN mm/vmscan.c~memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages mm/vmscan.c
--- a/mm/vmscan.c~memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages
+++ a/mm/vmscan.c
@@ -1973,18 +1973,17 @@ static void shrink_zone(struct zone *zon
 			shrink_lruvec(lruvec, sc);
 
 			/*
-			 * Limit reclaim has historically picked one
-			 * memcg and scanned it with decreasing
-			 * priority levels until nr_to_reclaim had
-			 * been reclaimed.  This priority cycle is
-			 * thus over after a single memcg.
-			 *
-			 * Direct reclaim and kswapd, on the other
-			 * hand, have to scan all memory cgroups to
-			 * fulfill the overall scan target for the
+			 * Direct reclaim and kswapd have to scan all memory
+			 * cgroups to fulfill the overall scan target for the
 			 * zone.
+			 *
+			 * Limit reclaim, on the other hand, only cares about
+			 * nr_to_reclaim pages to be reclaimed and it will
+			 * retry with decreasing priority if one round over the
+			 * whole hierarchy is not sufficient.
 			 */
-			if (!global_reclaim(sc)) {
+			if (!global_reclaim(sc) &&
+					sc->nr_reclaimed >= sc->nr_to_reclaim) {
 				mem_cgroup_iter_break(root, memcg);
 				break;
 			}
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

