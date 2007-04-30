From: akpm@linux-foundation.org
Subject: - slub-remove-object-activities-out-of-checking-functions-printk-cleanup-diagnostic-functions.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:59:44 -0700
Message-ID: <200704301859.l3UIxiRo012118@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423702AbXD3TAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 15:00:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB printk cleanup: Diagnostic functions
has been removed from the -mm tree.  Its filename was
     slub-remove-object-activities-out-of-checking-functions-printk-cleanup-diagnostic-functions.patch

This patch was dropped because it was folded into slub-remove-object-activities-out-of-checking-functions.patch

------------------------------------------------------
Subject: SLUB printk cleanup: Diagnostic functions
From: Christoph Lameter <clameter@sgi.com>

Make printk output of the diagnostic functions consistent and use the new
slab_err function as much as possible to consolidate code.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   73 +++++++++++++++++++++-------------------------------
 1 files changed, 30 insertions(+), 43 deletions(-)

diff -puN mm/slub.c~slub-remove-object-activities-out-of-checking-functions-printk-cleanup-diagnostic-functions mm/slub.c
--- a/mm/slub.c~slub-remove-object-activities-out-of-checking-functions-printk-cleanup-diagnostic-functions
+++ a/mm/slub.c
@@ -465,7 +465,7 @@ static int check_valid_pointer(struct km
 static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
 						void *from, void *to)
 {
-	printk(KERN_ERR "@@@ SLUB: %s Restoring %s (0x%x) from 0x%p-0x%p\n",
+	printk(KERN_ERR "@@@ SLUB %s: Restoring %s (0x%x) from 0x%p-0x%p\n",
 		s->name, message, data, from, to - 1);
 	memset(from, data, to - from);
 }
@@ -512,9 +512,7 @@ static int slab_pad_check(struct kmem_ca
 		return 1;
 
 	if (!check_bytes(p + length, POISON_INUSE, remainder)) {
-		printk(KERN_ERR "SLUB: %s slab 0x%p: Padding fails check\n",
-			s->name, p);
-		dump_stack();
+		slab_err(s, page, "Padding check failed");
 		restore_bytes(s, "slab padding", POISON_INUSE, p + length,
 			p + length + remainder);
 		return 0;
@@ -600,30 +598,25 @@ static int check_slab(struct kmem_cache 
 	VM_BUG_ON(!irqs_disabled());
 
 	if (!PageSlab(page)) {
-		printk(KERN_ERR "SLUB: %s Not a valid slab page @0x%p "
-			"flags=%lx mapping=0x%p count=%d \n",
-			s->name, page, page->flags, page->mapping,
+		slab_err(s, page, "Not a valid slab page flags=%lx "
+			"mapping=0x%p count=%d", page->flags, page->mapping,
 			page_count(page));
 		return 0;
 	}
 	if (page->offset * sizeof(void *) != s->offset) {
-		printk(KERN_ERR "SLUB: %s Corrupted offset %lu in slab @0x%p"
-			" flags=0x%lx mapping=0x%p count=%d\n",
-			s->name,
+		slab_err(s, page, "Corrupted offset %lu flags=0x%lx "
+			"mapping=0x%p count=%d",
 			(unsigned long)(page->offset * sizeof(void *)),
-			page,
 			page->flags,
 			page->mapping,
 			page_count(page));
-		dump_stack();
 		return 0;
 	}
 	if (page->inuse > s->objects) {
-		printk(KERN_ERR "SLUB: %s inuse %u > max %u in slab "
-			"page @0x%p flags=%lx mapping=0x%p count=%d\n",
-			s->name, page->inuse, s->objects, page, page->flags,
+		slab_err(s, page, "inuse %u > max %u @0x%p flags=%lx "
+			"mapping=0x%p count=%d",
+			s->name, page->inuse, s->objects, page->flags,
 			page->mapping, page_count(page));
-		dump_stack();
 		return 0;
 	}
 	/* Slab_pad_check fixes things up after itself */
@@ -652,12 +645,13 @@ static int on_freelist(struct kmem_cache
 				set_freepointer(s, object, NULL);
 				break;
 			} else {
-				printk(KERN_ERR "SLUB: %s slab 0x%p "
-					"freepointer 0x%p corrupted.\n",
-					s->name, page, fp);
-				dump_stack();
+				slab_err(s, page, "Freepointer 0x%p corrupt",
+									fp);
 				page->freelist = NULL;
 				page->inuse = s->objects;
+				printk(KERN_ERR "@@@ SLUB %s: Freelist "
+					"cleared. Slab 0x%p\n",
+					s->name, page);
 				return 0;
 			}
 			break;
@@ -668,11 +662,12 @@ static int on_freelist(struct kmem_cache
 	}
 
 	if (page->inuse != s->objects - nr) {
-		printk(KERN_ERR "slab %s: page 0x%p wrong object count."
-			" counter is %d but counted were %d\n",
-			s->name, page, page->inuse,
-			s->objects - nr);
+		slab_err(s, page, "Wrong object count. Counter is %d but "
+			"counted were %d", s, page, page->inuse,
+							s->objects - nr);
 		page->inuse = s->objects - nr;
+		printk(KERN_ERR "@@@ SLUB %s: Object count adjusted. "
+			"Slab @0x%p\n", s->name, page);
 	}
 	return search == NULL;
 }
@@ -708,10 +703,7 @@ static int alloc_object_checks(struct km
 		goto bad;
 
 	if (object && !on_freelist(s, page, object)) {
-		printk(KERN_ERR "SLUB: %s Object 0x%p@0x%p "
-			"already allocated.\n",
-			s->name, object, page);
-		dump_stack();
+		slab_err(s, page, "Object 0x%p already allocated", object);
 		goto bad;
 	}
 
@@ -751,15 +743,12 @@ static int free_object_checks(struct kme
 		goto fail;
 
 	if (!check_valid_pointer(s, page, object)) {
-		printk(KERN_ERR "SLUB: %s slab 0x%p invalid "
-			"object pointer 0x%p\n",
-			s->name, page, object);
+		slab_err(s, page, "Invalid object pointer 0x%p", object);
 		goto fail;
 	}
 
 	if (on_freelist(s, page, object)) {
-		printk(KERN_ERR "SLUB: %s slab 0x%p object "
-			"0x%p already free.\n", s->name, page, object);
+		slab_err(s, page, "Object 0x%p already free", object);
 		goto fail;
 	}
 
@@ -768,24 +757,22 @@ static int free_object_checks(struct kme
 
 	if (unlikely(s != page->slab)) {
 		if (!PageSlab(page))
-			printk(KERN_ERR "slab_free %s size %d: attempt to"
-				"free object(0x%p) outside of slab.\n",
-				s->name, s->size, object);
+			slab_err(s, page, "Attempt to free object(0x%p) "
+				"outside of slab", object);
 		else
-		if (!page->slab)
+		if (!page->slab) {
 			printk(KERN_ERR
-				"slab_free : no slab(NULL) for object 0x%p.\n",
+				"SLUB <none>: no slab for object 0x%p.\n",
 						object);
+			dump_stack();
+		}
 		else
-			printk(KERN_ERR "slab_free %s(%d): object at 0x%p"
-				" belongs to slab %s(%d)\n",
-				s->name, s->size, object,
-				page->slab->name, page->slab->size);
+			slab_err(s, page, "object at 0x%p belongs "
+				"to slab %s", object, page->slab->name);
 		goto fail;
 	}
 	return 1;
 fail:
-	dump_stack();
 	printk(KERN_ERR "@@@ SLUB: %s slab 0x%p object at 0x%p not freed.\n",
 		s->name, page, object);
 	return 0;
_

Patches currently in -mm which might be from clameter@sgi.com are

extend-print_symbol-capability.patch
slab-introduce-krealloc.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
make-page-private-usable-in-compound-pages-v1.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-remove-object-activities-out-of-checking-functions-printk-cleanup-diagnostic-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-slabinfo-remove-hackname.patch
slub-slabinfo-more-statistic-fixes-and-handling-fixes.patch
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
vmstat-use-our-own-timer-events.patch
readahead-state-based-method-aging-accounting.patch
