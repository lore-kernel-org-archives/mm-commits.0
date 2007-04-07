From: akpm@linux-foundation.org
Subject: + make-page-private-usable-in-compound-pages-v1.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:24:05 -0700
Message-ID: <200704070524.l375O5ag028152@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbXDGFYI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:24:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Make page->private usable in compound pages
has been added to the -mm tree.  Its filename is
     make-page-private-usable-in-compound-pages-v1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make page->private usable in compound pages
From: Christoph Lameter <clameter@sgi.com>

If we add a new flag so that we can distinguish between the first page and the
tail pages then we can avoid to use page->private in the first page. 
page->private == page for the first page, so there is no real information in
there.

Freeing up page->private makes the use of compound pages more transparent. 
They become more usable like real pages.  Right now we have to be careful f.e.
 if we are going beyond PAGE_SIZE allocations in the slab on i386 because we
can then no longer use the private field.  This is one of the issues that
cause us not to support debugging for page size slabs in SLAB.

Having page->private available for SLUB would allow more meta information in
the page struct.  I can probably avoid the 16 bit ints that I have in there
right now.

Also if page->private is available then a compound page may be equipped with
buffer heads.  This may free up the way for filesystems to support larger
blocks than page size.

We add PageTail as an alias of PageReclaim.  Compound pages cannot currently
be reclaimed.  Because of the alias one needs to check PageCompound first.

The RFC for the this approach was discussed at
http://marc.info/?t=117574302800001&r=1&w=2

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c        |    2 +-
 include/linux/mm.h         |   33 ++++++++++++++++++++++++++++-----
 include/linux/page-flags.h |   14 ++++++++++++++
 mm/internal.h              |    2 +-
 mm/page_alloc.c            |   29 ++++++++++++++++++++---------
 mm/slab.c                  |    6 ++----
 mm/slub.c                  |   19 ++++---------------
 mm/swap.c                  |    2 +-
 8 files changed, 71 insertions(+), 36 deletions(-)

diff -puN arch/ia64/mm/init.c~make-page-private-usable-in-compound-pages-v1 arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~make-page-private-usable-in-compound-pages-v1
+++ a/arch/ia64/mm/init.c
@@ -121,7 +121,7 @@ lazy_mmu_prot_update (pte_t pte)
 		return;				/* i-cache is already coherent with d-cache */
 
 	if (PageCompound(page)) {
-		order = (unsigned long) (page[1].lru.prev);
+		order = compound_order(page);
 		flush_icache_range(addr, addr + (1UL << order << PAGE_SHIFT));
 	}
 	else
diff -puN include/linux/mm.h~make-page-private-usable-in-compound-pages-v1 include/linux/mm.h
--- a/include/linux/mm.h~make-page-private-usable-in-compound-pages-v1
+++ a/include/linux/mm.h
@@ -294,17 +294,28 @@ static inline int get_page_unless_zero(s
 	return atomic_inc_not_zero(&page->_count);
 }
 
+static inline struct page *compound_head(struct page *page)
+{
+	/*
+	 * We could avoid the PageCompound(page) check if
+	 * we would not overload PageTail().
+	 *
+	 * This check has to be done in several performance critical
+	 * paths of the slab etc. IMHO PageTail deserves its own flag.
+	 */
+	if (unlikely(PageCompound(page) && PageTail(page)))
+		return page->first_page;
+	return page;
+}
+
 static inline int page_count(struct page *page)
 {
-	if (unlikely(PageCompound(page)))
-		page = (struct page *)page_private(page);
-	return atomic_read(&page->_count);
+	return atomic_read(&compound_head(page)->_count);
 }
 
 static inline void get_page(struct page *page)
 {
-	if (unlikely(PageCompound(page)))
-		page = (struct page *)page_private(page);
+	page = compound_head(page);
 	VM_BUG_ON(atomic_read(&page->_count) == 0);
 	atomic_inc(&page->_count);
 }
@@ -341,6 +352,18 @@ static inline compound_page_dtor *get_co
 	return (compound_page_dtor *)page[1].lru.next;
 }
 
+static inline int compound_order(struct page *page)
+{
+	if (!PageCompound(page) || PageTail(page))
+		return 0;
+	return (unsigned long)page[1].lru.prev;
+}
+
+static inline void set_compound_order(struct page *page, unsigned long order)
+{
+	page[1].lru.prev = (void *)order;
+}
+
 /*
  * Multiple processes may "see" the same page. E.g. for untouched
  * mappings of /dev/null, all processes see the same page full of
diff -puN include/linux/page-flags.h~make-page-private-usable-in-compound-pages-v1 include/linux/page-flags.h
--- a/include/linux/page-flags.h~make-page-private-usable-in-compound-pages-v1
+++ a/include/linux/page-flags.h
@@ -94,6 +94,12 @@
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
 
+/*
+ * Marks tail portion of a compound page. We currently do not reclaim
+ * compound pages so we can reuse a flag only used for reclaim here.
+ */
+#define PG_tail			PG_reclaim
+
 #if (BITS_PER_LONG > 32)
 /*
  * 64-bit-only flags build down from bit 31
@@ -241,6 +247,14 @@ static inline void SetPageUptodate(struc
 #define __SetPageCompound(page)	__set_bit(PG_compound, &(page)->flags)
 #define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
 
+/*
+ * Note: PG_tail is an alias of another page flag. The result of PageTail()
+ * is only valid if PageCompound(page) is true.
+ */
+#define PageTail(page)	test_bit(PG_tail, &(page)->flags)
+#define __SetPageTail(page)	__set_bit(PG_tail, &(page)->flags)
+#define __ClearPageTail(page)	__clear_bit(PG_tail, &(page)->flags)
+
 #ifdef CONFIG_SWAP
 #define PageSwapCache(page)	test_bit(PG_swapcache, &(page)->flags)
 #define SetPageSwapCache(page)	set_bit(PG_swapcache, &(page)->flags)
diff -puN mm/internal.h~make-page-private-usable-in-compound-pages-v1 mm/internal.h
--- a/mm/internal.h~make-page-private-usable-in-compound-pages-v1
+++ a/mm/internal.h
@@ -24,7 +24,7 @@ static inline void set_page_count(struct
  */
 static inline void set_page_refcounted(struct page *page)
 {
-	VM_BUG_ON(PageCompound(page) && page_private(page) != (unsigned long)page);
+	VM_BUG_ON(PageCompound(page) && PageTail(page));
 	VM_BUG_ON(atomic_read(&page->_count));
 	set_page_count(page, 1);
 }
diff -puN mm/page_alloc.c~make-page-private-usable-in-compound-pages-v1 mm/page_alloc.c
--- a/mm/page_alloc.c~make-page-private-usable-in-compound-pages-v1
+++ a/mm/page_alloc.c
@@ -275,7 +275,7 @@ static void bad_page(struct page *page)
 
 static void free_compound_page(struct page *page)
 {
-	__free_pages_ok(page, (unsigned long)page[1].lru.prev);
+	__free_pages_ok(page, compound_order(page));
 }
 
 static void prep_compound_page(struct page *page, unsigned long order)
@@ -284,12 +284,14 @@ static void prep_compound_page(struct pa
 	int nr_pages = 1 << order;
 
 	set_compound_page_dtor(page, free_compound_page);
-	page[1].lru.prev = (void *)order;
-	for (i = 0; i < nr_pages; i++) {
+	set_compound_order(page, order);
+	__SetPageCompound(page);
+	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
+		__SetPageTail(p);
 		__SetPageCompound(p);
-		set_page_private(p, (unsigned long)page);
+		p->first_page = page;
 	}
 }
 
@@ -298,15 +300,19 @@ static void destroy_compound_page(struct
 	int i;
 	int nr_pages = 1 << order;
 
-	if (unlikely((unsigned long)page[1].lru.prev != order))
+	if (unlikely(compound_order(page) != order))
 		bad_page(page);
 
-	for (i = 0; i < nr_pages; i++) {
+	if (unlikely(!PageCompound(page)))
+			bad_page(page);
+	__ClearPageCompound(page);
+	for (i = 1; i < nr_pages; i++) {
 		struct page *p = page + i;
 
-		if (unlikely(!PageCompound(p) |
-				(page_private(p) != (unsigned long)page)))
+		if (unlikely(!PageCompound(p) | !PageTail(p) |
+				(p->first_page != page)))
 			bad_page(page);
+		__ClearPageTail(p);
 		__ClearPageCompound(p);
 	}
 }
@@ -479,13 +485,18 @@ static inline int free_pages_check(struc
 			1 << PG_private |
 			1 << PG_locked	|
 			1 << PG_active	|
-			1 << PG_reclaim	|
 			1 << PG_slab	|
 			1 << PG_swapcache |
 			1 << PG_writeback |
 			1 << PG_reserved |
 			1 << PG_buddy ))))
 		bad_page(page);
+	/*
+	 * PageReclaim == PageTail. It is only an error
+	 * for PageReclaim to be set if PageCompound is clear.
+	 */
+	if (unlikely(!PageCompound(page) && PageReclaim(page)))
+		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
 	/*
diff -puN mm/slab.c~make-page-private-usable-in-compound-pages-v1 mm/slab.c
--- a/mm/slab.c~make-page-private-usable-in-compound-pages-v1
+++ a/mm/slab.c
@@ -602,8 +602,7 @@ static inline void page_set_cache(struct
 
 static inline struct kmem_cache *page_get_cache(struct page *page)
 {
-	if (unlikely(PageCompound(page)))
-		page = (struct page *)page_private(page);
+	page = compound_head(page);
 	BUG_ON(!PageSlab(page));
 	return (struct kmem_cache *)page->lru.next;
 }
@@ -615,8 +614,7 @@ static inline void page_set_slab(struct 
 
 static inline struct slab *page_get_slab(struct page *page)
 {
-	if (unlikely(PageCompound(page)))
-		page = (struct page *)page_private(page);
+	page = compound_head(page);
 	BUG_ON(!PageSlab(page));
 	return (struct slab *)page->lru.prev;
 }
diff -puN mm/slub.c~make-page-private-usable-in-compound-pages-v1 mm/slub.c
--- a/mm/slub.c~make-page-private-usable-in-compound-pages-v1
+++ a/mm/slub.c
@@ -1273,9 +1273,7 @@ void kmem_cache_free(struct kmem_cache *
 
 	page = virt_to_page(x);
 
-	if (unlikely(PageCompound(page)))
-		page = page->first_page;
-
+	page = compound_head(page);
 
 	if (unlikely(PageError(page) && (s->flags & SLAB_STORE_USER)))
 		set_tracking(s, x, 1);
@@ -1286,10 +1284,7 @@ EXPORT_SYMBOL(kmem_cache_free);
 /* Figure out on which slab object the object resides */
 static struct page *get_object_page(const void *x)
 {
-	struct page *page = virt_to_page(x);
-
-	if (unlikely(PageCompound(page)))
-		page = page->first_page;
+	struct page *page = compound_head(virt_to_page(x));
 
 	if (!PageSlab(page))
 		return NULL;
@@ -1896,10 +1891,7 @@ void kfree(const void *x)
 	if (!x)
 		return;
 
-	page = virt_to_page(x);
-
-	if (unlikely(PageCompound(page)))
-		page = page->first_page;
+	page = compound_head(virt_to_page(x));
 
 	s = page->slab;
 
@@ -1935,10 +1927,7 @@ void *krealloc(const void *p, size_t new
 		return NULL;
 	}
 
-	page = virt_to_page(p);
-
-	if (unlikely(PageCompound(page)))
-		page = page->first_page;
+	page = compound_head(virt_to_page(p));
 
 	new_cache = get_slab(new_size, flags);
 
diff -puN mm/swap.c~make-page-private-usable-in-compound-pages-v1 mm/swap.c
--- a/mm/swap.c~make-page-private-usable-in-compound-pages-v1
+++ a/mm/swap.c
@@ -55,7 +55,7 @@ static void fastcall __page_cache_releas
 
 static void put_compound_page(struct page *page)
 {
-	page = (struct page *)page_private(page);
+	page = compound_head(page);
 	if (put_page_testzero(page)) {
 		compound_page_dtor *dtor;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
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
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
