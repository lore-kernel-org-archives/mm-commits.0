From: akpm@linux-foundation.org
Subject: + mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
 added to -mm tree
Date: Wed, 18 Jun 2014 16:54:47 -0700
Message-ID: <53a226c7.CR1TWDeJw/svXy65%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521AbaFRXys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, tj@kernel.org, mhocko@suse.cz, hughd@google.com, hannes@cmpxchg.org


The patch titled
     Subject: mm: memcontrol: reclaim at least once for __GFP_NORETRY
has been added to the -mm tree.  Its filename is
     mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch

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
Subject: mm: memcontrol: reclaim at least once for __GFP_NORETRY

Currently, __GFP_NORETRY tries charging once and gives up before even
trying to reclaim.  Bring the behavior on par with the page allocator and
reclaim at least once before giving up.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry
+++ a/mm/memcontrol.c
@@ -2613,13 +2613,13 @@ retry:
 	if (!(gfp_mask & __GFP_WAIT))
 		goto nomem;
 
-	if (gfp_mask & __GFP_NORETRY)
-		goto nomem;
-
 	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= batch)
 		goto retry;
+
+	if (gfp_mask & __GFP_NORETRY)
+		goto nomem;
 	/*
 	 * Even though the limit is exceeded at this point, reclaim
 	 * may have been able to free some pages.  Retry the charge
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

