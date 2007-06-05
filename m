From: akpm@linux-foundation.org
Subject: + slab-fix-alien-cache-handling.patch added to -mm tree
Date: Mon, 04 Jun 2007 21:11:25 -0700
Message-ID: <200706050411.l554BNNw028991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50238 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbXFEELf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 00:11:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, lethal@linux-sh.org, penberg@cs.helsinki.fi


The patch titled
     slab: fix alien cache handling
has been added to the -mm tree.  Its filename is
     slab-fix-alien-cache-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab: fix alien cache handling
From: Christoph Lameter <clameter@sgi.com>

cache_free_alien must be called regardless if we use alien caches or not.
cache_free_alien() will do the right thing if there are no alien caches
available.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: Pekka J Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~slab-fix-alien-cache-handling mm/slab.c
--- a/mm/slab.c~slab-fix-alien-cache-handling
+++ a/mm/slab.c
@@ -3539,7 +3539,7 @@ static inline void __cache_free(struct k
 	check_irq_off();
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
-	if (use_alien_caches && cache_free_alien(cachep, objp))
+	if (cache_free_alien(cachep, objp))
 		return;
 
 	if (likely(ac->avail < ac->limit)) {
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
mount-t-tmpfs-o-mpol=-check-nodes-online.patch
slab-fix-alien-cache-handling.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
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
define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
