From: akpm@linux-foundation.org
Subject: +
 slab-change-int-to-size_t-for-representing-allocation-size.patch added to
 -mm tree
Date: Wed, 02 Jul 2014 13:49:22 -0700
Message-ID: <53b47052.+UHoyLle5w6B1Qvf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:60763 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaGBUtX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2014 16:49:23 -0400
Received: by mail-oa0-f74.google.com with SMTP id i7so2705527oag.5
        for <mm-commits@vger.kernel.org>; Wed, 02 Jul 2014 13:49:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: change int to size_t for representing allocation size
has been added to the -mm tree.  Its filename is
     slab-change-int-to-size_t-for-representing-allocation-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-change-int-to-size_t-for-representing-allocation-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-change-int-to-size_t-for-representing-allocation-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slab: change int to size_t for representing allocation size

It is better to represent allocation size in size_t rather than int.
So change it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~slab-change-int-to-size_t-for-representing-allocation-size mm/slab.c
--- a/mm/slab.c~slab-change-int-to-size_t-for-representing-allocation-size
+++ a/mm/slab.c
@@ -681,7 +681,7 @@ static void init_arraycache(struct array
 static struct array_cache *alloc_arraycache(int node, int entries,
 					    int batchcount, gfp_t gfp)
 {
-	int memsize = sizeof(void *) * entries + sizeof(struct array_cache);
+	size_t memsize = sizeof(void *) * entries + sizeof(struct array_cache);
 	struct array_cache *ac = NULL;
 
 	ac = kmalloc_node(memsize, gfp, node);
@@ -868,7 +868,7 @@ static void *alternate_node_alloc(struct
 static struct alien_cache *__alloc_alien_cache(int node, int entries,
 						int batch, gfp_t gfp)
 {
-	int memsize = sizeof(void *) * entries + sizeof(struct alien_cache);
+	size_t memsize = sizeof(void *) * entries + sizeof(struct alien_cache);
 	struct alien_cache *alc = NULL;
 
 	alc = kmalloc_node(memsize, gfp, node);
@@ -880,7 +880,7 @@ static struct alien_cache *__alloc_alien
 static struct alien_cache **alloc_alien_cache(int node, int limit, gfp_t gfp)
 {
 	struct alien_cache **alc_ptr;
-	int memsize = sizeof(void *) * nr_node_ids;
+	size_t memsize = sizeof(void *) * nr_node_ids;
 	int i;
 
 	if (limit > 1)
@@ -1037,7 +1037,7 @@ static int init_cache_node_node(int node
 {
 	struct kmem_cache *cachep;
 	struct kmem_cache_node *n;
-	const int memsize = sizeof(struct kmem_cache_node);
+	const size_t memsize = sizeof(struct kmem_cache_node);
 
 	list_for_each_entry(cachep, &slab_caches, list) {
 		/*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

slub-fix-off-by-one-in-number-of-slab-tests.patch
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

