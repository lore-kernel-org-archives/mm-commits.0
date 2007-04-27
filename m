From: akpm@linux-foundation.org
Subject: + slub-add-min_partial.patch added to -mm tree
Date: Thu, 26 Apr 2007 23:31:36 -0700
Message-ID: <200704270631.l3R6Va5v021308@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755392AbXD0Gbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 02:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Add MIN_PARTIAL
has been added to the -mm tree.  Its filename is
     slub-add-min_partial.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Add MIN_PARTIAL
From: Christoph Lameter <clameter@sgi.com>

We leave a mininum of partial slabs on nodes when we search for
partial slabs on other node. Define a constant for that value.

Then modify slub to keep MIN_PARTIAL slabs around.

This avoids bad situations where a function frees the last object
in a slab (which results in the page being returned to the page
allocator) only to then allocate one again (which requires getting
a page back from the page allocator if the partial list was empty).
Keeping a couple of slabs on the partial list reduces overhead.

Empty slabs are added to the end of the partial list to insure that
partially allocated slabs are consumed first (defragmentation).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   55 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 19 deletions(-)

diff -puN mm/slub.c~slub-add-min_partial mm/slub.c
--- a/mm/slub.c~slub-add-min_partial
+++ a/mm/slub.c
@@ -139,6 +139,9 @@
  */
 #define SLUB_UNIMPLEMENTED (SLAB_DEBUG_INITIAL)
 
+/* Mininum number of partial slabs */
+#define MIN_PARTIAL 2
+
 #define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
 /*
@@ -657,16 +660,8 @@ static int on_freelist(struct kmem_cache
 /*
  * Tracking of fully allocated slabs for debugging
  */
-static void add_full(struct kmem_cache *s, struct page *page)
+static void add_full(struct kmem_cache_node *n, struct page *page)
 {
-	struct kmem_cache_node *n;
-
-	VM_BUG_ON(!irqs_disabled());
-
-	if (!(s->flags & SLAB_STORE_USER))
-		return;
-
-	n = get_node(s, page_to_nid(page));
 	spin_lock(&n->list_lock);
 	list_add(&page->lru, &n->full);
 	spin_unlock(&n->list_lock);
@@ -975,10 +970,16 @@ static __always_inline int slab_trylock(
 /*
  * Management of partially allocated slabs
  */
-static void add_partial(struct kmem_cache *s, struct page *page)
+static void add_partial_tail(struct kmem_cache_node *n, struct page *page)
 {
-	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+	spin_lock(&n->list_lock);
+	n->nr_partial++;
+	list_add_tail(&page->lru, &n->partial);
+	spin_unlock(&n->list_lock);
+}
 
+static void add_partial(struct kmem_cache_node *n, struct page *page)
+{
 	spin_lock(&n->list_lock);
 	n->nr_partial++;
 	list_add(&page->lru, &n->partial);
@@ -1078,7 +1079,7 @@ static struct page *get_any_partial(stru
 		n = get_node(s, zone_to_nid(*z));
 
 		if (n && cpuset_zone_allowed_hardwall(*z, flags) &&
-				n->nr_partial > 2) {
+				n->nr_partial > MIN_PARTIAL) {
 			page = get_partial_node(n);
 			if (page)
 				return page;
@@ -1112,15 +1113,31 @@ static struct page *get_partial(struct k
  */
 static void putback_slab(struct kmem_cache *s, struct page *page)
 {
+	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
+
 	if (page->inuse) {
+
 		if (page->freelist)
-			add_partial(s, page);
-		else if (PageError(page))
-			add_full(s, page);
+			add_partial(n, page);
+		else if (PageError(page) && (s->flags & SLAB_STORE_USER))
+			add_full(n, page);
 		slab_unlock(page);
+
 	} else {
-		slab_unlock(page);
-		discard_slab(s, page);
+		if (n->nr_partial < MIN_PARTIAL) {
+			/*
+			 * Adding an empty page to the partial slabs in order
+			 * to avoid page allocator overhead. This page needs to
+			 * come after all the others that are not fully empty
+			 * in order to make sure that we do maximum
+			 * defragmentation.
+			 */
+			add_partial_tail(n, page);
+			slab_unlock(page);
+		} else {
+			slab_unlock(page);
+			discard_slab(s, page);
+		}
 	}
 }
 
@@ -1371,7 +1388,7 @@ checks_ok:
 	 * then add it.
 	 */
 	if (unlikely(!prior))
-		add_partial(s, page);
+		add_partial(get_node(s, page_to_nid(page)), page);
 
 out_unlock:
 	slab_unlock(page);
@@ -1579,7 +1596,7 @@ static struct kmem_cache_node * __init e
 	kmalloc_caches->node[node] = n;
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
-	add_partial(kmalloc_caches, page);
+	add_partial(n, page);
 	return n;
 }
 
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
