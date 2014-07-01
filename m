From: akpm@linux-foundation.org
Subject: + slab-remove-bad_alien_magic.patch added to -mm tree
Date: Tue, 01 Jul 2014 15:16:51 -0700
Message-ID: <53b33353.sJdItNIBti1qhbcN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:33884 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759046AbaGAWQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2014 18:16:52 -0400
Received: by mail-yh0-f73.google.com with SMTP id f10so1118934yha.0
        for <mm-commits@vger.kernel.org>; Tue, 01 Jul 2014 15:16:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: remove BAD_ALIEN_MAGIC
has been added to the -mm tree.  Its filename is
     slab-remove-bad_alien_magic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-remove-bad_alien_magic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-remove-bad_alien_magic.patch

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
Subject: slab: remove BAD_ALIEN_MAGIC

BAD_ALIEN_MAGIC value isn't used anymore. So remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/slab.c~slab-remove-bad_alien_magic mm/slab.c
--- a/mm/slab.c~slab-remove-bad_alien_magic
+++ a/mm/slab.c
@@ -470,8 +470,6 @@ static struct kmem_cache kmem_cache_boot
 	.name = "kmem_cache",
 };
 
-#define BAD_ALIEN_MAGIC 0x01020304ul
-
 static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
 
 static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
@@ -838,7 +836,7 @@ static int transfer_objects(struct array
 static inline struct alien_cache **alloc_alien_cache(int node,
 						int limit, gfp_t gfp)
 {
-	return (struct alien_cache **)BAD_ALIEN_MAGIC;
+	return NULL;
 }
 
 static inline void free_alien_cache(struct alien_cache **ac_ptr)
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
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
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
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

