From: akpm@linux-foundation.org
Subject: + slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch added to -mm tree
Date: Thu, 26 Apr 2007 23:31:38 -0700
Message-ID: <200704270631.l3R6VcbQ021323@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755394AbXD0Gbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 02:31:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, mel@skynet.ie


The patch titled
     SLUB: Free slabs and sort partial slab lists in kmem_cache_shrink
has been added to the -mm tree.  Its filename is
     slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Free slabs and sort partial slab lists in kmem_cache_shrink
From: Christoph Lameter <clameter@sgi.com>

At kmem_cache_shrink check if we have any empty slabs on the partial
if so then remove them.

Also--as an anti-fragmentation measure--sort the partial slabs so that
the most fully allocated ones come first and the least allocated last.

The next allocations may fill up the nearly full slabs. Having the
least allocated slabs last gives them the maximum chance that their
remaining objects may be freed. Thus we can hopefully minimize the
partial slabs.

I think this is the best one can do in terms antifragmentation
measures. Real defragmentation (meaning moving objects out of slabs with
the least free objects to those that are almost full) can be implemted
by reverse scanning through the list produced here but that would mean
that we need to provide a callback at slab cache creation that allows
the deletion or moving of an object. This will involve slab API
changes, so defer for now.

Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 105 insertions(+), 13 deletions(-)

diff -puN mm/slub.c~slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink mm/slub.c
--- a/mm/slub.c~slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink
+++ a/mm/slub.c
@@ -136,9 +136,19 @@
  */
 #define SLUB_UNIMPLEMENTED (SLAB_DEBUG_INITIAL)
 
-/* Mininum number of partial slabs */
+/*
+ * Mininum number of partial slabs. These will be left on the partial
+ * lists even if they are empty. kmem_cache_shrink may reclaim them.
+ */
 #define MIN_PARTIAL 2
 
+/*
+ * Maximum number of desirable partial slabs.
+ * The existence of more partial slabs makes kmem_cache_shrink
+ * sort the partial list by the number of objects in the.
+ */
+#define MAX_PARTIAL 10
+
 #define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
 /*
@@ -1951,7 +1961,7 @@ static int kmem_cache_close(struct kmem_
 	for_each_online_node(node) {
 		struct kmem_cache_node *n = get_node(s, node);
 
-		free_list(s, n, &n->partial);
+		n->nr_partial -= free_list(s, n, &n->partial);
 		if (atomic_long_read(&n->nr_slabs))
 			return 1;
 	}
@@ -2200,6 +2210,79 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+/*
+ *  kmem_cache_shrink removes empty slabs from the partial lists
+ *  and then sorts the partially allocated slabs by the number
+ *  of items in use. The slabs with the most items in use
+ *  come first. New allocations will remove these from the
+ *  partial list because they are full. The slabs with the
+ *  least items are placed last. If it happens that the objects
+ *  are freed then the page can be returned to the page allocator.
+ */
+int kmem_cache_shrink(struct kmem_cache *s)
+{
+	int node;
+	int i;
+	struct kmem_cache_node *n;
+	struct page *page;
+	struct page *t;
+	struct list_head *slabs_by_inuse =
+		kmalloc(sizeof(struct list_head) * s->objects, GFP_KERNEL);
+	unsigned long flags;
+
+	if (!slabs_by_inuse)
+		return -ENOMEM;
+
+	flush_all(s);
+	for_each_online_node(node) {
+		n = get_node(s, node);
+
+		if (n->nr_partial <= MIN_PARTIAL)
+			continue;
+
+		for (i = 0; i < s->objects; i++)
+			INIT_LIST_HEAD(slabs_by_inuse + i);
+
+		spin_lock_irqsave(&n->list_lock, flags);
+
+		/*
+		 * Build lists indexed by the items in use in
+		 * each slab or free slabs if empty.
+		 *
+		 * Note that concurrent frees may occur while
+		 * we hold the list_lock. page->inuse here is
+		 * the upper limit.
+		 */
+		list_for_each_entry_safe(page, t, &n->partial, lru) {
+			if (!page->inuse) {
+				list_del(&page->lru);
+				n->nr_partial--;
+				discard_slab(s, page);
+			} else
+			if (n->nr_partial > MAX_PARTIAL)
+				list_move(&page->lru,
+					slabs_by_inuse + page->inuse);
+		}
+
+		if (n->nr_partial <= MAX_PARTIAL)
+			goto out;
+
+		/*
+		 * Rebuild the partial list with the slabs filled up
+		 * most first and the least used slabs at the end.
+		 */
+		for (i = s->objects - 1; i > 0; i--)
+			list_splice(slabs_by_inuse + i, n->partial.prev);
+
+	out:
+		spin_unlock_irqrestore(&n->list_lock, flags);
+	}
+
+	kfree(slabs_by_inuse);
+	return 0;
+}
+EXPORT_SYMBOL(kmem_cache_shrink);
+
 /**
  * krealloc - reallocate memory. The contents will remain unchanged.
  *
@@ -2444,17 +2527,6 @@ static struct notifier_block __cpuinitda
 
 #endif
 
-/***************************************************************
- *	Compatiblility definitions
- **************************************************************/
-
-int kmem_cache_shrink(struct kmem_cache *s)
-{
-	flush_all(s);
-	return 0;
-}
-EXPORT_SYMBOL(kmem_cache_shrink);
-
 #ifdef CONFIG_NUMA
 
 /*****************************************************************
@@ -3228,6 +3300,25 @@ static ssize_t validate_store(struct kme
 }
 SLAB_ATTR(validate);
 
+static ssize_t shrink_show(struct kmem_cache *s, char *buf)
+{
+	return 0;
+}
+
+static ssize_t shrink_store(struct kmem_cache *s,
+			const char *buf, size_t length)
+{
+	if (buf[0] == '1') {
+		int rc = kmem_cache_shrink(s);
+
+		if (rc)
+			return rc;
+	} else
+		return -EINVAL;
+	return length;
+}
+SLAB_ATTR(shrink);
+
 static ssize_t alloc_calls_show(struct kmem_cache *s, char *buf)
 {
 	if (!(s->flags & SLAB_STORE_USER))
@@ -3284,6 +3375,7 @@ static struct attribute * slab_attrs[] =
 	&poison_attr.attr,
 	&store_user_attr.attr,
 	&validate_attr.attr,
+	&shrink_attr.attr,
 	&alloc_calls_attr.attr,
 	&free_calls_attr.attr,
 #ifdef CONFIG_ZONE_DMA
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
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
extend-print_symbol-capability-fix.patch
extend-print_symbol-capability-fix-fix.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
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
slub-i386-support.patch
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
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
readahead-state-based-method-aging-accounting.patch
