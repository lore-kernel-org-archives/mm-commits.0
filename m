From: akpm@linux-foundation.org
Subject: [merged] mm-warn_on_once-if-f_op-mmap-change-vmas-start-address.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:29:00 -0800
Message-ID: <20121214232900.A744582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:59044 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab2LNX3B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:29:01 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so410582yen.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:29:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: WARN_ON_ONCE if f_op->mmap() change vma's start address
has been removed from the -mm tree.  Its filename was
     mm-warn_on_once-if-f_op-mmap-change-vmas-start-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm: WARN_ON_ONCE if f_op->mmap() change vma's start address

During reviewing the source code, I found a comment which mention that
after f_op->mmap(), vma's start address can be changed.  I didn't verify
that it is really possible, because there are so many f_op->mmap()
implementation.  But if there are some mmap() which change vma's start
address, it is possible error situation, because we already prepare prev
vma, rb_link and rb_parent and these are related to original address.

So add WARN_ON_ONCE for finding that this situtation really happens.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/mmap.c~mm-warn_on_once-if-f_op-mmap-change-vmas-start-address mm/mmap.c
--- a/mm/mmap.c~mm-warn_on_once-if-f_op-mmap-change-vmas-start-address
+++ a/mm/mmap.c
@@ -1488,7 +1488,11 @@ munmap_back:
 		 *
 		 * Answer: Yes, several device drivers can do it in their
 		 *         f_op->mmap method. -DaveM
+		 * Bug: If addr is changed, prev, rb_link, rb_parent should
+		 *      be updated for vma_link()
 		 */
+		WARN_ON_ONCE(addr != vma->vm_start);
+
 		addr = vma->vm_start;
 		pgoff = vma->vm_pgoff;
 		vm_flags = vma->vm_flags;
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

