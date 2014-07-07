From: akpm@linux-foundation.org
Subject: [merged] slub-fix-off-by-one-in-number-of-slab-tests.patch
 removed from -mm tree
Date: Mon, 07 Jul 2014 11:11:14 -0700
Message-ID: <53bae2c2.Wgf08xsdlK//tvMO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:62192 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaGGSLP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:15 -0400
Received: by mail-oa0-f74.google.com with SMTP id i7so979545oag.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fix off by one in number of slab tests
has been removed from the -mm tree.  Its filename was
     slub-fix-off-by-one-in-number-of-slab-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slub: fix off by one in number of slab tests

min_partial means minimum number of slab cached in node partial list.  So,
if nr_partial is less than it, we keep newly empty slab on node partial
list rather than freeing it.  But if nr_partial is equal or greater than
it, it means that we have enough partial slabs so should free newly empty
slab.  Current implementation missed the equal case so if we set
min_partial is 0, then, at least one slab could be cached.  This is
critical problem to kmemcg destroying logic because it doesn't works
properly if some slabs is cached.  This patch fixes this problem.

Fixes 91cb69620284 ("slub: make dead memcg caches discard free slabs
immediately").

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-fix-off-by-one-in-number-of-slab-tests mm/slub.c
--- a/mm/slub.c~slub-fix-off-by-one-in-number-of-slab-tests
+++ a/mm/slub.c
@@ -1881,7 +1881,7 @@ redo:
 
 	new.frozen = 0;
 
-	if (!new.inuse && n->nr_partial > s->min_partial)
+	if (!new.inuse && n->nr_partial >= s->min_partial)
 		m = M_FREE;
 	else if (new.freelist) {
 		m = M_PARTIAL;
@@ -1992,7 +1992,7 @@ static void unfreeze_partials(struct kme
 				new.freelist, new.counters,
 				"unfreezing slab"));
 
-		if (unlikely(!new.inuse && n->nr_partial > s->min_partial)) {
+		if (unlikely(!new.inuse && n->nr_partial >= s->min_partial)) {
 			page->next = discard_page;
 			discard_page = page;
 		} else {
@@ -2620,7 +2620,7 @@ static void __slab_free(struct kmem_cach
                 return;
         }
 
-	if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
+	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial))
 		goto slab_empty;
 
 	/*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
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
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-defer-slab_destroy-in-free_block-v4.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
cma-generalize-cma-reserved-area-management-functionality-fix.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

