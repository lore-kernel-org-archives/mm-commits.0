From: akpm@linux-foundation.org
Subject: +
 slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch added to -mm tree
Date: Tue, 24 Jun 2014 14:53:05 -0700
Message-ID: <53a9f341.EHgyyGpdW7YJ/8bx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFXVxG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: kmem_cache_shrink: check if partial list is empty under list_lock
has been added to the -mm tree.  Its filename is
     slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch

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

origin.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
slub-fix-off-by-one-in-number-of-slab-tests.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slub-kmem_cache_shrink-check-if-partial-list-is-empty-under-list_lock.patch
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
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

