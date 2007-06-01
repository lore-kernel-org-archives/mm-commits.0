From: akpm@linux-foundation.org
Subject: - slub-fix-numa--sysfs-bootstrap-issue.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:06:37 -0700
Message-ID: <200706010706.l5176a6e004725@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758329AbXFAHGj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:06:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Fix NUMA / SYSFS bootstrap issue
has been removed from the -mm tree.  Its filename was
     slub-fix-numa--sysfs-bootstrap-issue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Fix NUMA / SYSFS bootstrap issue
From: Christoph Lameter <clameter@sgi.com>

We need this patch in ASAP.  Patch fixes the mysterious hang that remained
on some particular configurations with lockdep on after the first fix that
moved the #idef CONFIG_SLUB_DEBUG to the right location.  See
http://marc.info/?t=117963072300001&r=1&w=2

The kmem_cache_node cache is very special because it is needed for NUMA
bootstrap.  Under certain conditions (like for example if lockdep is
enabled and significantly increases the size of spinlock_t) the structure
may become exactly the size as one of the larger caches in the kmalloc
array.

That early during bootstrap we cannot perform merging properly.  The unique
id for the kmem_cache_node cache will match one of the kmalloc array. 
Sysfs will complain about a duplicate directory entry.  All of this occurs
while the console is not yet fully operational.  Thus boot may appear to be
silently failing.

The kmem_cache_node cache is very special.  During early boostrap the main
allocation function is not operational yet and so we have to run our own
small special alloc function during early boot.  It is also special in that
it is never freed.

We really do not want any merging on that cache.  Set the refcount -1 and
forbid merging of slabs that have a negative refcount.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/slub.c~slub-fix-numa--sysfs-bootstrap-issue mm/slub.c
--- a/mm/slub.c~slub-fix-numa--sysfs-bootstrap-issue
+++ a/mm/slub.c
@@ -2435,6 +2435,7 @@ void __init kmem_cache_init(void)
 	 */
 	create_kmalloc_cache(&kmalloc_caches[0], "kmem_cache_node",
 		sizeof(struct kmem_cache_node), GFP_KERNEL);
+	kmalloc_caches[0].refcount = -1;
 #endif
 
 	/* Able to allocate the per node structures */
@@ -2482,6 +2483,12 @@ static int slab_unmergeable(struct kmem_
 	if (s->ctor)
 		return 1;
 
+	/*
+	 * We may have set a slab to be unmergeable during bootstrap.
+	 */
+	if (s->refcount < 0)
+		return 1;
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slub-fix-locking-for-hotplug-callbacks.patch
slab-fix-slab-debug-for-non-alien-caches.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-use-ilog2-instead-of-series-of-constant-comparisons.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
hexdump-more-output-formatting.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
