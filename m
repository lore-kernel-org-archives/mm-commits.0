From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-use_hierarchy-css_is_ancestor-oops-regression.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:17 -0700
Message-ID: <20120621192517.56B28A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:45647 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050Ab2FUTZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:19 -0400
Received: by mail-lb0-f202.google.com with SMTP id gp10so125586lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix use_hierarchy css_is_ancestor oops regression
has been removed from the -mm tree.  Its filename was
     memcg-fix-use_hierarchy-css_is_ancestor-oops-regression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: fix use_hierarchy css_is_ancestor oops regression

If use_hierarchy is set, reclaim testing soon oopses in css_is_ancestor()
called from __mem_cgroup_same_or_subtree() called from page_referenced():
when processes are exiting, it's easy for mm_match_cgroup() to pass along
a NULL memcg coming from a NULL mm->owner.

Check for that in __mem_cgroup_same_or_subtree().  Return true or false? 
False because we cannot know if it was in the hierarchy, but also false
because it's better not to count a reference from an exiting process.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-use_hierarchy-css_is_ancestor-oops-regression mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-use_hierarchy-css_is_ancestor-oops-regression
+++ a/mm/memcontrol.c
@@ -1148,7 +1148,7 @@ bool __mem_cgroup_same_or_subtree(const 
 {
 	if (root_memcg == memcg)
 		return true;
-	if (!root_memcg->use_hierarchy)
+	if (!root_memcg->use_hierarchy || !memcg)
 		return false;
 	return css_is_ancestor(&memcg->css, &root_memcg->css);
 }
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
tmpfs-implement-numa-node-interleaving.patch
tmpfs-implement-numa-node-interleaving-fix.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-remove-mem_cgroup_charge_type_force.patch
swap-allow-swap-readahead-to-be-merged.patch
documentation-update-how-page-cluster-affects-swap-i-o.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
prio_tree-debugging-patch.patch

