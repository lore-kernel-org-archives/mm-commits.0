From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page.patch added to -mm
 tree
Date: Tue, 07 Jul 2020 12:20:24 -0700
Message-ID: <20200707192024.o4StYvmH0%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbgGGTU0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:20:26 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, shakeelb@google.com, vbabka@suse.cz


The patch titled
     Subject: mm: slab: rename (un)charge_slab_page() to (un)account_slab_page()
has been added to the -mm tree.  Its filename is
     mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: slab: rename (un)charge_slab_page() to (un)account_slab_page()

charge_slab_page() and uncharge_slab_page() are not related anymore to
memcg charging and uncharging.  In order to make their names less
confusing, let's rename them to account_slab_page() and
unaccount_slab_page() respectively.

Link: http://lkml.kernel.org/r/20200707173612.124425-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 mm/slab.h |    8 ++++----
 mm/slub.c |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/mm/slab.c~mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page
+++ a/mm/slab.c
@@ -1379,7 +1379,7 @@ static struct page *kmem_getpages(struct
 		return NULL;
 	}
 
-	charge_slab_page(page, cachep->gfporder, cachep);
+	account_slab_page(page, cachep->gfporder, cachep);
 	__SetPageSlab(page);
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
 	if (sk_memalloc_socks() && page_is_pfmemalloc(page))
@@ -1403,7 +1403,7 @@ static void kmem_freepages(struct kmem_c
 
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += 1 << order;
-	uncharge_slab_page(page, order, cachep);
+	unaccount_slab_page(page, order, cachep);
 	__free_pages(page, order);
 }
 
--- a/mm/slab.h~mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page
+++ a/mm/slab.h
@@ -440,15 +440,15 @@ static inline struct kmem_cache *virt_to
 	return page->slab_cache;
 }
 
-static __always_inline void charge_slab_page(struct page *page, int order,
-					     struct kmem_cache *s)
+static __always_inline void account_slab_page(struct page *page, int order,
+					      struct kmem_cache *s)
 {
 	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
 			    PAGE_SIZE << order);
 }
 
-static __always_inline void uncharge_slab_page(struct page *page, int order,
-					       struct kmem_cache *s)
+static __always_inline void unaccount_slab_page(struct page *page, int order,
+						struct kmem_cache *s)
 {
 	if (memcg_kmem_enabled())
 		memcg_free_page_obj_cgroups(page);
--- a/mm/slub.c~mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page
+++ a/mm/slub.c
@@ -1621,7 +1621,7 @@ static inline struct page *alloc_slab_pa
 		page = __alloc_pages_node(node, flags, order);
 
 	if (page)
-		charge_slab_page(page, order, s);
+		account_slab_page(page, order, s);
 
 	return page;
 }
@@ -1844,7 +1844,7 @@ static void __free_slab(struct kmem_cach
 	page->mapping = NULL;
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += pages;
-	uncharge_slab_page(page, order, s);
+	unaccount_slab_page(page, order, s);
 	__free_pages(page, order);
 }
 
_

Patches currently in -mm which might be from guro@fb.com are

mm-kmem-make-memcg_kmem_enabled-irreversible.patch
mm-memcg-factor-out-memcg-and-lruvec-level-changes-out-of-__mod_lruvec_state.patch
mm-memcg-prepare-for-byte-sized-vmstat-items.patch
mm-memcg-convert-vmstat-slab-counters-to-bytes.patch
mm-slub-implement-slub-version-of-obj_to_index.patch
mm-memcg-slab-obj_cgroup-api.patch
mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch
mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects.patch
mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch
mm-memcg-slab-deprecate-memorykmemslabinfo.patch
mm-memcg-slab-move-memcg_kmem_bypass-to-memcontrolh.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-accounted-allocations.patch
mm-memcg-slab-simplify-memcg-cache-creation.patch
mm-memcg-slab-remove-memcg_kmem_get_cache.patch
mm-memcg-slab-deprecate-slab_root_caches.patch
mm-memcg-slab-remove-redundant-check-in-memcg_accumulate_slabinfo.patch
mm-memcg-slab-use-a-single-set-of-kmem_caches-for-all-allocations.patch
kselftests-cgroup-add-kernel-memory-accounting-tests.patch
tools-cgroup-add-memcg_slabinfopy-tool.patch
percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-memcg-slab-remove-unused-argument-by-charge_slab_page.patch
mm-slab-rename-uncharge_slab_page-to-unaccount_slab_page.patch
mm-kmem-switch-to-static_branch_likely-in-memcg_kmem_enabled.patch
