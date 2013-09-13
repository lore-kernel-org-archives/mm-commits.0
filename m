From: akpm@linux-foundation.org
Subject: [merged] memcg-track-all-children-over-limit-in-the-root.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:14 -0700
Message-ID: <52336f46.V6nvi9DQD2Kf6fj0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3IMUCP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghan@google.com, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, bsingharora@gmail.com, mhocko@suse.cz

Subject: [merged] memcg-track-all-children-over-limit-in-the-root.patch removed from -mm tree
To: mhocko@suse.cz,bsingharora@gmail.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com,yinghan@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:14 -0700


The patch titled
     Subject: memcg: track all children over limit in the root
has been removed from the -mm tree.  Its filename was
     memcg-track-all-children-over-limit-in-the-root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: track all children over limit in the root

Children in soft limit excess are currently tracked up the hierarchy in
memcg->children_in_excess.  Nevertheless there still might exist tons of
groups that are not in hierarchy relation to the root cgroup (e.g.  all
first level groups if root_mem_cgroup->use_hierarchy == false).

As the whole tree walk has to be done when the iteration starts at
root_mem_cgroup the iterator should be able to skip the walk if there is
no child above the limit without iterating them.  This can be done easily
if the root tracks all children rather than only hierarchical children. 
This is done by this patch which updates root_mem_cgroup
children_in_excess if root_mem_cgroup->use_hierarchy == false so the root
knows about all children in excess.

Please note that this is not an issue for inner memcgs which have
use_hierarchy == false because then only the single group is visited so no
special optimization is necessary.

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

 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN mm/memcontrol.c~memcg-track-all-children-over-limit-in-the-root mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-track-all-children-over-limit-in-the-root
+++ a/mm/memcontrol.c
@@ -864,9 +864,15 @@ static void mem_cgroup_update_soft_limit
 	/*
 	 * Necessary to update all ancestors when hierarchy is used
 	 * because their event counter is not touched.
+	 * We track children even outside the hierarchy for the root
+	 * cgroup because tree walk starting at root should visit
+	 * all cgroups and we want to prevent from pointless tree
+	 * walk if no children is below the limit.
 	 */
 	while (delta && (parent = parent_mem_cgroup(parent)))
 		atomic_add(delta, &parent->children_in_excess);
+	if (memcg != root_mem_cgroup && !root_mem_cgroup->use_hierarchy)
+		atomic_add(delta, &root_mem_cgroup->children_in_excess);
 	spin_unlock(&memcg->soft_lock);
 }
 
@@ -6043,6 +6049,9 @@ static void mem_cgroup_css_offline(struc
 	if (memcg->soft_contributed) {
 		while ((memcg = parent_mem_cgroup(memcg)))
 			atomic_dec(&memcg->children_in_excess);
+
+		if (memcg != root_mem_cgroup && !root_mem_cgroup->use_hierarchy)
+			atomic_dec(&root_mem_cgroup->children_in_excess);
 	}
 	mem_cgroup_destroy_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
watchdog-update-watchdog_tresh-properly-fix.patch

