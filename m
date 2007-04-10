From: akpm@linux-foundation.org
Subject: + optimize-compound_head-by-avoiding-a-shared-page.patch added to -mm tree
Date: Mon, 09 Apr 2007 22:10:59 -0700
Message-ID: <200704100510.l3A5AxRf031971@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44330 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966061AbXDJFLC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 01:11:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Optimize compound_head() by avoiding a shared page flag
has been added to the -mm tree.  Its filename is
     optimize-compound_head-by-avoiding-a-shared-page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Optimize compound_head() by avoiding a shared page flag
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
@@ -296,14 +296,7 @@ static inline int get_page_unless_zero(s
 
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
@@ -354,7 +347,7 @@ static inline compound_page_dtor *get_co
 
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
@@ -285,12 +285,11 @@ static void prep_compound_page(struct pa
 
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
@@ -303,17 +302,16 @@ static void destroy_compound_page(struct
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

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-add-slabinfo-tool.patch
make-page-private-usable-in-compound-pages-v1.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
