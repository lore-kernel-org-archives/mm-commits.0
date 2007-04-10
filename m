From: akpm@linux-foundation.org
Subject: + slub-enable-tracking-of-full-slabs.patch added to -mm tree
Date: Tue, 10 Apr 2007 12:35:13 -0700
Message-ID: <200704101935.l3AJZDvI015656@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42678 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbXDJTfP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 15:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: enable tracking of full slabs
has been added to the -mm tree.  Its filename is
     slub-enable-tracking-of-full-slabs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: enable tracking of full slabs
From: Christoph Lameter <clameter@sgi.com>

If slab tracking is on then build a list of full slabs so that we can verify
the integrity of all slabs and are also able to built list of alloc/free
callers.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    1 
 mm/slub.c                |   38 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff -puN include/linux/slub_def.h~slub-enable-tracking-of-full-slabs include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-enable-tracking-of-full-slabs
+++ a/include/linux/slub_def.h
@@ -16,6 +16,7 @@ struct kmem_cache_node {
 	unsigned long nr_partial;
 	atomic_long_t nr_slabs;
 	struct list_head partial;
+	struct list_head full;
 };
 
 /*
diff -puN mm/slub.c~slub-enable-tracking-of-full-slabs mm/slub.c
--- a/mm/slub.c~slub-enable-tracking-of-full-slabs
+++ a/mm/slub.c
@@ -572,6 +572,36 @@ static int on_freelist(struct kmem_cache
 	return 0;
 }
 
+/*
+ * Tracking of fully allocated slabs for debugging
+ */
+static void add_full(struct kmem_cache *s, struct page *page)
+{
+	struct kmem_cache_node *n;
+
+	if (!(s->flags & SLAB_STORE_USER))
+		return;
+
+	n = get_node(s, page_to_nid(page));
+	spin_lock(&n->list_lock);
+	list_add(&page->lru, &n->full);
+	spin_unlock(&n->list_lock);
+}
+
+static void remove_full(struct kmem_cache *s, struct page *page)
+{
+	struct kmem_cache_node *n;
+
+	if (!(s->flags & SLAB_STORE_USER))
+		return;
+
+	n = get_node(s, page_to_nid(page));
+
+	spin_lock(&n->list_lock);
+	list_del(&page->lru);
+	spin_unlock(&n->list_lock);
+}
+
 static int alloc_object_checks(struct kmem_cache *s, struct page *page,
 							void *object)
 {
@@ -990,6 +1020,9 @@ static void putback_slab(struct kmem_cac
 	if (page->inuse) {
 		if (page->freelist)
 			add_partial(s, page);
+		else
+		if (PageError(page))
+			add_full(s, page);
 		slab_unlock(page);
 	} else {
 		slab_unlock(page);
@@ -1253,7 +1286,7 @@ out_unlock:
 slab_empty:
 	if (prior)
 		/*
-		 * Partially used slab that is on the partial list.
+		 * Slab on the partial list.
 		 */
 		remove_partial(s, page);
 
@@ -1265,6 +1298,8 @@ slab_empty:
 debug:
 	if (!free_object_checks(s, page, x))
 		goto out_unlock;
+	if (!PageActive(page) && !page->freelist)
+		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, x, TRACK_FREE, addr);
 	goto checks_ok;
@@ -1383,6 +1418,7 @@ static void init_kmem_cache_node(struct 
 	atomic_long_set(&n->nr_slabs, 0);
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
+	INIT_LIST_HEAD(&n->full);
 }
 
 #ifdef CONFIG_NUMA
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
slub-core-fix-another-numa-bootstrap-issue.patch
slub-core-fix-object-counting.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
validation-of-slabs-metadata-and-guard-zones.patch
add-ability-to-list-alloc--free-callers-per-slab.patch
drop-version-number.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
