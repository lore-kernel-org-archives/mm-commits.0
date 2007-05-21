From: akpm@linux-foundation.org
Subject: + slub-use-ilog2-instead-of-series-of-constant-comparisons.patch added to -mm tree
Date: Mon, 21 May 2007 14:54:17 -0700
Message-ID: <200705212154.l4LLsHir020937@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757596AbXEUVz1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:55:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: use ilog2 instead of series of constant comparisons
has been added to the -mm tree.  Its filename is
     slub-use-ilog2-instead-of-series-of-constant-comparisons.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   66 +++++++++++--------------------------
 1 files changed, 20 insertions(+), 46 deletions(-)

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
@@ -65,56 +68,36 @@ struct kmem_cache {
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
 	/*
-	 * We should return 0 if size == 0 but we use the smallest object
-	 * here for SLAB legacy reasons.
+	 * We should return 0 if size == 0 (which would result in the
+	 * kmalloc caller to get NULL) but we use the smallest object
+	 * here for legacy reasons. Just issue a warning so that
+	 * we can discover locations where we do 0 sized allocations.
 	 */
 	WARN_ON_ONCE(size == 0);
 
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
@@ -131,18 +114,9 @@ static inline struct kmem_cache *kmalloc
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

slub-debug-fix-object-size-calculation.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slub-debug-fix-check-for-super-sized-slabs-512k-64bit-256k.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-use-ilog2-instead-of-series-of-constant-comparisons.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-bio_alloc-allocations-correctly.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-page-cache-pages-as-__gfp_pagecache-instead-of-__gfp_movable.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
