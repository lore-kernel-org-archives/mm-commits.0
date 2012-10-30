From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-do-not-fail-in-hugetlb_cgroup_pre_destroy.patch removed from -mm tree
Date: Tue, 30 Oct 2012 13:48:05 -0700
Message-ID: <20121030204806.2B1B85C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:43149 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab2J3UsK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 16:48:10 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so48113lah.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 13:48:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, bsingharora@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: do not fail in hugetlb_cgroup_pre_destroy()
has been removed from the -mm tree.  Its filename was
     hugetlb-do-not-fail-in-hugetlb_cgroup_pre_destroy.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: hugetlb: do not fail in hugetlb_cgroup_pre_destroy()

Now that pre_destroy() callbacks are called from the context where neither
any task can attach the group nor any children group can be added there is
no other way to fail from hugetlb_pre_destroy().

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN mm/hugetlb_cgroup.c~hugetlb-do-not-fail-in-hugetlb_cgroup_pre_destroy mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~hugetlb-do-not-fail-in-hugetlb_cgroup_pre_destroy
+++ a/mm/hugetlb_cgroup.c
@@ -159,14 +159,9 @@ static int hugetlb_cgroup_pre_destroy(st
 {
 	struct hstate *h;
 	struct page *page;
-	int ret = 0, idx = 0;
+	int idx = 0;
 
 	do {
-		if (cgroup_task_count(cgroup) ||
-		    !list_empty(&cgroup->children)) {
-			ret = -EBUSY;
-			goto out;
-		}
 		for_each_hstate(h) {
 			spin_lock(&hugetlb_lock);
 			list_for_each_entry(page, &h->hugepage_activelist, lru)
@@ -177,8 +172,8 @@ static int hugetlb_cgroup_pre_destroy(st
 		}
 		cond_resched();
 	} while (hugetlb_cgroup_have_usage(cgroup));
-out:
-	return ret;
+
+	return 0;
 }
 
 int hugetlb_cgroup_charge_cgroup(int idx, unsigned long nr_pages,
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
drop_caches-add-some-documentation-and-info-messsge.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
mm-memblock-reduce-overhead-in-binary-search.patch

