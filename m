From: akpm@linux-foundation.org
Subject: [folded] memcg-add-mem_cgroup_from_css-helper-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:35:37 -0700
Message-ID: <20120731233537.859FCA028B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:54752 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab2GaXfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:35:38 -0400
Received: by obbwc20 with SMTP id wc20so4820389obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:35:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, liwanp@linux.vnet.ibm.com, mhocko@suse.cz, shangw@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-add-mem_cgroup_from_css-helper-fix
has been removed from the -mm tree.  Its filename was
     memcg-add-mem_cgroup_from_css-helper-fix.patch

This patch was dropped because it was folded into memcg-add-mem_cgroup_from_css-helper.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-add-mem_cgroup_from_css-helper-fix

that patch was very broken

Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-mem_cgroup_from_css-helper-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_from_css-helper-fix
+++ a/mm/memcontrol.c
@@ -868,9 +868,8 @@ static void memcg_check_events(struct me
 
 struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
 {
-	return mem_cgroup_from_css(cgroup_subsys_state(cont,
-				mem_cgroup_subsys_id), struct mem_cgroup,
-				css);
+	return mem_cgroup_from_css(
+		cgroup_subsys_state(cont, mem_cgroup_subsys_id));
 }
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
@@ -883,8 +882,7 @@ struct mem_cgroup *mem_cgroup_from_task(
 	if (unlikely(!p))
 		return NULL;
 
-	return mem_cgroup_from_css(task_subsys_state(p, mem_cgroup_subsys_id),
-				struct mem_cgroup, css);
+	return mem_cgroup_from_css(task_subsys_state(p, mem_cgroup_subsys_id));
 }
 
 struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
@@ -970,8 +968,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
 		if (css) {
 			if (css == &root->css || css_tryget(css))
-				memcg = mem_cgroup_from_css(css,
-						     struct mem_cgroup, css);
+				memcg = mem_cgroup_from_css(css);
 		} else
 			id = 0;
 		rcu_read_unlock();
@@ -2500,7 +2497,7 @@ static struct mem_cgroup *mem_cgroup_loo
 	css = css_lookup(&mem_cgroup_subsys, id);
 	if (!css)
 		return NULL;
-	return mem_cgroup_from_css(css, struct mem_cgroup, css);
+	return mem_cgroup_from_css(css);
 }
 
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-media-video-v4l2-ioctlc-fix-build.patch
mm-make-vb_alloc-more-foolproof.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-make-mem_cgroup_force_empty_list-return-bool.patch
mm-fadvise-dont-return-einval-when-filesystem-cannot-implement-fadvise.patch
memcg-rename-config-variables.patch
mm-have-order-0-compaction-start-off-where-it-left.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-add-mem_cgroup_from_css-helper.patch
mm-hugetlbfs-close-race-during-teardown-of-hugetlbfs-shared-page-tables-fix.patch

