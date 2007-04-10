From: akpm@linux-foundation.org
Subject: + slub-core-fix-another-numa-bootstrap-issue.patch added to -mm tree
Date: Mon, 09 Apr 2007 22:31:26 -0700
Message-ID: <200704100531.l3A5VQPf032322@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44882 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966101AbXDJFb2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 01:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: fix another NUMA bootstrap issue
has been added to the -mm tree.  Its filename is
     slub-core-fix-another-numa-bootstrap-issue.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: fix another NUMA bootstrap issue
From: Christoph Lameter <clameter@sgi.com>

Make sure that the bootstrap allocation occurs on the correct node and
that the slab we allocated gets put onto the partial list. Otherwise the rest
of the slab is lost for good.

And while we are at it reduce the amount of #ifdefs by rearranging code.

init_kmem_cache_node already initializes most fields. Avoid memset and just
set the remaining field manually.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   85 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 32 deletions(-)

diff -puN mm/slub.c~slub-core-fix-another-numa-bootstrap-issue mm/slub.c
--- a/mm/slub.c~slub-core-fix-another-numa-bootstrap-issue
+++ a/mm/slub.c
@@ -1388,15 +1388,46 @@ static unsigned long calculate_alignment
 
 static void init_kmem_cache_node(struct kmem_cache_node *n)
 {
-	memset(n, 0, sizeof(struct kmem_cache_node));
+	n->nr_partial = 0;
 	atomic_long_set(&n->nr_slabs, 0);
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
 }
 
+#ifdef CONFIG_NUMA
+/*
+ * No kmalloc_node yet so do it by hand. We know that this is the first
+ * slab on the node for this slabcache. There are no concurrent accesses
+ * possible.
+ *
+ * Note that this function only works on the kmalloc_node_cache
+ * when allocating for the kmalloc_node_cache.
+ */
+struct kmem_cache_node * __init early_kmem_cache_node_alloc(
+					gfp_t gfpflags, int node)
+{
+	struct page *page;
+	struct kmem_cache_node *n;
+
+	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
+	page = new_slab(kmalloc_caches, gfpflags | GFP_THISNODE, node);
+	/* new_slab() disables interupts */
+	local_irq_enable();
+
+	BUG_ON(!page);
+	n = page->freelist;
+	BUG_ON(!n);
+	page->freelist = get_freepointer(kmalloc_caches, n);
+	page->inuse++;
+	kmalloc_caches->node[node] = n;
+	init_kmem_cache_node(n);
+	atomic_long_inc(&n->nr_slabs);
+	add_partial(kmalloc_caches, page);
+	return n;
+}
+
 static void free_kmem_cache_nodes(struct kmem_cache *s)
 {
-#ifdef CONFIG_NUMA
 	int node;
 
 	for_each_online_node(node) {
@@ -1405,12 +1436,10 @@ static void free_kmem_cache_nodes(struct
 			kmem_cache_free(kmalloc_caches, n);
 		s->node[node] = NULL;
 	}
-#endif
 }
 
 static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
 {
-#ifdef CONFIG_NUMA
 	int node;
 	int local_node;
 
@@ -1424,45 +1453,37 @@ static int init_kmem_cache_nodes(struct 
 
 		if (local_node == node)
 			n = &s->local_node;
-		else
-		if (slab_state == DOWN) {
-			/*
-			 * No kmalloc_node yet so do it by hand.
-			 * We know that this is the first slab on the
-			 * node for this slabcache. There are no concurrent
-			 * accesses possible.
-			 */
-			struct page *page;
-
-			BUG_ON(s->size < sizeof(struct kmem_cache_node));
-			page = new_slab(kmalloc_caches, gfpflags, node);
-			/* new_slab() disables interupts */
-			local_irq_enable();
-
-			BUG_ON(!page);
-			n = page->freelist;
-			page->freelist = get_freepointer(kmalloc_caches, n);
-			page->inuse++;
-		} else
+		else {
+			if (slab_state == DOWN) {
+				n = early_kmem_cache_node_alloc(gfpflags,
+								node);
+				continue;
+			}
 			n = kmem_cache_alloc_node(kmalloc_caches,
 							gfpflags, node);
 
-		if (!n) {
-			free_kmem_cache_nodes(s);
-			return 0;
-		}
+			if (!n) {
+				free_kmem_cache_nodes(s);
+				return 0;
+			}
 
+		}
 		s->node[node] = n;
 		init_kmem_cache_node(n);
-
-		if (slab_state == DOWN)
-			atomic_long_inc(&n->nr_slabs);
 	}
+	return 1;
+}
 #else
+static void free_kmem_cache_nodes(struct kmem_cache *s)
+{
+}
+
+static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
+{
 	init_kmem_cache_node(&s->local_node);
-#endif
 	return 1;
 }
+#endif
 
 int calculate_sizes(struct kmem_cache *s)
 {
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
slub-add-slabinfo-tool.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
update-slabinfoc.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
