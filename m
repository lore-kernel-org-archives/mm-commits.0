From: akpm@linux-foundation.org
Subject: [merged] memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:03 -0800
Message-ID: <20130225205503.B43D95A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:54775 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3BYUzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:04 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so347476ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: move mem_cgroup_soft_limit_tree_init to mem_cgroup_init
has been removed from the -mm tree.  Its filename was
     memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: move mem_cgroup_soft_limit_tree_init to mem_cgroup_init

Per-node-zone soft limit tree is currently initialized when the root
cgroup is created which is OK but it pointlessly pollutes memcg allocation
code with something that can be called when the memcg subsystem is
initialized by mem_cgroup_init along with other controller specific parts.

While we are at it let's make mem_cgroup_soft_limit_tree_init void because
it doesn't make much sense to report memory failure because if we fail to
allocate memory that early during the boot then we are screwed anyway
(this saves some code).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff -puN mm/memcontrol.c~memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init
+++ a/mm/memcontrol.c
@@ -6052,7 +6052,7 @@ struct mem_cgroup *parent_mem_cgroup(str
 }
 EXPORT_SYMBOL(parent_mem_cgroup);
 
-static int mem_cgroup_soft_limit_tree_init(void)
+static void __init mem_cgroup_soft_limit_tree_init(void)
 {
 	struct mem_cgroup_tree_per_node *rtpn;
 	struct mem_cgroup_tree_per_zone *rtpz;
@@ -6063,8 +6063,7 @@ static int mem_cgroup_soft_limit_tree_in
 		if (!node_state(node, N_NORMAL_MEMORY))
 			tmp = -1;
 		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
-		if (!rtpn)
-			goto err_cleanup;
+		BUG_ON(!rtpn);
 
 		soft_limit_tree.rb_tree_per_node[node] = rtpn;
 
@@ -6074,17 +6073,6 @@ static int mem_cgroup_soft_limit_tree_in
 			spin_lock_init(&rtpz->lock);
 		}
 	}
-	return 0;
-
-err_cleanup:
-	for_each_node(node) {
-		if (!soft_limit_tree.rb_tree_per_node[node])
-			break;
-		kfree(soft_limit_tree.rb_tree_per_node[node]);
-		soft_limit_tree.rb_tree_per_node[node] = NULL;
-	}
-	return 1;
-
 }
 
 static struct cgroup_subsys_state * __ref
@@ -6106,8 +6094,6 @@ mem_cgroup_css_alloc(struct cgroup *cont
 	if (cont->parent == NULL) {
 		int cpu;
 
-		if (mem_cgroup_soft_limit_tree_init())
-			goto free_out;
 		root_mem_cgroup = memcg;
 		for_each_possible_cpu(cpu) {
 			struct memcg_stock_pcp *stock =
@@ -6850,6 +6836,7 @@ static int __init mem_cgroup_init(void)
 {
 	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
 	enable_swap_cgroup();
+	mem_cgroup_soft_limit_tree_init();
 	return 0;
 }
 subsys_initcall(mem_cgroup_init);
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

