From: akpm@linux-foundation.org
Subject: - slub-do-our-own-flags-based-on-pg_active-and-pg_error.patch removed from -mm tree
Date: Fri, 18 May 2007 00:05:37 -0700
Message-ID: <200705180705.l4I75aFw010109@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56524 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755889AbXERHHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Do our own flags based on PG_active and PG_error
has been removed from the -mm tree.  Its filename was
     slub-do-our-own-flags-based-on-pg_active-and-pg_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Do our own flags based on PG_active and PG_error
From: Christoph Lameter <clameter@sgi.com>

The atomicity when handling flags in SLUB is not necessary since both flags
used by SLUB are not updated in a racy way.  Flag updates are either done
during slab creation or destruction or under slab_lock.  Some of these flags
do not have the non atomic variants that we need.  So define our own.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN mm/slub.c~slub-do-our-own-flags-based-on-pg_active-and-pg_error mm/slub.c
--- a/mm/slub.c~slub-do-our-own-flags-based-on-pg_active-and-pg_error
+++ a/mm/slub.c
@@ -99,42 +99,42 @@
  * 			the fast path and disables lockless freelists.
  */
 
+#define FROZEN (1 << PG_active)
+
+#ifdef CONFIG_SLUB_DEBUG
+#define SLABDEBUG (1 << PG_error)
+#else
+#define SLABDEBUG 0
+#endif
+
 static inline int SlabFrozen(struct page *page)
 {
-	return PageActive(page);
+	return page->flags & FROZEN;
 }
 
 static inline void SetSlabFrozen(struct page *page)
 {
-	SetPageActive(page);
+	page->flags |= FROZEN;
 }
 
 static inline void ClearSlabFrozen(struct page *page)
 {
-	ClearPageActive(page);
+	page->flags &= ~FROZEN;
 }
 
 static inline int SlabDebug(struct page *page)
 {
-#ifdef CONFIG_SLUB_DEBUG
-	return PageError(page);
-#else
-	return 0;
-#endif
+	return page->flags & SLABDEBUG;
 }
 
 static inline void SetSlabDebug(struct page *page)
 {
-#ifdef CONFIG_SLUB_DEBUG
-	SetPageError(page);
-#endif
+	page->flags |= SLABDEBUG;
 }
 
 static inline void ClearSlabDebug(struct page *page)
 {
-#ifdef CONFIG_SLUB_DEBUG
-	ClearPageError(page);
-#endif
+	page->flags &= ~SLABDEBUG;
 }
 
 /*
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
