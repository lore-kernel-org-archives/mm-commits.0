From: akpm@linux-foundation.org
Subject: + slub-fix-off-by-one-in-number-of-slab-tests.patch added to -mm
 tree
Date: Tue, 24 Jun 2014 14:51:56 -0700
Message-ID: <53a9f2fc.4PZEZlOUyq9IP2av%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFXVv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 17:51:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: fix off by one in number of slab tests
has been added to the -mm tree.  Its filename is
     slub-fix-off-by-one-in-number-of-slab-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slub-fix-off-by-one-in-number-of-slab-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slub-fix-off-by-one-in-number-of-slab-tests.patch

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
Subject: slub: fix off by one in number of slab tests

min_partial means minimum number of slab cached in node partial list.  So,
if nr_partial is less than it, we keep newly empty slab on node partial
list rather than freeing it.  But if nr_partial is equal or greater than
it, it means that we have enough partial slabs so should free newly empty
slab.  Current implementation missed the equal case so if we set
min_partial is 0, then, at least one slab could be cached.  This is
critical problem to kmemcg destroying logic because it doesn't works
properly if some slabs is cached.  This patch fixes this problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-fix-off-by-one-in-number-of-slab-tests mm/slub.c
--- a/mm/slub.c~slub-fix-off-by-one-in-number-of-slab-tests
+++ a/mm/slub.c
@@ -1851,7 +1851,7 @@ redo:
 
 	new.frozen = 0;
 
-	if (!new.inuse && n->nr_partial > s->min_partial)
+	if (!new.inuse && n->nr_partial >= s->min_partial)
 		m = M_FREE;
 	else if (new.freelist) {
 		m = M_PARTIAL;
@@ -1962,7 +1962,7 @@ static void unfreeze_partials(struct kme
 				new.freelist, new.counters,
 				"unfreezing slab"));
 
-		if (unlikely(!new.inuse && n->nr_partial > s->min_partial)) {
+		if (unlikely(!new.inuse && n->nr_partial >= s->min_partial)) {
 			page->next = discard_page;
 			discard_page = page;
 		} else {
@@ -2587,7 +2587,7 @@ static void __slab_free(struct kmem_cach
                 return;
         }
 
-	if (unlikely(!new.inuse && n->nr_partial > s->min_partial))
+	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial))
 		goto slab_empty;
 
 	/*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
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
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
slub-fix-off-by-one-in-number-of-slab-tests.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
slab-set-free_limit-for-dead-caches-to-0.patch
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

