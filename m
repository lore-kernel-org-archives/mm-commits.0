From: akpm@linux-foundation.org
Subject: + slub-debug-fix-object-size-calculation.patch added to -mm tree
Date: Mon, 21 May 2007 12:23:40 -0700
Message-ID: <200705211923.l4LJNgkA017652@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933175AbXEUTZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 15:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, hugh@veritas.com


The patch titled
     SLUB Debug: Fix object size calculation
has been added to the -mm tree.  Its filename is
     slub-debug-fix-object-size-calculation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB Debug: Fix object size calculation
From: Christoph Lameter <clameter@sgi.com>

The object size calculation is wrong if !CONFIG_SLUB_DEBUG because the
#ifdef CONFIG_SLUB_DEBUG is now switching off the size adjustments for
DESTROY_BY_RCU and ctor.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-debug-fix-object-size-calculation mm/slub.c
--- a/mm/slub.c~slub-debug-fix-object-size-calculation
+++ a/mm/slub.c
@@ -1917,7 +1917,6 @@ static int calculate_sizes(struct kmem_c
 	 */
 	s->inuse = size;
 
-#ifdef CONFIG_SLUB_DEBUG
 	if (((flags & (SLAB_DESTROY_BY_RCU | SLAB_POISON)) ||
 		s->ctor)) {
 		/*
@@ -1932,6 +1931,7 @@ static int calculate_sizes(struct kmem_c
 		size += sizeof(void *);
 	}
 
+#ifdef CONFIG_SLUB_DEBUG
 	if (flags & SLAB_STORE_USER)
 		/*
 		 * Need to store information about allocs and frees after
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
