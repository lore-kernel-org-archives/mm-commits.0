From: akpm@linux-foundation.org
Subject: + slub-core-use-enum-for-tracking-modes-instead-of-integers.patch added to -mm tree
Date: Mon, 09 Apr 2007 22:29:44 -0700
Message-ID: <200704100529.l3A5TiNJ032264@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44798 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966095AbXDJF3q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 01:29:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: use enum for tracking modes instead of integers
has been added to the -mm tree.  Its filename is
     slub-core-use-enum-for-tracking-modes-instead-of-integers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: use enum for tracking modes instead of integers
From: Christoph Lameter <clameter@sgi.com>

Integers caused some confusion. This cleans it up and uses symbolic constants
throughout.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN mm/slub.c~slub-core-use-enum-for-tracking-modes-instead-of-integers mm/slub.c
--- a/mm/slub.c~slub-core-use-enum-for-tracking-modes-instead-of-integers
+++ a/mm/slub.c
@@ -211,7 +211,10 @@ struct track {
 	unsigned long when;	/* When did the operation occur */
 };
 
-struct track *get_track(struct kmem_cache *s, void *object, int alloc)
+enum track_item { TRACK_ALLOC, TRACK_FREE };
+
+struct track *get_track(struct kmem_cache *s, void *object,
+	enum track_item alloc)
 {
 	struct track *p;
 
@@ -224,7 +227,7 @@ struct track *get_track(struct kmem_cach
 }
 
 static void set_track(struct kmem_cache *s, void *object,
-				int alloc, void *addr)
+				enum track_item alloc, void *addr)
 {
 	struct track *p;
 
@@ -249,8 +252,8 @@ static void set_track(struct kmem_cache 
 static void init_tracking(struct kmem_cache *s, void *object)
 {
 	if (s->flags & SLAB_STORE_USER) {
-		set_track(s, object, 0, NULL);
-		set_track(s, object, 1, NULL);
+		set_track(s, object, TRACK_FREE, NULL);
+		set_track(s, object, TRACK_ALLOC, NULL);
 	}
 }
 
@@ -298,8 +301,8 @@ static void print_trailer(struct kmem_ca
 		off = s->inuse;
 
 	if (s->flags & SLAB_STORE_USER) {
-		print_track("Last alloc", get_track(s, p, 0));
-		print_track("Last free ", get_track(s, p, 1));
+		print_track("Last alloc", get_track(s, p, TRACK_ALLOC));
+		print_track("Last free ", get_track(s, p, TRACK_FREE));
 		off += 2 * sizeof(struct track);
 	}
 
@@ -1186,7 +1189,7 @@ debug:
 	if (!alloc_object_checks(s, page, object))
 		goto another_slab;
 	if (s->flags & SLAB_STORE_USER)
-		set_tracking(s, object, 0);
+		set_tracking(s, object, TRACK_ALLOC);
 	goto have_object;
 }
 
@@ -1278,7 +1281,7 @@ void kmem_cache_free(struct kmem_cache *
 
 
 	if (unlikely(PageError(page) && (s->flags & SLAB_STORE_USER)))
-		set_tracking(s, x, 1);
+		set_tracking(s, x, TRACK_FREE);
 	slab_free(s, page, x);
 }
 EXPORT_SYMBOL(kmem_cache_free);
@@ -1904,7 +1907,7 @@ void kfree(const void *x)
 	s = page->slab;
 
 	if (unlikely(PageError(page) && (s->flags & SLAB_STORE_USER)))
-		set_tracking(s, (void *)x, 1);
+		set_tracking(s, (void *)x, TRACK_FREE);
 	slab_free(s, page, (void *)x);
 }
 EXPORT_SYMBOL(kfree);
@@ -2267,7 +2270,7 @@ void *__kmalloc_track_caller(size_t size
 	object = kmem_cache_alloc(s, gfpflags);
 
 	if (object && (s->flags & SLAB_STORE_USER))
-		set_track(s, object, 0, caller);
+		set_track(s, object, TRACK_ALLOC, caller);
 
 	return object;
 }
@@ -2284,7 +2287,7 @@ void *__kmalloc_node_track_caller(size_t
 	object = kmem_cache_alloc_node(s, gfpflags, node);
 
 	if (object && (s->flags & SLAB_STORE_USER))
-		set_track(s, object, 0, caller);
+		set_track(s, object, TRACK_ALLOC, caller);
 
 	return object;
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
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-add-slabinfo-tool.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
fix-object-tracking.patch
fix-another-numa-bootstrap-issue.patch
update-slabinfoc.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
