From: akpm@linux-foundation.org
Subject: + memcg-cleanup-for_each_node_state.patch added to -mm tree
Date: Tue, 20 Dec 2011 15:01:34 -0800
Message-ID: <20111220230135.B4E725C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:40327 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1LTXBi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2011 18:01:38 -0500
Received: by eekc1 with SMTP id c1so221453eek.1
        for <mm-commits@vger.kernel.org>; Tue, 20 Dec 2011 15:01:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: cleanup for_each_node_state()
has been added to the -mm tree.  Its filename is
     memcg-cleanup-for_each_node_state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: memcg: cleanup for_each_node_state()

We already have for_each_node(node) define in nodemask.h, better to use it.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-cleanup-for_each_node_state mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cleanup-for_each_node_state
+++ a/mm/memcontrol.c
@@ -570,7 +570,7 @@ static void mem_cgroup_remove_from_trees
 	struct mem_cgroup_per_zone *mz;
 	struct mem_cgroup_tree_per_zone *mctz;
 
-	for_each_node_state(node, N_POSSIBLE) {
+	for_each_node(node) {
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 			mz = mem_cgroup_zoneinfo(memcg, node, zone);
 			mctz = soft_limit_tree_node_zone(node, zone);
@@ -4857,7 +4857,7 @@ static void __mem_cgroup_free(struct mem
 	mem_cgroup_remove_from_trees(memcg);
 	free_css_id(&mem_cgroup_subsys, &memcg->css);
 
-	for_each_node_state(node, N_POSSIBLE)
+	for_each_node(node)
 		free_mem_cgroup_per_zone_info(memcg, node);
 
 	free_percpu(memcg->stat);
@@ -4916,7 +4916,7 @@ static int mem_cgroup_soft_limit_tree_in
 	struct mem_cgroup_tree_per_zone *rtpz;
 	int tmp, node, zone;
 
-	for_each_node_state(node, N_POSSIBLE) {
+	for_each_node(node) {
 		tmp = node;
 		if (!node_state(node, N_NORMAL_MEMORY))
 			tmp = -1;
@@ -4935,7 +4935,7 @@ static int mem_cgroup_soft_limit_tree_in
 	return 0;
 
 err_cleanup:
-	for_each_node_state(node, N_POSSIBLE) {
+	for_each_node(node) {
 		if (!soft_limit_tree.rb_tree_per_node[node])
 			break;
 		kfree(soft_limit_tree.rb_tree_per_node[node]);
@@ -4956,7 +4956,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (!memcg)
 		return ERR_PTR(error);
 
-	for_each_node_state(node, N_POSSIBLE)
+	for_each_node(node)
 		if (alloc_mem_cgroup_per_zone_info(memcg, node))
 			goto free_out;
 
_
Subject: Subject: memcg: cleanup for_each_node_state()

Patches currently in -mm which might be from lliubbo@gmail.com are

linux-next.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch

