From: akpm@linux-foundation.org
Subject: - slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch removed from -mm tree
Date: Fri, 18 May 2007 00:05:25 -0700
Message-ID: <200705180705.l4I75OGa010090@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029AbXERHGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Remove depends on EXPERIMENTAL and !ARCH_USES_SLAB_PAGE_STRUCT
has been removed from the -mm tree.  Its filename was
     slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Remove depends on EXPERIMENTAL and !ARCH_USES_SLAB_PAGE_STRUCT
From: Christoph Lameter <clameter@sgi.com>

No arch sets ARCH_USES_SLAB_PAGE_STRUCT anymore.

Remove the experimental dependency as well since we want to have it as
a real alternative to SLAB.

It all comes down to killing a single line from init/Kconfig.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN init/Kconfig~slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct init/Kconfig
--- a/init/Kconfig~slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct
+++ a/init/Kconfig
@@ -567,7 +567,6 @@ config SLAB
 	  a slab allocator.
 
 config SLUB
-	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
 	bool "SLUB (Unqueued Allocator)"
 	help
 	   SLUB is a slab allocator that minimizes cache line usage
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-another-slabinfo-fix.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
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
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
revoke-core-code.patch
