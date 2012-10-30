From: akpm@linux-foundation.org
Subject: [wrecked] memcg-root_cgroup-cannot-reach-mem_cgroup_move_parent.patch removed from -mm tree
Date: Tue, 30 Oct 2012 13:47:15 -0700
Message-ID: <20121030204715.D053A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45506 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab2J3UrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 16:47:18 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so79494vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 13:47:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, bsingharora@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: root_cgroup cannot reach mem_cgroup_move_parent()
has been removed from the -mm tree.  Its filename was
     memcg-root_cgroup-cannot-reach-mem_cgroup_move_parent.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: root_cgroup cannot reach mem_cgroup_move_parent()

The root cgroup cannot be destroyed so we never hit it down the
mem_cgroup_pre_destroy() path and mem_cgroup_force_empty_write() shouldn't
even try to do anything if called for the root.

This means that mem_cgroup_move_parent() doesn't have to bother with the
root cgroup and it can assume it can always move charges upwards.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-root_cgroup-cannot-reach-mem_cgroup_move_parent mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-root_cgroup-cannot-reach-mem_cgroup_move_parent
+++ a/mm/memcontrol.c
@@ -2709,9 +2709,7 @@ static int mem_cgroup_move_parent(struct
 	unsigned long uninitialized_var(flags);
 	int ret;
 
-	/* Is ROOT ? */
-	if (mem_cgroup_is_root(child))
-		return -EINVAL;
+	VM_BUG_ON(mem_cgroup_is_root(child));
 
 	ret = -EBUSY;
 	if (!get_page_unless_zero(page))
@@ -3817,6 +3815,8 @@ static int mem_cgroup_force_empty_write(
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	int ret;
 
+	if (mem_cgroup_is_root(memcg))
+		return -EINVAL;
 	css_get(&memcg->css);
 	ret = mem_cgroup_force_empty(memcg);
 	css_put(&memcg->css);
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
thp-clean-up-__collapse_huge_page_isolate.patch
thp-clean-up-__collapse_huge_page_isolate-v2.patch
mm-introduce-mm_find_pmd.patch
mm-introduce-mm_find_pmd-fix.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memcg-simplify-mem_cgroup_force_empty_list-error-handling.patch
cgroups-forbid-pre_destroy-callback-to-fail.patch
memcg-make-mem_cgroup_reparent_charges-non-failing.patch
hugetlb-do-not-fail-in-hugetlb_cgroup_pre_destroy.patch
drop_caches-add-some-documentation-and-info-messsge.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
mm-memblock-reduce-overhead-in-binary-search.patch

