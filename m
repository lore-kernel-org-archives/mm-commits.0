From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch added to
 -mm tree
Date: Wed, 18 Jun 2014 16:54:50 -0700
Message-ID: <53a226ca.hQPAQaXQ9ckOOQdp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaFRXyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, tj@kernel.org, hughd@google.com, hannes@cmpxchg.org, mhocko@suse.cz


The patch titled
     Subject: mm: memcontrol: remove explicit OOM parameter in charge path
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3701,7 +3694,6 @@ int mem_cgroup_charge_anon(struct page *
 {
 	unsigned int nr_pages = 1;
 	struct mem_cgroup *memcg;
-	bool oom = true;
 
 	if (mem_cgroup_disabled())
 		return 0;
@@ -3713,14 +3705,9 @@ int mem_cgroup_charge_anon(struct page *
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
@@ -3757,7 +3744,7 @@ static int __mem_cgroup_try_charge_swapi
 		memcg = try_get_mem_cgroup_from_page(page);
 	if (!memcg)
 		memcg = get_mem_cgroup_from_mm(mm);
-	ret = mem_cgroup_try_charge(memcg, mask, 1, true);
+	ret = mem_cgroup_try_charge(memcg, mask, 1);
 	css_put(&memcg->css);
 	if (ret == -EINTR)
 		memcg = root_mem_cgroup;
@@ -3784,7 +3771,7 @@ int mem_cgroup_try_charge_swapin(struct
 	if (!PageSwapCache(page)) {
 		struct mem_cgroup *memcg;
 
-		memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
+		memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1);
 		if (!memcg)
 			return -ENOMEM;
 		*memcgp = memcg;
@@ -3853,7 +3840,7 @@ int mem_cgroup_charge_file(struct page *
 		return 0;
 	}
 
-	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
+	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1);
 	if (!memcg)
 		return -ENOMEM;
 	__mem_cgroup_commit_charge(memcg, page, 1, type, false);
@@ -6465,7 +6452,8 @@ one_by_one:
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

watchdog-remove-preemption-restrictions-when-restarting-lockup-detector.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch

