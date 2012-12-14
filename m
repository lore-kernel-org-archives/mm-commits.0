From: akpm@linux-foundation.org
Subject: [merged] bootmem-remove-alloc_arch_preferred_bootmem.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:26:52 -0800
Message-ID: <20121214232653.44A2B200083@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:56912 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab2LNX05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:26:57 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so208085eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:26:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, benh@kernel.crashing.org, egtvedt@samfundet.no, fujita.tomonori@lab.ntt.co.jp, hannes@cmpxchg.org, hskinnemoen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bootmem: remove alloc_arch_preferred_bootmem()
has been removed from the -mm tree.  Its filename was
     bootmem-remove-alloc_arch_preferred_bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: bootmem: remove alloc_arch_preferred_bootmem()

The name of this function is not suitable, and removing the function and
open-coding it into each call sites makes the code more understandable.

Additionally, we shouldn't do an allocation from bootmem when
slab_is_available(), so directly return kmalloc()'s return value.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff -puN mm/bootmem.c~bootmem-remove-alloc_arch_preferred_bootmem mm/bootmem.c
--- a/mm/bootmem.c~bootmem-remove-alloc_arch_preferred_bootmem
+++ a/mm/bootmem.c
@@ -575,15 +575,6 @@ find_block:
 	return NULL;
 }
 
-static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
-					unsigned long size, unsigned long align,
-					unsigned long goal, unsigned long limit)
-{
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc(size, GFP_NOWAIT);
-	return NULL;
-}
-
 static void * __init alloc_bootmem_core(unsigned long size,
 					unsigned long align,
 					unsigned long goal,
@@ -592,9 +583,8 @@ static void * __init alloc_bootmem_core(
 	bootmem_data_t *bdata;
 	void *region;
 
-	region = alloc_arch_preferred_bootmem(NULL, size, align, goal, limit);
-	if (region)
-		return region;
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc(size, GFP_NOWAIT);
 
 	list_for_each_entry(bdata, &bdata_list, list) {
 		if (goal && bdata->node_low_pfn <= PFN_DOWN(goal))
@@ -692,11 +682,9 @@ void * __init ___alloc_bootmem_node_nopa
 {
 	void *ptr;
 
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc(size, GFP_NOWAIT);
 again:
-	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size,
-					   align, goal, limit);
-	if (ptr)
-		return ptr;
 
 	/* do not panic in alloc_bootmem_bdata() */
 	if (limit && goal + size > limit)
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

