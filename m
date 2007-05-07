From: akpm@linux-foundation.org
Subject: + slub-make-page-private-usable-in-compound-pages-v1.patch added to -mm tree
Date: Mon, 07 May 2007 11:45:39 -0700
Message-ID: <200705071845.l47Ije1D002113@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754666AbXEGSqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 14:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, nacc@us.ibm.com


The patch titled
     Make page->private usable in compound pages
has been added to the -mm tree.  Its filename is
     slub-make-page-private-usable-in-compound-pages-v1.patch

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

[nacc@us.ibm.com: fix hugetlbfs]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   14 ++++++++++++++
 mm/slub.c                  |   19 ++++---------------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff -puN include/linux/page-flags.h~slub-make-page-private-usable-in-compound-pages-v1 include/linux/page-flags.h
--- a/include/linux/page-flags.h~slub-make-page-private-usable-in-compound-pages-v1
+++ a/include/linux/page-flags.h
@@ -95,6 +95,12 @@
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
@@ -265,6 +271,14 @@ static inline void __ClearPageTail(struc
 #define __SetPageHead(page)	__SetPageCompound(page)
 #define __ClearPageHead(page)	__ClearPageCompound(page)
 
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
diff -puN mm/slub.c~slub-make-page-private-usable-in-compound-pages-v1 mm/slub.c
--- a/mm/slub.c~slub-make-page-private-usable-in-compound-pages-v1
+++ a/mm/slub.c
@@ -1325,9 +1325,7 @@ void kmem_cache_free(struct kmem_cache *
 
 	page = virt_to_page(x);
 
-	if (unlikely(PageCompound(page)))
-		page = page->first_page;
-
+	page = compound_head(page);
 
 	if (unlikely(PageError(page) && (s->flags & SLAB_STORE_USER)))
 		set_tracking(s, x, TRACK_FREE);
@@ -1338,10 +1336,7 @@ EXPORT_SYMBOL(kmem_cache_free);
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
@@ -2081,10 +2076,7 @@ void kfree(const void *x)
 	if (!x)
 		return;
 
-	page = virt_to_page(x);
-
-	if (unlikely(PageCompound(page)))
-		page = page->first_page;
+	page = compound_head(virt_to_page(x));
 
 	s = page->slab;
 
@@ -2120,10 +2112,7 @@ void *krealloc(const void *p, size_t new
 		return NULL;
 	}
 
-	page = virt_to_page(p);
-
-	if (unlikely(PageCompound(page)))
-		page = page->first_page;
+	page = compound_head(virt_to_page(p));
 
 	new_cache = get_slab(new_size, flags);
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
make-page-private-usable-in-compound-pages-v1.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-multiple-alignment-specifications.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_ctor_atomic.patch
slab-allocators-remove-useless-__gfp_no_grow-flag.patch
page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible.patch
slub-core.patch
slub-change-default-alignments.patch
slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes.patch
powerpc-disable-slub-for-configurations-in-which-slab-page-structs-are-modified.patch
slub-make-page-private-usable-in-compound-pages-v1.patch
slub-add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-add-slabinfo-tool.patch
slub-slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
slub-slab-allocators-remove-slab_debug_initial-flag.patch
slub-slab-allocators-remove-slab_ctor_atomic.patch
slub-slab-allocators-remove-useless-__gfp_no_grow-flag.patch
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
