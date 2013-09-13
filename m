From: akpm@linux-foundation.org
Subject: [merged]
 memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:12 -0700
Message-ID: <52336f44.d2kovKKBrWY/8mTG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3IMUCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghan@google.com, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, bsingharora@gmail.com, mhocko@suse.cz

Subject: [merged] memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch removed from -mm tree
To: mhocko@suse.cz,bsingharora@gmail.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com,yinghan@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:12 -0700


The patch titled
     Subject: memcg, vmscan: do not attempt soft limit reclaim if it would not scan anything
has been removed from the -mm tree.  Its filename was
     memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg, vmscan: do not attempt soft limit reclaim if it would not scan anything

mem_cgroup_should_soft_reclaim controls whether soft reclaim pass is done
and it always says yes currently.  Memcg iterators are clever to skip
nodes that are not soft reclaimable quite efficiently but
mem_cgroup_should_soft_reclaim can be more clever and do not start the
soft reclaim pass at all if it knows that nothing would be scanned anyway.

In order to do that, simply reuse mem_cgroup_soft_reclaim_eligible for the
target group of the reclaim and allow the pass only if the whole subtree
wouldn't be skipped.

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

 mm/memcontrol.c |    6 +++++-
 mm/vmscan.c     |    4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything
+++ a/mm/memcontrol.c
@@ -1885,7 +1885,11 @@ enum mem_cgroup_filter_t
 mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
 		struct mem_cgroup *root)
 {
-	struct mem_cgroup *parent = memcg;
+	struct mem_cgroup *parent;
+
+	if (!memcg)
+		memcg = root_mem_cgroup;
+	parent = memcg;
 
 	if (res_counter_soft_limit_excess(&memcg->res))
 		return VISIT;
diff -puN mm/vmscan.c~memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything mm/vmscan.c
--- a/mm/vmscan.c~memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything
+++ a/mm/vmscan.c
@@ -142,7 +142,9 @@ static bool global_reclaim(struct scan_c
 
 static bool mem_cgroup_should_soft_reclaim(struct scan_control *sc)
 {
-	return !mem_cgroup_disabled();
+	struct mem_cgroup *root = sc->target_mem_cgroup;
+	return !mem_cgroup_disabled() &&
+		mem_cgroup_soft_reclaim_eligible(root, root) != SKIP_TREE;
 }
 #else
 static bool global_reclaim(struct scan_control *sc)
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
watchdog-update-watchdog_tresh-properly-fix.patch

