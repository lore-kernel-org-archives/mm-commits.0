From: akpm@linux-foundation.org
Subject: - slub-use-ilog2-instead-of-series-of-constant-comparisons.patch removed from -mm tree
Date: Wed, 06 Jun 2007 10:21:08 -0700
Message-ID: <200706061721.l56HL8CB002236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60674 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755415AbXFFRVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 13:21:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLUB: use ilog2 instead of series of constant comparisons
has been removed from the -mm tree.  Its filename was
     slub-use-ilog2-instead-of-series-of-constant-comparisons.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: SLUB: use ilog2 instead of series of constant comparisons
From: Christoph Lameter <clameter@sgi.com>

I finally found a way to get rid of the nasty list of comparisions in
slub_def.h. ilog2 seems to work right for constants.

Also update comments

Drop the generation of an unresolved symbol for the case that the size is
too big. A simple BUG_ON sufficies now that we can alloc up to MAX_ORDER
size slab objects.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   61 +++++++++----------------------------
 1 file changed, 16 insertions(+), 45 deletions(-)

diff -puN include/linux/slub_def.h~slub-use-ilog2-instead-of-series-of-constant-comparisons include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-use-ilog2-instead-of-series-of-constant-comparisons
+++ a/include/linux/slub_def.h
@@ -10,6 +10,7 @@
 #include <linux/gfp.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
+#include <linux/log2.h>
 
 struct kmem_cache_node {
 	spinlock_t list_lock;	/* Protect partial list and nr_partial */
@@ -58,6 +59,8 @@ struct kmem_cache {
  */
 #define KMALLOC_SHIFT_LOW 3
 
+#define KMALLOC_MIN_SIZE (1UL << KMALLOC_SHIFT_LOW)
+
 /*
  * We keep the general caches in an array of slab caches that are used for
  * 2^x bytes of allocations.
@@ -65,8 +68,9 @@ struct kmem_cache {
 extern struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1];
 
 /*
- * Sorry that the following has to be that ugly but some versions of GCC
- * have trouble with constant propagation and loops.
+ * Determine the kmalloc array index given the object size.
+ *
+ * Return -1 if the object size is not supported.
  */
 static inline int kmalloc_index(size_t size)
 {
@@ -76,42 +80,18 @@ static inline int kmalloc_index(size_t s
 	if (size > KMALLOC_MAX_SIZE)
 		return -1;
 
+	if (size <= KMALLOC_MIN_SIZE)
+		return KMALLOC_SHIFT_LOW;
+
+	/*
+	 * We map the non power of two slabs to the unused
+	 * log2 values in the kmalloc array.
+	 */
 	if (size > 64 && size <= 96)
 		return 1;
 	if (size > 128 && size <= 192)
 		return 2;
-	if (size <=          8) return 3;
-	if (size <=         16) return 4;
-	if (size <=         32) return 5;
-	if (size <=         64) return 6;
-	if (size <=        128) return 7;
-	if (size <=        256) return 8;
-	if (size <=        512) return 9;
-	if (size <=       1024) return 10;
-	if (size <=   2 * 1024) return 11;
-	if (size <=   4 * 1024) return 12;
-	if (size <=   8 * 1024) return 13;
-	if (size <=  16 * 1024) return 14;
-	if (size <=  32 * 1024) return 15;
-	if (size <=  64 * 1024) return 16;
-	if (size <= 128 * 1024) return 17;
-	if (size <= 256 * 1024) return 18;
-	if (size <=  512 * 1024) return 19;
-	if (size <= 1024 * 1024) return 20;
-	if (size <=  2 * 1024 * 1024) return 21;
-	if (size <=  4 * 1024 * 1024) return 22;
-	if (size <=  8 * 1024 * 1024) return 23;
-	if (size <= 16 * 1024 * 1024) return 24;
-	if (size <= 32 * 1024 * 1024) return 25;
-	return -1;
-
-/*
- * What we really wanted to do and cannot do because of compiler issues is:
- *	int i;
- *	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
- *		if (size <= (1 << i))
- *			return i;
- */
+	return ilog2(size - 1) + 1;
 }
 
 /*
@@ -128,18 +108,9 @@ static inline struct kmem_cache *kmalloc
 		return NULL;
 
 	/*
-	 * This function only gets expanded if __builtin_constant_p(size), so
-	 * testing it here shouldn't be needed.  But some versions of gcc need
-	 * help.
+	 * If this triggers then the amount of memory requested was too large.
 	 */
-	if (__builtin_constant_p(size) && index < 0) {
-		/*
-		 * Generate a link failure. Would be great if we could
-		 * do something to stop the compile here.
-		 */
-		extern void __kmalloc_size_too_large(void);
-		__kmalloc_size_too_large();
-	}
+	BUG_ON(index < 0);
 	return &kmalloc_caches[index];
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
slab-fix-alien-cache-handling.patch
slub-return-zero_size_ptr-for-kmalloc0.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-use-ilog2-instead-of-series-of-constant-comparisons.patch
slub-support-slub_debug-on-by-default.patch
slub-support-slub_debug-on-by-default-tidy.patch
numa-mempolicy-allow-tunable-policy-for-system-init.patch
numa-mempolicy-allow-tunable-policy-for-system-init-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
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
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
revert-slub-use-ilog2-instead-of-series-of-constant-comparisons.patch
