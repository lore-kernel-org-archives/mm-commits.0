From: akpm@linux-foundation.org
Subject: [merged] mm-slab-reverse-iteration-on-find_mergeable.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:55:41 -0800
Message-ID: <5489e8ad.PMLBeGXZTfmbaaLO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbaLKSzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: reverse iteration on find_mergeable()
has been removed from the -mm tree.  Its filename was
     mm-slab-reverse-iteration-on-find_mergeable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: reverse iteration on find_mergeable()

Unlike SLUB, sometimes, object isn't started at the beginning of the slab
in the SLAB.  This causes the unalignment problem when after slab merging
is supported by commit 12220dea07f1 ("mm/slab: support slab merge"). 
Alignment mismatch check is introduced ("mm/slab: fix unalignment problem
on Malta with EVA due to slab merge") to prevent merge in this case.

This causes undesirable result that merging happens between infrequently
used kmem_caches if there are kmem_caches with same size and is 256 bytes,
are merged into pool_workqueue rather than kmalloc-256, because
kmem_caches for kmalloc are at the tail of the list.

To prevent this situation, this patch reverses iteration order in
find_mergeable() to find frequently used kmem_caches.  This change helps
to merge kmem_cache to frequently used kmem_caches, such as kmalloc
kmem_caches.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab_common.c~mm-slab-reverse-iteration-on-find_mergeable mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-reverse-iteration-on-find_mergeable
+++ a/mm/slab_common.c
@@ -240,7 +240,7 @@ struct kmem_cache *find_mergeable(size_t
 	size = ALIGN(size, align);
 	flags = kmem_cache_flags(size, flags, name, NULL);
 
-	list_for_each_entry(s, &slab_caches, list) {
+	list_for_each_entry_reverse(s, &slab_caches, list) {
 		if (slab_unmergeable(s))
 			continue;
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
lib-bitmap-added-alignment-offset-for-bitmap_find_next_zero_area.patch
mm-cma-align-to-physical-address-not-cma-region-position.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch
include-linux-kmemleakh-needs-slabh.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation-fix.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
fix-memory-ordering-bug-in-mm-vmallocc.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
zsmalloc-merge-size_class-to-reduce-fragmentation.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

