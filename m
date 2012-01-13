From: akpm@linux-foundation.org
Subject: [merged] memcg-clean-up-soft_limit_tree-if-allocation-fails.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:34:00 -0800
Message-ID: <20120113203401.2CEAA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37836 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:34:03 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25396eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:34:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, aarcange@redhat.com, bsingharora@gmail.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: free entries in soft_limit_tree if allocation fails
has been removed from the -mm tree.  Its filename was
     memcg-clean-up-soft_limit_tree-if-allocation-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: free entries in soft_limit_tree if allocation fails

If we are not able to allocate tree nodes for all NUMA nodes then we
should release those that were allocated.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-clean-up-soft_limit_tree-if-allocation-fails mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-soft_limit_tree-if-allocation-fails
+++ a/mm/memcontrol.c
@@ -4960,7 +4960,7 @@ static int mem_cgroup_soft_limit_tree_in
 			tmp = -1;
 		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
 		if (!rtpn)
-			return 1;
+			goto err_cleanup;
 
 		soft_limit_tree.rb_tree_per_node[node] = rtpn;
 
@@ -4971,6 +4971,16 @@ static int mem_cgroup_soft_limit_tree_in
 		}
 	}
 	return 0;
+
+err_cleanup:
+	for_each_node_state(node, N_POSSIBLE) {
+		if (!soft_limit_tree.rb_tree_per_node[node])
+			break;
+		kfree(soft_limit_tree.rb_tree_per_node[node]);
+		soft_limit_tree.rb_tree_per_node[node] = NULL;
+	}
+	return 1;
+
 }
 
 static struct cgroup_subsys_state * __ref
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch

