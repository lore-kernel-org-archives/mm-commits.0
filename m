From: akpm@linux-foundation.org
Subject: [withdrawn]
 slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch removed from -mm tree
Date: Tue, 15 Jul 2014 12:17:13 -0700
Message-ID: <53c57e39.UFTR+Bn1s9fuSDOZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:60739 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbaGOTRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 15:17:15 -0400
Received: by mail-qc0-f201.google.com with SMTP id m20so689242qcx.4
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 12:17:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: kmem_cache_shrink: check if partial list is empty under list_lock
has been removed from the -mm tree.  Its filename was
     slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: kmem_cache_shrink: check if partial list is empty under list_lock

SLUB's implementation of kmem_cache_shrink skips nodes that have
nr_partial=0, because they surely don't have any empty slabs to free. 
This check is done w/o holding any locks, therefore it can race with
concurrent kfree adding an empty slab to a partial list.  As a result, a
just shrinked cache can have empty slabs.

This is unacceptable for kmemcg, which needs to be sure that there will be
no empty slabs on dead memcg caches after kmem_cache_shrink was called,
because otherwise we may leak a dead cache.

Let's fix this race by checking if node partial list is empty under
node->list_lock.  Since the nr_partial!=0 branch of kmem_cache_shrink does
nothing if the list is empty, we can simply remove the nr_partial=0 check.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/slub.c~slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock mm/slub.c
--- a/mm/slub.c~slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock
+++ a/mm/slub.c
@@ -3395,9 +3395,6 @@ int __kmem_cache_shrink(struct kmem_cach
 
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
-		if (!n->nr_partial)
-			continue;
-
 		for (i = 0; i < objects; i++)
 			INIT_LIST_HEAD(slabs_by_inuse + i);
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
slab-set-free_limit-for-dead-caches-to-0.patch
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
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
fork-make-mm_init_owner-static.patch
linux-next.patch

