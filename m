From: akpm@linux-foundation.org
Subject: - slub-debug-fix-check-for-super-sized-slabs-512k-64bit-256k.patch removed from -mm tree
Date: Tue, 29 May 2007 11:51:52 -0700
Message-ID: <200705291851.l4TIppoe008364@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757985AbXE2SwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:52:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB Debug: fix check for super sized slabs (>512k 64bit, >256k  32bit)
has been removed from the -mm tree.  Its filename was
     slub-debug-fix-check-for-super-sized-slabs-512k-64bit-256k.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB Debug: fix check for super sized slabs (>512k 64bit, >256k  32bit)
From: Christoph Lameter <clameter@sgi.com>

The check for super sized slabs where we can no longer move the free
pointer behind the object for debugging purposes etc is accessing a field
that is not setup yet.  We must use objsize here since the size of the slab
has not been determined yet.

The effect of this is that a global slab shrink via "slabinfo -s" will show
errors about offsets being wrong if booted with slub_debug.  Potentially
there are other troubles with huge slabs under slub_debug because the
calculated free pointer offset is truncated.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-debug-fix-check-for-super-sized-slabs-512k-64bit-256k mm/slub.c
--- a/mm/slub.c~slub-debug-fix-check-for-super-sized-slabs-512k-64bit-256k
+++ a/mm/slub.c
@@ -939,7 +939,7 @@ static void kmem_cache_open_debug_check(
 	 * Debugging or ctor may create a need to move the free
 	 * pointer. Fail if this happens.
 	 */
-	if (s->size >= 65535 * sizeof(void *)) {
+	if (s->objsize >= 65535 * sizeof(void *)) {
 		BUG_ON(s->flags & (SLAB_RED_ZONE | SLAB_POISON |
 				SLAB_STORE_USER | SLAB_DESTROY_BY_RCU));
 		BUG_ON(s->ctor);
_

Patches currently in -mm which might be from clameter@sgi.com are

slub-more-documentation.patch
slub-more-documentation-fix.patch
ntfs_init_locked_inode-fix-array-indexing.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
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
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
