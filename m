From: akpm@linux-foundation.org
Subject: + memcg-introduce-memcg_kmem_should_charge-helper.patch added to
 -mm tree
Date: Tue, 04 Nov 2014 15:22:38 -0800
Message-ID: <54595fbe.Eyq10oAe8UyGkPXE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaKDXWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 18:22:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: introduce memcg_kmem_should_charge helper
has been added to the -mm tree.  Its filename is
     memcg-introduce-memcg_kmem_should_charge-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-introduce-memcg_kmem_should_charge-helper.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/memcg-introduce-memcg_kmem_should_charge-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: introduce memcg_kmem_should_charge helper

We use the same set of checks in both memcg_kmem_newpage_charge and
memcg_kmem_get_cache, and I need it in yet another function, which will be
introduced by one of the following patches.  So let's introduce a helper
function for it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   43 +++++++++++++++++------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-introduce-memcg_kmem_should_charge-helper include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-introduce-memcg_kmem_should_charge-helper
+++ a/include/linux/memcontrol.h
@@ -403,6 +403,26 @@ void memcg_update_array_size(int num_gro
 struct kmem_cache *
 __memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp);
 
+static __always_inline bool memcg_kmem_should_charge(gfp_t gfp)
+{
+	/*
+	 * __GFP_NOFAIL allocations will move on even if charging is not
+	 * possible. Therefore we don't even try, and have this allocation
+	 * unaccounted. We could in theory charge it forcibly, but we hope
+	 * those allocations are rare, and won't be worth the trouble.
+	 */
+	if (gfp & __GFP_NOFAIL)
+		return false;
+	if (in_interrupt())
+		return false;
+	if (!current->mm || (current->flags & PF_KTHREAD))
+		return false;
+	/* If the test is dying, just let it go. */
+	if (unlikely(fatal_signal_pending(current)))
+		return false;
+	return true;
+}
+
 /**
  * memcg_kmem_newpage_charge: verify if a new kmem allocation is allowed.
  * @gfp: the gfp allocation flags.
@@ -420,22 +440,8 @@ memcg_kmem_newpage_charge(gfp_t gfp, str
 {
 	if (!memcg_kmem_enabled())
 		return true;
-
-	/*
-	 * __GFP_NOFAIL allocations will move on even if charging is not
-	 * possible. Therefore we don't even try, and have this allocation
-	 * unaccounted. We could in theory charge it forcibly, but we hope
-	 * those allocations are rare, and won't be worth the trouble.
-	 */
-	if (gfp & __GFP_NOFAIL)
+	if (!memcg_kmem_should_charge(gfp))
 		return true;
-	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
-		return true;
-
-	/* If the test is dying, just let it go. */
-	if (unlikely(fatal_signal_pending(current)))
-		return true;
-
 	return __memcg_kmem_newpage_charge(gfp, memcg, order);
 }
 
@@ -478,13 +484,8 @@ memcg_kmem_get_cache(struct kmem_cache *
 {
 	if (!memcg_kmem_enabled())
 		return cachep;
-	if (gfp & __GFP_NOFAIL)
-		return cachep;
-	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
+	if (!memcg_kmem_should_charge(gfp))
 		return cachep;
-	if (unlikely(fatal_signal_pending(current)))
-		return cachep;
-
 	return __memcg_kmem_get_cache(cachep, gfp);
 }
 #else
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
memcg-do-not-destroy-kmem-caches-on-css-offline.patch
slab-charge-slab-pages-to-the-current-memory-cgroup.patch
memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg.patch
memcg-zap-memcg_unregister_cache.patch
memcg-free-kmem-cache-id-on-css-offline.patch
memcg-introduce-memcg_kmem_should_charge-helper.patch
slab-introduce-slab_free-helper.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

