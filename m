From: akpm@linux-foundation.org
Subject: - optimize-compound_head-by-avoiding-a-shared-page.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:00 -0700
Message-ID: <200705080003.l48030Hr008906@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967330AbXEHAD2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mm: optimize compound_head() by avoiding a shared page flag
has been removed from the -mm tree.  Its filename was
     optimize-compound_head-by-avoiding-a-shared-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: optimize compound_head() by avoiding a shared page flag
From: Christoph Lameter <clameter@sgi.com>

The patch adds PageTail(page) and PageHead(page) to check if a page is the
head or the tail of a compound page.  This is done by masking the two bits
describing the state of a compound page and then comparing them.  So one
comparision and a branch instead of two bit checks and two branches.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |   11 +---------
 include/linux/page-flags.h |   37 ++++++++++++++++++++++++-----------
 mm/page_alloc.c            |   10 +++------
 3 files changed, 32 insertions(+), 26 deletions(-)

diff -puN include/linux/mm.h~optimize-compound_head-by-avoiding-a-shared-page include/linux/mm.h
--- a/include/linux/mm.h~optimize-compound_head-by-avoiding-a-shared-page
+++ a/include/linux/mm.h
@@ -269,14 +269,7 @@ static inline int get_page_unless_zero(s
 
 static inline struct page *compound_head(struct page *page)
 {
-	/*
-	 * We could avoid the PageCompound(page) check if
-	 * we would not overload PageTail().
-	 *
-	 * This check has to be done in several performance critical
-	 * paths of the slab etc. IMHO PageTail deserves its own flag.
-	 */
-	if (unlikely(PageCompound(page) && PageTail(page)))
+	if (unlikely(PageTail(page)))
 		return page->first_page;
 	return page;
 }
@@ -327,7 +320,7 @@ static inline compound_page_dtor *get_co
 
 static inline int compound_order(struct page *page)
 {
-	if (!PageCompound(page) || PageTail(page))
+	if (!PageHead(page))
 		return 0;
 	return (unsigned long)page[1].lru.prev;
 }
diff -puN include/linux/page-flags.h~optimize-compound_head-by-avoiding-a-shared-page include/linux/page-flags.h
--- a/include/linux/page-flags.h~optimize-compound_head-by-avoiding-a-shared-page
+++ a/include/linux/page-flags.h
@@ -6,6 +6,7 @@
 #define PAGE_FLAGS_H
 
 #include <linux/types.h>
+#include <linux/mm_types.h>
 
 /*
  * Various page->flags bits:
@@ -94,12 +95,6 @@
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 
-/*
- * Marks tail portion of a compound page. We currently do not reclaim
- * compound pages so we can reuse a flag only used for reclaim here.
- */
-#define PG_tail			PG_reclaim
-
 #if (BITS_PER_LONG > 32)
 /*
  * 64-bit-only flags build down from bit 31
@@ -248,12 +243,32 @@ static inline void SetPageUptodate(struc
 #define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
 
 /*
- * Note: PG_tail is an alias of another page flag. The result of PageTail()
- * is only valid if PageCompound(page) is true.
+ * PG_reclaim is used in combination with PG_compound to mark the
+ * head and tail of a compound page
+ *
+ * PG_compound & PG_reclaim	=> Tail page
+ * PG_compound & ~PG_reclaim	=> Head page
  */
-#define PageTail(page)	test_bit(PG_tail, &(page)->flags)
-#define __SetPageTail(page)	__set_bit(PG_tail, &(page)->flags)
-#define __ClearPageTail(page)	__clear_bit(PG_tail, &(page)->flags)
+
+#define PG_head_tail_mask ((1L << PG_compound) | (1L << PG_reclaim))
+
+#define PageTail(page)	((page->flags & PG_head_tail_mask) \
+				== PG_head_tail_mask)
+
+static inline void __SetPageTail(struct page *page)
+{
+	page->flags |= PG_head_tail_mask;
+}
+
+static inline void __ClearPageTail(struct page *page)
+{
+	page->flags &= ~PG_head_tail_mask;
+}
+
+#define PageHead(page)	((page->flags & PG_head_tail_mask) \
+				== (1L << PG_compound))
+#define __SetPageHead(page)	__SetPageCompound(page)
+#define __ClearPageHead(page)	__ClearPageCompound(page)
 
 #ifdef CONFIG_SWAP
 #define PageSwapCache(page)	test_bit(PG_swapcache, &(page)->flags)
diff -puN mm/page_alloc.c~optimize-compound_head-by-avoiding-a-shared-page mm/page_alloc.c
--- a/mm/page_alloc.c~optimize-compound_head-by-avoiding-a-shared-page
+++ a/mm/page_alloc.c
@@ -235,12 +235,11 @@ static void prep_compound_page(struct pa
 
 	set_compound_page_dtor(page, free_compound_page);
 	set_compound_order(page, order);
-	__SetPageCompound(page);
+	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
 		__SetPageTail(p);
-		__SetPageCompound(p);
 		p->first_page = page;
 	}
 }
@@ -253,17 +252,16 @@ static void destroy_compound_page(struct
 	if (unlikely(compound_order(page) != order))
 		bad_page(page);
 
-	if (unlikely(!PageCompound(page)))
+	if (unlikely(!PageHead(page)))
 			bad_page(page);
-	__ClearPageCompound(page);
+	__ClearPageHead(page);
 	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
-		if (unlikely(!PageCompound(p) | !PageTail(p) |
+		if (unlikely(!PageTail(p) |
 				(p->first_page != page)))
 			bad_page(page);
 		__ClearPageTail(p);
-		__ClearPageCompound(p);
 	}
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
