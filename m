From: akpm@linux-foundation.org
Subject: [merged] memcg-cleanup-for_each_node_state.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:34:24 -0800
Message-ID: <20120113203424.AD7A31E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:36289 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759097Ab2AMUeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:34:25 -0500
Received: by mail-yx0-f202.google.com with SMTP id l1so72194yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:34:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: cleanup for_each_node_state()
has been removed from the -mm tree.  Its filename was
     memcg-cleanup-for_each_node_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: memcg: cleanup for_each_node_state()

We already have for_each_node(node) define in nodemask.h, better to use it.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-cleanup-for_each_node_state mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cleanup-for_each_node_state
+++ a/mm/memcontrol.c
@@ -565,7 +565,7 @@ static void mem_cgroup_remove_from_trees
 	struct mem_cgroup_per_zone *mz;
 	struct mem_cgroup_tree_per_zone *mctz;
 
-	for_each_node_state(node, N_POSSIBLE) {
+	for_each_node(node) {
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 			mz = mem_cgroup_zoneinfo(memcg, node, zone);
 			mctz = soft_limit_tree_node_zone(node, zone);
@@ -4818,7 +4818,7 @@ static void __mem_cgroup_free(struct mem
 	mem_cgroup_remove_from_trees(memcg);
 	free_css_id(&mem_cgroup_subsys, &memcg->css);
 
-	for_each_node_state(node, N_POSSIBLE)
+	for_each_node(node)
 		free_mem_cgroup_per_zone_info(memcg, node);
 
 	free_percpu(memcg->stat);
@@ -4877,7 +4877,7 @@ static int mem_cgroup_soft_limit_tree_in
 	struct mem_cgroup_tree_per_zone *rtpz;
 	int tmp, node, zone;
 
-	for_each_node_state(node, N_POSSIBLE) {
+	for_each_node(node) {
 		tmp = node;
 		if (!node_state(node, N_NORMAL_MEMORY))
 			tmp = -1;
@@ -4896,7 +4896,7 @@ static int mem_cgroup_soft_limit_tree_in
 	return 0;
 
 err_cleanup:
-	for_each_node_state(node, N_POSSIBLE) {
+	for_each_node(node) {
 		if (!soft_limit_tree.rb_tree_per_node[node])
 			break;
 		kfree(soft_limit_tree.rb_tree_per_node[node]);
@@ -4917,7 +4917,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (!memcg)
 		return ERR_PTR(error);
 
-	for_each_node_state(node, N_POSSIBLE)
+	for_each_node(node)
 		if (alloc_mem_cgroup_per_zone_info(memcg, node))
 			goto free_out;
 
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch

