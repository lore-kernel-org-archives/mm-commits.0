From: akpm@linux-foundation.org
Subject: + add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:24:53 -0700
Message-ID: <200704070524.l375OrUN028169@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44972 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbXDGFYz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Add virt_to_head_page and consolidate code in slab and slub
has been added to the -mm tree.  Its filename is
     add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add virt_to_head_page and consolidate code in slab and slub
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++++
 mm/slab.c          |    9 ++++-----
 mm/slub.c          |   10 ++++------
 3 files changed, 14 insertions(+), 11 deletions(-)

diff -puN include/linux/mm.h~add-virt_to_head_page-and-consolidate-code-in-slab-and-slub include/linux/mm.h
--- a/include/linux/mm.h~add-virt_to_head_page-and-consolidate-code-in-slab-and-slub
+++ a/include/linux/mm.h
@@ -320,6 +320,12 @@ static inline void get_page(struct page 
 	atomic_inc(&page->_count);
 }
 
+static inline struct page *virt_to_head_page(const void *x)
+{
+	struct page *page = virt_to_page(x);
+	return compound_head(page);
+}
+
 /*
  * Setup the page count before being freed into the page allocator for
  * the first time (boot or memory hotplug)
diff -puN mm/slab.c~add-virt_to_head_page-and-consolidate-code-in-slab-and-slub mm/slab.c
--- a/mm/slab.c~add-virt_to_head_page-and-consolidate-code-in-slab-and-slub
+++ a/mm/slab.c
@@ -614,20 +614,19 @@ static inline void page_set_slab(struct 
 
 static inline struct slab *page_get_slab(struct page *page)
 {
-	page = compound_head(page);
 	BUG_ON(!PageSlab(page));
 	return (struct slab *)page->lru.prev;
 }
 
 static inline struct kmem_cache *virt_to_cache(const void *obj)
 {
-	struct page *page = virt_to_page(obj);
+	struct page *page = virt_to_head_page(obj);
 	return page_get_cache(page);
 }
 
 static inline struct slab *virt_to_slab(const void *obj)
 {
-	struct page *page = virt_to_page(obj);
+	struct page *page = virt_to_head_page(obj);
 	return page_get_slab(page);
 }
 
@@ -2873,7 +2872,7 @@ static void *cache_free_debugcheck(struc
 
 	objp -= obj_offset(cachep);
 	kfree_debugcheck(objp);
-	page = virt_to_page(objp);
+	page = virt_to_head_page(objp);
 
 	slabp = page_get_slab(page);
 
@@ -3097,7 +3096,7 @@ static void *cache_alloc_debugcheck_afte
 		struct slab *slabp;
 		unsigned objnr;
 
-		slabp = page_get_slab(virt_to_page(objp));
+		slabp = page_get_slab(virt_to_head_page(objp));
 		objnr = (unsigned)(objp - slabp->s_mem) / cachep->buffer_size;
 		slab_bufctl(slabp)[objnr] = BUFCTL_ACTIVE;
 	}
diff -puN mm/slub.c~add-virt_to_head_page-and-consolidate-code-in-slab-and-slub mm/slub.c
--- a/mm/slub.c~add-virt_to_head_page-and-consolidate-code-in-slab-and-slub
+++ a/mm/slub.c
@@ -1271,9 +1271,7 @@ void kmem_cache_free(struct kmem_cache *
 {
 	struct page * page;
 
-	page = virt_to_page(x);
-
-	page = compound_head(page);
+	page = virt_to_head_page(x);
 
 	if (unlikely(PageError(page) && (s->flags & SLAB_STORE_USER)))
 		set_tracking(s, x, 1);
@@ -1284,7 +1282,7 @@ EXPORT_SYMBOL(kmem_cache_free);
 /* Figure out on which slab object the object resides */
 static struct page *get_object_page(const void *x)
 {
-	struct page *page = compound_head(virt_to_page(x));
+	struct page *page = virt_to_head_page(x);
 
 	if (!PageSlab(page))
 		return NULL;
@@ -1891,7 +1889,7 @@ void kfree(const void *x)
 	if (!x)
 		return;
 
-	page = compound_head(virt_to_page(x));
+	page = virt_to_head_page(x);
 
 	s = page->slab;
 
@@ -1927,7 +1925,7 @@ void *krealloc(const void *p, size_t new
 		return NULL;
 	}
 
-	page = compound_head(virt_to_page(p));
+	page = virt_to_head_page(p);
 
 	new_cache = get_slab(new_size, flags);
 
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
