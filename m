From: akpm@linux-foundation.org
Subject: - slub-core-fix-another-numa-bootstrap-issue.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:21:27 -0700
Message-ID: <200704270821.l3R8LRxM023220@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755523AbXD0IVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: fix another NUMA bootstrap issue
has been removed from the -mm tree.  Its filename was
     slub-core-fix-another-numa-bootstrap-issue.patch

This patch was dropped because it was folded into slub-core.patch

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
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-core-fix-another-numa-bootstrap-issue.patch
slub-core-fix-object-counting.patch
slub-core-drop-version-number.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-we-do-not-need-ifdef-config_smp-around-bit-spinlocks.patch
slub-core-printk-facility-level-cleanup.patch
slub-core-kmem_cache_close-is-static-and-should-not-be-exported.patch
slub-core-add-explanation-for-defrag_ratio-=-100.patch
slub-core-add-explanation-for-locking.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-the-64k-limits.patch
slub-core-explain-sizing-of-slabs-in-detail.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-add-checks-for-interrupts-disabled.patch
slub-core-use-__print_symbol-instead-of-kallsyms_lookup.patch
slub-core-missing-inlines-and-statics.patch
slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch
slub-extract-finish_bootstrap-function-for-clean-sysfs-boot.patch
slub-core-fix-kmem_cache_destroy.patch
slub-core-fix-validation.patch
slub-core-add-after-object-padding.patch
slub-core-resiliency-fixups.patch
slub-core-resiliency-fixups-fix.patch
slub-core-resiliency-test.patch
slub-core-update-cpu-after-new_slab.patch
slub-core-fix-sysfs-directory-handling.patch
slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch
slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-validation-of-slabs-metadata-and-guard-zones-fix-pageerror-checks-during-validation.patch
slub-validation-of-slabs-metadata-and-guard-zones-remove-duplicate-vm_bug_on.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_debug_initial-flag-locks-fix.patch
slab-allocators-remove-multiple-alignment-specifications.patch
slab-allocators-remove-slab_ctor_atomic.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slub-i386-support.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
readahead-state-based-method-aging-accounting.patch
