From: akpm@linux-foundation.org
Subject: [merged] memcg-add-mem_cgroup_from_css-helper.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:40 -0700
Message-ID: <20120801201841.36A165C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45834 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2HAUSn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:43 -0400
Received: by mail-ee0-f74.google.com with SMTP id d4so347915eek.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwanp@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, shangw@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add mem_cgroup_from_css() helper
has been removed from the -mm tree.  Its filename was
     memcg-add-mem_cgroup_from_css-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: memcg: add mem_cgroup_from_css() helper

Add a mem_cgroup_from_css() helper to replace open-coded invokations of
container_of().  To clarify the code and to add a little more type safety.

[akpm@linux-foundation.org: fix extensive breakage]
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-mem_cgroup_from_css-helper mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_from_css-helper
+++ a/mm/memcontrol.c
@@ -405,6 +405,12 @@ enum charge_type {
 static void mem_cgroup_get(struct mem_cgroup *memcg);
 static void mem_cgroup_put(struct mem_cgroup *memcg);
 
+static inline
+struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *s)
+{
+	return container_of(s, struct mem_cgroup, css);
+}
+
 /* Writing them here to avoid exposing memcg's inner layout */
 #ifdef CONFIG_MEMCG_KMEM
 #include <net/sock.h>
@@ -862,9 +868,8 @@ static void memcg_check_events(struct me
 
 struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
 {
-	return container_of(cgroup_subsys_state(cont,
-				mem_cgroup_subsys_id), struct mem_cgroup,
-				css);
+	return mem_cgroup_from_css(
+		cgroup_subsys_state(cont, mem_cgroup_subsys_id));
 }
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
@@ -877,8 +882,7 @@ struct mem_cgroup *mem_cgroup_from_task(
 	if (unlikely(!p))
 		return NULL;
 
-	return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
-				struct mem_cgroup, css);
+	return mem_cgroup_from_css(task_subsys_state(p, mem_cgroup_subsys_id));
 }
 
 struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
@@ -964,8 +968,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
 		if (css) {
 			if (css == &root->css || css_tryget(css))
-				memcg = container_of(css,
-						     struct mem_cgroup, css);
+				memcg = mem_cgroup_from_css(css);
 		} else
 			id = 0;
 		rcu_read_unlock();
@@ -2494,7 +2497,7 @@ static struct mem_cgroup *mem_cgroup_loo
 	css = css_lookup(&mem_cgroup_subsys, id);
 	if (!css)
 		return NULL;
-	return container_of(css, struct mem_cgroup, css);
+	return mem_cgroup_from_css(css);
 }
 
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch

