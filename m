From: akpm@linux-foundation.org
Subject: + slub-do-our-own-flags-based-on-pg_active-and-pg_error.patch added to -mm tree
Date: Tue, 15 May 2007 22:41:24 -0700
Message-ID: <200705160541.l4G5fOVh027199@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760173AbXEPFmv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 01:42:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Do our own flags based on PG_active and PG_error
has been added to the -mm tree.  Its filename is
     slub-do-our-own-flags-based-on-pg_active-and-pg_error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
slub-it-is-legit-to-allocate-a-slab-of-the-maximum-permitted-size.patch
slub-dont-confuse-ctor-and-dtor.patch
fix-find_or_create_page-skips-cpuset-memory-spreading.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
slab-warn-on-zero-length-allocations.patch
i386-dont-check_pgt_cache-in-flush_tlb_mm.patch
slub-fix-handling-of-oversized-slabs.patch
fix-page-allocation-flags-in-grow_dev_page.patch
slub-slabinfo-fixes.patch
slub-do-our-own-flags-based-on-pg_active-and-pg_error.patch
slub-simplify-debug-code.patch
compat_core_sys_select-avoid-kmalloc0.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
