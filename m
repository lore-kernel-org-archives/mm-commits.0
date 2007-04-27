From: akpm@linux-foundation.org
Subject: - slub-core-printk-facility-level-cleanup.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:21:53 -0700
Message-ID: <200704270821.l3R8LrTr023272@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755527AbXD0IV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:21:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: printk facility level cleanup
has been removed from the -mm tree.  Its filename was
     slub-core-printk-facility-level-cleanup.patch

This patch was dropped because it was folded into slub-core.patch

------------------------------------------------------
Subject: SLUB: printk facility level cleanup
From: Christoph Lameter <clameter@sgi.com>

Consistently use KERN_ERR instead of KERN_CRIT.  Fixup one location where
we did not use a facility level.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/slub.c~slub-core-printk-facility-level-cleanup mm/slub.c
--- a/mm/slub.c~slub-core-printk-facility-level-cleanup
+++ a/mm/slub.c
@@ -502,14 +502,14 @@ static int check_object(struct kmem_cach
 static int check_slab(struct kmem_cache *s, struct page *page)
 {
 	if (!PageSlab(page)) {
-		printk(KERN_CRIT "SLUB: %s Not a valid slab page @0x%p "
+		printk(KERN_ERR "SLUB: %s Not a valid slab page @0x%p "
 			"flags=%lx mapping=0x%p count=%d \n",
 			s->name, page, page->flags, page->mapping,
 			page_count(page));
 		return 0;
 	}
 	if (page->offset * sizeof(void *) != s->offset) {
-		printk(KERN_CRIT "SLUB: %s Corrupted offset %lu in slab @0x%p"
+		printk(KERN_ERR "SLUB: %s Corrupted offset %lu in slab @0x%p"
 			" flags=0x%lx mapping=0x%p count=%d\n",
 			s->name,
 			(unsigned long)(page->offset * sizeof(void *)),
@@ -520,7 +520,7 @@ static int check_slab(struct kmem_cache 
 		return 0;
 	}
 	if (page->inuse > s->objects) {
-		printk(KERN_CRIT "SLUB: %s Inuse %u > max %u in slab "
+		printk(KERN_ERR "SLUB: %s Inuse %u > max %u in slab "
 			"page @0x%p flags=%lx mapping=0x%p count=%d\n",
 			s->name, page->inuse, s->objects, page, page->flags,
 			page->mapping, page_count(page));
@@ -566,7 +566,7 @@ static int on_freelist(struct kmem_cache
 	}
 
 	if (page->inuse != s->objects - nr) {
-		printk(KERN_CRIT "slab %s: page 0x%p wrong object count."
+		printk(KERN_ERR "slab %s: page 0x%p wrong object count."
 			" counter is %d but counted were %d\n",
 			s->name, page, page->inuse,
 			s->objects - nr);
@@ -601,7 +601,7 @@ static int alloc_object_checks(struct km
 	init_object(s, object, 1);
 
 	if (s->flags & SLAB_TRACE) {
-		printk("TRACE %s alloc 0x%p inuse=%d fp=0x%p\n",
+		printk(KERN_INFO "TRACE %s alloc 0x%p inuse=%d fp=0x%p\n",
 			s->name, object, page->inuse,
 			page->freelist);
 		dump_stack();
@@ -630,7 +630,7 @@ static int free_object_checks(struct kme
 	}
 
 	if (on_freelist(s, page, object)) {
-		printk(KERN_CRIT "SLUB: %s slab 0x%p object "
+		printk(KERN_ERR "SLUB: %s slab 0x%p object "
 			"0x%p already free.\n", s->name, page, object);
 		goto fail;
 	}
@@ -640,23 +640,23 @@ static int free_object_checks(struct kme
 
 	if (unlikely(s != page->slab)) {
 		if (!PageSlab(page))
-			printk(KERN_CRIT "slab_free %s size %d: attempt to"
+			printk(KERN_ERR "slab_free %s size %d: attempt to"
 				"free object(0x%p) outside of slab.\n",
 				s->name, s->size, object);
 		else
 		if (!page->slab)
-			printk(KERN_CRIT
+			printk(KERN_ERR
 				"slab_free : no slab(NULL) for object 0x%p.\n",
 						object);
 		else
-		printk(KERN_CRIT "slab_free %s(%d): object at 0x%p"
+		printk(KERN_ERR "slab_free %s(%d): object at 0x%p"
 				" belongs to slab %s(%d)\n",
 				s->name, s->size, object,
 				page->slab->name, page->slab->size);
 		goto fail;
 	}
 	if (s->flags & SLAB_TRACE) {
-		printk("TRACE %s free 0x%p inuse=%d fp=0x%p\n",
+		printk(KERN_INFO "TRACE %s free 0x%p inuse=%d fp=0x%p\n",
 			s->name, object, page->inuse,
 			page->freelist);
 		print_section("Object", object, s->objsize);
@@ -1772,7 +1772,7 @@ static int __init setup_slub_debug(char 
 				slub_debug |= SLAB_TRACE;
 				break;
 			default:
-				printk(KERN_CRIT "slub_debug option '%c' "
+				printk(KERN_ERR "slub_debug option '%c' "
 					"unknown. skipped\n",*str);
 			}
 	}
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
