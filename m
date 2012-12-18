From: akpm@linux-foundation.org
Subject: + mm-cma-warn-if-freed-memory-is-still-in-use-fix.patch added to -mm tree
Date: Tue, 18 Dec 2012 15:29:53 -0800
Message-ID: <20121218232954.92E02200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:35212 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab2LRX35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 18:29:57 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so70024eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 15:29:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mina86@mina86.com


The patch titled
     Subject: mm-cma-warn-if-freed-memory-is-still-in-use-fix
has been added to the -mm tree.  Its filename is
     mm-cma-warn-if-freed-memory-is-still-in-use-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm-cma-warn-if-freed-memory-is-still-in-use-fix

Support sparsemem.

(And prevent "count" overflow if nr_pages cannot fit in signed type.)

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-cma-warn-if-freed-memory-is-still-in-use-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-warn-if-freed-memory-is-still-in-use-fix
+++ a/mm/page_alloc.c
@@ -5981,9 +5981,11 @@ done:
 
 void free_contig_range(unsigned long pfn, unsigned nr_pages)
 {
-	struct page *page = pfn_to_page(pfn);
-	int count = 0;
-	for (; nr_pages--; page++) {
+	unsigned int count = 0;
+
+	for (; nr_pages--; pfn++) {
+		struct page *page = pfn_to_page(pfn);
+
 		count += page_count(page) != 1;
 		__free_page(page);
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
irq-tsk-comm-is-an-array.patch
memcg-make-it-possible-to-use-the-stock-for-more-than-one-page.patch
memcg-reclaim-when-more-than-one-page-needed.patch
memcg-change-defines-to-an-enum.patch
memcg-kmem-accounting-basic-infrastructure.patch
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
kmem-add-slab-specific-documentation-about-the-kmem-controller.patch
memcg-add-comments-clarifying-aspects-of-cache-attribute-propagation.patch
slub-drop-mutex-before-deleting-sysfs-entry.patch
ksm-numa-awareness-sysfs-knob.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch
x86-fix-the-argument-passed-to-sync_global_pgds.patch
mm-mempolicy-introduce-spinlock-to-read-shared-policy-tree.patch
mm-cma-warn-if-freed-memory-is-still-in-use-fix.patch
mm-dmapoolc-fix-null-dev-in-dma_pool_create.patch

