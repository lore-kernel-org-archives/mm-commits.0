From: akpm@linux-foundation.org
Subject: [withdrawn]
 slab-recharge-slab-pages-to-the-allocating-memory-cgroup.patch removed from -mm tree
Date: Mon, 10 Nov 2014 14:15:59 -0800
Message-ID: <5461391f.ZrHDOZt6t11Fd5D/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaKJWP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Nov 2014 17:15:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: recharge slab pages to the allocating memory cgroup
has been removed from the -mm tree.  Its filename was
     slab-recharge-slab-pages-to-the-allocating-memory-cgroup.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: slab: recharge slab pages to the allocating memory cgroup

Since we now reuse per cgroup kmem caches, the slab we allocate an object
from may be accounted to a dead memory cgroup.  If we leave such a slab
accounted to a dead cgroup, we risk pinning the cgroup forever, so we
introduce a new function, memcg_kmem_recharge_slab, which is to be called
in the end of kmalloc.  It recharges the new object's slab to the current
cgroup unless it is already charged to it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 ++++++++
 mm/memcontrol.c            |   62 +++++++++++++++++++++++++++++++++++
 mm/slab.c                  |   10 +++++
 mm/slub.c                  |    8 ++++
 4 files changed, 95 insertions(+)

diff -puN include/linux/memcontrol.h~slab-recharge-slab-pages-to-the-allocating-memory-cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~slab-recharge-slab-pages-to-the-allocating-memory-cgroup
+++ a/include/linux/memcontrol.h
@@ -395,6 +395,7 @@ bool __memcg_kmem_newpage_charge(gfp_t g
 void __memcg_kmem_commit_charge(struct page *page,
 				       struct mem_cgroup *memcg, int order);
 void __memcg_kmem_uncharge_pages(struct page *page, int order);
+int __memcg_kmem_recharge_slab(void *obj, gfp_t gfp);
 
 int memcg_cache_id(struct mem_cgroup *memcg);
 
@@ -488,6 +489,15 @@ memcg_kmem_get_cache(struct kmem_cache *
 		return cachep;
 	return __memcg_kmem_get_cache(cachep, gfp);
 }
+
+static __always_inline int memcg_kmem_recharge_slab(void *obj, gfp_t gfp)
+{
+	if (!memcg_kmem_enabled())
+		return 0;
+	if (!memcg_kmem_should_charge(gfp))
+		return 0;
+	return __memcg_kmem_recharge_slab(obj, gfp);
+}
 #else
 #define for_each_memcg_cache_index(_idx)	\
 	for (; NULL; )
@@ -522,6 +532,11 @@ memcg_kmem_get_cache(struct kmem_cache *
 {
 	return cachep;
 }
+
+static inline int memcg_kmem_recharge_slab(void *obj, gfp_t gfp)
+{
+	return 0;
+}
 #endif /* CONFIG_MEMCG_KMEM */
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN mm/memcontrol.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup
+++ a/mm/memcontrol.c
@@ -2828,6 +2828,68 @@ void __memcg_kmem_uncharge_pages(struct
 	memcg_uncharge_kmem(memcg, 1 << order);
 	page->mem_cgroup = NULL;
 }
+
+/*
+ * Since we reuse per cgroup kmem caches, the slab we allocate an object from
+ * may be accounted to a dead memory cgroup. If we leave such a slab accounted
+ * to a dead cgroup, we risk pinning the cgroup forever, so this function is
+ * called in the end of kmalloc to recharge the new object's slab to the
+ * current cgroup unless it is already charged to it.
+ */
+int __memcg_kmem_recharge_slab(void *obj, gfp_t gfp)
+{
+	struct mem_cgroup *page_memcg, *memcg;
+	struct page *page;
+	int nr_pages;
+	int ret = 0;
+
+	if (current->memcg_kmem_skip_account)
+		goto out;
+
+	page = virt_to_head_page(obj);
+	page_memcg = ACCESS_ONCE(page->mem_cgroup);
+
+	rcu_read_lock();
+
+	memcg = mem_cgroup_from_task(rcu_dereference(current->mm->owner));
+	if (!memcg_kmem_is_active(memcg))
+		memcg = NULL;
+	if (likely(memcg == page_memcg))
+		goto out_unlock;
+	if (memcg && !css_tryget(&memcg->css))
+		goto out_unlock;
+
+	rcu_read_unlock();
+
+	nr_pages = 1 << compound_order(page);
+
+	if (memcg && memcg_charge_kmem(memcg, gfp, nr_pages)) {
+		ret = -ENOMEM;
+		goto out_put_memcg;
+	}
+
+	/*
+	 * We use cmpxchg to synchronize against concurrent threads allocating
+	 * from the same slab. If it fails, it means that some other thread
+	 * recharged the slab before us, and we are done.
+	 */
+	if (cmpxchg(&page->mem_cgroup, page_memcg, memcg) == page_memcg) {
+		if (page_memcg)
+			memcg_uncharge_kmem(page_memcg, nr_pages);
+	} else {
+		if (memcg)
+			memcg_uncharge_kmem(memcg, nr_pages);
+	}
+
+out_put_memcg:
+	if (memcg)
+		css_put(&memcg->css);
+	goto out;
+out_unlock:
+	rcu_read_unlock();
+out:
+	return ret;
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff -puN mm/slab.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup mm/slab.c
--- a/mm/slab.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup
+++ a/mm/slab.c
@@ -3133,6 +3133,8 @@ done:
 	return obj;
 }
 
+static __always_inline void slab_free(struct kmem_cache *cachep, void *objp);
+
 static __always_inline void *
 slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 		   unsigned long caller)
@@ -3185,6 +3187,10 @@ slab_alloc_node(struct kmem_cache *cache
 		kmemcheck_slab_alloc(cachep, flags, ptr, cachep->object_size);
 		if (unlikely(flags & __GFP_ZERO))
 			memset(ptr, 0, cachep->object_size);
+		if (unlikely(memcg_kmem_recharge_slab(ptr, flags))) {
+			slab_free(cachep, ptr);
+			ptr = NULL;
+		}
 	}
 
 	return ptr;
@@ -3250,6 +3256,10 @@ slab_alloc(struct kmem_cache *cachep, gf
 		kmemcheck_slab_alloc(cachep, flags, objp, cachep->object_size);
 		if (unlikely(flags & __GFP_ZERO))
 			memset(objp, 0, cachep->object_size);
+		if (unlikely(memcg_kmem_recharge_slab(objp, flags))) {
+			slab_free(cachep, objp);
+			objp = NULL;
+		}
 	}
 
 	return objp;
diff -puN mm/slub.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup mm/slub.c
--- a/mm/slub.c~slab-recharge-slab-pages-to-the-allocating-memory-cgroup
+++ a/mm/slub.c
@@ -2360,6 +2360,9 @@ new_slab:
 	return freelist;
 }
 
+static __always_inline void slab_free(struct kmem_cache *s,
+			struct page *page, void *x, unsigned long addr);
+
 /*
  * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_alloc)
  * have the fastpath folded into their functions. So no function call
@@ -2445,6 +2448,11 @@ redo:
 
 	slab_post_alloc_hook(s, gfpflags, object);
 
+	if (object && unlikely(memcg_kmem_recharge_slab(object, gfpflags))) {
+		slab_free(s, virt_to_head_page(object), object, _RET_IP_);
+		object = NULL;
+	}
+
 	return object;
 }
 
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
slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup-fix-2-checkpatch-fixes.patch
memcg-zap-kmem_account_flags.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

