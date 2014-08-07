From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:04:29 -0700
Message-ID: <53e3dbcd.KqTVdDzGS2dy7RPO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:54488 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaHGUEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:30 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so837008oig.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, hughd@google.com, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove explicit OOM parameter in charge path
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: memcontrol: remove explicit OOM parameter in charge path

For the page allocator, __GFP_NORETRY implies that no OOM should be
triggered, whereas memcg has an explicit parameter to disable OOM.

The only callsites that want OOM disabled are THP charges and charge
moving.  THP already uses __GFP_NORETRY and charge moving can use it as
well - one full reclaim cycle should be plenty.  Switch it over, then
remove the OOM parameter.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-explicit-oom-parameter-in-charge-path mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-explicit-oom-parameter-in-charge-path
+++ a/mm/memcontrol.c
@@ -2555,15 +2555,13 @@ static int memcg_cpu_hotplug_callback(st
  * mem_cgroup_try_charge - try charging a memcg
  * @memcg: memcg to charge
  * @nr_pages: number of pages to charge
- * @oom: trigger OOM if reclaim fails
  *
  * Returns 0 if @memcg was charged successfully, -EINTR if the charge
  * was bypassed to root_mem_cgroup, and -ENOMEM if the charge failed.
  */
 static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
 				 gfp_t gfp_mask,
-				 unsigned int nr_pages,
-				 bool oom)
+				 unsigned int nr_pages)
 {
 	unsigned int batch = max(CHARGE_BATCH, nr_pages);
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
@@ -2647,9 +2645,6 @@ retry:
 	if (fatal_signal_pending(current))
 		goto bypass;
 
-	if (!oom)
-		goto nomem;
-
 	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
@@ -2675,15 +2670,14 @@ done:
  */
 static struct mem_cgroup *mem_cgroup_try_charge_mm(struct mm_struct *mm,
 				 gfp_t gfp_mask,
-				 unsigned int nr_pages,
-				 bool oom)
+				 unsigned int nr_pages)
 
 {
 	struct mem_cgroup *memcg;
 	int ret;
 
 	memcg = get_mem_cgroup_from_mm(mm);
-	ret = mem_cgroup_try_charge(memcg, gfp_mask, nr_pages, oom);
+	ret = mem_cgroup_try_charge(memcg, gfp_mask, nr_pages);
 	css_put(&memcg->css);
 	if (ret == -EINTR)
 		memcg = root_mem_cgroup;
@@ -2900,8 +2894,7 @@ static int memcg_charge_kmem(struct mem_
 	if (ret)
 		return ret;
 
-	ret = mem_cgroup_try_charge(memcg, gfp, size >> PAGE_SHIFT,
-				    oom_gfp_allowed(gfp));
+	ret = mem_cgroup_try_charge(memcg, gfp, size >> PAGE_SHIFT);
 	if (ret == -EINTR)  {
 		/*
 		 * mem_cgroup_try_charge() chosed to bypass to root due to
@@ -3650,7 +3643,6 @@ int mem_cgroup_charge_anon(struct page *
 {
 	unsigned int nr_pages = 1;
 	struct mem_cgroup *memcg;
-	bool oom = true;
 
 	if (mem_cgroup_disabled())
 		return 0;
@@ -3662,14 +3654,9 @@ int mem_cgroup_charge_anon(struct page *
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-		/*
-		 * Never OOM-kill a process for a huge page.  The
-		 * fault handler will fall back to regular pages.
-		 */
-		oom = false;
 	}
 
-	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, nr_pages, oom);
+	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, nr_pages);
 	if (!memcg)
 		return -ENOMEM;
 	__mem_cgroup_commit_charge(memcg, page, nr_pages,
@@ -3706,7 +3693,7 @@ static int __mem_cgroup_try_charge_swapi
 		memcg = try_get_mem_cgroup_from_page(page);
 	if (!memcg)
 		memcg = get_mem_cgroup_from_mm(mm);
-	ret = mem_cgroup_try_charge(memcg, mask, 1, true);
+	ret = mem_cgroup_try_charge(memcg, mask, 1);
 	css_put(&memcg->css);
 	if (ret == -EINTR)
 		memcg = root_mem_cgroup;
@@ -3733,7 +3720,7 @@ int mem_cgroup_try_charge_swapin(struct
 	if (!PageSwapCache(page)) {
 		struct mem_cgroup *memcg;
 
-		memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
+		memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1);
 		if (!memcg)
 			return -ENOMEM;
 		*memcgp = memcg;
@@ -3802,7 +3789,7 @@ int mem_cgroup_charge_file(struct page *
 		return 0;
 	}
 
-	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
+	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1);
 	if (!memcg)
 		return -ENOMEM;
 	__mem_cgroup_commit_charge(memcg, page, 1, type, false);
@@ -6440,7 +6427,8 @@ one_by_one:
 			batch_count = PRECHARGE_COUNT_AT_ONCE;
 			cond_resched();
 		}
-		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
+		ret = mem_cgroup_try_charge(memcg,
+					    GFP_KERNEL & ~__GFP_NORETRY, 1);
 		if (ret)
 			/* mem_cgroup_clear_mc() will do uncharge later */
 			return ret;
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch

