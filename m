From: akpm@linux-foundation.org
Subject: [merged] bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:26:48 -0800
Message-ID: <20121214232649.107DE200086@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:43599 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab2LNX0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:26:52 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so208329fae.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:26:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, benh@kernel.crashing.org, egtvedt@samfundet.no, fujita.tomonori@lab.ntt.co.jp, hannes@cmpxchg.org, hskinnemoen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bootmem: remove not implemented function call, bootmem_arch_preferred_node()
has been removed from the -mm tree.  Its filename was
     bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: bootmem: remove not implemented function call, bootmem_arch_preferred_node()

There is no implementation of bootmem_arch_preferred_node() and a call to
this function will cause a compilation error.  So remove it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN mm/bootmem.c~bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node mm/bootmem.c
--- a/mm/bootmem.c~bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node
+++ a/mm/bootmem.c
@@ -581,18 +581,6 @@ static void * __init alloc_arch_preferre
 {
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc(size, GFP_NOWAIT);
-
-#ifdef CONFIG_HAVE_ARCH_BOOTMEM
-	{
-		bootmem_data_t *p_bdata;
-
-		p_bdata = bootmem_arch_preferred_node(bdata, size, align,
-							goal, limit);
-		if (p_bdata)
-			return alloc_bootmem_bdata(p_bdata, size, align,
-							goal, limit);
-	}
-#endif
 	return NULL;
 }
 
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
linux-next.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
mm-add-a-__gfp_kmemcg-flag.patch
memcg-kmem-controller-infrastructure.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
res_counter-return-amount-of-charges-after-res_counter_uncharge.patch
memcg-kmem-accounting-lifecycle-management.patch
memcg-use-static-branches-when-code-not-in-use.patch
memcg-allow-a-memcg-with-kmem-charges-to-be-destructed.patch
memcg-execute-the-whole-memcg-freeing-in-free_worker.patch
fork-protect-architectures-where-thread_size-=-page_size-against-fork-bombs.patch
memcg-add-documentation-about-the-kmem-controller.patch
slab-slub-struct-memcg_params.patch
slab-annotate-on-slab-caches-nodelist-locks.patch
slab-slub-consider-a-memcg-parameter-in-kmem_create_cache.patch
memcg-allocate-memory-for-memcg-caches-whenever-a-new-memcg-appears.patch
memcg-infrastructure-to-match-an-allocation-to-the-right-cache.patch
memcg-skip-memcg-kmem-allocations-in-specified-code-regions.patch
slb-always-get-the-cache-from-its-page-in-kmem_cache_free.patch
slb-allocate-objects-from-memcg-cache.patch
memcg-destroy-memcg-caches.patch
memcg-slb-track-all-the-memcg-children-of-a-kmem_cache.patch
memcg-slb-shrink-dead-caches.patch
memcg-aggregate-memcg-cache-values-in-slabinfo.patch
slab-propagate-tunable-values.patch
slub-slub-specific-propagation-changes.patch
slub-slub-specific-propagation-changes-fix.patch
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch

