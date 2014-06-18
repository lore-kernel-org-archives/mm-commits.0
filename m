From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch added to -mm tree
Date: Wed, 18 Jun 2014 16:54:49 -0700
Message-ID: <53a226c9.5wM9i4CiYvFkA424%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaFRXyu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, tj@kernel.org, mhocko@suse.cz, hughd@google.com, hannes@cmpxchg.org


The patch titled
     Subject: mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL charges
has been added to the -mm tree.  Its filename is
     mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL charges

There is no reason why oom-disabled and __GFP_NOFAIL charges should try to
reclaim only once when every other charge tries several times before
giving up.  Make them all retry the same number of times.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges
+++ a/mm/memcontrol.c
@@ -2566,7 +2566,7 @@ static int mem_cgroup_try_charge(struct
 				 bool oom)
 {
 	unsigned int batch = max(CHARGE_BATCH, nr_pages);
-	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct res_counter *fail_res;
 	unsigned long nr_reclaimed;
@@ -2638,6 +2638,9 @@ retry:
 	if (mem_cgroup_wait_acct_move(mem_over_limit))
 		goto retry;
 
+	if (nr_retries--)
+		goto retry;
+
 	if (gfp_mask & __GFP_NOFAIL)
 		goto bypass;
 
@@ -2647,9 +2650,6 @@ retry:
 	if (!oom)
 		goto nomem;
 
-	if (nr_oom_retries--)
-		goto retry;
-
 	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
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
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

