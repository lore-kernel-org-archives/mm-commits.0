From: akpm@linux-foundation.org
Subject: [withdrawn]
 slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch removed
 from -mm tree
Date: Tue, 15 Jul 2014 12:17:19 -0700
Message-ID: <53c57e3f.YHLPwxDZBHsxAeNq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57949 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaGOTZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 15:25:23 -0400
Received: by mail-qc0-f202.google.com with SMTP id i17so475369qcy.1
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 12:25:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: make dead memcg caches discard free slabs immediately
has been removed from the -mm tree.  Its filename was
     slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slub: make dead memcg caches discard free slabs immediately

Since a dead memcg cache is destroyed only after the last slab allocated
to it is freed, we must disable caching of empty slabs for such caches,
otherwise they will be hanging around forever.

This patch makes SLUB discard dead memcg caches' slabs as soon as they
become empty.  To achieve that, it disables per cpu partial lists for dead
caches (see put_cpu_partial) and forbids keeping empty slabs on per node
partial lists by setting cache's min_partial to 0 on kmem_cache_shrink,
which is always called on memcg offline (see memcg_unregister_all_caches).

Thanks to Joonsoo Kim.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/slub.c~slub-make-dead-memcg-caches-discard-free-slabs-immediately mm/slub.c
--- a/mm/slub.c~slub-make-dead-memcg-caches-discard-free-slabs-immediately
+++ a/mm/slub.c
@@ -2034,6 +2034,14 @@ static void put_cpu_partial(struct kmem_
 
 	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
 								!= oldpage);
+
+	if (memcg_cache_dead(s)) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
+		local_irq_restore(flags);
+	}
 #endif
 }
 
@@ -3372,6 +3380,9 @@ int __kmem_cache_shrink(struct kmem_cach
 		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
 	unsigned long flags;
 
+	if (memcg_cache_dead(s))
+		s->min_partial = 0;
+
 	if (!slabs_by_inuse) {
 		/*
 		 * Do not fail shrinking empty slabs if allocation of the
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
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

